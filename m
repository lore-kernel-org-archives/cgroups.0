From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests: cgroup: fix unexpected failure on
 test_memcg_low
Date: Tue, 23 May 2023 16:40:46 +0200
Message-ID: <r5owzlvxbx22gqmw2cnmykvrzzhhw3hkoffk3f4wbvv7lmqzod@wbbmnt4a76cu>
References: <20230522095233.4246-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qrfw5lltt6r2lzen"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684852848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGlr9RSvSIRIegvdJA3tDbcOz/gxFk1P8G5vHNFFvdw=;
        b=Uxk2np0yuV6dsJAJsvbMA15zF96rjED8fP2akEhLxsmTpt+feyN2T/XT2pX2L8XeAZ4ZNd
        x/FzKx4vRGic0qaTq8sE2kEc12gKEby+NSQYZAjT9a/i9yg98rtiR1IHPVBAP/QqZKzzcp
        /LSS2uf6XfVEVLuRagQgPj5k0Vkwt7U=
Content-Disposition: inline
In-Reply-To: <20230522095233.4246-2-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--qrfw5lltt6r2lzen
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 22, 2023 at 09:52:33AM +0000, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org=
> wrote:
> Since commit f079a020ba95 ("selftests: memcg: factor out common parts
> of memory.{low,min} tests"), the value used in second alloc_anon has
> changed from 148M to 170M. Because memory.low allows reclaiming page
> cache in child cgroups, so the memory.current is close to 30M instead
> of 50M. Therefore, adjust the expected value of parent cgroup.
>=20
> Fixes: f079a020ba95 ("selftests: memcg: factor out common parts of memory=
=2E{low,min} tests")
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Yes, the expected value should be complement of the allocation to the
limit when reclaim is allowed.

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

FTR, the test_memcg_low fails after the fix still (6.3.1-2-default)
because of nonzero memory.events:low in the unprotected A/B/E group
(with memory_recursiveprot).
(That's another and long standing issues -- perhaps the reason why this
issue was hidden.)

Thanks,
Michal

--qrfw5lltt6r2lzen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZGzQbAAKCRAkDQmsBEOq
uZ7BAQCh/IzL0Y/nVUwN/zZJm3gzAUIYiiYkjKXr3IdIi/nEEAD8CrjZAUCERkWq
My0modfCN7u48OMYoc2a0660bD9tYww=
=er1S
-----END PGP SIGNATURE-----

--qrfw5lltt6r2lzen--
