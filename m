From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Tue, 20 Nov 2018 17:50:14 +0100
Message-ID: <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
 <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+Wf6CDJUPs+eWjtmr8Hr9KG3FFVm+nlkqZS2f8RgM/w=;
        b=bR53PuEkjfKVO5TfuQ57wxNpCGss5PElS42NlnIjUGGw8biMobE8VfD8A7yOhyg7TC
         evXEdHcDLEQS1PR8hyjN3k1q1TpLWTTPVIMHma0fR4A9eq/FXWqA9rrXZQ6+52BApAWS
         dXn5fVB13ahQLsouU+4AlZzMipjOTQmhOgXT0=
In-Reply-To: <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 20 nov 2018, alle ore 17:28, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Paolo.
>=20
> On Mon, Nov 19, 2018 at 11:34:14AM +0100, Paolo Valente wrote:
>> - if all entities produce the same output, the this common output is
>> shown only once;
>> - if the outputs differ, then every per-entity output is shown,
>> followed by the name of the entity that produced that output.
>=20
> So, this doesn't make sense to me.  One set of numbers is meaningful,
> the other not and the user doesn't have a way to tell which one is.
> It makes no sense to present both numbers.
>=20

I do agree that these numbers may confuse.  Before discussing how to
do this better, let me tell you why we are showing them.

In the first place, the need for a diversified output showed up in the
following case.  Given a group using the blkio/io controller, and two
drives
- one with legacy block and cfq
- one with blk-mq and bfq
there will be different statistics for each scheduler, for the same
interface files.

Then we understood that exactly the same happens with throttling, in
case the latter is activated on different devices w.r.t. bfq.

In addition, the same may happen, in the near future, with the
bandwidth controller Josef is working on.  If the controller can be
configured per device, as with throttling, then statistics may differ,
for the same interface files, between bfq, throttling and that
controller.

More general examples could be made considering that this extension is
for the generic cgroup interface.

Of course, suggestions for a clearer way to show these numbers are
more than welcome!  Maybe involved device identifiers can be somehow
gathered by the entities providing these numbers, and then shown?  In
this respect, consider that, even without this extension, one still
has the fundamental problem of not knowing to which devices numbers
apply (unless I'm missing something else).

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

