From: Roman Gushchin <guro@fb.com>
Subject: Re: [v11 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 11 Oct 2017 17:10:24 +0100
Message-ID: <20171011161024.GA26974@castle>
References: <20171005130454.5590-1-guro@fb.com>
 <20171005130454.5590-4-guro@fb.com>
 <alpine.DEB.2.10.1710091414260.59643@chino.kir.corp.google.com>
 <20171010122306.GA11653@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=RbNWDdOXSEN7Kf3HzNIroHnFF8S+AbVqnq0e1pqSx1E=;
 b=LhKSxFObwPUTYxsy3TKgnve+LC1s0i01pp6s4Smr0kboBndEj8PtoMei+vhJsygRgyST
 rwo+bJG1NGROtS0ZGUPU/Wb43J/4V0gGfpU0M+4vJTwcmDrSxsYQ2w6syAhlvf4t3xMH
 0RO9J52wLqxsE0E6RKIZFRMMqG6T/P1JnWo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RbNWDdOXSEN7Kf3HzNIroHnFF8S+AbVqnq0e1pqSx1E=;
 b=ICZST3GtkJLqMCwNqogEc1x2TGgR04UWuXvipDXIsoQbC+uTHo/VSS/mMo3WAk8ywBSesH6N5TzT/VqBsF2Tkeo7MmZ4o/7UTyeifG5u9emJ1Z7I7m+mOMPAxFq6T9OA8G2tca0cLBhfwJC0BPo/+xHFUOGNr9RmgFXvYskV4Mc=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710101345370.28262@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 10, 2017 at 02:13:00PM -0700, David Rientjes wrote:
> On Tue, 10 Oct 2017, Roman Gushchin wrote:
> 
> > > This seems to unfairly bias the root mem cgroup depending on process size.  
> > > It isn't treated fairly as a leaf mem cgroup if they are being compared 
> > > based on different criteria: the root mem cgroup as (mostly) the largest 
> > > rss of a single process vs leaf mem cgroups as all anon, unevictable, and 
> > > unreclaimable slab pages charged to it by all processes.
> > > 
> > > I imagine a configuration where the root mem cgroup has 100 processes 
> > > attached each with rss of 80MB, compared to a leaf cgroup with 100 
> > > processes of 1MB rss each.  How does this logic prevent repeatedly oom 
> > > killing the processes of 1MB rss?
> > > 
> > > In this case, "the root cgroup is treated as a leaf memory cgroup" isn't 
> > > quite fair, it can simply hide large processes from being selected.  Users 
> > > who configure cgroups in a unified hierarchy for other resource 
> > > constraints are penalized for this choice even though the mem cgroup with 
> > > 100 processes of 1MB rss each may not be limited itself.
> > > 
> > > I think for this comparison to be fair, it requires accounting for the 
> > > root mem cgroup itself or for a different accounting methodology for leaf 
> > > memory cgroups.
> > 
> > This is basically a workaround, because we don't have necessary stats for root
> > memory cgroup. If we'll start gathering them at some point, we can change this
> > and treat root memcg exactly as other leaf cgroups.
> > 
> 
> I understand why it currently cannot be an apples vs apples comparison 
> without, as I suggest in the last paragraph, that the same accounting is 
> done for the root mem cgroup, which is intuitive if it is to be considered 
> on the same basis as leaf mem cgroups.
> 
> I understand for the design to work that leaf mem cgroups and the root mem 
> cgroup must be compared if processes can be attached to the root mem 
> cgroup.  My point is that it is currently completely unfair as I've 
> stated: you can have 10000 processes attached to the root mem cgroup with 
> rss of 80MB each and a leaf mem cgroup with 100 processes of 1MB rss each 
> and the oom killer is going to target the leaf mem cgroup as a result of 
> this apples vs oranges comparison.
> 
> In case it's not clear, the 10000 processes of 80MB rss each is the most 
> likely contributor to a system-wide oom kill.  Unfortunately, the 
> heuristic introduced by this patchset is broken wrt a fair comparison of 
> the root mem cgroup usage.
> 
> > Or, if someone will come with an idea of a better approximation, it can be
> > implemented as a separate enhancement on top of the initial implementation.
> > This is more than welcome.
> > 
> 
> We don't need a better approximation, we need a fair comparison.  The 
> heuristic that this patchset is implementing is based on the usage of 
> individual mem cgroups.  For the root mem cgroup to be considered 
> eligible, we need to understand its usage.  That usage is _not_ what is 
> implemented by this patchset, which is the largest rss of a single 
> attached process.  This, in fact, is not an "approximation" at all.  In 
> the example of 10000 processes attached with 80MB rss each, the usage of 
> the root mem cgroup is _not_ 80MB.
> 
> I'll restate that oom killing a process is a last resort for the kernel, 
> but it also must be able to make a smart decision.  Targeting dozens of 
> 1MB processes instead of 80MB processes because of a shortcoming in this 
> implementation is not the appropriate selection, it's the opposite of the 
> correct selection.
> 
> > > I'll reiterate what I did on the last version of the patchset: considering 
> > > only leaf memory cgroups easily allows users to defeat this heuristic and 
> > > bias against all of their memory usage up to the largest process size 
> > > amongst the set of processes attached.  If the user creates N child mem 
> > > cgroups for their N processes and attaches one process to each child, the 
> > > _only_ thing this achieved is to defeat your heuristic and prefer other 
> > > leaf cgroups simply because those other leaf cgroups did not do this.
> > > 
> > > Effectively:
> > > 
> > > for i in $(cat cgroup.procs); do mkdir $i; echo $i > $i/cgroup.procs; done
> > > 
> > > will radically shift the heuristic from a score of all anonymous + 
> > > unevictable memory for all processes to a score of the largest anonymous +
> > > unevictable memory for a single process.  There is no downside or 
> > > ramifaction for the end user in doing this.  When comparing cgroups based 
> > > on usage, it only makes sense to compare the hierarchical usage of that 
> > > cgroup so that attaching processes to descendants or splitting the 
> > > implementation of a process into several smaller individual processes does 
> > > not allow this heuristic to be defeated.
> > 
> > To all previously said words I can only add that cgroup v2 allows to limit
> > the amount of cgroups in the sub-tree:
> > 1a926e0bbab8 ("cgroup: implement hierarchy limits").
> > 
> 
> So the solution to 
> 
> for i in $(cat cgroup.procs); do mkdir $i; echo $i > $i/cgroup.procs; done
> 
> evading all oom kills for your mem cgroup is to limit the number of 
> cgroups that can be created by the user?  With a unified cgroup hierarchy, 
> that doesn't work well if I wanted to actually constrain these individual 
> processes to different resource limits like cpu usage.  In fact, the user 
> may not know it is effectively evading the oom killer entirely because it 
> has constrained the cpu of individual processes because its a side-effect 
> of this heuristic.
> 
> 
> You chose not to respond to my reiteration of userspace having absolutely 
> no control over victim selection with the new heuristic without setting 
> all processes to be oom disabled via /proc/pid/oom_score_adj.  If I have a 
> very important job that is running on a system that is really supposed to 
> use 80% of memory, I need to be able to specify that it should not be oom 
> killed based on user goals.  Setting all processes to be oom disabled in 
> the important mem cgroup to avoid being oom killed unless absolutely 
> necessary in a system oom condition is not a robust solution: (1) the mem 
> cgroup livelocks if it reaches its own mem cgroup limit and (2) the system 
> panic()'s if these preferred mem cgroups are the only consumers left on 
> the system.  With overcommit, both of these possibilities exist in the 
> wild and the problem is only a result of the implementation detail of this 
> patchset.
> 
> For these reasons: unfair comparison of root mem cgroup usage to bias 
> against that mem cgroup from oom kill in system oom conditions, the 
> ability of users to completely evade the oom killer by attaching all 
> processes to child cgroups either purposefully or unpurposefully, and the 
> inability of userspace to effectively control oom victim selection:
> 
> Nacked-by: David Rientjes <rientjes@google.com>

Hi David!

Do you find the following approach (summing oom_score of
tasks belonging to the root memory cgroup) acceptable?

Also, I've closed the race, you've pointed on.

Thanks!

--------------------------------------------------------------------------------
From 7f51d26be2d2a5b6e4840574f72beb15920c0993 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 25 May 2017 14:18:45 +0100
Subject: [v12 3/6] mm, oom: cgroup-aware OOM killer

Traditionally, the OOM killer is operating on a process level.
Under oom conditions, it finds a process with the highest oom score
and kills it.

This behavior doesn't suit well the system with many running
containers:

1) There is no fairness between containers. A small container with
few large processes will be chosen over a large one with huge
number of small processes.

