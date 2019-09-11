From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Wed, 11 Sep 2019 18:44:31 +0200
Message-ID: <37CB2690-F1B9-4159-B6A9-77BDB0FF906D@linaro.org>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
 <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
 <A69EF8D0-8156-46DB-A4DA-C5334764116E@linaro.org>
 <20190911141630.GV2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CIzlo4K5/PjwxwRPJcn0L8E28gxLYoETPgMFHBnxBGM=;
        b=RiplzaXsZoN/l8/1QB2+PKmfBVYwqpeO8FjSnlnUnzxJBUYAaqG8Zm1oboRrHXiUgK
         shFRnhEZ9eAh5ONRTyBJDmTxG56+hxS9st+TCG401AIBpGfhNFuCfPkL/dcJCWBB0VQD
         X760P9SJ0S3MpF0ZGewpEpp8cHqbAFGYiZffb1lKQ6ej5txVcZzNhSZqqlBLsjymKFgD
         S1tQjzpdK8PA1rlsT7cr9AOOK94cRX5NGAP1ZHEviIDK+Q89HaLqqsdpqxy2M0ctDDbq
         KAzP+tv0EsEdBVkVUh5M6A6MLsCnd3jTrRLqj/6zi4SuSH/7MmYIU0IMTDMjeaznIdVu
         hAVA==
In-Reply-To: <20190911141630.GV2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, clm@fb.com, dennisz@fb.com, newella@fb.com, Li Zefan <lizefan@huawei.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, Rik van Riel <riel@surriel.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 11 set 2019, alle ore 16:16, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello,
>=20
> On Wed, Sep 11, 2019 at 10:18:53AM +0200, Paolo Valente wrote:
>>> The two being enabled at the same time doesn't make sense, so we can
>>> just switch over to bfq when bfq is selected as the iosched.  I =
asked
>>> what Paolo wanted to do in terms of interface a couple times now but
>>> didn't get an answer and he posted a patch which makes the two
>>> controllers conflict, so....  Paolo, so it looks like you want to
>>> rename all bfq files to drop the bfq prefix, right?
>>=20
>> Yep, mainly because ... this is the solution you voted and you
>> yourself proposed [1] :)
>>=20
>> [1] https://patchwork.kernel.org/patch/10988261/
>=20
> So, that was then.  Since then the interface change has been published
> and userspace, at least some of them, already had to adjust.  Now, I
> don't have any opinion on the matter and flipping again will cause
> inconveniences to some subset of users.  It's your call.
>=20

Ok, then let's go for removing bfq prefix, as expected, e.g., by
systemd community [1].  A few days ago I reposted a patch removing the
prefix from all involved parameters [2], it should make all legacy
software work again.

[1] https://github.com/systemd/systemd/issues/7057
[2] https://lkml.org/lkml/2019/9/9/47

>>> I can implement
>>> the switching if so.
>>=20
>> That would be perfect.
>=20
> Whichever way it gets decided, this is easy enough.  I'll prep a
> patch.
>=20

Thank you for that too,
Paolo

> Thanks.
>=20
> --=20
> tejun

