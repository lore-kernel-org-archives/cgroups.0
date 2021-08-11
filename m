From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 1/6] cgroup/cpuset: Enable event notification when partition state changes
Date: Tue, 10 Aug 2021 23:06:02 -0400
Message-ID: <20210811030607.13824-2-longman@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628651205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rxmUDgi/eSAWBp+aX5tEZpY9hepwTSXrcnetuW0lBu8=;
        b=TcGoTsS+EMliZJRf4cQkAnhvOB97Z5AQTFPH/prk7Q374QYVfKvs/iMPPFX/22yAuzHgaR
        Bonq+69fmr+JMp2sg6FnWrvhdZcbHvnw+qfVH61rbXD+Z6tRgofjyflK/XXUWvloH/NubE
        +2HTWZ86YpiUqn2Im6JZiAs+KJ049yI=
In-Reply-To: <20210811030607.13824-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

A valid cpuset partition can become invalid if all its CPUs are offlined
or somehow removed. This can happen through external events without
"cpuset.cpus.partition" being touched at all.

Users that rely on the property of a partition being present do not
currently have a simple way to get such an event notified other than
constant periodic polling which is both inefficient and cumbersome.

To make life easier for those users, event notification is now enabled
for "cpuset.cpus.partition" whenever its state changes.

Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 46 ++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 65258102e030..fcc11f2d3b5b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -160,6 +160,9 @@ struct cpuset {
 	 */
 	int use_parent_ecpus;
 	int child_ecpus_count;
+
+	/* Handle for cpuset.cpus.partition */
+	struct cgroup_file partition_file;
 };
 
 /*
@@ -263,6 +266,16 @@ static inline int is_partition_root(const struct cpuset *cs)
 	return cs->partition_root_state > 0;
 }
 
+/*
+ * Send notification event of whenever partition_root_state changes.
+ */
+static inline void notify_partition_change(struct cpuset *cs,
+					   int old_prs, int new_prs)
+{
+	if (old_prs != new_prs)
+		cgroup_file_notify(&cs->partition_file);
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
 		  (1 << CS_MEM_EXCLUSIVE)),
@@ -1148,7 +1161,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	struct cpuset *parent = parent_cs(cpuset);
 	int adding;	/* Moving cpus from effective_cpus to subparts_cpus */
 	int deleting;	/* Moving cpus from subparts_cpus to effective_cpus */
-	int new_prs;
+	int old_prs, new_prs;
 	bool part_error = false;	/* Partition error? */
 
 	percpu_rwsem_assert_held(&cpuset_rwsem);
@@ -1184,7 +1197,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 	 * A cpumask update cannot make parent's effective_cpus become empty.
 	 */
 	adding = deleting = false;
-	new_prs = cpuset->partition_root_state;
+	old_prs = new_prs = cpuset->partition_root_state;
 	if (cmd == partcmd_enable) {
 		cpumask_copy(tmp->addmask, cpuset->cpus_allowed);
 		adding = true;
@@ -1274,7 +1287,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 				       parent->subparts_cpus);
 	}
 
-	if (!adding && !deleting && (new_prs == cpuset->partition_root_state))
+	if (!adding && !deleting && (new_prs == old_prs))
 		return 0;
 
 	/*
@@ -1302,9 +1315,11 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 
 	parent->nr_subparts_cpus = cpumask_weight(parent->subparts_cpus);
 
-	if (cpuset->partition_root_state != new_prs)
+	if (old_prs != new_prs)
 		cpuset->partition_root_state = new_prs;
+
 	spin_unlock_irq(&callback_lock);
+	notify_partition_change(cpuset, old_prs, new_prs);
 
 	return cmd == partcmd_update;
 }
@@ -1326,7 +1341,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 	bool need_rebuild_sched_domains = false;
-	int new_prs;
+	int old_prs, new_prs;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -1366,8 +1381,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 		 * update_tasks_cpumask() again for tasks in the parent
 		 * cpuset if the parent's subparts_cpus changes.
 		 */
-		new_prs = cp->partition_root_state;
-		if ((cp != cs) && new_prs) {
+		old_prs = new_prs = cp->partition_root_state;
+		if ((cp != cs) && old_prs) {
 			switch (parent->partition_root_state) {
 			case PRS_DISABLED:
 				/*
@@ -1438,10 +1453,11 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 			}
 		}
 
-		if (new_prs != cp->partition_root_state)
+		if (new_prs != old_prs)
 			cp->partition_root_state = new_prs;
 
 		spin_unlock_irq(&callback_lock);
+		notify_partition_change(cp, old_prs, new_prs);
 
 		WARN_ON(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
@@ -2023,6 +2039,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		spin_lock_irq(&callback_lock);
 		cs->partition_root_state = new_prs;
 		spin_unlock_irq(&callback_lock);
+		notify_partition_change(cs, old_prs, new_prs);
 	}
 
 	free_cpumasks(NULL, &tmpmask);
@@ -2708,6 +2725,7 @@ static struct cftype dfl_files[] = {
 		.write = sched_partition_write,
 		.private = FILE_PARTITION_ROOT,
 		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct cpuset, partition_file),
 	},
 
 	{
@@ -3103,11 +3121,17 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 		 */
 		if ((parent->partition_root_state == PRS_ERROR) ||
 		     cpumask_empty(&new_cpus)) {
+			int old_prs;
+
 			update_parent_subparts_cpumask(cs, partcmd_disable,
 						       NULL, tmp);
-			spin_lock_irq(&callback_lock);
-			cs->partition_root_state = PRS_ERROR;
-			spin_unlock_irq(&callback_lock);
+			old_prs = cs->partition_root_state;
+			if (old_prs != PRS_ERROR) {
+				spin_lock_irq(&callback_lock);
+				cs->partition_root_state = PRS_ERROR;
+				spin_unlock_irq(&callback_lock);
+				notify_partition_change(cs, old_prs, PRS_ERROR);
+			}
 		}
 		cpuset_force_rebuild();
 	}
-- 
2.18.1

