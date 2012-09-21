From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
Date: Fri, 21 Sep 2012 13:40:35 -0700
Message-ID: <20120921204035.GQ7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-16-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Z7TjXtppKeHBTYdkrqAm1ctaw4UZUWCe56o3zSOBHhU=;
        b=rBdn9ar2/8rQrJ32Zb8+Zc11wEouvqGel02xYxSkcWSCtOv0LyxFkph6vnrGfTAhOS
         AI8BsE5bloJTjlVl26Wm75AICA9/LQLUlJ/WE7EaOWbVL1M8XT6Y+FK2KzD2vtZIKTV0
         Af9QFlFAbgXO5JaXXkhcTH2KDV6P2RVEG8lSFPGWNCTcdhDJaLzyTCfw4n15w+c6q55y
         gXAZMA79/p7iewJ0DaoVRVBx8swYRLn4VCESIr04nfcpKLUyO9/OxYl8I20KB337qwBx
         cVmnG6RVV9YPsAwkJtoNDzb9W7uNR3JvoL0PqlldFhU8Re/XgoOhQnq2mhjds10hry9V
         taDg==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-16-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:12:09PM +0400, Glauber Costa wrote:
> @@ -764,10 +777,21 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  		goto out;
>  	}
>  
> +	/*
> +	 * Because the cache is expected to duplicate the string,
> +	 * we must make sure it has opportunity to copy its full
> +	 * name. Only now we can remove the dead part from it
> +	 */
> +	name = (char *)new_cachep->name;
> +	if (name)
> +		name[strlen(name) - 4] = '\0';

This is kinda nasty.  Do we really need to do this?  How long would a
dead cache stick around?

> diff --git a/mm/slab.c b/mm/slab.c
> index bd9928f..6cb4abf 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3785,6 +3785,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
>  	}
>  
>  	ac_put_obj(cachep, ac, objp);
> +
> +	kmem_cache_verify_dead(cachep);

Reaping dead caches doesn't exactly sound like a high priority thing
and adding a branch to hot path for that might not be the best way to
do it.  Why not schedule an extremely lazy deferrable delayed_work
which polls for emptiness, say, every miniute or whatever?

Thanks.

-- 
tejun
