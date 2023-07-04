---
title: "TPB - Wiring & Tuning"
date: 2023-07-01
series: [ "The Purple Bike" ]
---


![Controller in box closeup; many wires](<2023-06-30 21.20.11.jpg> "UBOX Controller") 

Here I've wired up the Spintend UBOX controller to both motors; each with a set of hall sensors and a temperature probe inside the motor. All the wires come along the frame and up through the controller box. The side of the controller screws into place, just a few M5 fasteners.

![Ariel view of bike, controller, and computer](<2023-06-30 21.19.59.jpg> "Programming") 

Now that all the bits are connected, it's time to tune. Basic tuning of a VESC is bog-standard, wizard-led, motor detection. However, I often find that the VESC auto-detection is very conservative with amperage, and if you later on turn up the amperage (which you likely should), the lower level motor configuration leads to cogging and grinding noises when riding.

As such, it's almost always useful to re-tune the FOC parameters on the FOC page with a higher duty cycle and higher amps (I) as well.

In addition, this is where I setup the throttle, ranges, and curves for acceleration. Nothing to crazy here; except that since this is an ebike throttle, you do need to use a voltage divider to get the most out of the throttle.

On the VESC, you feed the throttle with 5v and Ground. The throttle then sends back 0.8v -> 4.2v on the signal line depending on the twist position. However, the ADC port on VESCs can only read up to 3.3v -- and while _some_ VESC controllers will tolerate the higher 4.2v top-end, the controller reads everything above 3.3v as 3.3v. This means you lose an enormous amount of throttle twist range to "Wide Open Throttle". A voltage divider on the signal line will pull the voltage proportionally into the 3.3v range.


![Bike propped up against a wall](<2023-07-01 08.35.09.jpg> "All buttoned up")

Here's the bike with some wire management done. It looks a bit "lifted" in the rear, but that flattens out once you sit on the bike; and the suspension has a TON of travel to soak that up. I actually tried a smaller suspension (190mm vs the 220mm pictured here) and it looks a lot better at rest, but when you sit down it gets waaaaay too low. Like, routinely scraping the bottom too low. Given this was designed for 20" *minimum* tires, that I'm getting away with these 14's at all is amazing.
