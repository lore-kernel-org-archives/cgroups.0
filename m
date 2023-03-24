From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/1] Fix vmstat_percpu incorrect subtraction after
 reparent
Date: Fri, 24 Mar 2023 18:14:11 +0100
Message-ID: <20230324171411.t2romq3ydphoonu2@blackpad>
References: <20230320030648.50663-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ps5la3sopyo7hm5"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679678053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=porIllnFw2p86E2ijRdzEbR8T3FBX2CIBdas6/Gd6LM=;
        b=jNC/qpMiWtn8ZgQtU4A5VS7jMHFB68+eObtzqVIN51ypAMW/Ky4K3757kbkbewPI+S4o0/
        9wP6YVvSr/W/oORA3ewkTTignhMg2px7JA36e5FimP8QjD85IoHibcNR2Z7Ztuxr5A9Dyc
        CB5+QL8FBM5fxNh5CZY/p5MsWHl3hYg=
Content-Disposition: inline
In-Reply-To: <20230320030648.50663-1-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mpenttil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org


--7ps5la3sopyo7hm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:06:47AM +0000, Cai Xinchen <caixinchen1@huawei.c=
om> wrote:
> There are two problems left:
>=20
>      root
>      /  \
>     A    B
>    / \    \
>   C   E    D
>=20
> 1. In some case of reparent, some page cache may be used by other memcg
> D but it charges to the parent memcg A of dying memcg E. D is getting
> away with using the page for free while A is taxed.

Note that A is (effectively) taxed even before E is removed due to
hierarchical nature of charging. Then what you describe transforms into
"well-known" problem of shared charging (with not well-known solution
:-/).

HTH,
Michal

--7ps5la3sopyo7hm5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZB3aYQAKCRAkDQmsBEOq
uULUAQCHRvKpQPSDHUkOEFl2uZo3E7GeJT8AUOQoAsdb9Scv3wEA6jAYPC9q+nvp
FbwIeniHgYs6j4F0z5/Y/u/CsVBLuQw=
=CvmU
-----END PGP SIGNATURE-----

--7ps5la3sopyo7hm5--
