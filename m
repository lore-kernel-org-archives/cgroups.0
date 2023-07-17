From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 08:57:59 -1000
Message-ID: <ZLWPN_xyGFrqqJkV@slm.duckdns.org>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
 <CU4OCLEHU1S5.359W394902648@seitikki>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689620281; x=1692212281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R8dRbDx5OSxI2KS2h9OabLw4RmAj19B/uXTDt0GaZHU=;
        b=gavjJiyKOJJ91nNIatF2UTY1MOjBA/LN5qn+DvBE1EDa8T2NoqnsMZXv2uo1iq24e2
         9IH7V8sh8o2+DFZj4ze/lqiTegaBY9fD4X/iALxVQhuW07SMmRQTmY/v034iTc1PU98c
         RzzRZl2usbAewfMoSn3QyfhBpw4FcqTUkuYH+1PwX2IKaR1CdzYtW7eRHzo9uVcjXBEg
         w8oLkzy0Mz7niu+EPyCvt9EdQabvlU+flcojaLOAYsID14Zi6hcOcgULkg7aIpmLWGYs
         gzb+jgZsLdkAXNcmJb2382ngichavzupucGljPu7ZkGWp1O5tNCFrZ/ivZJ8yKKHoMmi
         Z+bA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CU4OCLEHU1S5.359W394902648@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Mon, Jul 17, 2023 at 06:55:32PM +0000, Jarkko Sakkinen wrote:
> On Mon Jul 17, 2023 at 6:47 PM UTC, Haitao Huang wrote:
> > The variable 'new_usage' in misc_cg_try_charge() may overflow if it
> > becomes above INT_MAX. This was observed when I implement the new SGX
> > EPC cgroup[1] as a misc cgroup and test on a platform with large SGX EPC
> > sizes.
> >
> > Change type of new_usage to long from int and check overflow.
> >
> > Fixes: a72232eabdfcf ("cgroup: Add misc cgroup controller")
> > Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > [1] https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
> > ---
> >  kernel/cgroup/misc.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
> > index fe3e8a0eb7ed..ff9f900981a3 100644
> > --- a/kernel/cgroup/misc.c
> > +++ b/kernel/cgroup/misc.c
> > @@ -143,7 +143,7 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
> >  	struct misc_cg *i, *j;
> >  	int ret;
> >  	struct misc_res *res;
> > -	int new_usage;
> > +	long new_usage;
> >  
> >  	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
> >  		return -EINVAL;
> > @@ -153,10 +153,10 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
> >  
> >  	for (i = cg; i; i = parent_misc(i)) {
> >  		res = &i->res[type];
> > -
> 
> This is extra noise in the patch, please remove the change.

Lemme just revert it. Haitao, can you instead make the resource counters and
all related variables explicit 64bit instead?

Thanks.

-- 
tejun
