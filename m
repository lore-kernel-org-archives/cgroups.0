From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V3 05/10] cpuset: Rebuild root domain deadline accounting information
Date: Tue, 13 Feb 2018 13:32:42 -0700
Message-ID: <1518553967-20656-6-git-send-email-mathieu.poirier@linaro.org>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RpRuSxilgCH4LvoCdF6+8SofEdCVGn9nDBpdua5XPeg=;
        b=ZyuffiXfo5iEz4uAcBgVh9AbjJH/5OUzhigoxN2CbbuxFHdrROm2U7MPr4IvGUJOk/
         cTyZ7LxGXqGzrfnj4ITSxP8pzQb4/w4Ldb/Y9PLCnBEbcfNmliQ9PhH6wfw5+X4MXgKI
         lVY+kt6t1HwJFSh02q7haJn8rjheinsPeh9rk=
In-Reply-To: <1518553967-20656-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When the topology of root domains is modified by CPUset or CPUhotplug
operations information about the current deadline bandwidth held in the
root domain is lost.

This patch address the issue by recalculating the lost deadline
bandwidth information by circling through the deadline tasks held in
CPUsets and adding their current load to the root domain they are
associated with.

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/sched.h          |  5 ++++
 include/linux/sched/deadline.h |  8 ++++++
 kernel/cgroup/cpuset.c         | 63 +++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/deadline.c        | 31 +++++++++++++++++++++
 kernel/sched/sched.h           |  3 --
 kernel/sched/topology.c        | 14 +++++++++-
 6 files changed, 119 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b161ef8a902e..b9bd7da8dc85 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -239,6 +239,11 @@ struct vtime {
 	u64			gtime;
 };
 
+#ifdef CONFIG_SMP
+extern struct root_domain def_root_domain;
+extern struct mutex sched_domains_mutex;
+#endif
+
 struct sched_info {
 #ifdef CONFIG_SCHED_INFO
 	/* Cumulative counters: */
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index a5bc8728ead7..050961659b1d 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -29,4 +29,12 @@ static inline bool dl_time_before(u64 a, u64 b)
 	return (s64)(a - b) < 0;
 }
 
+#ifdef CONFIG_SMP
+
+struct root_domain;
+extern void dl_add_task_root_domain(struct task_struct *p);
+extern void dl_clear_root_domain(struct root_domain *rd);
+
+#endif /* CONFIG_SMP */
+
 #endif /* _LINUX_SCHED_DEADLINE_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 41f8391640e6..d8108030b754 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -44,6 +44,7 @@
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/sched/deadline.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
 #include <linux/seq_file.h>
@@ -812,6 +813,66 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	return ndoms;
 }
 
+static void update_tasks_root_domain(struct cpuset *cs)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	css_task_iter_start(&cs->css, 0, &it);
+
+	while ((task = css_task_iter_next(&it)))
+		dl_add_task_root_domain(task);
+
+	css_task_iter_end(&it);
+}
+
+/*
+ * Called with cpuset_mutex held (rebuild_sched_domains())
+ * Called with hotplug lock held (rebuild_sched_domains_locked())
+ * Called with sched_domains_mutex held (partition_and_rebuild_domains())
+ */
+static void rebuild_root_domains(void)
+{
+	struct cpuset *cs = NULL;
+	struct cgroup_subsys_state *pos_css;
+
+	rcu_read_lock();
+
+	/*
+	 * Clear default root domain DL accounting, it will be computed again
+	 * if a task belongs to it.
+	 */
+	dl_clear_root_domain(&def_root_domain);
+
+	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
+
+		if (cpumask_empty(cs->effective_cpus)) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
+		}
+
+		css_get(&cs->css);
+
+		rcu_read_unlock();
+
+		update_tasks_root_domain(cs);
+
+		rcu_read_lock();
+		css_put(&cs->css);
+	}
+	rcu_read_unlock();
+}
+
+static void
+partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
+				    struct sched_domain_attr *dattr_new)
+{
+	mutex_lock(&sched_domains_mutex);
+	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
+	rebuild_root_domains();
+	mutex_unlock(&sched_domains_mutex);
+}
+
 /*
  * Rebuild scheduler domains.
  *
@@ -844,7 +905,7 @@ static void rebuild_sched_domains_locked(void)
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
-	partition_sched_domains(ndoms, doms, attr);
+	partition_and_rebuild_sched_domains(ndoms, doms, attr);
 out:
 	put_online_cpus();
 }
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9bb0e0c412ec..8eb508cf1990 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2269,6 +2269,37 @@ void __init init_sched_dl_class(void)
 					GFP_KERNEL, cpu_to_node(i));
 }
 
+void dl_add_task_root_domain(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq_flags rf;
+	struct rq *rq;
+	struct dl_bw *dl_b;
+
+	rq = task_rq_lock(p, &rf);
+	if (!dl_task(p))
+		goto unlock;
+
+	dl_b = &rq->rd->dl_bw;
+	raw_spin_lock_irqsave(&dl_b->lock, flags);
+
+	dl_b->total_bw += p->dl.dl_bw;
+
+	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+unlock:
+	task_rq_unlock(rq, p, &rf);
+}
+
+void dl_clear_root_domain(struct root_domain *rd)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rd->dl_bw.lock, flags);
+	rd->dl_bw.total_bw = 0;
+	raw_spin_unlock_irqrestore(&rd->dl_bw.lock, flags);
+}
+
 #endif /* CONFIG_SMP */
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb5fc458547f..8aba192d4d17 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -685,9 +685,6 @@ struct root_domain {
 	unsigned long max_cpu_capacity;
 };
 
-extern struct root_domain def_root_domain;
-extern struct mutex sched_domains_mutex;
-
 extern void init_defrootdomain(void);
 extern int sched_init_domains(const struct cpumask *cpu_map);
 extern void rq_attach_root(struct rq *rq, struct root_domain *rd);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index eee721da40fb..3210ded386ba 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3,6 +3,7 @@
  * Scheduler topology setup/handling methods
  */
 #include <linux/sched.h>
+#include <linux/sched/deadline.h>
 #include <linux/mutex.h>
 #include <linux/sched/isolation.h>
 #include <linux/proc_fs.h>
@@ -1889,8 +1890,19 @@ void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n && !new_topology; j++) {
 			if (cpumask_equal(doms_cur[i], doms_new[j])
-			    && dattrs_equal(dattr_cur, i, dattr_new, j))
+			    && dattrs_equal(dattr_cur, i, dattr_new, j)) {
+				struct root_domain *rd;
+
+				/*
+				 * This domain won't be destroyed and as such
+				 * its dl_bw->total_bw needs to be cleared.  It
+				 * will be recomputed in function
+				 * update_tasks_root_domain().
+				 */
+				rd = cpu_rq(cpumask_any(doms_cur[i]))->rd;
+				dl_clear_root_domain(rd);
 				goto match1;
+			}
 		}
 		/* No match - a current sched domain not in new doms_new[] */
 		detach_destroy_domains(doms_cur[i]);
-- 
2.7.4
