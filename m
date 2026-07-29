Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D044331D
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318592; cv=none; b=t9gGkbRT2/msm1J4VJx/8Pp6yeKDKFmhfva95uXeTzvjQuLSkEolKHxPDBKNKO1wmus7Dq4HIqwA2W16h+aSNysSoHNap2BieOVQ+KIWgRZwfVCmSJ2OYlK+1Y0sfUWXWAUHodylAYjnCi46PkZjBAdkMI0nVGTp5VqZZCTAEm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318592; c=relaxed/simple;
	bh=4zXhUVKUU3dqZSbnSYsl5Mg8T8MnIn7mL1cY5ZXVo+A=;
	h=Cc:Subject:Content-Type:To:Message-Id:Mime-Version:In-Reply-To:
	 From:Date:References; b=RyJDTlobyNSCX/VVAbpAdl537Ad0wKHo2iOaApYl76Fi0JOXM66YZT4nGNv2KU+BFYqD1zqUufp1RhE2QOkbJ4RbPwJe0SGvV0Givya3NYDVTWDD1f17If+JFja5agQhlW9p0PzwLP0NX5hoNfYEAwYcIeRlMdByGSbIPWHp8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=SJQRO26a; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="SJQRO26a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785318580;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4zXhUVKUU3dqZSbnSYsl5Mg8T8MnIn7mL1cY5ZXVo+A=;
 b=SJQRO26acjjhtQ6iKSu4G0tZhBQVGnjbgZ2l2tFDYubHzbQSE+c3ClwFUVxXGvDV6LaPYW
 wvNkwyIV8mdW9sgmorV7KaAKC92LMCn2NsCak+sOGxYb5eGFftNoYJQvkmqFpOFTCpZu3d
 6g5s2wslE1ekKE59IUn9dlPwGkHaXfO/4Xemt4QgPcBo3yvcHHt1S98ipJOPVFwDcqGA/b
 UJHrhXtDQkvpVftZHEBVzr39zvT/6/+SsIyAK6bL5Md2zt5XLqPXX1feUKx9cIAvky7esV
 uSaQdbOV8sy9NNr7ti6PDceNkJouVlZtJ/XAJSlirW1+kTWb9aFSS2Z6YJMapg==
Cc: <hch@lst.de>, <dongsheng.yang@linux.dev>, <cengku@gmail.com>, 
	<josef@toxicpanda.com>, <ming.lei@redhat.com>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_set_dev
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 09:49:38 +0000
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a69ccb3+d4352d+vger.kernel.org+yukuai@fygo.io>
To: "Nilay Shroff" <nilay@linux.ibm.com>, <axboe@kernel.dk>, <tj@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <b9465ff1-3be6-4723-aa8b-1706eca09f7c@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8d5f5b83-dea7-47cd-ab0f-61d85a3d7ed9@linux.ibm.com>
From: "yu kuai" <yukuai@fygo.io>
Date: Wed, 29 Jul 2026 17:49:34 +0800
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-2-yukuai@kernel.org> <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io> <8d5f5b83-dea7-47cd-ab0f-61d85a3d7ed9@linux.ibm.com>
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/29 16:05, Nilay Shroff =E5=86=99=E9=81=93:
> On 7/27/26 1:46 PM, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/7/24 20:30, Yu Kuai =E5=86=99=E9=81=93:
>>> From: Yu Kuai<yukuai@fygo.io>
>>>
>>> bio_set_dev(), bio_init() and bio_reset() associate a bio with a=20
>>> blkg for
>>> its target queue. That association may have to create a new blkg, and
>>> currently there are lots of callers that are under atomic context.
>>>
>>> Move the association out of those helpers and into the submit path,=20
>>> which
>>> is always sleepable (submit_bio_noacct() already does might_sleep()):
>>>
>>> =C2=A0=C2=A0=C2=A0 - submit_bio() associates new I/O before bio_set_iop=
rio(), whose
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkcg_set_ioprio() reads the policy from=
 bio->bi_blkg.
>>>
>>> =C2=A0=C2=A0=C2=A0 - submit_bio_noacct() (re)associates when a bio has =
no blkg yet=20
>>> or was
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 remapped to a different queue.=C2=A0 blk=
_throtl_bio() and the rq_qos
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 throttlers (iocost, iolatency) pair bio-=
>bi_blkg with the=20
>>> queue of
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio->bi_bdev, so a remapped bio must be =
reassociated to the=20
>>> new queue.
>>>
>>> =C2=A0=C2=A0=C2=A0 - bio_set_dev() no longer associates; instead it dro=
ps the=20
>>> existing blkg
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 when the device changes, since that blkg=
 is tied to the old=20
>>> queue.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bio_init()/bio_reset() leave bi_blkg NUL=
L.
>>>
>>> Introduce bio_disassociate_blkg() to drop a bio's blkg reference and=20
>>> use it
>>> from bio_set_dev(), bio_uninit() and the bio freeing path, replacing=20
>>> their
>>> open-coded blkg_put().
>> Turns out bio will be submitted by kworker for some drivers and for
>> blkcg_punt_bio_submit(). Is it possible to record blkcg during bio=20
>> initialization,
>> as blkcg must exist, and then covert it to blkg during submission? I=20
>> can use union
>> for blkcg and blkg to avoid new field in struct bio.
>
> Since blkcg_punt_bio_submit() is the only deferred submission path,=20
> and it seems to
> me that all of its callers (btrfs mostly) appear to be in sleepable=20
> context, would
> it be sufficient to associate the blkg before punting the bio rather=20
> than changing the
> bio lifetime semantics?

blkcg_punt_bio_submit() must be called in sleepable context, itself is not =
a problem, we
can definitely associate a blkg there.

However, some drivers will also defer bio submission to kworker like dm and=
 md raid5, dm
is also the key participants to call bio_set_dev under atomic context. I li=
ke the idea to
just associate blkcg first, because most bio-based drivers will not enable =
blk-throttle,
which is the only blkcg policy for bio-based driver, hence blkg for bio-bas=
ed drivers is
not needed at all.

>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai
