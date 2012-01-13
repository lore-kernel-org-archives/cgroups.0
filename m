From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking account
 move.
Date: Fri, 13 Jan 2012 17:33:47 +0900
Message-ID: <20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120113173001.ee5260ca.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I think this bugfix is needed before going ahead. thoughts?
==
From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Fri, 13 Jan 2012 14:27:20 +0900
Subject: [PATCH 2/7] memcg: add memory barrier for checking account move.

At starting move_account(), source memcg's per-cpu variable
MEM_CGROUP_ON_MOVE is set. The page status update
routine check it under rcu_read_lock(). But there is no memory
barrier. This patch adds one.

Signed-off-by: KAMAZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 08b988d..9019069 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1256,8 +1256,10 @@ static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 
 	get_online_cpus();
 	spin_lock(&memcg->pcp_counter_lock);
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
 		per_cpu(memcg->stat->count[MEM_CGROUP_ON_MOVE], cpu) += 1;
+		smp_wmb();
+	}
 	memcg->nocpu_base.count[MEM_CGROUP_ON_MOVE] += 1;
 	spin_unlock(&memcg->pcp_counter_lock);
 	put_online_cpus();
@@ -1294,6 +1296,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
+	smp_rmb();
 	return this_cpu_read(memcg->stat->count[MEM_CGROUP_ON_MOVE]) > 0;
 }
 
-- 
1.7.4.1

