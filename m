From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 01/18] cgroup/misc: Add per resource callbacks for
 CSS events
Date: Tue, 26 Sep 2023 16:10:30 +0300
Message-ID: <CVSVH3ARQBRC.1QUTEQE3YNN5T@qgv27q77ld-mac>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
 <20230923030657.16148-2-haitao.huang@linux.intel.com>
 <CVS5XFKKTTUZ.XRMYK1ADHSPG@suppilovahvero>
 <op.2buytfetwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695733836;
        bh=GDQp7RRyC5swsgr+p465JJc4d2vBoN5WMysJHZ++naU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nzht4gYm6auaMDpvFO3Q3sroRMOACCjpWaWumOcbekI+j6alECIBYEYDumT23Et3N
         VcAWkq2onCsdBltq8qAjOWtoblLW451bXVGKcmeflXYOS4++rDcEAhegAV4P/qreo5
         3rJWLxleexp6I3PQgKYLczdoKI7Lrf7waVOheGzkn+DyHUfZBpPK1JmTGwo1mItGK9
         qP2xvlvl/pWKckbiBrxBFdFvwuxykzhQnnZwOoh8gDT9jGfXNn9rLdUhhAgw8Eb/xt
         yIj22r2NsghGoKMQVB6OPYKF6rf1Wyq63s7A+C3y+06vSTwptNyQc1xuMuMbZrfpfY
         PaoFQzGv/ZPQg==
