From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/17] cgroup/drm: Expose GPU utilisation
Date: Tue, 25 Jul 2023 11:44:12 -1000
Message-ID: <ZMBCLJMLL_cl9G_e@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-16-tvrtko.ursulin@linux.intel.com>
 <ZLsEdJeEAPYWFunT@slm.duckdns.org>
 <ZLsEomsuxoy-YnkA@slm.duckdns.org>
 <3b96cada-3433-139c-3180-1f050f0f80f3@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690321455; x=1690926255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LMF20IZtbfCz3aU/3bfXT+An6WYKlC9WFpBOERsbLtc=;
        b=cuSOP3cY00kalmUDb+byhPR92kTHul30bSE157ciDmWkuI3153sw6DFVNwFXC73ZZH
         AMb7lJ2vBq3NfzlR75VP9ViihITZUUBuwZSP+iZbcnGqMdmLWEqXA3VleLVomwy1AQ7K
         ot9lBHyDBPxyHGh8V0vMqtTuB/kS4Flz9vR00TJzFanJ7/hOzkkIhAlOcCaVYUWR/q4O
         PXmqDHD51oaTBEblzjHQjFk3hcSdEHYiNZdxxP7RxHHD4HSfdG65/jyaMhgqcPMVdOgf
         DDMqgL1wXsE0INWvlim252xKspmHeBqwoIe1+prRY5UcjPYodxV6TTiAF6/c+R5lSC29
         IUzg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3b96cada-3433-139c-3180-1f050f0f80f3-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Tue, Jul 25, 2023 at 03:08:40PM +0100, Tvrtko Ursulin wrote:
> > Also, shouldn't this be keyed by the drm device?
>
> It could have that too, or it could come later. Fun with GPUs that it not
> only could be keyed by the device, but also by the type of the GPU engine.
> (Which are a) vendor specific and b) some aree fully independent, some
> partially so, and some not at all - so it could get complicated semantics
> wise really fast.)

I see.

> If for now I'd go with drm.stat/usage_usec containing the total time spent
> how would you suggest adding per device granularity? Files as documented
> are either flag or nested, not both at the same time. So something like:
> 
> usage_usec 100000
> card0 usage_usec 50000
> card1 usage_usec 50000
> 
> Would or would not fly? Have two files along the lines of drm.stat and drm.dev_stat?

Please follow one of the pre-defined formats. If you want to have card
identifier and field key, it should be a nested keyed file like io.stat.

> While on this general topic, you will notice that for memory stats I have
> _sort of_ nested keyed per device format, for example on integrated Intel
> GPU:
> 
>   $ cat drm.memory.stat
>   card0 region=system total=12898304 shared=0 active=0 resident=12111872 purgeable=167936
>   card0 region=stolen-system total=0 shared=0 active=0 resident=0 purgeable=0
> 
> If one a discrete Intel GPU two more lines would appear with memory
> regions of local and local-system. But then on some server class
> multi-tile GPUs even further regions with more than one device local
> memory region. And users do want to see this granularity for container use
> cases at least.
> 
> Anyway, this may not be compatible with the nested key format as
> documented in cgroup-v2.rst, although it does not explicitly say.
> 
> Should I cheat and create key names based on device and memory region name
> and let userspace parse it? Like:
> 
>   $ cat drm.memory.stat
>   card0.system total=12898304 shared=0 active=0 resident=12111872 purgeable=167936
>   card0.stolen-system total=0 shared=0 active=0 resident=0 purgeable=0

Yeah, this looks better to me. If they're reporting different values for the
same fields, they're separate keys.

Thanks.

-- 
tejun
