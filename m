From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 3/8] memcg: Allow the use of task RSS memory as over-high action trigger
Date: Mon, 17 Aug 2020 10:08:26 -0400
Message-ID: <20200817140831.30260-4-longman@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597673399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=BkHtKKuY3b6GbgQQuDgz6i1v5ZDG8cyA2U/RRbTyPVc=;
        b=LKwFOckCMrQkGgjJ4ba/cVuje05HGNboCl2WMZUmy2V7q+5eUxX/Iw5tS8fT11KYQhbPFr
        0sUu6yYbBnlLAgchNobPaSBpNHB2lMdNIa1oWZJnBuaFo8zTbvr9BTaWityeLbQzQjsMNI
        A0HUv5PSoFVFu0fNuE1ZAjKHy+uvQXE=
In-Reply-To: <20200817140831.30260-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The total memory consumption of a task as tracked by memory cgroup
includes different types of memory like page caches, anonymous memory,
share memory and kernel memory.

In a memory cgroup with a multiple running tasks, using total memory
consumption of all the tasks within the cgroup as action trigger may
not be fair to tasks that don't contribute to excessive memory usage.

Page cache memory can typically be shared between multiple tasks. It
is also not easy to pin kernel memory usage to a specific task. That
leaves a task's anonymous (RSS) memory usage as best proxy for a task's
contribution to total memory consumption within the memory cgroup.

