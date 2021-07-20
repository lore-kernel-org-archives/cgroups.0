From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 5/9] cgroup/cpuset: Clarify the use of invalid partition root
Date: Tue, 20 Jul 2021 10:18:30 -0400
Message-ID: <20210720141834.10624-6-longman@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626790804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rZZr3sNUbKZUg7SvSA895cqp7BzbFQI3D2K+Izz5kw4=;
        b=LTElxgczNbCOCcuJw9ZzQFDjSYoKgiHDP+ExqPPWTGNpISs680F8nxcuLw+6dpeKH9EETD
        0nud4il6rc5G0GEI0ZxqxH7r7DhlyNGT8rEofYa36chR0TCI3XIxGg/ZTVqSCeghipbKdi
        /tS5ANi7jUnKYoYGvoqKz4LIFuf1sH8=
In-Reply-To: <20210720141834.10624-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For cpuset partition, the special state of PRS_ERROR (invalid partition
root) was originally designed to handle hotplug events.  In this state,
CPUs allocated to the partition root is released back to the parent
but the cpuset exclusive flags remain unchanged.

Since partition root sets the CPU_EXCLUSIVE flag, cpuset.cpus changes
that break the cpu exclusivity rule will not be allowed. However,
other changes to cpuset.cpus on a partition root may still cause it to
become invalid. This is undesriable as we don't want accidental change
to cpuset.cpus to invalidate a partition root.

Additional checks are now added to make sure that regular cpuset control
file manipulations are not allowed to make a partition root invalid. These
additional checks are:

 1) A partition root can't be changed to member if it has child partition
    roots.
 2) Removing CPUs from cpuset.cpus that causes it to become invalid is
    not allowed.

Comments are also added to clarify that a partition root becomes
invalid only when an external event like hotplug that causes all the
CPUs allocated to a partition root to become unavailable.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 144 ++++++++++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 58 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2e34fc5b76f0..c16060b703cc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -177,7 +177,9 @@ struct cpuset {
  *       subparts_cpus. In this case, the cpuset is not a real partition
  *       root anymore.  However, the CPU_EXCLUSIVE bit will still be set
  *       and the cpuset can be restored back to a partition root if the
- *       parent cpuset can give more CPUs back to this child cpuset.
+ *       parent cpuset can give more CPUs back to this child cpuset. A
+ *       partition root becomes invalid when all its cpus become unavailable
+ *       like being offlined.
  */
 #define PRS_DISABLED		0
 #define PRS_ENABLED		1
@@ -1211,6 +1213,15 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		/*
 		 * partcmd_update with newmask:
 		 *
+		 * Return error if newmask isn't a subset of
+		 * (cpus_allowed | parent->effective_cpus).
+		 */
+		cpumask_or(tmp->addmask, cpuset->cpus_allowed,
+					 parent->effective_cpus);
+		if (!cpumask_subset(newmask, tmp->addmask))
+			return -EINVAL;
+
+		/*
 		 * delmask = cpus_allowed & ~newmask & parent->subparts_cpus
 		 * addmask = newmask & parent->effective_cpus
 		 *		     & ~parent->subparts_cpus
@@ -1223,7 +1234,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
 		/*
-		 * Return error if the new effective_cpus could become empty.
+		 * Return error if parent's effective_cpus could become empty.
 		 */
 		if (adding &&
 		    cpumask_equal(parent->effective_cpus, tmp->addmask)) {
@@ -1239,20 +1250,35 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 				return -EINVAL;
 			cpumask_copy(tmp->addmask, parent->effective_cpus);
 		}
+
+		/*
+		 * Return error if effective_cpus becomes empty or any CPU
+		 * distributed to child partitions is deleted.
+		 */
+		if (deleting &&
+		   (cpumask_intersects(tmp->delmask, cpuset->subparts_cpus) ||
+		    cpumask_equal(tmp->delmask, cpuset->effective_cpus)))
+			return -EBUSY;
 	} else {
 		/*
 		 * partcmd_update w/o newmask:
 		 *
 		 * addmask = cpus_allowed & parent->effective_cpus
 		 *
+		 * This gets invoked either due to a hotplug event or
+		 * from update_cpumasks_hier() where we can't return an
+		 * error. This can cause a partition root to become invalid
+		 * in the case of a hotplug.
+		 *
 		 * Note that parent's subparts_cpus may have been
 		 * pre-shrunk in case there is a change in the cpu list.
 		 * So no deletion is needed.
 		 */
 		adding = cpumask_and(tmp->addmask, cpuset->cpus_allowed,
 				     parent->effective_cpus);
-		part_error = cpumask_equal(tmp->addmask,
-					   parent->effective_cpus);
+		part_error = (is_partition_root(cpuset) &&
+			      !parent->nr_subparts_cpus) ||
+			     cpumask_equal(tmp->addmask, parent->effective_cpus);
 	}
 
 	if (cmd == partcmd_update) {
@@ -1427,33 +1453,27 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 
 		spin_lock_irq(&callback_lock);
 
-		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
 		if (cp->nr_subparts_cpus && (new_prs != PRS_ENABLED)) {
+			/*
+			 * Put all active subparts_cpus back to effective_cpus.
+			 */
+			cpumask_or(tmp->new_cpus, tmp->new_cpus,
+				   cp->subparts_cpus);
+			cpumask_and(tmp->new_cpus, tmp->new_cpus,
+				    cpu_active_mask);
 			cp->nr_subparts_cpus = 0;
 			cpumask_clear(cp->subparts_cpus);
-		} else if (cp->nr_subparts_cpus) {
+		}
+
+		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
+		if (cp->nr_subparts_cpus) {
 			/*
 			 * Make sure that effective_cpus & subparts_cpus
-			 * are mutually exclusive.
-			 *
-			 * In the unlikely event that effective_cpus
-			 * becomes empty. we clear cp->nr_subparts_cpus and
-			 * let its child partition roots to compete for
-			 * CPUs again.
+			 * of a partition root are mutually exclusive.
 			 */
 			cpumask_andnot(cp->effective_cpus, cp->effective_cpus,
 				       cp->subparts_cpus);
-			if (cpumask_empty(cp->effective_cpus)) {
-				cpumask_copy(cp->effective_cpus, tmp->new_cpus);
-				cpumask_clear(cp->subparts_cpus);
-				cp->nr_subparts_cpus = 0;
-			} else if (!cpumask_subset(cp->subparts_cpus,
-						   tmp->new_cpus)) {
-				cpumask_andnot(cp->subparts_cpus,
-					cp->subparts_cpus, tmp->new_cpus);
-				cp->nr_subparts_cpus
-					= cpumask_weight(cp->subparts_cpus);
-			}
+			WARN_ON_ONCE(cpumask_empty(cp->effective_cpus));
 		}
 
 		if (new_prs != old_prs)
@@ -1462,7 +1482,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		spin_unlock_irq(&callback_lock);
 		notify_partition_change(cp, old_prs, new_prs);
 
-		WARN_ON(!is_in_v2_mode() &&
+		WARN_ON_ONCE(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
 		update_tasks_cpumask(cp);
@@ -1585,8 +1605,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Make sure that subparts_cpus is a subset of cpus_allowed.
 	 */
 	if (cs->nr_subparts_cpus) {
-		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
-			       cs->cpus_allowed);
+		cpumask_and(cs->subparts_cpus, cs->subparts_cpus,
+			    cs->cpus_allowed);
 		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
 	}
 	spin_unlock_irq(&callback_lock);
@@ -2008,20 +2028,26 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		}
 	} else {
 		/*
-		 * Turning off partition root will clear the
-		 * CS_CPU_EXCLUSIVE bit.
+		 * Switch back to member is always allowed if PRS_ERROR.
 		 */
 		if (old_prs == PRS_ERROR) {
-			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			err = 0;
-			goto out;
+			goto reset_flag;
 		}
 
+		/*
+		 * A partition root cannot be reverted to member if some
+		 * CPUs have been distributed to child partition roots.
+		 */
+		if (!cpumask_empty(cs->subparts_cpus))
+			return -EBUSY;
+
 		err = update_parent_subparts_cpumask(cs, partcmd_disable,
 						     NULL, &tmpmask);
 		if (err)
 			goto out;
 
+reset_flag:
 		/* Turning off CS_CPU_EXCLUSIVE will not return error */
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 	}
@@ -3103,11 +3129,28 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	/*
 	 * In the unlikely event that a partition root has empty
-	 * effective_cpus or its parent becomes erroneous, we have to
-	 * transition it to the erroneous state.
+	 * effective_cpus, we will have to force any child partitions,
+	 * if present, to become invalid by setting nr_subparts_cpus to 0
+	 * without causing itself to become invalid.
+	 */
+	if (is_partition_root(cs) && cs->nr_subparts_cpus &&
+	    cpumask_empty(&new_cpus)) {
+		cs->nr_subparts_cpus = 0;
+		cpumask_clear(cs->subparts_cpus);
+		compute_effective_cpumask(&new_cpus, cs, parent);
+	}
+
+	/*
+	 * If empty effective_cpus or zero nr_subparts_cpus or its parent
+	 * becomes erroneous, we have to transition it to the erroneous state.
 	 */
 	if (is_partition_root(cs) && (cpumask_empty(&new_cpus) ||
-	   (parent->partition_root_state == PRS_ERROR))) {
+	    (parent->partition_root_state == PRS_ERROR) ||
+	    !parent->nr_subparts_cpus)) {
+		int old_prs;
+
+		update_parent_subparts_cpumask(cs, partcmd_disable,
+					       NULL, tmp);
 		if (cs->nr_subparts_cpus) {
 			spin_lock_irq(&callback_lock);
 			cs->nr_subparts_cpus = 0;
@@ -3116,38 +3159,23 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 			compute_effective_cpumask(&new_cpus, cs, parent);
 		}
 
-		/*
-		 * If the effective_cpus is empty because the child
-		 * partitions take away all the CPUs, we can keep
-		 * the current partition and let the child partitions
-		 * fight for available CPUs.
-		 */
-		if ((parent->partition_root_state == PRS_ERROR) ||
-		     cpumask_empty(&new_cpus)) {
-			int old_prs;
-
-			update_parent_subparts_cpumask(cs, partcmd_disable,
-						       NULL, tmp);
-			old_prs = cs->partition_root_state;
-			if (old_prs != PRS_ERROR) {
-				spin_lock_irq(&callback_lock);
-				cs->partition_root_state = PRS_ERROR;
-				spin_unlock_irq(&callback_lock);
-				notify_partition_change(cs, old_prs, PRS_ERROR);
-			}
+		old_prs = cs->partition_root_state;
+		if (old_prs != PRS_ERROR) {
+			spin_lock_irq(&callback_lock);
+			cs->partition_root_state = PRS_ERROR;
+			spin_unlock_irq(&callback_lock);
+			notify_partition_change(cs, old_prs, PRS_ERROR);
 		}
 		cpuset_force_rebuild();
 	}
 
 	/*
 	 * On the other hand, an erroneous partition root may be transitioned
-	 * back to a regular one or a partition root with no CPU allocated
-	 * from the parent may change to erroneous.
+	 * back to a regular one.
 	 */
-	if (is_partition_root(parent) &&
-	   ((cs->partition_root_state == PRS_ERROR) ||
-	    !cpumask_intersects(&new_cpus, parent->subparts_cpus)) &&
-	     update_parent_subparts_cpumask(cs, partcmd_update, NULL, tmp))
+	else if (is_partition_root(parent) &&
+		(cs->partition_root_state == PRS_ERROR) &&
+		 update_parent_subparts_cpumask(cs, partcmd_update, NULL, tmp))
 		cpuset_force_rebuild();
 
 update_tasks:
-- 
2.18.1