2) Containers often do not expect that some random process inside
will be killed. In many cases much safer behavior is to kill
all tasks in the container. Traditionally, this was implemented
in userspace, but doing it in the kernel has some advantages,
especially in a case of a system-wide OOM.

To address these issues, the cgroup-aware OOM killer is introduced.

This patch introduces the core functionality: an ability to select
a memory cgroup as an OOM victim. Under OOM conditions the OOM killer
looks for the biggest leaf memory cgroup and kills the biggest
task belonging to it.

The following patches will extend this functionality to consider
non-leaf memory cgroups as OOM victims, and also provide an ability
to kill all tasks belonging to the victim cgroup.

The root cgroup is treated as a leaf memory cgroup, so it's score
is compared with other leaf memory cgroups.
Due to memcg statistics implementation a special approximation
is used for estimating oom_score of root memory cgroup: we sum
oom_score of the belonging processes (or, to be more precise,
tasks owning their mm structures).

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h |  17 +++++
 include/linux/oom.h        |  12 ++-
 mm/memcontrol.c            | 181 +++++++++++++++++++++++++++++++++++++++++++++
 mm/oom_kill.c              |  72 +++++++++++++-----
 4 files changed, 262 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69966c461d1c..75b63b68846e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -35,6 +35,7 @@ struct mem_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
