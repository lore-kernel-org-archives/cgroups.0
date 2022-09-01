From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 08/10] cgroup/cpuset: Make partition invalid if cpumask change violates exclusivity rule
Date: Thu,  1 Sep 2022 16:57:43 -0400
Message-ID: <20220901205745.323326-9-longman@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662065907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vcxKMjXClmm1CGJHlAQCcN01M2QmT/+Q6JHJZbXLhs=;
        b=QZW83CsCbShGLoNmmDbUE/FQM0BqB7zed7eLKthuqqLiamito0vBTTfCIJaItBB7CHCQrN
        tiOdOrgJ14uy4iTT+Mynxcmq1uj+3R00PzOjvgr4zBqtAscCQSvHA5wiataCrMbvvFVhgx
        8eV5i+pDOIrzfHYVDCv8Aljp+SCnwZk=
In-Reply-To: <20220901205745.323326-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Currently, changes in "cpust.cpus" of a partition root is not allowed if
it violates the sibling cpu exclusivity rule when the check is done
in the validate_change() function. That is inconsistent with the
other cpuset changes that are always allowed but may make a partition
invalid.

Update the cpuset code to allow cpumask change even if it violates the
sibling cpu exclusivity rule, but invalidate the partition instead
just like the other changes. However, other sibling partitions with
conflicting cpumask will also be invalidated in order to not violating
the exclusivity rule. This behavior is specific to this partition
rule violation.

Note that a previous commit has made sibling cpu exclusivity rule check
the last check of validate_change(). So if -EINVAL is returned, we can
be sure that sibling cpu exclusivity rule violation is the only rule
that is broken.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 69 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b0d921d03f62..6baa977a71ba 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1256,6 +1256,7 @@ enum subparts_cmd {
 	partcmd_enable,		/* Enable partition root	 */
 	partcmd_disable,	/* Disable partition root	 */
 	partcmd_update,		/* Update parent's subparts_cpus */
+	partcmd_invalidate,	/* Make partition invalid	 */
 };
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
@@ -1286,13 +1287,17 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
  * or vice versa. An error code will only be returned if transitioning from
  * invalid to valid violates the exclusivity rule.
  *
+ * For partcmd_invalidate, the current partition will be made invalid.
+ *
  * The partcmd_enable and partcmd_disable commands are used by
  * update_prstate(). An error code may be returned and the caller will check
  * for error.
  *
  * The partcmd_update command is used by update_cpumasks_hier() with newmask
- * NULL and update_cpumask() with newmask set. The callers won't check for
- * error and so partition_root_state and prs_error will be updated directly.
+ * NULL and update_cpumask() with newmask set. The partcmd_invalidate is used
+ * by update_cpumask() with NULL newmask. In both cases, the callers won't
+ * check for error and so partition_root_state and prs_error will be updated
+ * directly.
  */
 static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 					  struct cpumask *newmask,
@@ -1320,7 +1325,8 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		return PERR_CPUSEMPTY;
 
 	/*
-	 * new_prs will only be changed for the partcmd_update command.
+	 * new_prs will only be changed for the partcmd_update and
+	 * partcmd_invalidate commands.
 	 */
 	adding = deleting = false;
 	old_prs = new_prs = cs->partition_root_state;
@@ -1350,6 +1356,20 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		deleting = !is_prs_invalid(old_prs) &&
 			   cpumask_and(tmp->delmask, cs->cpus_allowed,
 				       parent->subparts_cpus);
+	} else if (cmd == partcmd_invalidate) {
+		if (is_prs_invalid(old_prs))
+			return 0;
+
+		/*
+		 * Make the current partition invalid. It is assumed that
+		 * invalidation is caused by violating cpu exclusivity rule.
+		 */
+		deleting = cpumask_and(tmp->delmask, cs->cpus_allowed,
+				       parent->subparts_cpus);
+		if (old_prs > 0) {
+			new_prs = -old_prs;
+			part_error = PERR_NOTEXCL;
+		}
 	} else if (newmask) {
 		/*
 		 * partcmd_update with newmask:
@@ -1403,6 +1423,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 					  parent->cpus_allowed);
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
+
 		if ((is_partition_valid(cs) && !parent->nr_subparts_cpus) ||
 		    (adding &&
 		     cpumask_subset(parent->effective_cpus, tmp->addmask) &&
@@ -1709,6 +1730,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 {
 	int retval;
 	struct tmpmasks tmp;
+	bool invalidate = false;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
 	if (cs == &top_cpuset)
@@ -1736,10 +1758,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
-	retval = validate_change(cs, trialcs);
-	if (retval < 0)
-		return retval;
-
 #ifdef CONFIG_CPUMASK_OFFSTACK
 	/*
 	 * Use the cpumasks in trialcs for tmpmasks when they are pointers
@@ -1750,9 +1768,42 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	tmp.new_cpus = trialcs->cpus_allowed;
 #endif
 
+	retval = validate_change(cs, trialcs);
+
+	if ((retval == -EINVAL) && cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
+		struct cpuset *cp, *parent;
+		struct cgroup_subsys_state *css;
+
+		/*
+		 * The -EINVAL error code indicates that partition sibling
+		 * CPU exclusivity rule has been violated. We still allow
+		 * the cpumask change to proceed while invalidating the
+		 * partition. However, any conflicting sibling partitions
+		 * have to be marked as invalid too.
+		 */
+		invalidate = true;
+		rcu_read_lock();
+		parent = parent_cs(cs);
+		cpuset_for_each_child(cp, css, parent)
+			if (is_partition_valid(cp) &&
+			    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
+				rcu_read_unlock();
+				update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
+				rcu_read_lock();
+			}
+		rcu_read_unlock();
+		retval = 0;
+	}
+	if (retval < 0)
+		return retval;
+
 	if (cs->partition_root_state) {
-		update_parent_subparts_cpumask(cs, partcmd_update,
-					       trialcs->cpus_allowed, &tmp);
+		if (invalidate)
+			update_parent_subparts_cpumask(cs, partcmd_invalidate,
+						       NULL, &tmp);
+		else
+			update_parent_subparts_cpumask(cs, partcmd_update,
+						trialcs->cpus_allowed, &tmp);
 	}
 
 	compute_effective_cpumask(trialcs->effective_cpus, trialcs,
-- 
2.31.1

