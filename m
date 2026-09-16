Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31744D9567
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583712; cv=none; b=fUPw8uBMbWsYWzWDhLrFvEYJrM/jE6We3ZZG4VQIZMK7QV3QqPTRrn1kdHf6s3FY5EVyE9Y7kIh21XsSNJH9PIe9I/HD3QUq6MnBx0BTRUQEe0RxqRfTeDK3TDIBnnHbcfe6IIzJg8zuzrV7USId4231/MpjQ5fhwYOq6YelNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583712; c=relaxed/simple;
	bh=X61Dnjaw35FZr4d8vkWRgJwXha9DyIs+cJOK34/L4bo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KowpRiCSIeNKnjRdbEIKDLk1emndzOKDPXVcK0qZ+Mc0jYXZO/8ABLVpaeqVwX7bpG4IvT2gse8546mXsfwmMP2YSIguiDVXE4Y4Rf7BLMQssOdsuNmw6MFgJYevFcIjGNu33R6CItNKNvhh/8IV17eSeCAz9N0zvxVJxjerWh0=
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
Subject: [RFC PATCH v11 3/4] mm: swap: add a debugfs interface for memcg tier selection
Date: Thu, 17 Sep 2026 03:34:36 +0900
Message-Id: <20260916183437.2946306-4-youngjun.park@lge.com>
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

Swap tiers do nothing until something chooses between them. Let a memory
cgroup do that.

Each cgroup carries a mask of the tiers it may swap to. Write a cgroup
path and a hex mask to /sys/kernel/debug/swap/memcg_tiers to set it. Bit
i is the tier at index i. /sys/kernel/debug/swap/tiers lists each tier's
index and priority.

  # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers

This lives in debugfs on purpose. A cgroup file is a permanent ABI, and
what a swap tier should look like is not settled yet. It is built only
with CONFIG_MEMCG and CONFIG_DEBUG_FS.

The masks are kept in a list keyed by cgroup ID rather than in struct
mem_cgroup, so memcg itself is not changed. A mask applies to the memory
charged to its cgroup and is not inherited by child cgroups. The entry of
a removed cgroup is dropped on the next write.

Each swap device is stamped with its tier's bit at swapon. A device's
tier never changes, so the stamp is written once and read locklessly by
the allocator.

When the last device of a tier is swapped off, the tier frees its index
for reuse. It waits until swapoff can no longer fail, so a device whose
swapoff fails goes back to the same index. The freed bit is set back in
every cgroup mask, so a cgroup that had disabled that tier must disable
it again once a new tier reuses the index.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/mm/index.rst     |   1 +
 Documentation/mm/swap-tier.rst |  55 ++++++
 MAINTAINERS                    |   1 +
 include/linux/swap.h           |   1 +
 mm/swap_tier.c                 | 294 ++++++++++++++++++++++++++++++++-
 mm/swap_tier.h                 |  31 ++++
 mm/swapfile.c                  |   5 +
 7 files changed, 387 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/mm/swap-tier.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c..6afc45cd4b3d 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -34,6 +34,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_reclaim
    swap
    swap-table
+   swap-tier
    page_cache
    shmfs
    oom
diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
new file mode 100644
index 000000000000..4007c23f83a6
--- /dev/null
+++ b/Documentation/mm/swap-tier.rst
@@ -0,0 +1,55 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Chris Li <chrisl@kernel.org>,
+         Youngjun Park <youngjun.park@lge.com>
+
+==========
+Swap Tier
+==========
+
+Swap tier is a group of swap devices that share a priority. It acts as a
+facilitation layer, allowing users to manage swap devices based on their
+speeds.
+
+Users are encouraged to assign swap device priorities according to device
+speed to fully utilize this feature.
+
+Tier Index
+----------
+
+A tier is created when the first swap device with its priority is swapped on,
+and removed when the last one is swapped off. Each tier is given an index when
+it is created and keeps it until it is removed, so a tier's index does not
+change when another priority is swapped on or off.
+
+Per-cgroup Tier Selection
+-------------------------
+
+A memory cgroup can be limited to some tiers through debugfs. This is for
+evaluation, not a stable ABI.
+
+``/sys/kernel/debug/swap/tiers`` lists the index and priority of each tier.
+``/sys/kernel/debug/swap/memcg_tiers`` takes a cgroup path and a mask in hex,
+where bit ``i`` allows the tier at index ``i``::
+
+    # cat /sys/kernel/debug/swap/tiers
+    Idx   Prio
+    0     100
+    1     50
+    # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
+
+There is no separate delete operation. Writing a mask that allows every tier
+clears the restriction, so the cgroup drops out of the file::
+
+    # echo "/batch 0xffffffff" > /sys/kernel/debug/swap/memcg_tiers
+
+A cgroup's mask is also dropped when the cgroup is removed.
+
+A mask applies to the memory charged to its own cgroup and is not inherited by
+child cgroups. A tier keeps its index for its lifetime, so the same mask keeps
+selecting the same tier across a swapon or swapoff.
+
+When a tier's last device is swapped off, its index is freed and can be reused
+by a later tier. The freed index is re-allowed in every cgroup mask, so a
+cgroup that had disabled it must disable it again once a new tier reuses the
+index.
diff --git a/MAINTAINERS b/MAINTAINERS
index 37f353015cae..af17b804f31b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17402,6 +17402,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
+F:	Documentation/mm/swap-tier.rst
 F:	include/linux/swap.h
 F:	include/linux/swap_ops.h
 F:	include/linux/swapfile.h
diff --git a/include/linux/swap.h b/include/linux/swap.h
index df69c2dd434a..30d3c37ca530 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -237,6 +237,7 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
+	unsigned int	tier_mask;	/* swap tier mask */
 	struct plist_node list;		/* entry in its swap tier */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 286f319fb125..de183c2678e0 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -1,5 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/swap.h>
+#if defined(CONFIG_MEMCG) && defined(CONFIG_DEBUG_FS)
+#include <linux/debugfs.h>
+#include <linux/memcontrol.h>
+#include <linux/seq_file.h>
+#endif
 
 #include "swap.h"
 #include "swap_tier.h"
@@ -17,6 +22,10 @@ static LIST_HEAD(swap_tier_inactive_list);
 	for (idx = 0, tier = &swap_tiers[0]; idx < MAX_SWAPTIER; \
 		idx++, tier = &swap_tiers[idx])
 
+/* A tier's index is its slot in the array, stable for its lifetime. */
+#define TIER_IDX(tier)	((tier) - swap_tiers)
+#define TIER_MASK(tier)	(1U << TIER_IDX(tier))
+
 /*
  * Naming Convention:
  *   swap_tiers_*() - Public/exported functions
@@ -56,6 +65,12 @@ static void swap_tier_inactivate(struct swap_tier *tier)
 	list_move_tail(&tier->list, &swap_tier_inactive_list);
 }
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_DEBUG_FS)
+static void swap_tiers_debugfs_init(void);
+#else
+static inline void swap_tiers_debugfs_init(void) {}
+#endif
+
 void swap_tiers_init(void)
 {
 	struct swap_tier *tier;
@@ -69,6 +84,8 @@ void swap_tiers_init(void)
 		INIT_LIST_HEAD(&tier->list);
 		swap_tier_inactivate(tier);
 	}
+
+	swap_tiers_debugfs_init();
 }
 
 static struct swap_tier *swap_tier_prepare(short prio)
@@ -103,6 +120,17 @@ void swap_tiers_assign_dev(struct swap_info_struct *swp)
 	spin_unlock(&swap_avail_lock);
 
 	plist_add(&swp->list, &tier->active_head);
+
+	/* Put back by a failed swapoff, so already stamped and counted. */
+	if (swp->tier_mask)
+		return;
+
+	/*
+	 * A device's tier never changes, so stamp it once here. Paired with
+	 * the READ_ONCE() in the allocator, which reads this without swap_lock.
+	 */
+	tier->nr_devs++;
+	WRITE_ONCE(swp->tier_mask, TIER_MASK(tier));
 }
 
 void swap_tiers_remove_dev(struct swap_info_struct *swp)
@@ -113,11 +141,31 @@ void swap_tiers_remove_dev(struct swap_info_struct *swp)
 
 	tier = swap_tier_lookup(swp->prio);
 	plist_del(&swp->list, &tier->active_head);
-	if (plist_head_empty(&tier->active_head)) {
+}
+
+/*
+ * A failed swapoff puts the device back into its tier, so the tier is given
+ * up only here, once swapoff can no longer fail. Returns the tier's mask if
+ * @swp was its last device, 0 otherwise.
+ */
+unsigned int swap_tiers_release_dev(struct swap_info_struct *swp)
+{
+	struct swap_tier *tier;
+	unsigned int freed = 0;
+
+	lockdep_assert_held(&swap_lock);
+
+	tier = swap_tier_lookup(swp->prio);
+	if (!--tier->nr_devs) {
 		spin_lock(&swap_avail_lock);
 		swap_tier_inactivate(tier);
 		spin_unlock(&swap_avail_lock);
+		freed = TIER_MASK(tier);
 	}
+
+	WRITE_ONCE(swp->tier_mask, 0);
+
+	return freed;
 }
 
 /* The avail list of the tier @swp belongs to. */
@@ -127,3 +175,247 @@ struct plist_head *swap_tiers_avail_head(struct swap_info_struct *swp)
 
 	return &swap_tier_lookup(swp->prio)->avail_head;
 }
