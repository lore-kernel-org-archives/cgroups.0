From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] sched/{cpuset,core}: restore complete root_domain
 status across hotplug
Date: Wed, 9 Sep 2015 17:11:34 +0200
Message-ID: <20150909151134.GU16853@twins.programming.kicks-ass.net>
References: <1441188096-23021-1-git-send-email-juri.lelli@arm.com>
 <1441188096-23021-2-git-send-email-juri.lelli@arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441188096-23021-2-git-send-email-juri.lelli@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@arm.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Wed, Sep 02, 2015 at 11:01:33AM +0100, Juri Lelli wrote:
> Hotplug operations are destructive w.r.t data associated with cpuset;
> in this case we care about root_domains. SCHED_DEADLINE puts bandwidth
> information regarding admitted tasks on root_domains, information that
> is gone when an hotplug operation happens. Also, it is not currently
> possible to tell to which task(s) the allocated bandwidth belongs, as
> this link is lost after sched_setscheduler() succeeds.
> 
> This patch forces rebuilding of allocated bandwidth information at
> root_domain level after cpuset_hotplug_workfn() callback is done
> setting up scheduling and root domains.

> +static void cpuset_hotplug_update_rd(void)
> +{
> +	struct cpuset *cs;
> +	struct cgroup_subsys_state *pos_css;
> +
> +	mutex_lock(&cpuset_mutex);
> +	rcu_read_lock();
> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
> +		if (!css_tryget_online(&cs->css))
> +			continue;
> +		rcu_read_unlock();
> +
> +		update_tasks_rd(cs);
> +
> +		rcu_read_lock();
> +		css_put(&cs->css);
> +	}
> +	rcu_read_unlock();
> +	mutex_unlock(&cpuset_mutex);
> +}
> +
> +/**
>   * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
>   *
>   * This function is called after either CPU or memory configuration has
> @@ -2296,6 +2335,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  	/* rebuild sched domains if cpus_allowed has changed */
>  	if (cpus_updated)
>  		rebuild_sched_domains();
> +
> +	cpuset_hotplug_update_rd();
>  }

So the problem is that rebuild_sched_domains() destroys rd->dl_bw ? I
worry the above is racy in that you do not restore under the same
cpuset_mutex instance as you rebuild.

That is, what will stop a new task from joining the cpuset and
overloading the bandwidth between the root-domain getting rebuild and
restoring the bandwidth?
