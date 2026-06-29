Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5072F872
	for <cgroups@vger.kernel.org>; Mon, 29 Jun 2026 09:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723819; cv=none; b=onn58gl4Qj3MRhvNpyS7dy7UEYjd3iK2RxUagYvcaKK9LELpsg7oTEOhJ8hFc1grai4T7hNOYTw+aDe1PzZfKJNHQa9HgRm0Hl0fdzhdYiH6rlpq0S5hXnjirEc3YqX0IE7tk83iivBdptVA6riQL3QKfo8pzxCdjqQQJeYyCas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723819; c=relaxed/simple;
	bh=aZiIdkWvg/SWXssn7mLtElQqAfi3YfAuZ9p9/V/bx/4=;
	h=Message-Id:Mime-Version:To:Cc:From:Subject:Date:In-Reply-To:
	 Content-Type:References; b=XQ22iYyJ/nbdL6Xvlx56BsGPkSU0dn1MYbQxzlt2g1kdGYwJhLXBJpuEZOIZPQhBu2Hk4bSBzrQ3eakPCWpkS+egfDZGEtKodSWL6DLf3ZxWaXFnD8U+tHLNzHltC0Mpq2mKPkBupqqjxfnzmMvbsi/T5MpdDHGjMau2gcOovkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=pYwKiW3h; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="pYwKiW3h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782723803;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aZiIdkWvg/SWXssn7mLtElQqAfi3YfAuZ9p9/V/bx/4=;
 b=pYwKiW3hMBanbuKNm7+P9l7/8OWJ3WvD63/FUTw1dBfXPhQXsF7H5YCnjgXpaDsxlHCuso
 Y2W+QaI5yM1h5d0O8qqPq8YoL0e6Nj73nPGwr52/c2uN5SPoa529x6gkca/RS6bov3Mu+/
 I4zpmVpe81mvvb00I46FTbgHOCqx5pFcdHbPURG5Jn4OV3n3NK26DKAXQ1DSD83XRKxXyo
 NktPMhwpzFZRQWdK58F3rxQn15NOrDUCG+xFwAiMJbwH6AhfU/JU1TJO23T08Z2Sry+RA0
 bgVDjFcl9vgh+ZC1mS1luutxHesirRDcRZY21rYaugjyQ0erPA5oQ3OAacrzNQ==
Content-Transfer-Encoding: quoted-printable
Message-Id: <ef6f87cb-6ad3-41c9-80bc-9fe996a2379c@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Mon, 29 Jun 2026 09:03:22 +0000
X-Lms-Return-Path: <lba+26a4234da+a5328c+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Nilay Shroff" <nilay@linux.ibm.com>, <yukuai@fygo.io>, 
	"Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Jens Axboe" <axboe@kernel.dk>
Cc: "Zheng Qixing" <zhengqixing@huawei.com>, 
	"Christoph Hellwig" <hch@lst.de>, "Tang Yizhou" <yizhou.tang@shopee.com>, 
	"Ming Lei" <ming.lei@redhat.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 2/4] blk-cgroup: fix race between policy activation and blkg destruction
Date: Mon, 29 Jun 2026 17:03:11 +0800
In-Reply-To: <c44fcd50-6341-4617-b6cb-cad3c65a7a75@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260624064625.1743650-1-yukuai@kernel.org> <20260624064625.1743650-5-yukuai@kernel.org> <6580506d-3baa-4ceb-bf2e-5f6c974f3d10@linux.ibm.com> <7ebbf312-7c1b-4024-a35d-89a95d82b4f4@fygo.io> <749d17be-ff9f-4f70-a948-0133f02eec93@fygo.io> <866644be-3b07-49f9-9c5d-e0f94ad1c793@linux.ibm.com> <5f5a4729-0c90-4f6f-b97e-cab9d0289dc2@fygo.io> <c44fcd50-6341-4617-b6cb-cad3c65a7a75@linux.ibm.com>

Hi,

