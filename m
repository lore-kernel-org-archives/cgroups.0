Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0C041DED0;
	Wed, 29 Jul 2026 07:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309863; cv=none; b=nd7M5O7LnSfDV6RCFbH5nxTiW71bn64IY1ituzLFAmFuc4j4mhRt1+AcIFWyVoscZnZONei0b9ZwRv+C3DRnVVlOiOZn1Nb00mshWHJP1V+WT0BRBP/OJmkbP0NIf1UH3gkTfD0tJzwMXElPHLcjDBg2A9sqZrlviASNGC642Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309863; c=relaxed/simple;
	bh=SoAJyejZXL0gCLwGRJfkqETnV4x7TO3pNvXZBPwiTSQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ni9WoQ0uN2NnFbUH8gy4DkR5BqFz9HfykIyixoxCgHYoVUYD54sabCfSI98rlQrk9STRArwkiZdd5T6j3pmMvFB7u1Gtn4C6vzoJrLbEYWHJJ17HBFgwL0xKF7HRWd+GRzWR3VHdIyMfJsv2drDN/mIFtNqNdEVIL8gIYfCpdBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UY/LZLHn; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UY/LZLHn"
Message-ID: <166abc44-f725-4181-9fc9-f808f4894a17@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785309846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OZtSbiAnS6rQTDFNl1WKWuT5KuTX1/3h5uLg/WVvQOo=;
	b=UY/LZLHnfaubVs4/Z3UPrdU2csZYo5PVIhN49O7akvxqo2YH156NNrrUlYyGILviOqucCq
	tEkRZM1B2gp7xJPGRVbUy0dRoQ0sqfBMwKuBQpZijjdVU4q3Z+3LS2d/dp1hfhZ9ThVrr5
	zDA+ySs5o+2sUphVcgN0RzdInK5z/gM=
Date: Wed, 29 Jul 2026 15:23:42 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, hch@lst.de, dongsheng.yang@linux.dev,
 cengku@gmail.com, josef@toxicpanda.com, nilay@linux.ibm.com,
 ming.lei@redhat.com, yukuai@fygo.io, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of
 bio_set_dev
To: Yu Kuai <yukuai@kernel.org>, axboe@kernel.dk, tj@kernel.org
References: <20260724123037.3004560-1-yukuai@kernel.org>
 <20260724123037.3004560-2-yukuai@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260724123037.3004560-2-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/24 20:30, Yu Kuai 写道:
> From: Yu Kuai <yukuai@fygo.io>
> 
> bio_set_dev(), bio_init() and bio_reset() associate a bio with a blkg for
> its target queue. That association may have to create a new blkg, and
> currently there are lots of callers that are under atomic context.
> 
> Move the association out of those helpers and into the submit path, which
> is always sleepable (submit_bio_noacct() already does might_sleep()):
> 
>   - submit_bio() associates new I/O before bio_set_ioprio(), whose
>     blkcg_set_ioprio() reads the policy from bio->bi_blkg.
> 
>   - submit_bio_noacct() (re)associates when a bio has no blkg yet or was
>     remapped to a different queue.  blk_throtl_bio() and the rq_qos
>     throttlers (iocost, iolatency) pair bio->bi_blkg with the queue of
>     bio->bi_bdev, so a remapped bio must be reassociated to the new queue.
> 
>   - bio_set_dev() no longer associates; instead it drops the existing blkg
>     when the device changes, since that blkg is tied to the old queue.
>     bio_init()/bio_reset() leave bi_blkg NULL.
> 

Hi Yu Kuai,

Thanks for the v2 rework.  One thing I wanted to flag: with association
moved out of bio_set_dev(), blkcg_punt_bio_submit() can be reached with
bio->bi_blkg == NULL.  btrfs compressed writeback builds its bio without
going through the generic submit_bio() (it uses btrfs_submit_bio()), so the
new association never runs for it, and the bio_set_dev() in
btrfs_submit_dev_bio() no longer fills bi_blkg in.

I reproduced it on this tree -- btrfs with compress=zstd, write dirty data
from a non-root cgroup, sync:

  BUG: kernel NULL pointer dereference, address 0x30
  Workqueue: btrfs-worker btrfs_work_helper
  RIP: 0010:blkcg_punt_bio_submit+0xf/0x80
  Call Trace:
   btrfs_submit_bio+0x79/0x1a0
   btrfs_work_helper+0x141/0x360

0x30 is the offset of ->parent in struct blkcg_gq, and RBX (bio->bi_blkg)
is NULL at the fault, so it's the `if (blkg->parent)` read.  Regular
buffered writeback looked fine -- wbc_init_bio() sets bi_blkg early -- so it
seems limited to the compressed path.

