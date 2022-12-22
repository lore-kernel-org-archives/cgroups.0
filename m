From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: don't make all constants unsigned long long
Date: Thu, 22 Dec 2022 14:58:55 +0100
Message-ID: <20221222135855.GC20830@blackbody.suse.cz>
References: <20221220201819.1497577-1-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671717537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKATc+B04yPGuwVoMjN+880psfHG481KAwJvLG9IAuY=;
        b=WBq6ASIWKvgNfUiotGOXishHrXz1OaT2uQNWZx8kpWVUeCyV4sC+9XgZFcx3hg0MIFTKEE
        FNnScyG76pkyCA01ofhDM+9a43A/HvwDIbpjwQDoV5rxUo9JtKhJwoEky3vMyPimd2ZCzg
        a1pscpFiO+riwT3DwA6cEVpiLPIz1/g=
Content-Disposition: inline
In-Reply-To: <20221220201819.1497577-1-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 20, 2022 at 09:18:19PM +0100, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:
> +enum {
>  	/* switch iff the conditions are met for longer than this */
>  	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
> +};

This looks gratuitous.

What about indivudial #defines with typed literals instead of the "lazy
splitting"?

Regards,
Michal

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY6RingAKCRAkDQmsBEOq
uVPgAP4y2ImrULaeHe+Vpcp/aQaKYMrV7D3Q1d9z39OiU0CmwQD+PBJ70cOphLPH
5zWBwTr/hS3qRiIJ7Feh9YL4sjTrig8=
=ZT8m
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
