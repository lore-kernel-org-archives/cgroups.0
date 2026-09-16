Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3675529403
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583712; cv=none; b=rww0mDFKgM4K/eixYktqARFrXvLn/sGscqyj9FLF/QBehTT5R+Myt9pHLZCNHBbV7MV0bxUoJAtDFqr/k5F49OeOimaKAuNnb7HufPOw2NMYTlnGtKT2RCuE0q4Hy9pXJlDqKiBibv1Jp3Hn7n2x66iESV9xNo9LQtBe/edAn/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583712; c=relaxed/simple;
	bh=9vQQUggjZS/CTjvK13LaKTfDvlY33IA8A65kzKIFyFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=px/I4YoRMrOrC4Wzk5B3+4wABxMKr/d9/zv0rBKTvW8oQcS/8e6v7oHYs3aDhYo1m19IiXuNxXgueIUdqRdAn737mdPwPc1S/CFE5mp+VvMZTvMBD1YhyOffSx6xGqmsZPb5hBOmYlovV7VjWCLiNaJ1bP7BRP8OKf2LT2AdOTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Sep 2026 03:34:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	taejoon.song@lge.com,
	her0gyugyu@gmail.com,
	lianux.mm@gmail.com
Subject: [RFC PATCH v11 1/4] mm: swap: introduce swap tier infrastructure
Date: Thu, 17 Sep 2026 03:34:34 +0900
Message-Id: <20260916183437.2946306-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260916183437.2946306-1-youngjun.park@lge.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the "swap tier" as an abstraction over swap devices, so that
swap allocation is organized on a tier basis rather than on a flat list
of devices.

Swap priority already points this way. Devices with different priorities
are used in priority order, and devices with the same priority are used
round-robin. A priority therefore already behaves like a tier, a group
of devices that share one service speed. This patch gives that group an
explicit structure, without adding any user interface.

A swap tier is the set of swap devices that share a priority. A tier is
created when the first device with its priority is swapped on, and
removed when the last one is swapped off. The active tiers are kept
sorted by priority for allocation.

Making the tier own its devices gives a same-priority group the data
structures it needs and lays the groundwork for tier-based allocation,
onto which per-cgroup swap device selection can later be fit.

No tier feature and no user-visible change are introduced here. This
only prepares the ground for them.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS          |   2 +
 include/linux/swap.h |   2 +-
 mm/Makefile          |   2 +-
 mm/swap.h            |   1 +
 mm/swap_tier.c       | 114 +++++++++++++++++++++++++++++++++++++++++++
 mm/swap_tier.h       |  37 ++++++++++++++
 mm/swapfile.c        |  66 +++++++++++++------------
 7 files changed, 192 insertions(+), 32 deletions(-)
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e4412c3d8d45..37f353015cae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17410,6 +17410,8 @@ F:	mm/page_io.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_tier.c
+F:	mm/swap_tier.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 43155e122b5c..22ccb4b5801e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -237,7 +237,7 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
+	struct plist_node list;		/* entry in its swap tier */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..d89a7abadc46 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -76,7 +76,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o swap_tier.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..4de6b9b0f261 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -36,6 +36,7 @@ struct swap_io_ctx;
 #define swap_entry_order(order)	0
 #endif
 
