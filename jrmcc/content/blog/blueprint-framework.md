---
title: "BluePrint, A CSS \"Framework\" a.k.a. Tables 2.0"
date: 2007-08-05T00:00:00Z
---

<blockquote>
<a href="http://www.blueprintcss.org/">BluePrint</a><br><br>
Blueprint is a <span class="caps">CSS </span>framework, which aims to cut down on your <span class="caps">CSS </span>development time. It gives you a solid <span class="caps">CSS </span>foundation to build your project on top of, with an easy-to-use grid, sensible typography, and even a stylesheet for printing.
</blockquote>

<p>On the surface, this could save you some time and work -- that is, until you realize what a <strong>bad idea</strong> it is. </p>

<p>After you get past the basic "oh, neato" link hovering effects of <span class="caps">CSS, </span>you learn that its true power (and purpose) lies in its ability to <em>separate the content and design layer</em>. This "framework" undoes all of that careful crafting and smashes them right back together. Let me illustrate:</p>

<blockquote>You have a 300 page website. Each page is a two column layout. You set it up with blueprint, <em>span-4</em>'s, <em>rights</em>, and all those layout classes and get it worked out just right. Cool. 3 months later, you need to switch the column positions and change the sizes. Uh oh! Better get your find-n-replace skills out of the cupboard because it's now time to get find all those classes that define the width and floats and change them around. You end up editing 300 files and hating life. Nice.</blockquote>

<p>How about, instead, you do what <span class="caps">CSS </span>is <span class="caps">SUPPOSED </span>to do and title those two columns for their <span class="caps">CONTENT </span>and not their <span class="caps">PRESENTATION.</span> Then you can edit a single <span class="caps">CSS </span>file, target the content layer, and change presentation quickly. Entire site change: 5 minutes. Hair saved: Entire scalp.</p>

<p>I will commend the Blueprint author for putting so much work into it -- this tool will certainly allow you to quickly setup a site, but it comes at the price of <em>completely obliterating the entire point of <span class="caps">CSS</span></em> for which <strong>I could never recommend this tool</strong>.</p>

<hr/>

<p><strong>2013 Update</strong><br/>A lot has happened in the last 6 years of web design, but this kind of CSS framework is still an awful idea. Unfortuneately, the concept has gained extremely wide spread popularity thanks to Bootstrap, another front-end framework pretty much just like Blueprint. There is some glimers of hope out there, and so I suggest you checkout, instead, <a href="http://semantic.gs/">a semantic grid system</a>. Combine the framework goodness, but keep the proper separation!</p>