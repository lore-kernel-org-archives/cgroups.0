From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [rfc][patch 3/3] mm, memcg: introduce own oom handler to iterate
 only over its own threads
Date: Tue, 26 Jun 2012 11:58:32 +0200
Message-ID: <20120626095832.GC9566@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1206251847180.24838@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206251847180.24838-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 25-06-12 18:47:53, David Rientjes wrote:
> The global oom killer is serialized by the zonelist being used in the
> page allocation.  Concurrent oom kills are thus a rare event and only
> occur in systems using mempolicies and with a large number of nodes.
> 
> Memory controller oom kills, however, can frequently be concurrent since
> there is no serialization once the oom killer is called for oom
> conditions in several different memcgs in parallel.
> 
> This creates a massive contention on tasklist_lock since the oom killer
> requires the readside for the tasklist iteration.  If several memcgs are
> calling the oom killer, this lock can be held for a substantial amount of
> time, especially if threads continue to enter it as other threads are
> exiting.
> 
> Since the exit path grabs the writeside of the lock with irqs disabled in
> a few different places, this can cause a soft lockup on cpus as a result
> of tasklist_lock starvation.
> 
> The kernel lacks unfair writelocks, and successful calls to the oom
> killer usually result in at least one thread entering the exit path, so
> an alternative solution is needed.
> 
> This patch introduces a seperate oom handler for memcgs so that they do
> not require tasklist_lock for as much time.  Instead, it iterates only
> over the threads attached to the oom memcg and grabs a reference to the
> selected thread before calling oom_kill_process() to ensure it doesn't
> prematurely exit.
> 
> This still requires tasklist_lock for the tasklist dump, iterating
> children of the selected process, and killing all other threads on the
> system sharing the same memory as the selected victim.  So while this
> isn't a complete solution to tasklist_lock starvation, it significantly
> reduces the amount of time that it is held.

There is an issues with memcg ref. counting but I like the approach in
general.
> 
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

After the things bellow are fixed
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  include/linux/memcontrol.h |    9 ++-----
>  include/linux/oom.h        |   16 ++++++++++++
>  mm/memcontrol.c            |   62 +++++++++++++++++++++++++++++++++++++++++++-
>  mm/oom_kill.c              |   48 +++++++++++-----------------------
>  4 files changed, 94 insertions(+), 41 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -1470,6 +1470,66 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
>  	return min(limit, memsw);
>  }
>  
> +void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> +				int order)
> +{
> +	struct mem_cgroup *iter;
> +	unsigned long chosen_points = 0;
> +	unsigned long totalpages;
> +	unsigned int points = 0;
> +	struct task_struct *chosen = NULL;
> +	struct task_struct *task;
> +
> +	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	for_each_mem_cgroup_tree(iter, memcg) {
> +		struct cgroup *cgroup = iter->css.cgroup;
> +		struct cgroup_iter it;
> +
> +		cgroup_iter_start(cgroup, &it);

I guess this should protect from task move and exit, right?

> +		while ((task = cgroup_iter_next(cgroup, &it))) {
> +			switch (oom_scan_process_thread(task, totalpages, NULL,
> +							false)) {
> +			case OOM_SCAN_SELECT:
> +				if (chosen)
> +					put_task_struct(chosen);
> +				chosen = task;
> +				chosen_points = ULONG_MAX;
> +				get_task_struct(chosen);
> +				/* fall through */
> +			case OOM_SCAN_CONTINUE:
> +				continue;
> +			case OOM_SCAN_ABORT:
> +				cgroup_iter_end(cgroup, &it);
> +				if (chosen)
> +					put_task_struct(chosen);

You need mem_cgroup_iter_break here to have ref. counting correct.

> +				return;
> +			case OOM_SCAN_OK:
> +				break;
> +			};
> +			points = oom_badness(task, memcg, NULL, totalpages);
> +			if (points > chosen_points) {
> +				if (chosen)
> +					put_task_struct(chosen);
> +				chosen = task;
> +				chosen_points = points;
> +				get_task_struct(chosen);
> +			}
> +		}
> +		cgroup_iter_end(cgroup, &it);
> +		if (!memcg->use_hierarchy)
> +			break;

And this is not necessary, because for_each_mem_cgroup_tree is hierarchy
aware.

[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
