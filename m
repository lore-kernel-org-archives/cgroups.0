From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm] slab: fix cpuset check in fallback_alloc
Date: Fri, 15 Aug 2014 11:13:05 +0800
Message-ID: <53ED7AC1.502@huawei.com>
References: <1407692891-24312-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.02.1408101512500.706@chino.kir.corp.google.com> <20140811071315.GA18709@esperanza> <alpine.DEB.2.02.1408110433140.15519@chino.kir.corp.google.com> <20140811121739.GB18709@esperanza> <alpine.DEB.2.02.1408111354330.24240@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1408111354330.24240-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On 2014/8/12 5:05, David Rientjes wrote:
> On Mon, 11 Aug 2014, Vladimir Davydov wrote:
> 
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1963,7 +1963,7 @@ zonelist_scan:
>>>  
>>>  	/*
>>>  	 * Scan zonelist, looking for a zone with enough free.
>>> -	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
>>> +	 * See __cpuset_node_allowed() comment in kernel/cpuset.c.
>>>  	 */
>>>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>>  						high_zoneidx, nodemask) {
>>> @@ -1974,7 +1974,7 @@ zonelist_scan:
>>>  				continue;
>>>  		if (cpusets_enabled() &&
>>>  			(alloc_flags & ALLOC_CPUSET) &&
>>> -			!cpuset_zone_allowed_softwall(zone, gfp_mask))
>>> +			!cpuset_zone_allowed(zone, gfp_mask))
>>>  				continue;
>>
>> So, this is get_page_from_freelist. It's called from
>> __alloc_pages_nodemask with alloc_flags always having ALLOC_CPUSET bit
>> set and from __alloc_pages_slowpath with alloc_flags having ALLOC_CPUSET
>> bit set only for __GFP_WAIT allocations. That said, w/o your patch we
>> try to respect cpusets for all allocations, including atomic, and only
>> ignore cpusets if tight on memory (freelist's empty) for !__GFP_WAIT
>> allocations, while with your patch we always ignore cpusets for
>> !__GFP_WAIT allocations. Not sure if it really matters though, because
>> usually one uses cpuset.mems in conjunction with cpuset.cpus and it
>> won't make any difference then. It also doesn't conflict with any cpuset
>> documentation.
>>
> 
> Yeah, that's why I'm asking Li, the cpuset maintainer, if we can do this.  

I'm not quite sure. That code has been there before I got involved in cpuset.

> The only thing that we get by falling back to the page allocator slowpath 
> is that kswapd gets woken up before the allocation is attempted without 
> ALLOC_CPUSET.  It seems pointless to wakeup kswapd when the allocation can 
> succeed on any node.  Even with the patch, if the allocation fails because 
> all nodes are below their min watermark, then we still fallback to the 
> slowpath and wake up kswapd but there's nothing much else we can do 
> because it's !__GFP_WAIT.
> .

But I tend to agree with you. But if we want to do this, we should split this
change from the cleanup.

Regarding to the cleanup, I found there used to be a single cpuset_node_allowed(),
and your cleanup is exactly a revert of that ancient commit:

commit 02a0e53d8227aff5e62e0433f82c12c1c2805fd6
Author: Paul Jackson <pj-sJ/iWh9BUns@public.gmane.org>
Date:   Wed Dec 13 00:34:25 2006 -0800

    [PATCH] cpuset: rework cpuset_zone_allowed api

Seems the major intention was to avoid accident sleep-in-atomic bugs, because
callback_mutex might be held.

I don't see there's any reason callback_mutex can't be a spinlock. I thought
about this when Gu Zhen fixed the bug that callback_mutex is nested inside
rcu_read_lock().

--
 kernel/cpuset.c | 81 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 32 deletions(-)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index baa155c..9d9e239 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -284,7 +284,7 @@ static struct cpuset top_cpuset = {
  */
 
 static DEFINE_MUTEX(cpuset_mutex);
-static DEFINE_MUTEX(callback_mutex);
+static DEFINE_SPINLOCK(callback_lock);
 
 /*
  * CPU / memory hotplug is handled asynchronously.
@@ -848,6 +848,7 @@ static void update_tasks_cpumask(struct cpuset *cs)
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 {
+	unsigned long flags;
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 	bool need_rebuild_sched_domains = false;
@@ -875,9 +876,9 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 			continue;
 		rcu_read_unlock();
 
-		mutex_lock(&callback_mutex);
+		spin_lock_irqsave(&callback_lock, flags);
 		cpumask_copy(cp->effective_cpus, new_cpus);
-		mutex_unlock(&callback_mutex);
+		spin_unlock_irqrestore(&callback_lock, flags);
 
 		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
@@ -910,6 +911,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 			  const char *buf)
 {
+	unsigned long flags;
 	int retval;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
@@ -942,9 +944,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	/* use trialcs->cpus_allowed as a temp variable */
 	update_cpumasks_hier(cs, trialcs->cpus_allowed);
@@ -1105,6 +1107,7 @@ static void update_tasks_nodemask(struct cpuset *cs)
  */
 static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 {
+	unsigned long flags;
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 
@@ -1132,8 +1135,9 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		rcu_read_unlock();
 
 		mutex_lock(&callback_mutex);
+		spin_lock_irqsave(&callback_lock, flags);
 		cp->effective_mems = *new_mems;
-		mutex_unlock(&callback_mutex);
+		spin_unlock_irqrestore(&callback_lock, flags);
 
 		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
 			!nodes_equal(cp->mems_allowed, cp->effective_mems));
@@ -1162,6 +1166,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
+	unsigned long flags;
 	int retval;
 
 	/*
@@ -1201,9 +1206,9 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cs->mems_allowed = trialcs->mems_allowed;
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	/* use trialcs->mems_allowed as a temp variable */
 	update_nodemasks_hier(cs, &cs->mems_allowed);
@@ -1264,6 +1269,7 @@ static void update_tasks_flags(struct cpuset *cs)
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
+	unsigned long flags;
 	struct cpuset *trialcs;
 	int balance_flag_changed;
 	int spread_flag_changed;
@@ -1288,9 +1294,9 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cs->flags = trialcs->flags;
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		rebuild_sched_domains_locked();
@@ -1690,11 +1696,12 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	ssize_t count;
 	char *buf, *s;
 	int ret = 0;
+	unsigned long flags;
 
 	count = seq_get_buf(sf, &buf);
 	s = buf;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_mutex, flags);
 
 	switch (type) {
 	case FILE_CPULIST:
@@ -1721,7 +1728,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 		seq_commit(sf, -1);
 	}
 out_unlock:
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqstore(&callback_lock, flags);
 	return ret;
 }
 
