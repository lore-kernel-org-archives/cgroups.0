Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F4431A49
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 07:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311692; cv=none; b=HHxt2o4kij5fv81903TRp4T5Kp25Phf/VTdJiPTEZe4kmNARV+mJC3AmyCfd8ThRaoPqpGYqjFg97TlyqSSzKdwBs5k8GyWAvBq8SC1CUnnllZ4fD/9v7lQoeyIIKv4SLWYLXWymdp+WYCn8MCGoM5VRYWiIBTl6tF3ZaM9fKT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311692; c=relaxed/simple;
	bh=2D4qAyJNWTIObVRpTT2BkVkAK/bhjbaS0ihJmBXMOv4=;
	h=References:Content-Type:To:From:Mime-Version:Subject:Message-Id:
	 Cc:Date:In-Reply-To; b=eV2CEsNZ6UZCKSqMth6sKWWrWTrvnTRdGzcIAY7/xggLMUtd9tlIOnZodp8F16DrDD3Z00zrv+nk1xvdjF8QtjhGf38Uq/kz8slQtPp9tcDaXwRhPrYEdlSy4GA8kJ7vJLzFuzb0YMDWzKq7nWj0ABxwAAD3T13gJWlE4JQOHRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=UNoLl5/S; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="UNoLl5/S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785311679;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1cfueyFgHKkgjZ15WjasvQoLRQhcWtGX4/4nLQe1Ovo=;
 b=UNoLl5/SMSRH+StanSKWMUzGYkl6UrU+bHloWu538eZ4o4kygdsPTSJkuglCUaNyvcK4eS
 nI4K6IXKeTzvz9A9MyQ8q5RGBWqugF9A2ZCe2DDqOULpHqZAvzP8piEPm66rYCFIXS/lV2
 Nw/30G0t4MFlySXV/F220l2NwP9iPkLxEAZx29F4c7GtIEQUTUN84wz9Il5R7uiN0Wxs/D
 qWlOFDedLFRek1wqXp/99I+F9GRZNqRXWL/N9UIezmos803Cxv+vFF4oPm+NtyrfLiyIgL
 40Jvh5rh1AAGDc/EAEtMp9AVGdV1M1ZTLC9h5ybejt5S2uVlGN7+F06sl+75YQ==
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 07:54:37 +0000
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-4-yukuai@kernel.org> <d093d6be-1399-4cb9-9b3a-25518d60e801@linux.dev>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
To: "Tao Cui" <cui.tao@linux.dev>, <axboe@kernel.dk>, <tj@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v2 3/8] blk-cgroup: protect blkgs with blkcg_mutex
Message-Id: <f7b04137-fea8-474a-8bc2-a27dccdb007e@fygo.io>
User-Agent: Mozilla Thunderbird
Cc: <hch@lst.de>, <dongsheng.yang@linux.dev>, <cengku@gmail.com>, 
	<josef@toxicpanda.com>, <nilay@linux.ibm.com>, <ming.lei@redhat.com>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>
Date: Wed, 29 Jul 2026 15:54:33 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <d093d6be-1399-4cb9-9b3a-25518d60e801@linux.dev>
X-Lms-Return-Path: <lba+26a69b1be+be37fa+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/29 15:29, Tao Cui =E5=86=99=E9=81=93:
>
> =E5=9C=A8 2026/7/24 20:30, Yu Kuai =E5=86=99=E9=81=93:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> queue_lock is still needed by block core users, but blkcg no longer need=
s
>> it for blkg topology now that throttle runtime state has a private lock.
>>
>> Move queue-local blkg synchronization to q->blkcg_mutex.  Hold it while
>> looking up, creating and destroying blkgs, while preparing and undoing
>> configuration, and while activating or deactivating policies.
>>
>> Update the BFQ, iocost, iolatency and throttle paths which walk
>> q->blkg_list or access per-blkg policy state to use the same lock.
>>
>> blkcg->lock still protects blkcg-local radix tree and list updates.  Som=
e
>> lookups under blkcg_mutex can race with blkcg updates done for other
>> queues, so keep those lookups in RCU read-side critical sections.  In
>> particular, protect the parent lookup in blkg_create() and the parent wa=
lk
>> in blkg_lookup_create().
>>
>> Now that blkg association happens from the sleepable submit path, the
>> queue_lock -> blkcg_mutex conversion lets blkg creation sleep properly.
>> Nowait bio handling (failing submit instead of sleeping) is added in a
>> follow-up patch.
>>
> Hi Yu Kuai,
>
> Quick question on the async blkg free path: it now holds the new mutex
> across the per-policy teardown, which can sleep (iocost does timer shutdo=
wn
> in there, for instance).  Since first-IO blkg creation also takes this mu=
tex
> now -- it used to be the queue spinlock -- could a first IO for a cgroup =
end
> up waiting on an unrelated cgroup's blkg being torn down on the workqueue=
?
> Not sure it matters in practice; just wondering whether that's a concern =
at
> all, or if I'm overreading how long the mutex is held.

