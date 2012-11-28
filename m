From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/13] cpuset: introduce cpuset_for_each_child()
Date: Wed, 28 Nov 2012 13:34:12 -0800
Message-ID: <1354138460-19286-6-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=gdEyoLTWB9nF2SdodprzkpFXdlmiVbDT0M/2G5bGNzU=;
        b=e5GjgMREhc6Z8ISCrQ55mdNWjg92tQjyd+zSNn/tHEcO2Qf0RNebGIT9jxdDGKyhgr
         2ucPtiEIxqolK2KJrFQ3MEgCPM787Z0x2gjoxzb5fcEh44P9u+S9YXU7Sigw0mby7R8d
         dYQsAzPY6USvt/6s4LPFVTBri3xtg40AR6pSy1XCQ559fct0jAqoiYSqkZ3/XKmE7P/f
         0AQd5mP8d7M6SOHB1jMxjPXeqILWNPwqLTBSrhptKvvftkKTZ/EU1FlSbUJPIiUjYUrb
         BFr9iryrNwS/mzwX2N5zeDoN+dNnMa2xsblzs/oxHYhv5N5cjqvgZw5g7J9Sah0xcK87
         i3mw==
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Instead of iterating cgroup->children directly, introduce and use
cpuset_for_each_child() which wraps cgroup_for_each_child() and
performs online check.  As it uses the generic iterator, it requires
RCU read locking too.

As cpuset is currently protected by cgroup_mutex, non-online cpusets
aren't visible to all the iterations and this patch currently doesn't
make any functional difference.  This will be used to de-couple cpuset
locking from cgroup core.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 85 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 31 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22b521d..5a52ed6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -200,6 +200,19 @@ static struct cpuset top_cpuset = {
 		  (1 << CS_MEM_EXCLUSIVE)),
 };
 
+/**
+ * cpuset_for_each_child - traverse online children of a cpuset
+ * @child_cs: loop cursor pointing to the current child
+ * @pos_cgrp: used for iteration
+ * @parent_cs: target cpuset to walk children of
+ *
+ * Walk @child_cs through the online children of @parent_cs.  Must be used
+ * with RCU read locked.
+ */
+#define cpuset_for_each_child(child_cs, pos_cgrp, parent_cs)		\
+	cgroup_for_each_child((pos_cgrp), (parent_cs)->css.cgroup)	\
+		if (is_cpuset_online(((child_cs) = cgroup_cs((pos_cgrp)))))
+
 /*
  * There are two global mutexes guarding cpuset structures.  The first
  * is the main control groups cgroup_mutex, accessed via
@@ -419,48 +432,55 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 {
 	struct cgroup *cont;
 	struct cpuset *c, *par;
+	int ret;
+
+	rcu_read_lock();
 
 	/* Each of our child cpusets must be a subset of us */
-	list_for_each_entry(cont, &cur->css.cgroup->children, sibling) {
-		if (!is_cpuset_subset(cgroup_cs(cont), trial))
-			return -EBUSY;
-	}
+	ret = -EBUSY;
+	cpuset_for_each_child(c, cont, cur)
+		if (!is_cpuset_subset(c, trial))
+			goto out;
 
 	/* Remaining checks don't apply to root cpuset */
+	ret = 0;
 	if (cur == &top_cpuset)
-		return 0;
+		goto out;
 
 	par = cur->parent;
 
 	/* We must be a subset of our parent cpuset */
+	ret = -EACCES;
 	if (!is_cpuset_subset(trial, par))
-		return -EACCES;
+		goto out;
 
 	/*
 	 * If either I or some sibling (!= me) is exclusive, we can't
 	 * overlap
 	 */
-	list_for_each_entry(cont, &par->css.cgroup->children, sibling) {
-		c = cgroup_cs(cont);
+	ret = -EINVAL;
+	cpuset_for_each_child(c, cont, par) {
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
 		    c != cur &&
 		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
-			return -EINVAL;
+			goto out;
 		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
 		    c != cur &&
 		    nodes_intersects(trial->mems_allowed, c->mems_allowed))
-			return -EINVAL;
+			goto out;
 	}
 
 	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
-	if (cgroup_task_count(cur->css.cgroup)) {
-		if (cpumask_empty(trial->cpus_allowed) ||
-		    nodes_empty(trial->mems_allowed)) {
-			return -ENOSPC;
-		}
-	}
+	ret = -ENOSPC;
+	if (cgroup_task_count(cur->css.cgroup) &&
+	    (cpumask_empty(trial->cpus_allowed) ||
+	     nodes_empty(trial->mems_allowed)))
+		goto out;
 
-	return 0;
+	ret = 0;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 #ifdef CONFIG_SMP
@@ -501,10 +521,10 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
 		if (is_sched_load_balance(cp))
 			update_domain_attr(dattr, cp);
 
-		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
-			child = cgroup_cs(cont);
+		rcu_read_lock();
+		cpuset_for_each_child(child, cont, cp)
 			list_add_tail(&child->stack_list, &q);
-		}
+		rcu_read_unlock();
 	}
 }
 
@@ -623,10 +643,10 @@ static int generate_sched_domains(cpumask_var_t **domains,
 			continue;
 		}
 
-		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
-			child = cgroup_cs(cont);
+		rcu_read_lock();
+		cpuset_for_each_child(child, cont, cp)
 			list_add_tail(&child->stack_list, &q);
-		}
+		rcu_read_unlock();
   	}
 
 	for (i = 0; i < csn; i++)
@@ -1824,7 +1844,8 @@ static int cpuset_css_online(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *parent = cs->parent;
-	struct cgroup *tmp_cg;
+	struct cpuset *tmp_cs;
+	struct cgroup *pos_cg;
 
 	if (!parent)
 		return 0;
@@ -1853,12 +1874,14 @@ static int cpuset_css_online(struct cgroup *cgrp)
 	 * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
 	 * (and likewise for mems) to the new cgroup.
 	 */
-	list_for_each_entry(tmp_cg, &cgrp->parent->children, sibling) {
-		struct cpuset *tmp_cs = cgroup_cs(tmp_cg);
-
-		if (is_mem_exclusive(tmp_cs) || is_cpu_exclusive(tmp_cs))
+	rcu_read_lock();
+	cpuset_for_each_child(tmp_cs, pos_cg, parent) {
+		if (is_mem_exclusive(tmp_cs) || is_cpu_exclusive(tmp_cs)) {
+			rcu_read_unlock();
 			return 0;
+		}
 	}
+	rcu_read_unlock();
 
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = parent->mems_allowed;
@@ -2027,10 +2050,10 @@ static struct cpuset *cpuset_next(struct list_head *queue)
 
 	cp = list_first_entry(queue, struct cpuset, stack_list);
 	list_del(queue->next);
-	list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
-		child = cgroup_cs(cont);
+	rcu_read_lock();
+	cpuset_for_each_child(child, cont, cp)
 		list_add_tail(&child->stack_list, queue);
-	}
+	rcu_read_unlock();
 
 	return cp;
 }
-- 
1.7.11.7

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
