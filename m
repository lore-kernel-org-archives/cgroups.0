From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Wed, 17 Aug 2022 09:13:38 +0800
Message-ID: <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
 <Yvvx+/d2+OMROUOe@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yvvx+/d2+OMROUOe-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/08/17 3:37, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:07PM +0800, Yu Kuai wrote:
> ...
>> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
>> support to count splited bios for iops limit, thus it adds flaged bio
>                                                               ^
>                                                               flagged
>=20
>> checking in tg_with_in_bps_limit() so that splited bios will only count
>                                               ^
>                                               split
>=20
>> once for bps limit, however, it introduce a new problem that io throttle
>> won't work if multiple bios are throttled.
>>
>> In order to fix the problem, at first, don't skip flaged bio in
>> tg_with_in_bps_limit(), however, this will break that splited bios should
>> only count once for bps limit. And this patch tries to avoid
>> over-accounting by decrementing it first in __blk_throtl_bio(), and
>> then counting it again while dispatching it.
>>
>> Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> Please cc stable w/ version tag.
>=20
>> ---
>>   block/blk-throttle.c | 26 ++++++++++++++++++++------
>>   1 file changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 9f5fe62afff9..2957e2c643f4 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -811,7 +811,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *=
tg, struct bio *bio,
>>   	unsigned int bio_size =3D throtl_bio_data_size(bio);
>>  =20
>>   	/* no need to throttle if this bio's bytes have been accounted */
>> -	if (bps_limit =3D=3D U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
>> +	if (bps_limit =3D=3D U64_MAX) {
>>   		if (wait)
>>   			*wait =3D 0;
>>   		return true;
>> @@ -921,11 +921,8 @@ static void throtl_charge_bio(struct throtl_grp *tg=
, struct bio *bio)
>>   	unsigned int bio_size =3D throtl_bio_data_size(bio);
>>  =20
>>   	/* Charge the bio to the group */
>> -	if (!bio_flagged(bio, BIO_THROTTLED)) {
>> -		tg->bytes_disp[rw] +=3D bio_size;
>> -		tg->last_bytes_disp[rw] +=3D bio_size;
>> -	}
>> -
>> +	tg->bytes_disp[rw] +=3D bio_size;
>> +	tg->last_bytes_disp[rw] +=3D bio_size;
>>   	tg->io_disp[rw]++;
>>   	tg->last_io_disp[rw]++;
>>  =20
>> @@ -2121,6 +2118,23 @@ bool __blk_throtl_bio(struct bio *bio)
>>   			tg->last_low_overflow_time[rw] =3D jiffies;
>>   		throtl_downgrade_check(tg);
>>   		throtl_upgrade_check(tg);
>> +
>> +		/*
>> +		 * Splited bios can be re-entered because iops limit should be
>                     ^                ^^^^^^^^^^^^^
>                     Split            re-enter
>=20
>> +		 * counted again, however, bps limit should not. Since bps limit
>> +		 * will be counted again while dispatching it, compensate the
>> +		 * over-accounting here. Noted that compensation can fail if
>> +		 * new slice is started.
>=20
> I can't really follow the comment. Please improve the explanation.
>=20
>> +		 */
>> +		if (bio_flagged(bio, BIO_THROTTLED)) {
>> +			unsigned int bio_size =3D throtl_bio_data_size(bio);
>> +
>> +			if (tg->bytes_disp[rw] >=3D bio_size)
>> +				tg->bytes_disp[rw] -=3D bio_size;
>> +			if (tg->last_bytes_disp[rw] >=3D bio_size)
>> +				tg->last_bytes_disp[rw] -=3D bio_size;
>> +		}
>=20
> So, as a fix for the immediate problem, I guess this might do but this fe=
els
> really fragile. How can we be certain that re-entering only happens becau=
se
> of splitting? What if future core development changes that? It seems to be
> solving the problem in the wrong place. Shouldn't we flag the bio indicat=
ing
> that it's split when we're splitting the bio so that we only limit them f=
or
> iops in the first place?
>=20
Splited bio is tracked in __bio_clone:

if (bio_flagged(bio_src, BIO_THROTTLED))
	bio_set_flag(bio, BIO_THROTTLED);

And currenty, the iops limit and bps limit are treated differently,
however there are only one flag 'BIO_THROTTLED' and they can't be
distinguished.

Perhaps I can use two flags, for example BIO_IOPS_THROTTLED and
BIO_BPS_THROTTLED, this way only iops limit can be handled and bps
limit can be skipped for splited bio.

What do you think?

Thanks,
Kuai
> Thanks.
>=20

