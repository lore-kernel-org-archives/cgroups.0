From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Wed, 29 Apr 2020 12:15:10 +0200
Message-ID: <20200429101510.GA28637@dhcp22.suse.cz>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-04-20 19:26:47, Chris Down wrote:
> From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
> 
> Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
> 
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
> 
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim cycle
> in which the cgroup did have siblings.
> 
> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.

Thanks this describes the underlying problem. I would be also explicit
that the issue should be visible only on tail memcgs which have both
max/high and protection configured and the effect depends on the
difference between the two (the smaller it is the largrger the effect).

There is no mention about the fix. The patch resets effective values for
the reclaim root and I've had some concerns about that
http://lkml.kernel.org/r/20200424162103.GK11591-2MMpYkNvuYA6bu5BqYkRsg@public.gmane.org
Johannes has argued that other races are possible and I didn't get to
think about it thoroughly. But this patch is introducing a new
possibility of breaking protection. If we want to have a quick and
simple fix that would be easier to backport to older kernels then I
would feel much better if we simply workedaround the problem as
suggested earlier http://lkml.kernel.org/r/20200423061629.24185-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
We can rework the effective values calculation to be more robust against
races on top of that because this is likely a more tricky thing to do.

> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> 
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: rework code comment]
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: changelog]
> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: fix store tear]
> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: retitle]
> ---
>  mm/memcontrol.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0be00826b832..b0374be44e9e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6392,8 +6392,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  
>  	if (!root)
>  		root = root_mem_cgroup;
> -	if (memcg == root)
> +	if (memcg == root) {
> +		/*
> +		 * The cgroup is the reclaim root in this reclaim
> +		 * cycle, and therefore not protected. But it may have
> +		 * stale effective protection values from previous
> +		 * cycles in which it was not the reclaim root - for
> +		 * example, global reclaim followed by limit reclaim.
> +		 * Reset these values for mem_cgroup_protection().
> +		 */
> +		WRITE_ONCE(memcg->memory.emin, 0);
> +		WRITE_ONCE(memcg->memory.elow, 0);
>  		return MEMCG_PROT_NONE;
> +	}
>  
>  	usage = page_counter_read(&memcg->memory);
>  	if (!usage)
> -- 
> 2.26.2

-- 
Michal Hocko
SUSE Labs
