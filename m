From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH RESEND v6 1/8] blk-throttle: fix that io throttle can only
 work for single bio
Date: Fri, 29 Jul 2022 14:32:36 +0800
Message-ID: <7f01aba1-43ab-38ab-5755-7ac22d0a78d5@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-2-yukuai1@huaweicloud.com>
 <YuGDjFkxDSsVrcRw@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YuGDjFkxDSsVrcRw-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/07/28 2:27, Tejun Heo =D0=B4=B5=C0:
> Sorry about the long delay.
>=20
> So, the code looks nice but I have a difficult time following the logic.
>=20
> On Fri, Jul 01, 2022 at 05:34:34PM +0800, Yu Kuai wrote:
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
>=20
> So, we're charging and controlling whether it has already been throttled =
or
> not.
>=20
>> @@ -2121,6 +2118,21 @@ bool __blk_throtl_bio(struct bio *bio)
>>   			tg->last_low_overflow_time[rw] =3D jiffies;
>>   		throtl_downgrade_check(tg);
>>   		throtl_upgrade_check(tg);
>> +
>> +		/*
>> +		 * re-entered bio has accounted bytes already, so try to
>> +		 * compensate previous over-accounting. However, if new
>> +		 * slice is started, just forget it.
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
> and trying to restore the overaccounting. However, it's not clear why this
> helps with the problem you're describing. The comment should be clearly
> spelling out why it's done this way and how this works.
>=20
> Also, blk_throttl_bio() doesn't call into __blk_throtl_bio() at all if
> THROTTLED is set and HAS_IOPS_LIMIT is not, so if there are only bw limit=
s,
> we end up accounting these IOs twice?
>=20

We need to make sure following conditions is always hold:

1) If a bio is splited, iops limits should count multiple times, while
bps limits should only count once.
2) If a bio is issued while some bios are already throttled, bps limits
should not be ignored.

commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
fixes that 1) is not hold, while it breaks 2). Root cause is that such
bio will be flaged in __blk_throtl_bio(), and later
tg_with_in_bps_limit() will skip flaged bio.

In order to fix this problem, at first, I change that flaged bio won't
be skipped in tg_with_in_bps_limit():

-	if (!bio_flagged(bio, BIO_THROTTLED)) {
-		tg->bytes_disp[rw] +=3D bio_size;
-		tg->last_bytes_disp[rw] +=3D bio_size;
-	}
-
+	tg->bytes_disp[rw] +=3D bio_size;
+	tg->last_bytes_disp[rw] +=3D bio_size;

However, this will break that bps limits should only count once. Thus I
try to restore the overaccounting in __blk_throtl_bio() in such case:

+		if (bio_flagged(bio, BIO_THROTTLED)) {
+			unsigned int bio_size =3D throtl_bio_data_size(bio);
+
+			if (tg->bytes_disp[rw] >=3D bio_size)
+				tg->bytes_disp[rw] -=3D bio_size;
+			if (tg->last_bytes_disp[rw] >=3D bio_size)
+				tg->last_bytes_disp[rw] -=3D bio_size;
+		}

If new slice is not started, then the decrement should make sure this
bio won't be counted again. However, if new slice is started and the
condition 'bytes_disp >=3D bio_size' doesn't hold, this bio will end up
accounting twice.

Pleas let me know if you think this suituation is problematic, I'll try
to figure out a new way...

Thanks,
Kuai

