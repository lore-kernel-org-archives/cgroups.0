Received: from lf-2-44.ptr.blmpb.com (lf-2-44.ptr.blmpb.com [101.36.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F89D2931EE
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 07:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784790285; cv=none; b=PQUpjqxYoC7SNL7GvFfJbZHB015Qn7BmVx9uQWPXq0pDR1dknZz/y+Us3dTM3M/v4whTbbOD2YJ/onTxJB6/XJE9myC90XnHKMG4yj7PPXAmN/ts1muN7wyR91xd49BIxsF86iLlZrcFb5gaiogu7GXJRALiH/0VHWu5+Q63Pyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784790285; c=relaxed/simple;
	bh=uhyBvDEhPU+sGnw3/t9PBXDk9+k140Odr/fon+soAPc=;
	h=Message-Id:References:To:Mime-Version:Content-Type:Date:
	 In-Reply-To:Cc:From:Subject; b=n8fOB7bSTjWcKlQ5k2jpU+JCOeSPWH2W1ikh53YTCtRzNXzR17hb3HQO1nAwldeFAahArtlfLcAPypZpYe5QHAdwgJIIUU/+kCRfvdrIIMhYdMlA4wtFnzI6U7nLoRuC2nl9mxwm8thswDHrcnqhNCDuZr+Wo80qLk2WYh4G0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=kRCLEiKe; arc=none smtp.client-ip=101.36.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="kRCLEiKe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784790224;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uhyBvDEhPU+sGnw3/t9PBXDk9+k140Odr/fon+soAPc=;
 b=kRCLEiKewcrFXOWLhoorNYSuDcSujGeZ+4YnuLSvybdE34VeH9awKs1DrmA8CDtssSpK7X
 rKLiZeSqg0YoQqDfdBx7bxC+P34/AFGG7iIgYmWmpc/Dh+wNCVO1vn3I8qD06Niz3WOVZd
 Ti22VrLglKfwRZDK+tgropkPvIOc//y9RAoRa9z+eU4lwyFlCQ+BQHJ2c2WQcnZ5EtuVAD
 ItBk8ScccMArT6vgWHA+qB/It/3pxoQn6kLcT2/6cMY7BIIxIYJY0TzhU3KBHmGsPbwnIm
 I2py8ldBbpQvkR+3+vTYp5+4F6O0StqnCGyCs+0ws9t+jlcS1VxhE57+494zGA==
Message-Id: <338127ba-2c79-405e-bd8c-afa2bf812615@fygo.io>
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Thu, 23 Jul 2026 07:03:42 +0000
User-Agent: Mozilla Thunderbird
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-2-yukuai@kernel.org> <6baae2af-640e-48bd-9909-977cd316c8d5@linux.ibm.com>
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Thu, 23 Jul 2026 15:03:37 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6baae2af-640e-48bd-9909-977cd316c8d5@linux.ibm.com>
Reply-To: yukuai@fygo.io
Cc: "Christoph Hellwig" <hch@lst.de>, "Keith Busch" <kbusch@kernel.org>, 
	"Sagi Grimberg" <sagi@grimberg.me>, "Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Yu Kuai" <yukuai@fygo.io>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-nvme@lists.infradead.org>, <dm-devel@lists.linux.dev>, 
	<linux-bcache@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 01/17] nvme-multipath: retarget failedover bios from requeue work
X-Lms-Return-Path: <lba+26a61bccf+eca662+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/18 3:12, Nilay Shroff =E5=86=99=E9=81=93:
> On 7/5/26 1:21 AM, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> bio_set_dev() is about to become explicitly sleepable because it can
>> associate the bio with a blkg for the destination queue.=C2=A0 NVMe fail=
over
>> can run from request completion context, and nvme_failover_req() also=20
>> holds
>> head->requeue_lock with interrupts disabled while it steals bios from=20
>> the
>> failed request.=C2=A0 Calling bio_set_dev() there is not safe once the=
=20
>> helper is
>> allowed to sleep.
>>
>> The requeue lock only protects head->requeue_list.=C2=A0 Keep the list
>> manipulation under that lock, but defer retargeting to=20
>> nvme_requeue_work(),
>> which already drains the list from process context before=20
>> resubmitting each
>> bio.=C2=A0 The bios remain private to the requeue list until the worker =
pops
>> them, so moving the device switch there preserves the existing retry=20
>> flow
>> while avoiding a sleepable helper in completion context.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>> =C2=A0 drivers/nvme/host/multipath.c | 4 +---
>> =C2=A0 1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/nvme/host/multipath.c=20
>> b/drivers/nvme/host/multipath.c
>> index 9b9a657fa330..76baa180ae1c 100644
>> --- a/drivers/nvme/host/multipath.c
>> +++ b/drivers/nvme/host/multipath.c
>> @@ -149,7 +149,6 @@ void nvme_failover_req(struct request *req)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct nvme_ns *ns =3D req->q->queuedata;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16 status =3D nvme_req(req)->status & NV=
ME_SCT_SC_MASK;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
>> -=C2=A0=C2=A0=C2=A0 struct bio *bio;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nvme_mpath_clear_current_path(ns);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_long_inc(&ns->failover);
>> @@ -165,8 +164,6 @@ void nvme_failover_req(struct request *req)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irqsave(&ns->head->reque=
ue_lock, flags);
>> -=C2=A0=C2=A0=C2=A0 for (bio =3D req->bio; bio; bio =3D bio->bi_next)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_set_dev(bio, ns->head->d=
isk->part0);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blk_steal_bios(&ns->head->requeue_list, r=
eq);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irqrestore(&ns->head->requeue=
_lock, flags);
>> =C2=A0 @@ -684,6 +681,7 @@ static void nvme_requeue_work(struct=20
>> work_struct *work)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 next =3D bio->bi_=
next;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio->bi_next =3D =
NULL;
>> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_set_dev(bio, head=
->disk->part0);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 submit_bio_noacct=
(bio);
>
> What happens if bio_set_dev() fails to associate a blkg? From what
> I understand, bio_associate_blkg() may fail, leaving bio->bi_blkg
> set to NULL. Later, submit_bio_noacct() can invoke blkcg-related
> helpers such as blk_should_throtl(), which expect a valid bio->bi_blkg.
> However if bio->bi_blkg is NULL then accessing it without NULL check
> could crash the kernel. This is probably not a bug introduced with your
> changes, but you may want to check it.

bio_set_dev() will not leave bio->bi_blkg set to NULL. blkg_lookup_create()
will iterate closest blkg start from root_blkg, if any blkg is missing then
create, and if creating failed, current closest blkg is returned.

The same iteration exist in blkcg configuration, where failure is returned =
if
blkg creation failed.

>
> The question is, is bio_associate_blkg() guaranteed never to fail, or
> should the failure be handled explicitly before the bio is resubmitted?
>
> I also skimmed through the rest of the series. However, as Christoph
> mentioned in an earlier thread, we may be moving away from non-blocking
> blkg allocation altogether. If that's the direction we're taking, this
> series will likely need to be reworked. I'd therefore prefer to wait for
> the next revision before reviewing the other patches.
>
> Thanks,
> --Nilay
>
>
--=20
Thanks,
Kuai
