From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Fri, 30 Nov 2018 19:23:24 +0100
Message-ID: <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gyqSeFnxuL66/4Tb83vuNNeyna66MDa5D0/0KSnYmmA=;
        b=Ew9SX3RhnoO0FB2mWoiHH/G5G9uPbHdEEKfx28ZS1PmNH/iK+DNijjO38sGJjmcojV
         VTpXBHm1FHfP+HQEyVYsIQsMag6z4pGTPuHtx+kKI2peqoRPOkdUtVdfv0aFZ1MhIutc
         jXusQzvJpN5XrW4REVP3SAiqy/jxMo17A54Lo=
In-Reply-To: <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 20 nov 2018, alle ore 17:50, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>=20
>=20
>> Il giorno 20 nov 2018, alle ore 17:28, Tejun Heo <tj@kernel.org> ha =
scritto:
>>=20
>> Hello, Paolo.
>>=20
>> On Mon, Nov 19, 2018 at 11:34:14AM +0100, Paolo Valente wrote:
>>> - if all entities produce the same output, the this common output is
>>> shown only once;
>>> - if the outputs differ, then every per-entity output is shown,
>>> followed by the name of the entity that produced that output.
>>=20
>> So, this doesn't make sense to me.  One set of numbers is meaningful,
>> the other not and the user doesn't have a way to tell which one is.
>> It makes no sense to present both numbers.
>>=20
>=20
> I do agree that these numbers may confuse.  Before discussing how to
> do this better, let me tell you why we are showing them.
>=20
> In the first place, the need for a diversified output showed up in the
> following case.  Given a group using the blkio/io controller, and two
> drives
> - one with legacy block and cfq
> - one with blk-mq and bfq
> there will be different statistics for each scheduler, for the same
> interface files.
>=20
> Then we understood that exactly the same happens with throttling, in
> case the latter is activated on different devices w.r.t. bfq.
>=20
> In addition, the same may happen, in the near future, with the
> bandwidth controller Josef is working on.  If the controller can be
> configured per device, as with throttling, then statistics may differ,
> for the same interface files, between bfq, throttling and that
> controller.
>=20
> More general examples could be made considering that this extension is
> for the generic cgroup interface.
>=20
> Of course, suggestions for a clearer way to show these numbers are
> more than welcome!  Maybe involved device identifiers can be somehow
> gathered by the entities providing these numbers, and then shown?  In
> this respect, consider that, even without this extension, one still
> has the fundamental problem of not knowing to which devices numbers
> apply (unless I'm missing something else).
>=20

Hi Tejun,
have you had time to look into this?  Any improvement to this
interface is ok for us. We are only interested in finally solving this
interface issue, as, for what concerns us directly, it has been
preventing legacy code to use bfq for years.

Thanks,
Paolo



> Thanks,
> Paolo
>=20
>> Thanks.
>>=20
>> --=20
>> tejun
>=20
> --=20
> You received this message because you are subscribed to the Google =
Groups "bfq-iosched" group.
> To unsubscribe from this group and stop receiving emails from it, send =
an email to bfq-iosched+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.

