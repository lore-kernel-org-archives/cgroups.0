From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Fri, 25 Feb 2022 15:18:00 +0800
Message-ID: <c000951a-b304-4663-4752-4a2cf8a4cbbb@huawei.com>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220210115637.1074927-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: ming.lei@redhat.com, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

friendly ping ...

=D4=DA 2022/02/10 19:56, Yu Kuai =D0=B4=B5=C0:
> Throttled bios can't be issued after del_gendisk() is done, thus
> it's better to cancel them immediately rather than waiting for
> throttle is done.
>=20
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
> Changes in v9:
>   - some minor changes as suggested by Ming.
> Changes in v8:
>   - fold two patches into one
> Changes in v7:
>   - use the new solution as suggested by Ming.
>=20
>   block/blk-throttle.c | 44 +++++++++++++++++++++++++++++++++++++++++---
>   block/blk-throttle.h |  2 ++
>   block/genhd.c        |  2 ++
>   3 files changed, 45 insertions(+), 3 deletions(-)
>=20
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 7c462c006b26..ca92e5fa2769 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -43,8 +43,12 @@
>   static struct workqueue_struct *kthrotld_workqueue;
>  =20
>   enum tg_state_flags {
> -	THROTL_TG_PENDING	=3D 1 << 0,	/* on parent's pending tree */
> -	THROTL_TG_WAS_EMPTY	=3D 1 << 1,	/* bio_lists[] became non-empty */
> +	/* on parent's pending tree */
> +	THROTL_TG_PENDING	=3D 1 << 0,
> +	/* bio_lists[] became non-empty */
> +	THROTL_TG_WAS_EMPTY	=3D 1 << 1,
> +	/* starts to cancel all bios, will be set if the disk is deleted */
> +	THROTL_TG_CANCELING	=3D 1 << 2,
>   };
>  =20
>   #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
> @@ -871,7 +875,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, st=
ruct bio *bio,
>   	       bio !=3D throtl_peek_queued(&tg->service_queue.queued[rw]));
>  =20
>   	/* If tg->bps =3D -1, then BW is unlimited */
> -	if (bps_limit =3D=3D U64_MAX && iops_limit =3D=3D UINT_MAX) {
> +	if ((bps_limit =3D=3D U64_MAX && iops_limit =3D=3D UINT_MAX) ||
> +	    tg->flags & THROTL_TG_CANCELING) {
>   		if (wait)
>   			*wait =3D 0;
>   		return true;
> @@ -1763,6 +1768,39 @@ static bool throtl_hierarchy_can_upgrade(struct th=
rotl_grp *tg)
>   	return false;
>   }
>  =20
> +void blk_throtl_cancel_bios(struct request_queue *q)
> +{
> +	struct cgroup_subsys_state *pos_css;
> +	struct blkcg_gq *blkg;
> +
> +	spin_lock_irq(&q->queue_lock);
> +	/*
> +	 * queue_lock is held, rcu lock is not needed here technically.
> +	 * However, rcu lock is still held to emphasize that following
> +	 * path need RCU protection and to prevent warning from lockdep.
> +	 */
> +	rcu_read_lock();
> +	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
> +		struct throtl_grp *tg =3D blkg_to_tg(blkg);
> +		struct throtl_service_queue *sq =3D &tg->service_queue;
> +
> +		/*
> +		 * Set the flag to make sure throtl_pending_timer_fn() won't
> +		 * stop until all throttled bios are dispatched.
> +		 */
> +		blkg_to_tg(blkg)->flags |=3D THROTL_TG_CANCELING;
> +		/*
> +		 * Update disptime after setting the above flag to make sure
> +		 * throtl_select_dispatch() won't exit without dispatching.
> +		 */
> +		tg_update_disptime(tg);
> +
> +		throtl_schedule_pending_timer(sq, jiffies + 1);
> +	}
> +	rcu_read_unlock();
> +	spin_unlock_irq(&q->queue_lock);
> +}
> +
>   static bool throtl_can_upgrade(struct throtl_data *td,
>   	struct throtl_grp *this_tg)
>   {
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index 175f03abd9e4..2ae467ac17ea 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -160,12 +160,14 @@ static inline void blk_throtl_exit(struct request_q=
ueue *q) { }
>   static inline void blk_throtl_register_queue(struct request_queue *q) {=
 }
>   static inline void blk_throtl_charge_bio_split(struct bio *bio) { }
>   static inline bool blk_throtl_bio(struct bio *bio) { return false; }
> +static inline void blk_throtl_cancel_bios(struct request_queue *q) { }
>   #else /* CONFIG_BLK_DEV_THROTTLING */
>   int blk_throtl_init(struct request_queue *q);
>   void blk_throtl_exit(struct request_queue *q);
>   void blk_throtl_register_queue(struct request_queue *q);
>   void blk_throtl_charge_bio_split(struct bio *bio);
>   bool __blk_throtl_bio(struct bio *bio);
> +void blk_throtl_cancel_bios(struct request_queue *q);
>   static inline bool blk_throtl_bio(struct bio *bio)
>   {
>   	struct throtl_grp *tg =3D blkg_to_tg(bio->bi_blkg);
> diff --git a/block/genhd.c b/block/genhd.c
> index 9589d1d59afa..6acc98cd0365 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -29,6 +29,7 @@
>   #include "blk.h"
>   #include "blk-mq-sched.h"
>   #include "blk-rq-qos.h"
> +#include "blk-throttle.h"
>  =20
>   static struct kobject *block_depr;
>  =20
> @@ -625,6 +626,7 @@ void del_gendisk(struct gendisk *disk)
>  =20
>   	blk_mq_freeze_queue_wait(q);
>  =20
> +	blk_throtl_cancel_bios(disk->queue);
>   	rq_qos_exit(q);
>   	blk_sync_queue(q);
>   	blk_flush_integrity();
>=20
