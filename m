From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -next] block: remove init_mutex in blk_iolatency_try_init
Date: Mon, 7 Aug 2023 18:05:02 +0200
Message-ID: <o6nnp6jwzpchlqsiusbioqsyaml2fonxzmzi46yrycjgtq6hyb@ixqiysu6lmpe>
References: <20230804113659.3816877-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="env6f55kcvztiepj"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691424304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bZVNSk8gsvl9GSo4kwNnLBVbqlAJHs7wB7A03Nfoabw=;
        b=tLr4BsfQPa66NZGbldX+FsBuWy8uUvhq4m+aLl58MfSznsenCiXd5FpEyS4kc0k0PQs4qV
        hWNXdEB6SVgQQnAKCpwcc1eRudbynnYMp/6R1VaLjBh7tb+yC9kdm2NIvRJg8u/Iszbsxy
        qnDbvnciKsnQT4t83hLK4O0IHfEKgFQ=
Content-Disposition: inline
In-Reply-To: <20230804113659.3816877-1-lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


--env6f55kcvztiepj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Fri, Aug 04, 2023 at 07:36:59PM +0800, Li Lingfeng <lilingfeng@huaweiclo=
ud.com> wrote:
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

I'm looking at ioc_cost_model_write() or ioc_qos_write() where is
a similar pattern.
Could the check+init be open-coded back to iolatency_set_limit() to make
code more regular?

Michal

--env6f55kcvztiepj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZNEWLQAKCRAGvrMr/1gc
jn1dAQCk1LWQd+a/FX05jNIsP4otfvuL+JS3d6sEDyf0vMaFygEAjLDMi1OjT7uC
fEqCGPmP6loMuSnafbXji32xymoC8QQ=
=98HQ
-----END PGP SIGNATURE-----

--env6f55kcvztiepj--
