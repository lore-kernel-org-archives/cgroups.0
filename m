From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] cgroup: remove unused macro for_each_e_css()
Date: Thu, 1 Jun 2023 16:06:12 +0200
Message-ID: <rzd6vcpcrxngnfannzzse5iidxsoioxscudsvxnapcrfzhf2lq@dr4yc725m457>
References: <20230527093353.153078-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7atkutyhfmrtddtv"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685628374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xbkSDAdLFYbIoAWZ1gJrOqgEs1hVPjHXyEexOto9I8A=;
        b=OFsvcR3IGJWU1vkTU/YzDEmg+rz0dQ0ZG9ZHI6OHkHIOVx7Xf3LBlZfdmKjzKSniYjH/nv
        HoQW+BjkC+fQM0nDOmL/QuexEcBaGYInAuL48PWP50HUeA2Mwr0rZdnWK3zxuaBoT7ek5y
        nZNMrc3/WyIFOS4ILCyjAcg5YLe/zBs=
Content-Disposition: inline
In-Reply-To: <20230527093353.153078-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--7atkutyhfmrtddtv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 05:33:53PM +0800, Miaohe Lin <linmiaohe@huawei.com>=
 wrote:
> for_each_e_css() is unused now. Remove it.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  kernel/cgroup/cgroup.c | 15 ---------------
>  1 file changed, 15 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>


--7atkutyhfmrtddtv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCZHil0gAKCRAkDQmsBEOq
uQEPAP9GalywFNelOaF6eV8FMJ2HWO0EOdep8H7YyRYil61QegEAtXf9VuTbZxYH
4tIj6a7SeAsQ0tiMcSTlXFSGaRwmPgU=
=b4BE
-----END PGP SIGNATURE-----

--7atkutyhfmrtddtv--
