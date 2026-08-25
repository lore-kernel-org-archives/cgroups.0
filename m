Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E02931F8
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787625248; cv=none; b=Ai4ZEerbWedCOUNa8N0kGsr5p4TbCvs1pHvlltRMsMR28wKWuRV6IuyEWPcSJOCX18SHzSb0owi3wyuWaUIcrJMWInaAzPOPCvTpcEqBYuA3/sfIn5GMZIxEC0XzZdvQpid3Kz4kN3ZSxkIn0KL6anc/1LGddCQNGpJDdHQFAaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787625248; c=relaxed/simple;
	bh=Cw5BitVxKiZ/XuqFC9PfZMXgD2EiVbmLVlUZl4A/kNE=;
	h=From:Subject:Date:Message-Id:In-Reply-To:To:References:
	 Content-Type:Cc:Mime-Version; b=u6pMz+49pM73x4Qf8yX1Vw9lHKTjp1gx0LgXCXu3B9LVZZ/UsBRQ5JN1FcCWlsf+iqKF4qGqTdEJJFkUNQc1jSBdjBenzuWG8nlVGdtSDsWtThZzXgm2ruUpr8/yrPltKKASWQhECA9kcCyNS1oe7Pub2RWPwxHDAnQtMtxQMhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=N1damRuD; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="N1damRuD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787625231;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lDI5s84hBd6G6H4Z44CVTBiUldbRbWGcWgxU60+VRcc=;
 b=N1damRuDdXq/S1qvgsPvIgiOMRae2tOkZnrPnX1YDwqs4BpardpXORILjIwLcfT8gYvwpj
 y61YbIXqFqSjzjrn0p6+CIe6SIBHKc9qAw6XSARZEfZtjieI80bZQTVw9B+QETeoNZA+pu
 TWAjzZ46WhnyanSUxlDLh1p/WnyjNm3fgccPfl/M/4xsLb/VBYb1pWqQR0LMYoC1hGE8nK
 KadtWGzDFvZXC6xb/23tUyEcACNIzwGM96ySDeyVio6TOd1xo8LUoK8Oh78L/wbHfzWxv3
 04zQ7pe5Zo3U0Nd2rvrcDJvdztzZvF7cvxjniVoqNblCd8b3RFfMfgLhHpxn6g==
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v3 4/6] blk-cgroup: allocate blkgs in blkg_create
Date: Tue, 25 Aug 2026 10:33:45 +0800
Message-Id: <6a9cc2ee-c46f-4cd4-9d32-a96bcbfed213@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <ca5c6c43-b6e6-48f3-9e3b-6d5f8b1538c8@linux.dev>
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.larksuite.com with ESMTPS; Tue, 25 Aug 2026 02:33:49 +0000
To: "Tao Cui" <cui.tao@linux.dev>, "Yu Kuai" <yukuai@kernel.org>, 
	"Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, 
	"Clark Williams" <clrkwllms@kernel.org>, 
	"Steven Rostedt" <rostedt@goodmis.org>, "yu kuai" <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
References: <20260823152926.1043863-1-yukuai@kernel.org> <20260823152926.1043863-5-yukuai@kernel.org> <ca5c6c43-b6e6-48f3-9e3b-6d5f8b1538c8@linux.dev>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: "Christoph Hellwig" <hch@lst.de>, "Nilay Shroff" <nilay@linux.ibm.com>, 
	"Hannes Reinecke" <hare@suse.de>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>, 
	<linux-kernel@vger.kernel.org>
