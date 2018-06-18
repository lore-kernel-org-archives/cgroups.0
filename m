From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 6/9] cpuset: Make generate_sched_domains() recognize reserved_cpus
Date: Mon, 18 Jun 2018 12:14:06 +0800
Message-ID: <1529295249-5207-8-git-send-email-longman@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

The generate_sched_domains() function is modified to make it work
correctly with the newly introduced reserved_cpus mask for schedule
domains generation.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 26ac083..ea640ce 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -672,13 +672,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] struct cpumask slot */
 	struct cgroup_subsys_state *pos_css;
+	bool root_load_balance = is_sched_load_balance(&top_cpuset);
 
 	doms = NULL;
 	dattr = NULL;
 	csa = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
-	if (is_sched_load_balance(&top_cpuset)) {
+	if (root_load_balance && !top_cpuset.nr_reserved) {
 		ndoms = 1;
 		doms = alloc_sched_domains(ndoms);
 		if (!doms)
@@ -701,6 +702,8 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	csn = 0;
 
 	rcu_read_lock();
+	if (root_load_balance)
+		csa[csn++] = &top_cpuset;
 	cpuset_for_each_descendant_pre(cp, pos_css, &top_cpuset) {
 		if (cp == &top_cpuset)
 			continue;
@@ -711,6 +714,9 @@ static int generate_sched_domains(cpumask_var_t **domains,
 		 * parent's cpus, so just skip them, and then we call
 		 * update_domain_attr_tree() to calc relax_domain_level of
 		 * the corresponding sched domain.
+		 *
+		 * If root is load-balancing, we can skip @cp if it
+		 * is a subset of the root's effective_cpus.
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
 		    !(is_sched_load_balance(cp) &&
@@ -718,11 +724,16 @@ static int generate_sched_domains(cpumask_var_t **domains,
 					 housekeeping_cpumask(HK_FLAG_DOMAIN))))
 			continue;
 
+		if (root_load_balance &&
+		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
+			continue;
+
 		if (is_sched_load_balance(cp))
 			csa[csn++] = cp;
 
-		/* skip @cp's subtree */
-		pos_css = css_rightmost_descendant(pos_css);
+		/* skip @cp's subtree if not a scheduling domain root */
+		if (!is_sched_domain_root(cp))
+			pos_css = css_rightmost_descendant(pos_css);
 	}
 	rcu_read_unlock();
 
@@ -850,7 +861,12 @@ static void rebuild_sched_domains_locked(void)
 	 * passing doms with offlined cpu to partition_sched_domains().
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
-	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
+	if (!top_cpuset.nr_reserved &&
+	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
+		goto out;
+
+	if (top_cpuset.nr_reserved &&
+	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
 		goto out;
 
 	/* Generate domain masks and attrs */
-- 
1.8.3.1

