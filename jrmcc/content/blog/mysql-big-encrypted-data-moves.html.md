---
title: "Sharding Large, Encrypted MySQL Tables"
date: 2013-12-30T00:00:00Z
---

Alright, let's say you have a pretty big database. I'm talking, like, 100GB
for a medium sized table here. (Some tables in excess of 3TB!)

Now let's say that you're going to be sharding this dataset. I'm not going to
cover sharding itself in this post, but the concept is pretty simple: we want
to split the data out across multiple servers in an easy to look up fashion. In
this scenario, we're going to split the data up 1024 ways and do the lookup by
`modulo` hash of `userId`.

You're now faced with a multipart problem: How do you export all this data,
split it up for all the shards, and then load it where it is supposed to go?

## Data Export

Typically, you're going to see the advice to use `mysqldump`. Don't. It's not
going to work. For starters, there can be a lot of issues with it timing out,
making sure it doesn't lock things it shouldn't, and some other problems.
Primarily, however, it's default export is SQL statements -- and SQL statements,
while they can be fast to load, they are *not* the fastest way to load data.

Instead, you should use the `SELECT INTO OUTFILE` command. It will look
something like this:

{{< highlight sql >}}
SELECT
userId, username, hashedPassword, secretData
INTO OUTFILE '/path/to/users.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM schema.users;
{{< /highlight >}}

This will create a standard 'ol CSV file. However, there's a problem here. That
`secretData` column is a binary field with encrypted (or any kind of binary)
data. Binary data can contain any set of characters, including problem
characters like `\n` or `"` which will ruin the format of the CSV file and lead
to lost data. Not to mention that most systems expect CSVs to be ascii
plaintext.

So, how do you export this data in a sane CSV? Turns out it's pretty easy,
just `hex()` the binary values:

{{< highlight sql >}}
SELECT
userId, username, hashedPassword, hex(secretData)
INTO OUTFILE '/path/to/users.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM schema.users;
{{< /highlight >}}

This will convert the binary data into its hexidecimal representation which,
in turn, creates a perfectly acceptable CSV file.

## Data Splitting

Now that we have every row exported, we need to split the data up acording to
which shard the row of data will ultimately reside in. So, in our case, if a
row belongs to `userId=584685` that means `584685 % 1024 = 1005` the record
should go to shard 1005 (of 1024 total). We need to evaluate every record in
the CSV and put that line into a different CSV which contains records for
the given shard.

I toiled on this for several days, mostly trying to add multi-threading to the
process. Ultimately, however, diskio is the limiting factor and your disk will
never out-perform your CPU. (Maybe you could put this file into `/tmpfs` and
multi-thread it, but it's really not worth it.)

So, in order to read the file, parse it, and dump each record into the
appropriate CSV file we turn to the incomprehensible `awk` linux tool:

{{< highlight bash >}}
awk -F, '{x=sprintf("%.4d", $1%1024); print > x".csv" }'
{{< /highlight >}}

In short, what this does is pull the first column of data (split by commas),
modulo against 1024, set that to the variable `x` and then appends the whole
line to `x.csv`. The `sprintf` is there so we get `0090.csv` instead of `90.csv`
which is a bit nicer when listing the files.

Now, `awk` will happily run this until it finishes, but as it can take a very
long time to run, I highly recommend you install the `pv` utility and run the
command like this to get visual progress bar and ETA:

{{< highlight bash >}}
pv /path/to/users.csv | awk -F, '{x=sprintf("%.4d", $1%1024); print > x".csv" }'
{{< /highlight >}}

Finally, run these commands in a `screen` session so if you lose your SSH
connection all is not lost.

## Loading The Data

Great, you've got the data all split out, but if you do a normal `LOAD DATA INFILE`
that `hex()`d data isn't that you actually want in the column. Fortuneately,
`LOAD DATA INFILE` has a trick which lets us get the data imported in the
correct format:

{{< highlight sql >}}
LOAD DATA LOCAL INFILE '/path/to/shard.csv'
REPLACE INTO TABLE schema.users
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
userId, username, hashedPassword, @secretData
SET secretData = unhex(@secretData);
{{< /highlight >}}

This is an interesting extra little feature of `LOAD DATA` wherein you can
specify each portion of the CSV to go into a column or into a variable. You
place the `hex()`d data into the `@secretData` variable and then use the `SET`
portion of the command to `unhex()` the value into the `secretData` column,
thus restoring your binary data.

## Loading Each Shard

Getting these CSV's loaded into each shard, reader, is an exercise I leave in
your hands. I will say some loops, shell commands, and `LOAD DATA LOCAL INFILE`
are your friend.

## Result

The previous data migration system was a program that `SELECT`ed rows on one
connection from the source, then used a separate connection to the target
to insert them. This method, for the 100GB table had an ETA of **over 120 days**.
The dump/split/load method worked in a grand total of **12 hours.** Most of that
time (~10.5 hours) was spent on the splitting of the file itself. The dump took
40 minutes and the (parallel) load another 45.