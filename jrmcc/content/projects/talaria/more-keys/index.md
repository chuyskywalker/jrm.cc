---
title: "Programming Additional RFID Keys to the Talaria XXX"
date: 2023-08-09
---

The manual talks about this, but it's a little rough to understand so I wanted to clear it up a bit.

The Talaria XXX unlocks using an RFID key. The bike comes with two such RFID keys. Each of these keys are registered on the RFID reader as "Admin Keys". You can use these keys to program **more keys** on to the bike.

* Turn the bike on
* Hold one of the admin keys on the reader, do not remove it
* The normal bike activate tones will go
* After 5 seconds, there will be 5 rising beeps
  * _(If you hold it longer still, I believe you'll hear 5 descending notes indicating that you've left "add keys" mode)_
* Remove the admin key
* Place the new RFID key on the reader, it will make a lot of tones
* Remove the new RFID key
* Turn off the bike

After that, the new "non-admin" key will work for turning the bike on-and-off, but will NOT be able to activate the "add more keys" mode.

Here's a quick video showing this in action:

{{< youtube sd_Fpt9MD7c >}}

I used some RFID fobs I had from [this kit on Amazon](https://www.amazon.com/gp/product/B07VLDSYRW), so I'm not 100% sure what kind they are as the listing is a little vague.

You do not need to, and frankly, should not "clone" the Admin keys. In fact, it's in your best interest to follow these steps, make a few "secondary" keys and put the admin keys in a safe, stored away place. This way if you lose a key while out, you can easily replace it by just scanning in more keys.

_(One thing I do not yet know is how many extra keys can be stored in the on-board reader. Given how small the RFID id's are, however, I wouldn't be surprised if it's **a lot**.)_