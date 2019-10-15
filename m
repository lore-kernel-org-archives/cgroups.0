From: Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH v3 2/2] sched/topology: Allow sched_asym_cpucapacity to be disabled
Date: Tue, 15 Oct 2019 16:42:50 +0100
Message-ID: <20191015154250.12951-3-valentin.schneider@arm.com>
References: <20191015154250.12951-1-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191015154250.12951-1-valentin.schneider@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com, stable@vger.kernel.org

While the static key is correctly initialized as being disabled, it will
remain forever enabled once turned on. This means that if we start with an
asymmetric system and hotplug out enough CPUs to end up with an SMP system,
the static key will remain set - which is obviously wrong. We should detect
this and turn off things like misfit migration and capacity aware wakeups.

As Quentin pointed out, having separate root domains makes this slightly
trickier. We could have exclusive cpusets that create an SMP island - IOW,
the domains within this root domain will not see any asymmetry. This means
we need to count how many asymmetric root domains we have.

Change the simple key enablement to an increment, and decrement the key
counter when destroying domains that cover asymmetric CPUs.

Cc: <stable@vger.kernel.org>
Fixes: df054e8445a4 ("sched/topology: Add static_key for asymmetric CPU capacity optimizations")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
---
 kernel/sched/topology.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 9318acf1d1fe..f0e730143380 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2029,7 +2029,7 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	rcu_read_unlock();
 
 	if (has_asym)
-		static_branch_enable_cpuslocked(&sched_asym_cpucapacity);
+		static_branch_inc_cpuslocked(&sched_asym_cpucapacity);
 
 	if (rq && sched_debug_enabled) {
 		pr_info("root domain span: %*pbl (max cpu_capacity = %lu)\n",
@@ -2125,7 +2125,10 @@ int sched_init_domains(const struct cpumask *cpu_map)
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
 	int i;
+	unsigned int cpu = cpumask_any(cpu_map);
+
+	if (rcu_access_pointer(per_cpu(sd_asym_cpucapacity, cpu)))
+		static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
 
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
--
2.22.0

