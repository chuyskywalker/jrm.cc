---
title: "Home Cluster (Part I): Motivations"
date: 2016-06-05
---

## AWS -- Too Much

Mid 2015, I undertook moving all my website hosting into my house. Setup a basic server, got a decent ISP connect, added a CDN in front of my sites, and stopped paying AWS > $150/month.

However, back then I had moved it to what was, previously, my media server machine. It was acceptable for video playback _(i3 core (4t), 8gb of ram, and some spinning disks)_ but was clearly was struggling at times with VMWare and several virtual machines sitting on top of it.

I eventually got my hands on some obscenely powerful datacenter-grade hardware, set it all up -- and then got my first power bill. Paying $70/month to run that beastly 2u server just wasn't going to fly.

## Mini Cluster

To work around expensive power costs, and to scratch my own continued learning education, I decided to have a go at creating a mini-cluster. I started putting together a plan for a small cluster of cheap machines, low power, low noise, capable enough to run my websites, *and* I wanted some redundancy.

## First Forray, Pi(e) Time!

When you think, "small efficient computer" you should probably jump right to [Raspberry Pi](https://www.raspberrypi.org/). What that team has accomplished is nothing short of amazing. I bought two different models of these to try them out, but ultimately didn't settle on them as a platform.

While there is a lot of maturity in the RPI platform, and the power/noise factors are amazing, having to constantly deal with software availability and ARM compilation just wasn't  as of hoops I would jump through.

## On Towards X86

Knowing that I wanted to stay pretty mainstream, I came back to the X86 (Intel and AMD) camp. Looking around I generally found that the Intel processors *and relatved components* had a hard time pricing out to less than $500 for a small box. Turning to AMD camp and I found an amazingly cheap, low power, and mid-performance chip call the `AM1`. With 4 cores @ 2ghz chip and sub $50 it's right where I wanted. More importantly, the price point for the components around it a quite low:

Price | Item | Notes
--- | --- | ---
$42 | [AM1&nbsp;Processor](http://www.amazon.com/AMD-AD5350JAHMBOX-Quad-core-Desktop-Processor/dp/B00IOMFAQ0) | Great deal
$10 | [Passive&nbsp;Heatsink](http://www.amazon.com/Arctic-Alpine-Passive-Cooling-ACALP00005A/dp/B00U8PUNH2) | The processors included fan is noisey, and this keeps you plenty cool. It does mean I can't close the mini-case, but I don't mind that too much
$40 | [MSI&nbsp;AM1&nbsp;Motherboard](http://www.amazon.com/MSI-AM1I-Mini-ITX-AMD-Motherboard/dp/B00K4DUY86) | Basic ammenities, no USB3, but overall no major complaints
$52 | [16GB Ram (2x8gb)](http://www.amazon.com/Crucial-Ballistix-PC3-12800-240-Pin-BLS2KIT8G3D1609DS1S00/dp/B006YG9EEW) | Yup, it's ram.
$65 | [Case](http://www.amazon.com/Antec-ISK110-VESA-Mini-ITX-Case/dp/B0064LWISQ) | Includes pico power supply, hence the pricey-ness. Easy to pull out the extra front components (usb/audio) ports to give you a bit more cable routing ease, nice bonus.

_(Naturally, prices fluctuate a bit.)_

Overall, I spent about ~$210 per machine, add in a $25 switch and some cables and I had a small cluster for around $700. _I already had hard drives, SSDs infact, from other builds._

All put together with a bit of wood stain and hung up:

![Cluster](/img/cluster.jpg)

Now I've got three identical machines. I'm ready to start getting my cluster up and running.