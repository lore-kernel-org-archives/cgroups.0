From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Wed, 11 Sep 2019 10:18:53 +0200
Message-ID: <A69EF8D0-8156-46DB-A4DA-C5334764116E@linaro.org>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
 <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=R6bNyRB3okcLgmMwzrbkbbFt8yg4QtbotOgZ2XtiVFQ=;
        b=T10RJz72P4bazLOmVQcxgR86fu6+qGr1JftyGJUuSDSuJccnd7vnWx7F+SNdOVW//i
         dOaN5N9S5adBx5TFmelByaEo4t5VgpA2m00JbgDiWz854afZSstaupDlHffRMzRX7BW2
         ZVep8klfo0LjL8jDbGF9aBeqfc5LA2Gvq+MrL4GAcIk2e5Z6wy+EzBeW9rGl2x0GJFdL
         ENacUnjM+CLhVcMXW45xALoU7qPPovZHx4xK9O8WUkQgISEOMTordF9jLBmq07SbwTX1
         IPhe76cE//tEyQNVvZ2aEZ2AgtdRegAuQFcgTKjoEz53rrrZUSW8mjDTQLaM34MgxpoN
         /dPw==
In-Reply-To: <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, clm@fb.com, dennisz@fb.com, newella@fb.com, Li Zefan <lizefan@huawei.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, Rik van Riel <riel@surriel.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 10 set 2019, alle ore 18:08, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Michal.
>=20
> On Tue, Sep 10, 2019 at 02:55:14PM +0200, Michal Koutn=C3=BD wrote:
>> This adds the generic io.weight attribute. How will this compose with
>> the weight from IO schedulers? (AFAIK, only BFQ allows proportional
>> control as of now. +CC Paolo.)
>=20
> The two being enabled at the same time doesn't make sense, so we can
> just switch over to bfq when bfq is selected as the iosched.  I asked
> what Paolo wanted to do in terms of interface a couple times now but
> didn't get an answer and he posted a patch which makes the two
> controllers conflict, so....  Paolo, so it looks like you want to
> rename all bfq files to drop the bfq prefix, right?

Yep, mainly because ... this is the solution you voted and you
yourself proposed [1] :)

[1] https://patchwork.kernel.org/patch/10988261/

>  I can implement
> the switching if so.
>=20

That would be perfect.

Thanks,
Paolo

>> I see this attributes are effectively per-cgroup per-device. =
Apparently,
>> one device should have only one weight across hierarchy. Would it =
make
>> sense to have io.bfq.weight and io.cost.weight with disjunctive =
devices?
>=20
> It never makes sense to have both enabled, so I don't think that
> interface makes sense.
>=20
>>> +		.name =3D "cost.qos",
>>> +		.flags =3D CFTYPE_ONLY_ON_ROOT,
>>> [...]
>>> +		.name =3D "cost.model",
>>> +		.flags =3D CFTYPE_ONLY_ON_ROOT,
>> I'm concerned that these aren't true cgroup attributes. The root =
cgroup
>> would act as container for global configuration options. Wouldn't =
these
>> values better fit as (configurable) attributes of the respective
>> devices?
>=20
> Initially, I put them under block device sysfs but it was too clumsy
> with different config file formats and all.  I think it's better to
> have global controller configs at the root cgroup.
>=20
>> Secondly, how is CFTYPE_ONLY_ON_ROOT supposed to be presented in =
cgroup
>> namespaces?
>=20
> Not at all.  These are system-wide configs.  cgroup namespaces
> shouldn't have anything which aren't in non-root cgroups.
>=20
> Thanks.
>=20
> --=20
> tejun

