From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] cpuacct: Introduce cgroup_account_cputime[_field]()
Date: Fri, 11 Aug 2017 09:37:53 -0700
Message-ID: <20170811163754.3939102-3-tj@kernel.org>
References: <20170811163754.3939102-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/rEiX6OoKDJNT1FGzsbHIer/w2Lw3mEZh3h1F3LVj8Y=;
        b=hGo+vs4l6wA8dAHUzLS3N0ql7IGZB9ggjqXeQfVWRKOTHZ0CXoOfLTpNwHuWI44xcc
         wfiAbqtfzTHz9XABzkhzK8Zqqbs3TzEvDhaD3ffulu5wfVTKC7N+jOOr+mNlqV9z9W8Y
         PGGKcyqS+AAdzLkYL7TNrXxzhJa9/iuRMrSlyutiQP2IsuYybQevrjB8HxtAy0sHxViF
         PMoLMmg4CKOQlNk4/+F+XdmtOL+mMcMJxHLC2e79rT1rBFNSU6b6MOMykWlK6mCZvuPM
         GlKENy/zytBSDRhSjbUX7m8INEONWYUFQxP3xRVDq2KW/kl6SMRp/Ln6YBXI+3BrZNqi
         2+KQ==
In-Reply-To: <20170811163754.3939102-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Introduce cgroup_account_cputime[_field]() which wrap cpuacct_charge()
and cgroup_account_field().  This doesn't introduce any functional
changes and will be used to add cgroup basic resource accounting.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 include/linux/cgroup.h   | 38 ++++++++++++++++++++++++++++++++++++++
 kernel/sched/cpuacct.h   | 17 -----------------
 kernel/sched/cputime.c   |  2 +-
 kernel/sched/deadline.c  |  2 +-
 kernel/sched/fair.c      |  2 +-
 kernel/sched/rt.c        |  2 +-
 kernel/sched/sched.h     |  1 -
 kernel/sched/stop_task.c |  2 +-
 8 files changed, 43 insertions(+), 23 deletions(-)
 delete mode 100644 kernel/sched/cpuacct.h

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 085056e..f395e02 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -22,6 +22,7 @@
 #include <linux/nsproxy.h>
 #include <linux/user_namespace.h>
 #include <linux/refcount.h>
+#include <linux/kernel_stat.h>
 
 #include <linux/cgroup-defs.h>
 
@@ -675,6 +676,43 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 #endif /* !CONFIG_CGROUPS */
 
 /*
+ * Basic resource stats.
+ */
+#ifdef CONFIG_CGROUPS
+
+#ifdef CONFIG_CGROUP_CPUACCT
+void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
+#else
+static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static inline void cpuacct_account_field(struct task_struct *tsk, int index,
+					 u64 val) {}
+#endif
+
+static inline void cgroup_account_cputime(struct task_struct *task,
+					  u64 delta_exec)
+{
+	cpuacct_charge(task, delta_exec);
+}
+
+static inline void cgroup_account_cputime_field(struct task_struct *task,
+						enum cpu_usage_stat index,
+						u64 delta_exec)
+{
+	cpuacct_account_field(task, index, delta_exec);
+}
+
+#else	/* CONFIG_CGROUPS */
+
+static inline void cgroup_account_cputime(struct task_struct *task,
+					  u64 delta_exec) {}
+static inline void cgroup_account_cputime_field(struct task_struct *task,
+						enum cpu_usage_stat index,
+						u64 delta_exec) {}
+
+#endif	/* CONFIG_CGROUPS */
+
+/*
  * sock->sk_cgrp_data handling.  For more info, see sock_cgroup_data
  * definition in cgroup-defs.h.
  */
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
deleted file mode 100644
index ba72807..0000000
--- a/kernel/sched/cpuacct.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifdef CONFIG_CGROUP_CPUACCT
-
-extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
-extern void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
-
-#else
-
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
-{
-}
-
-static inline void
-cpuacct_account_field(struct task_struct *tsk, int index, u64 val)
-{
-}
-
-#endif
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3a8bfcc..d13149d 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -109,7 +109,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 */
 	__this_cpu_add(kernel_cpustat.cpustat[index], tmp);
 
-	cpuacct_account_field(p, index, tmp);
+	cgroup_account_cputime_field(p, index, tmp);
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a84299f..4d5119f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1145,7 +1145,7 @@ static void update_curr_dl(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cgroup_account_cputime(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c95880e..9b2e0b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -864,7 +864,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
-		cpuacct_charge(curtask, delta_exec);
+		cgroup_account_cputime(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 45caf93..ed6e95d 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -979,7 +979,7 @@ static void update_curr_rt(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cgroup_account_cputime(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eeef1a3..35812d779 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -36,7 +36,6 @@
 
 #include "cpupri.h"
 #include "cpudeadline.h"
-#include "cpuacct.h"
 
 #ifdef CONFIG_SCHED_DEBUG
 # define SCHED_WARN_ON(x)	WARN_ONCE(x, #x)
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 9f69fb6..ec0bb5a 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -71,7 +71,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cgroup_account_cputime(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
-- 
2.9.3
