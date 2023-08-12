From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 1/1] blk-throttle: fix throttle configuring not effective
Date: Sat, 12 Aug 2023 15:53:44 +0800
Message-ID: <5ba76f5e-9b02-13c8-c2a3-b15fe016261d@huaweicloud.com>
References: <20230812072116.42321-1-zhuxiaohui.400@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230812072116.42321-1-zhuxiaohui.400-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: zhuxiaohui <zhuxiaohui400-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhuxiaohui <zhuxiaohui.400-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/08/12 15:21, zhuxiaohui =D0=B4=B5=C0:
> when updating block throttle limit with persistence and stable io
> pressure, especially a relative high io pressure, fio test e.g.,
> there may never be a change to start a new slice, and carryover_ios &
> carryover_bytes will not be cleared.
>=20
> As a result, when reconfiguring block throttle limit, we can notice that
> the actual iops and throughput is a random value far away from what is
> set
>=20
> So we need to update carryover value when dispatching bio

I don't understand, not clear carryover_bytes/ios is what expected, and
how can they affect actual bandwith/iops.

Can you give a example how you tested and why current calculation is not
correct?

Thanks,
Kuai

>=20
> Signed-off-by: zhuxiaohui <zhuxiaohui.400-EC8Uxl6Npydl57MIdRCFDg@public.g=
mane.org>
> ---
>   block/blk-throttle.c | 26 ++++++++++++++++++++++++++
>   block/blk-throttle.h |  4 ++--
>   2 files changed, 28 insertions(+), 2 deletions(-)
>=20
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 7397ff199d66..13c9d87a7201 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -821,6 +821,30 @@ static void tg_update_carryover(struct throtl_grp *t=
g)
>   		   tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
>   }
>  =20
> +static void tg_charge_carryover(struct throtl_grp *tg, struct bio *bio)
> +{
> +	bool rw =3D bio_data_dir(bio);
> +
> +	if (unlikely(tg->carryover_bytes[rw])) {
> +		unsigned int bio_size =3D throtl_bio_data_size(bio);
> +		unsigned int carryout_size =3D abs(tg->carryover_bytes[rw]);
> +
> +		carryout_size =3D min(carryout_size, bio_size);
> +
> +		if (tg->carryover_bytes[rw] < 0)
> +			tg->carryover_bytes[rw] +=3D carryout_size;
> +		else
> +			tg->carryover_bytes[rw] -=3D carryout_size;
> +	}
> +
> +	if (unlikely(tg->carryover_ios[rw])) {
> +		if (tg->carryover_ios[rw] < 0)
> +			tg->carryover_ios[rw] +=3D 1;
> +		else
> +			tg->carryover_ios[rw] -=3D 1;
> +	}
> +}
> +
>   static unsigned long tg_within_iops_limit(struct throtl_grp *tg, struct=
 bio *bio,
>   				 u32 iops_limit)
>   {
> @@ -965,6 +989,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, =
struct bio *bio)
>  =20
>   	tg->io_disp[rw]++;
>   	tg->last_io_disp[rw]++;
> +
> +	tg_charge_carryover(tg, bio);
>   }
>  =20
>   /**
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index d1ccbfe9f797..8f1642becb23 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -127,8 +127,8 @@ struct throtl_grp {
>   	 * bytes/ios are waited already in previous configuration, and they wi=
ll
>   	 * be used to calculate wait time under new configuration.
>   	 */
> -	uint64_t carryover_bytes[2];
> -	unsigned int carryover_ios[2];
> +	int64_t carryover_bytes[2];
> +	int carryover_ios[2];
>  =20
>   	unsigned long last_check_time;
>  =20
>=20

