From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Fri, 30 Nov 2018 19:53:07 +0100
Message-ID: <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=iEs0bu2v/4Sbmzc6i6UNYRAir2y1g1QCSGpytJmcmF4=;
        b=g8dX7FoZG+8Sd9IqjIs5yD0k5Nvh75AU4C2jRh+xbHynzneloHDxHX7x4y6NEIU9lo
         rK3R56IyT7atQubRCSGtGLextL736gjUxcfoa5s2pLusGyHaozLv8rbzjs0kxtXD1LAM
         3S0cGJHkXW9aNOCNa1MfpIculGopHk6o10gVQ=
In-Reply-To: <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 30 nov 2018, alle ore 19:42, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Paolo.
>=20
> On Fri, Nov 30, 2018 at 07:23:24PM +0100, Paolo Valente wrote:
>>> Then we understood that exactly the same happens with throttling, in
>>> case the latter is activated on different devices w.r.t. bfq.
>>>=20
>>> In addition, the same may happen, in the near future, with the
>>> bandwidth controller Josef is working on.  If the controller can be
>>> configured per device, as with throttling, then statistics may =
differ,
>>> for the same interface files, between bfq, throttling and that
>>> controller.
>=20
> So, regardless of how all these are implemented, what's presented to
> user should be consistent and clear.  There's no other way around it.
> Only what's relevant should be visible to userspace.
>=20
>> have you had time to look into this?  Any improvement to this
>> interface is ok for us. We are only interested in finally solving =
this
>> interface issue, as, for what concerns us directly, it has been
>> preventing legacy code to use bfq for years.
>=20
> Unfortunately, I don't have any implementation proposal, but we can't
> show things this way to userspace.
>=20

Well, this is not very helpful to move forward :)

Let me try to repeat the problem, to try to help you help us unblock
the situation.

If we have multiple entities attached to the same interface output
file, you don't find it clear that each entity shows the number it
wants to show.  But you have no idea either of how that differentiated
information should be shown.  Is this the situation, or is the problem
somewhere 'above' this level?

If the problem is as I described it, here are some proposal attempts:
1) Do you want file sharing to be allowed only if all entities will
output the same number?  (this seems excessive, but maybe it makes
sense)
2) Do you want only one number to be shown, equal to the sum of the
numbers of each entity?  (in some cases, this may make sense)
3) Do you prefer an average?
4) Do you have any other idea, even if just germinal?

Looking forward to your feedback,
Paolo=20


> Thanks.
>=20
> --=20
> tejun
>=20
> --=20
> You received this message because you are subscribed to the Google =
Groups "bfq-iosched" group.
> To unsubscribe from this group and stop receiving emails from it, send =
an email to bfq-iosched+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.

