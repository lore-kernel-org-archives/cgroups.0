From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Tue, 18 Dec 2018 18:22:52 +0100
Message-ID: <EC4F9B54-2352-4D85-B56C-5800CFEBCCB8@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
 <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=A8dUrmsI3uhRJycvb5Lt2RLbjLjJPOChaN1JgkfUuDI=;
        b=gi2K0UAneGavKoIZ/1rnLlZkJYk5BLZIkBmRdAqAodRl8kwQZ5D1ebrSoC1Wp1ZzVB
         LNnRvKZzp14g5738QO7lAyeFtBmcN6fUZwg5nuvIZQPWPUfHT2A48FFis0l/xE0JE9us
         rTlQgWOip7fd3aX4PhNLRjECPNTO94/T1gu7w=
In-Reply-To: <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Angelo Ruocco <angelo.ruocco.90@gmail.com>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 18 dic 2018, alle ore 17:41, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Paolo.
>=20
> On Tue, Dec 18, 2018 at 08:48:10AM +0100, Paolo Valente wrote:
>> If Tejun cannot see any solution to his concern, then can we just
>> switch to this extension, considering that
>> - for non-shared names the interface is *identical* to the current
>>  one;
>> - by using this new interface, and getting feedback we could
>>  understand how to better handle Tejun's concern?
>> A lot of systems do use weights, and people don't even know that =
these
>> systems don't work correctly in blk-mq.  And they won't work =
correctly
>> in any available configuration from 4.21, if we don't fix this =
problem.
>=20
> So, when seen from userland, how it should behave isn't vague or
> complicated.  For a given device and policy type, there can be only
> one implementation active.

Yes, but the problem is the opposite. You may have
- two different policies, with the same interface parameter,=20
- one active on one device
- the other one active on another device

In that case, statistics from one policy necessarily differ from
statistics from the other policy.

In this respect, in a system with more than one drive it already
happens that the same policy is active on different devices.  When
printing a statistics interface file for the policy, the output will
be a list of separate statistics, with a bunch of statistics *for
each* drive (plus a grand total in some cases).

So, our proposal simply extends this scheme in the most natural way:
if, now, also two or more policies share the same statistics file,
then the output will be a list of separate statistics, one for each
policy.  The statistics for each policy will be tagged with the policy
name, and will have the same identical form as above.  It seems the
most natural hierarchical extension of the same scheme.

At any rate, if you don't like it, just tell us how you prefer it
done.  Do you prefer the sharing of statistics file to be simply
forbidden?  (If this can be done.) I think such an incomplete solution
would preserve part of the current mess; but, if this allows us to
exit from this impasse, then it is ok for me.

*Any* feasible option is ok for me. Just pick one.

>  It doesn't make sense to have two weight
> mechanisms active on one device, right?

(Un)fortunately, the problem are not weights.  There won't be two
weights for two policies expiring a weight parameter.  The problems
concerns statistics.  See above.


>  So, the interface should only
> present what makes sense to the user for both configuration knobs and
> statistics, and that'd be a hard requirement because we don't want to
> present confusing spurious information to userspace.
>=20
> There seemd to have been significant misunderstandings as to what the
> requirements are when this was discussed way back, so idk what the
> good path forward is at this point.  Just keep the current names?
>=20

I don't clearly understand how "just picking the current names" is a
way forward, but if we do not make this extension, in a way or the
other, then two policies will simply not be allowed to share the same
interface files.  And we will be still at the starting point.

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

