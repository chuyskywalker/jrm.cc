---
title: "PHP: AES Mcrypt & OpenSSL"
date: 2014-05-11T16:00:00Z
---

At some point you may find yourself dealing with personal or sensitive information: names, addresses, creditcard information, etc. In situations like this, you *must* use encryption and the current "gold standard" of encryption is AES. I want to talk a bit about what AES is, what it is not, and how you should apply it in PHP.

## AES

First off, let's clear up a common misconception. AES, or [Advanced Encryption Standard][aes] is not a cipher. Instead, AES is an agreed upon set of cryptographic rules which have been vetted to be secure. In brief, these are the rules for AES:

1. Cipher: [Rijndael cipher][rijndael]
2. Blocksize: 16 bytes (128 bits)
3. Key size: 16, 24, 32 bytes (128, 192, 256 bits respectively)

After that there are two choices left, but they are generally decided upon between the parties involved in sharing the data. You must decide upon a "padding" and "mode":

**Padding** is the method by which you expand your data to fit into exact the 16 byte blocks that AES requires. For example, if your data is 14 bytes long, you must pad the extra 2 bytes with something before encrypting. The reason you have to agree on the method is because you'll want to remove those extra bytes correctly after decryption. There are [a number of different padding methods][padding-methods], but the most common and sure-fire is PKCS#7.

**Mode** is manner in which the cipher is applied to each block of plaintext data. As an example, the very naive ECB mode takes your key, a block of data and smashes them together -- a process then repeated with each block. The problem with ECB is that doing this leads to visible patterns in the encoded content ([see the image here][ecbtux]). Therefore, you are strongly advised to use anything but ECB. The most common implementation you'll find for mode is CBC. **C**ipher**B**lock**C**haining also operates one block to the next, but utilizes the output from the previous block in the next block's encryption so you get (in essence) `key + lastblock + currentblock = ciphertext`. The IV (initialization vector), by the way is that "lastblock" for the first iteration.

One last note about modes: more advanced modes like CFB, OFB, CTR are streaming cipher modes which do not *technically* require a fixed block size. However, using them without padding your data would make your encryption pattern not fit into "AES" spec.

## PHP Code

There are a number of possible choices for the padding and block cipher, however I'm going to stick to the most common variant, PCKS#7 and [CBC][cbc]. I'm choosing these because of their popularity, but also because OpenSSL supports this combo. (OpenSSL, for example, does not support AES using any streaming block mode ciphers.)

If you search for "PHP AES" you'll find a lot of answers and, true to the PHP community, a good deal of them are old, bad, and sometimes plain wrong. I've seen several instances where Rinjdael\_256 or 192 was used which is invalid because it uses the wrong block size.

One of the most common mistakes you'll see in AES PHP code is a lack of explicit padding. Mcrypt will catch that your data is not padded and will do so, silently, with ZERO fill padding. You don't want ZERO fill padding because it can cause problems when removed for binary data which often contains null bytes as valid portions of the data.

So, to put my money where my mouth is, I've tossed in my own code:

 \- https://github.com/chuyskywalker/phpaes

What you will find here are several classes and interfaces for implementing AES 128/192/256 + PKCS#7 + CBC.

### Testing

The code comes with a full PHPUnit test suite, and also some CLI based scripts for more hack-and-explore type testing.

 * `examples/compat.php`: Validate that the OpenSSL and Mcrypt variants are producing the same ciphertext/decodedtext values.
 * `examples/aes-cbc-*.php`: Try out each method individually (should you so desire) -- contains much more granular data about what's going on with each engine
 * `examples/compare.php`: The most interesting, this script will produce "operations per second" comparison timings on your system for both extensions. It tests different plaintext lengths, many iterations, encoding/decoding, and key length.

I think you are going to be surprised by the results of the timings script -- I sure was.

## Off to the races: Mcrypt vs. OpenSSL

*Speed, speed, speed*

