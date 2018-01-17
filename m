From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 78/99] sh: intc: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:42 -0800
Message-ID: <20180117202203.19756-79-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=dMmQH2kHjjOa16pkYOdU1wgqtUGiT/uWNr9dt65hu+s=; b=hsV5P1O5ZYQJlIu4Q8zFdZFfj7
 AUARsbJAKdzCeXPkp0UJ3tpRoFrmrVBYHn3N0M5vNBC/8ont4oqSglZFB95/RGdQBlkFgm4Ak7V1N
 Td70p3IWiYUM3/rwR7D8M38zRqKGcP0/bA8Y7a9mmnb4xHuUmSmXEM6524AY0ztQeDEI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=dMmQH2kHjjOa16pkYOdU1wgqtUGiT/uWNr9dt65hu+s=; b=WmHUZrbNCFiKvHrDzPduXuf4ta
 HZWojrIo1V6enGju1SonG8tpld6g4QvqroQWXE6VSw+pA0pCddRYzxKUFzNQfSpGIBe4M9QZA1mBG
 bWAvuSyPrIgGOWO5B7NQchXj+E8bbg886fsDcjmapSv2EnOzDlJhl4b2oQBzQJPyJ7eY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=dMmQH2kHjjOa16pkYOdU1wgqtUGiT/uWNr9dt65hu+s=; b=Z5HwbJq+WvZ17baDIq63sXVlp
 JVwvHXByxRp4BFajgsSY2DUEvl80qyvZvhEcU3ZmC2gRpCdmiUKDD/+ux6zHxZ9rqc7p1rxJo5nz8
 XP+PIn2FFUC8y1gxVF+6B2/MWY0wv6MWZLTH/vZK89LybM/5sZSN4YauDexE1DwhoJoi5gXlTCY1F
 jkSOL5vf/vc5S4Mvkz0kSEfE/TlhtHWa1x0n+3uJYohkJnWNOsT/FJ2OOBw49wMJIvBTYvv5e23zQ
 w+ejeudjqCGq7mWLWkV745jkOevwKzzZCIUMysgMKx+TTPoseudlmEaiVvPWnoJjLEUIP2eF42NVW
 3pUb2wDjw==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The radix tree was being protected by a raw spinlock.  I believe that
