From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] mm, memcg: expose swapcache stat for memcg v1
Date: Thu, 7 Sep 2023 17:24:52 +0200
Message-ID: <mei7epglsl25g4q5xe7pvh4drvnepp6ojuspd5hhfceg2nheui@pnfvj3ttsisj>
References: <20230902100728.3850149-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wxfpj2ogfybqrtvf"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694100294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zFcvvMfLX/FLCw89MZD/SftO31WVSjyKM8zaaef4qC0=;
        b=jnp2YcfgSBGHrqpz0lPrMlO2WAiAnLH5iVvvgzOw4A0LNJAcaIhIAL2PfJWwQMnErcne/D
        d6Iy5cxt7/mnHfXeO6GKOwiWGZ62czzPOrS5mtYz82g64fG2uLRVcwc+jaVSKc0/vZ7CX5
        yAfGbYQLBoFhWbc4LrA1JQ7NVZlcV4Q=
Content-Disposition: inline
In-Reply-To: <20230902100728.3850149-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Liu Shixin <liushixin2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org


--wxfpj2ogfybqrtvf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

On Sat, Sep 02, 2023 at 06:07:28PM +0800, Liu Shixin <liushixin2@huawei.com=
> wrote:
> Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2")
> adds swapcache stat for the cgroup v2, it seems there is no reason to
> hide it in memcg v1. Conversely, with swapcached it is more accurate to
> evaluate the available memory for memcg.

Hm, since the commit b25806dcd3d5 ("mm: memcontrol: deprecate swapaccountin=
g=3D0 mode")=20
do_memsw_account() is synonymous with
!cgroup_subsys_on_dfl(memory_cgrp_subsys) so its uses in
memcg1_stat_format can be simplified.

Would you mind making your patch into a series with (to keep diffstat
low ;-)):

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4098,8 +4098,6 @@ static void memcg1_stat_format(struct mem_cgroup *mem=
cg, struct seq_buf *s)
        for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++) {
                unsigned long nr;
=20
-               if (memcg1_stats[i] =3D=3D MEMCG_SWAP && !do_memsw_account(=
))
-                       continue;
                nr =3D memcg_page_state_local(memcg, memcg1_stats[i]);
                seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
                           nr * memcg_page_state_unit(memcg1_stats[i]));
@@ -4122,15 +4120,12 @@ static void memcg1_stat_format(struct mem_cgroup *m=
emcg, struct seq_buf *s)
        }
        seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
                       (u64)memory * PAGE_SIZE);
-       if (do_memsw_account())
-               seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-                              (u64)memsw * PAGE_SIZE);
+       seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
+                      (u64)memsw * PAGE_SIZE);
=20
        for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++) {
                unsigned long nr;
=20
-               if (memcg1_stats[i] =3D=3D MEMCG_SWAP && !do_memsw_account(=
))
-                       continue;
                nr =3D memcg_page_state(memcg, memcg1_stats[i]);
                seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
                           (u64)nr * memcg_page_state_unit(memcg1_stats[i])=
);


Also,
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4068,6 +4068,9 @@ static const unsigned int memcg1_stats[] =3D {
>  	WORKINGSET_REFAULT_ANON,
>  	WORKINGSET_REFAULT_FILE,
>  	MEMCG_SWAP,
> +#ifdef CONFIG_SWAP
> +	NR_SWAPCACHE,
> +#endif
>  };

The guard should cover both NR_SWAPCACHE and MEMCG_SWAP or none, no?
(Similarly in memcg1_stat_names.)

Thanks,
Michal


--wxfpj2ogfybqrtvf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZPnrQgAKCRAGvrMr/1gc
jn8BAP9ux2iqMVWdi0SIkBy8fzCs7S97CpmXcNHLQr2/54hnqQD/crinaGH5Lq0o
qJTHnwxhWG1t9D1dZK8ifnirUwdT/wY=
=KKmU
-----END PGP SIGNATURE-----

--wxfpj2ogfybqrtvf--