+struct oom_control;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
@@ -342,6 +343,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
 }
 
+static inline void mem_cgroup_put(struct mem_cgroup *memcg)
+{
+	css_put(&memcg->css);
+}
+
 #define mem_cgroup_from_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
@@ -480,6 +486,8 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
 
 bool mem_cgroup_oom_synchronize(bool wait);
 
+bool mem_cgroup_select_oom_victim(struct oom_control *oc);
+
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
 #endif
@@ -744,6 +752,10 @@ static inline bool task_in_mem_cgroup(struct task_struct *task,
 	return true;
 }
 
+static inline void mem_cgroup_put(struct mem_cgroup *memcg)
+{
+}
+
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
@@ -936,6 +948,11 @@ static inline
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
+static inline bool mem_cgroup_select_oom_victim(struct oom_control *oc)
+{
+	return false;
+}
 #endif /* CONFIG_MEMCG */
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 76aac4ce39bc..ca78e2d5956e 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -9,6 +9,13 @@
 #include <linux/sched/coredump.h> /* MMF_* */
 #include <linux/mm.h> /* VM_FAULT* */
 
+
+/*
+ * Special value returned by victim selection functions to indicate
+ * that are inflight OOM victims.
+ */
+#define INFLIGHT_VICTIM ((void *)-1UL)
+
 struct zonelist;
 struct notifier_block;
 struct mem_cgroup;
@@ -39,7 +46,8 @@ struct oom_control {
 
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
-	struct task_struct *chosen;
+	struct task_struct *chosen_task;
+	struct mem_cgroup *chosen_memcg;
 	unsigned long chosen_points;
 };
 
@@ -101,6 +109,8 @@ extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
+extern int oom_evaluate_task(struct task_struct *task, void *arg);
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index df3368734f1c..8f04e1fb9dd9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2670,6 +2670,187 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 	return ret;
 }
 
