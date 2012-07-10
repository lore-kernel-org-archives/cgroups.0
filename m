From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 3/5] mm, memcg: introduce own oom handler to iterate
 only over its own threads
Date: Tue, 10 Jul 2012 14:19:59 -0700
Message-ID: <20120710141959.b6a3ecbe.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1206251846020.24838@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1206291404530.6040@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1206291405500.6040@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206291405500.6040-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 29 Jun 2012 14:06:56 -0700 (PDT)
David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> The global oom killer is serialized by the zonelist being used in the
> page allocation.

Brain hurts.  Presumably this is referring to some lock within the
zonelist.  Clarify, please?

>  Concurrent oom kills are thus a rare event and only
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
> 
>
> ...
>
> @@ -1469,6 +1469,65 @@ u64 mem_cgroup_get_limit(struct mem_cgroup *memcg)
>  	return min(limit, memsw);
>  }
>  
> +void __mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> +				int order)

Perhaps have a comment over this function explaining why it exists?

> +{
> +	struct mem_cgroup *iter;
> +	unsigned long chosen_points = 0;
> +	unsigned long totalpages;
> +	unsigned int points = 0;
> +	struct task_struct *chosen = NULL;
> +
> +	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	for_each_mem_cgroup_tree(iter, memcg) {
> +		struct cgroup *cgroup = iter->css.cgroup;
> +		struct cgroup_iter it;
> +		struct task_struct *task;
> +
> +		cgroup_iter_start(cgroup, &it);
> +		while ((task = cgroup_iter_next(cgroup, &it))) {
> +			switch (oom_scan_process_thread(task, totalpages, NULL,
> +							false)) {
> +			case OOM_SCAN_SELECT:
>
> ...
>
