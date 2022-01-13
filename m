From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Thu, 13 Jan 2022 16:46:18 +0800
Message-ID: <2221953d-be40-3433-d46c-f40acd044482@huawei.com>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com> <Yd5FkuhYX9YcgQkZ@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yd5FkuhYX9YcgQkZ@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/01/12 11:05, Ming Lei =D0=B4=B5=C0:
> Hello Yu Kuai,
>=20
> On Mon, Jan 10, 2022 at 09:47:58PM +0800, Yu Kuai wrote:
>> Throttled bios can't be issued after del_gendisk() is done, thus
>> it's better to cancel them immediately rather than waiting for
>> throttle is done.
>>
>> For example, if user thread is throttled with low bps while it's
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
>>
>> Noted this patch is mainly from revertion of commit 32e3374304c7
>> ("blk-throttle: remove tg_drain_bios") and commit b77412372b68
>> ("blk-throttle: remove blk_throtl_drain").
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   block/blk-throttle.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>>   block/blk-throttle.h |  2 ++
>>   block/genhd.c        |  2 ++
>>   3 files changed, 81 insertions(+)
>=20
> Just wondering why not take the built-in way in throtl_upgrade_state() for
> canceling throttled bios? Something like the following, then we can avoid
> to re-invent the wheel.
>=20
>   block/blk-throttle.c | 38 +++++++++++++++++++++++++++++++-------
>   block/blk-throttle.h |  2 ++
>   block/genhd.c        |  3 +++
>   3 files changed, 36 insertions(+), 7 deletions(-)
>=20
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index cf7e20804f1b..17e56b2e44c4 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1816,16 +1816,11 @@ static void throtl_upgrade_check(struct throtl_gr=
p *tg)
>   		throtl_upgrade_state(tg->td);
>   }
>  =20
> -static void throtl_upgrade_state(struct throtl_data *td)
> +static void __throtl_cancel_bios(struct throtl_data *td)
>   {
>   	struct cgroup_subsys_state *pos_css;
>   	struct blkcg_gq *blkg;
>  =20
> -	throtl_log(&td->service_queue, "upgrade to max");
> -	td->limit_index =3D LIMIT_MAX;
> -	td->low_upgrade_time =3D jiffies;
> -	td->scale =3D 0;
> -	rcu_read_lock();
>   	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg) {
>   		struct throtl_grp *tg =3D blkg_to_tg(blkg);
>   		struct throtl_service_queue *sq =3D &tg->service_queue;
> @@ -1834,12 +1829,41 @@ static void throtl_upgrade_state(struct throtl_da=
ta *td)
>   		throtl_select_dispatch(sq);
>   		throtl_schedule_next_dispatch(sq, true);
Hi, Ming Lei

I'm confused that how can bios be canceled here?
tg->iops and tg->bps stay untouched, how can throttled bios
dispatch?
>   	}
> -	rcu_read_unlock();
>   	throtl_select_dispatch(&td->service_queue);
>   	throtl_schedule_next_dispatch(&td->service_queue, true);
>   	queue_work(kthrotld_workqueue, &td->dispatch_work);
>   }
>  =20
> +void blk_throtl_cancel_bios(struct request_queue *q)
> +{
> +	struct cgroup_subsys_state *pos_css;
> +	struct blkcg_gq *blkg;
> +
> +	rcu_read_lock();
> +	spin_lock_irq(&q->queue_lock);
> +	__throtl_cancel_bios(q->td);
> +	spin_unlock_irq(&q->queue_lock);
> +	rcu_read_unlock();
> +
> +	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg)
> +		del_timer_sync(&blkg_to_tg(blkg)->service_queue.pending_timer);
> +	del_timer_sync(&q->td->service_queue.pending_timer);

By the way, I think delete timer will end up io hung here if there are
some bios still be throttled.

Thanks,
Kuai
> +
> +	throtl_shutdown_wq(q);
> +}
> +
> +static void throtl_upgrade_state(struct throtl_data *td)
> +{
> +	throtl_log(&td->service_queue, "upgrade to max");
> +	td->limit_index =3D LIMIT_MAX;
> +	td->low_upgrade_time =3D jiffies;
> +	td->scale =3D 0;
> +
> +	rcu_read_lock();
> +	__throtl_cancel_bios(td);
> +	rcu_read_unlock();
> +}
> +
>   static void throtl_downgrade_state(struct throtl_data *td)
>   {
>   	td->scale /=3D 2;
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index b23a9f3abb82..525ac607c518 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -162,11 +162,13 @@ static inline int blk_throtl_init(struct request_qu=
eue *q) { return 0; }
>   static inline void blk_throtl_exit(struct request_queue *q) { }
>   static inline void blk_throtl_register_queue(struct request_queue *q) {=
 }
>   static inline bool blk_throtl_bio(struct bio *bio) { return false; }
> +static inline void blk_throtl_cancel_bios(struct request_queue *q) {}
>   #else /* CONFIG_BLK_DEV_THROTTLING */
>   int blk_throtl_init(struct request_queue *q);
>   void blk_throtl_exit(struct request_queue *q);
>   void blk_throtl_register_queue(struct request_queue *q);
>   bool __blk_throtl_bio(struct bio *bio);
> +void blk_throtl_cancel_bios(struct request_queue *q);
>   static inline bool blk_throtl_bio(struct bio *bio)
>   {
>   	struct throtl_grp *tg =3D blkg_to_tg(bio->bi_blkg);
> diff --git a/block/genhd.c b/block/genhd.c
> index 626c8406f21a..1395cbd8eacf 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -30,6 +30,7 @@
>   #include "blk.h"
>   #include "blk-mq-sched.h"
>   #include "blk-rq-qos.h"
> +#include "blk-throttle.h"
>  =20
>   static struct kobject *block_depr;
>  =20
> @@ -622,6 +623,8 @@ void del_gendisk(struct gendisk *disk)
>  =20
>   	blk_mq_freeze_queue_wait(q);
>  =20
> +	blk_throtl_cancel_bios(q);
> +
>   	rq_qos_exit(q);
>   	blk_sync_queue(q);
>   	blk_flush_integrity();
>=20
> Thanks,
> Ming
>=20
> .
>=20
