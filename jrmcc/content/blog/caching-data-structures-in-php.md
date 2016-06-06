---
title: "Caching Data Structures in PHP"
date: 2011-10-15T00:00:00Z
---


In one of my projects I need to create and use several fairly large,
non-changing data structures -- hash tables of string values, array's of
objects, nested object definitions several layers deep, etc. For example,
from my battlefield 2 stats website I have several very large arrays that
describe every award you can get, which look something like this, but repeated
hundrededs of times:

```php
'9' => array(
    'short'     => 'MgySgt',
    'long'      => 'Master Gunnery Sergeant',
    'unlock'    => true,
    'notes'     => '',
    'thisrank'  => '9',
    'nextrank'  => '12',
    'requires'  => array(
        'awards'    => '',
        'rank'      => '7',
        'score'     => '50000',
        'round'     => ''
        )
    ),
```

So the question arises, how do you store this data, load it, and use it?

## First Step: Research

Of course, I found a page on [StackOverflow about php storage](http://stackoverflow.com/questions/804045/preferred-method-to-store-php-arrays-json-encode-vs-serialize).
Perusing the article, you'll see most people break down the caching theory
into three options:

 1. json_encode the data into a file, load it, json_decode
 2. serialize the data into a file, load it, unserialize
 3. var_export the data into a file, require() it

One responder (who should have more votes, if it was up to me) went pretty far
and did a serious amount of [benchmarking for the php array storage issue](http://techblog.procurios.nl/k/618/news/view/34972/14863/Cache-a-large-array-JSON-serialize-or-var_export.html).

I won't go into a lot of details on each method as the linked articles cover
them each pretty well, but I want to open two other options and redo the
benchmarks because something smelled fishy when JSON has been coming out
the winner...

## The Purported Winner, JSON

JSON certainly has some advantages: the cached file sizes are smaller
(especially when you saving a numericly indexed array), it is usually faster
to write, and if you have a highly JS oriented site architecture being able
to make HTTP requests for your JSON data files can be quite useful.

What irked me is that, for my purposes, none of those things really truly
matter. File size isn't a real concern because my largest cached file weighs
in at about 50KB. I won't be distributing the data to JS applications, and
writes only happens once.

So, what does matter? *Read speed.* And with that in mind, what I found out is
that JSON can't hold a candle to the other two methods.

## Cons of var_export

I'd first like to rebut the cons list that var_export was given on Procurious.nl:

> 1. Needs PHP wrapper code.
> 2. Can not encode Objects of classes missing the __set_state method.
> 2. When using an opcode cache your cache file will be stored in the opcode
>    cache. If you do not need a persistant cache this is useless, most opcode
>    caches support storing values in the shared memory. If you don't mind
>    storing the cache in memory, use the shared memory without writing the
>    cache to disk first.
> 4. Another disadvantage is that your stored file has to be valid PHP.
>    If it contains a parse error (which could happen when your script crashes
>    while writing the cache) your application will not work anymore.


 1. Wrapper code exists for your other caching methods as well, it's just placed
    inside the loading function instead of in the cached file itself.
 2. If you encoding objects created with classes, JSON is going to fail worse.
    The more likely scenario, however, is that you are just using “dumb” stdClass
    objects, in which case it is super easy to overcome the
    `stdClass::__set_state()` blunder. `str_replace('stdClass::__set_state(', '(object)', var_export($data,true))`
     done and fixed.
 3. The point of pushing the cache data into a file is for longevity. Your APC
    cache will not survive a server restart, a cached file will. Additionally,
    I have too much data to reliably cache in memory[^1]; using the opcache
    provides the built in “most used gets kept around” optimization.
 4. This point could be made about <em>ANY</em> of these methods. A broken
    serialized file or cut-in-half JSON object is just as likely to cause errors.

## Don't Discount The Opcode Cache

I find it odd that the opcode cache was so readily dismissed; it's a surefire
way to speed up ANY of these operations. To that point, let's introduce two
other caching methods that an that can make unserialize and json_decode even
faster. How? Just wrap the data up inside a PHP file!

```php
// json_data_cache.php:
<?php return json_decode('{"your": "json", "goes": "here"}');
```

The same treatement can be applied to unserialize. By introducing this boiler
plate routine into your serialized/json_encode'ed data you can take advantage
of the opcode cache. When you'll see later is that even if you decide to go
with JSON, doing this will lead to a significant speed up.

## Test Script

Here you will find the test script for [benchmarking php caching with json, serialize, and var_export](https://bitbucket.org/chuyskywalker/php-file-cache-test/overview).
A quick overview of how this is intended to be used:

 1. Install to a webserver (apache, lighttpd, etc) that has PHP with
    APC installed.
 2. Call script from browser as `test.php?m=gen` This step will create all the
    cached data files. These files <strong>should be</strong> the same as the
    data files I (or any one else) would use to test as long as the `$setsize`
     value is the same.
 3. Call the sript again as `test.php?m=test` This will run the load & parse
    tests on each cache file created.

The data generated by this script is fairly comprehesive. It will test arrays
of strings, ints, and objects. The arrays are indexed by numeric and string
keys. Additionally, it will test two object collections. In all cases, the
script creates a Large, Medium, and Small set of data based on the `$setsize`
value (100% size, 50% and 10%).

When you are running the test, I highly recommend you run with the same
`$setsize` and `$itterations` value with APC off, APC enabled (apc.stat=1), and
finally APC enabled(apc.stat=0) restarting your webserver between each
execution. <code>apc.stat</code> instructs APC to check the file for
modifications to see if it should be recompiled before using the opcache
variant. Turning this off eeks a bit of performance out of APC at the cost of
needing to manually clear the APC cache if you update files. The testing,
however, shows that you may or may not think this is valuable — the performance
difference is very, very minimal.

Also, for the APC enabled test runs, perform each run twice to ensure that your
APC cache is primed.

## Results, Man!

I ran this test on a Fedora 15 virtual box on top of a Win7 install on a Corei7
machine with the settings `$setsize=2500` and `$itterations=200`. The webserver
was Apache/2.2.21 with PHP 5.3.8 with APC 3.1.9.

Here's a graph comparing the best runs of each decoding situation:

<img src="/img//php-data-cache-speed-baseline.png" alt="" width="743" height="735">

And an [ODS (Open Office Calc) file of the raw results](/other/php-data-cache-speed.ods)
and a few other graphs.

What you are looking at here is the decoding of each type of data structure by
method, as compared to the fastest method, which is `var_export with APC`.

## Take aways:

 1. var_export with APC caching (apc.stat on <em>or</em> off) is about 270%
    faster than anything else
 2. If you want to keep your data in JSON format, keep it in the json.php data
    structure -- the opcode cache makes this method an average of 150% faster
    than loading JSON from a file and even if you don't have an opcache you'll
    not lose any performance anyway
 3. The jump in performance between var_export with and without opcode cacheing
    is as dramatic as I had expected
 4. <strong>Important</strong> You <em>must</em> know your deployment
    environment -- <code>var_export</code> <strong>without opcode caching</strong>
    is by far and away the very slowest method

If you have any suggestions, feedback, or wish to contest the results, feel
free to get in touch or submit a patch.

 [^1] If you have a small enough data cache, you should be reading up on [Redis](http://redis.io/), and this whole discussion becomes pointless very quickly.
