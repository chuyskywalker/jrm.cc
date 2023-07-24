---
title: "Speed Restriction Remote"
date: 2023-07-24
---

The Talaria XXX ships configured as a, more-or-less, street legal mode for most locations. Specifically, in Eco it will cap at 20mph and in Sport 28mph. With the eventual addition of an operable peddle kit, this will take it from a semi-gray area to a legitimate ebike.

You can, however, cut a brown wire inside the wire harness and release the full potential of the bike. After that mod, Eco mode will take you up to 30mph and sport can get close to 50mph. This takes the bike well into off-road private use only territory, however.

You can, however, have the best of both worlds, both restricted and unrestricted modes.

## Why Toggle?

* Perhaps you wish to let someone new ride the bike, putting it into the restricted eco mode makes it a lot safer
* You wish to have the bike always startup in the restricted mode for safety reasons
* You install a pedal kit and wish to use the bike in bike areas more considerately

I'm sure you can come up with a few others, but these are some of the large ones. This setup isn't terribly uncommon either -- simply look to many popular brands of ebikes which come with "Sport" or "Race" modes which push well into the >35mph speeds.

## Wiring Guide

First, go buy a cheap RF relay toggle. I picked up this "[DieseRC 433Mhx Remote](https://www.amazon.com/dp/B098X9GFGB)" for about $15. Now, open up the side compartment on the XXX and find this plug:

![3 wire plug](<2023-07-24 14.09.27.jpg> "Voltage readout") 

The connector will have an empty blank on the end; if you have a compatible wiring kit, by all means make up a proper plug. Otherwise, buy some wire taps and pull V+ from the black wire and V- from the green wire.

![close up of relay box wired up](<2023-07-24 14.22.26.jpg> "Wiring connected")

On the relay, you'll want to connect V+ and V- to the same on the plug. This will give the relay power to operate while the bike is powered up. _(The relay, while held, only consumes ~0.5w -- no worries on that.)_ 

Splice the brown wire in to the COM and NC terminals. It doesn't matter which side of the wire goes into which. This setup will cause the brown wire to be "connected" (Normally Closed) by default. When the bike turns on, it will always be in restricted mode.

_(Note, in my picture, I extended the wires with whatever I had laying around, hence the red/black for the NC/COM loop and the dual-black for the V+/V-.)_

## In Action Video

With that all wired up and put back in (though, test both remotes if you bought two before closing it up), you can now toggle the speed restrictor whenever the bike is on and at 0mph.

Toggling the relay while the bike is in motion will do nothing until the bike comes to a complete stop, at which point the new status (restricted or not) will take effect.

{{< youtube iflocO13hKs >}}

Ride responsibly.