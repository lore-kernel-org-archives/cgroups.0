From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 15/17] cgroup/drm: Expose GPU utilisation
Date: Fri, 21 Jul 2023 12:20:18 -1000
Message-ID: <ZLsEomsuxoy-YnkA@slm.duckdns.org>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-16-tvrtko.ursulin@linux.intel.com>
 <ZLsEdJeEAPYWFunT@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689978020; x=1690582820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6xRYi4aCBF7mvF9Wq1OcAPDild54ArRewQg4E7JKv4=;
        b=KkHPlyzjqy+65JjxuJgW31Z63b8E8dgBPO23fclVK63J02CdQ4bxPgkvvAcvKpvVB8
         KLce+Y4ZAIlKYS25+ziMYw/Ue1uBPq8EvSWA7k4Zot0rP9lRUYXzVhQLw8oH9wPhebx8
         NDFJS1ksZygEE55Cy7PS8rPXlxFm8JFiH6/TRQoEg+hvZzcGB/KgAwgGaynsy1r+ZgBH
         jwlXF+OvqxKXIamZwRS/075w9H0D/NVYXwuSCjD5K8KsvkhjJBDJSTHZEACzM1+Kfw+n
         WrDXkZg+aWxz2TFpOjN4Jhi7B4IQ3R8WYEVmN/7/EbmWj6bSLy9fgmRv/x1Ll42WXGhL
         EZ8Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZLsEdJeEAPYWFunT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eero Tamminen <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Jul 21, 2023 at 12:19:32PM -1000, Tejun Heo wrote:
> On Wed, Jul 12, 2023 at 12:46:03PM +0100, Tvrtko Ursulin wrote:
> > +  drm.active_us
> > +	GPU time used by the group recursively including all child groups.
> 
> Maybe instead add drm.stat and have "usage_usec" inside? That'd be more
> consistent with cpu side.

Also, shouldn't this be keyed by the drm device?

-- 
tejun
