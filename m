From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 4/9] cpuset: Allow changes to cpus in a domain root
Date: Mon, 18 Jun 2018 12:14:03 +0800
Message-ID: <1529295249-5207-5-git-send-email-longman@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

The previous patch introduces a new domain_root flag, but won't allow
changes made to "cpuset.cpus" once the flag is on. That may be too
restrictive in some use cases. So this restiction is now relaxed to
allow changes made to the "cpuset.cpus" file with some constraints:

 1) The new set of cpus must still be exclusive.
 2) Newly added cpus must be a subset of the parent effective_cpus.
 3) None of the deleted cpus can be one of those allocated to a child
    domain roots, if present.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 ++++
 kernel/cgroup/cpuset.c                  | 81 ++++++++++++++++++++++++++-------
 2 files changed, 73 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index d5e25a0..5ee5e77 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1617,6 +1617,15 @@ Cpuset Interface Files
 	There must be at least one cpu left in the parent scheduling
 	domain root cgroup.
 
+	In a scheduling domain root, changes to "cpuset.cpus" is allowed
+	as long as the first condition above as well as the following
+	two additional conditions are true.
+
+	1) Any added CPUs must be a proper subset of the parent's
+	   "cpuset.cpus.effective".
+	2) No CPU that has been distributed to child scheduling domain
+	   roots is deleted.
+
 
 Device controller
 -----------------
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a1d5ccd..b1abe3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -957,6 +957,9 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 
 		spin_lock_irq(&callback_lock);
 		cpumask_copy(cp->effective_cpus, new_cpus);
+		if (cp->nr_reserved)
+			cpumask_andnot(cp->effective_cpus, cp->effective_cpus,
+				       cp->reserved_cpus);
 		spin_unlock_irq(&callback_lock);
 
 		WARN_ON(!is_in_v2_mode() &&
@@ -984,24 +987,26 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 /**
  * update_reserved_cpumask - update the reserved_cpus mask of parent cpuset
  * @cpuset:  The cpuset that requests CPU reservation
- * @delmask: The old reserved cpumask to be removed from the parent
- * @addmask: The new reserved cpumask to be added to the parent
+ * @oldmask: The old reserved cpumask to be removed from the parent
+ * @newmask: The new reserved cpumask to be added to the parent
  * Return: 0 if successful, an error code otherwise
  *
  * Changes to the reserved CPUs are not allowed if any of CPUs changing
  * state are in any of the child cpusets of the parent except the requesting
  * child.
  *
- * If the sched_domain_root flag changes, either the delmask (0=>1) or the
- * addmask (1=>0) will be NULL.
+ * If the sched_domain_root flag changes, either the oldmask (0=>1) or the
+ * newmask (1=>0) will be NULL.
  *
  * Called with cpuset_mutex held. Some of the checks are skipped if the
  * cpuset is being offlined (dying).
  */
 static int update_reserved_cpumask(struct cpuset *cpuset,
-	struct cpumask *delmask, struct cpumask *addmask)
+	struct cpumask *oldmask, struct cpumask *newmask)
 {
 	int retval;
+	int adding, deleting;
+	cpumask_var_t addmask, delmask;
 	struct cpuset *parent = parent_cs(cpuset);
 	struct cpuset *sibling;
 	struct cgroup_subsys_state *pos_css;
@@ -1013,15 +1018,15 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	 * The new cpumask, if present, must not be empty.
 	 */
 	if (!is_sched_domain_root(parent) ||
-	   (addmask && cpumask_empty(addmask)))
+	   (newmask && cpumask_empty(newmask)))
 		return -EINVAL;
 
 	/*
-	 * The delmask, if present, must be a subset of parent's reserved
+	 * The oldmask, if present, must be a subset of parent's reserved
 	 * CPUs.
 	 */
