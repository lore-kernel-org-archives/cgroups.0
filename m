From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cpuacct: Initialize cpuacct subsystem earlier
Date: Thu, 28 Mar 2013 15:21:14 +0800
Message-ID: <5153EF6A.9050906@huawei.com>
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

Initialize cpuacct before the scheduler is functioning, so when
cpuacct_charge() and cpuacct_account_field() are called, task_ca()
won't return NULL.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/cpuacct.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 0425581..75e46d2 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -292,9 +292,10 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 }
 
 struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.css_alloc = cpuacct_css_alloc,
-	.css_free = cpuacct_css_free,
-	.subsys_id = cpuacct_subsys_id,
-	.base_cftypes = files,
+	.name		= "cpuacct",
+	.css_alloc	= cpuacct_css_alloc,
+	.css_free	= cpuacct_css_free,
+	.subsys_id	= cpuacct_subsys_id,
+	.base_cftypes	= files,
+	.early_init	= 1,
 };
-- 
1.8.0.2
