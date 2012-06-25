From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid overflow
Date: Mon, 25 Jun 2012 14:04:20 +0800
Message-ID: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=rZjIDK1nttP/wwEFlODXJisfCyCG1K4DQUuK7jeiV40=;
        b=ufjyyzgbeIrcxaBVrVuHcTBgFFdpGI2lSQC0aObk2r0aPUDXWQGNsXy+Wdogy6Jts5
         qOgjiO8PhszYzBT1UNyfi3rSLMRp3LScRbsFDQp++48YnX4/txozeH9YjeR3+MTCWaML
         2Zw76gMkN3pc5KMqKsFJYZdyuYwyRkpYuWhfklOaTJ8qE6Z3K20qMKMd0pkxz0X2myAD
         m/TZrWe+zJFeA8paFkNaNFPja4oMkLbtNukxxVH9R+XxBajOkwbO2rIhKIhSaa1MZgZT
         F4n59LN7oQHToOmDuyQ4q8d5tkVAuCg7gCAWhfD2sd2mhNgAn1Dv57uLNHHtiCbYqmI2
         ryDg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Changlog:

V2 -> V1:
* fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Since the return value variable in mem_cgroup_zone_nr_lru_pages and
mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
value of funtions by u64 to avoid overflow.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/vmstat.h |    2 +-
 mm/memcontrol.c        |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 65efb92..6a14291 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
 	return x;
 }
 
-static inline unsigned long zone_page_state(struct zone *zone,
+static inline u64 zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
 	long x = atomic_long_read(&zone->vm_stat[item]);
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