was not necessary, and the new internal regular spinlock will be
adequate for this array.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/sh/intc/core.c      |  9 ++----
 drivers/sh/intc/internals.h |  5 ++--
 drivers/sh/intc/virq.c      | 72 +++++++++++++--------------------------------
 3 files changed, 25 insertions(+), 61 deletions(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 8e72bcbd3d6d..356a423d9dcb 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -30,7 +30,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-#include <linux/radix-tree.h>
 #include <linux/export.h>
 #include <linux/sort.h>
 #include "internals.h"
@@ -78,11 +77,8 @@ static void __init intc_register_irq(struct intc_desc *desc,
 	struct intc_handle_int *hp;
 	struct irq_data *irq_data;
 	unsigned int data[2], primary;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&intc_big_lock, flags);
-	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
-	raw_spin_unlock_irqrestore(&intc_big_lock, flags);
+	xa_store(&d->array, enum_id, intc_irq_xlate_get(irq), GFP_ATOMIC);
 
 	/*
 	 * Prefer single interrupt source bitmap over other combinations:
@@ -196,8 +192,7 @@ int __init register_intc_controller(struct intc_desc *desc)
 	INIT_LIST_HEAD(&d->list);
 	list_add_tail(&d->list, &intc_list);
 
-	raw_spin_lock_init(&d->lock);
-	INIT_RADIX_TREE(&d->tree, GFP_ATOMIC);
+	xa_init(&d->array);
 
 	d->index = nr_intc_controllers;
 
diff --git a/drivers/sh/intc/internals.h b/drivers/sh/intc/internals.h
index fa73c173b56a..9b6fd07e99a6 100644
--- a/drivers/sh/intc/internals.h
+++ b/drivers/sh/intc/internals.h
@@ -5,7 +5,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <linux/device.h>
 
 #define _INTC_MK(fn, mode, addr_e, addr_d, width, shift) \
@@ -54,8 +54,7 @@ struct intc_subgroup_entry {
 struct intc_desc_int {
 	struct list_head list;
 	struct device dev;
-	struct radix_tree_root tree;
-	raw_spinlock_t lock;
+	struct xarray array;
 	unsigned int index;
 	unsigned long *reg;
 #ifdef CONFIG_SMP
diff --git a/drivers/sh/intc/virq.c b/drivers/sh/intc/virq.c
index a638c3048207..801c9c8b7556 100644
--- a/drivers/sh/intc/virq.c
+++ b/drivers/sh/intc/virq.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/irq.h>
 #include <linux/list.h>
-#include <linux/radix-tree.h>
 #include <linux/spinlock.h>
 #include <linux/export.h>
 #include "internals.h"
@@ -27,10 +26,7 @@ struct intc_virq_list {
 #define for_each_virq(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-/*
- * Tags for the radix tree
- */
-#define INTC_TAG_VIRQ_NEEDS_ALLOC	0
+#define INTC_TAG_VIRQ_NEEDS_ALLOC	XA_TAG_0
 
 void intc_irq_xlate_set(unsigned int irq, intc_enum id, struct intc_desc_int *d)
 {
@@ -54,23 +50,18 @@ int intc_irq_lookup(const char *chipname, intc_enum enum_id)
 	int irq = -1;
 
 	list_for_each_entry(d, &intc_list, list) {
-		int tagged;
-
 		if (strcmp(d->chip.name, chipname) != 0)
 			continue;
 
 		/*
 		 * Catch early lookups for subgroup VIRQs that have not
-		 * yet been allocated an IRQ. This already includes a
-		 * fast-path out if the tree is untagged, so there is no
-		 * need to explicitly test the root tree.
+		 * yet been allocated an IRQ.
 		 */
-		tagged = radix_tree_tag_get(&d->tree, enum_id,
-					    INTC_TAG_VIRQ_NEEDS_ALLOC);
-		if (unlikely(tagged))
+		if (unlikely(xa_get_tag(&d->array, enum_id,
+						INTC_TAG_VIRQ_NEEDS_ALLOC)))
 			break;
 
-		ptr = radix_tree_lookup(&d->tree, enum_id);
+		ptr = xa_load(&d->array, enum_id);
 		if (ptr) {
 			irq = ptr - intc_irq_xlate;
 			break;
@@ -148,22 +139,16 @@ static void __init intc_subgroup_init_one(struct intc_desc *desc,
 {
 	struct intc_map_entry *mapped;
 	unsigned int pirq;
-	unsigned long flags;
 	int i;
 
-	mapped = radix_tree_lookup(&d->tree, subgroup->parent_id);
-	if (!mapped) {
-		WARN_ON(1);
+	mapped = xa_load(&d->array, subgroup->parent_id);
+	if (WARN_ON(!mapped))
 		return;
-	}
 
 	pirq = mapped - intc_irq_xlate;
 
-	raw_spin_lock_irqsave(&d->lock, flags);
-
 	for (i = 0; i < ARRAY_SIZE(subgroup->enum_ids); i++) {
 		struct intc_subgroup_entry *entry;
-		int err;
 
 		if (!subgroup->enum_ids[i])
 			continue;
@@ -176,15 +161,14 @@ static void __init intc_subgroup_init_one(struct intc_desc *desc,
 		entry->enum_id = subgroup->enum_ids[i];
 		entry->handle = intc_subgroup_data(subgroup, d, i);
 
-		err = radix_tree_insert(&d->tree, entry->enum_id, entry);
-		if (unlikely(err < 0))
+		if (xa_err(xa_store(&d->array, entry->enum_id, entry,
+						GFP_NOWAIT))) {
+			kfree(entry);
 			break;
-
-		radix_tree_tag_set(&d->tree, entry->enum_id,
+		}
+		xa_set_tag(&d->array, entry->enum_id,
 				   INTC_TAG_VIRQ_NEEDS_ALLOC);
 	}
-
-	raw_spin_unlock_irqrestore(&d->lock, flags);
 }
 
 void __init intc_subgroup_init(struct intc_desc *desc, struct intc_desc_int *d)
@@ -201,28 +185,16 @@ void __init intc_subgroup_init(struct intc_desc *desc, struct intc_desc_int *d)
 static void __init intc_subgroup_map(struct intc_desc_int *d)
 {
 	struct intc_subgroup_entry *entries[32];
-	unsigned long flags;
 	unsigned int nr_found;
 	int i;
 
-	raw_spin_lock_irqsave(&d->lock, flags);
-
-restart:
-	nr_found = radix_tree_gang_lookup_tag_slot(&d->tree,
-			(void ***)entries, 0, ARRAY_SIZE(entries),
-			INTC_TAG_VIRQ_NEEDS_ALLOC);
+	nr_found = xa_extract(&d->array, (void **)entries, 0, ULONG_MAX,
+			ARRAY_SIZE(entries), INTC_TAG_VIRQ_NEEDS_ALLOC);
 
 	for (i = 0; i < nr_found; i++) {
-		struct intc_subgroup_entry *entry;
-		int irq;
+		struct intc_subgroup_entry *entry = entries[i];
+		int irq = irq_alloc_desc(numa_node_id());
 
-		entry = radix_tree_deref_slot((void **)entries[i]);
-		if (unlikely(!entry))
-			continue;
-		if (radix_tree_deref_retry(entry))
-			goto restart;
-
-		irq = irq_alloc_desc(numa_node_id());
 		if (unlikely(irq < 0)) {
 			pr_err("no more free IRQs, bailing..\n");
 			break;
@@ -250,13 +222,11 @@ static void __init intc_subgroup_map(struct intc_desc_int *d)
 		add_virq_to_pirq(entry->pirq, irq);
 		irq_set_chained_handler(entry->pirq, intc_virq_handler);
 
-		radix_tree_tag_clear(&d->tree, entry->enum_id,
-				     INTC_TAG_VIRQ_NEEDS_ALLOC);
-		radix_tree_replace_slot(&d->tree, (void **)entries[i],
-					&intc_irq_xlate[irq]);
+		xa_store(&d->array, entry->enum_id, &intc_irq_xlate[irq],
+				GFP_NOWAIT);
+		xa_clear_tag(&d->array, entry->enum_id,
+				INTC_TAG_VIRQ_NEEDS_ALLOC);
 	}
-
-	raw_spin_unlock_irqrestore(&d->lock, flags);
 }
 
 void __init intc_finalize(void)
@@ -264,6 +234,6 @@ void __init intc_finalize(void)
 	struct intc_desc_int *d;
 
 	list_for_each_entry(d, &intc_list, list)
-		if (radix_tree_tagged(&d->tree, INTC_TAG_VIRQ_NEEDS_ALLOC))
+		if (xa_tagged(&d->array, INTC_TAG_VIRQ_NEEDS_ALLOC))
 			intc_subgroup_map(d);
 }
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
