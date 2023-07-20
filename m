From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm:vmscan: fix inaccurate reclaim during proactive
 reclaim
Date: Thu, 20 Jul 2023 12:24:40 -0400
Message-ID: <20230720162440.GA1015794@cmpxchg.org>
References: <20230720072708.55067-1-yangyifei03@kuaishou.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1689870282; x=1690475082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s74T/DS0uEk+n6R0wwBy5aetjEjuSLERJS55RIwoaX4=;
        b=IZzpQokKpB0UhARjk1C5AYsxhEoUwekbG1CIGPqpzF+J5EyUNV4fXvSh6ICM60s/l/
         l3LTb+/4oHtXOm/axHhrDe9RYyjLFUcJp/fjdEfH3AfdarB9wYiD6qDHqXQIUGTULJjY
         vw7yjUAGA6a1rzcc8PN64w16jP4JWgFnyix3oUPgbdJpcchORfcHKjhuGO7hDatwjMex
         Tgoo3H3N3xNYsZnI1oMU+JFxWEkqso9+qil3xyi6Lze7Drl2ReIPDqQjSEa8jAMYviY/
         z9eO+nZw1PsJ45lS/RFq6qSgkSD6Jl0gP4PD3UUJ8jAvUFV4u798afEKcJEM6QS2Vj9Y
         5HwA==
Content-Disposition: inline
In-Reply-To: <20230720072708.55067-1-yangyifei03-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Efly Young <yangyifei03-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 20, 2023 at 03:27:08PM +0800, Efly Young wrote:
> Before commit f53af4285d77 ("mm: vmscan: fix extreme overreclaim and
> swap floods"), proactive reclaim will extreme overreclaim sometimes.
> But proactive reclaim still inaccurate and some extent overreclaim.
> 
> Problematic case is easy to construct. Allocate lots of anonymous
> memory (e.g., 20G) in a memcg, then swapping by writing memory.recalim
> and there is a certain probability of overreclaim. For example, request
> 1G by writing memory.reclaim will eventually reclaim 1.7G or other
> values more than 1G.
> 
> The reason is that reclaimer may have already reclaimed part of requested
> memory in one loop, but before adjust sc->nr_to_reclaim in outer loop,
> call shrink_lruvec() again will still follow the current sc->nr_to_reclaim
> to work. It will eventually lead to overreclaim. In theory, the amount
> of reclaimed would be in [request, 2 * request).
> 
> Reclaimer usually tends to reclaim more than request. But either direct
> or kswapd reclaim have much smaller nr_to_reclaim targets, so it is
> less noticeable and not have much impact.
> 
> Proactive reclaim can usually come in with a larger value, so the error
> is difficult to ignore. Considering proactive reclaim is usually low
> frequency, handle the batching into smaller chunks is a better approach.
> 
> Signed-off-by: Efly Young <yangyifei03-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hey, I didn't write the patch, you did :) Please change it to

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

You can also add

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

[quoting remainder for new CCs]

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4b27e24..d36cf88 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6741,8 +6741,8 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>  			lru_add_drain_all();
>  
>  		reclaimed = try_to_free_mem_cgroup_pages(memcg,
> -						nr_to_reclaim - nr_reclaimed,
> -						GFP_KERNEL, reclaim_options);
> +					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
> +					GFP_KERNEL, reclaim_options);
>  
>  		if (!reclaimed && !nr_retries--)
>  			return -EAGAIN;
> -- 
> 1.8.3.1
