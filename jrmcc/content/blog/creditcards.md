---
title: "Creditcards: Inherently Flawed And What To Do About It"
date: 2014-01-01T00:00:00Z
---

It has recently been revealed that malware, placed inside the P.O.S. system
at Targets all over the U.S., collected well over 40 **million** individual
creditcard details during the last two months of 2013.

This breach got me thinking about creditcards and whether they're a secure
enough form of currency transfer. To sum up the answer: no, not even close.

## Creditcards' Inherent Insecurity

In computer security one of the attacks you must guard against is the
[Replay Attack](http://en.wikipedia.org/wiki/Replay_attack). To summarize,
if a "bad guy" can intercept a request to your server and then "replay it"
themselves (this impersonating another user), they can begin to do all
sorts of bad things. The wikipedia article provides a simple but
compelling example:

> Suppose Alice wants to prove her identity to Bob. Bob requests her password as
> proof of identity, which Alice dutifully provides; meanwhile, Mallory is
> eavesdropping on the conversation and keeps the password. After the
> interchange is over, Mallory (posing as Alice) connects to Bob; when asked for
> a proof of identity, Mallory sends Alice's password, which Bob accepts.

Now exchange "password" with "creditcard details" and you begin to realize that
this form of payment is extremely insecure. If the bad guy, Mallory, can watch
you enter your creditcard details into your Amazon account, what is to stop him
from taking those and entering them anywhere else? Honestly, not much.

## Creditcard Security Measures

They are:

 1. Signatures on cards
 2. ID checks by register agents
 3. Transaction Monitoring

These are awful.

 1. When was the last time a store clerk was qualified to compare signatures
    with any reasonable accuracy? Shoot, most places your card is swiped and
    *that's it*. (Watch the line at Starbucks any day.)
 2. ID checks are weak in the sense that they're almost never done -- even
    when people go out of their way to write "SEE ID" on the back of the card.
 2. Finally, monitoring your transactions for purchases you didn't make is not
    only tedious, but it's also *reactionary*. By the time you notice that
    someone has stolen your card details and is spending your money, it's
    too late.

The fact is, there is very little out there that prevents your cards from being
used by anyone for nearly anything once the details have been stolen. This,
more than anything else, is why creditcard companies don't hold you accountable
for charges you didn't make -- because they know that their payment system
is unerringly weak.

## Alternatives

Cash. No, really. Cash can't be "duplicated" and replayed like your creditcard
details. Not only that, but [you tend to spend less with cash in hand](http://www.dailymail.co.uk/news/article-1055334/Scientists-advice-stop-overspending-Carry-cash-ditch-credit-debit-cards.html)
(and [even less if you carry large bills instead](http://business.time.com/2012/01/26/why-bill-size-really-does-matter/).)

What I would really like to see, however, is Public Key Infrastructure put into
place for payment systems.

## PKI Payments

I'm not going to get into a lot of depth about what PKI is except to highlight
the parts relevant for what I'm thinking. With PKI you create a Public Key and a
Private Key. You hold on to the private key and never give it out. You spread
the public key to your creditcard company and to their merchant account payment
processing partners. Through some mathematical magic, you can combine your private
key with, say, a purchase request and the public key can then validate that your
private key was used to sign the purchase. However, no one can use the public key
to do the same. (A document signed with a public key will not validate with the
same public key.) Additionally, if any of the details for the purchase request
are changed, or the signature is tampered with, it's readily identifiable.

With a system like this, replay attacks are impossible because you can't "replay"
the same data again. For starters, the thief would be making the same purchase
(not very useful) and secondarily, the unique signature could be logged by the
merchant as "already paid" and rejected immediately (further, flagged as
potential fraud).

The dilemma with a system like this is that it's fairly complex. Complexity,
especially with PKI, can be [tricky to get right](https://www.schneier.com/paper-pki-ft.txt).

That doesn't mean we shouldn't pursue it though. A smartcard which could check
your fingerprint, accept a pin code, or monitor some other biometric to
authorize it to sign a purchase would be fairly convenient, but avoid the
problem of creditcard details leaking all over the place. It would be immensely
comforting to know that no matter how sketchy that website is, I can guarantee
that the purchase I made isn't going to lead to different charges being racked
up on my account.

There is work being done [in this area](http://www.smartcardalliance.org/pages/smart-cards-faq),
but I have yet to see any major vendors really take up the call to arms -- and
who can blame them? Creditcards "work" for all their flaws and retooling an
entire business chain and norms is no small feat. Consider, of course, that
creditcards have really only been around for 60 years or so, it's not hard to
imagine that in 60 years from now they'll look radically different. And,
perhaps, a bit more secure.

**May 5th, 2014**: Target announced they are [outfitting themselves with chip-and-pin](http://www.nytimes.com/2014/04/30/business/after-data-breach-target-replaces-its-head-of-technology.html)
 (a form of PKI-like protection).