From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/13] cpuset: don't nest cgroup_mutex inside get_online_cpus()
Date: Thu,  3 Jan 2013 13:36:02 -0800
Message-ID: <1357248967-24959-9-git-send-email-tj@kernel.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=AA6OKEi+MiQHfw8DypGwkN2n4D743IDqgx6YxBeYbzk=;
        b=gKRCk4bxA6S//BiNwGHlYI9rKLNIZeKXKnM6DaJjQJo7VYdcQeVLAtNbYRoOQ0BJxM
         BK3ciu+dMoe4Ms0Nu1cs5txxUhQXTIV2o5bLtNyYHpgnwCEkkuSsxDm6QdBwbB60nSAW
         wpRXcwLiYXf6NWmXX87FCI15gdXUx0gkwz8Cp9sNhcgSM+G/dQVt6yMHAZi3ZiFAYaRM
         EIS0lS+JVf/i+hP6rQdyYXZh8er9qxksgdEocFk0l/FOZxrLv3GzcHWDgqy+2hu1jmeQ
         NusYobknMfee4R6+kqXMJbAp9hKNnlVSHUUFoRbNf4xigY6UoIUgbw6BkHrFx72fpmWg
         DVbA==
In-Reply-To: <1357248967-24959-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

CPU / memory hotplug path currently grabs cgroup_mutex from hotplug
event notifications.  We want to separate cpuset locking from cgroup
core and make cgroup_mutex outer to hotplug synchronization so that,
among other things, mechanisms which depend on get_online_cpus() can
be used from cgroup callbacks.  In general, we want to keep
cgroup_mutex the outermost lock to minimize locking interactions among
different controllers.

Convert cpuset_handle_hotplug() to cpuset_hotplug_workfn() and
schedule it from the hotplug notifications.  As the function can
already handle multiple mixed events without any input, converting it
to a work function is mostly trivial; however, one complication is
that cpuset_update_active_cpus() needs to update sched domains
synchronously to reflect an offlined cpu to avoid confusing the
scheduler.  This is worked around by falling back to the the default
single sched domain synchronously before scheduling the actual hotplug
work.  This makes sched domain rebuilt twice per CPU hotplug event but
the operation isn't that heavy and a lot of the second operation would
be noop for systems w/ single sched domain, which is the common case.

This decouples cpuset hotplug handling from the notification callbacks
and there can be an arbitrary delay between the actual event and
updates to cpusets.  Scheduler and mm can handle it fine but moving
tasks out of an empty cpuset may race against writes to the cpuset
restoring execution resources which can lead to confusing behavior.
Flush hotplug work item from cpuset_write_resmask() to avoid such
confusions.

v2: Synchronous sched domain rebuilding using the fallback sched
    domain added.  This fixes various issues caused by confused
    scheduler putting tasks on a dead CPU, including the one reported
    by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d448e6..658eb1a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -260,6 +260,13 @@ static char cpuset_nodelist[CPUSET_NODELIST_LEN];
 static DEFINE_SPINLOCK(cpuset_buffer_lock);
 
 /*
+ * CPU / memory hotplug is handled asynchronously.
+ */
+static void cpuset_hotplug_workfn(struct work_struct *work);
+
+static DECLARE_WORK(cpuset_hotplug_work, cpuset_hotplug_workfn);
+
+/*
  * This is ugly, but preserves the userspace API for existing cpuset
  * users. If someone tries to mount the "cpuset" filesystem, we
  * silently switch it to mount "cgroup" instead
@@ -1565,6 +1572,19 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *trialcs;
 
+	/*
+	 * CPU or memory hotunplug may leave @cs w/o any execution
+	 * resources, in which case the hotplug code asynchronously updates
+	 * configuration and transfers all tasks to the nearest ancestor
+	 * which can execute.
+	 *
+	 * As writes to "cpus" or "mems" may restore @cs's execution
+	 * resources, wait for the previously scheduled operations before
+	 * proceeding, so that we don't end up keep removing tasks added
+	 * after execution capability is restored.
+	 */
+	flush_work(&cpuset_hotplug_work);
+
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
@@ -2095,7 +2115,7 @@ static void cpuset_propagate_hotplug(struct cpuset *cs)
 }
 
 /**
- * cpuset_handle_hotplug - handle CPU/memory hot[un]plug
+ * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
  *
  * This function is called after either CPU or memory configuration has
  * changed and updates cpuset accordingly.  The top_cpuset is always
@@ -2110,7 +2130,7 @@ static void cpuset_propagate_hotplug(struct cpuset *cs)
  * Note that CPU offlining during suspend is ignored.  We don't modify
  * cpusets across suspend/resume cycles at all.
  */
-static void cpuset_handle_hotplug(void)
+static void cpuset_hotplug_workfn(struct work_struct *work)
 {
 	static cpumask_t new_cpus, tmp_cpus;
 	static nodemask_t new_mems, tmp_mems;
@@ -2177,7 +2197,18 @@ static void cpuset_handle_hotplug(void)
 
 void cpuset_update_active_cpus(bool cpu_online)
 {
-	cpuset_handle_hotplug();
+	/*
+	 * We're inside cpu hotplug critical region which usually nests
+	 * inside cgroup synchronization.  Bounce actual hotplug processing
+	 * to a work item to avoid reverse locking order.
+	 *
+	 * We still need to do partition_sched_domains() synchronously;
+	 * otherwise, the scheduler will get confused and put tasks to the
+	 * dead CPU.  Fall back to the default single domain.
+	 * cpuset_hotplug_workfn() will rebuild it as necessary.
+	 */
+	partition_sched_domains(1, NULL, NULL);
+	schedule_work(&cpuset_hotplug_work);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -2189,7 +2220,7 @@ void cpuset_update_active_cpus(bool cpu_online)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	cpuset_handle_hotplug();
+	schedule_work(&cpuset_hotplug_work);
 	return NOTIFY_OK;
 }
 #endif
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
