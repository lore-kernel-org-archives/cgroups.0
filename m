From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/5] cpuacct: Initialize root cpuacct earlier
Date: Fri, 29 Mar 2013 14:44:04 +0800
Message-ID: <51553834.9090701@huawei.com>
References: <51553813.10004@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51553813.10004-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Now we don't need cpuacct_init(), and instead we just initialize
root_cpuacct when it's defined.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c    |  2 --
 kernel/sched/cpuacct.c | 11 ++++-------
 kernel/sched/cpuacct.h |  5 -----
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7016c1..5338e6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6936,8 +6936,6 @@ void __init sched_init(void)
 
 #endif /* CONFIG_CGROUP_SCHED */
 
-	cpuacct_init();
-
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index a691c4d..0425581 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -59,7 +59,10 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 }
 
 static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
-static struct cpuacct root_cpuacct;
+static struct cpuacct root_cpuacct = {
+	.cpustat	= &kernel_cpustat,
+	.cpuusage	= &root_cpuacct_cpuusage,
+};
 
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
@@ -288,12 +291,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 	rcu_read_unlock();
 }
 
-void __init cpuacct_init(void)
-{
-	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = &root_cpuacct_cpuusage;
-}
-
 struct cgroup_subsys cpuacct_subsys = {
 	.name = "cpuacct",
 	.css_alloc = cpuacct_css_alloc,
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index 51cd76e..ed60562 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -1,15 +1,10 @@
 #ifdef CONFIG_CGROUP_CPUACCT
 
-extern void cpuacct_init(void);
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
 
 #else
 
-static inline void cpuacct_init(void)
-{
-}
-
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 }
-- 
1.8.0.2
