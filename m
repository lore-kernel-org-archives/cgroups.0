From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [PATCH v2] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Fri, 23 Dec 2022 17:52:52 +0800
Message-ID: <13d0add5-eca9-d27d-f51a-8e7a7efe5d06@bytedance.com>
References: <20221218111314.55525-1-hanjinke.666@bytedance.com>
 <20221221104246.37714-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVgAGkj+SjuhFiSBYtG1SjVAwKIoE0eDmxPhnITBIZ8=;
        b=VumzJqwelKVRQ5UaXZUVpxoVWPcFionVHd0OBu1dkucxo5cto+xLHjk1fUh9PR++oz
         zzbI0k782oKNaLoP95HAn0ysIPcrrkNyHPzagZoD7vO36TCz2zx6Snqc22VX1nwirZKc
         qS5s0Pia2LHs1MThSS7Je4cglk4i3VqWVUCcAa7LC9o8th/MSuiCHzEh5lCdaDLQYyIU
         Q4d8ycVZpBFXXMqwLPF/uVUrfIXNC1Rl8+jifT0q/ozBRrZRzXvtzyeAY3isO78ftnjS
         Sd9KbhPM1VmuqqD2txaYqJj2/z96yX+/8m+JvjDyEJ0bmGusHmNb3eFd1N1o6nvY14WU
         ozRQ==
In-Reply-To: <20221221104246.37714-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com

Hi
In the process of testing v2, threre is one issue need to solved.

If a bio can't dispatch because of overlimit, a wait time will 
calculated and the dispatch will exit. Then spin lock of request queue
will be released and new io may be queued to the throtl queue. When it's
time to dispatch the waiting bio, another bio(eg: from sync queue) may 
be selected to dispatch instead of the waitting bio. The may lead the 
waitting bio to be wait more than once. Iff the dispatched bio is 
smaller than the waitting bio, slice will be trimmed after each diapatch
,the bandwidth cannot be filled in this case.

I will fix this issue and send the v3.

Thanks.
Jinke.


