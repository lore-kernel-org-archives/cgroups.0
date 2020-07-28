From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: don't count limit-setting reclaim as
 memory pressure
Date: Tue, 28 Jul 2020 11:53:41 -0700
Message-ID: <20200728185341.GA410810@carbon.DHCP.thefacebook.com>
References: <20200728135210.379885-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FVNIR2xjk/9l9AEZJ00iTvtiTR8dEBO3vE9XfzlitWc=;
 b=gP9o441jVCsBKj6ajeSRfOwOOWmH82HF1aaFcpXtSMIDimrC66Zd2rksWc/ciyNEc+jL
 A/WZDNi3vcFAwErOMqBeucLkSFF79CumYbXVVmLFYX92GKoq0WN/KMN8PBj9+aHJhAIp
 B3A0z9XlZbRPQxs0IomC41Izior5Mi/n/Lo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVNIR2xjk/9l9AEZJ00iTvtiTR8dEBO3vE9XfzlitWc=;
 b=Z7ZiC9i2fll3ivLLcSLh6WTjpARzYpgi3evXwxLTELo25+zUwYoJFbIwr0EcTG8NL/3BA+qBO2Jo0K2WNTHQcg6OuM9TcFq9KXWYJUXi02lbGqE6RJMa9iAVny03r7+fLnT7eJmIF05y0bL9nK5HrGr/drU43MG2fVwBCke46vM=
Content-Disposition: inline
In-Reply-To: <20200728135210.379885-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jul 28, 2020 at 09:52:10AM -0400, Johannes Weiner wrote:
> When an outside process lowers one of the memory limits of a cgroup
> (or uses the force_empty knob in cgroup1), direct reclaim is performed
> in the context of the write(), in order to directly enforce the new
> limit and have it being met by the time the write() returns.
> 
> Currently, this reclaim activity is accounted as memory pressure in
> the cgroup that the writer(!) belongs to. This is unexpected. It
> specifically causes problems for senpai
> (https://github.com/facebookincubator/senpai), which is an agent that
> routinely adjusts the memory limits and performs associated reclaim
> work in tens or even hundreds of cgroups running on the host. The
> cgroup that senpai is running in itself will report elevated levels of
> memory pressure, even though it itself is under no memory shortage or
> any sort of distress.
> 
> Move the psi annotation from the central cgroup reclaim function to
> callsites in the allocation context, and thereby no longer count any
> limit-setting reclaim as memory pressure. If the newly set limit
> causes the workload inside the cgroup into direct reclaim, that of
> course will continue to count as memory pressure.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 12 +++++++++++-
>  mm/vmscan.c     |  6 ------
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 805a44bf948c..8377640ad494 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2233,11 +2233,18 @@ static void reclaim_high(struct mem_cgroup *memcg,
>  			 gfp_t gfp_mask)
>  {
>  	do {
> +		unsigned long pflags;
> +
>  		if (page_counter_read(&memcg->memory) <=
>  		    READ_ONCE(memcg->memory.high))
>  			continue;
> +
>  		memcg_memory_event(memcg, MEMCG_HIGH);
> +
> +		psi_memstall_enter(&pflags);
>  		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
> +		psi_memstall_leave(&pflags);
> +
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
>  }
> @@ -2451,10 +2458,11 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct mem_cgroup *mem_over_limit;
>  	struct page_counter *counter;
> +	enum oom_status oom_status;
>  	unsigned long nr_reclaimed;
>  	bool may_swap = true;
>  	bool drained = false;
> -	enum oom_status oom_status;
> +	unsigned long pflags;
>  
>  	if (mem_cgroup_is_root(memcg))
>  		return 0;
> @@ -2514,8 +2522,10 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
>  	memcg_memory_event(mem_over_limit, MEMCG_MAX);
>  
> +	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
>  						    gfp_mask, may_swap);
> +	psi_memstall_leave(&pflags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>  		goto retry;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 749d239c62b2..742538543c79 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3318,7 +3318,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  					   bool may_swap)
>  {
>  	unsigned long nr_reclaimed;
> -	unsigned long pflags;
>  	unsigned int noreclaim_flag;
>  	struct scan_control sc = {
>  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> @@ -3339,17 +3338,12 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
> -
>  	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
> -
> -	psi_memstall_enter(&pflags);
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
>  
>  	memalloc_noreclaim_restore(noreclaim_flag);
> -	psi_memstall_leave(&pflags);
> -
>  	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
>  	set_task_reclaim_state(current, NULL);
>  
> -- 
> 2.27.0
> 
