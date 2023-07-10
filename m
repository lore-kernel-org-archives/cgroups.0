From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Mon, 10 Jul 2023 17:46:12 +0200
Message-ID: <ue4duahv6scnn64zgduuhiyq2gh33w7x5ftdffw3uqcn4ahyd2@txxtxf2fkzp2>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kyoxkof3brdp3vbp"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689003973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Csf/O53K061Tg2O8DUcAmJ7TXCxHkY96GEDUe2hk864=;
        b=RZe3jCqnQgAh5tdMl3sCRcNfotwRAgzSOz2BVkOFs9k4b/FZP5ITr5hQIt91PoxufhAG42
        wL7ZJbjnQQfjKSEkclDuqxso6t318xk/U9jWnV3Zats3gJ5tZfrLx7AZpvzdZ6tO1ZsfOo
        Zj+zO02nA6M0SGiuqFSULOcz9ZbN/7c=
Content-Disposition: inline
In-Reply-To: <20230701073856.2095425-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--kyoxkof3brdp3vbp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin <linmiaohe@huawei.com>=
 wrote:
> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
> it to simplify the code. No functional change intended.

I'd add a comment that it builds upon cgroup_addrm_files()'s:
> For removals, this function never fails.

> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  kernel/cgroup/cgroup.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--kyoxkof3brdp3vbp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZKwnwgAKCRAGvrMr/1gc
jnYVAPwMLLOEYIeph0SWge4e4A3F5ye6RxReGFqVGXVEK09OngD+J+R/PCIA08hT
CiKosuzZJmwkLRKsTW4SlJ9cUwbSNQU=
=VAXP
-----END PGP SIGNATURE-----

--kyoxkof3brdp3vbp--
