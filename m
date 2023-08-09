From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -next v2] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Wed, 9 Aug 2023 14:11:12 +0200
Message-ID: <6dcshmol4oz4hpsm42s3ocfdg7rtykkx2vjg6fd6zdvmkbmg7w@4liecv2rxqqk>
References: <20230809112928.2009183-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vz25knwjnl4pua2b"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691583074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bFw/WJBWsVmnC3JIQOGCnya92pXr+LvPFTesg/9s1Q=;
        b=ub7DH9nJ6UoqBcoyE6iSeIUyE0clsVVe5kr8cLreCRs3+yOwc6WU+42omEKVGcb/gvgfPj
        oVqhy3fAHZCWwoR+tdZRHfU3fYjPFnVc3wKvCw4PhA4i7plNsvJhMFx5UZ7fOrghG9i54O
        d09dv4DUMpoBrW3WSb1ipEZMLrYeBpE=
Content-Disposition: inline
In-Reply-To: <20230809112928.2009183-1-lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--vz25knwjnl4pua2b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2023 at 07:29:28PM +0800, Li Lingfeng <lilingfeng@huaweiclo=
ud.com> wrote:
>  1 file changed, 10 insertions(+), 24 deletions(-)

I like this bottom line.

> @@ -861,7 +838,16 @@ static ssize_t iolatency_set_limit(struct kernfs_ope=
n_file *of, char *buf,
> =20
>  	blkg_conf_init(&ctx, buf);
> =20
> -	ret =3D blk_iolatency_try_init(&ctx);
> +	ret =3D blkg_conf_open_bdev(&ctx);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
> +	 * confuse iolat_rq_qos() test. Make the test and init atomic.
> +	 */

Perhaps add here
	lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);

because without that the last sentence of the comment misses the
context.

> +	if (!iolat_rq_qos(ctx.bdev->bd_queue))
> +		ret =3D blk_iolatency_init(ctx.bdev->bd_disk);
>  	if (ret)
>  		goto out;

Thanks,
Michal

--vz25knwjnl4pua2b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZNOCXgAKCRAGvrMr/1gc
jqQ5AP97ZVTbopQGteWUqwgmcSpEJ6DaXzMfGJ8JRsEFEncwPQD/d9YGR41xRPtq
9ifkSdCa+JcV+2WAW25bjYGN6+hovwc=
=8mdk
-----END PGP SIGNATURE-----

--vz25knwjnl4pua2b--
