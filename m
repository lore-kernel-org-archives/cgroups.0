From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Sun, 30 Dec 2018 11:25:25 +0100
Message-ID: <F2A4E669-8C79-46D7-8A97-2C561FF5346B@linaro.org>
References: <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
 <25296DAE-73EC-46CC-9A98-A8B7E9017BB7@linaro.org>
 <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
 <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
 <EC4F9B54-2352-4D85-B56C-5800CFEBCCB8@linaro.org>
 <A360EBDC-B297-4754-AF5C-0A6C30D725B4@linaro.org>
 <20181227234144.GE2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RcIxiy51crz2BQyDtywt/mbWbWq0tfJAe0NkaqiG1IM=;
        b=J2Gz+1F1qZXyqxAPjwSRThTSJUptrgZUg6fKCtvgXhgC8HcoRmlPrhLmIwcxyF6xn+
         wbCktOKo6nps6P+AolCt1l1RLjoq9WdSMOwUXb/dz10JTbqZ9y+TOrrS6g4FyWrMhgfI
         gy1xRQH3ziJRyLLoBvajgBfamYoD0nXeNpCIU=
In-Reply-To: <20181227234144.GE2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Angelo Ruocco <angelo.ruocco.90@gmail.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>



> Il giorno 28 dic 2018, alle ore 00:41, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Paolo.
>=20
> On Sun, Dec 23, 2018 at 12:00:14PM +0100, Paolo Valente wrote:
>> 4.21 is coming ...  and the legacy proportional share interface will
>> be gone with cfq.  This will break legacy code using the
>> proportional-share interface on top of bfq.  This code may just fail
>> when trying to use interface files that don't exist any longer.
>=20
> Sounds like inheriting .cfq namespace would be the easiest.  Would
> that work?
>=20

For bfq, yes, but what will, e.g., Josef do when he adds his new
proportional-share implementation?  Will he add a new set of names not
used by any legacy piece of code?

What's the benefit of throwing away months of work, on which we agreed
before starting it, and that solves a problem already acknowledged by
interested parties?

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

