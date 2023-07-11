---
title: GPS Tracker for Whatever
date: 2023-07-08
---

<div style="background-color: #eee; border: 4px solid #a33; padding: 5px 5px 0px 5px; margin:  15px">

# WARNING; VJOYCAR G28 Tracker is _WIDE OPEN_ on SMS
<i>(2023-07-10)</i>

The VJOYCAR tracker has no "admin mode". **Anyone with your SIM card phone number can configure, control, and locate your device.**

If your SIM card provider allows you to disable SMS doing so can protect your configuration and details -- however, lack of SMS severely reduces the utility of this tracker; I can not recommend it.

</div>

I've been exploring the world of GPS trackers for a little bit and found one that I think really takes the cake; and some that I think are so close but not quite there.

Let's be clear about my purpose: I want some GPS trackers for vehicles -- bikes, cars, trucks, etc. These aren't for pets, people, purses, and such. Thus I have a few things going for me that you may not in other situations. First, there's always a battery to run from. Second, there's usually some indicator of "on"ness (ACC, controller on, etc). I want to know when these are moving when they should not be (ie: I'm not doing the moving).

## Commercial Offerings

Two popular options that I looked into are [Invoxia](https://www.invoxia.com/) and [MoniMoto7](https://monimoto.com/product/tracker-monimoto-7/). Both of these are nicely packaged and the subscription costs, which you're not likely to avoid([^1]), are within reason. I love, love, love the Bluetooth Low Energy tag concept that MoniMoto uses in which, if the tag is nearby, everything is good. If the tag is NOT nearby and the tracker starts moving, it goes into alert mode and you're informed and tracking starts. This is an excellent way to keep a super long battery life.

Here's why I didn't go with those solutions:

![Invoxia Tracker](<2023-07-08 09_31_55-GPS Trackers for vehicles, valuables and pets - Invoxia.png> "It really is quite small")

For Invoxia, it's missing that "authorized person nearby, all is good" alarming/tracking. Instead, it offers geofences you can program to alert you if the tracker is outside the zone. Which, in theory, is nice for things that are supposed to stay at X location, you can then get updates regularly when it's not there. However, for something like a car or bike, it's egregiously annoying to be getting an app alert/text message every N minutes while you are on the bike! Thus you have to turn off the geofence, and now you won't get alerts if somebody nabs your bike from the garage.

![MoniMoto7 Tracker](<2023-07-08 09_33_12-Tracker Monimoto 7 - Monimoto US.png> "Fobs!")

For MiniMoto: it does not hardwire to the vehicle. While this is touted as a feature, to me it's just one more battery hassle. If the device can survive months off two small 1.5v batteries, whatever is in my cars and bikes should provide for years. Instead, I have to hassle with digging the unit out every 6-12 months and replacing highly specific, non-rechargeable batteries? No, no thank you.

**For both:** Each is locked into their esim/networks and cloud-based app. If either of them ever chose to shutdown, raise their rates, or sell your data _(which, let's be honest, they're likely already doing)_ you get zero say in the matter other than creating another piece of ewaste when you throw it away.

## VJOYCAR G28 GPS Tracker

![G28 Tracker](<2023-07-08 08.45.56.jpg> "Very small, but full of features")

I eventually stumbled on the [VJOYCAR G28 GPS Tracker](https://www.alibaba.com/product-detail/4G-Smart-Real-Time-Location-Tracking_1600801761567.html) and here's a laundry list of things I really like about it:

* Supports a _HUGE_ voltage range (9-100v), which makes is super easy to install on any car, truck, and especially easy to directly wire into any electric bike
* Can detect vehicle on/off status through accessory wire
* Can control a relay to turn something on/off on the vehicle
* Supports configuration via SMS
* Uses any compatible LTE sim card
* Can be configured to report to a different tracking server

Now, if you're uncomfortable with or paranoid around purchasing device from China, you can just skip out now. _(Though, if you are paranoid about how your data is being used, nothing here is for you!)_

Getting past that, these little trackers are fantastic. I **am not** using their tracking server, but instead installed [Traccar](https://www.traccar.org/) in my HomeAssistant installation. This allows me to have my own tracking data under my own control.

Update frequency while moving is fantastic, resolution is spot on, and the alarms you can configure trigger extremely well. In my testing these devices report so well that I can tell which side of the street I'm driving down! You can be alerted if the tracker has moved, been tampered with, or if there is a power loss. Alerts are either off or report to the server and, optionally, can directly SMS you.

## Setup of the G28

Setting these up does require some configuration and twiddling. It took some time to figure out all the right SMS commands and such, so here's what I've found.

Some reference material:
- [List of commands the G28 supports](https://docs.google.com/spreadsheets/d/1YEcCr1LKUNWWIl97aG6aPiibnHWOHijJSfZisGDvflI/edit?usp=sharing)
- [Manual PDF](<G28-4G user manual.pdf>)

I'm using [Tello](https://tello.com/) for my SIM card; I selected a `500MB data, 0 minutes` plan for $5/month. Despite having zero minutes, you still get unlimited SMS, so no worries there. In terms of data usage, 500/mo. is more than enough.


### SMS Configuration

Here's the SMS's I needed to send to get this configured nicely:

Sets the "SOS" number (alerts go here):
```text
SOS,A,18008675309#
```

Set the APN for your provider. You'll need to dig that up from them:
```text
APN,wholesale#
```

Set the server your device will report to:
```text
SERVER,1,1.2.3.4,5023,0#
```
_(There is another form of this command, `SERVER,0,...`, but the docs are a bit unclear about the format of the IP address. I found using an IP in the `SERVER,1` form works just fine, though, soooo....)_

**Sidenote:** On the traccar installation, make sure you have the configuration XML include the `<entry key='gt06.port'>5023</entry>` directive to turn on the GT06 protocol and port. For one of my units, despite setting the time zone correctly, I found it was better to rely on the time-of-reporting instead of the time-from-unit reporting. I turned that option on by adding `<entry key='time.override'>serverTime</entry>` and `<entry key='time.protocols'>gt06</entry>` to limit the effect to just the GT06 devices.

Grab the IMEI number for setup in Traccar:
```text
IMEI#
```

Set the device timezone to PST; flavor according to your location:
```text
GMT,w,7,0#
```

### All set for tracking

With that all sorted out, and the device added in my Traccar instance, I started getting data right away. A quick trip around the block showed the tracker working just as expected.

Powering the device, having it detect ACC on/off status, etc are all too situation specific to cover here, but it's not rocket science. Positive to positive, negative to negative and you should be good to go.

## Conclusion

<div style="background-color: #eee; border: 4px solid #a33; padding: 5px 5px 0px 5px; margin:  15px">

# WARNING; VJOYCAR G28 Tracker is _WIDE OPEN_ on SMS
<i>(2023-07-10)</i>

The VJOYCAR tracker has no "admin mode". **Anyone with your SIM card phone number can configure, control, and locate your device.**

If your SIM card provider allows you to disable SMS doing so can protect your configuration and details -- however, lack of SMS severely reduces the utility of this tracker; I can not recommend it.

</div>

If you can surmount the minor technical wall, and aren't afraid to connect a few wires, the G28 is a fantastic option. A much cheaper initial price, competitive ongoing rate (and bring-your-own-card), and a far more configurable unit, the G28 really stands out as an exceptional GPS tracker. I'm happy enough with these units that I went and bought five ([^2]) to deploy across all my vehicles.

[^1]: If you want reliable tracking you **must** use LTE; there are some solutions like LoRA and LoRAWAN, but everything I've read about them appears to imply very low coverage and some highly specific hardware and coding to get it right.

[^2]: Big oof given the fact that I found out they lack the admin mode _after_ the bulk purchase. Poop.