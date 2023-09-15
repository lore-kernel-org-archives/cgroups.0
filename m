From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for CSS
 events
Date: Fri, 15 Sep 2023 07:58:11 -1000
Message-ID: <ZQSbM9ItXVyeIU7F@mtj.duckdns.org>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
 <ZQSaoXBg-X4cwFdX@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694800694; x=1695405494; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mmdT62MLeEsA6axk7W0K2pDhI35EHOQeEKc3uSsgrQ0=;
        b=hZuXMt1J3dQIPEM02Z4526qVSrcu3LkoUQ3N27PorLBdZ14WEh4V0cFMEFrbbyDQ75
         USKcvjmgTEVSwV12oJtSKokKx9B3+rsh2WRMSbWPLpLy3aolTxoDvGFUDhpAa9wjlgAJ
         lrUpK5VDuodvZxhrk690IjivVlyzS3YxOVKMakW5nM/bpp+gMG/RYT5BabsvGXv85O/F
         oDhJDhyUUERxrFMUHQIigoSo4Nu+vyGwlciTkWrfSdgqfjyMef9pa9WSkYecy/6XwDT2
         jgs/OlN5s55OfrvjKZGQ4KGuNrpnlWJx4R+duIVhETvCIXh8PlFvP6On0gSM+6bnZpw3
         Rnjw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZQSaoXBg-X4cwFdX-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Fri, Sep 15, 2023 at 07:55:45AM -1000, Tejun Heo wrote:
> On Tue, Sep 12, 2023 at 09:06:18PM -0700, Haitao Huang wrote:
> > @@ -37,6 +37,11 @@ struct misc_res {
> >  	u64 max;
> >  	atomic64_t usage;
> >  	atomic64_t events;
> > +
> > +	/* per resource callback ops */
> > +	int (*misc_cg_alloc)(struct misc_cg *cg);
> > +	void (*misc_cg_free)(struct misc_cg *cg);
> > +	void (*misc_cg_max_write)(struct misc_cg *cg);
> 
> A nit about naming. These are already in misc_res and cgroup_ and cgrp_
> prefixes are a lot more common. So, maybe go for sth like cgrp_alloc?

Ah, never mind about the prefix part. misc is using cg_ prefix widely
already.

Thanks.

-- 
tejun
