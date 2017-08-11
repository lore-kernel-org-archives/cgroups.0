From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Fri, 11 Aug 2017 16:19:07 -0400
Message-ID: <e9682f27-a23c-802c-daed-e49fc9d4613c@redhat.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811163754.3939102-4-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 08/11/2017 12:37 PM, Tejun Heo wrote:
> In cgroup1, while cpuacct isn't actually controlling any resources, it
> is a separate controller due to combinaton of two factors -
> 1. enabling cpu controller has significant side effects, and 2. we
> have to pick one of the hierarchies to account CPU usages on.  cpuacct
> controller is effectively used to designate a hierarchy to track CPU
> usages on.
>
> cgroup2's unified hierarchy removes the second reason and we can
> account basic CPU usages by default.  While we can use cpuacct for
> this purpose, both its interface and implementation leave a lot to be
> desired - it collects and exposes two sources of truth which don't
> agree with each other and some of the exposed statistics don't make
> much sense.  Also, it propagates all the way up the hierarchy on each
> accounting event which is unnecessary.
>
> This patch adds basic resource accounting mechanism to cgroup2's
> unified hierarchy and accounts CPU usages using it.
>
> * All accountings are done per-cpu and don't propagate immediately.
>   It just bumps the per-cgroup per-cpu counters and links to the
>   parent's updated list if not already on it.
>
> * On a read, the per-cpu counters are collected into the global ones
>   and then propagated upwards.  Only the per-cpu counters which have
>   changed since the last read are propagated.
>
> * CPU usage stats are collected and shown in "cgroup.stat" with "cpu."
>   prefix.  Total usage is collected from scheduling events.  User/sys
>   breakdown is sourced from tick sampling and adjusted to the usage
>   using cputime_adjuts().

Typo: cputime_adjust()

