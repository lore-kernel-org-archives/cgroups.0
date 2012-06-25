From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5 v2] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 14:05:49 +0800
Message-ID: <1340604349-8046-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=NoOAoM/4GpxFUVzLXktFUi0pd8RD2/JEcMgafrLP/1w=;
        b=jlu15TxGOEm6lnN7cKxLk8a7eusg3ksJgnS3qKNzuKNlX/RVGgfYhtUnYqBlk0QWiH
         vqJZyVa2E7w23yBZFaad3FDLnIrFQXlHv92DIQcx8NurDX/eUw1ykuCVWsOR18T9Mlsg
         KBhx9P48rligyYpQIs/qRTILGGnAiGWvZF3LOQPofAmjbdtUvsgjpMmfDotG2uw3dwqc
         qxc5+Hl283xoh1AjP7jlDN0IwfQE/xtjUkViDq1kGuRcG6TmNa+uIgV9JI051vSHKT4l
         c/myc2u3qgtqA3xLABUdPrpUHMNRDPgEOb7XD88VJ8WM2EMDQ5PSeI9ZlVtw+sfCHV2J
         IZ3Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Since LRU_ALL_EVICTABLE is useless, just remove it.
Add LRU_ALL_UNEVICTABLE to mask unevictable pages.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/mmzone.h |    2 +-
 mm/memcontrol.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68c569f..5873620 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -209,7 +209,7 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
+#define LRU_ALL_UNEVICTABLE (BIT(LRU_UNEVICTABLE))
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 724bd02..ccda728 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4033,11 +4033,11 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 	}
 	seq_putc(m, '\n');
 
-	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
+	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_UNEVICTABLE);
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				BIT(LRU_UNEVICTABLE));
+				LRU_ALL_UNEVICTABLE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
-- 
1.7.9.5
