From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch] mm, memcg: avoid unnecessary function call when memcg is
 disabled
Date: Mon, 19 Nov 2012 17:44:34 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        bh=9N5IqF3JO3l4UiSWBfePiHNdCSH+vYWBO9nigG/Cazs=;
        b=NnKVUorNL8At/Ttuy4cZqDbWJvsm5tJA9NBKQpTDsuXh5NGi18fM+J2Y/Xzfimqeo9
         kCVGzUJ73r0tFlnLjOi1NMdO9S7ssaEmiZGM4Td6lR5mkfQvNvkjE8NYLxOSneFllwZu
         Eq/nU6ZGiRnRHOudknE9jFVJ9qA85oUbgkUEmylH3Q7dvUk26D/HV7S9rK+WrLhC4G/L
         S3hPQbqDLkWgoIRCtO0XsiZNcKQKBrQQwN9X+1hgy0sy6s8Ka7wUngPhkaGBeB+FmLeF
         xhMJ32iPb5kbP0NRjNhm095Hp09gqEoe8x4LaidFcSfSs+GY+2buZ4yz60ZtmPf9NCrM
         HFHQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

While profiling numa/core v16 with cgroup_disable=memory on the command 
line, I noticed mem_cgroup_count_vm_event() still showed up as high as 
0.60% in perftop.

This occurs because the function is called extremely often even when memcg 
is disabled.

To fix this, inline the check for mem_cgroup_disabled() so we avoid the 
unnecessary function call if memcg is disabled.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |    9 ++++++++-
 mm/memcontrol.c            |    9 ++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
+static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
+					     enum vm_event_item idx)
+{
+	if (mem_cgroup_disabled() || !mm)
+		return;
+	__mem_cgroup_count_vm_event(mm, idx);
+}
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -59,6 +59,8 @@
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
+EXPORT_SYMBOL(mem_cgroup_subsys);
+
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
@@ -1015,13 +1017,10 @@ void mem_cgroup_iter_break(struct mem_cgroup *root,
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
+void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 	struct mem_cgroup *memcg;
 
-	if (!mm)
-		return;
-
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (unlikely(!memcg))
@@ -1040,7 +1039,7 @@ void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 out:
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_count_vm_event);
+EXPORT_SYMBOL(__mem_cgroup_count_vm_event);
 
 /**
  * mem_cgroup_zone_lruvec - get the lru list vector for a zone and memcg
