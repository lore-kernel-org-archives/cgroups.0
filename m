From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup/cpuset: Don't update tasks' cpumasks for cpu offline events
Date: Thu,  2 Feb 2023 09:32:00 -0500
Message-ID: <20230202143200.128753-3-longman@redhat.com>
References: <20230202143200.128753-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675348339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4+oxLjiheAOZOYbU74GypHSVXBNjbH6+0gElb58eD0=;
        b=IsbLE3BPfbFR54UlN1UJDel7bNeWhSny5JMk9aHNfAHXBOg9a68c7jtdNZyia5IbU+ZfmN
        qAvuTfQZ4F0eHtOYUqgCa8ope6ZYapnU1srbb9VAxkC8kqcwS2ArhPk6Cgd4T8H+r/l+bB
        YN18BREkq4fERjzeiq/w0L7s1soAYQs=
In-Reply-To: <20230202143200.128753-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It is a known issue that when a task is in a non-root v1 cpuset, a cpu
offline event will cause that cpu to be lost from the task's cpumask
permanently as the cpuset's cpus_allowed mask won't get back that cpu
when it becomes online again. A possible workaround for this type of
cpu offline/online sequence is to leave the offline cpu in the task's
cpumask and do the update only if new cpus are added. It also has the
benefit of reducing the overhead of a cpu offline event.

Note that the scheduler is able to ignore the offline cpus and so
leaving offline cpus in the cpumask won't do any harm.

Now with v2, only the cpu online events will cause a call to
hotplug_update_tasks() to update the tasks' cpumasks. For tasks
in a non-root v1 cpuset, the situation is a bit different. The cpu
offline event will not cause change to a task's cpumask. Neither does a
subsequent cpu online event because "cpuset.cpus" had that offline cpu
removed and its subsequent onlining won't be registered as a change
to the cpuset. An exception is when all the cpus in the original
"cpuset.cpus" have gone offline once. In that case, "cpuset.cpus" will
become empty which will force task migration to its parent. A task's
cpumask will also be changed if set_cpus_allowed_ptr() is somehow called
for whatever reason.

Of course, this patch can cause a discrepancy between v1's "cpuset.cpus"
and and its tasks' cpumasks. Howver, it can also largely work around
the offline cpu losing problem with v1 cpuset.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cbf749fc05d9..207bafdb05e8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3332,7 +3332,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 static void
 hotplug_update_tasks_legacy(struct cpuset *cs,
 			    struct cpumask *new_cpus, nodemask_t *new_mems,
-			    bool cpus_updated, bool mems_updated)
+			    bool update_task_cpus, bool mems_updated)
 {
 	bool is_empty;
 
@@ -3347,7 +3347,7 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
 	 * as the tasks will be migrated to an ancestor.
 	 */
-	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
+	if (update_task_cpus && !cpumask_empty(cs->cpus_allowed))
 		update_tasks_cpumask(cs);
 	if (mems_updated && !nodes_empty(cs->mems_allowed))
 		update_tasks_nodemask(cs);
@@ -3371,11 +3371,14 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 static void
 hotplug_update_tasks(struct cpuset *cs,
 		     struct cpumask *new_cpus, nodemask_t *new_mems,
-		     bool cpus_updated, bool mems_updated)
+		     bool update_task_cpus, bool mems_updated)
 {
 	/* A partition root is allowed to have empty effective cpus */
-	if (cpumask_empty(new_cpus) && !is_partition_valid(cs))
+	if (cpumask_empty(new_cpus) && !is_partition_valid(cs)) {
 		cpumask_copy(new_cpus, parent_cs(cs)->effective_cpus);
+		update_task_cpus = true;
+	}
+
 	if (nodes_empty(*new_mems))
 		*new_mems = parent_cs(cs)->effective_mems;
 
@@ -3384,7 +3387,7 @@ hotplug_update_tasks(struct cpuset *cs,
 	cs->effective_mems = *new_mems;
 	spin_unlock_irq(&callback_lock);
 
-	if (cpus_updated)
+	if (update_task_cpus)
 		update_tasks_cpumask(cs);
 	if (mems_updated)
 		update_tasks_nodemask(cs);
@@ -3410,7 +3413,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 {
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
-	bool cpus_updated;
+	bool cpus_updated, update_task_cpus;
 	bool mems_updated;
 	struct cpuset *parent;
 retry:
@@ -3512,12 +3515,21 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (mems_updated)
 		check_insane_mems_config(&new_mems);
 
+	/*
+	 * Update tasks' cpumasks only if new cpus are added. Some offline
+	 * cpus may be left, but the scheduler has no problem ignoring those.
+	 * The case of empty new_cpus will be handled inside
+	 * hotplug_update_tasks().
+	 */
+	update_task_cpus = cpus_updated &&
+			   !cpumask_subset(&new_cpus, cs->effective_cpus);
+
 	if (is_in_v2_mode())
 		hotplug_update_tasks(cs, &new_cpus, &new_mems,
-				     cpus_updated, mems_updated);
+				     update_task_cpus, mems_updated);
 	else
 		hotplug_update_tasks_legacy(cs, &new_cpus, &new_mems,
-					    cpus_updated, mems_updated);
+					    update_task_cpus, mems_updated);
 
 unlock:
 	percpu_up_write(&cpuset_rwsem);
-- 
2.31.1

