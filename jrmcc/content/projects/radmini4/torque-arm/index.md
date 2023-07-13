---
title: "Clamping Torque Arm"
date: 2023-07-12
---

I'm having a devil of a time getting a working motor combo for this build ([^1]) and one of the options is this big direct drive hub motor. It's statorade cooled and has hubsinks so could take TONS of power...but it's got a problem: this beefcake motor uses an **M16** axle. All of my good (Grin) torque arms are only good up to M14. I can't skip a torque arm either, it's an absolute **MUST** for the amount of power I plan to send through this thing. It's even more critical when you, as I plan to do, use regen.

So, I sat down today and modeled up what I'd need!

![3d model view](<2023-07-12 20_40_53-Autodesk Fusion 360.png> "The Model In Question")

I worked off some pictures I took of the bike; attempting to get it as "flat" as possible. This...didn't work so great. So I ~~stole~~ borrowed some crayons from the kids and created a [frottage](https://www.allaboutdrawings.com/frottage.html) of the dropout. I scanned this into the computer and used that as a much more accurate starting point.

Even with that, it took five attempts before I got all the bolt hole locations correct:

![Multiple 3d printing build plates](<2023-07-12 20_42_28-Untitled.png> "All the build plates")

![Several prototypes sitting on the garage floor](<2023-07-12 19.17.13.jpg> "The first four attempts")

Finally, though, I had one in which all the bolt holes lined up and everything went together smoothly.

![The working piece bolted on](<2023-07-12 19.27.49.jpg> "Success!")

This design is kind of special... First, there is a small plate which nestles up against the flat of the motor axle. Second, two M5 bolts thread in from the side push that plate against the axle. This action clamps the motor axle and prevents *any* rocking motion. Bolt the arm to the bike and you've got a rock solid, ready-for-regen-and-high-power mount.

{{< youtube bScvFMkszu0 >}}

Up till now, everything is 3d printed which couldn't even survive a 100w motor, let alone this monster. Instead, the design is exported as DXF and I've made an order at [sendcutsent](https://sendcutsend.com) to get this made out of 304 stainless steel. They mostly do laster cut, 2d work, so the side holes are something I will drill and tap when the cut pieces arrive.

I'm excited to try this out!

[^1]: I have four, _FOUR_ motor options (RadMiniStock, [MXUS XF19FAT](../mxus-motor/), Bafang G062, and a DD hub) -- and none of them are ideal. 

      1. The RadMini stock is just not a strong motor, can't really push it, and the top speed is very low compared to the rest. To its credit, this is the only motor that _does_ work correctly; just not as powerful or fast as I'd like.
      2. The MXUS doesn't want to play nice with the phaserunner (but works great with a frankenrunner, wtf). 
      3. The bafang's freehub cassette is causing some massive chain slap in the smallest cogs. 
      4. The DD can't be mounted because, as per this page, I need a gosh-darned torque arm!
