From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Do not high throttle allocators based on
 wraparound
Date: Tue, 31 Mar 2020 17:57:52 +0200
Message-ID: <20200331155752.GN30449@dhcp22.suse.cz>
References: <20200331152424.GA1019937@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200331152424.GA1019937-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 31-03-20 16:24:24, Chris Down wrote:
> From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> If a cgroup violates its memory.high constraints, we may end
> up unduly penalising it. For example, for the following hierarchy:
> 
> A:   max high, 20 usage
> A/B: 9 high, 10 usage
> A/C: max high, 10 usage
> 
> We would end up doing the following calculation below when calculating
> high delay for A/B:
> 
> A/B: 10 - 9 = 1...
> A:   20 - PAGE_COUNTER_MAX = 21, so set max_overage to 21.
> 
> This gets worse with higher disparities in usage in the parent.
> 
> I have no idea how this disappeared from the final version of the patch,
> but it is certainly Not Good(tm). This wasn't obvious in testing
> because, for a simple cgroup hierarchy with only one child, the result
> is usually roughly the same. It's only in more complex hierarchies that
> things go really awry (although still, the effects are limited to a
> maximum of 2 seconds in schedule_timeout_killable at a maximum).

I find this paragraph rather confusing. This is essentially an unsigned
underflow when any of the memcg up the hierarchy is below the high
limit, right?  There doesn't really seem anything complex in such a
hierarchy.

> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: changelog]
> 
> Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.4.x

To the patch
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index eecf003b0c56..75a978307863 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2336,6 +2336,9 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
>  		usage = page_counter_read(&memcg->memory);
>  		high = READ_ONCE(memcg->high);
>  
> +		if (usage <= high)
> +			continue;
> +
>  		/*
>  		 * Prevent division by 0 in overage calculation by acting as if
>  		 * it was a threshold of 1 page
> -- 
> 2.26.0
> 

-- 
Michal Hocko
SUSE Labs
