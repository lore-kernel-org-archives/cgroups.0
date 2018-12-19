From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 1/2] cgroup/cpuset: Update stale generate_sched_domains() comments
Date: Wed, 19 Dec 2018 14:34:44 +0100
Message-ID: <20181219133445.31982-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Commit fc560a26acce ("cpuset: replace cpuset->stack_list with
cpuset_for_each_descendant_pre()") removed the local list (q)
that was used to perform a top-down scan of all cpusets;
however, comments mentioning it were not updated.

Update comments to reflect current implementation.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
---
 kernel/cgroup/cpuset.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f0decd8165e7..f0822a730879 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -725,11 +725,10 @@ static inline int nr_cpusets(void)
  * Must be called with cpuset_mutex held.
  *
  * The three key local variables below are:
- *    q  - a linked-list queue of cpuset pointers, used to implement a
- *	   top-down scan of all cpusets.  This scan loads a pointer
- *	   to each cpuset marked is_sched_load_balance into the
- *	   array 'csa'.  For our purposes, rebuilding the schedulers
- *	   sched domains, we can ignore !is_sched_load_balance cpusets.
+ *    cp - cpuset pointer, used (together with pos_css) to perform a
+ *	   top-down scan of all cpusets. For our purposes, rebuilding
+ *	   the schedulers sched domains, we can ignore !is_sched_load_
+ *	   balance cpusets.
  *  csa  - (for CpuSet Array) Array of pointers to all the cpusets
  *	   that need to be load balanced, for convenient iterative
  *	   access by the subsequent code that finds the best partition,
@@ -760,7 +759,7 @@ static inline int nr_cpusets(void)
 static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
-	struct cpuset *cp;	/* scans q */
+	struct cpuset *cp;	/* top-down scan of cpusets */
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
-- 
2.17.2