Got a lot of data? I sure do, and the faster I can process the droves of encrypted data the better. To that end, the results from Mcrypt are super disappointing. OpenSSL routinely trounces it by factors of nearly 30x faster. 30x!

Here's a result table from my machine (i7 windows host, 4 core CentOS 6.4 VM through PHP 5.5.6):

```bash
# php examples/compare.php
Results:
+---------+--------+----------+-------------+--------------+
| ext     | keylen | textsize | (en/de)code | ops/sec      |
+---------+--------+----------+-------------+--------------+
| mcrypt  |    128 | short    | enc         |   5626.38872 |
| mcrypt  |    128 | short    | dec         |   5729.21909 |
| mcrypt  |    192 | short    | enc         |   5694.37256 |
| mcrypt  |    192 | short    | dec         |   5682.78434 |
| mcrypt  |    256 | short    | enc         |   5644.36358 |
| mcrypt  |    256 | short    | dec         |   5661.23080 |
| mcrypt  |    128 | medium   | enc         |   5583.97725 |
| mcrypt  |    128 | medium   | dec         |   5650.75122 |
| mcrypt  |    192 | medium   | enc         |   5591.54051 |
| mcrypt  |    192 | medium   | dec         |   5552.83950 |
| mcrypt  |    256 | medium   | enc         |   5524.18533 |
| mcrypt  |    256 | medium   | dec         |   5513.65563 |
| mcrypt  |    128 | long     | enc         |   4773.67544 |
| mcrypt  |    128 | long     | dec         |   4774.14273 |
| mcrypt  |    192 | long     | enc         |   4633.75035 |
| mcrypt  |    192 | long     | dec         |   4634.35450 |
| mcrypt  |    256 | long     | enc         |   4494.90529 |
| mcrypt  |    256 | long     | dec         |   4280.92422 |
| openssl |    128 | short    | enc         | 168581.35048 |
| openssl |    128 | short    | dec         | 170417.03234 |
| openssl |    192 | short    | enc         | 172052.83452 |
| openssl |    192 | short    | dec         | 171349.94689 |
| openssl |    256 | short    | enc         | 171112.27154 |
| openssl |    256 | short    | dec         | 171644.45899 |
| openssl |    128 | medium   | enc         | 166944.11718 |
| openssl |    128 | medium   | dec         | 169084.25381 |
| openssl |    192 | medium   | enc         | 166665.50107 |
| openssl |    192 | medium   | dec         | 168459.47466 |
| openssl |    256 | medium   | enc         | 163878.40900 |
| openssl |    256 | medium   | dec         | 167946.82470 |
| openssl |    128 | long     | enc         | 110370.61207 |
| openssl |    128 | long     | dec         | 142731.36868 |
| openssl |    192 | long     | enc         | 103798.85171 |
| openssl |    192 | long     | dec         | 135396.21667 |
| openssl |    256 | long     | enc         |  96767.81100 |
| openssl |    256 | long     | dec         | 132203.99672 |
+---------+--------+----------+-------------+--------------+
```

Summary:

1. If you are using a 256 bit key on long strings you'll see a 21x increase in speed for encoding and 30x increase for decoding
1. Use openssl
1. Niceity: openssl handles PKCS#7 automatically (and if you exclude the `OPENSSL_RAW_DATA` flag, it will also handle base64 (en|de)coding too!)
1. Key length has very little effect on speed in this situation -- use 256 bit keys

Clearly, you're going to want to use openssl, which also helps abstract all the little foibles people often make with mcrypt. However, if you can't use openssl, but do have mcrypt, this library can help you implement it ***correctly***.



[aes]: https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
[padding-methods]: http://en.wikipedia.org/wiki/Padding_(cryptography)#Block_cipher_mode_of_operation
[ecbtux]: http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_.28ECB.29
[rijndael]: http://csrc.nist.gov/archive/aes/rijndael/Rijndael-ammended.pdf
[cbc]: http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29