I don't think waiting is a problem here in practice, as you said only the f=
irst IO
for a cgroup will try to hold the mutex.

>
> Thanks,
> Tao> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>>   block/bfq-cgroup.c    |  10 +--
>>   block/blk-cgroup.c    | 182 ++++++++++++++++++++++--------------------
>>   block/blk-cgroup.h    |  16 ++--
>>   block/blk-core.c      |   2 +
>>   block/blk-iocost.c    |   5 +-
>>   block/blk-iolatency.c |   7 +-
>>   block/blk-throttle.c  |  10 +--
>>   7 files changed, 121 insertions(+), 111 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index e82ff03bda02..42614aa78cd4 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -426,7 +426,7 @@ static void bfqg_stats_xfer_dead(struct bfq_group *b=
fqg)
>>  =20
>>   	parent =3D bfqg_parent(bfqg);
>>  =20
>> -	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->queue_lock);
>> +	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->blkcg_mutex);
>>  =20
>>   	if (unlikely(!parent))
>>   		return;
>> @@ -874,7 +874,7 @@ static void bfq_reparent_active_queues(struct bfq_da=
ta *bfqd,
>>    *		    and reparent its children entities.
>>    * @pd: descriptor of the policy going offline.
>>    *
>> - * blkio already grabs the queue_lock for us, so no need to use
>> + * blkio already grabs the blkcg_mutex for us, so no need to use
>>    * RCU-based magic
>>    */
>>   static void bfq_pd_offline(struct blkg_policy_data *pd)
>> @@ -947,8 +947,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
>>   	struct blkcg_gq *blkg;
>>  =20
>>   	mutex_lock(&q->blkcg_mutex);
>> -	spin_lock_irq(&q->queue_lock);
>> -	spin_lock(&bfqd->lock);
>> +	spin_lock_irq(&bfqd->lock);
>>  =20
>>   	list_for_each_entry(blkg, &q->blkg_list, q_node) {
>>   		struct bfq_group *bfqg =3D blkg_to_bfqg(blkg);
>> @@ -957,8 +956,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
>>   	}
>>   	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
>>  =20
>> -	spin_unlock(&bfqd->lock);
>> -	spin_unlock_irq(&q->queue_lock);
>> +	spin_unlock_irq(&bfqd->lock);
>>   	mutex_unlock(&q->blkcg_mutex);
>>   }
>>  =20
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 618e5566fa52..03e1d4d34921 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -131,9 +131,7 @@ static void blkg_free_workfn(struct work_struct *wor=
k)
>>   			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
>>   	if (blkg->parent)
>>   		blkg_put(blkg->parent);
>> -	spin_lock_irq(&q->queue_lock);
>>   	list_del_init(&blkg->q_node);
>> -	spin_unlock_irq(&q->queue_lock);
>>   	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	/*
>> @@ -382,7 +380,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg, struct gendisk *disk,
>>   	struct blkcg_gq *blkg;
>>   	int i, ret;
>>  =20
>> -	lockdep_assert_held(&disk->queue->queue_lock);
>> +	lockdep_assert_held(&disk->queue->blkcg_mutex);
>>  =20
>>   	/* request_queue is dying, do not create/recreate a blkg */
>>   	if (blk_queue_dying(disk->queue)) {
>> @@ -402,12 +400,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *=
blkcg, struct gendisk *disk,
>>  =20
>>   	/* link parent */
>>   	if (blkcg_parent(blkcg)) {
>> +		rcu_read_lock();
>>   		blkg->parent =3D blkg_lookup(blkcg_parent(blkcg), disk->queue);
>>   		if (WARN_ON_ONCE(!blkg->parent)) {
>> +			rcu_read_unlock();
>>   			ret =3D -ENODEV;
>>   			goto err_free_blkg;
>>   		}
>>   		blkg_get(blkg->parent);
>> +		rcu_read_unlock();
>>   	}
>>  =20
>>   	/* invoke per-policy init */
>> @@ -419,7 +420,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg, struct gendisk *disk,
>>   	}
>>  =20
>>   	/* insert */
>> -	spin_lock(&blkcg->lock);
>> +	spin_lock_irq(&blkcg->lock);
>>   	ret =3D radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
>>   	if (likely(!ret)) {
>>   		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
>> @@ -436,7 +437,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg, struct gendisk *disk,
>>   		}
>>   		blkg->online =3D true;
>>   	}
>> -	spin_unlock(&blkcg->lock);
>> +	spin_unlock_irq(&blkcg->lock);
>>  =20
>>   	if (!ret)
>>   		return blkg;
>> @@ -459,7 +460,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *bl=
kcg, struct gendisk *disk,
>>    * Lookup blkg for the @blkcg - @disk pair.  If it doesn't exist, try =
to
>>    * create one.  blkg creation is performed recursively from blkcg_root=
 such
