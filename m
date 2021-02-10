From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Wed, 10 Feb 2021 10:51:04 +0100
Message-ID: <YCOsiM5towVQwmjy@dhcp22.suse.cz>
References: <cover.1612902157.git.tim.c.chen@linux.intel.com>
 <90ef1dbc8ba6112794a3d09ecfed73f385f08eb7.1612902157.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612950667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CAFzAyZy/KFZTsu+ARXaCj+Xnf0VYpa/fyIfFuwi9+E=;
        b=YUq56y6mtYH/Zv/QM5JMteooatovb8ZVwTA95QkzipN8TrrweOCA2kd/E4vxFBA8rRv/TC
        KacdaHK0HaJxMz0S1v9EbDcIGgfr77mN3pQpz3D4aIvttYIWmFZX86ZrhHqQzGuaRftQz/
        +rE8Is9r5TMyPepqPzAgq8PzSP3lPw0=
Content-Disposition: inline
In-Reply-To: <90ef1dbc8ba6112794a3d09ecfed73f385f08eb7.1612902157.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 09-02-21 12:29:46, Tim Chen wrote:
> To rate limit updates to the mem cgroup soft limit tree, we only perform
> updates every SOFTLIMIT_EVENTS_TARGET (defined as 1024) memory events.
> 
> However, this sampling based updates may miss a critical update: i.e. when
> the mem cgroup first exceeded its limit but it was not on the soft limit tree.
> It should be on the tree at that point so it could be subjected to soft
> limit page reclaim. If the mem cgroup had few memory events compared with
> other mem cgroups, we may not update it and place in on the mem cgroup
> soft limit tree for many memory events.  And this mem cgroup excess
> usage could creep up and the mem cgroup could be hidden from the soft
> limit page reclaim for a long time.

Have you observed this happening in the real life? I do agree that the
threshold based updates of the tree is not ideal but the whole soft
reclaim code is far from optimal. So why do we care only now? The
feature is essentially dead and fine tuning it sounds like a step back
to me.

> Fix this issue by forcing an update to the mem cgroup soft limit tree if a
> mem cgroup has exceeded its memory soft limit but it is not on the mem
> cgroup soft limit tree.
> 
> Reviewed-by: Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  mm/memcontrol.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a51bf90732cb..d72449eeb85a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -985,15 +985,22 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>   */
>  static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  {
> +	struct mem_cgroup_per_node *mz;
> +	bool force_update = false;
> +
> +	mz = mem_cgroup_nodeinfo(memcg, page_to_nid(page));
> +	if (mz && !mz->on_tree && soft_limit_excess(mz->memcg) > 0)
> +		force_update = true;
> +
>  	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> +	if (unlikely((force_update) || mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
>  		bool do_softlimit;
>  
>  		do_softlimit = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_SOFTLIMIT);
>  		mem_cgroup_threshold(memcg);
> -		if (unlikely(do_softlimit))
> +		if (unlikely((force_update) || do_softlimit))
>  			mem_cgroup_update_tree(memcg, page);
>  	}
>  }
> -- 
> 2.20.1

-- 
Michal Hocko
SUSE Labs