+static long memcg_oom_badness(struct mem_cgroup *memcg,
+			      const nodemask_t *nodemask,
+			      unsigned long totalpages)
+{
+	long points = 0;
+	int nid;
+	pg_data_t *pgdat;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (nodemask && !node_isset(nid, *nodemask))
+			continue;
+
+		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
+				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
+
+		pgdat = NODE_DATA(nid);
+		points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
+					    NR_SLAB_UNRECLAIMABLE);
+	}
+
+	points += memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) /
+		(PAGE_SIZE / 1024);
+	points += memcg_page_state(memcg, MEMCG_SOCK);
+	points += memcg_page_state(memcg, MEMCG_SWAP);
+
+	return points;
+}
+
+/*
+ * Checks if the given memcg is a valid OOM victim and returns a number,
+ * which means the folowing:
+ *   -1: there are inflight OOM victim tasks, belonging to the memcg
+ *    0: memcg is not eligible, e.g. all belonging tasks are protected
+ *       by oom_score_adj set to OOM_SCORE_ADJ_MIN
+ *   >0: memcg is eligible, and the returned value is an estimation
+ *       of the memory footprint
+ */
+static long oom_evaluate_memcg(struct mem_cgroup *memcg,
+			       const nodemask_t *nodemask,
+			       unsigned long totalpages)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+	int eligible = 0;
+
+	/*
+	 * Root memory cgroup is a special case:
+	 * we don't have necessary stats to evaluate it exactly as
+	 * leaf memory cgroups, so we approximate it's oom_score
+	 * by summing oom_score of all belonging tasks, which are
+	 * owners of their mm structs.
+	 *
+	 * If there are inflight OOM victim tasks inside
+	 * the root memcg, we return -1.
+	 */
+	if (memcg == root_mem_cgroup) {
+		struct css_task_iter it;
+		struct task_struct *task;
+		long score = 0;
+
+		css_task_iter_start(&memcg->css, 0, &it);
+		while ((task = css_task_iter_next(&it))) {
+			if (tsk_is_oom_victim(task) &&
+			    !test_bit(MMF_OOM_SKIP,
+				      &task->signal->oom_mm->flags)) {
+				score = -1;
+				break;
+			}
+
+			task_lock(task);
+			if (!task->mm || task->mm->owner != task) {
+				task_unlock(task);
+				continue;
+			}
+			task_unlock(task);
+
+			score += oom_badness(task, memcg, nodemask,
+					     totalpages);
+		}
+		css_task_iter_end(&it);
+
+		return score;
+	}
+
+	/*
+	 * Memcg is OOM eligible if there are OOM killable tasks inside.
+	 *
+	 * We treat tasks with oom_score_adj set to OOM_SCORE_ADJ_MIN
+	 * as unkillable.
+	 *
+	 * If there are inflight OOM victim tasks inside the memcg,
+	 * we return -1.
+	 */
+	css_task_iter_start(&memcg->css, 0, &it);
+	while ((task = css_task_iter_next(&it))) {
+		if (!eligible &&
+		    task->signal->oom_score_adj != OOM_SCORE_ADJ_MIN)
+			eligible = 1;
+
+		if (tsk_is_oom_victim(task) &&
+		    !test_bit(MMF_OOM_SKIP, &task->signal->oom_mm->flags)) {
+			eligible = -1;
+			break;
+		}
+	}
+	css_task_iter_end(&it);
+
+	if (eligible <= 0)
+		return eligible;
+
+	return memcg_oom_badness(memcg, nodemask, totalpages);
+}
+
+static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
+{
+	struct mem_cgroup *iter;
+
+	oc->chosen_memcg = NULL;
+	oc->chosen_points = 0;
+
+	/*
+	 * The oom_score is calculated for leaf memory cgroups (including
+	 * the root memcg).
+	 */
+	rcu_read_lock();
+	for_each_mem_cgroup_tree(iter, root) {
+		long score;
+
+		if (memcg_has_children(iter) && iter != root_mem_cgroup)
+			continue;
+
+		score = oom_evaluate_memcg(iter, oc->nodemask, oc->totalpages);
+
+		/*
+		 * Ignore empty and non-eligible memory cgroups.
+		 */
+		if (score == 0)
+			continue;
+
+		/*
+		 * If there are inflight OOM victims, we don't need
+		 * to look further for new victims.
+		 */
+		if (score == -1) {
+			oc->chosen_memcg = INFLIGHT_VICTIM;
+			mem_cgroup_iter_break(root, iter);
+			break;
+		}
+
+		if (score > oc->chosen_points) {
+			oc->chosen_points = score;
+			oc->chosen_memcg = iter;
+		}
+	}
+
+	if (oc->chosen_memcg && oc->chosen_memcg != INFLIGHT_VICTIM)
+		css_get(&oc->chosen_memcg->css);
+
+	rcu_read_unlock();
+}
+
+bool mem_cgroup_select_oom_victim(struct oom_control *oc)
+{
+	struct mem_cgroup *root;
+
+	if (mem_cgroup_disabled())
+		return false;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return false;
+
+	if (oc->memcg)
+		root = oc->memcg;
+	else
+		root = root_mem_cgroup;
+
+	select_victim_memcg(root, oc);
+
+	return oc->chosen_memcg;
+}
+
 /*
  * Reclaims as many pages from the given memcg as possible.
  *
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0b9f36117989..5b670adb850c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -309,7 +309,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	return CONSTRAINT_NONE;
 }
 
-static int oom_evaluate_task(struct task_struct *task, void *arg)
+int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
 	unsigned long points;
@@ -343,26 +343,26 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 		goto next;
 
 	/* Prefer thread group leaders for display purposes */
