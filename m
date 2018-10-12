From: Waiman Long <longman@redhat.com>
Subject: [PATCH v13 02/11] cpuset: Define data structures to support scheduling partition
Date: Fri, 12 Oct 2018 13:55:42 -0400
Message-ID: <1539366951-8498-3-git-send-email-longman@redhat.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539366951-8498-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

From a cpuset point of view, a scheduling partition is a group of
cpusets with their own set of exclusive CPUs that are not shared by
other tasks outside the scheduling partition.

In the legacy hierarchy, scheduling partitions are supported indirectly
via the right use of the load balancing and the exclusive CPUs flag
which is not intuitive and can be hard to use.

To fully support the concept of scheduling partitions in the default
hierarchy, we need to add some new field into the cpuset structure as
well as a new tmpmasks structure that is used to pre-allocate cpumasks
at the top level cpuset functions to avoid memory allocation in inner
functions as memory allocation failure in those inner functions may
cause a cpuset to have inconsistent states.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2b5c447..29a2bdc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -110,6 +110,13 @@ struct cpuset {
 	nodemask_t effective_mems;
 
 	/*
+	 * CPUs allocated to child sub-partitions (default hierarchy only)
+	 * - CPUs granted by the parent = effective_cpus U subparts_cpus
+	 * - effective_cpus and subparts_cpus are mutually exclusive.
+	 */
+	cpumask_var_t subparts_cpus;
+
+	/*
 	 * This is old Memory Nodes tasks took on.
 	 *
 	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
@@ -134,6 +141,30 @@ struct cpuset {
 
 	/* for custom sched domain */
 	int relax_domain_level;
+
+	/* number of CPUs in subparts_cpus */
+	int nr_subparts_cpus;
+
+	/* partition root state */
+	int partition_root_state;
+};
+
+/*
+ * Partition root states:
+ *
+ *   0 - not a partition root
+ *   1 - partition root
+ */
+#define PRS_DISABLED		0
+#define PRS_ENABLED		1
+
+/*
+ * Temporary cpumasks for working with partitions that are passed among
+ * functions to avoid memory allocation in inner functions.
+ */
+struct tmpmasks {
+	cpumask_var_t addmask, delmask;	/* For partition root */
+	cpumask_var_t new_cpus;		/* For update_cpumasks_hier() */
 };
 
 static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
@@ -218,9 +249,15 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_partition_root(const struct cpuset *cs)
+{
+	return cs->partition_root_state;
+}
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
 		  (1 << CS_MEM_EXCLUSIVE)),
+	.partition_root_state = PRS_ENABLED,
 };
 
 /**
-- 
1.8.3.1