@@ -1924,6 +1931,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	struct cpuset *parent = parent_cs(cs);
 	struct cpuset *tmp_cs;
 	struct cgroup_subsys_state *pos_css;
+	unsigned long flags;
 
 	if (!parent)
 		return 0;
@@ -1938,12 +1946,12 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 
 	cpuset_inc();
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	if (cgroup_on_dfl(cs->css.cgroup)) {
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 		cs->effective_mems = parent->effective_mems;
 	}
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
@@ -1970,10 +1978,10 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	}
 	rcu_read_unlock();
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cs->mems_allowed = parent->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
-	mutex_unlock(&callback_mutex);
+	spin_lock_irqrestore(&callback_lock, flags);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
 	return 0;
@@ -2011,8 +2019,10 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 
 static void cpuset_bind(struct cgroup_subsys_state *root_css)
 {
+	unsigned long flags;
+
 	mutex_lock(&cpuset_mutex);
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 
 	if (cgroup_on_dfl(root_css->cgroup)) {
 		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
@@ -2023,7 +2033,7 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
 		top_cpuset.mems_allowed = top_cpuset.effective_mems;
 	}
 
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 	mutex_unlock(&cpuset_mutex);
 }
 
@@ -2107,13 +2117,14 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 			    bool cpus_updated, bool mems_updated)
 {
 	bool is_empty;
+	unsigned long flags;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cpumask_copy(cs->cpus_allowed, new_cpus);
 	cpumask_copy(cs->effective_cpus, new_cpus);
 	cs->mems_allowed = *new_mems;
 	cs->effective_mems = *new_mems;
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	/*
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
@@ -2145,15 +2156,17 @@ hotplug_update_tasks(struct cpuset *cs,
 		     struct cpumask *new_cpus, nodemask_t *new_mems,
 		     bool cpus_updated, bool mems_updated)
 {
+	unsigned long flags;
+
 	if (cpumask_empty(new_cpus))
 		cpumask_copy(new_cpus, parent_cs(cs)->effective_cpus);
 	if (nodes_empty(*new_mems))
 		*new_mems = parent_cs(cs)->effective_mems;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	cpumask_copy(cs->effective_cpus, new_cpus);
 	cs->effective_mems = *new_mems;
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	if (cpus_updated)
 		update_tasks_cpumask(cs);
@@ -2227,6 +2240,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
 	bool on_dfl = cgroup_on_dfl(top_cpuset.css.cgroup);
+	unsigned long flags;
 
 	mutex_lock(&cpuset_mutex);
 
@@ -2239,21 +2253,21 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
-		mutex_lock(&callback_mutex);
+		spin_lock_irqsave(&callback_lock, flags);
 		if (!on_dfl)
 			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
-		mutex_unlock(&callback_mutex);
+		spin_unlock_irqrestore(&callback_lock, flags);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
 	}
 
 	/* synchronize mems_allowed to N_MEMORY */
 	if (mems_updated) {
-		mutex_lock(&callback_mutex);
+		spin_lock_irqsave(&callback_lock, flags);
 		if (!on_dfl)
 			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
-		mutex_unlock(&callback_mutex);
+		spin_unlock_irqrestore(&callback_lock, flags);
 		update_tasks_nodemask(&top_cpuset);
 	}
 
@@ -2346,11 +2360,13 @@ void __init cpuset_init_smp(void)
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	mutex_lock(&callback_mutex);
+	unsigned long flags;
+
+	spin_lock_irqsave(&callback_lock, flags);
 	rcu_read_lock();
 	guarantee_online_cpus(task_cs(tsk), pmask);
 	rcu_read_unlock();
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
@@ -2396,12 +2412,13 @@ void cpuset_init_current_mems_allowed(void)
 nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 {
 	nodemask_t mask;
+	unsigned long flags;
 
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_lock, flags);
 	rcu_read_lock();
 	guarantee_online_mems(task_cs(tsk), &mask);
 	rcu_read_unlock();
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 
 	return mask;
 }
@@ -2514,14 +2531,14 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 		return 1;
 
 	/* Not hardwall and node outside mems_allowed: scan up cpusets */
-	mutex_lock(&callback_mutex);
+	spin_lock_irqsave(&callback_mutex, flags);
 
 	rcu_read_lock();
 	cs = nearest_hardwall_ancestor(task_cs(current));
 	allowed = node_isset(node, cs->mems_allowed);
 	rcu_read_unlock();
 
-	mutex_unlock(&callback_mutex);
+	spin_unlock_irqrestore(&callback_lock, flags);
 	return allowed;
 }
 
