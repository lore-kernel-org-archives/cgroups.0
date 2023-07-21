From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 16/17] cgroup/drm: Expose memory stats
Date: Fri, 21 Jul 2023 12:21:56 -1000
Message-ID: <ZLsFBHqCQdPHoZVw@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-17-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689978119; x=1690582919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=91mL5jfG2O2HHjlTT7P8VaJYQOxhCgdT7EC1VTa5Mlk=;
        b=HoTrEYR2GIsVg0GudEbf1N4STKpjkBfxcIxV8y4tckabtqJiXjkWnRyTMvEvodEDKy
         03wenOijhJ+tz7aJDaz6ktZq2S+2ea84w8eFBiNgmFbHdK3MdKsab/DgPlyqg57SV9mL
         IGK9P1QQ1OSJTXDk3wrx0YWu81fBhzrZK7dvLtbfMBKSOnWl3qh8LtIB4j6mN6+41KcR
         CPzHBXacWVpcD7202RYxOO6l77KD3p35XYRFkjBMvI62PoRHwECevgNiUY75d76DmXUK
         HnA6FyFKxSgAi4SNMPpnrnVccOXAIhNLC7OXA0S1Z7aFf6+LPA9HGgSVVY9xeboyvKdz
         tSWg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230712114605.519432-17-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Jul 12, 2023 at 12:46:04PM +0100, Tvrtko Ursulin wrote:
>   $ cat drm.memory.stat
>   card0 region=system total=12898304 shared=0 active=0 resident=12111872 purgeable=167936
>   card0 region=stolen-system total=0 shared=0 active=0 resident=0 purgeable=0
> 
> Data is generated on demand for simplicty of implementation ie. no running
> totals are kept or accounted during migrations and such. Various
> optimisations such as cheaper collection of data are possible but
> deliberately left out for now.
> 
> Overall, the feature is deemed to be useful to container orchestration
> software (and manual management).
> 
> Limits, either soft or hard, are not envisaged to be implemented on top of
> this approach due on demand nature of collecting the stats.

So, yeah, if you want to add memory controls, we better think through how
the fd ownership migration should work.

Thanks.

-- 
tejun
