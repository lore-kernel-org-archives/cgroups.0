From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 4/5] cpuacct: No need to check subsys active state
Date: Thu, 28 Mar 2013 15:21:31 +0800
Message-ID: <5153EF7B.1020403@huawei.com>
References: <5153EF24.3040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5153EF24.3040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Now we're guaranteed when cpuacct_charge() and cpuacct_account_field()
are called, cpuacct has already been properly initialized, so we no
longer need those checks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/sched/cpuacct.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 75e46d2..ef57ab6 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -247,9 +247,6 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	struct cpuacct *ca;
 	int cpu;
 
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
 	cpu = task_cpu(tsk);
 
 	rcu_read_lock();
@@ -278,9 +275,6 @@ void cpuacct_account_field(struct task_struct *p, int index, u64 val)
 	struct kernel_cpustat *kcpustat;
 	struct cpuacct *ca;
 
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
 	rcu_read_lock();
 	ca = task_ca(p);
 	while (ca != &root_cpuacct) {
-- 
1.8.0.2
