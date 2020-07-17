From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide an anon_reclaimable stat
Date: Fri, 17 Jul 2020 10:34:19 +0200
Message-ID: <20200717083419.GD10655@dhcp22.suse.cz>
References: <20200715071522.19663-1-sjpark@amazon.com>
 <alpine.DEB.2.23.453.2007151031020.2788464@chino.kir.corp.google.com>
 <alpine.DEB.2.23.453.2007161357490.3209847@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2007161357490.3209847-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 16-07-20 13:58:19, David Rientjes wrote:
> Userspace can lack insight into the amount of memory that can be reclaimed
> from a memcg based on values from memory.stat.  Two specific examples:
> 
>  - Lazy freeable memory (MADV_FREE) that are clean anonymous pages on the
>    inactive file LRU that can be quickly reclaimed under memory pressure
>    but otherwise shows up as mapped anon in memory.stat, and
> 
>  - Memory on deferred split queues (thp) that are compound pages that can
>    be split and uncharged from the memcg under memory pressure, but
>    otherwise shows up as charged anon LRU memory in memory.stat.
> 
> Both of this anonymous usage is also charged to memory.current.
> 
> Userspace can currently derive this information but it depends on kernel
> implementation details for how this memory is handled for the purposes of
> reclaim (anon on inactive file LRU or unmapped anon on the LRU).
> 
> For the purposes of writing portable userspace code that does not need to
> have insight into the kernel implementation for reclaimable memory, this
> exports a stat that reveals the amount of anonymous memory that can be
> reclaimed and uncharged from the memcg to start new applications.
> 
> As the kernel implementation evolves for memory that can be reclaimed
> under memory pressure, this stat can be kept consistent.

Please be much more specific about the expected usage. You have
mentioned something in the email thread but this really belongs to the
changelog.

Why is reclaimable anonymous memory without any swap any special, say
from any other clean and easily reclaimable caches? What if there is a
swap available?

> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  6 +++++
>  mm/memcontrol.c                         | 31 +++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1296,6 +1296,12 @@ PAGE_SIZE multiple when read back.
>  		Amount of memory used in anonymous mappings backed by
>  		transparent hugepages
>  
> +	  anon_reclaimable
> +		The amount of charged anonymous memory that can be reclaimed
> +		under memory pressure without swap.  This currently includes
> +		lazy freeable memory (MADV_FREE) and compound pages that can be
> +		split and uncharged.
> +
>  	  inactive_anon, active_anon, inactive_file, active_file, unevictable
>  		Amount of memory, swap-backed and filesystem-backed,
>  		on the internal memory management lists used by the
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1350,6 +1350,32 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  	return false;
>  }
>  
> +/*
> + * Returns the amount of anon memory that is charged to the memcg that is
> + * reclaimable under memory pressure without swap, in pages.
> + */
> +static unsigned long memcg_anon_reclaimable(struct mem_cgroup *memcg)
> +{
> +	long deferred, lazyfree;
> +
> +	/*
> +	 * Deferred pages are charged anonymous pages that are on the LRU but
> +	 * are unmapped.  These compound pages are split under memory pressure.
> +	 */
> +	deferred = max_t(long, memcg_page_state(memcg, NR_ACTIVE_ANON) +
> +			       memcg_page_state(memcg, NR_INACTIVE_ANON) -
> +			       memcg_page_state(memcg, NR_ANON_MAPPED), 0);
> +	/*
> +	 * Lazyfree pages are charged clean anonymous pages that are on the file
> +	 * LRU and can be reclaimed under memory pressure.
> +	 */
> +	lazyfree = max_t(long, memcg_page_state(memcg, NR_ACTIVE_FILE) +
> +			       memcg_page_state(memcg, NR_INACTIVE_FILE) -
> +			       memcg_page_state(memcg, NR_FILE_PAGES), 0);
> +
> +	return deferred + lazyfree;
> +}
> +
>  static char *memory_stat_format(struct mem_cgroup *memcg)
>  {
>  	struct seq_buf s;
> @@ -1363,6 +1389,9 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
>  	 * Provide statistics on the state of the memory subsystem as
>  	 * well as cumulative event counters that show past behavior.
>  	 *
> +	 * All values in this buffer are read individually, so no implied
> +	 * consistency amongst them.
> +	 *
>  	 * This list is ordered following a combination of these gradients:
>  	 * 1) generic big picture -> specifics and details
>  	 * 2) reflecting userspace activity -> reflecting kernel heuristics
> @@ -1405,6 +1434,8 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
>  		       (u64)memcg_page_state(memcg, NR_ANON_THPS) *
>  		       HPAGE_PMD_SIZE);
>  #endif
> +	seq_buf_printf(&s, "anon_reclaimable %llu\n",
> +		       (u64)memcg_anon_reclaimable(memcg) * PAGE_SIZE);
>  
>  	for (i = 0; i < NR_LRU_LISTS; i++)
>  		seq_buf_printf(&s, "%s %llu\n", lru_list_name(i),

-- 
Michal Hocko
SUSE Labs
