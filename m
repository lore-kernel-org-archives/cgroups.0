From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Force update of mem cgroup soft limit tree on
 usage excess
Date: Fri, 19 Feb 2021 10:11:02 +0100
Message-ID: <YC+ApsntwnlVfCuK@dhcp22.suse.cz>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613725868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HK3gOMvSsOerVFX2l1WmjV6t+45SWNGfAyfy9D0NI4I=;
        b=l0gWdfjvB023KeFjTf+7ola/XiStFn7J6ZbR1Yk8PqvRYBWWwvxUJ6gADxWP5iemoq8Wne
        k/GZWOdhCUSjNyryLo2qew+rt6guUCiEVRRZRacQT4V82Hj0pqrhSdEHFx7JcVJPKOZUyu
        1YDuCYmEasD1wBLaqseB+XSD8qvxG4E=
Content-Disposition: inline
In-Reply-To: <06f1f92f1f7d4e57c4e20c97f435252c16c60a27.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 17-02-21 12:41:35, Tim Chen wrote:
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
> 
> Fix this issue by forcing an update to the mem cgroup soft limit tree if a
> mem cgroup has exceeded its memory soft limit but it is not on the mem
> cgroup soft limit tree.

Let me copy your clarification from the other reply (this should go to
the changelog btw.):
> The sceanrio I saw was we have multiple cgroups running pmbench.
> One cgroup exceeded the soft limit and soft reclaim is active on
> that cgroup.  So there are a whole bunch of memcg events associated
> with that cgroup.  Then another cgroup starts to exceed its
> soft limit.
>
> Memory is accessed at a much lower frequency
> for the second cgroup.  The memcg event update was not triggered for the
> second cgroup as the memcg event update didn't happened on the 1024th sample.
> The second cgroup was not placed on the soft limit tree and we didn't
> try to reclaim the excess pages.
>
> As time goes on, we saw that the first cgroup was kept close to its
> soft limit due to reclaim activities, while the second cgroup's memory
> usage slowly creep up as it keeps getting missed from the soft limit tree
> update as the update didn't fall on the modulo 1024 sample.  As a result,
> the memory usage of the second cgroup keeps growing over the soft limit
> for a long time due to its relatively rare occurrence.

Soft limit is evaluated every THRESHOLDS_EVENTS_TARGET * SOFTLIMIT_EVENTS_TARGET.
If all events correspond with a newly charged memory and the last event
was just about the soft limit boundary then we should be bound by 128k
pages (512M and much more if this were huge pages) which is a lot!
I haven't realized this was that much. Now I see the problem. This would
be a useful information for the changelog.

Your fix is focusing on the over-the-limit boundary which will solve the
problem but wouldn't that lead to to updates happening too often in
pathological situation when a memcg would get reclaimed immediatelly?

One way around that would be to lower the SOFTLIMIT_EVENTS_TARGET. Have
you tried that? Do we even need a separate treshold for soft limit, why
cannot we simply update the tree each MEM_CGROUP_TARGET_THRESH?
 
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