-	if (delmask && !cpumask_empty(delmask) && (!parent->nr_reserved ||
-		       !cpumask_subset(delmask, parent->reserved_cpus))) {
+	if (oldmask && !cpumask_empty(oldmask) && (!parent->nr_reserved ||
+		       !cpumask_subset(oldmask, parent->reserved_cpus))) {
 		WARN_ON_ONCE(1);
 		return -EINVAL;
 	}
@@ -1030,9 +1035,17 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	 * A sched_domain_root state change is not allowed if there are
 	 * online children and the cpuset is not dying.
 	 */
-	if (!dying && css_has_online_children(&cpuset->css))
+	if (!dying && (!oldmask || !newmask) &&
+	    css_has_online_children(&cpuset->css))
 		return -EBUSY;
 
+	if (!zalloc_cpumask_var(&addmask, GFP_KERNEL))
+		return -ENOMEM;
+	if (!zalloc_cpumask_var(&delmask, GFP_KERNEL)) {
+		free_cpumask_var(addmask);
+		return -ENOMEM;
+	}
+
 	if (!old_count) {
 		if (!zalloc_cpumask_var(&parent->reserved_cpus, GFP_KERNEL)) {
 			retval = -ENOMEM;
@@ -1042,12 +1055,29 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	}
 
 	retval = -EBUSY;
+	adding = deleting = false;
+	/*
+	 * addmask = newmask & ~oldmask
+	 * delmask = oldmask & ~newmask
+	 */
+	if (oldmask && newmask) {
+		adding   = cpumask_andnot(addmask, newmask, oldmask);
+		deleting = cpumask_andnot(delmask, oldmask, newmask);
+		if (!adding && !deleting)
+			goto out_ok;
+	} else if (newmask) {
+		adding = true;
+		cpumask_copy(addmask, newmask);
+	} else if (oldmask) {
+		deleting = true;
+		cpumask_copy(delmask, oldmask);
+	}
 
 	/*
 	 * The cpus to be added must be a proper subset of the parent's
 	 * effective_cpus mask but not in the reserved_cpus mask.
 	 */
-	if (addmask) {
+	if (adding) {
 		if (!cpumask_subset(addmask, parent->effective_cpus) ||
 		     cpumask_equal(addmask, parent->effective_cpus))
 			goto out;
@@ -1057,6 +1087,15 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	}
 
 	/*
+	 * For cpu changes in a domain root, cpu deletion isn't allowed
+	 * if any of the deleted CPUs is in reserved_cpus (distributed
+	 * to child domain roots).
+	 */
+	if (oldmask && newmask && cpuset->nr_reserved && deleting &&
+	    cpumask_intersects(delmask, cpuset->reserved_cpus))
+		goto out;
+
+	/*
 	 * Check if any CPUs in addmask or delmask are in the effective_cpus
 	 * of a sibling cpuset. The implied cpu_exclusive of a scheduling
 	 * domain root will ensure there are no overlap in cpus_allowed.
@@ -1070,10 +1109,10 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	cpuset_for_each_child(sibling, pos_css, parent) {
 		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
 			continue;
-		if (addmask &&
+		if (adding &&
 		    cpumask_intersects(sibling->effective_cpus, addmask))
 			goto out_unlock;
-		if (delmask &&
+		if (deleting &&
 		    cpumask_intersects(sibling->effective_cpus, delmask))
 			goto out_unlock;
 	}
@@ -1086,13 +1125,13 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	 */
 updated_reserved_cpus:
 	spin_lock_irq(&callback_lock);
-	if (addmask) {
+	if (adding) {
 		cpumask_or(parent->reserved_cpus,
 			   parent->reserved_cpus, addmask);
 		cpumask_andnot(parent->effective_cpus,
 			       parent->effective_cpus, addmask);
 	}
-	if (delmask) {
+	if (deleting) {
 		cpumask_andnot(parent->reserved_cpus,
 			       parent->reserved_cpus, delmask);
 		cpumask_or(parent->effective_cpus,
@@ -1101,8 +1140,12 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 
 	parent->nr_reserved = cpumask_weight(parent->reserved_cpus);
 	spin_unlock_irq(&callback_lock);
+
+out_ok:
 	retval = 0;
 out:
+	free_cpumask_var(addmask);
+	free_cpumask_var(delmask);
 	if (old_count && !parent->nr_reserved)
 		free_cpumask_var(parent->reserved_cpus);
 
@@ -1154,8 +1197,12 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
-	if (is_sched_domain_root(cs))
-		return -EBUSY;
+	if (is_sched_domain_root(cs)) {
+		retval = update_reserved_cpumask(cs, cs->cpus_allowed,
+						 trialcs->cpus_allowed);
+		if (retval < 0)
+			return retval;
+	}
 
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
-- 
1.8.3.1

