From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cpuacct: Allocate per_cpu cpuusage for root cpuacct statically
Date: Thu, 28 Mar 2013 15:20:41 +0800
Message-ID: <5153EF49.5040502@huawei.com>
References: <5153EF24.3040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5153EF24.3040608-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This is a preparation, so later we can initialize cpuacct earlier.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/cpuacct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9305fd2..a691c4d 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -58,6 +58,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return cgroup_ca(ca->css.cgroup->parent);
 }
 
+static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct;
 
 /* create a new cpu accounting group */
@@ -290,8 +291,7 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 void __init cpuacct_init(void)
 {
 	root_cpuacct.cpustat = &kernel_cpustat;
-	root_cpuacct.cpuusage = alloc_percpu(u64);
-	BUG_ON(!root_cpuacct.cpuusage); /* Too early, not expected to fail */
+	root_cpuacct.cpuusage = &root_cpuacct_cpuusage;
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-- 
1.8.0.2