> This keeps the accounting side hot path O(1) and per-cpu and the read
> side O(nr_updated_since_last_read).
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  Documentation/cgroup-v2.txt     |   9 ++
>  include/linux/cgroup-defs.h     |  47 ++++++
>  include/linux/cgroup.h          |  22 +++
>  kernel/cgroup/Makefile          |   2 +-
>  kernel/cgroup/cgroup-internal.h |   8 +
>  kernel/cgroup/cgroup.c          |  24 ++-
>  kernel/cgroup/stat.c            | 333 ++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 442 insertions(+), 3 deletions(-)
>  create mode 100644 kernel/cgroup/stat.c
>
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index dc44785..3f82169 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -886,6 +886,15 @@ All cgroup core files are prefixed with "cgroup."
>  		A dying cgroup can consume system resources not exceeding
>  		limits, which were active at the moment of cgroup deletion.
>  
> +	  cpu.usage_usec
> +		CPU time consumed in the subtree.
> +
> +	  cpu.user_usec
> +		User CPU time consumed in the subtree.
> +
> +	  cpu.system_usec
> +		System CPU time consumed in the subtree.
> +
>  
>  Controllers
>  ===========
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 59e4ad9..17da9c8 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -16,6 +16,7 @@
>  #include <linux/refcount.h>
>  #include <linux/percpu-refcount.h>
>  #include <linux/percpu-rwsem.h>
> +#include <linux/u64_stats_sync.h>
>  #include <linux/workqueue.h>
>  #include <linux/bpf-cgroup.h>
>  
> @@ -249,6 +250,47 @@ struct css_set {
>  	struct rcu_head rcu_head;
>  };
>  
> +/*
> + * cgroup basic resource usage statistics.  Accounting is done per-cpu in
> + * cgroup_cpu_stat which is then lazily propagated up the hierarchy on
> + * reads.  The propagation is selective - only the cgroup_cpu_stats which
> + * have been updated since the last propagation are propagated.
> + */
> +struct cgroup_cpu_stat {
> +	/*
> +	 * ->sync protects all the current counters.  These are the only
> +	 * fields which get updated in the hot path.
> +	 */
> +	struct u64_stats_sync sync;
> +	struct task_cputime cputime;
> +
> +	/*
> +	 * Snapshots at the last reading.  These are used to calculate the
> +	 * deltas to propagate to the global counters.
> +	 */
> +	struct task_cputime last_cputime;
> +
> +	/*
> +	 * Child cgroups with stat updates on this cpu since the last read
> +	 * are linked on the parent's ->updated_children through
> +	 * ->updated_next.
> +	 *
> +	 * In addition to being more compact, singly-linked list pointing
> +	 * to the cgroup makes it unnecessary for each per-cpu struct to
> +	 * point back to the associated cgroup.
> +	 *
> +	 * Protected by per-cpu cgroup_cpu_stat_lock.
> +	 */
> +	struct cgroup *updated_children;	/* terminated by self cgroup */
> +	struct cgroup *updated_next;		/* NULL iff not on the list */
> +};
> +
> +struct cgroup_stat {
> +	/* per-cpu statistics are collected into the folowing global counters */
> +	struct task_cputime cputime;
> +	struct prev_cputime prev_cputime;
> +};
> +
>  struct cgroup {
>  	/* self css with NULL ->ss, points back to this cgroup */
>  	struct cgroup_subsys_state self;
> @@ -348,6 +390,11 @@ struct cgroup {
>  	 */
>  	struct cgroup *dom_cgrp;
>  
> +	/* cgroup basic resource statistics */
> +	struct cgroup_cpu_stat __percpu *cpu_stat;
> +	struct cgroup_stat pending_stat;	/* pending from children */
> +	struct cgroup_stat stat;
> +
>  	/*
>  	 * list of pidlists, up to two for each namespace (one for procs, one
>  	 * for tasks); created on demand.
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index f395e02..4c82212 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -689,17 +689,39 @@ static inline void cpuacct_account_field(struct task_struct *tsk, int index,
>  					 u64 val) {}
>  #endif
>  
> +void cgroup_stat_show_cputime(struct seq_file *seq, const char *prefix);
> +
> +void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec);
> +void __cgroup_account_cputime_field(struct cgroup *cgrp,
> +				    enum cpu_usage_stat index, u64 delta_exec);
> +
>  static inline void cgroup_account_cputime(struct task_struct *task,
>  					  u64 delta_exec)
>  {
> +	struct cgroup *cgrp;
> +
>  	cpuacct_charge(task, delta_exec);
> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(task);
> +	if (cgroup_parent(cgrp))
> +		__cgroup_account_cputime(cgrp, delta_exec);
> +	rcu_read_unlock();
>  }
>  
>  static inline void cgroup_account_cputime_field(struct task_struct *task,
>  						enum cpu_usage_stat index,
>  						u64 delta_exec)
>  {
> +	struct cgroup *cgrp;
> +
>  	cpuacct_account_field(task, index, delta_exec);
> +
> +	rcu_read_lock();
> +	cgrp = task_dfl_cgroup(task);
> +	if (cgroup_parent(cgrp))
> +		__cgroup_account_cputime_field(cgrp, index, delta_exec);
> +	rcu_read_unlock();
>  }
>  
>  #else	/* CONFIG_CGROUPS */
> diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
> index ce693cc..0acee61 100644
> --- a/kernel/cgroup/Makefile
> +++ b/kernel/cgroup/Makefile
> @@ -1,4 +1,4 @@
> -obj-y := cgroup.o namespace.o cgroup-v1.o
> +obj-y := cgroup.o stat.o namespace.o cgroup-v1.o
>  
>  obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
>  obj-$(CONFIG_CGROUP_PIDS) += pids.o
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
> index c167a40..f17da09 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -197,6 +197,14 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
>  int cgroup_task_count(const struct cgroup *cgrp);
>  
>  /*
> + * stat.c
> + */
> +void cgroup_stat_flush(struct cgroup *cgrp);
> +int cgroup_stat_init(struct cgroup *cgrp);
> +void cgroup_stat_exit(struct cgroup *cgrp);
> +void cgroup_stat_boot(void);
> +
> +/*
>   * namespace.c
>   */
>  extern const struct proc_ns_operations cgroupns_operations;
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index c038ccf..a399a55 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -142,12 +142,14 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
>  };
>  #undef SUBSYS
>  
> +static DEFINE_PER_CPU(struct cgroup_cpu_stat, cgrp_dfl_root_cpu_stat);
> +
>  /*
>   * The default hierarchy, reserved for the subsystems that are otherwise
>   * unattached - it never has more than a single cgroup, and all tasks are
>   * part of that cgroup.
>   */
> -struct cgroup_root cgrp_dfl_root;
> +struct cgroup_root cgrp_dfl_root = { .cgrp.cpu_stat = &cgrp_dfl_root_cpu_stat };
>  EXPORT_SYMBOL_GPL(cgrp_dfl_root);
>  
>  /*
> @@ -3296,6 +3298,8 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
>  	seq_printf(seq, "nr_dying_descendants %d\n",
>  		   cgroup->nr_dying_descendants);
>  
> +	cgroup_stat_show_cputime(seq, "cpu.");
> +
>  	return 0;
>  }
>  
> @@ -4466,6 +4470,8 @@ static void css_free_work_fn(struct work_struct *work)
>  			 */
>  			cgroup_put(cgroup_parent(cgrp));
>  			kernfs_put(cgrp->kn);
> +			if (cgroup_on_dfl(cgrp))
> +				cgroup_stat_exit(cgrp);
>  			kfree(cgrp);
>  		} else {
>  			/*
> @@ -4510,6 +4516,9 @@ static void css_release_work_fn(struct work_struct *work)
>  		/* cgroup release path */
>  		trace_cgroup_release(cgrp);
>  
> +		if (cgroup_on_dfl(cgrp))
> +			cgroup_stat_flush(cgrp);
> +
>  		for (tcgrp = cgroup_parent(cgrp); tcgrp;
>  		     tcgrp = cgroup_parent(tcgrp))
>  			tcgrp->nr_dying_descendants--;
> @@ -4696,6 +4705,12 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
>  	if (ret)
>  		goto out_free_cgrp;
>  
> +	if (cgroup_on_dfl(parent)) {
> +		ret = cgroup_stat_init(cgrp);
> +		if (ret)
> +			goto out_cancel_ref;
> +	}
> +
>  	/*
>  	 * Temporarily set the pointer to NULL, so idr_find() won't return
>  	 * a half-baked cgroup.
> @@ -4703,7 +4718,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
>  	cgrp->id = cgroup_idr_alloc(&root->cgroup_idr, NULL, 2, 0, GFP_KERNEL);
>  	if (cgrp->id < 0) {
>  		ret = -ENOMEM;
> -		goto out_cancel_ref;
> +		goto out_stat_exit;
>  	}
>  
>  	init_cgroup_housekeeping(cgrp);
> @@ -4752,6 +4767,9 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
>  
>  	return cgrp;
>  
> +out_stat_exit:
> +	if (cgroup_on_dfl(parent))
> +		cgroup_stat_exit(cgrp);
>  out_cancel_ref:
>  	percpu_ref_exit(&cgrp->self.refcnt);
>  out_free_cgrp:
> @@ -5146,6 +5164,8 @@ int __init cgroup_init(void)
>  	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
>  	BUG_ON(cgroup_init_cftypes(NULL, cgroup1_base_files));
>  
> +	cgroup_stat_boot();
> +
>  	/*
>  	 * The latency of the synchronize_sched() is too high for cgroups,
>  	 * avoid it at the cost of forcing all readers into the slow path.
> diff --git a/kernel/cgroup/stat.c b/kernel/cgroup/stat.c
> new file mode 100644
> index 0000000..19a10b2
> --- /dev/null
> +++ b/kernel/cgroup/stat.c
> @@ -0,0 +1,333 @@
> +#include "cgroup-internal.h"
> +
> +#include <linux/sched/cputime.h>
> +
> +static DEFINE_MUTEX(cgroup_stat_mutex);
> +static DEFINE_PER_CPU(raw_spinlock_t, cgroup_cpu_stat_lock);

If the hierarchy is large enough and the stat data hasn't been read
recently, it may take a while to accumulate all the stat data even for
one cpu in cgroup_stat_flush_locked(). So I think it will make more
sense to use regular spinlock_t instead of raw_spinlock_t.

> +
> +static struct cgroup_cpu_stat *cgroup_cpu_stat(struct cgroup *cgrp, int cpu)
> +{
> +	return per_cpu_ptr(cgrp->cpu_stat, cpu);
> +}
> +
> +/**
> + * cgroup_cpu_stat_updated - keep track of updated cpu_stat
> + * @cgrp: target cgroup
> + * @cpu: cpu on which cpu_stat was updated
> + *
> + * @cgrp's cpu_stat on @cpu was updated.  Put it on the parent's matching
> + * cpu_stat->updated_children list.
> + */
> +static void cgroup_cpu_stat_updated(struct cgroup *cgrp, int cpu)
> +{
> +	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_cpu_stat_lock, cpu);
> +	struct cgroup *parent;
> +	unsigned long flags;
> +
> +	/*
> +	 * Speculative already-on-list test.  This may race leading to
> +	 * temporary inaccuracies, which is fine.
> +	 *
> +	 * Because @parent's updated_children is terminated with @parent
> +	 * instead of NULL, we can tell whether @cgrp is on the list by
> +	 * testing the next pointer for NULL.
> +	 */
> +	if (cgroup_cpu_stat(cgrp, cpu)->updated_next)
> +		return;
> +
> +	raw_spin_lock_irqsave(cpu_lock, flags);
> +
> +	/* put @cgrp and all ancestors on the corresponding updated lists */
> +	for (parent = cgroup_parent(cgrp); parent;
> +	     cgrp = parent, parent = cgroup_parent(cgrp)) {
> +		struct cgroup_cpu_stat *cstat = cgroup_cpu_stat(cgrp, cpu);
> +		struct cgroup_cpu_stat *pcstat = cgroup_cpu_stat(parent, cpu);
> +
> +		/*
> +		 * Both additions and removals are bottom-up.  If a cgroup
> +		 * is already in the tree, all ancestors are.
> +		 */
> +		if (cstat->updated_next)
> +			break;
> +
> +		cstat->updated_next = pcstat->updated_children;
> +		pcstat->updated_children = cgrp;
> +	}
> +
> +	raw_spin_unlock_irqrestore(cpu_lock, flags);
> +}
> +
> +/**
> + * cgroup_cpu_stat_next_updated - iterate cpu_stat updated tree
> + * @pos: current position
> + * @root: root of the tree to traversal
> + * @cpu: target cpu
> + *
> + * Walks the udpated cpu_stat tree on @cpu from @root.  %NULL @pos starts
> + * the traversal and %NULL return indicates the end.  During traversal,
> + * each returned cgroup is unlinked from the tree.  Must be called with the
> + * matching cgroup_cpu_stat_lock held.
> + *
> + * The only ordering guarantee is that, for a parent and a child pair
> + * covered by a given traversal, if a child is visited, its parent is
> + * guaranteed to be visited afterwards.
> + */
> +static struct cgroup *cgroup_cpu_stat_next_updated(struct cgroup *pos,
> +						   struct cgroup *root, int cpu)

This function is trying to unwind one cgrp from the updated_children and
updated_next linkage. It is somewhat like the opposite of
cgroup_cpu_stat_updated(). I just feel like its name isn't intuitive
enough to convey what it is doing. Maybe use name like
cgroup_cpu_stat_unlink_one() to match cgroup_cpu_stat_flush_one().

Cheers,
Longman
