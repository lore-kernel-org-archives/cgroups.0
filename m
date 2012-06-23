From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Date: Sat, 23 Jun 2012 14:15:34 +0800
Message-ID: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=t8RLLbteSVG0HSglSsTwL4Cjqoa/oXgIGryK6dw9mm0=;
        b=sGz2kSPdrCan9ZEh5XMVfRCznfeyxt28M/SE2qDKtVtlwZxvLJN++wVVszeN51hIHs
         y8YjiwRwmFC7eHaNtKjuDKGoftYX4zmz8jMTc7zkbdBcRAiAmHuqV+cAmRmTxgLdQXXD
         40Kg8CxiFk1TojVJ5QNRas3pRLBYi4eqiv7SqBqCEwm2Xjb5AokEruLX8rOlXL68T0+g
         dtywoE4HuexX0hqUCUajnSnwgJSWzSg67gn9rZ4O5s7RIMn0MxXLUHbizJ7GYYPHNple
         pbWbnZcfNv0AiXB9A2lB+v/sSOkNOSc41rbwl0JmObbyp/chddJuM2EBhUa4agTGoR4C
         Hfqg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Since the return value variable in mem_cgroup_zone_nr_lru_pages and
mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
value of funtions by u64 to avoid overflow.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2677e0..724bd02 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -776,8 +776,7 @@ mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
 	return ret;
 }
 
-static unsigned long
-mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+static u64 mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 			int nid, unsigned int lru_mask)
 {
 	u64 total = 0;
@@ -790,7 +789,7 @@ mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 	return total;
 }
 
-static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
+static u64 mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 			unsigned int lru_mask)
 {
 	int nid;
-- 
1.7.9.5
