---
title: "Home Cluster -- Motivations"
date: 2016-06-05
---

Sometime last year, I moved all my website hosting into my house. Got a decent line, added a CDN in front of things, and stopped paying AWS > $150/month.

However, back then I had moved it to what was, previously, my media server machine. It was acceptable for that -- i3 core, 8gb of ram, and some spinning disks. It did...alright with VMWare on top of it, but clearly was struggling at times.

A few months back I decided to have a go at creating my own little cluster. I'd previously hosted most of my sites at home on a single server. Little thing, i3 core with 8gb of ram. Worked ok, but was a constant failure risk. Inherieted a REALLY nice datacenter rackmount beast, but since it costs $50+/month in power, I can't really use that -- plus it sounds like a jet engine 24/7. So I started putting together a plan for a small cluster of cheap machines, low power, low noise, capable enough to run my websites, *and* I wanted some redundancy.

## First Forray

When you think, "small efficient computer" you should probably jump right to Raspberry Pi. What that team has accomplished is nothing short of amazing. I bought two different models of these to try them out, but ultimately didn't settle on them as a platform. While there is a lot of maturity in the RPI platform, and the power/noise factors are amazing, having to constantly deal with software availability and ARM compilation just wasn't something I wanted to jump through hoops for.

## On Towards X86

Knowing that I wanted to stay pretty main stream, I came back to the X86 (Intel and AMD) camp. Turns out AMD has this amazingly cheap, low power, and mid-performance chip call the `AM1`. It's a 4 core, 2ghz chip and it's fantastic for the price. So I bought up 3 of these, some tiny motherboards, 7" square cases, and scrounged a few hard drives together and built these three systems:

[ image here later ]

Now'd I've got three identical machines. I'm ready to start getting my cluster up and running.
