From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Tue, 29 Aug 2017 16:32:52 +0200
Message-ID: <20170829143252.6zoes63bwfflukjy@hirez.programming.kicks-ass.net>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aHuroL3aHgfj/elwHefbFSv+2OvVsyPPWLNUZMrvbSI=; b=bs9Oqnwur4LO2H/S95RWFRRG5
        WsCeOS2tu5FvRLe48XlaMK1YApsA3YmMgY+YAGLRAPkzIFOOure1GnUvRHwchA+aesPuw1U2HsqYF
        E6bd/VZzKZ2PeBpCLwNjAkXTJjgGgjDooO87ZBFUIJ8IrMhgYW/UvCHwkZX11HfprzXpBnz+/9vK+
        YTNsl1P2rxKw+46N772ngnhse2dpncbB0skJomcecD6618+eZfCREFYwFH40HKBOfPkMuV2FS5m6o
        kL7n6uoQ3IUEBQPU9gY9QbmfKxJsuIvWdb278NxLv9oIoUhAGwTQPVZhwdT3y0KSgCPCh+gPcmQCB
      
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-4-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org


So I mostly like. On accounting it only adds to the immediate cgroup (if
it has a parent, aka !root).

On update it does a DFS of all sub-groups and propagates the deltas up
to the requested group.

On Fri, Aug 11, 2017 at 09:37:54AM -0700, Tejun Heo wrote:
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

> +static struct cgroup_cpu_stat *cgroup_cpu_stat_account_begin(struct cgroup *cgrp)
> +{
> +	struct cgroup_cpu_stat *cstat;
> +
> +	cstat = get_cpu_ptr(cgrp->cpu_stat);
> +	u64_stats_update_begin(&cstat->sync);
> +	return cstat;
> +}
> +
> +static void cgroup_cpu_stat_account_end(struct cgroup *cgrp,
> +					struct cgroup_cpu_stat *cstat)
> +{
> +	u64_stats_update_end(&cstat->sync);
> +	cgroup_cpu_stat_updated(cgrp, smp_processor_id());
> +	put_cpu_ptr(cstat);
> +}
> +
> +void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec)
> +{
> +	struct cgroup_cpu_stat *cstat;
> +
> +	cstat = cgroup_cpu_stat_account_begin(cgrp);
> +	cstat->cputime.sum_exec_runtime += delta_exec;
> +	cgroup_cpu_stat_account_end(cgrp, cstat);
> +}

What I don't get is why you need cgroup_cpu_stat_updated(). That is, I
see you use it to keep the keep the DFS 'stack' up-to-date, but what I
don't see is why you'd need that.

Have a look at walk_tg_tree_from(), I think we can do something like
that on struct cgroup_subsys_state, it has that children list and the
parent pointer.

And yes, walk_tg_tree_from() is tricky, it always takes a fair while to
remember how it works.

