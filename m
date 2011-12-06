From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 3/4] memcg: clear pc->mem_cgroup if necessary
Date: Tue, 6 Dec 2011 19:15:05 +0900
Message-ID: <20111206191505.22cea0aa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111206123923.1432ab52.kamezawa.hiroyu@jp.fujitsu.com>
	<20111206191211.3be32ccb.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206191211.3be32ccb.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From f0c8f600f0d0e5500aaad493fb5740ebe5ee1225 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Tue, 6 Dec 2011 17:51:55 +0900
Subject: [PATCH 3/4] memcg: clear pc->mem_cgorup if necessary.

At swap-in, page is added to LRU before accounted by memcg.
This causes page_cgroup->mem_cgroup v.s. LRU mis-match. This problem
is now treated by PCG_ACCT_LRU flag bit in page_cgroup->flags.

This patch is a preparation for new approarch. This patch clears
pc->mem_cgroup if a newly allocated page may be added to LRU before
charge. This will be required for removing PCG_ACCT_LRU bit.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/memcontrol.h |    5 +++++
 mm/ksm.c                   |    1 +
 mm/memcontrol.c            |   14 ++++++++++++++
 mm/swap_state.c            |    1 +
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bd3b102..7428409 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -126,6 +126,7 @@ extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
+extern void mem_cgroup_reset_owner(struct page *page);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -388,6 +389,10 @@ static inline void mem_cgroup_replace_page_cache(struct page *oldpage,
 				struct page *newpage)
 {
 }
+
+static inline void mem_cgroup_reset_owner(struct page *page);
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff --git a/mm/ksm.c b/mm/ksm.c
index a6d3fb7..480983d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1571,6 +1571,7 @@ struct page *ksm_does_need_to_copy(struct page *page,
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
 		SetPageDirty(new_page);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 66a2a59..b8706d8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3017,6 +3017,20 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 	rcu_read_unlock();
 }
 
+/*
+ * A function for resetting pc->memc_cgroup for newly allocated pages.
+ * This function should be called if the newpage will be added to LRU
+ * before start accounting.
+ */
+void mem_cgroup_reset_owner(struct page *newpage)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(newpage);
+	VM_BUG_ON(PageCgroupUsed(pc));
+	pc->mem_cgroup = root_mem_cgroup;
+}
+
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 78cc4d1..747539e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -301,6 +301,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			mem_cgroup_reset_owner(new_page);
 		}
 
 		/*
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
