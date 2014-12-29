From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: switch soft limit default back to
 infinity
Date: Mon, 29 Dec 2014 09:22:29 +0100
Message-ID: <20141229082229.GA32618@dhcp22.suse.cz>
References: <1419792468-9278-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PqAx4EML8gjghsNKRPnsaoZQDk4+KRat1FxCm6reMeI=;
        b=ODETi6658U61eqyPNRIiKGTfdKhQseK4w51r7mXz5l2P09DwulUSPk0nZpKsqzm/WP
         UNGhSRZ8lVZpk2AHFONBJSRT9SIBk27B2Ktc4tAkffsPzATNbHt9VObBW63Q2H8yefhs
         WAtStYkkT4iQAFBPzjNb1pJ6viqwxUvgP+PzIQnQrkmue6kVRSyf1EpLzLID+70t+9Vk
         rskBae8CD8XdAN5gc6jSyRiKM4g2hwh/meS507+jkG9lzZ2lT6/v6XXMxMIMbepfR9aW
         Jr/+6f785WHqyUMBDYPN17OtC0phEg86bf+jSXKTm31dquUqU6TXePzNags6aULzp2Cm
         LLBg==
Content-Disposition: inline
In-Reply-To: <1419792468-9278-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun 28-12-14 13:47:48, Johannes Weiner wrote:
> 3e32cb2e0a12 ("mm: memcontrol: lockless page counters") accidentally
> switched the soft limit default from infinity to zero, which turns all

Should have noticed that during the review :/

> memcgs with even a single page into soft limit excessors and engages
> soft limit reclaim on all of them during global memory pressure.  This
> makes global reclaim generally more aggressive, but also inverts the
> meaning of existing soft limit configurations where unset soft limits
> are usually more generous than set ones.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ef91e856c7e4..b7104a55ae64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4679,6 +4679,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  	if (parent_css == NULL) {
>  		root_mem_cgroup = memcg;
>  		page_counter_init(&memcg->memory, NULL);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, NULL);
>  		page_counter_init(&memcg->kmem, NULL);
>  	}
> @@ -4724,6 +4725,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  
>  	if (parent->use_hierarchy) {
>  		page_counter_init(&memcg->memory, &parent->memory);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, &parent->memsw);
>  		page_counter_init(&memcg->kmem, &parent->kmem);
>  
> @@ -4733,6 +4735,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  		 */
>  	} else {
>  		page_counter_init(&memcg->memory, NULL);
> +		memcg->soft_limit = PAGE_COUNTER_MAX;
>  		page_counter_init(&memcg->memsw, NULL);
>  		page_counter_init(&memcg->kmem, NULL);
>  		/*
> @@ -4807,7 +4810,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  	mem_cgroup_resize_limit(memcg, PAGE_COUNTER_MAX);
>  	mem_cgroup_resize_memsw_limit(memcg, PAGE_COUNTER_MAX);
>  	memcg_update_kmem_limit(memcg, PAGE_COUNTER_MAX);
> -	memcg->soft_limit = 0;
> +	memcg->soft_limit = PAGE_COUNTER_MAX;
>  }
>  
>  #ifdef CONFIG_MMU
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs
