From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v8 1/3] llist: Allow optional sentinel node terminated lockless list
Date: Tue,  4 Oct 2022 11:17:46 -0400
Message-ID: <20221004151748.293388-2-longman@redhat.com>
References: <20221004151748.293388-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664896684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDnUG6qKVLmHKsL0iwbk4ZwBTpd8xhf7h4SAaI6XFGE=;
        b=bTvdgjiGdQOIz73m9FYNqk0MXKcynbwOHBivtJmpvyZ78ahxy39PBAAn73mqmg5noNQ3CX
        wRkvVzOUR/EmbY/8xvvphGmE/DRG/gTWAW07KFZsBHVvlz1jyEOaiRiScqbaGmtXaD58VL
        8lXimklp2nXq8HsvoCkQVlUO6SQNnFE=
In-Reply-To: <20221004151748.293388-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The lockless list API is useful for dealing with list in a lockless
manner. However, one of the drawback of the existing API is that there
is not an easy way to determine if an entry has already been put into a
lockless list. This has to be tracked externally and the tracking will
not be atomic unless some external synchronization logic is in place.

This patch changes the internal of the lockless list code to allow it
to support a lockless list terminated by an internal sentinel value
(LLIST_END) instead of NULL. The advantage of this scheme is that
we can atomically determine if an entry has been put into a lockless
list by doing a NULL check of the next pointer of the llist_node. The
drawback is that a bit more code may be needed to handle both NULL and
the sentinel value. The real world performance impact of this change,
however, should be negligible.

To use a sentinel terminated lockless list, the following new API must
be used for initialization and deletion of a lockless list.

 - SLLIST_HEAD_INIT() and init_sllist_head() for initialization
 - sllist_del_all() and __llist_del_all() for deletion

Other llist APIs are modified to process both NULL or the sentinel
terminated lockless list.

Of course, the callers should clear the next pointer when an entry is
removed from a sentinel terminated lockless list. Note that the internal
LIST_END sentinel value will never be returned. NULL will always be
returned if the lockless list is empty for backward compatibility.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/llist.h | 100 +++++++++++++++++++++++++++++++++---------
 lib/llist.c           |  20 ++++++---
 2 files changed, 95 insertions(+), 25 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 85bda2d02d65..c7380e9b98e2 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -2,7 +2,8 @@
 #ifndef LLIST_H
 #define LLIST_H
 /*
- * Lock-less NULL terminated single linked list
+ * Lock-less NULL or sentinel terminated singly linked list
+ * --------------------------------------------------------
  *
  * Cases where locking is not needed:
  * If there are multiple producers and multiple consumers, llist_add can be
@@ -44,6 +45,15 @@
  * list can NOT be used in NMI handlers.  So code that uses the list in
  * an NMI handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
  *
+ * A sentinel node terminated lock-less list allows lock-list membership
+ * determination to be done atomically by doing a NULL check of the next
+ * pointer of the llist_node as it will never be NULL if it is in a lock-less
+ * list. The following APIs must be used for the initalization and deletion
+ * of a sentinel terminated lock-less list.
+ *
+ * - SLLIST_HEAD_INIT() and init_sllist_head() for initialization
+ * - sllist_del_all() and __llist_del_all() for deletion
+ *
  * Copyright 2010,2011 Intel Corp.
  *   Author: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  */
