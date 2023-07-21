From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/17] cgroup/drm: Expose GPU utilisation
Date: Fri, 21 Jul 2023 12:19:32 -1000
Message-ID: <ZLsEdJeEAPYWFunT@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-16-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689977974; x=1690582774;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LsrbrVHFxjwjByjc6/UZrNrL/NPET1Wevp1mB/G/Lmc=;
        b=D6dXczY+0qF8EjPi28ps6MVuYsmGnnl07dBtmDJMYl7vBhxNbiI46WCsnYerS3mdC1
         KJe0HOBXRp4SjPvPuqJThZbDALy0UO3m+BCzAkLWsKYZok+M09tI1Ijg6hiHp0FjDR2g
         Wfe3Md02hxCbKwHsJLZNfRvIrRMW2zZr9NZneiEEC96Gb7gHmArpMdUNDYUP+EfOvpHM
         b7FbtaG8csDOKZ4KQlozssqHNZVcuBMG/+KXvbQME5X35/ARjyJ22OOe/U9bFIwvi1GD
         ttfxFjpx6YWTM60Q/ICBRYeD67D4yI0TYfK7ByJPBQzZ/NAyniSv3hzNsiZk7+SnT9z2
         wiNw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230712114605.519432-16-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Jul 12, 2023 at 12:46:03PM +0100, Tvrtko Ursulin wrote:
> +  drm.active_us
> +	GPU time used by the group recursively including all child groups.

Maybe instead add drm.stat and have "usage_usec" inside? That'd be more
consistent with cpu side.

Thanks.

-- 
tejun