-	if (points == oc->chosen_points && thread_group_leader(oc->chosen))
+	if (points == oc->chosen_points && thread_group_leader(oc->chosen_task))
 		goto next;
 select:
-	if (oc->chosen)
-		put_task_struct(oc->chosen);
+	if (oc->chosen_task)
+		put_task_struct(oc->chosen_task);
 	get_task_struct(task);
-	oc->chosen = task;
+	oc->chosen_task = task;
 	oc->chosen_points = points;
 next:
 	return 0;
 abort:
-	if (oc->chosen)
-		put_task_struct(oc->chosen);
-	oc->chosen = (void *)-1UL;
+	if (oc->chosen_task)
+		put_task_struct(oc->chosen_task);
+	oc->chosen_task = INFLIGHT_VICTIM;
 	return 1;
 }
 
 /*
  * Simple selection loop. We choose the process with the highest number of
- * 'points'. In case scan was aborted, oc->chosen is set to -1.
+ * 'points'. In case scan was aborted, oc->chosen_task is set to -1.
  */
 static void select_bad_process(struct oom_control *oc)
 {
@@ -923,7 +923,7 @@ static void __oom_kill_process(struct task_struct *victim)
 
 static void oom_kill_process(struct oom_control *oc, const char *message)
 {
-	struct task_struct *p = oc->chosen;
+	struct task_struct *p = oc->chosen_task;
 	unsigned int points = oc->chosen_points;
 	struct task_struct *victim = p;
 	struct task_struct *child;
@@ -984,6 +984,27 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	__oom_kill_process(victim);
 }
 
+static bool oom_kill_memcg_victim(struct oom_control *oc)
+{
+
+	if (oc->chosen_memcg == NULL || oc->chosen_memcg == INFLIGHT_VICTIM)
+		return oc->chosen_memcg;
+
+	/* Kill a task in the chosen memcg with the biggest memory footprint */
+	oc->chosen_points = 0;
+	oc->chosen_task = NULL;
+	mem_cgroup_scan_tasks(oc->chosen_memcg, oom_evaluate_task, oc);
+
+	if (oc->chosen_task == NULL || oc->chosen_task == INFLIGHT_VICTIM)
+		goto out;
+
+	__oom_kill_process(oc->chosen_task);
+
+out:
+	mem_cgroup_put(oc->chosen_memcg);
+	return oc->chosen_task;
+}
+
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
@@ -1036,6 +1057,7 @@ bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
+	bool delay = false; /* if set, delay next allocation attempt */
 
 	if (oom_killer_disabled)
 		return false;
@@ -1080,27 +1102,39 @@ bool out_of_memory(struct oom_control *oc)
 	    current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
 		get_task_struct(current);
-		oc->chosen = current;
+		oc->chosen_task = current;
 		oom_kill_process(oc, "Out of memory (oom_kill_allocating_task)");
 		return true;
 	}
 
+	if (mem_cgroup_select_oom_victim(oc)) {
+		if (oom_kill_memcg_victim(oc))
+		    delay = true;
+
+		goto out;
+	}
+
 	select_bad_process(oc);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!oc->chosen && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
+	if (!oc->chosen_task && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
 		dump_header(oc, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (oc->chosen && oc->chosen != (void *)-1UL) {
+	if (oc->chosen_task && oc->chosen_task != INFLIGHT_VICTIM) {
 		oom_kill_process(oc, !is_memcg_oom(oc) ? "Out of memory" :
 				 "Memory cgroup out of memory");
-		/*
-		 * Give the killed process a good chance to exit before trying
-		 * to allocate memory again.
-		 */
-		schedule_timeout_killable(1);
+		delay = true;
 	}
-	return !!oc->chosen;
+
+out:
+	/*
+	 * Give the killed process a good chance to exit before trying
+	 * to allocate memory again.
+	 */
+	if (delay)
+		schedule_timeout_killable(1);
+
+	return !!oc->chosen_task;
 }
 
 /*
-- 
2.13.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