@@ -64,6 +74,16 @@ struct llist_node {
 #define LLIST_HEAD_INIT(name)	{ NULL }
 #define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
 
+/*
+ * Sentinel terminated llist_head initializer
+ *
+ * LLIST_END is chosen to be 1 so that a check for both NULL and LLIST_END
+ * can be optimized by the compiler to a single unsigned integer comparison.
+ */
+#define LLIST_END		((struct llist_node *)1UL)
+#define SLLIST_HEAD_INIT(name)	{ LLIST_END }
+#define SLLIST_HEAD(name)	struct llist_head name = SLLIST_HEAD_INIT(name)
+
 /**
  * init_llist_head - initialize lock-less list head
  * @head:	the head for your lock-less list
@@ -73,6 +93,15 @@ static inline void init_llist_head(struct llist_head *list)
 	list->first = NULL;
 }
 
+/**
+ * init_sllist_head - initialize sentinel terminated lock-less list head
+ * @head:	the head for your lock-less list
+ */
+static inline void init_sllist_head(struct llist_head *list)
+{
+	list->first = LLIST_END;
+}
+
 /**
  * llist_entry - get the struct of this entry
  * @ptr:	the &struct llist_node pointer.
@@ -83,21 +112,22 @@ static inline void init_llist_head(struct llist_head *list)
 	container_of(ptr, type, member)
 
 /**
- * member_address_is_nonnull - check whether the member address is not NULL
+ * member_address_is_valid - check whether member addr is not NULL or sentinel
  * @ptr:	the object pointer (struct type * that contains the llist_node)
  * @member:	the name of the llist_node within the struct.
  *
  * This macro is conceptually the same as
- *	&ptr->member != NULL
+ *	(&ptr->member != NULL) && (&ptr->member != LLIST_END)
  * but it works around the fact that compilers can decide that taking a member
- * address is never a NULL pointer.
+ * address is never a NULL or the sentinel pointer.
  *
- * Real objects that start at a high address and have a member at NULL are
- * unlikely to exist, but such pointers may be returned e.g. by the
- * container_of() macro.
+ * Real objects that start at a high address and have a member at NULL or
+ * LLIST_END are unlikely to exist, but such pointers may be returned e.g.
+ * by the container_of() macro.
  */
-#define member_address_is_nonnull(ptr, member)	\
-	((uintptr_t)(ptr) + offsetof(typeof(*(ptr)), member) != 0)
+#define member_address_is_valid(ptr, member)				       \
+	({ uintptr_t __n = (uintptr_t)(ptr) + offsetof(typeof(*(ptr)), member);\
+	   __n && (__n != (uintptr_t)LLIST_END); })
 
 /**
  * llist_for_each - iterate over some deleted entries of a lock-less list
@@ -114,7 +144,7 @@ static inline void init_llist_head(struct llist_head *list)
  * reverse the order by yourself before traversing.
  */
 #define llist_for_each(pos, node)			\
-	for ((pos) = (node); pos; (pos) = (pos)->next)
+	for ((pos) = (node); (pos) && (pos) != LLIST_END; (pos) = (pos)->next)
 
 /**
  * llist_for_each_safe - iterate over some deleted entries of a lock-less list
@@ -133,7 +163,8 @@ static inline void init_llist_head(struct llist_head *list)
  * reverse the order by yourself before traversing.
  */
 #define llist_for_each_safe(pos, n, node)			\
-	for ((pos) = (node); (pos) && ((n) = (pos)->next, true); (pos) = (n))
+	for ((pos) = (node); (pos) && ((pos) != LLIST_END) &&	\
+	     ((n) = (pos)->next, true); (pos) = (n))
 
 /**
  * llist_for_each_entry - iterate over some deleted entries of lock-less list of given type
@@ -152,7 +183,7 @@ static inline void init_llist_head(struct llist_head *list)
  */
 #define llist_for_each_entry(pos, node, member)				\
 	for ((pos) = llist_entry((node), typeof(*(pos)), member);	\
-	     member_address_is_nonnull(pos, member);			\
+	     member_address_is_valid(pos, member);			\
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
 /**
@@ -172,11 +203,11 @@ static inline void init_llist_head(struct llist_head *list)
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_entry_safe(pos, n, node, member)			       \
-	for (pos = llist_entry((node), typeof(*pos), member);		       \
-	     member_address_is_nonnull(pos, member) &&			       \
-	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
-	     pos = n)
+#define llist_for_each_entry_safe(pos, n, node, member)			   \
+	for (pos = llist_entry((node), typeof(*(pos)), member);		   \
+	     member_address_is_valid(pos, member) &&			   \
+		(n = llist_entry((pos)->member.next, typeof(*(n)), member),\
+		 true); pos = n)
 
 /**
  * llist_empty - tests whether a lock-less list is empty
@@ -188,12 +219,16 @@ static inline void init_llist_head(struct llist_head *list)
  */
 static inline bool llist_empty(const struct llist_head *head)
 {
-	return READ_ONCE(head->first) == NULL;
+	struct llist_node *first = READ_ONCE(head->first);
+
+	return !first || (first == LLIST_END);
 }
 
 static inline struct llist_node *llist_next(struct llist_node *node)
 {
-	return node->next;
+	struct llist_node *next = node->next;
+
+	return (next == LLIST_END) ? NULL : next;
 }
 
 extern bool llist_add_batch(struct llist_node *new_first,
@@ -204,9 +239,11 @@ static inline bool __llist_add_batch(struct llist_node *new_first,
 				     struct llist_node *new_last,
 				     struct llist_head *head)
 {
+	bool empty = llist_empty(head);
+
 	new_last->next = head->first;
 	head->first = new_first;
-	return new_last->next == NULL;
+	return empty;
 }
 
 /**
@@ -247,6 +284,29 @@ static inline struct llist_node *__llist_del_all(struct llist_head *head)
 	return first;
 }
 
+/**
+ * sllist_del_all - delete all entries from sentinel terminated lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.  The order of entries
+ * deleted is from the newest to the oldest added one.
+ */
+static inline struct llist_node *sllist_del_all(struct llist_head *head)
+{
+	struct llist_node *first = xchg(&head->first, LLIST_END);
+
+	return (first == LLIST_END) ? NULL : first;
+}
+
+static inline struct llist_node *__sllist_del_all(struct llist_head *head)
+{
+	struct llist_node *first = head->first;
+
+	head->first = LLIST_END;
+	return (first == LLIST_END) ? NULL : first;
+}
+
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
 struct llist_node *llist_reverse_order(struct llist_node *head);
diff --git a/lib/llist.c b/lib/llist.c
index 611ce4881a87..1e782c9cafa8 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Lock-less NULL terminated single linked list
+ * Lock-less NULL or sentinel terminated singly linked lists
  *
  * The basic atomic operation of this list is cmpxchg on long.  On
  * architectures that don't have NMI-safe cmpxchg implementation, the
@@ -14,7 +14,6 @@
 #include <linux/export.h>
 #include <linux/llist.h>
 
-
 /**
  * llist_add_batch - add several linked entries in batch
  * @new_first:	first entry in batch to be added
@@ -32,7 +31,7 @@ bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
 		new_last->next = first = READ_ONCE(head->first);
 	} while (cmpxchg(&head->first, first, new_first) != first);
 
-	return !first;
+	return !first || (first == LLIST_END);
 }
 EXPORT_SYMBOL_GPL(llist_add_batch);
 
@@ -56,7 +55,7 @@ struct llist_node *llist_del_first(struct llist_head *head)
 
 	entry = smp_load_acquire(&head->first);
 	for (;;) {
-		if (entry == NULL)
+		if (!entry || (entry == LLIST_END))
 			return NULL;
 		old_entry = entry;
 		next = READ_ONCE(entry->next);
@@ -79,14 +78,25 @@ EXPORT_SYMBOL_GPL(llist_del_first);
 struct llist_node *llist_reverse_order(struct llist_node *head)
 {
 	struct llist_node *new_head = NULL;
+	struct llist_node *new_tail = head;
+
+	if (!head || (head == LLIST_END))
+		return NULL;
 
-	while (head) {
+	while (head && (head != LLIST_END)) {
 		struct llist_node *tmp = head;
+
 		head = head->next;
 		tmp->next = new_head;
 		new_head = tmp;
 	}
 
+	/*
+	 * Terminate list with the same NULL or sentinel terminator
+	 */
+	if (head)
+		new_tail->next = LLIST_END;
+
 	return new_head;
 }
 EXPORT_SYMBOL_GPL(llist_reverse_order);
-- 
2.31.1

