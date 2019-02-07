---
title: "HexBox - A Simple CNC Box"
date: 2018-02-06T00:00:00Z
---

Over the weekend I worked on, designed, and utterly failed to properly print a heart shaped box on my Shapeoko XL machine.

It was, naturally, all my fault. First, I hadn't kept up with cleaning the machine, so it got gunked up and caused a Z skip which dug into the piece very deeply, ruining it. Secondly, I screwed up the settings in Fusion 360 which caused the lid to not be properly thinned out, so the two halves would not mate correctly.

I decided I'd taken on a bit much and went a bit simpler, thus the **Hex Box**.

---

The Hexbox is a simple hexagon shape, with an interior lip that allows the top to sit against it.

![Fusion 360 sketch diagram of the hexbox](/hexbox/hexbox-design.png)

The outter line is the outter most edge of both the top and bottom.

The inner line is where the bottom lip will rise up (the width going to the most inner line.)

Imporantly, the concave edges on the lip and lid interior are _not_ hard edges like the outside of the hexagon. A router bit, which spins, can not make sharp interior edges.

It's a bit easier to see what this translates to in the render:

![Fusion 360 rendering of the hexbox top and bottom](/hexbox/hexbox-render.png)

Once I had the model for lid and base all sorted out, I went through the Fusion 360 CAM process and exported the GCODE for my Shapeoko. Head out to the garage, get a piece of pine tossed in the clamps, zero it all up, and press play. About 10 minutes later, and then 20 minutes of sanding, I've got a box that fits!

![The finished box sitting on my desk in two halves](/hexbox/real.jpg)

---

If you'd like, the Fusion model and GCode can both be downloaded here:

- [Fusion F3D](/hexbox/hexbox-v3.f3d)
- [Shapeoko GCode](/hexbox/hexbox.nc)
