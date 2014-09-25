From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Date: Thu, 25 Sep 2014 16:23:12 +0200
Message-ID: <20140925142312.GE11080@dhcp22.suse.cz>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
 <20140925025758.GA6903@mtj.dyndns.org>
 <20140925134342.GB22508@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hJ+uuZOM7ovuh2LdsJ9/ZP+69D6aV5qKPO8EBEhj4k4=;
        b=bIM5cLJPbb/HcxTSFo1ZVurms67yaA+2JGfLFsCvS0xcqxzZndxwyUK+d37dI0zTlb
         3+7ZRd1eI1kpnE4MtjuuX0qj41BQjrH50DmBweS1ZsSvfwSGbJnO7eL6fCjO9Nz0XH5H
         /Etk69tLQG0Hbnj1bfON0GSq+kTjDBkg5JX5TTk2xhoIBvmO8dhubBm1RwxIVOHUBeNP
         YZ4W+MUwB1yRNZ9X/ZXTAG59dYhJT06B5xMpnTdQt5MTK1ucdvuDgqZhy5NxW/1+brlr
         XBvP2euoPthQoC/x2EfbA29KmnrTJei5GPbH9xjqpbDoxjaGxlizB2PpA+/SK99T6yJW
         dBYA==
Content-Disposition: inline
In-Reply-To: <20140925134342.GB22508@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 25-09-14 09:43:42, Johannes Weiner wrote:
[...]
> From 1cd659f42f399adc58522d478f54587c8c4dd5cc Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Wed, 24 Sep 2014 22:00:20 -0400
> Subject: [patch] mm: memcontrol: do not iterate uninitialized memcgs
> 
> The cgroup iterators yield css objects that have not yet gone through
> css_online(), but they are not complete memcgs at this point and so
> the memcg iterators should not return them.  d8ad30559715 ("mm/memcg:
> iteration skip memcgs not yet fully initialized") set out to implement
> exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
> not meet the ordering requirements for memcg, and so the iterator may
> skip over initialized groups, or return partially initialized memcgs.
> 
> The cgroup core can not reasonably provide a clear answer on whether
> the object around the css has been fully initialized, as that depends
> on controller-specific locking and lifetime rules.  Thus, introduce a
> memcg-specific flag that is set after the memcg has been initialized
> in css_online(), and read before mem_cgroup_iter() callers access the
> memcg members.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@vger.kernel.org>	[3.12+]

I am not an expert (obviously) on memory barriers but from
Documentation/memory-barriers.txt, my understanding is that
smp_load_acquire and smp_store_release is exactly what we need here.
"
However, after an ACQUIRE on a given variable, all memory accesses
preceding any prior RELEASE on that same variable are guaranteed to be
visible.
"

Acked-by: Michal Hocko <mhocko@suse.cz>

Stable backport would be trickier because ACQUIRE/RELEASE were
introduced later but smp_mb() should be safe replacement.

Thanks!

> ---
>  mm/memcontrol.c | 36 +++++++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 306b6470784c..23976fd885fd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -292,6 +292,9 @@ struct mem_cgroup {
>  	/* vmpressure notifications */
>  	struct vmpressure vmpressure;
>  
> +	/* css_online() has been completed */
> +	int initialized;
> +
>  	/*
>  	 * the counter to account for mem+swap usage.
>  	 */
> @@ -1090,10 +1093,21 @@ skip_node:
>  	 * skipping css reference should be safe.
>  	 */
>  	if (next_css) {
> -		if ((next_css == &root->css) ||
> -		    ((next_css->flags & CSS_ONLINE) &&
> -		     css_tryget_online(next_css)))
> -			return mem_cgroup_from_css(next_css);
> +		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
> +
> +		if (next_css == &root->css)
> +			return memcg;
> +
> +		if (css_tryget_online(next_css)) {
> +			/*
> +			 * Make sure the memcg is initialized:
> +			 * mem_cgroup_css_online() orders the the
> +			 * initialization against setting the flag.
> +			 */
> +			if (smp_load_acquire(&memcg->initialized))
> +				return memcg;
> +			css_put(next_css);
> +		}
>  
>  		prev_css = next_css;
>  		goto skip_node;
> @@ -5413,6 +5427,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  	struct mem_cgroup *parent = mem_cgroup_from_css(css->parent);
> +	int ret;
>  
>  	if (css->id > MEM_CGROUP_ID_MAX)
>  		return -ENOSPC;
> @@ -5449,7 +5464,18 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	}
>  	mutex_unlock(&memcg_create_mutex);
>  
> -	return memcg_init_kmem(memcg, &memory_cgrp_subsys);
> +	ret = memcg_init_kmem(memcg, &memory_cgrp_subsys);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Make sure the memcg is initialized: mem_cgroup_iter()
> +	 * orders reading memcg->initialized against its callers
> +	 * reading the memcg members.
> +	 */
> +	smp_store_release(&memcg->initialized, 1);
> +
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.1.0
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
