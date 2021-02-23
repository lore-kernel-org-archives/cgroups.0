From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix slub memory accounting
Date: Tue, 23 Feb 2021 19:42:27 +0100
Message-ID: <YDVMk+GQ943JXGz6@blackbook>
References: <20210223092423.42420-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IG0eXaihVNtABiw1"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614105756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QZ33EKFydKYQll/wNBrYJt9SLMpJFdNX6PK6738sxL4=;
        b=mRqz5RlxY0MleyIZCOCdydEysSrolgNwxZXrgyikDtYy1z8XMTWGF98OFHNS48BU9VNXn+
        hyu7Y2zGqWmCaeLcc37RctNV3xOx9vTeKixinggl492o/U0QDr7KtYdw/h6EKKOjAClx2o
        85Yyb5VCteuKVyX9O1ML24HqsJ1TiBo=
Content-Disposition: inline
In-Reply-To: <20210223092423.42420-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--IG0eXaihVNtABiw1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2021 at 05:24:23PM +0800, Muchun Song <songmuchun@bytedance=
=2Ecom> wrote:
>  mm/slab_common.c | 4 ++--
>  mm/slub.c        | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

--IG0eXaihVNtABiw1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmA1TI8ACgkQia1+riC5
qSiWAQ/9HoHZzRkfByT6xtaSn15MABMfGyy9kpE9KTK6y30Id4ErEgc+l0uy9jSz
W3omUt+e01+K0G7jDAwTN8dK/SevY/IpENprCxKMVkZ3thk4OO72uAy4ip7Ahpc5
j4YUVofSMiHeM8BRg0jyNURYnAjD5zI1tS3D9xVVe5EFnbhSBw5ur3gTNTjs9ZUd
N9Iu5BVUmohXes7P0Z1vyFOSuvyf4bWDPb1sHnHPU9n73p6lPQ+0Z9o7ph1nR5zZ
0SG48AnWW5sEiCDxvGU27NpnNueLfTz9tBiAd5f/k1VJSZyPez1aJXcRYnQDAuxo
H9AgsQnO7BmHR2+doyHjlfaPkRtXT5QLSq/0z87hf/T78eTYMlG7hLTo2DHMEdKA
L+Jx7JQo0IasKOmID/nmL14PMDs5XYRWxw1y+DW1G0kW7u/0Th8sgMLkh0qQQYZx
m5gTJIXJ0mZjnZoK0hQqtxkuVnTvPMTy5fTvFlduzoIp1pILkdjNmFxWg8ZAenIA
lYoCkkPd17lOF7vC4jXo/L9gFSOyODZamS/jbjnwo9GqadMYiAJNHo4ShIoF3YAz
dyG5TSSVFDzn9XdwMfwPg7tBUtD6GiLG7GLjKT+IJM6LO5wFoDeQPCag41KgxTDn
SSwi1GdzHGyrGDH6JcTmAqWDudbmvTdK065ntc7Zj2XmRXMTeDc=
=7qx0
-----END PGP SIGNATURE-----

--IG0eXaihVNtABiw1--