X-Lms-Return-Path: <lba+26a8cff0e+3bf86d+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/8/25 9:35, Tao Cui =E5=86=99=E9=81=93:
> Hi Kuai,
>
> =E5=9C=A8 2026/8/23 23:29, Yu Kuai =E5=86=99=E9=81=93:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> Move blkg allocation into blkg_create() and have it take a gfp_t mask, s=
o
>> that the caller controls whether creation may sleep. blkg_create() now
>> always allocates the blkg itself instead of sometimes receiving a
>> preallocated one, which lets the lookup and config paths drop their open=
-
>> coded preallocation and retry loops.
>>
>> blkg_lookup_create() and the root-blkg setup use GFP_NOIO (or GFP_KERNEL
>> for the root) so they do not recurse into IO reclaim; the nowait policy
>> path added later will use GFP_ATOMIC.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>>   block/blk-cgroup.c | 48 +++++++++++++---------------------------------
>>   1 file changed, 13 insertions(+), 35 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 0f34a80a726d..33fba781017b 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -383,37 +383,29 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *b=
lkcg, struct gendisk *disk,
>>   out_free_blkg:
>>   	kfree(blkg);
>>   	return NULL;
>>   }
>>  =20
>> -/*
>> - * If @new_blkg is %NULL, this function tries to allocate a new one as
>> - * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return=
.
>> - */
>>   static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendis=
k *disk,
>> -				    struct blkcg_gq *new_blkg)
>> +				    gfp_t gfp_mask)
>>   {
>> -	struct blkcg_gq *blkg;
>> +	struct blkcg_gq *blkg =3D NULL;
>>   	int i, ret;
>>  =20
>>   	lockdep_assert_held(&disk->queue->blkcg_mutex);
>>  =20
>>   	/* request_queue is dying, do not create/recreate a blkg */
>>   	if (blk_queue_dying(disk->queue)) {
>>   		ret =3D -ENODEV;
>>   		goto err_free_blkg;
>>   	}
>>  =20
> Reading patch 4/6, one thing looked off to me. Before the series,
> blkg_create() allocated with GFP_NOWAIT under queue_lock, or took a
> caller-preallocated object. After patches 3+4, it allocates with the
> passed gfp_mask while holding blkcg_mutex:
>
>> -	/* allocate */
>> -	if (!new_blkg) {
>> -		new_blkg =3D blkg_alloc(blkcg, disk, GFP_NOWAIT);
>> -		if (unlikely(!new_blkg)) {
>> -			ret =3D -ENOMEM;
>> -			goto err_free_blkg;
>> -		}
>> +	blkg =3D blkg_alloc(blkcg, disk, gfp_mask);
>> +	if (unlikely(!blkg)) {
>> +		ret =3D -ENOMEM;
>> +		goto err_free_blkg;
>>   	}
>> -	blkg =3D new_blkg;
>>  =20
> (patch 4 also makes blkg_lookup_create() pass GFP_NOIO for the
> config path, where blkg_conf_prep() used to drop queue_lock before
> allocating.)
>
> blk_throtl_init() reaches blkcg_activate_policy() with the queue
> frozen, so we can end up allocating (and entering reclaim) while
> holding q_usage_counter -> blkcg_mutex. Reclaim can then add the
> q_usage_counter edge from the disk probe side.
>
> I booted the series in a VM with PROVE_LOCKDEP to check, and lockdep
> does report a circular dependency on the first io.max write, every
> boot:
>
>      bash/2330 is trying to acquire lock:
>      ffff88810e518548 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkcg_activate_p=
olicy+0x1ee/0xa00
>      but task is already holding lock:
>      ffff88810e518060 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_f=
reeze_queue_nomemsave+0xd/0x20
>
>      Chain exists of:
>      &q->blkcg_mutex --> fs_reclaim --> &q->q_usage_counter
>
> GFP_NOIO keeps direct writeback out of reclaim, so an actual hang
> looks hard to hit -- but the splat fires on a very common operation.

This is a known problem, and there is also a known problem to call pd_alloc=
_fn() while
queue is frozen, because percpu allocation there can trigger lockdep deadlo=
ck as well.

>
> Could the two-phase allocation already used for pd_prealloc in
> blkcg_activate_policy() also apply to blkg_create()? I.e. try
> GFP_NOWAIT under blkcg_mutex, and if that fails drop the mutex,
> preallocate with GFP_KERNEL and retry. I think that drops the
> blkcg_mutex -> fs_reclaim edge, but I may be missing something.

I'm afraid not, this is not the plan to fix the deadlock, the plan for the =
order is:

1) hold blkcg_mutex first;
2) allocate memory, including blkg and pd_alloc_fn;
3) queue freeze;
4) pd_init_fn and make blkg online;

