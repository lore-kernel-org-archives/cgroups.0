From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next] blk-throttle: delay the setting of 'BIO_THROTTLED'
 to when throttle is done
Date: Wed, 18 May 2022 14:30:07 +0800
Message-ID: <73e8bdef-0f80-d255-e4f2-170813a12f5f@huawei.com>
References: <20220517134909.2910251-1-yukuai3@huawei.com>
 <YoRw8J1Y/bzxVsSR@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YoRw8J1Y/bzxVsSR@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/05/18 12:07, Ming Lei =D0=B4=B5=C0:
> On Tue, May 17, 2022 at 09:49:09PM +0800, Yu Kuai wrote:
>> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
>> introduce a new problem, for example:
>>
>> [root@localhost ~]# echo "8:0 1024" > /sys/fs/cgroup/blkio/blkio.throttl=
e.write_bps_device
>> [root@localhost ~]# echo $$ > /sys/fs/cgroup/blkio/cgroup.procs
>> [root@localhost ~]# dd if=3D/dev/zero of=3D/dev/sda bs=3D10k count=3D1 o=
flag=3Ddirect &
>> [1] 620
>> [root@localhost ~]# dd if=3D/dev/zero of=3D/dev/sda bs=3D10k count=3D1 o=
flag=3Ddirect &
>> [2] 626
>> [root@localhost ~]# 1+0 records in
>> 1+0 records out
>> 10240 bytes (10 kB, 10 KiB) copied, 10.0038 s, 1.0 kB/s1+0 records in
>> 1+0 records out
>>
>> 10240 bytes (10 kB, 10 KiB) copied, 9.23076 s, 1.1 kB/s
>> -> the second bio is issued after 10s instead of 20s.
>>
>> This is because if some bios are already queued, current bio is queued
>> directly and the flag 'BIO_THROTTLED' is set. And later, when former
>> bios are dispatched, this bio will be dispatched without waiting at all,
>> this is due to tg_with_in_bps_limit() will return 0 if the flag is set.
>>
>> Instead of setting the flag when bio starts throttle, delay to when
>> throttle is done to fix the problem.
>>
>> Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/blk-throttle.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 447e1b8722f7..f952f2d942ff 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -811,7 +811,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *=
tg, struct bio *bio,
>>   	unsigned int bio_size =3D throtl_bio_data_size(bio);
>>  =20
>>   	/* no need to throttle if this bio's bytes have been accounted */
>> -	if (bps_limit =3D=3D U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
>> +	if (bps_limit =3D=3D U64_MAX) {
>=20
> This way may double account bio size for re-entered split bio.
Hi, Ming

Yes, you are right, I forgot that...
>=20
>=20
>>   		if (wait)
>>   			*wait =3D 0;
>>   		return true;
>> @@ -1226,8 +1226,10 @@ static void blk_throtl_dispatch_work_fn(struct wo=
rk_struct *work)
>>  =20
>>   	spin_lock_irq(&q->queue_lock);
>>   	for (rw =3D READ; rw <=3D WRITE; rw++)
>> -		while ((bio =3D throtl_pop_queued(&td_sq->queued[rw], NULL)))
>> +		while ((bio =3D throtl_pop_queued(&td_sq->queued[rw], NULL))) {
>> +			bio_set_flag(bio, BIO_THROTTLED);
>>   			bio_list_add(&bio_list_on_stack, bio);
>> +		}
>>   	spin_unlock_irq(&q->queue_lock);
>>  =20
>>   	if (!bio_list_empty(&bio_list_on_stack)) {
>> @@ -2134,7 +2136,8 @@ bool __blk_throtl_bio(struct bio *bio)
>>   			}
>>   			break;
>>   		}
>> -
>> +		/* this bio will be issued directly */
>> +		bio_set_flag(bio, BIO_THROTTLED);
>>   		/* within limits, let's charge and dispatch directly */
>>   		throtl_charge_bio(tg, bio);
>=20
> Marking BIO_THROTTLED before throtle_charge_bio() causes the bio
> bytes not be charged.
Yes, thanks for spotting this.
>=20
> Another simple way is to compensate for previous extra bytes accounting,
> something like the following patch:
>=20
>=20
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 139b2d7a99e2..44773d2ba257 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -810,8 +810,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *t=
g, struct bio *bio,
>   	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>   	unsigned int bio_size =3D throtl_bio_data_size(bio);
>  =20
> -	/* no need to throttle if this bio's bytes have been accounted */
> -	if (bps_limit =3D=3D U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
> +	if (bps_limit =3D=3D U64_MAX) {
>   		if (wait)
>   			*wait =3D 0;
>   		return true;
> @@ -921,10 +920,8 @@ static void throtl_charge_bio(struct throtl_grp *tg,=
 struct bio *bio)
>   	unsigned int bio_size =3D throtl_bio_data_size(bio);
>  =20
>   	/* Charge the bio to the group */
> -	if (!bio_flagged(bio, BIO_THROTTLED)) {
> -		tg->bytes_disp[rw] +=3D bio_size;
> -		tg->last_bytes_disp[rw] +=3D bio_size;
> -	}
> +	tg->bytes_disp[rw] +=3D bio_size;
> +	tg->last_bytes_disp[rw] +=3D bio_size;
>  =20
>   	tg->io_disp[rw]++;
>   	tg->last_io_disp[rw]++;
> @@ -2125,6 +2122,20 @@ bool __blk_throtl_bio(struct bio *bio)
>   		if (sq->nr_queued[rw])
>   			break;
>  =20
> +		/*
> +		 * re-entered bio has accounted bytes already, so try to
> +		 * compensate previous over-accounting. However, if new
> +		 * slice is started, just forget it
> +		 */
> +		if (bio_flagged(bio, BIO_THROTTLED)) {
> +			unsigned int bio_size =3D throtl_bio_data_size(bio);
> +
> +			if (tg->bytes_disp[rw] >=3D bio_size)
> +				tg->bytes_disp[rw] -=3D bio_size;
> +			if (tg->last_bytes_disp[rw] - bio_size)
> +				tg->last_bytes_disp[rw] -=3D bio_size;
> +		}
> +
If new slice is not started, then this should fix the problem.
 From what I can see, other than tg_conf_updated, new silce can start if
there are still bio throttled:

tg_may_dispatch
  if (!(tg->service_queue.nr_queued[rw]))
   throtl_start_new_slice

Thus I think the change is ok. For the case in tg_conf_updated, I'll
remove the throtl_start_new_slice() to fix a hung problem. I'll add this
patch with this one in next version.

Thanks,
Kuai

>   		/* if above limits, break to queue */
>   		if (!tg_may_dispatch(tg, bio, NULL)) {
>   			tg->last_low_overflow_time[rw] =3D jiffies;
>=20
> Thanks,
> Ming
>=20
> .
>=20