> Introduce bio_disassociate_blkg() to drop a bio's blkg reference and use it
> from bio_set_dev(), bio_uninit() and the bio freeing path, replacing their
> open-coded blkg_put().
> 
> This is the first step to convert protecting blkg with blkcg_mutex.
> 
> Signed-off-by: Yu Kuai <yukuai@fygo.io>
> ---
>  block/bio.c         | 18 ++----------------
>  block/blk-cgroup.c  | 18 ++++++++++++++++++
>  block/blk-core.c    | 21 +++++++++++++++++++++
>  include/linux/bio.h |  7 +++++--
>  4 files changed, 46 insertions(+), 18 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 6a2f6fc3413e..ea030c5e39a4 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -179,12 +179,7 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
>  
>  void bio_uninit(struct bio *bio)
>  {
> -#ifdef CONFIG_BLK_CGROUP
> -	if (bio->bi_blkg) {
> -		blkg_put(bio->bi_blkg);
> -		bio->bi_blkg = NULL;
> -	}
> -#endif
> +	bio_disassociate_blkg(bio);
>  	if (bio_integrity(bio))
>  		bio_integrity_free(bio);
>  
> @@ -235,8 +230,6 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
>  #ifdef CONFIG_BLK_CGROUP
>  	bio->bi_blkg = NULL;
>  	bio->issue_time_ns = 0;
> -	if (bdev)
> -		bio_associate_blkg(bio);
>  #ifdef CONFIG_BLK_CGROUP_IOCOST
>  	bio->bi_iocost_cost = 0;
>  #endif
> @@ -280,8 +273,6 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>  	atomic_set(&bio->__bi_remaining, 1);
>  	bio->bi_io_vec = bv;
>  	bio->bi_bdev = bdev;
> -	if (bio->bi_bdev)
> -		bio_associate_blkg(bio);
>  	bio->bi_opf = opf;
>  }
>  EXPORT_SYMBOL(bio_reset);
> @@ -1803,17 +1794,12 @@ void bio_endio(struct bio *bio)
>  		goto again;
>  	}
>  
> -#ifdef CONFIG_BLK_CGROUP
>  	/*
>  	 * Release cgroup info.  We shouldn't have to do this here, but quite
>  	 * a few callers of bio_init fail to call bio_uninit, so we cover up
>  	 * for that here at least for now.
>  	 */
> -	if (bio->bi_blkg) {
> -		blkg_put(bio->bi_blkg);
> -		bio->bi_blkg = NULL;
> -	}
> -#endif
> +	bio_disassociate_blkg(bio);
>  
>  	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d9676126c5b5..618e5566fa52 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -2170,6 +2170,24 @@ void bio_clone_blkg_association(struct bio *dst, struct bio *src)
>  }
>  EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
>  
> +/**
> + * bio_disassociate_blkg - disassociate a bio from its blkg
> + * @bio: target bio
> + *
> + * Drop the blkg reference held by @bio and clear the association.  This is
> + * used when a bio's target device changes (e.g. via bio_set_dev()): the old
> + * blkg is tied to the previous request_queue, so it is dropped here and the
> + * bio is reassociated to the new queue from the submit path.
> + */
> +void bio_disassociate_blkg(struct bio *bio)
> +{
> +	if (bio->bi_blkg) {
> +		blkg_put(bio->bi_blkg);
> +		bio->bi_blkg = NULL;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
> +
>  static int blk_cgroup_io_type(struct bio *bio)
>  {
>  	if (op_is_discard(bio->bi_opf))
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 365641266c9e..8103643b39fc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -822,6 +822,20 @@ void submit_bio_noacct(struct bio *bio)
>  
>  	might_sleep();
>  
> +	/*
> +	 * Associate the bio with a blkg for its target queue here, where it is
> +	 * safe to sleep, instead of in bio_set_dev()/bio_init() which may run
> +	 * under a spinlock.  bio_set_dev() no longer associates, so a freshly
> +	 * allocated or remapped bio has no blkg until it reaches the submit path.
> +	 * Reassociate only when the bio was remapped to a different queue since
> +	 * it was last associated; blk_throtl_bio() and the rq_qos throttlers
> +	 * rely on bio->bi_blkg matching the queue of bio->bi_bdev.
> +	 */
> +#ifdef CONFIG_BLK_CGROUP
> +	if (!bio->bi_blkg || bio->bi_blkg->q != q)
> +		bio_associate_blkg(bio);
> +#endif
> +
>  	/*
>  	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
>  	 * if queue does not support NOWAIT.
> @@ -958,6 +972,13 @@ void submit_bio(struct bio *bio)
>  		count_vm_events(PGPGOUT, bio_sectors(bio));
>  	}
>  
> +	/*
> +	 * bio_set_ioprio() -> blkcg_set_ioprio() reads the policy from
> +	 * bio->bi_blkg, so associate the blkg (for new I/O, the first time) before
> +	 * it runs.  This is the sleepable entry point for new I/O; remapped bios
> +	 * that reach submit_bio_noacct() directly are reassociated there.
> +	 */
> +	bio_associate_blkg(bio);
>  	bio_set_ioprio(bio);
>  	submit_bio_noacct(bio);
>  }
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 8f33f717b14f..7a7509c8a59a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -507,6 +507,7 @@ void bio_associate_blkg(struct bio *bio);
>  void bio_associate_blkg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css);
>  void bio_clone_blkg_association(struct bio *dst, struct bio *src);
> +void bio_disassociate_blkg(struct bio *bio);
>  void blkcg_punt_bio_submit(struct bio *bio);
>  #else	/* CONFIG_BLK_CGROUP */
>  static inline void bio_associate_blkg(struct bio *bio) { }
> @@ -515,6 +516,7 @@ static inline void bio_associate_blkg_from_css(struct bio *bio,
>  { }
>  static inline void bio_clone_blkg_association(struct bio *dst,
>  					      struct bio *src) { }
> +static inline void bio_disassociate_blkg(struct bio *bio) { }
>  static inline void blkcg_punt_bio_submit(struct bio *bio)
>  {
>  	submit_bio(bio);
> @@ -524,10 +526,11 @@ static inline void blkcg_punt_bio_submit(struct bio *bio)
>  static inline void bio_set_dev(struct bio *bio, struct block_device *bdev)
>  {
>  	bio_clear_flag(bio, BIO_REMAPPED);
> -	if (bio->bi_bdev != bdev)
> +	if (bio->bi_bdev != bdev) {
>  		bio_clear_flag(bio, BIO_BPS_THROTTLED);
> +		bio_disassociate_blkg(bio);
> +	}
>  	bio->bi_bdev = bdev;
> -	bio_associate_blkg(bio);
>  }
>  
>  /*

