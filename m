From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 03/16] slab: Ignore the cflgs bit in cache creation
Date: Fri, 21 Sep 2012 10:33:52 -0700
Message-ID: <20120921173352.GE7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=P1j2zFXeAxQPy2AkFIYCXKKs6qSXZJ+LEee57ihFOqA=;
        b=IA0qRD/mLRzm9AFi3zWiqZ6N9/Lt3FUGcBYQwtJz/OEoPJDxxojewc20q3Oc501IUZ
         scxAJ9clS5A6Peptk2rY2d65XZ07jv9laRM1l3ouJtMmYeQgot9nFTgFzg1fPT9ndrd9
         m8vutgiCxw8LU4N+bmKo4UQet7U8bAHoIgmVRnmFg+nplgWA0bLo7IzHhkB5eoxnMSfJ
         DEwJHCbg2yOLSV6flTW/50swcx/WV0ksitq4izwhCtWwXTovPBJmOGmOPHE500Blos/z
         v2sFRUCBqc6tDzZVqHM0CFXqI0PrNHNVN6QZkBgTW/YbjMRsu4nxOnH2W8C8cbj/uvhl
         iJ8A==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, Sep 18, 2012 at 06:11:57PM +0400, Glauber Costa wrote:
> No cache should ever pass that as a creation flag, since this bit is
> used to mark an internal decision of the slab about object placement. We
> can just ignore this bit if it happens to be passed (such as when
> duplicating a cache in the kmem memcg patches)
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/slab.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index a7ed60f..ccf496c 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2373,6 +2373,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>  	int err;
>  	size_t size = cachep->size;
>  
> +	flags &= ~CFLGS_OFF_SLAB;

A comment explaining why this is necessary wouldn't hurt.

Thanks.

-- 
tejun
