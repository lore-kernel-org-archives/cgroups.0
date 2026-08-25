Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A92D5C83
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 01:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787621725; cv=none; b=lAdFpr8G9gDGVHhD7KVnqMacEXGbj0lWo9sfKpzkYtK9cqn6vkaivLabLSIFcZt/I9LuEi4Zp0+CO0YYcu+0MmjaltMh2AI9N1asCvAw8ry4xgD8uLw4hTW+spjE6veuh5fWpfIFSD2F4rWVqQIdOKNHlly3b/lCobwFTcJD36U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787621725; c=relaxed/simple;
	bh=p5lPbK2jlF4D2oJ2mfcXZ3A9mwzMgb9oUbrKUKKpWp0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RAlHLX1J7aWkqc5ivb2XCppm8xCw8aPq6nt0vWG3CJtvKZ8YfYXJcjf9vYrjscpq0B4vI+mmJjuzM9sUeZlm9Pe0kTI/rqhw6LrcBPJO/QeXc5HVWPjcfCyard3R2xb7mjbYnsgbvB1F5lCIq8UnepKOsoMWD+ul5Xocavxw8t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UKATGl9B; arc=none smtp.client-ip=95.215.58.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UKATGl9B"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=p5lPbK2jlF4D2oJ2mfcXZ3A9mwzMgb9oUbrKUKKpWp0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787621719; v=1; x=1788226519;
 b=UKATGl9BSUOD98DW5vwdHiWFWkFffkE9hulXm26fnCPMk0MASZYU9o5f967ciWT5402rJBiU
 bpdonXDu3QYMfcP0hMkA0nZKhbbwpVjr/lt9bzGf21Se6q11SzXOpOQKTw2iIwoQUC10UZi0DmO
 F6unTmr8ewL7abLjFwv9csGk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.110.173] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 84308079bb73c8cc;
	Tue, 25 Aug 2026 01:35:10 +0000
X-Mizu-Trace-ID: 84308079bb73c8cc
X-Migadu-Flow: FLOW_OUT
Message-ID: <ca5c6c43-b6e6-48f3-9e3b-6d5f8b1538c8@linux.dev>
Date: Tue, 25 Aug 2026 09:35:00 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@fygo.io>,
 Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
 Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 4/6] blk-cgroup: allocate blkgs in blkg_create
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <20260823152926.1043863-1-yukuai@kernel.org>
 <20260823152926.1043863-5-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260823152926.1043863-5-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