In-Reply-To: <op.2buytfetwjvjmi-yDQzE4XY+yVaPPhiJ6yCxLKMmGWinSIL2HeeBUIffwg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Tue Sep 26, 2023 at 6:04 AM EEST, Haitao Huang wrote:
> Hi Jarkko
>
> On Mon, 25 Sep 2023 12:09:21 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =
=20
> wrote:
>
> > On Sat Sep 23, 2023 at 6:06 AM EEST, Haitao Huang wrote:
> >> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>
> >> The misc cgroup controller (subsystem) currently does not perform
> >> resource type specific action for Cgroups Subsystem State (CSS) events=
:
> >> the 'css_alloc' event when a cgroup is created and the 'css_free' even=
t
> >> when a cgroup is destroyed, or in event of user writing the max value =
to
> >> the misc.max file to set the usage limit of a specific resource
> >> [admin-guide/cgroup-v2.rst, 5-9. Misc].
> >>
> >> Define callbacks for those events and allow resource providers to
> >> register the callbacks per resource type as needed. This will be
> >> utilized later by the EPC misc cgroup support implemented in the SGX
> >> driver:
> >> - On css_alloc, allocate and initialize necessary structures for EPC
> >> reclaiming, e.g., LRU list, work queue, etc.
> >> - On css_free, cleanup and free those structures created in alloc.
> >> - On max_write, trigger EPC reclaiming if the new limit is at or below
> >> current usage.
> >>
> >> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> ---
> >> V5:
> >> - Remove prefixes from the callback names (tj)
> >> - Update commit message (Jarkko)
> >>
> >> V4:
> >> - Moved this to the front of the series.
> >> - Applies on cgroup/for-6.6 with the overflow fix for misc.
> >>
> >> V3:
> >> - Removed the released() callback
> >> ---
> >>  include/linux/misc_cgroup.h |  5 +++++
> >>  kernel/cgroup/misc.c        | 32 +++++++++++++++++++++++++++++---
> >>  2 files changed, 34 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> >> index e799b1f8d05b..96a88822815a 100644
> >> --- a/include/linux/misc_cgroup.h
> >> +++ b/include/linux/misc_cgroup.h
> >> @@ -37,6 +37,11 @@ struct misc_res {
> >>  	u64 max;
> >>  	atomic64_t usage;
> >>  	atomic64_t events;
> >> +
> >> +	/* per resource callback ops */
> >> +	int (*alloc)(struct misc_cg *cg);
> >> +	void (*free)(struct misc_cg *cg);
> >> +	void (*max_write)(struct misc_cg *cg);
> >>  };
> >>
> >>  /**
> >> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> >> index 79a3717a5803..62c9198dee21 100644
> >> --- a/kernel/cgroup/misc.c
> >> +++ b/kernel/cgroup/misc.c
> >> @@ -276,10 +276,13 @@ static ssize_t misc_cg_max_write(struct =20
> >> kernfs_open_file *of, char *buf,
> >>
> >>  	cg =3D css_misc(of_css(of));
> >>
> >> -	if (READ_ONCE(misc_res_capacity[type]))
> >> +	if (READ_ONCE(misc_res_capacity[type])) {
> >>  		WRITE_ONCE(cg->res[type].max, max);
> >> -	else
> >> +		if (cg->res[type].max_write)
> >> +			cg->res[type].max_write(cg);
> >> +	} else {
> >>  		ret =3D -EINVAL;
> >> +	}
> >>
> >>  	return ret ? ret : nbytes;
> >>  }
> >> @@ -383,23 +386,39 @@ static struct cftype misc_cg_files[] =3D {
> >>  static struct cgroup_subsys_state *
> >>  misc_cg_alloc(struct cgroup_subsys_state *parent_css)
> >>  {
> >> +	struct misc_cg *parent_cg;
> >>  	enum misc_res_type i;
> >>  	struct misc_cg *cg;
> >> +	int ret;
> >>
> >>  	if (!parent_css) {
> >>  		cg =3D &root_cg;
> >> +		parent_cg =3D &root_cg;
> >>  	} else {
> >>  		cg =3D kzalloc(sizeof(*cg), GFP_KERNEL);
> >>  		if (!cg)
> >>  			return ERR_PTR(-ENOMEM);
> >> +		parent_cg =3D css_misc(parent_css);
> >>  	}
> >>
> >>  	for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
> >>  		WRITE_ONCE(cg->res[i].max, MAX_NUM);
> >>  		atomic64_set(&cg->res[i].usage, 0);
> >> +		if (parent_cg->res[i].alloc) {
> >> +			ret =3D parent_cg->res[i].alloc(cg);
> >> +			if (ret)
> >> +				goto alloc_err;
> >> +		}
> >>  	}
> >>
> >>  	return &cg->css;
> >> +
> >> +alloc_err:
> >> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++)
> >> +		if (parent_cg->res[i].free)
> >> +			cg->res[i].free(cg);
> >> +	kfree(cg);
> >> +	return ERR_PTR(ret);
> >>  }
> >>
> >>  /**
> >> @@ -410,7 +429,14 @@ misc_cg_alloc(struct cgroup_subsys_state =20
> >> *parent_css)
> >>   */
> >>  static void misc_cg_free(struct cgroup_subsys_state *css)
> >>  {
> >> -	kfree(css_misc(css));
> >> +	struct misc_cg *cg =3D css_misc(css);
> >> +	enum misc_res_type i;
> >> +
> >> +	for (i =3D 0; i < MISC_CG_RES_TYPES; i++)
> >> +		if (cg->res[i].free)
> >> +			cg->res[i].free(cg);
> >> +
> >> +	kfree(cg);
> >>  }
> >>
> >>  /* Cgroup controller callbacks */
> >> --
> >> 2.25.1
> >
> > Since the only existing client feature requires all callbacks, should
> > this not have that as an invariant?
> >
> > I.e. it might be better to fail unless *all* ops are non-nil (e.g. to
> > catch issues in the kernel code).
> >
>
> These callbacks are chained from cgroup_subsys, and they are defined =20
> separately so it'd be better follow the same pattern.  Or change together=
 =20
> with cgroup_subsys if we want to do that. Reasonable?

I noticed this one later:

It would better to create a separate ops struct and declare the instance
as const at minimum.

Then there is no need for dynamic assigment of ops and all that is in
rodata. This is improves both security and also allows static analysis
bit better.

Now you have to dynamically trace the struct instance, e.g. in case of
a bug. If this one done, it would be already in the vmlinux.

BR, Jarkko
