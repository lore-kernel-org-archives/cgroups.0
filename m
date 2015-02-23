From: riel@redhat.com
Subject: [PATCH 1/2] cpusets,isolcpus: exclude isolcpus from load balancing in cpusets
Date: Mon, 23 Feb 2015 16:45:05 -0500
Message-ID: <1424727906-4460-2-git-send-email-riel@redhat.com>
References: <1424727906-4460-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424727906-4460-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, cgroups@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Ensure that cpus specified with the isolcpus= boot commandline
option stay outside of the load balancing in the kernel scheduler.

Operations like load balancing can introduce unwanted latencies,
which is exactly what the isolcpus= commandline is there to prevent.

Previously, simply creating a new cpuset, without even touching the
cpuset.cpus field inside the new cpuset, would undo the effects of
isolcpus=, by creating a scheduler domain spanning the whole system,
and setting up load balancing inside that domain. The cpuset root
cpuset.cpus file is read-only, so there was not even a way to undo
that effect.

This does not impact the majority of cpusets users, since isolcpus=
is a fairly specialized feature used for realtime purposes.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 13 +++++++++++--
 kernel/sched/core.c   |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cb5cdc777c8a..af1b32a5ddcc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1038,6 +1038,8 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
 
+extern cpumask_var_t cpu_isolated_map;
+
 /* Allocate an array of sched domains, for partition_sched_domains(). */
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b257f6bca2..1ad63fa37cb4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -625,6 +625,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_var_t *doms;	/* resulting partition; i.e. sched domains */
+	cpumask_var_t non_isolated_cpus;  /* load balanced CPUs */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] struct cpumask slot */
@@ -634,6 +635,10 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	dattr = NULL;
 	csa = NULL;
 
+	if (!alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL))
+		goto done;
+	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
+
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
 		ndoms = 1;
@@ -646,7 +651,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms[0], top_cpuset.effective_cpus);
+		cpumask_and(doms[0], top_cpuset.effective_cpus,
+				     non_isolated_cpus);
 
 		goto done;
 	}
@@ -669,7 +675,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		 * the corresponding sched domain.
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
-		    !is_sched_load_balance(cp))
+		    !(is_sched_load_balance(cp) &&
+		      cpumask_intersects(cp->cpus_allowed, non_isolated_cpus)))
 			continue;
 
 		if (is_sched_load_balance(cp))
@@ -751,6 +758,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 
 			if (apn == b->pn) {
 				cpumask_or(dp, dp, b->effective_cpus);
+				cpumask_and(dp, dp, non_isolated_cpus);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -763,6 +771,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	BUG_ON(nslot != ndoms);
 
 done:
+	free_cpumask_var(non_isolated_cpus);
 	kfree(csa);
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 97fe79cf613e..6069f3703240 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5831,7 +5831,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 }
 
 /* cpus with isolated domains */
-static cpumask_var_t cpu_isolated_map;
+cpumask_var_t cpu_isolated_map;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
-- 
1.9.3