在 2026/8/23 23:29, Yu Kuai 写道:
> From: Yu Kuai <yukuai@fygo.io>
> 
> Move blkg allocation into blkg_create() and have it take a gfp_t mask, so
> that the caller controls whether creation may sleep. blkg_create() now
> always allocates the blkg itself instead of sometimes receiving a
> preallocated one, which lets the lookup and config paths drop their open-
> coded preallocation and retry loops.
> 
> blkg_lookup_create() and the root-blkg setup use GFP_NOIO (or GFP_KERNEL
> for the root) so they do not recurse into IO reclaim; the nowait policy
> path added later will use GFP_ATOMIC.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>  block/blk-cgroup.c | 48 +++++++++++++---------------------------------
>  1 file changed, 13 insertions(+), 35 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 0f34a80a726d..33fba781017b 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -383,37 +383,29 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
>  out_free_blkg:
>  	kfree(blkg);
>  	return NULL;
>  }
>  
> -/*
> - * If @new_blkg is %NULL, this function tries to allocate a new one as
> - * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
> - */
>  static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
> -				    struct blkcg_gq *new_blkg)
> +				    gfp_t gfp_mask)
>  {
> -	struct blkcg_gq *blkg;
> +	struct blkcg_gq *blkg = NULL;
>  	int i, ret;
>  
>  	lockdep_assert_held(&disk->queue->blkcg_mutex);
>  
>  	/* request_queue is dying, do not create/recreate a blkg */
>  	if (blk_queue_dying(disk->queue)) {
>  		ret = -ENODEV;
>  		goto err_free_blkg;
>  	}
>  

Reading patch 4/6, one thing looked off to me. Before the series,
blkg_create() allocated with GFP_NOWAIT under queue_lock, or took a
caller-preallocated object. After patches 3+4, it allocates with the
passed gfp_mask while holding blkcg_mutex:

> -	/* allocate */
> -	if (!new_blkg) {
> -		new_blkg = blkg_alloc(blkcg, disk, GFP_NOWAIT);
> -		if (unlikely(!new_blkg)) {
> -			ret = -ENOMEM;
> -			goto err_free_blkg;
> -		}
> +	blkg = blkg_alloc(blkcg, disk, gfp_mask);
> +	if (unlikely(!blkg)) {
> +		ret = -ENOMEM;
> +		goto err_free_blkg;
>  	}
> -	blkg = new_blkg;
>  

(patch 4 also makes blkg_lookup_create() pass GFP_NOIO for the
config path, where blkg_conf_prep() used to drop queue_lock before
allocating.)

blk_throtl_init() reaches blkcg_activate_policy() with the queue
frozen, so we can end up allocating (and entering reclaim) while
holding q_usage_counter -> blkcg_mutex. Reclaim can then add the
q_usage_counter edge from the disk probe side.

I booted the series in a VM with PROVE_LOCKDEP to check, and lockdep
does report a circular dependency on the first io.max write, every
boot:

    bash/2330 is trying to acquire lock:
    ffff88810e518548 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkcg_activate_policy+0x1ee/0xa00
    but task is already holding lock:
    ffff88810e518060 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_freeze_queue_nomemsave+0xd/0x20

    Chain exists of:
    &q->blkcg_mutex --> fs_reclaim --> &q->q_usage_counter

GFP_NOIO keeps direct writeback out of reclaim, so an actual hang
looks hard to hit -- but the splat fires on a very common operation.

Could the two-phase allocation already used for pd_prealloc in
blkcg_activate_policy() also apply to blkg_create()? I.e. try
GFP_NOWAIT under blkcg_mutex, and if that fails drop the mutex,
preallocate with GFP_KERNEL and retry. I think that drops the
blkcg_mutex -> fs_reclaim edge, but I may be missing something.

Thanks,
Tao

>  	/* link parent */
>  	if (blkcg_parent(blkcg)) {
>  		rcu_read_lock();
>  		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk->queue);
> @@ -461,12 +453,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
>  	/* @blkg failed fully initialized, use the usual release path */
>  	percpu_ref_kill(&blkg->refcnt);
>  	return ERR_PTR(ret);
>  
>  err_free_blkg:
> -	if (new_blkg)
> -		blkg_free(new_blkg);
> +	if (blkg)
> +		blkg_free(blkg);
>  	return ERR_PTR(ret);
>  }
>  
>  /*
>   * The root blkg holds a live reference while the disk is active, so walking
> @@ -531,11 +523,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
>  			pos = parent;
>  			parent = blkcg_parent(parent);
>  		}
>  		rcu_read_unlock();
>  
> -		blkg = blkg_create(pos, disk, NULL);
> +		blkg = blkg_create(pos, disk, GFP_NOIO);
>  		if (IS_ERR(blkg)) {
>  			blkg = ret_blkg;
>  			break;
>  		}
>  		if (pos == blkcg)
> @@ -865,39 +857,29 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
>  	 * non-root blkgs have access to their parents.
>  	 */
>  	while (true) {
>  		struct blkcg *pos = blkcg;
>  		struct blkcg *parent;
> -		struct blkcg_gq *new_blkg;
>  
>  		parent = blkcg_parent(blkcg);
>  		rcu_read_lock();
>  		while (parent && !blkg_lookup(parent, q)) {
>  			pos = parent;
>  			parent = blkcg_parent(parent);
>  		}
>  		rcu_read_unlock();
>  
> -		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
> -		if (unlikely(!new_blkg)) {
> -			ret = -ENOMEM;
> -			goto fail_unlock;
> -		}
> -
>  		if (!blkcg_policy_enabled(q, pol)) {
> -			blkg_free(new_blkg);
>  			ret = -EOPNOTSUPP;
>  			goto fail_unlock;
>  		}
>  
>  		rcu_read_lock();
>  		blkg = blkg_lookup(pos, q);
>  		rcu_read_unlock();
> -		if (blkg) {
> -			blkg_free(new_blkg);
> -		} else {
> -			blkg = blkg_create(pos, disk, new_blkg);
> +		if (!blkg) {
> +			blkg = blkg_create(pos, disk, GFP_NOIO);
>  			if (IS_ERR(blkg)) {
>  				ret = PTR_ERR(blkg);
>  				goto fail_unlock;
>  			}
>  		}
> @@ -1466,27 +1448,23 @@ void blkg_exit_queue(struct request_queue *q)
>  }
>  
>  int blkcg_init_disk(struct gendisk *disk)
>  {
>  	struct request_queue *q = disk->queue;
> -	struct blkcg_gq *new_blkg, *blkg;
> +	struct blkcg_gq *blkg;
>  
>  	/*
>  	 * If the queue is shared across disk rebind (e.g., SCSI), the
>  	 * previous disk's blkcg state is cleaned up asynchronously via
>  	 * disk_release() -> blkcg_exit_disk(). Wait for all old blkgs to be
>  	 * removed from the queue list before setting up new blkcg state.
>  	 */
>  	wait_var_event(&q->blkg_list, list_empty_careful(&q->blkg_list));
>  
> -	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
> -	if (!new_blkg)
> -		return -ENOMEM;
> -
>  	/* Make sure the root blkg exists. */
>  	mutex_lock(&q->blkcg_mutex);
> -	blkg = blkg_create(&blkcg_root, disk, new_blkg);
> +	blkg = blkg_create(&blkcg_root, disk, GFP_KERNEL);
>  	if (IS_ERR(blkg))
>  		goto err_unlock;
>  	q->root_blkg = blkg;
>  	mutex_unlock(&q->blkcg_mutex);
>  

