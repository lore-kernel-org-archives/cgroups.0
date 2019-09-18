From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Wed, 18 Sep 2019 07:18:50 +0200
Message-ID: <4D39D2FA-A487-4FAD-A67E-B90750CE0BD4@linaro.org>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org>
 <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cjIjHnXm58P1zO4oY7wd4+yUsPOW1veEt4hwLPpO2MY=;
        b=K8Dp9vC/OdSO9BAKVo9xeWWUiq2GDluYa2bLJ6eA0T9Jx7oTWgtTuS+aw8jzpbEZED
         JtfNz/iXeCdnyNgIKTNFiek7ijuz0E6YXmCeywGkS78IkEBRsO0h0bLdzrlTUuPNQsOY
         Ht0ezrew4y5yiyHfA52s2TuHHixni67GN23+E9m5YB9xKy3NpLJZ5VZIF7YCobCVeIvA
         ZFM8scx6LXHSI7Y5aFYKyQzUB/eB5MaTBLISGqatmi5SkNUqo1zk+X/MZDf66V+UhWyh
         BLBx0BugJNVz3Ha8NJW4zrhsmxEWz86jZFpHIrgOslr8gn+38AYcVBkL7pyilVw2ys2T
         ut2w==
In-Reply-To: <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>



> Il giorno 17 set 2019, alle ore 23:32, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello,
>=20
> On Tue, Sep 17, 2019 at 06:51:48PM +0200, Paolo Valente wrote:
>> When bfq was merged into mainline, there were two I/O schedulers that
>> implemented the proportional-share policy: bfq for blk-mq and cfq for
>> legacy blk. bfq's interface files in the blkio/io controller have the
>> same names as cfq. But the cgroups interface doesn't allow two
>> entities to use the same name for their files, so for bfq we had to
>> prepend the "bfq" prefix to each of its files. However no legacy code
>> uses these modified file names. This naming also causes confusion, =
as,
>> e.g., in [1].
>>=20
>> Now cfq has gone with legacy blk, so there is no need any longer for
>> these prefixes in (the never used) bfq names. In view of this fact, =
this
>> commit removes these prefixes, thereby enabling legacy code to truly
>> use the proportional share policy in blk-mq.
>=20
> So, I wrote the iocost switching patch and don't have a strong
> interest in whether bfq prefix should get dropped or not.  However, I
> gotta point out that flipping interface this way is way out of the
> norm.
>=20
> In the previous release cycle, the right thing to do was dropping the
> bfq prefix but that wasn't possible because bfq's interface wasn't
> compatible at that point and didn't made to be compatible in time.
> Non-obviously different interface with the same name is a lot worse
> than giving it a new name, so the only acceptable course of action at
> that point was keeping the bfq prefix.
>=20
> Now that the interface has already been published in a released
> kernel, dropping the prefix would be something extremely unusual as
> there would already be users who will be affected by the interface
> flip-flop.  We sometimes do change interfaces but I'm having a
> difficult time seeing the overriding rationales in this case.
>=20

This issue is a nightmare :)

Userspace wants the weight to be called weight (I'm not reporting
links to threads again).  *Any* solution that gets to this is ok for me.

A solution that both fulfills userspace request and doesn't break
anything for hypothetical users of the current interface already made
it to mainline, and Linus liked it too.  It is:
19e9da9e86c4 ("block, bfq: add weight symlink to the bfq.weight cgroup =
parameter")

But it was then reverted on Tejun's request to do exactly what we
don't want do any longer now:
cf8929885de3 ("cgroup/bfq: revert bfq.weight symlink change")

So, Jens, Tejun, can we please just revert that revert?

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

