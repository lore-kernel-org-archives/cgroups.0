From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Revert "mm/vmscan: never demote for memcg reclaim"
Date: Thu, 19 May 2022 11:51:12 +0200
Message-ID: <YoYTEDD+c4GT0xYY@dhcp22.suse.cz>
References: <20220518190911.82400-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652953874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I8DbhN/hmOIXXZ4piaGn9jvuXkaTo8VWp7TEEneSWwU=;
        b=YFxzBTOtJeatYq35CXez5bOlSjNY4j0o3mtivxShrX3+r3OGxsUKu4LeTD5d/SWLBWQHZw
        et1F5ekV2CK0+dO/rT6Z6P3Tc3mMmVNGUJuW4ovJIawZLb0vaTZXSIG2mclSWc4xLg67TK
        pvtcYKhsS9GpnIBCVqgNTN5bQGKNjh4=
Content-Disposition: inline
In-Reply-To: <20220518190911.82400-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Wed 18-05-22 15:09:11, Johannes Weiner wrote:
> This reverts commit 3a235693d3930e1276c8d9cc0ca5807ef292cf0a.
> 
> Its premise was that cgroup reclaim cares about freeing memory inside
> the cgroup, and demotion just moves them around within the cgroup
> limit. Hence, pages from toptier nodes should be reclaimed directly.
> 
> However, with NUMA balancing now doing tier promotions, demotion is
> part of the page aging process. Global reclaim demotes the coldest
> toptier pages to secondary memory, where their life continues and from
> which they have a chance to get promoted back. Essentially, tiered
> memory systems have an LRU order that spans multiple nodes.
> 
> When cgroup reclaims pages coming off the toptier directly, there can
> be colder pages on lower tier nodes that were demoted by global
> reclaim. This is an aging inversion, not unlike if cgroups were to
> reclaim directly from the active lists while there are inactive pages.
> 
> Proactive reclaim is another factor. The goal of that it is to offload
> colder pages from expensive RAM to cheaper storage. When lower tier
> memory is available as an intermediate layer, we want offloading to
> take advantage of it instead of bypassing to storage.
> 
> Revert the patch so that cgroups respect the LRU order spanning the
> memory hierarchy.

I do agree with your reasoning.

> Of note is a specific undercommit scenario, where all cgroup limits in
> the system add up to <= available toptier memory. In that case,
> shuffling pages out to lower tiers first to reclaim them from there is
> inefficient. This is something could be optimized/short-circuited
> later on (although care must be taken not to accidentally recreate the
> aging inversion). Let's ensure correctness first.

My slight concern with demotion is that there is no actual "guarantee"
to reclaim any charges which try_charge depends on to make a forward
progress. I suspect this is rather unlikely situation, though. The last
tear (without any fallback) should have some memory to reclaim most of
the time. Retries should push some pages out but low effort allocation
requests like GFP_NORETRY might fail but callers should be prepared for
that.

All that being said the agin inversion is much more real of a problem
than this.

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/vmscan.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c6918fff06e1..7a4090712177 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -528,13 +528,8 @@ static bool can_demote(int nid, struct scan_control *sc)
>  {
>  	if (!numa_demotion_enabled)
>  		return false;
> -	if (sc) {
> -		if (sc->no_demotion)
> -			return false;
> -		/* It is pointless to do demotion in memcg reclaim */
> -		if (cgroup_reclaim(sc))
> -			return false;
> -	}
> +	if (sc && sc->no_demotion)
> +		return false;
>  	if (next_demotion_node(nid) == NUMA_NO_NODE)
>  		return false;
>  
> -- 
> 2.36.1

-- 
Michal Hocko
SUSE Labs