So a new set of PR_MEMFLAG_RSS_* flags are added to enable the checking
of a task's real RSS memory footprint as a trigger to over-high action
provided that the total memory consumption of the cgroup has exceeded
memory.high + the additional memcg memory limit.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |  2 +-
 include/linux/sched.h      |  3 ++-
 include/uapi/linux/prctl.h | 14 +++++++++++---
 kernel/sys.c               |  4 ++--
 mm/memcontrol.c            | 32 ++++++++++++++++++++++++++++++--
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 40e6ceb8209b..562958cf79d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -447,7 +447,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
 long mem_cgroup_over_high_get(struct task_struct *task, unsigned long item);
 long mem_cgroup_over_high_set(struct task_struct *task, unsigned long action,
-			      unsigned long limit);
+			      unsigned long limit, unsigned long limit2);
 
 static struct mem_cgroup_per_node *
 mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ec1bd072334..a1e9ac8b9b16 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1265,11 +1265,12 @@ struct task_struct {
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
 
-	/* Memory over-high action, flags, signal and limit */
+	/* Memory over-high action, flags, signal and limits */
 	unsigned char			memcg_over_high_action;
 	unsigned char			memcg_over_high_signal;
 	unsigned short			memcg_over_high_flags;
 	unsigned int			memcg_over_high_climit;
+	unsigned int			memcg_over_high_plimit;
 	unsigned int			memcg_over_limit;
 
 	/* Used by memcontrol for targeted memcg charge: */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 87970ae7b32c..ef8d84c94b4a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -244,9 +244,10 @@ struct prctl_mm_map {
 
 /*
  * PR_SET_MEMCONTROL:
- * 2 parameters are passed:
+ * 3 parameters are passed:
  *  - Action word
  *  - Memory cgroup additional memory limit
+ *  - Flag specific memory limit
  *
  * The action word consists of 3 bit fields:
  *  - Bits  0-7 : over-memory-limit action code
@@ -263,8 +264,14 @@ struct prctl_mm_map {
 # define PR_MEMACT_MAX			PR_MEMACT_KILL
 
 /* Flags for PR_SET_MEMCONTROL */
-# define PR_MEMFLAG_SIGCONT		(1UL << 0) /* Continuous signal delivery */
-# define PR_MEMFLAG_MASK		PR_MEMFLAG_SIGCONT
+# define PR_MEMFLAG_SIGCONT		(1UL <<  0) /* Continuous signal delivery */
+# define PR_MEMFLAG_RSS_ANON		(1UL <<  8) /* Check anonymous pages */
+# define PR_MEMFLAG_RSS_FILE		(1UL <<  9) /* Check file pages */
+# define PR_MEMFLAG_RSS_SHMEM		(1UL << 10) /* Check shmem pages */
+# define PR_MEMFLAG_RSS			(PR_MEMFLAG_RSS_ANON |\
+					 PR_MEMFLAG_RSS_FILE |\
+					 PR_MEMFLAG_RSS_SHMEM)
+# define PR_MEMFLAG_MASK		(PR_MEMFLAG_SIGCONT | PR_MEMFLAG_RSS)
 
 /* Action word masks */
 # define PR_MEMACT_MASK			0xff
@@ -274,5 +281,6 @@ struct prctl_mm_map {
 /* Return specified value for PR_GET_MEMCONTROL */
 # define PR_MEMGET_ACTION		0
 # define PR_MEMGET_CLIMIT		1
+# define PR_MEMGET_PLIMIT		2
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 644b86235d7f..272f82227c2d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2541,9 +2541,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		error = mem_cgroup_over_high_get(me, arg2);
 		break;
 	case PR_SET_MEMCONTROL:
-		if (arg4 || arg5)
+		if (arg5)
 			return -EINVAL;
-		error = mem_cgroup_over_high_set(me, arg2, arg3);
+		error = mem_cgroup_over_high_set(me, arg2, arg3, arg4);
 		break;
 #endif
 	default:
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5cad7bb26d13..aa76bae7f408 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2629,6 +2629,12 @@ void mem_cgroup_handle_over_high(void)
 	css_put(&memcg->css);
 }
 
+static inline unsigned long
+get_rss_counter(struct mm_struct *mm, int mm_bit, u16 flags, int rss_bit)
+{
+	return (flags & rss_bit) ? get_mm_counter(mm, mm_bit) : 0;
+}
+
 /*
  * Task specific action when over the high limit.
  * Return true if an action has been taken or further check is not needed,
@@ -2656,6 +2662,22 @@ static bool __mem_cgroup_over_high_action(struct mem_cgroup *memcg, u8 action)
 	if (mem <= memcg->memory.high + limit)
 		goto out;
 
+	/*
+	 * Check RSS memory if any of the PR_MEMFLAG_RSS flags is set.
+	 */
+	if (flags & PR_MEMFLAG_RSS) {
+		mem = get_rss_counter(mm, MM_ANONPAGES, flags,
+				      PR_MEMFLAG_RSS_ANON) +
+		      get_rss_counter(mm, MM_FILEPAGES, flags,
+				      PR_MEMFLAG_RSS_FILE) +
+		      get_rss_counter(mm, MM_SHMEMPAGES, flags,
+				      PR_MEMFLAG_RSS_SHMEM);
+
+		limit = READ_ONCE(current->memcg_over_high_plimit);
+		if (mem <= limit)
+			goto out;
+	}
+
 	ret = true;
 	switch (action) {
 	case PR_MEMACT_ENOMEM:
@@ -7063,12 +7085,15 @@ long mem_cgroup_over_high_get(struct task_struct *task, unsigned long item)
 
 	case PR_MEMGET_CLIMIT:
 		return (long)task->memcg_over_high_climit * PAGE_SIZE;
+
+	case PR_MEMGET_PLIMIT:
+		return (long)task->memcg_over_high_plimit * PAGE_SIZE;
 	}
 	return -EINVAL;
 }
 
 long mem_cgroup_over_high_set(struct task_struct *task, unsigned long action,
-			      unsigned long limit)
+			      unsigned long limit, unsigned long limit2)
 {
 	unsigned char  cmd   = action & PR_MEMACT_MASK;
 	unsigned char  sig   = (action >> PR_MEMACT_SIG_SHIFT) & PR_MEMACT_MASK;
@@ -7084,12 +7109,15 @@ long mem_cgroup_over_high_set(struct task_struct *task, unsigned long action,
 
 	if (cmd == PR_MEMACT_NONE) {
 		WRITE_ONCE(task->memcg_over_high_climit, 0);
+		WRITE_ONCE(task->memcg_over_high_plimit, 0);
 	} else {
 		/*
 		 * Convert limits to # of pages
 		 */
-		limit = DIV_ROUND_UP(limit, PAGE_SIZE);
+		limit  = DIV_ROUND_UP(limit, PAGE_SIZE);
+		limit2 = DIV_ROUND_UP(limit2, PAGE_SIZE);
 		WRITE_ONCE(task->memcg_over_high_climit, limit);
+		WRITE_ONCE(task->memcg_over_high_plimit, limit2);
 	}
 	return 0;
 }
-- 
2.18.1

