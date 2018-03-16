From: David Rientjes <rientjes@google.com>
Subject: [patch -mm 6/6] mm, memcg: disregard mempolicies for cgroup-aware
 oom killer
Date: Fri, 16 Mar 2018 14:08:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803161408260.211123@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=A6vq5i90Jqkyhe9hZRu54QDM5GsjcTOeljWeyNIKdvw=;
        b=eHHOfcqS1GMqX4uwECUjBaN6ci8f9RfOnMf1leuiBBkTA+5xN/bv1bVV19RW5kz3Up
         6ji7MHPpfBZmFdA2uZDZ+YRWuaPa6HBcxCO5ulAWCz67hzy12XW0OOcPLxvaATLYMasq
         lE2rxJoLg/bH1R0fs/IJAuvhx6xblzjSNesVAO8YjeMOMznzyAlnVdzMuUixxJKWarvb
         cbirwFdzfA99eNqd5uhIhL5/afJTYWHs308AhevJzzFsOXPcXcL1TBtiJkfXwq/1q8YT
         IkOhJOl7pvSsZ8ctyP+wx8ckQ4AIpa8Q8xEbpSp6aDWp2XNxh4tlB7zfzGzdaoFU8FRP
         KPAQ==
In-Reply-To: <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org


The cgroup-aware oom killer currently considers the set of allowed nodes
for the allocation that triggers the oom killer and discounts usage from
disallowed nodes when comparing cgroups.

If a cgroup has both the cpuset and memory controllers enabled, it may be
possible to restrict allocations to a subset of nodes, for example.  Some
latency sensitive users use cpusets to allocate only local memory, almost
to the point of oom even though there is an abundance of available free
memory on other nodes.

The same is true for processes that mbind(2) their memory to a set of
allowed nodes.

This yields very inconsistent results by considering usage from each mem
cgroup (and perhaps its subtree) for the allocation's set of allowed nodes
for its mempolicy.  Allocating a single page for a vma that is mbind to a
now-oom node can cause a cgroup that is restricted to that node by its
cpuset controller to be oom killed when other cgroups may have much higher
overall usage.

The cgroup-aware oom killer is described as killing the largest memory
consuming cgroup (or subtree) without mentioning the mempolicy of the
allocation.  For now, discount it.  It would be possible to add an
additional oom policy for NUMA awareness if it would be generally useful
later with the extensible interface.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2608,19 +2608,15 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 	return ret;
 }
 
-static long memcg_oom_badness(struct mem_cgroup *memcg,
-			      const nodemask_t *nodemask)
+static long memcg_oom_badness(struct mem_cgroup *memcg)
 {
 	const bool is_root_memcg = memcg == root_mem_cgroup;
 	long points = 0;
 	int nid;
-	pg_data_t *pgdat;
 
 	for_each_node_state(nid, N_MEMORY) {
-		if (nodemask && !node_isset(nid, *nodemask))
-			continue;
+		pg_data_t *pgdat = NODE_DATA(nid);
 
-		pgdat = NODE_DATA(nid);
 		if (is_root_memcg) {
 			points += node_page_state(pgdat, NR_ACTIVE_ANON) +
 				  node_page_state(pgdat, NR_INACTIVE_ANON);
@@ -2656,8 +2652,7 @@ static long memcg_oom_badness(struct mem_cgroup *memcg,
  *   >0: memcg is eligible, and the returned value is an estimation
  *       of the memory footprint
  */
-static long oom_evaluate_memcg(struct mem_cgroup *memcg,
-			       const nodemask_t *nodemask)
+static long oom_evaluate_memcg(struct mem_cgroup *memcg)
 {
 	struct css_task_iter it;
 	struct task_struct *task;
@@ -2691,7 +2686,7 @@ static long oom_evaluate_memcg(struct mem_cgroup *memcg,
 	if (eligible <= 0)
 		return eligible;
 
-	return memcg_oom_badness(memcg, nodemask);
+	return memcg_oom_badness(memcg);
 }
 
 static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
@@ -2751,7 +2746,7 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 		if (memcg_has_children(iter))
 			continue;
 
-		score = oom_evaluate_memcg(iter, oc->nodemask);
+		score = oom_evaluate_memcg(iter);
 
 		/*
 		 * Ignore empty and non-eligible memory cgroups.
@@ -2780,8 +2775,7 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 
 	if (oc->chosen_memcg != INFLIGHT_VICTIM) {
 		if (root == root_mem_cgroup) {
-			group_score = oom_evaluate_memcg(root_mem_cgroup,
-							 oc->nodemask);
+			group_score = oom_evaluate_memcg(root_mem_cgroup);
 			if (group_score > leaf_score) {
 				/*
 				 * Discount the sum of all leaf scores to find