=E5=9C=A8 2026/6/29 13:33, Nilay Shroff =E5=86=99=E9=81=93:
> On 6/27/26 9:43 AM, yu kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2026/6/26 14:12, Nilay Shroff =E5=86=99=E9=81=93:
>>> On 6/26/26 7:22 AM, yu kuai wrote:
>>>> Hi,
>>>>
>>>> =E5=9C=A8 2026/6/26 9:50, yu kuai =E5=86=99=E9=81=93:
>>>>> Hi,
>>>>>
>>>>> =E5=9C=A8 2026/6/25 23:08, Nilay Shroff =E5=86=99=E9=81=93:
>>>>>> On 6/24/26 12:16 PM, Yu Kuai wrote:
>>>>>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>>>>>> index 7baccfb690fe..f7e788a7fe95 100644
>>>>>>> --- a/block/blk-cgroup.c
>>>>>>> +++ b/block/blk-cgroup.c
>>>>>>> @@ -1563,10 +1563,12 @@ int blkcg_activate_policy(struct gendisk
>>>>>>> *disk, const struct blkcg_policy *pol)
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(!pol->=
pd_alloc_fn || !pol->pd_free_fn))
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return -EINVAL;
>>>>>>> =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (queue_is_mq(=
q))
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 memflags =3D blk_mq_freeze_queue(q);
>>>>>>> +
>>>>>>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&q->blkcg_mutex);
>>>>>>> =C2=A0=C2=A0 =C2=A0 retry:
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&q->queue=
_lock);
>>>>>>> =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* blkg_list is =
pushed at the head, reverse walk to
>>>>>>> initialize parents first */
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_each_entry_rev=
erse(blkg, &q->blkg_list, q_node) {
>>>>>>> @@ -1625,10 +1627,11 @@ int blkcg_activate_policy(struct gendisk
>>>>>>> *disk, const struct blkcg_policy *pol)
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __set_bit(pol->plid, q-=
>blkcg_pols);
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D 0;
>>>>>>> =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(=
&q->queue_lock);
>>>>>>> =C2=A0=C2=A0 =C2=A0 out:
>>>>>>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&q->blkcg_mutex);
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (queue_is_mq(q))
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 blk_mq_unfreeze_queue(q, memflags);
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pinned_blkg)
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 blkg_put(pinned_blkg);
>>>>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pd_prealloc)
>>>>>> If the policy allocation fails, we jump to the lable enomem: and
>>>>>> teardown pds.
>>>>>> But I see this path still only acquires ->queue_lock. Don't we also
>>>>>> need
>>>>>> to protect it with ->blkcg_mutex?
>>>>> Yes, I agree we should protect it as well.
>>>>
>>>> Just take a closer look at the code, the enomem is already=20
>>>> protected by
>>>> blkcg_mutex :)
>>>>
>>>
>>> Oh yes, but the ->blkcg_mutex is never released if we jump to enomem.
>>> So that may potentially cause deadlock. We need to release=20
>>> ->blkcg_mutex
>>> once blkcg_policy_teardown_pds() returns. Or may be refactor code=20
>>> (or add
>>> comment) so that it's easy to realize or spot the ->blkcg_mutex is
>>> acquired
>>> and then released around blkcg_policy_teardown_pds().
>>
>> the enomem will goto out at last, and blkcg_mutex do released. The=20
>> code is
>> a bit hacky.
>>
>>>
>>>>>
>>>>>> Moreover I still see race between blkg insertion in blkg_create()
>>>>>> which
>>>>>> still doesn't use ->blkcg_mutex and so list traversal in
>>>>>> bfq_end_wr_async()
>>>>>> may still race with blkg_create(), isn't it? I remember you once=20
>>>>>> told
>>>>>> this will be handled in another series but I couldn't find that yet.
>>>>> This is the set:
>>>>>
>>>>> [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths=20
>>>>> - Yu
>>>>> Kuai=20
>>>>> <https://lore.kernel.org/all/cover.1780621988.git.yukuai@fygo.io/>
>>>>>
>>>>> Noted that set just make sure queue_lock is not nested under other
>>>>> atomic
>>>>> context, and that set do not acquire blkcg_mutex for blkg_create()
>>>>> yet. Howerver,
>>>>> with that set it'll be easy to convert all queue_lock to blkcg_mtuex
>>>>> for blkg
>>>>> protection, and together with lots of blk-cgroup code cleanups.
>>>>>
>>>
>>> Okay, so are you planning to send a follow-up patchset that replaces
>>> ->queue_lock
>>> with ->blkcg_mutex for protecting the blkg_list? If so, I'd still
>>> prefer acquiring
>>> ->blkcg_mutex around blkg_create() in this patchset. That would
>>> address the race
>>> between blkg_create() and the blkg_list traversal in
>>> bfq_end_wr_async(), while the
>>> subsequent series can focus on cleaning up and removing the remaining
>>> ->queue_lock
>>> usage for blkg protection.
>>
>> Yes, there is a follow-up patchset. When this set was posted,=20
>> blkg_create is still
>> called with queue_lock held, so I can't do that. However, not that=20
>> the other set
>> is already applied, I can hold blkcg_mutex for blkg_create() now.
>>
>
> If you already have a follow-up patchset that replaces ->queue_lock with
> ->blkcg_mutex for protecting blkg_list, then I think it might make sense
> to send that out first (if you haven't already) and hold off this=20
> series for
> now. That way, the blkg_create() race can be addressed first, and this
> series can build on top of those changes.

Yes, I already have a follow-up patchset that is build after this set.
I agree send that first will make sense, I'll rebase and send soon.

>
> BTW, if that follow-up series is merged first, I suspect the first two=20
> patches in
> this series may no longer be necessary, leaving only patches 3/4 and 4/4.

Yes, the first two patches will be folded into the patch to replace
queue_lock with blkcg_mutex.

>
> Thanks,
> --Nilay
>
>
>
--=20
Thanks,
Kuai