>
> Thanks,
> Tao
>
>>   	/* link parent */
>>   	if (blkcg_parent(blkcg)) {
>>   		rcu_read_lock();
>>   		blkg->parent =3D blkg_lookup(blkcg_parent(blkcg), disk->queue);
>> @@ -461,12 +453,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *=
blkcg, struct gendisk *disk,
>>   	/* @blkg failed fully initialized, use the usual release path */
>>   	percpu_ref_kill(&blkg->refcnt);
>>   	return ERR_PTR(ret);
>>  =20
>>   err_free_blkg:
>> -	if (new_blkg)
>> -		blkg_free(new_blkg);
>> +	if (blkg)
>> +		blkg_free(blkg);
>>   	return ERR_PTR(ret);
>>   }
>>  =20
>>   /*
>>    * The root blkg holds a live reference while the disk is active, so w=
alking
>> @@ -531,11 +523,11 @@ static struct blkcg_gq *blkg_lookup_create(struct =
blkcg *blkcg,
>>   			pos =3D parent;
>>   			parent =3D blkcg_parent(parent);
>>   		}
>>   		rcu_read_unlock();
>>  =20
>> -		blkg =3D blkg_create(pos, disk, NULL);
>> +		blkg =3D blkg_create(pos, disk, GFP_NOIO);
>>   		if (IS_ERR(blkg)) {
>>   			blkg =3D ret_blkg;
>>   			break;
>>   		}
>>   		if (pos =3D=3D blkcg)
>> @@ -865,39 +857,29 @@ int blkg_conf_prep(struct blkcg *blkcg, const stru=
ct blkcg_policy *pol,
>>   	 * non-root blkgs have access to their parents.
>>   	 */
>>   	while (true) {
>>   		struct blkcg *pos =3D blkcg;
>>   		struct blkcg *parent;
>> -		struct blkcg_gq *new_blkg;
>>  =20
>>   		parent =3D blkcg_parent(blkcg);
>>   		rcu_read_lock();
>>   		while (parent && !blkg_lookup(parent, q)) {
>>   			pos =3D parent;
>>   			parent =3D blkcg_parent(parent);
>>   		}
>>   		rcu_read_unlock();
>>  =20
>> -		new_blkg =3D blkg_alloc(pos, disk, GFP_NOIO);
>> -		if (unlikely(!new_blkg)) {
>> -			ret =3D -ENOMEM;
>> -			goto fail_unlock;
>> -		}
>> -
>>   		if (!blkcg_policy_enabled(q, pol)) {
>> -			blkg_free(new_blkg);
>>   			ret =3D -EOPNOTSUPP;
>>   			goto fail_unlock;
>>   		}
>>  =20
>>   		rcu_read_lock();
>>   		blkg =3D blkg_lookup(pos, q);
>>   		rcu_read_unlock();
>> -		if (blkg) {
>> -			blkg_free(new_blkg);
>> -		} else {
>> -			blkg =3D blkg_create(pos, disk, new_blkg);
>> +		if (!blkg) {
>> +			blkg =3D blkg_create(pos, disk, GFP_NOIO);
>>   			if (IS_ERR(blkg)) {
>>   				ret =3D PTR_ERR(blkg);
>>   				goto fail_unlock;
>>   			}
>>   		}
>> @@ -1466,27 +1448,23 @@ void blkg_exit_queue(struct request_queue *q)
>>   }
>>  =20
>>   int blkcg_init_disk(struct gendisk *disk)
>>   {
>>   	struct request_queue *q =3D disk->queue;
>> -	struct blkcg_gq *new_blkg, *blkg;
>> +	struct blkcg_gq *blkg;
>>  =20
>>   	/*
>>   	 * If the queue is shared across disk rebind (e.g., SCSI), the
>>   	 * previous disk's blkcg state is cleaned up asynchronously via
>>   	 * disk_release() -> blkcg_exit_disk(). Wait for all old blkgs to be
>>   	 * removed from the queue list before setting up new blkcg state.
>>   	 */
>>   	wait_var_event(&q->blkg_list, list_empty_careful(&q->blkg_list));
>>  =20
>> -	new_blkg =3D blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
>> -	if (!new_blkg)
>> -		return -ENOMEM;
>> -
>>   	/* Make sure the root blkg exists. */
>>   	mutex_lock(&q->blkcg_mutex);
>> -	blkg =3D blkg_create(&blkcg_root, disk, new_blkg);
>> +	blkg =3D blkg_create(&blkcg_root, disk, GFP_KERNEL);
>>   	if (IS_ERR(blkg))
>>   		goto err_unlock;
>>   	q->root_blkg =3D blkg;
>>   	mutex_unlock(&q->blkcg_mutex);
>>  =20

--=20
Thanks,
Kuai
