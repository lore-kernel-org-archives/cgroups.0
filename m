From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v3 1/4] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 16:43:32 +0800
Message-ID: <1340613812-9458-1-git-send-email-liwp.linux@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=NoOAoM/4GpxFUVzLXktFUi0pd8RD2/JEcMgafrLP/1w=;
        b=sNjj+t4zHTOfxwZVxtdoRk7fcdWYRsKRGDM5wyh7FiGu/66Z8UOnUIiu7nA+uAm4F8
         xx1L7rZY+5aPiMJ9nTYr6ngxQJdXo889G7fXz1/I8vSxbvnthGRFzqr9Y1COq8ATGElk
         zW3hUBj2gH7FKslJ+IvoZT1KHxH1D6fOT76/PuVRhA7aNHKbt3Op9Qv91UqvlrkGAarR
         PmyMMbR7zflElZarxZ5fcuHvDcnSZMXb71MtPu7qRCPi/k0ULiuZ4A5T6Zm3bfw3DXAb
         EX0e0gcWf4h0XGDxWNN2DjCwLHj6eR60UqkOrs/xUHbhyv8wuswDbn4+rvFSiqH1k5qM
         Bwkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <eric.dumazet@gmail.com>, Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since LRU_ALL_EVICTABLE is useless, just remove it.
Add LRU_ALL_UNEVICTABLE to mask unevictable pages.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
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
