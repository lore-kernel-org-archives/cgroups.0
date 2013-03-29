From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 1/5] cpuacct: allocate per_cpu cpuusage for root cpuacct
 statically
Date: Fri, 29 Mar 2013 14:43:46 +0800
Message-ID: <51553822.5000403@huawei.com>
References: <51553813.10004@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51553813.10004@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

This is a preparation, so later we can initialize cpuacct earlier.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
