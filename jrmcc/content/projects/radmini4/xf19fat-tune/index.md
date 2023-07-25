---
title: "MXUS XF19FAT Frankenrunner/Phaserunner Motor Tune"
date: 2023-07-25
---

In my on-going saga to install an upgraded motor, I've finally hit a combo that works. I've settled on the Frankenrunner + MXUS XF19FAT motor... though, it wasn't easy. The motor auto-detected fine (or so I though) and would run, but if I pushed the speed to about 20mph, it would cut out and give me an "Instantaneous Phase Overcurrent Fault".

After spending significant time trying to tweak the PLL Bandwidth and PLL Damping values, which is a righteous pain in the ass given you have to ride back to a laptop every time, I was at my wits end. No combinations large or small or in between would get this motor to run smoothly and reliably.

I'm lucky enough to have some spare VESC controllers around, and on a hunch, I decided to run the auto-tune from those and see what FOC parameters it would discover. Boy am I glad I swung for the fences on that one. The `Kp` and `Ki` values were WILDLY different with VESC **and** it revealed a very different `Rs` and `Ls` as well! While I doubt the FOC algorithm the two units share is the same, I had nothing to lose, so I pushed the VESC values into the Frankenrunner and...it works **great!**

In order to, perhaps, save someone the hassle in the future, I've exported my motor tune for the XF19-FAT and you can grab it here both as just the 'motor' values and then as the 'all' export.

* [MXUS XF19FAT Phaserunner / Frankenrunner Motor-Only Tune](radmini-mxusxf19-franken-tuned-vesc-motor.xml)
* [MXUS XF19FAT Phaserunner / Frankenrunner All Tune](radmini-mxusxf19-franken-tuned-vesc-all.xml) 

Hope this helps somebody else eventually.