>>    * that all non-root blkg's have access to the parent blkg.  This func=
tion
>> - * should be called under RCU read lock and takes @disk->queue->queue_l=
ock.
>> + * must be called with @disk->queue->blkcg_mutex held.
>>    *
>>    * Returns the blkg or the closest blkg if blkg_create() fails as it w=
alks
>>    * down from root.
>> @@ -491,6 +492,7 @@ static struct blkcg_gq *blkg_lookup_create(struct bl=
kcg *blkcg,
>>   		struct blkcg *parent =3D blkcg_parent(blkcg);
>>   		struct blkcg_gq *ret_blkg =3D q->root_blkg;
>>  =20
>> +		rcu_read_lock();
>>   		while (parent) {
>>   			blkg =3D blkg_lookup(parent, q);
>>   			if (blkg) {
>> @@ -501,6 +503,7 @@ static struct blkcg_gq *blkg_lookup_create(struct bl=
kcg *blkcg,
>>   			pos =3D parent;
>>   			parent =3D blkcg_parent(parent);
>>   		}
>> +		rcu_read_unlock();
>>  =20
>>   		blkg =3D blkg_create(pos, disk, NULL);
>>   		if (IS_ERR(blkg)) {
>> @@ -519,7 +522,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>>   	struct blkcg *blkcg =3D blkg->blkcg;
>>   	int i;
>>  =20
>> -	lockdep_assert_held(&blkg->q->queue_lock);
>> +	lockdep_assert_held(&blkg->q->blkcg_mutex);
>>   	lockdep_assert_held(&blkcg->lock);
>>  =20
>>   	/*
>> @@ -547,8 +550,8 @@ static void blkg_destroy(struct blkcg_gq *blkg)
>>   	hlist_del_init_rcu(&blkg->blkcg_node);
>>  =20
>>   	/*
>> -	 * Both setting lookup hint to and clearing it from @blkg are done
>> -	 * under queue_lock.  If it's not pointing to @blkg now, it never
>> +	 * Both setting lookup hint to and clearing it from @blkg are done und=
er
>> +	 * blkcg_mutex.  If it's not pointing to @blkg now, it never
>>   	 * will.  Hint assignment itself can race safely.
>>   	 */
>>   	if (rcu_access_pointer(blkcg->blkg_hint) =3D=3D blkg)
>> @@ -569,24 +572,21 @@ static void blkg_destroy_all(struct gendisk *disk)
>>   	int i;
>>  =20
>>   restart:
>> -	spin_lock_irq(&q->queue_lock);
>> +	mutex_lock(&q->blkcg_mutex);
>>   	list_for_each_entry(blkg, &q->blkg_list, q_node) {
>>   		struct blkcg *blkcg =3D blkg->blkcg;
>>  =20
>>   		if (hlist_unhashed(&blkg->blkcg_node))
>>   			continue;
>>  =20
>> -		spin_lock(&blkcg->lock);
>> +		spin_lock_irq(&blkcg->lock);
>>   		blkg_destroy(blkg);
>> -		spin_unlock(&blkcg->lock);
>> +		spin_unlock_irq(&blkcg->lock);
>>  =20
>> -		/*
>> -		 * in order to avoid holding the spin lock for too long, release
>> -		 * it when a batch of blkgs are destroyed.
>> -		 */
>> +		/* Avoid holding blkcg_mutex for too long. */
>>   		if (!(--count)) {
>>   			count =3D BLKG_DESTROY_BATCH_SIZE;
>> -			spin_unlock_irq(&q->queue_lock);
>> +			mutex_unlock(&q->blkcg_mutex);
>>   			cond_resched();
>>   			goto restart;
>>   		}
>> @@ -605,7 +605,7 @@ static void blkg_destroy_all(struct gendisk *disk)
>>   	}
>>  =20
>>   	q->root_blkg =3D NULL;
>> -	spin_unlock_irq(&q->queue_lock);
>> +	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	wake_up_var(&q->root_blkg);
>>   }
>> @@ -822,8 +822,8 @@ EXPORT_SYMBOL_GPL(blkg_conf_open_bdev);
>>    * @ctx->blkg to the blkg being configured.
>>    *
>>    * blkg_conf_open_bdev() must be called on @ctx beforehand. On success=
, this
>> - * function returns with queue lock held and must be followed by
>> - * blkg_conf_close_bdev().
>> + * function returns with blkcg_mutex held and must be followed by
>> + * blkg_conf_unprep().
>>    */
>>   int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol=
,
>>   		   struct blkg_conf_ctx *ctx)
>> @@ -841,7 +841,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct=
 blkcg_policy *pol,
>>  =20
>>   	/* Prevent concurrent with blkcg_deactivate_policy() */
>>   	mutex_lock(&q->blkcg_mutex);
>> -	spin_lock_irq(&q->queue_lock);
>>  =20
>>   	if (!blkcg_policy_enabled(q, pol)) {
>>   		ret =3D -EOPNOTSUPP;
>> @@ -862,35 +861,34 @@ int blkg_conf_prep(struct blkcg *blkcg, const stru=
ct blkcg_policy *pol,
>>   		struct blkcg_gq *new_blkg;
>>  =20
>>   		parent =3D blkcg_parent(blkcg);
>> +		rcu_read_lock();
>>   		while (parent && !blkg_lookup(parent, q)) {
>>   			pos =3D parent;
>>   			parent =3D blkcg_parent(parent);
>>   		}
>> -
>> -		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
>> -		spin_unlock_irq(&q->queue_lock);
>> +		rcu_read_unlock();
>>  =20
>>   		new_blkg =3D blkg_alloc(pos, disk, GFP_NOIO);
>>   		if (unlikely(!new_blkg)) {
>>   			ret =3D -ENOMEM;
>> -			goto fail_exit;
>> +			goto fail_unlock;
>>   		}
>>  =20
>>   		if (radix_tree_preload(GFP_KERNEL)) {
>>   			blkg_free(new_blkg);
>>   			ret =3D -ENOMEM;
>> -			goto fail_exit;
>> +			goto fail_unlock;
>>   		}
>>  =20
>> -		spin_lock_irq(&q->queue_lock);
>> -
>>   		if (!blkcg_policy_enabled(q, pol)) {
>>   			blkg_free(new_blkg);
>>   			ret =3D -EOPNOTSUPP;
>>   			goto fail_preloaded;
>>   		}
>>  =20
>> +		rcu_read_lock();
>>   		blkg =3D blkg_lookup(pos, q);
>> +		rcu_read_unlock();
>>   		if (blkg) {
>>   			blkg_free(new_blkg);
>>   		} else {
>> @@ -907,15 +905,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const stru=
ct blkcg_policy *pol,
>>   			goto success;
>>   	}
>>   success:
>> -	mutex_unlock(&q->blkcg_mutex);
>>   	ctx->blkg =3D blkg;
>>   	return 0;
>>  =20
>>   fail_preloaded:
>>   	radix_tree_preload_end();
>>   fail_unlock:
>> -	spin_unlock_irq(&q->queue_lock);
>> -fail_exit:
>>   	mutex_unlock(&q->blkcg_mutex);
>>   	/*
>>   	 * If queue was bypassing, we should retry.  Do so after a
>> @@ -938,7 +933,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
>>   void blkg_conf_unprep(struct blkg_conf_ctx *ctx)
>>   {
>>   	WARN_ON_ONCE(!ctx->blkg);
>> -	spin_unlock_irq(&ctx->bdev->bd_disk->queue->queue_lock);
>> +	mutex_unlock(&ctx->bdev->bd_disk->queue->blkcg_mutex);
>>   	ctx->blkg =3D NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(blkg_conf_unprep);
>> @@ -1258,8 +1253,9 @@ static struct blkcg_gq *blkcg_get_first_blkg(struc=
t blkcg *blkcg)
>>    * blkcg_destroy_blkgs - responsible for shooting down blkgs
>>    * @blkcg: blkcg of interest
>>    *
>> - * blkgs should be removed while holding both q and blkcg locks.  As bl=
kcg lock
>> - * is nested inside q lock, this function performs reverse double lock =
dancing.
>> + * blkgs should be removed while holding both q->blkcg_mutex and blkcg-=
>lock.
>> + * As blkcg->lock is nested inside q->blkcg_mutex, this function perfor=
ms
>> + * reverse double lock dancing.
>>    * Destroying the blkgs releases the reference held on the blkcg's css=
 allowing
>>    * blkcg_css_free to eventually be called.
>>    *
>> @@ -1274,13 +1270,13 @@ static void blkcg_destroy_blkgs(struct blkcg *bl=
kcg)
>>   	while ((blkg =3D blkcg_get_first_blkg(blkcg))) {
>>   		struct request_queue *q =3D blkg->q;
>>  =20
>> -		spin_lock_irq(&q->queue_lock);
>> -		spin_lock(&blkcg->lock);
>> +		mutex_lock(&q->blkcg_mutex);
>> +		spin_lock_irq(&blkcg->lock);
>>  =20
>>   		blkg_destroy(blkg);
>>  =20
>> -		spin_unlock(&blkcg->lock);
>> -		spin_unlock_irq(&q->queue_lock);
>> +		spin_unlock_irq(&blkcg->lock);
>> +		mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   		blkg_put(blkg);
>>   		cond_resched();
>> @@ -1472,21 +1468,20 @@ int blkcg_init_disk(struct gendisk *disk)
>>   	preloaded =3D !radix_tree_preload(GFP_KERNEL);
>>  =20
>>   	/* Make sure the root blkg exists. */
>> -	/* spin_lock_irq can serve as RCU read-side critical section. */
>> -	spin_lock_irq(&q->queue_lock);
>> +	mutex_lock(&q->blkcg_mutex);
>>   	blkg =3D blkg_create(&blkcg_root, disk, new_blkg);
>>   	if (IS_ERR(blkg))
>>   		goto err_unlock;
>>   	q->root_blkg =3D blkg;
>> -	spin_unlock_irq(&q->queue_lock);
>>  =20
>>   	if (preloaded)
>>   		radix_tree_preload_end();
>> +	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	return 0;
>>  =20
>>   err_unlock:
>> -	spin_unlock_irq(&q->queue_lock);
>> +	mutex_unlock(&q->blkcg_mutex);
>>   	if (preloaded)
>>   		radix_tree_preload_end();
>>   	return PTR_ERR(blkg);
>> @@ -1526,6 +1521,42 @@ struct cgroup_subsys io_cgrp_subsys =3D {
>>   };
>>   EXPORT_SYMBOL_GPL(io_cgrp_subsys);
>>  =20
>> +static void blkg_free_policy_data(struct blkcg_gq *blkg,
>> +				  const struct blkcg_policy *pol)
>> +{
>> +	struct blkcg *blkcg =3D blkg->blkcg;
>> +	struct blkg_policy_data *pd;
>> +	bool online =3D false;
>> +
>> +	lockdep_assert_held(&blkg->q->blkcg_mutex);
>> +
>> +	/*
>> +	 * ->pd_offline_fn() may need blkg->pd[] to stay installed, while
>> +	 * ->pd_free_fn() can sleep.  Mark offline under blkcg->lock, run
>> +	 * the offline callback, detach under blkcg->lock, then free.
>> +	 */
>> +	spin_lock_irq(&blkcg->lock);
>> +	pd =3D blkg->pd[pol->plid];
>> +	if (pd) {
>> +		online =3D pd->online;
>> +		pd->online =3D false;
>> +	}
>> +	spin_unlock_irq(&blkcg->lock);
>> +
>> +	if (!pd)
>> +		return;
>> +
>> +	if (online && pol->pd_offline_fn)
>> +		pol->pd_offline_fn(pd);
>> +
>> +	spin_lock_irq(&blkcg->lock);
>> +	WARN_ON_ONCE(blkg->pd[pol->plid] !=3D pd);
>> +	WRITE_ONCE(blkg->pd[pol->plid], NULL);
>> +	spin_unlock_irq(&blkcg->lock);
>> +
>> +	pol->pd_free_fn(pd);
>> +}
>> +
>>   /**
>>    * blkcg_activate_policy - activate a blkcg policy on a gendisk
>>    * @disk: gendisk of interest
>> @@ -1535,9 +1566,9 @@ EXPORT_SYMBOL_GPL(io_cgrp_subsys);
>>    * bypass mode to populate its blkgs with policy_data for @pol.
>>    *
>>    * Activation happens with @disk bypassed, so nobody would be accessin=
g blkgs
>> - * from IO path.  Update of each blkg is protected by both queue and bl=
kcg
>> - * locks so that holding either lock and testing blkcg_policy_enabled()=
 is
>> - * always enough for dereferencing policy data.
>> + * from IO path.  Update of each blkg is protected by q->blkcg_mutex an=
d
>> + * blkcg->lock so that holding either lock and testing blkcg_policy_ena=
bled()
>> + * is always enough for dereferencing policy data.
>>    *
>>    * The caller is responsible for synchronizing [de]activations and pol=
icy
>>    * [un]registerations.  Returns 0 on success, -errno on failure.
>> @@ -1563,8 +1594,9 @@ int blkcg_activate_policy(struct gendisk *disk, co=
nst struct blkcg_policy *pol)
>>  =20
>>   	if (queue_is_mq(q))
>>   		memflags =3D blk_mq_freeze_queue(q);
>> +
>>   retry:
>> -	spin_lock_irq(&q->queue_lock);
>> +	mutex_lock(&q->blkcg_mutex);
>>  =20
>>   	/* blkg_list is pushed at the head, reverse walk to initialize parent=
s first */
>>   	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
>> @@ -1572,14 +1604,15 @@ int blkcg_activate_policy(struct gendisk *disk, =
const struct blkcg_policy *pol)
>>  =20
>>   		if (blkg->pd[pol->plid])
>>   			continue;
>> +		if (hlist_unhashed(&blkg->blkcg_node))
>> +			continue;
>>  =20
>> -		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
>> +		/* If prealloc matches, use it; otherwise try GFP_NOWAIT. */
>>   		if (blkg =3D=3D pinned_blkg) {
>>   			pd =3D pd_prealloc;
>>   			pd_prealloc =3D NULL;
>>   		} else {
>> -			pd =3D pol->pd_alloc_fn(disk, blkg->blkcg,
>> -					      GFP_NOWAIT);
>> +			pd =3D pol->pd_alloc_fn(disk, blkg->blkcg, GFP_NOWAIT);
>>   		}
>>  =20
>>   		if (!pd) {
>> @@ -1592,7 +1625,7 @@ int blkcg_activate_policy(struct gendisk *disk, co=
nst struct blkcg_policy *pol)
>>   			blkg_get(blkg);
>>   			pinned_blkg =3D blkg;
>>  =20
>> -			spin_unlock_irq(&q->queue_lock);
>> +			mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   			if (pd_prealloc)
>>   				pol->pd_free_fn(pd_prealloc);
>> @@ -1600,11 +1633,10 @@ int blkcg_activate_policy(struct gendisk *disk, =
const struct blkcg_policy *pol)
>>   						       GFP_KERNEL);
>>   			if (pd_prealloc)
>>   				goto retry;
>> -			else
>> -				goto enomem;
>> +			goto enomem;
>>   		}
>>  =20
>> -		spin_lock(&blkg->blkcg->lock);
>> +		spin_lock_irq(&blkg->blkcg->lock);
>>  =20
>>   		pd->blkg =3D blkg;
>>   		pd->plid =3D pol->plid;
>> @@ -1617,14 +1649,14 @@ int blkcg_activate_policy(struct gendisk *disk, =
const struct blkcg_policy *pol)
>>   			pol->pd_online_fn(pd);
>>   		pd->online =3D true;
>>  =20
>> -		spin_unlock(&blkg->blkcg->lock);
>> +		spin_unlock_irq(&blkg->blkcg->lock);
>>   	}
>>  =20
>>   	__set_bit(pol->plid, q->blkcg_pols);
>>   	ret =3D 0;
>>  =20
>> -	spin_unlock_irq(&q->queue_lock);
>>   out:
>> +	mutex_unlock(&q->blkcg_mutex);
>>   	if (queue_is_mq(q))
>>   		blk_mq_unfreeze_queue(q, memflags);
>>   	if (pinned_blkg)
>> @@ -1635,23 +1667,9 @@ int blkcg_activate_policy(struct gendisk *disk, c=
onst struct blkcg_policy *pol)
>>  =20
>>   enomem:
>>   	/* alloc failed, take down everything */
>> -	spin_lock_irq(&q->queue_lock);
>> -	list_for_each_entry(blkg, &q->blkg_list, q_node) {
>> -		struct blkcg *blkcg =3D blkg->blkcg;
>> -		struct blkg_policy_data *pd;
>> -
>> -		spin_lock(&blkcg->lock);
>> -		pd =3D blkg->pd[pol->plid];
>> -		if (pd) {
>> -			if (pd->online && pol->pd_offline_fn)
>> -				pol->pd_offline_fn(pd);
>> -			pd->online =3D false;
>> -			pol->pd_free_fn(pd);
>> -			WRITE_ONCE(blkg->pd[pol->plid], NULL);
>> -		}
>> -		spin_unlock(&blkcg->lock);
>> -	}
>> -	spin_unlock_irq(&q->queue_lock);
>> +	mutex_lock(&q->blkcg_mutex);
>> +	list_for_each_entry(blkg, &q->blkg_list, q_node)
>> +		blkg_free_policy_data(blkg, pol);
>>   	ret =3D -ENOMEM;
>>   	goto out;
>>   }
>> @@ -1679,24 +1697,12 @@ void blkcg_deactivate_policy(struct gendisk *dis=
k,
>>   		memflags =3D blk_mq_freeze_queue(q);
>>  =20
>>   	mutex_lock(&q->blkcg_mutex);
>> -	spin_lock_irq(&q->queue_lock);
>>  =20
>>   	__clear_bit(pol->plid, q->blkcg_pols);
>>  =20
>> -	list_for_each_entry(blkg, &q->blkg_list, q_node) {
>> -		struct blkcg *blkcg =3D blkg->blkcg;
>> +	list_for_each_entry(blkg, &q->blkg_list, q_node)
>> +		blkg_free_policy_data(blkg, pol);
>>  =20
>> -		spin_lock(&blkcg->lock);
>> -		if (blkg->pd[pol->plid]) {
>> -			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
>> -				pol->pd_offline_fn(blkg->pd[pol->plid]);
>> -			pol->pd_free_fn(blkg->pd[pol->plid]);
>> -			blkg->pd[pol->plid] =3D NULL;
>> -		}
>> -		spin_unlock(&blkcg->lock);
>> -	}
>> -
>> -	spin_unlock_irq(&q->queue_lock);
>>   	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	if (queue_is_mq(q))
>> @@ -2087,11 +2093,11 @@ static inline struct blkcg_gq *blkg_tryget_close=
st(struct bio *bio,
>>   	 * Fast path failed, we're probably issuing IO in this cgroup the fir=
st
>>   	 * time, hold lock to create new blkg.
>>   	 */
>> -	spin_lock_irq(&q->queue_lock);
>> +	mutex_lock(&q->blkcg_mutex);
>>   	blkg =3D blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
>>   	if (blkg)
>>   		blkg =3D blkg_lookup_tryget(blkg);
>> -	spin_unlock_irq(&q->queue_lock);
>> +	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	return blkg;
>>   }
>> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> index 615390f751aa..5aaf2d54d17e 100644
>> --- a/block/blk-cgroup.h
>> +++ b/block/blk-cgroup.h
>> @@ -66,7 +66,7 @@ struct blkcg_gq {
>>   	/* reference count */
>>   	struct percpu_ref		refcnt;
>>  =20
>> -	/* is this blkg online? protected by both blkcg and q locks */
>> +	/* is this blkg online? protected by blkcg->lock and q->blkcg_mutex */
>>   	bool				online;
>>  =20
>>   	struct blkg_iostat_set __percpu	*iostat_cpu;
>> @@ -224,9 +224,9 @@ int blkg_conf_open_bdev(struct blkg_conf_ctx *ctx)
>>   	__cond_acquires(0, &ctx->bdev->bd_queue->rq_qos_mutex);
>>   int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol=
,
>>   		   struct blkg_conf_ctx *ctx)
>> -	__cond_acquires(0, &ctx->bdev->bd_disk->queue->queue_lock);
>> +	__cond_acquires(0, &ctx->bdev->bd_disk->queue->blkcg_mutex);
>>   void blkg_conf_unprep(struct blkg_conf_ctx *ctx)
>> -	__releases(ctx->bdev->bd_disk->queue->queue_lock);
>> +	__releases(ctx->bdev->bd_disk->queue->blkcg_mutex);
>>   void blkg_conf_close_bdev(struct blkg_conf_ctx *ctx)
>>   	__releases(&ctx->bdev->bd_queue->rq_qos_mutex);
>>  =20
>> @@ -255,7 +255,7 @@ static inline bool bio_issue_as_root_blkg(struct bio=
 *bio)
>>    *
>>    * Lookup blkg for the @blkcg - @q pair.
>>    *
>> - * Must be called in a RCU critical section.
>> + * Must be called in a RCU critical section or with q->blkcg_mutex held=
.
>>    */
>>   static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
>>   					   struct request_queue *q)
>> @@ -266,7 +266,7 @@ static inline struct blkcg_gq *blkg_lookup(struct bl=
kcg *blkcg,
>>   		return q->root_blkg;
>>  =20
>>   	blkg =3D rcu_dereference_check(blkcg->blkg_hint,
>> -			lockdep_is_held(&q->queue_lock));
>> +			lockdep_is_held(&q->blkcg_mutex));
>>   	if (blkg && blkg->q =3D=3D q)
>>   		return blkg;
>>  =20
>> @@ -350,9 +350,9 @@ static inline void blkg_put(struct blkcg_gq *blkg)
>>    * @p_blkg: target blkg to walk descendants of
>>    *
>>    * Walk @c_blkg through the descendants of @p_blkg.  Must be used with=
 RCU
>> - * read locked.  If called under either blkcg or queue lock, the iterat=
ion
>> - * is guaranteed to include all and only online blkgs.  The caller may
>> - * update @pos_css by calling css_rightmost_descendant() to skip subtre=
e.
>> + * read locked.  If called under either blkcg->lock or q->blkcg_mutex, =
the
>> + * iteration is guaranteed to include all and only online blkgs.  The c=
aller
>> + * may update @pos_css by calling css_rightmost_descendant() to skip su=
btree.
>>    * @p_blkg is included in the iteration and the first node to be visit=
ed.
>>    */
>>   #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 8103643b39fc..0a1d2b09a5d9 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -965,6 +965,8 @@ static void bio_set_ioprio(struct bio *bio)
>>    */
>>   void submit_bio(struct bio *bio)
>>   {
>> +	might_sleep();
>> +
>>   	if (bio_op(bio) =3D=3D REQ_OP_READ) {
>>   		task_io_account_read(bio->bi_iter.bi_size);
>>   		count_vm_events(PGPGIN, bio_sectors(bio));
>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>> index 8b2aeba2e1e3..ae50d143e4fc 100644
>> --- a/block/blk-iocost.c
>> +++ b/block/blk-iocost.c
>> @@ -3143,6 +3143,7 @@ static ssize_t ioc_weight_write(struct kernfs_open=
_file *of, char *buf,
>>   	struct blkg_conf_ctx ctx;
>>   	struct ioc_now now;
>>   	struct ioc_gq *iocg;
>> +	unsigned long flags;
>>   	u32 v;
>>   	int ret;
>>  =20
>> @@ -3195,11 +3196,11 @@ static ssize_t ioc_weight_write(struct kernfs_op=
en_file *of, char *buf,
>>   			goto unprep;
>>   	}
>>  =20
>> -	spin_lock(&iocg->ioc->lock);
>> +	spin_lock_irqsave(&iocg->ioc->lock, flags);
>>   	iocg->cfg_weight =3D v * WEIGHT_ONE;
>>   	ioc_now(iocg->ioc, &now);
>>   	weight_updated(iocg, &now);
>> -	spin_unlock(&iocg->ioc->lock);
>> +	spin_unlock_irqrestore(&iocg->ioc->lock, flags);
>>  =20
>>   	ret =3D 0;
>>  =20
>> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
>> index cef02b6c5fa9..30e23fee4f15 100644
>> --- a/block/blk-iolatency.c
>> +++ b/block/blk-iolatency.c
>> @@ -639,6 +639,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos=
)
>>   	timer_shutdown_sync(&blkiolat->timer);
>>   	flush_work(&blkiolat->enable_work);
>>   	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
>> +	flush_work(&blkiolat->enable_work);
>>   	kfree(blkiolat);
>>   }
>>  =20
>> @@ -811,16 +812,18 @@ static void iolatency_clear_scaling(struct blkcg_g=
q *blkg)
>>   	if (blkg->parent) {
>>   		struct iolatency_grp *iolat =3D blkg_to_lat(blkg->parent);
>>   		struct child_latency_info *lat_info;
>> +		unsigned long flags;
>> +
>>   		if (!iolat)
>>   			return;
>>  =20
>>   		lat_info =3D &iolat->child_lat;
>> -		spin_lock(&lat_info->lock);
>> +		spin_lock_irqsave(&lat_info->lock, flags);
>>   		atomic_set(&lat_info->scale_cookie, DEFAULT_SCALE_COOKIE);
>>   		lat_info->last_scale_event =3D 0;
>>   		lat_info->scale_grp =3D NULL;
>>   		lat_info->scale_lat =3D 0;
>> -		spin_unlock(&lat_info->lock);
>> +		spin_unlock_irqrestore(&lat_info->lock, flags);
>>   	}
>>   }
>>  =20
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 7bca2805404f..ef3edd5a4785 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -1777,10 +1777,10 @@ void blk_throtl_cancel_bios(struct gendisk *disk=
)
>>   	if (!blk_throtl_activated(q))
>>   		return;
>>  =20
>> -	spin_lock_irq(&q->queue_lock);
>> -	spin_lock(&td->lock);
>> +	mutex_lock(&q->blkcg_mutex);
>> +	spin_lock_irq(&td->lock);
>>   	/*
>> -	 * queue_lock is held, rcu lock is not needed here technically.
>> +	 * blkcg_mutex is held, rcu lock is not needed here technically.
>>   	 * However, rcu lock is still held to emphasize that following
>>   	 * path need RCU protection and to prevent warning from lockdep.
>>   	 */
>> @@ -1797,8 +1797,8 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
>>   		tg_cancel_writeback_bios(blkg_to_tg(blkg), cancel_bios);
>>   	}
>>   	rcu_read_unlock();
>> -	spin_unlock(&td->lock);
>> -	spin_unlock_irq(&q->queue_lock);
>> +	spin_unlock_irq(&td->lock);
>> +	mutex_unlock(&q->blkcg_mutex);
>>  =20
>>   	for (rw =3D READ; rw <=3D WRITE; rw++) {
>>   		struct bio *bio;

--=20
Thanks,
Kuai
