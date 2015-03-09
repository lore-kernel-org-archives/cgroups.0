From: riel@redhat.com
Subject: [PATCH 2/4] cpusets,isolcpus: exclude isolcpus from load balancing in cpusets
Date: Mon,  9 Mar 2015 12:12:08 -0400
Message-ID: <1425917530-1771-3-git-send-email-riel@redhat.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425917530-1771-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>

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
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1d1fe9361d29..b544e5229d99 100644
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
-- 
2.1.0
