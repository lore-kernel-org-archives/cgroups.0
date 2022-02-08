From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v7 1/2] blk-throtl: introduce a new flag
 THROTL_TG_CANCELING
Date: Tue, 8 Feb 2022 11:54:22 +0800
Message-ID: <6167d87a-bb4a-5323-9918-8ff46126ed13@huawei.com>
References: <20220128084522.3169961-1-yukuai3@huawei.com>
 <20220128084522.3169961-2-yukuai3@huawei.com> <YgDVCjkjJe1CSVxv@T590>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YgDVCjkjJe1CSVxv@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/02/07 16:15, Ming Lei =D0=B4=B5=C0:
> On Fri, Jan 28, 2022 at 04:45:21PM +0800, Yu Kuai wrote:
>> If the new flag is set, then the throtl_grp will stop throttling bios.
>> Prepare to canceling all throttled bios if the disk is gone.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/blk-throttle.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 7c462c006b26..abc5e506c72d 100644
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
>=20
> The above change and the following one in tg_update_disptime() isn't
> needed actually.
>=20
> Also I'd suggest to fold the two into one patch.

Ok, I'll fold the two in next version.

Thanks,
Kuai
>=20
>=20
> Thanks,
> Ming
>=20
> .
>=20
