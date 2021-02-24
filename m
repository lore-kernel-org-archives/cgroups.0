From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: enable memcg oom-kill for __GFP_NOFAIL
Date: Wed, 24 Feb 2021 10:14:31 +0100
Message-ID: <YDYY96mqxfUSBgdp@dhcp22.suse.cz>
References: <20210223204337.2785120-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614158072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FeA/2l27nVF/DGAxR2L37LYDHmL612+GcS6A2XoF94U=;
        b=aaBZQMHz3G2QqX4ncvXcTnQO6jkI1yH4iqWbcFQWhBD7EViANhw9jiT2vp3seI1HsyFSHz
        ZGrnILaRTgItVS3oEERlci6psg1StBolgA/TJ9EfmWhvjHMFwKMRGLT9uASLTYL9THTzg8
        2dQ0FGLeQuWebMaa7i6C5FzcFk63OKs=
Content-Disposition: inline
In-Reply-To: <20210223204337.2785120-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 23-02-21 12:43:37, Shakeel Butt wrote:
> In the era of async memcg oom-killer, the commit a0d8b00a3381 ("mm:
> memcg: do not declare OOM from __GFP_NOFAIL allocations") added the code
> to skip memcg oom-killer for __GFP_NOFAIL allocations. The reason was
> that the __GFP_NOFAIL callers will not enter aync oom synchronization
> path and will keep the task marked as in memcg oom. At that time the
> tasks marked in memcg oom can bypass the memcg limits and the oom
> synchronization would have happened later in the later userspace
> triggered page fault. Thus letting the task marked as under memcg oom
> bypass the memcg limit for arbitrary time.
> 
> With the synchronous memcg oom-killer (commit 29ef680ae7c21 ("memcg,
> oom: move out_of_memory back to the charge path")) and not letting the
> task marked under memcg oom to bypass the memcg limits (commit
> 1f14c1ac19aa4 ("mm: memcg: do not allow task about to OOM kill to bypass
> the limit")), we can again allow __GFP_NOFAIL allocations to trigger
> memcg oom-kill. This will make memcg oom behavior closer to page
> allocator oom behavior.

The patch is correct, I just do follow why 1f14c1ac19aa4 is really
relevant here. There nomem label wouldn't make any difference for
__GFP_NOFAIL requests. The code has has changed quite a lot since then.
 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This is a clear overlook when I moved the oom handling back to the
charge path. Thanks for the fixup.
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2db2aeac8a9e..dcb5665aeb69 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2797,9 +2797,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (gfp_mask & __GFP_RETRY_MAYFAIL)
>  		goto nomem;
>  
> -	if (gfp_mask & __GFP_NOFAIL)
> -		goto force;
> -
>  	if (fatal_signal_pending(current))
>  		goto force;
>  
> -- 
> 2.30.0.617.g56c4b15f3c-goog

-- 
Michal Hocko
SUSE Labs
