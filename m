From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 8/8] sched: don't queue timers on quiesced CPUs
Date: Fri,  4 Apr 2014 14:05:35 +0530
Message-ID: <3fefafdf2d06b1d6ecc0e2cbb6f860f6c8cd8df2.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org, Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

CPUSets have cpusets.quiesce sysfs file now, with which some CPUs can opt for
isolating themselves from background kernel activities, like: timers & hrtimers.

get_nohz_timer_target() is used for finding suitable CPU for firing a timer. To
guarantee that new timers wouldn't be queued on quiesced CPUs, we need to modify
this routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0339e2..b235af2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -557,17 +557,18 @@ void resched_cpu(int cpu)
  */
 int get_nohz_timer_target(int pinned)
 {
-	int cpu = smp_processor_id();
-	int i;
+	int cpu = smp_processor_id(), i;
 	struct sched_domain *sd;
 
-	if (pinned || !get_sysctl_timer_migration() || !idle_cpu(cpu))
+	if (pinned || !get_sysctl_timer_migration() ||
+	    !(idle_cpu(cpu) || cpu_quiesced(cpu)))
 		return cpu;
 
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		for_each_cpu(i, sched_domain_span(sd)) {
-			if (!idle_cpu(i)) {
+			/* Don't push timers to quiesced CPUs */
+			if (!(cpu_quiesced(i) || idle_cpu(i))) {
 				cpu = i;
 				goto unlock;
 			}
-- 
1.7.12.rc2.18.g61b472e