在 2022/12/21 下午6:42, Jinke Han 写道:
> From: Jinke Han <hanjinke.666@bytedance.com>
> 
> Now we don't distinguish sync write ios from normal buffer write ios
> in blk-throtl. A bio with REQ_SYNC tagged always mean it will be wait
> until write completion soon after it submit. So it's reasonable for sync
> io to complete as soon as possible.
> 
> In our test, fio writes a 100g file in sequential 4k blocksize in
> a container with low bps limit configured (wbps=10M). More than 1200
> ios were throttled in blk-throtl queue and the avarage throtle time
> of each io is 140s. At the same time, the operation of saving a small
> file by vim will be blocked amolst 140s. As a fsync will be send by vim,
> the sync ios of fsync will be blocked by a huge amount of buffer write
> ios ahead. This is also a priority inversion problem within one cgroup.
> In the database scene, things got really bad with blk-throtle enabled
> as fsync is called very often.
> 
> This patch splits bio queue into sync and async queues for blk-throtl
> and gives a huge priority to sync write ios. Sync queue only make sense
> for write ios as we treat all read io as sync io. I think it's a nice
> respond to the semantics of REQ_SYNC. Bios with REQ_META and REQ_PRIO
> gains the same priority as they are important to fs. This may avoid
> some potential priority inversion problems.
> 
> With this patch, do the same test above, the duration of the fsync sent
> by vim drops to servral hundreds of milliseconds.
> 
> Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
> Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
> ---
> 
> Changes in v2:
> - Make the code more simple
> 
>   block/blk-throttle.c | 105 +++++++++++++++++++++++++++++++++++++++----
>   block/blk-throttle.h |  12 ++++-
>   2 files changed, 108 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 847721dc2b2b..f3285c7da9f7 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -21,6 +21,13 @@
>   /* Total max dispatch from all groups in one round */
>   #define THROTL_QUANTUM 32
>   
> +/* For write ios, dispatch 4 sync ios and 1 normal io in one loop */
> +#define THROTL_SYNC_FACTOR 4
> +
> +/* Only make sense for write ios, all read ios are treated as SYNC */
> +#define SYNC	0
> +#define ASYNC	1
> +
>   /* Throttling is performed over a slice and after that slice is renewed */
>   #define DFL_THROTL_SLICE_HD (HZ / 10)
>   #define DFL_THROTL_SLICE_SSD (HZ / 50)
> @@ -241,11 +248,27 @@ static inline unsigned int throtl_bio_data_size(struct bio *bio)
>   	return bio->bi_iter.bi_size;
>   }
>   
> -static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
> +static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg,
> +			      bool rw)
>   {
>   	INIT_LIST_HEAD(&qn->node);
> -	bio_list_init(&qn->bios);
> +	bio_list_init(&qn->bios[SYNC]);
> +	bio_list_init(&qn->bios[ASYNC]);
>   	qn->tg = tg;
> +	qn->dispatch_sync_cnt = (rw == READ) ? UINT_MAX : 0;
> +}
> +
> +#define BLK_THROTL_SYNC(bio) (bio->bi_opf & (REQ_SYNC | REQ_META | REQ_PRIO))
> +
> +static inline void throtl_qnode_add_bio_list(struct throtl_qnode *qn,
> +					     struct bio *bio)
> +{
> +	bool rw = bio_data_dir(bio);
> +
> +	if ((rw == READ) || BLK_THROTL_SYNC(bio))
> +		bio_list_add(&qn->bios[SYNC], bio);
> +	else
> +		bio_list_add(&qn->bios[ASYNC], bio);
>   }
>   
>   /**
> @@ -261,13 +284,34 @@ static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
>   static void throtl_qnode_add_bio(struct bio *bio, struct throtl_qnode *qn,
>   				 struct list_head *queued)
>   {
> -	bio_list_add(&qn->bios, bio);
> +	throtl_qnode_add_bio_list(qn, bio);
>   	if (list_empty(&qn->node)) {
>   		list_add_tail(&qn->node, queued);
>   		blkg_get(tg_to_blkg(qn->tg));
>   	}
>   }
>   
> +static inline struct bio *throtl_qnode_bio_peek(struct throtl_qnode *qn)
> +{
> +	struct bio *bio;
> +	int from = SYNC;
> +
> +	/* qn for read ios */
> +	if (qn->dispatch_sync_cnt == UINT_MAX)
> +		return bio_list_peek(&qn->bios[from]);
> +
> +	/* qn for write ios */
> +	if (qn->dispatch_sync_cnt == THROTL_SYNC_FACTOR)
> +		from = ASYNC;
> +	bio = bio_list_peek(&qn->bios[from]);
> +	if (!bio) {
> +		from = 1 - from;
> +		bio = bio_list_peek(&qn->bios[from]);
> +	}
> +
> +	return bio;
> +}
> +
>   /**
>    * throtl_peek_queued - peek the first bio on a qnode list
>    * @queued: the qnode list to peek
> @@ -281,11 +325,56 @@ static struct bio *throtl_peek_queued(struct list_head *queued)
>   		return NULL;
>   
>   	qn = list_first_entry(queued, struct throtl_qnode, node);
> -	bio = bio_list_peek(&qn->bios);
> +	bio = throtl_qnode_bio_peek(qn);
>   	WARN_ON_ONCE(!bio);
>   	return bio;
>   }
>   
> +/**
> + * throtl_qnode_bio_pop: pop a bio from a qnode
> + * @qn: the qnode to pop a bio from
> + *
> + * For read io qn, just pop bio from sync queue and return.
> + * For write io qn, the target queue to pop was determined by the dispatch_sync_cnt.
> + * Try to pop bio from target queue, fetch the bio and return when it is not empty.
> + * If the target queue empty, pop bio from other queue instead.
> + */
> +static inline struct bio *throtl_qnode_bio_pop(struct throtl_qnode *qn)
> +{
> +	struct bio *bio;
> +	int from = SYNC;
> +
> +	/* qn for read ios */
> +	if (qn->dispatch_sync_cnt == UINT_MAX)
> +		return bio_list_pop(&qn->bios[from]);
> +
> +	/* qn for write ios */
> +	if (qn->dispatch_sync_cnt == THROTL_SYNC_FACTOR)
> +		from = ASYNC;
> +
> +	bio = bio_list_pop(&qn->bios[from]);
> +	if (!bio) {
> +		from = 1 - from;
> +		bio = bio_list_pop(&qn->bios[from]);
> +	}
> +
> +	if ((qn->dispatch_sync_cnt < THROTL_SYNC_FACTOR) &&
> +		(from == SYNC))
> +		qn->dispatch_sync_cnt++;
> +	else if (from == ASYNC)
> +		qn->dispatch_sync_cnt = 0;
> +
> +	return bio;
> +}
> +
> +static inline bool throtl_qnode_empty(struct throtl_qnode *qn)
> +{
> +	if (bio_list_empty(&qn->bios[SYNC]) &&
> +		bio_list_empty(&qn->bios[ASYNC]))
> +		return true;
> +	return false;
> +}
> +
>   /**
>    * throtl_pop_queued - pop the first bio form a qnode list
>    * @queued: the qnode list to pop a bio from
> @@ -310,10 +399,10 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
>   		return NULL;
>   
>   	qn = list_first_entry(queued, struct throtl_qnode, node);
> -	bio = bio_list_pop(&qn->bios);
> +	bio = throtl_qnode_bio_pop(qn);
>   	WARN_ON_ONCE(!bio);
>   
> -	if (bio_list_empty(&qn->bios)) {
> +	if (throtl_qnode_empty(qn)) {
>   		list_del_init(&qn->node);
>   		if (tg_to_put)
>   			*tg_to_put = qn->tg;
> @@ -355,8 +444,8 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
>   	throtl_service_queue_init(&tg->service_queue);
>   
>   	for (rw = READ; rw <= WRITE; rw++) {
> -		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
> -		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
> +		throtl_qnode_init(&tg->qnode_on_self[rw], tg, rw);
> +		throtl_qnode_init(&tg->qnode_on_parent[rw], tg, rw);
>   	}
>   
>   	RB_CLEAR_NODE(&tg->rb_node);
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index ef4b7a4de987..55f3a9594e0d 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -28,8 +28,18 @@
>    */
>   struct throtl_qnode {
>   	struct list_head	node;		/* service_queue->queued[] */
> -	struct bio_list		bios;		/* queued bios */
> +	struct bio_list		bios[2];	/* queued bios */
>   	struct throtl_grp	*tg;		/* tg this qnode belongs to */
> +
> +	/*
> +	 * 1) for write throtl_qnode:
> +	 * [0, THROTL_SYNC_FACTOR-1]: dispatch sync io
> +	 * [THROTL_SYNC_FACTOR]: dispatch async io
> +	 *
> +	 * 2) for read throtl_qnode:
> +	 * UINT_MAX
> +	 */
> +	unsigned int dispatch_sync_cnt;         /* sync io dispatch counter */
>   };
>   
>   struct throtl_service_queue {
