From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] block: cancel all throttled bios in del_gendisk()
Date: Thu, 10 Feb 2022 19:33:38 +0800
Message-ID: <148a020b-5609-1a3c-cfd9-d02abd26ff67@huawei.com>
References: <20220208113808.1401601-1-yukuai3@huawei.com>
 <YgMbaqTD+ycFPAtM@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YgMbaqTD+ycFPAtM@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/02/09 9:39, Ming Lei =D0=B4=B5=C0:
> On Tue, Feb 08, 2022 at 07:38:08PM +0800, Yu Kuai wrote:
>> Throttled bios can't be issued after del_gendisk() is done, thus
>> it's better to cancel them immediately rather than waiting for
>> throttle is done.
>>
>> For example, if user thread is throttled with low bps while it's
>> issuing large io, and the device is deleted. The user thread will
>> wait for a long time for io to return.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>> Changes in v8:
>>   - fold two patches into one
>> Changes in v7:
>>   - use the new solution as suggested by Ming.
>>
>>   block/blk-throttle.c | 49 ++++++++++++++++++++++++++++++++++++++++----
>>   block/blk-throttle.h |  2 ++
>>   block/genhd.c        |  2 ++
>>   3 files changed, 49 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 7c462c006b26..557d20796157 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -43,8 +43,12 @@
>>   static struct workqueue_struct *kthrotld_workqueue;
>>  =20
>>   enum tg_state_flags {
>> -	THROTL_TG_PENDING	=3D 1 << 0,	/* on parent's pending tree */
>> -	THROTL_TG_WAS_EMPTY	=3D 1 << 1,	/* bio_lists[] became non-empty */
>> +	/* on parent's pending tree */
>> +	THROTL_TG_PENDING	=3D 1 << 0,
>> +	/* bio_lists[] became non-empty */
>> +	THROTL_TG_WAS_EMPTY	=3D 1 << 1,
>> +	/* starts to cancel all bios, will be set if the disk is deleted */
>> +	THROTL_TG_CANCELING	=3D 1 << 2,
>>   };
>>  =20
>>   #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
>> @@ -871,7 +875,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, s=
truct bio *bio,
>>   	       bio !=3D throtl_peek_queued(&tg->service_queue.queued[rw]));
>>  =20
>>   	/* If tg->bps =3D -1, then BW is unlimited */
>> -	if (bps_limit =3D=3D U64_MAX && iops_limit =3D=3D UINT_MAX) {
>> +	if ((bps_limit =3D=3D U64_MAX && iops_limit =3D=3D UINT_MAX) ||
>> +	    tg->flags & THROTL_TG_CANCELING) {
>>   		if (wait)
>>   			*wait =3D 0;
>>   		return true;
>> @@ -974,6 +979,9 @@ static void tg_update_disptime(struct throtl_grp *tg)
>>   	unsigned long read_wait =3D -1, write_wait =3D -1, min_wait =3D -1, d=
isptime;
>>   	struct bio *bio;
>>  =20
>> +	if (tg->flags & THROTL_TG_CANCELING)
>> +		goto update;
>> +
>>   	bio =3D throtl_peek_queued(&sq->queued[READ]);
>>   	if (bio)
>>   		tg_may_dispatch(tg, bio, &read_wait);
>> @@ -983,9 +991,10 @@ static void tg_update_disptime(struct throtl_grp *t=
g)
>>   		tg_may_dispatch(tg, bio, &write_wait);
>>  =20
>>   	min_wait =3D min(read_wait, write_wait);
>> -	disptime =3D jiffies + min_wait;
>>  =20
>> +update:
>>   	/* Update dispatch time */
>> +	disptime =3D jiffies + min_wait;
>=20
> As I mentioned on V7, the change in tg_update_disptime() isn't needed, pl=
ease
> drop it.

Hi,
After dropping it, disptime will set to jiffies instead of
jiffies -1, this is fine since time_before() won't pass in
throtl_select_dispatch(). I'll drop it in v9...
>=20
>>   	throtl_dequeue_tg(tg);
>>   	tg->disptime =3D disptime;
>>   	throtl_enqueue_tg(tg);
>> @@ -1763,6 +1772,38 @@ static bool throtl_hierarchy_can_upgrade(struct t=
hrotl_grp *tg)
>>   	return false;
>>   }
>>  =20
>> +void blk_throtl_cancel_bios(struct request_queue *q)
>> +{
>> +	struct cgroup_subsys_state *pos_css;
>> +	struct blkcg_gq *blkg;
>> +
>> +	spin_lock_irq(&q->queue_lock);
>> +	/*
>> +	 * queue_lock is held, rcu lock is not needed here technically.
>> +	 * However, rcu lock is still held to emphasize that following
>> +	 * path need RCU protection and to prevent warning from lockdep.
>> +	 */
>> +	rcu_read_lock();
>> +	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
>> +		struct throtl_grp *tg =3D blkg_to_tg(blkg);
>> +		struct throtl_service_queue *sq =3D &tg->service_queue;
>> +
>> +		/*
>> +		 * Set disptime in the past to make sure
>> +		 * throtl_select_dispatch() won't exit without dispatching.
>> +		 */
>> +		tg->disptime =3D jiffies - 1;
>=20
> It might be better to replace the above line with tg_update_disptime().

Ok, I'll replace it and setting the flag first.

Thanks,
Kuai
>=20
> Otherwise, the patch looks good.
>=20
> Thanks,
> Ming
>=20
> .
>=20
