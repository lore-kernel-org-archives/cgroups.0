From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for
 CSS events
Date: Wed, 13 Sep 2023 12:39:06 +0300
Message-ID: <CVHOU5G1SCUT.RCBVZ3W8G2NJ@suppilovahvero>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694597951;
        bh=dSg3FHeMAumbmUvzWNHW95nSf89/Wz3zP7aimaIkbxI=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=ZXzWXrwu9RC5kdgvyD4Ye5Agb5QzVO02jBJEW0mnHaQpEFqlkH9MjuSEVgXaUrJmq
         EfQzJwDD9BBpXXvndNj+eIkUmIlhnnrBnsgfdmO/sFI5PRoHRFwjrU0y6hxj6aL84H
         I/1JlDKdOO1LKXWPAMI7ktI9zNLjuHZKAgw7jpbATlCAQIIfwwhGBcxlYjrAwHRiWN
         2hlxUuKCUSaDDKSY2Qy6K2Eom2p4u9TlGy9UGMjX9bItwj7Dnlyod7p1U3kbdl/FiD
         Wu/LBlqhgtKWx1dvr4RG1Rdjsr2CT7nXCgU1y7jqToY0rPbmBIx4XdymwLrsZa4tpi
         czcohdodFxFCA==
In-Reply-To: <20230913040635.28815-2-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed Sep 13, 2023 at 7:06 AM EEST, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> Consumers of the misc cgroup controller might need to perform separate
> actions for Cgroups Subsystem State(CSS) events: cgroup alloc and free.

nit: s/State(CSS)/State (CSS)/

"cgroup alloc" and "cgroup free" mean absolutely nothing.


> In addition, writes to the max value may also need separate action. Add

What "the max value"?

> the ability to allow downstream users to setup callbacks for these
> operations, and call the corresponding per-resource-type callback when
> appropriate.

Who are "the downstream users" and what sort of callbacks they setup?

>
> This code will be utilized by the SGX driver in a future patch.
>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
> V4:
> - Moved this to the front of the series.
> - Applies on cgroup/for-6.6 with the overflow fix for misc.
>
> V3:
> - Removed the released() callback
> ---
>  include/linux/misc_cgroup.h |  5 +++++
>  kernel/cgroup/misc.c        | 32 +++++++++++++++++++++++++++++---
>  2 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index e799b1f8d05b..e1bcd176c2de 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -37,6 +37,11 @@ struct misc_res {
>  	u64 max;
>  	atomic64_t usage;
>  	atomic64_t events;
> +
> +	/* per resource callback ops */
> +	int (*misc_cg_alloc)(struct misc_cg *cg);
> +	void (*misc_cg_free)(struct misc_cg *cg);
> +	void (*misc_cg_max_write)(struct misc_cg *cg);
>  };
> =20
>  /**
> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> index 79a3717a5803..e0092170d0dd 100644
> --- a/kernel/cgroup/misc.c
> +++ b/kernel/cgroup/misc.c
> @@ -276,10 +276,13 @@ static ssize_t misc_cg_max_write(struct kernfs_open=
_file *of, char *buf,
> =20
>  	cg =3D css_misc(of_css(of));
> =20
> -	if (READ_ONCE(misc_res_capacity[type]))
> +	if (READ_ONCE(misc_res_capacity[type])) {
>  		WRITE_ONCE(cg->res[type].max, max);
> -	else
> +		if (cg->res[type].misc_cg_max_write)
> +			cg->res[type].misc_cg_max_write(cg);
> +	} else {
>  		ret =3D -EINVAL;
> +	}
> =20
>  	return ret ? ret : nbytes;
>  }
> @@ -383,23 +386,39 @@ static struct cftype misc_cg_files[] =3D {
>  static struct cgroup_subsys_state *
>  misc_cg_alloc(struct cgroup_subsys_state *parent_css)
>  {
> +	struct misc_cg *parent_cg;
>  	enum misc_res_type i;
>  	struct misc_cg *cg;
> +	int ret;
> =20
>  	if (!parent_css) {
>  		cg =3D &root_cg;
> +		parent_cg =3D &root_cg;
>  	} else {
>  		cg =3D kzalloc(sizeof(*cg), GFP_KERNEL);
>  		if (!cg)
>  			return ERR_PTR(-ENOMEM);
> +		parent_cg =3D css_misc(parent_css);
>  	}
> =20
>  	for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
>  		WRITE_ONCE(cg->res[i].max, MAX_NUM);
>  		atomic64_set(&cg->res[i].usage, 0);
> +		if (parent_cg->res[i].misc_cg_alloc) {
> +			ret =3D parent_cg->res[i].misc_cg_alloc(cg);
> +			if (ret)
> +				goto alloc_err;
> +		}
>  	}
> =20
>  	return &cg->css;
> +
> +alloc_err:
> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++)
> +		if (parent_cg->res[i].misc_cg_free)
> +			cg->res[i].misc_cg_free(cg);
> +	kfree(cg);
> +	return ERR_PTR(ret);
>  }
> =20
>  /**
> @@ -410,7 +429,14 @@ misc_cg_alloc(struct cgroup_subsys_state *parent_css=
)
>   */
>  static void misc_cg_free(struct cgroup_subsys_state *css)
>  {
> -	kfree(css_misc(css));
> +	struct misc_cg *cg =3D css_misc(css);
> +	enum misc_res_type i;
> +
> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++)
> +		if (cg->res[i].misc_cg_free)
> +			cg->res[i].misc_cg_free(cg);
> +
> +	kfree(cg);
>  }
> =20
>  /* Cgroup controller callbacks */
> --=20
> 2.25.1

BR, Jarkko