+
+#if defined(CONFIG_MEMCG) && defined(CONFIG_DEBUG_FS)
+static DEFINE_MUTEX(swap_tier_lock);
+
+/*
+ * struct swap_tier_cgroup - tier mask of a cgroup.
+ *
+ * @id: cgroup ID of the cgroup.
+ * @mask: tiers the cgroup may swap to.
+ * @list: linkage into swap_tier_cgroup_list.
+ * @rcu: frees the entry after a grace period.
+ */
+struct swap_tier_cgroup {
+	u64 id;
+	unsigned int mask;
+	struct list_head list;
+	struct rcu_head rcu;
+};
+
+/*
+ * Cgroups written to memcg_tiers. Changed under swap_tier_lock, walked by
+ * the allocator under RCU. A cgroup not on the list may use every tier.
+ */
+static LIST_HEAD(swap_tier_cgroup_list);
+
+static struct swap_tier_cgroup *swap_tier_cgroup_lookup(u64 id)
+{
+	struct swap_tier_cgroup *stc;
+
+	list_for_each_entry_rcu(stc, &swap_tier_cgroup_list, list,
+				lockdep_is_held(&swap_tier_lock)) {
+		if (stc->id == id)
+			return stc;
+	}
+
+	return NULL;
+}
+
+/* Drop the entries that allow every tier or whose cgroup is removed. */
+static void swap_tier_cgroup_prune(void)
+{
+	struct swap_tier_cgroup *stc, *tmp;
+	struct cgroup *cgrp;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	list_for_each_entry_safe(stc, tmp, &swap_tier_cgroup_list, list) {
+		if (stc->mask != TIER_ALL_MASK) {
+			cgrp = __cgroup_get_from_id(stc->id);
+			if (!IS_ERR(cgrp)) {
+				cgroup_put(cgrp);
+				continue;
+			}
+		}
+
+		list_del_rcu(&stc->list);
+		kfree_rcu(stc, rcu);
+	}
+}
+
+/* One line per cgroup that dropped a tier, in the syntax a write takes. */
+static int swap_tiers_memcg_show(struct seq_file *m, void *v)
+{
+	struct swap_tier_cgroup *stc;
+	struct cgroup *cgrp;
+	char *path;
+
+	path = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	mutex_lock(&swap_tier_lock);
+	list_for_each_entry(stc, &swap_tier_cgroup_list, list) {
+		if (stc->mask == TIER_ALL_MASK)
+			continue;
+
+		/* A removed cgroup's entry stays until the next write. */
+		cgrp = __cgroup_get_from_id(stc->id);
+		if (IS_ERR(cgrp))
+			continue;
+
+		cgroup_path(cgrp, path, PATH_MAX);
+		cgroup_put(cgrp);
+		seq_printf(m, "%s 0x%x\n", path, stc->mask);
+	}
+	mutex_unlock(&swap_tier_lock);
+
+	kfree(path);
+	return 0;
+}
+
+/*
+ * Keep only the tiers set in @mask.  @cgpath must name a cgroup that has
+ * the memory controller enabled.
+ */
+static int swap_tiers_memcg_set(const char *cgpath, unsigned int mask)
+{
+	struct swap_tier_cgroup *stc;
+	struct cgroup *cgrp;
+	bool enabled;
+	int ret = 0;
+	u64 id;
+
+	cgrp = cgroup_get_from_path(cgpath);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	/*
+	 * Not cgroup_get_e_css(), which falls back to an ancestor when the
+	 * memory controller is not enabled here.
+	 */
+	rcu_read_lock();
+	enabled = cgroup_css(cgrp, &memory_cgrp_subsys);
+	rcu_read_unlock();
+	id = cgroup_id(cgrp);
+	cgroup_put(cgrp);
+
+	if (!enabled)
+		return -ENOENT;
+
+	mutex_lock(&swap_tier_lock);
+
+	stc = swap_tier_cgroup_lookup(id);
+	if (stc) {
+		WRITE_ONCE(stc->mask, mask);
+	} else if (mask != TIER_ALL_MASK) {
+		stc = kmalloc_obj(*stc, GFP_KERNEL);
+		if (stc) {
+			stc->id = id;
+			stc->mask = mask;
+			list_add_rcu(&stc->list, &swap_tier_cgroup_list);
+		} else {
+			ret = -ENOMEM;
+		}
+	}
+	swap_tier_cgroup_prune();
+
+	mutex_unlock(&swap_tier_lock);
+	return ret;
+}
+
+/* The tiers that the cgroup @folio is charged to may swap to. */
+unsigned int folio_tier_mask(struct folio *folio)
+{
+	struct swap_tier_cgroup *stc;
+	struct mem_cgroup *memcg;
+	unsigned int mask = TIER_ALL_MASK;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (memcg) {
+		stc = swap_tier_cgroup_lookup(cgroup_id(memcg->css.cgroup));
+		if (stc)
+			mask = READ_ONCE(stc->mask);
+	}
+	rcu_read_unlock();
+
+	return mask;
+}
+
+/*
+ * When a tier is removed, its index (bit position in the mask) becomes
+ * free for reassignment to a future tier. If a cgroup had previously
+ * disabled this tier (cleared the bit in its memcg_tiers entry), its mask
+ * would keep that bit clear, meaning the new tier at the same index would
+ * be silently unavailable, an invisible cgroup constraint left behind by a
+ * tier that no longer exists.
+ *
+ * To prevent this, OR the removed tier's mask bit into every cgroup's
+ * mask. This resets the bit so the new tier is accessible by default.
+ * Users who want to restrict it must explicitly disable it after the tier
+ * is re-created.
+ */
+void swap_tiers_memcg_propagate(unsigned int mask)
+{
+	struct swap_tier_cgroup *stc;
+
+	mutex_lock(&swap_tier_lock);
+	list_for_each_entry(stc, &swap_tier_cgroup_list, list)
+		WRITE_ONCE(stc->mask, stc->mask | mask);
+	mutex_unlock(&swap_tier_lock);
+}
+
+static int swap_tiers_memcg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, swap_tiers_memcg_show, NULL);
+}
+
+static ssize_t swap_tiers_memcg_write(struct file *file,
+				      const char __user *ubuf,
+				      size_t count, loff_t *ppos)
+{
+	char *pos, *tmp, *cgpath;
+	unsigned int mask;
+	int ret;
+
+	tmp = memdup_user_nul(ubuf, count);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	pos = strstrip(tmp);
+	cgpath = strsep(&pos, " \t\n");
+	if (!cgpath || !*cgpath || !pos ||
+	    kstrtouint(skip_spaces(pos), 16, &mask))
+		ret = -EINVAL;
+	else
+		ret = swap_tiers_memcg_set(cgpath, mask);
+
+	kfree(tmp);
+	return ret ? ret : count;
+}
+
+static const struct file_operations swap_tiers_memcg_fops = {
+	.open		= swap_tiers_memcg_open,
+	.read		= seq_read,
+	.write		= swap_tiers_memcg_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int swap_tiers_show(struct seq_file *m, void *v)
+{
+	struct swap_tier *tier;
+
+	seq_printf(m, "%-5s %s\n", "Idx", "Prio");
+
+	spin_lock(&swap_lock);
+	for_each_active_tier(tier)
+		seq_printf(m, "%-5td %d\n", TIER_IDX(tier), tier->prio);
+	spin_unlock(&swap_lock);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(swap_tiers);
+
+static void swap_tiers_debugfs_init(void)
+{
+	struct dentry *dir = debugfs_create_dir("swap", NULL);
+
+	debugfs_create_file("tiers", 0400, dir, NULL, &swap_tiers_fops);
+	debugfs_create_file("memcg_tiers", 0600, dir, NULL,
+			    &swap_tiers_memcg_fops);
+}
+#endif
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index c4347c28d8f1..9967cfbcc439 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -9,16 +9,20 @@
 /* Forward declarations */
 struct swap_info_struct;
 
+#define TIER_ALL_MASK		(~0U)
+
 /*
  * struct swap_tier - structure representing a swap tier.
  *
  * @prio: priority of the swap devices in the tier.
+ * @nr_devs: swap devices in the tier, including ones being swapped off.
  * @active_head: swap devices in the tier.
  * @avail_head: available swap devices in the tier.
  * @list: linkage into swap_tier_active_list or swap_tier_inactive_list.
  */
 struct swap_tier {
 	short prio;
+	int nr_devs;
 	struct plist_head active_head;
 	struct plist_head avail_head;
 	struct list_head list;
@@ -35,6 +39,33 @@ void swap_tiers_init(void);
 /* Tier assignment */
 void swap_tiers_assign_dev(struct swap_info_struct *swp);
 void swap_tiers_remove_dev(struct swap_info_struct *swp);
+unsigned int swap_tiers_release_dev(struct swap_info_struct *swp);
 struct plist_head *swap_tiers_avail_head(struct swap_info_struct *swp);
 
+/**
+ * swap_tiers_mask_test - test whether two tier masks overlap
+ * @tier_mask: mask to test, e.g. a swap device's tier bit
+ * @mask: mask to test against, e.g. a cgroup's mask
+ *
+ * Return: true if @tier_mask and @mask share at least one tier bit.
+ */
+static inline bool swap_tiers_mask_test(unsigned int tier_mask,
+					unsigned int mask)
+{
+	return tier_mask & mask;
+}
+
+#if defined(CONFIG_MEMCG) && defined(CONFIG_DEBUG_FS)
+/* Memcg related functions */
+void swap_tiers_memcg_propagate(unsigned int mask);
+unsigned int folio_tier_mask(struct folio *folio);
+#else
+static inline void swap_tiers_memcg_propagate(unsigned int mask) {}
+
+static inline unsigned int folio_tier_mask(struct folio *folio)
+{
+	return TIER_ALL_MASK;
+}
+#endif
+
 #endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e9d142c0655b..bb953dd33ca0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3191,6 +3191,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	unsigned int maxpages;
+	unsigned int freed_tier;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3290,7 +3291,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
+	freed_tier = swap_tiers_release_dev(p);
 	spin_unlock(&swap_lock);
+	/* Under swapon_mutex, so a swapon cannot reuse the index before this. */
+	if (freed_tier)
+		swap_tiers_memcg_propagate(freed_tier);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
-- 
2.48.1

