---
title: "Repairing a BLACK DECKER Handheld Vacuum"
date: 2021-03-31T00:00:00Z
---

About three years ago, I bought a [BLACK+DECKER 20V Max Handheld Vacuum, Cordless, Grey BDH2000PL](https://www.amazon.com/gp/product/B00IOEFBKS) and it's been a really nice little vacuum for small pickups. A few months ago, sadly, it would start up fine, but you'd hear the motor spin down after about a minute, and then 20 seconds later it would putter to a stop. The battery was on the outs.

I've also recently been bulking up on battery building experience for PEVs (Personal Electric Vehicles) and figured, _"how hard could it be to fix this?"_

As it turns out -- not super hard. Here's the steps I went through to do so:

## Disassembly

Take the vacuum apart. Remove two screws holding the cover on. Lift up lightly and then slide towards the rear to escape some plastic tab detents. Be careful here as if you break these there is no fix, you'll end up with a loose cover you'll have to, I suppose, tape back on later.

Slide out the battery pack and disconnect it from the main body. I had to snip the cable connector retainer clips a bit to get mine apart. The plastic pack is held together with some simple snaps, just lever them up to pull the top off.

Here's where you'll end up, and where most folks give up because, let's be honest, a soldering iron let along a battery welder, is pretty rare to have:

![](</img/vacuum-repair/2021-03-21 20.31.47.jpg>)

![](</img/vacuum-repair/2021-03-21 20.31.52.jpg>)

However, if you'll be carrying on, desolder the wires from the tabs and then rip all the tabs off. You don't need to worry about being too careful here since the tabs and batteries are all garbage.

Pull out the old batteries and dispose of them safely.

![](</img/vacuum-repair/2021-03-21 20.52.11.jpg>)

## New Cells and Assembly

Now, time to get some new cells -- the original cells were 1500mAh @ 10A output capability. You only need to meet or exceed the 10A output, and other than that get the highest mAh capacity you can in 18650. Battery stocks were pretty low when I was buying, so I ended up with Samsung 25R (2500mAh @ 20A), but would have preferred Samsung 36G (3600mAh 10A) cells for longer battery life. In either case, though, the replacements last longer than the originals by a pretty decent margin.

Add some extra cell protection on the postive ends:

![](</img/vacuum-repair/2021-03-31 17.25.47.jpg>)
_(Ok, I only had cell protectors for 21700 cells, so they are a bit large)_

Insert them all into the holders in the same directionality as originally shown. I found that it was easier to insert all of them negative first and push it through.

![](</img/vacuum-repair/2021-03-31 17.27.16.jpg>)

In this next picture, I've spot welded some nickle strip between the cells in the same fashion as the battery was originally setup. If you do not have a spot welder, you could attempt to solder wire or nickle strip here, but keep in mind it's less safe and potentially will shorten the lifespan of your cells to heat them up in that fashion. You also need to worry about getting the lid back on, as it doesn't have a ton of side clearance.

![](</img/vacuum-repair/2021-03-31 17.39.25.jpg>)

Once done, put a bit of solder onto the nickle strip between cells and and the neg+pos ends and start solder the balance/current wires back on. You should end up with something like this:

![](</img/vacuum-repair/2021-03-31 17.46.27.jpg>)

![](</img/vacuum-repair/2021-03-31 17.46.38.jpg>)

Finally, once you are done, it is time for the traditional _"first charge on the concrete where a battery fire won't spread."_ 

![](<img/vacuum-repair/2021-03-31 17.53.30.jpg>)

This should give the vacuum several more years of life and I can likely just do this again and again till the motor gives out -- which is also probably even easier to replace.
