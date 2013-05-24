From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v8 20/34] i915: bail out earlier when shrinker cannot
 acquire mutex
Date: Fri, 24 May 2013 23:57:08 +0200
Message-ID: <20130524215708.GK15743@phenom.ffwll.local>
References: <1369391368-31562-1-git-send-email-glommer@openvz.org>
 <1369391368-31562-21-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:x-operating-system:user-agent;
        bh=3RDXD0p5OWjkvrxHJsvB5y1Eb49vAXCovb1tdHeUw+w=;
        b=CUlznuIA8FhN279Sn5UjPKSXZy293LLymTTPjuvED52VUnM/xPSkdWjoOKZA741uL7
         Aj2Zw9a1f6VHSr0KaciOYdlFwxz9FaaZyHiqK4pR9sakZaRAi8N4JCfP7M6ytky/HdZA
         p005oRN7WgrQ26Dr75uz9M/QNV1ROUTWs6O+Q=
Content-Disposition: inline
In-Reply-To: <1369391368-31562-21-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, May 24, 2013 at 03:59:14PM +0530, Glauber Costa wrote:
> The main shrinker driver will keep trying for a while to free objects if
> the returned value from the shrink scan procedure is 0.  That means "no
> objects now", but a retry could very well succeed.
> 
> A negative value has a different meaning. It means it is impossible to
> shrink, and we would better bail out soon. We find this behavior more
> appropriate for the case where the lock cannot be taken. Specially given
> the hammer behavior of the i915: if another thread is already shrinking,
> we are likely not to be able to shrink anything anyway when we finally
> acquire the mutex.
> 
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
> CC: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>

> ---
>  drivers/gpu/drm/i915/i915_gem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 6b17122..52b3ac1 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -4448,10 +4448,10 @@ i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control *sc)
>  
>  	if (!mutex_trylock(&dev->struct_mutex)) {
>  		if (!mutex_is_locked_by(&dev->struct_mutex, current))
> -			return 0;
> +			return -1;
>  
>  		if (dev_priv->mm.shrinker_no_lock_stealing)
> -			return 0;
> +			return -1;
>  
>  		unlock = false;
>  	}
> -- 
> 1.8.1.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
