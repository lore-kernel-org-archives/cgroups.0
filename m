From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v8 08/34] list: add a new LRU list type
Date: Fri, 24 May 2013 15:59:02 +0530
Message-ID: <1369391368-31562-9-git-send-email-glommer@openvz.org>
References: <1369391368-31562-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369391368-31562-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Several subsystems use the same construct for LRU lists - a list
head, a spin lock and and item count. They also use exactly the same
code for adding and removing items from the LRU. Create a generic
type for these LRU lists.

This is the beginning of generic, node aware LRUs for shrinkers to
work with.

[ glommer: enum defined constants for lru. Suggested by gthelen,
  don't relock over retry ]
Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 include/linux/list_lru.h |  46 ++++++++++++++++++
 lib/Makefile             |   2 +-
 lib/list_lru.c           | 122 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/list_lru.h
 create mode 100644 lib/list_lru.c

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
new file mode 100644
index 0000000..4f82a57
--- /dev/null
+++ b/include/linux/list_lru.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2010-2012 Red Hat, Inc. All rights reserved.
+ * Author: David Chinner
+ *
+ * Generic LRU infrastructure
+ */
+#ifndef _LRU_LIST_H
+#define _LRU_LIST_H
+
+#include <linux/list.h>
+
+enum lru_status {
+	LRU_REMOVED,		/* item removed from list */
+	LRU_ROTATE,		/* item referenced, give another pass */
+	LRU_SKIP,		/* item cannot be locked, skip */
+	LRU_RETRY,		/* item not freeable. May drop the lock
+				   internally, but has to return locked. */
+};
+
+struct list_lru {
+	spinlock_t		lock;
+	struct list_head	list;
+	long			nr_items;
+};
+
+int list_lru_init(struct list_lru *lru);
+int list_lru_add(struct list_lru *lru, struct list_head *item);
+int list_lru_del(struct list_lru *lru, struct list_head *item);
+
+static inline unsigned long list_lru_count(struct list_lru *lru)
+{
+	return lru->nr_items;
+}
+
+typedef enum lru_status
+(*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
+
+typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
+
+unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+		   void *cb_arg, unsigned long nr_to_walk);
+
+unsigned long
+list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
+
+#endif /* _LRU_LIST_H */
diff --git a/lib/Makefile b/lib/Makefile
index 3eacb2c..dbeb899 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o
+	 earlycpio.o percpu-refcount.o list_lru.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/list_lru.c b/lib/list_lru.c
new file mode 100644
index 0000000..3127edd
--- /dev/null
+++ b/lib/list_lru.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (c) 2010-2012 Red Hat, Inc. All rights reserved.
+ * Author: David Chinner
+ *
+ * Generic LRU infrastructure
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list_lru.h>
+
+int
+list_lru_add(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (list_empty(item)) {
+		list_add_tail(item, &lru->list);
+		lru->nr_items++;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_add);
+
+int
+list_lru_del(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (!list_empty(item)) {
+		list_del_init(item);
+		lru->nr_items--;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_del);
+
+unsigned long
+list_lru_walk(
+	struct list_lru *lru,
+	list_lru_walk_cb isolate,
+	void		*cb_arg,
+	unsigned long	nr_to_walk)
+{
+	struct list_head *item, *n;
+	unsigned long removed = 0;
+
+	spin_lock(&lru->lock);
+	list_for_each_safe(item, n, &lru->list) {
+		enum lru_status ret;
+		bool first_pass = true;
+restart:
+		ret = isolate(item, &lru->lock, cb_arg);
+		switch (ret) {
+		case LRU_REMOVED:
+			lru->nr_items--;
+			removed++;
+			break;
+		case LRU_ROTATE:
+			list_move_tail(item, &lru->list);
+			break;
+		case LRU_SKIP:
+			break;
+		case LRU_RETRY:
+			if (!first_pass)
+				break;
+			first_pass = false;
+			goto restart;
+		default:
+			BUG();
+		}
+
+		if (nr_to_walk-- == 0)
+			break;
+
+	}
+	spin_unlock(&lru->lock);
+	return removed;
+}
+EXPORT_SYMBOL_GPL(list_lru_walk);
+
+unsigned long
+list_lru_dispose_all(
+	struct list_lru *lru,
+	list_lru_dispose_cb dispose)
+{
+	unsigned long disposed = 0;
+	LIST_HEAD(dispose_list);
+
+	spin_lock(&lru->lock);
+	while (!list_empty(&lru->list)) {
+		list_splice_init(&lru->list, &dispose_list);
+		disposed += lru->nr_items;
+		lru->nr_items = 0;
+		spin_unlock(&lru->lock);
+
+		dispose(&dispose_list);
+
+		spin_lock(&lru->lock);
+	}
+	spin_unlock(&lru->lock);
+	return disposed;
+}
+
+int
+list_lru_init(
+	struct list_lru	*lru)
+{
+	spin_lock_init(&lru->lock);
+	INIT_LIST_HEAD(&lru->list);
+	lru->nr_items = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_init);
-- 
1.8.1.4
