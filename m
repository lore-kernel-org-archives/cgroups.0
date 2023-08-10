From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Thu, 10 Aug 2023 21:43:58 +0800
Message-ID: <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230810035111.2236335-1-lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

=D4=DA 2023/08/10 11:51, Li Lingfeng =D0=B4=B5=C0:
> From: Li Lingfeng <lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
> a mutex named "init_mutex" in blk_iolatency_try_init for the race
> condition of initializing RQ_QOS_LATENCY.
> Now a new lock has been add to struct request_queue by commit a13bd91be223
> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
> held in blkg_conf_open_bdev before calling blk_iolatency_init.
> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
> remove it.
>=20
> Since init_mutex has been removed, blk_iolatency_try_init can be
> open-coded back to iolatency_set_limit() like ioc_qos_write().
>=20
Reviewed-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks,
Kuai
> Signed-off-by: Li Lingfeng <lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gma=
ne.org>
> ---
>    v1->v2: open-code blk_iolatency_try_init()
>    v2->v3: add lockdep check
>   block/blk-iolatency.c | 35 +++++++++++------------------------
>   1 file changed, 11 insertions(+), 24 deletions(-)
>=20
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index fd5fec989e39..c16aef4be036 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -824,29 +824,6 @@ static void iolatency_clear_scaling(struct blkcg_gq =
*blkg)
>   	}
>   }
>  =20
> -static int blk_iolatency_try_init(struct blkg_conf_ctx *ctx)
> -{
> -	static DEFINE_MUTEX(init_mutex);
> -	int ret;
> -
> -	ret =3D blkg_conf_open_bdev(ctx);
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
> -	 * confuse iolat_rq_qos() test. Make the test and init atomic.
> -	 */
> -	mutex_lock(&init_mutex);
> -
> -	if (!iolat_rq_qos(ctx->bdev->bd_queue))
> -		ret =3D blk_iolatency_init(ctx->bdev->bd_disk);
> -
> -	mutex_unlock(&init_mutex);
> -
> -	return ret;
> -}
> -
>   static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *b=
uf,
>   			     size_t nbytes, loff_t off)
>   {
> @@ -861,7 +838,17 @@ static ssize_t iolatency_set_limit(struct kernfs_ope=
n_file *of, char *buf,
>  =20
>   	blkg_conf_init(&ctx, buf);
>  =20
> -	ret =3D blk_iolatency_try_init(&ctx);
> +	ret =3D blkg_conf_open_bdev(&ctx);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
> +	 * confuse iolat_rq_qos() test. Make the test and init atomic.
> +	 */
> +	lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);
> +	if (!iolat_rq_qos(ctx.bdev->bd_queue))
> +		ret =3D blk_iolatency_init(ctx.bdev->bd_disk);
>   	if (ret)
>   		goto out;
>  =20
>=20

