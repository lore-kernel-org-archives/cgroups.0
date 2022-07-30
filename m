From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH RESEND v6 1/8] blk-throttle: fix that io throttle can only
 work for single bio
Date: Sat, 30 Jul 2022 09:06:37 +0800
Message-ID: <f5691140-3343-176c-8d33-68ac58f8f16b@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-2-yukuai1@huaweicloud.com>
 <YuGDjFkxDSsVrcRw@slm.duckdns.org>
 <7f01aba1-43ab-38ab-5755-7ac22d0a78d5@huaweicloud.com>
 <YuQhOjo02RX7uZ0K@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YuQhOjo02RX7uZ0K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>



=D4=DA 2022/07/30 2:04, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Fri, Jul 29, 2022 at 02:32:36PM +0800, Yu Kuai wrote:
>> We need to make sure following conditions is always hold:
>>
>> 1) If a bio is splited, iops limits should count multiple times, while
>> bps limits should only count once.
>> 2) If a bio is issued while some bios are already throttled, bps limits
>> should not be ignored.
>>
>> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
>> fixes that 1) is not hold, while it breaks 2). Root cause is that such
>> bio will be flaged in __blk_throtl_bio(), and later
>> tg_with_in_bps_limit() will skip flaged bio.
>>
>> In order to fix this problem, at first, I change that flaged bio won't
>> be skipped in tg_with_in_bps_limit():
>>
>> -	if (!bio_flagged(bio, BIO_THROTTLED)) {
>> -		tg->bytes_disp[rw] +=3D bio_size;
>> -		tg->last_bytes_disp[rw] +=3D bio_size;
>> -	}
>> -
>> +	tg->bytes_disp[rw] +=3D bio_size;
>> +	tg->last_bytes_disp[rw] +=3D bio_size;
>>
>> However, this will break that bps limits should only count once. Thus I
>> try to restore the overaccounting in __blk_throtl_bio() in such case:
>>
>> +		if (bio_flagged(bio, BIO_THROTTLED)) {
>> +			unsigned int bio_size =3D throtl_bio_data_size(bio);
>> +
>> +			if (tg->bytes_disp[rw] >=3D bio_size)
>> +				tg->bytes_disp[rw] -=3D bio_size;
>> +			if (tg->last_bytes_disp[rw] >=3D bio_size)
>> +				tg->last_bytes_disp[rw] -=3D bio_size;
>> +		}
>>
>> If new slice is not started, then the decrement should make sure this
>> bio won't be counted again. However, if new slice is started and the
>> condition 'bytes_disp >=3D bio_size' doesn't hold, this bio will end up
>> accounting twice.
>>
>> Pleas let me know if you think this suituation is problematic, I'll try
>> to figure out a new way...
>=20
> While a bit tricky, I think it's fine but please add comments in the code
> explaining what's going on and why. Also, can you please explain why
> __blk_throtl_bio() being skipped when iops limit is not set doesn't skew =
the
> result?

Because bps limit is already counted the first time __blk_throtl_bio()
is called for the orignal bio. When splited bio is reentered, we only
need to throttle it again if iops limit is set.

By the way, I found that this way is better after patch 4:

in __blk_throtl_bio():

if (bio_flagged(bio, BIO_THROTTLED)) {
	tg->bytes_skipped[rw] +=3D bio_size;
	if (tg->last_bytes_disp[rw] >=3D bio_size)
		tg->last_bytes_disp[rw] -=3D bio_size;
}

The overaccounting can be restored even if new slice is started.

Thanks,
Kuai