+extern spinlock_t swap_lock;
 extern struct swap_info_struct *swap_info[];
 
 /*
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
new file mode 100644
index 000000000000..8ed1427cee09
--- /dev/null
+++ b/mm/swap_tier.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/swap.h>
+
+#include "swap.h"
+#include "swap_tier.h"
+
+#define MAX_SWAPTIER	MAX_SWAPFILES
+
+static struct swap_tier swap_tiers[MAX_SWAPTIER];
+
+/* active swap priority list, sorted in descending order */
+LIST_HEAD(swap_tier_active_list);
+/* unused swap_tier object */
+static LIST_HEAD(swap_tier_inactive_list);
+
+#define for_each_tier(tier, idx) \
+	for (idx = 0, tier = &swap_tiers[0]; idx < MAX_SWAPTIER; \
+		idx++, tier = &swap_tiers[idx])
+
+/*
+ * Naming Convention:
+ *   swap_tiers_*() - Public/exported functions
+ *   swap_tier_*()  - Private/internal functions
+ */
+
+static struct swap_tier *swap_tier_lookup(short prio)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio == prio)
+			return tier;
+	}
+
+	return NULL;
+}
+
+/* Insert new tier into the active list sorted by priority. */
+static void swap_tier_activate(struct swap_tier *new)
+{
+	struct list_head *pos = &swap_tier_active_list;
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio <= new->prio) {
+			pos = &tier->list;
+			break;
+		}
+	}
+
+	list_add_tail(&new->list, pos);
+}
+
+static void swap_tier_inactivate(struct swap_tier *tier)
+{
+	list_move_tail(&tier->list, &swap_tier_inactive_list);
+}
+
+void swap_tiers_init(void)
+{
+	struct swap_tier *tier;
+	int idx;
+
+	BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
+
+	for_each_tier(tier, idx) {
+		plist_head_init(&tier->active_head);
+		INIT_LIST_HEAD(&tier->list);
+		swap_tier_inactivate(tier);
+	}
+}
+
+static struct swap_tier *swap_tier_prepare(short prio)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+
+	/* A tier holds at least one device, so one is always unused. */
+	tier = list_first_entry(&swap_tier_inactive_list,
+		struct swap_tier, list);
+
+	list_del_init(&tier->list);
+	tier->prio = prio;
+
+	return tier;
+}
+
+void swap_tiers_assign_dev(struct swap_info_struct *swp)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+
+	tier = swap_tier_lookup(swp->prio);
+	if (!tier) {
+		tier = swap_tier_prepare(swp->prio);
+		swap_tier_activate(tier);
+	}
+
+	plist_add(&swp->list, &tier->active_head);
+}
+
+void swap_tiers_remove_dev(struct swap_info_struct *swp)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+
+	tier = swap_tier_lookup(swp->prio);
+	plist_del(&swp->list, &tier->active_head);
+	if (plist_head_empty(&tier->active_head))
+		swap_tier_inactivate(tier);
+}
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
new file mode 100644
index 000000000000..3dce716d23f6
--- /dev/null
+++ b/mm/swap_tier.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SWAP_TIER_H
+#define _SWAP_TIER_H
+
+#include <linux/list.h>
+#include <linux/plist.h>
+#include <linux/types.h>
+
+/* Forward declarations */
+struct swap_info_struct;
+
+/*
+ * struct swap_tier - structure representing a swap tier.
+ *
+ * @prio: priority of the swap devices in the tier.
+ * @active_head: swap devices in the tier.
+ * @list: linkage into swap_tier_active_list or swap_tier_inactive_list.
+ */
+struct swap_tier {
+	short prio;
+	struct plist_head active_head;
+	struct list_head list;
+};
+
+extern struct list_head swap_tier_active_list;
+
+#define for_each_active_tier(tier) \
+	list_for_each_entry(tier, &swap_tier_active_list, list)
+
+/* Initialization and application */
+void swap_tiers_init(void);
+
+/* Tier assignment */
+void swap_tiers_assign_dev(struct swap_info_struct *swp);
+void swap_tiers_remove_dev(struct swap_info_struct *swp);
+
+#endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c0eddccfaca2..8201ae779833 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,6 +48,7 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -61,9 +62,9 @@ static void move_cluster(struct swap_info_struct *si,
  * lazily allocated & freed swap device info struts, and SWP_USED indicates
  * which device is used, ~SWP_USED devices and can be reused.
  *
- * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ * Also protects the swap tiers, total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -83,17 +84,11 @@ bool swap_migration_ad_supported;
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 
-/*
- * all active swap_info_structs
- * protected with swap_lock, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
 /*
  * all available (active, not full) swap_info_structs
  * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
+ * This is used by folio_alloc_swap() instead of the active lists of
+ * the swap tiers because those include all swap_info_structs,
  * but folio_alloc_swap() doesn't need to look at full ones.
  * This uses its own lock instead of swap_lock because when a
  * swap_info_struct changes between not-full/full, it needs to
@@ -1444,22 +1439,27 @@ static bool swap_sync_discard(void)
 {
 	bool ret = false;
 	struct swap_info_struct *si, *next;
+	struct swap_tier *tier;
+	short prio;
 
 	spin_lock(&swap_lock);
 start_over:
-	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		spin_unlock(&swap_lock);
-		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
-				ret = swap_do_scheduled_discard(si);
-			put_swap_device(si);
-		}
-		if (ret)
-			return true;
+	for_each_active_tier(tier) {
+		prio = tier->prio;
+		plist_for_each_entry_safe(si, next, &tier->active_head, list) {
+			spin_unlock(&swap_lock);
+			if (get_swap_device_info(si)) {
+				if (si->flags & SWP_PAGE_DISCARD)
+					ret = swap_do_scheduled_discard(si);
+				put_swap_device(si);
+			}
+			if (ret)
+				return true;
 
-		spin_lock(&swap_lock);
-		if (plist_node_empty(&next->list))
-			goto start_over;
+			spin_lock(&swap_lock);
+			if (plist_node_empty(&next->list) || tier->prio != prio)
+				goto start_over;
+		}
 	}
 	spin_unlock(&swap_lock);
 
@@ -3088,7 +3088,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	assert_spin_locked(&swap_lock);
 
-	plist_add(&si->list, &swap_active_head);
+	swap_tiers_assign_dev(si);
 
 	/* Add back to available list */
 	add_to_avail_list(si, true);
@@ -3182,6 +3182,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
 	struct swap_cluster_info *cluster_info;
+	struct swap_tier *tier;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
@@ -3200,13 +3201,17 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
+	for_each_active_tier(tier) {
+		plist_for_each_entry(p, &tier->active_head, list) {
+			if (p->flags & SWP_WRITEOK) {
+				if (p->swap_file->f_mapping == mapping) {
+					found = 1;
+					break;
+				}
 			}
 		}
+		if (found)
+			break;
 	}
 	if (!found) {
 		err = -EINVAL;
@@ -3230,7 +3235,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	}
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
+	swap_tiers_remove_dev(p);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	spin_unlock(&p->lock);
@@ -4002,7 +4007,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-	return !plist_head_empty(&swap_active_head);
+	return !list_empty(&swap_tier_active_list);
 }
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
@@ -4055,6 +4060,7 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	swap_tiers_init();
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.48.1

