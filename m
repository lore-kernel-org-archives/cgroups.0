From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9 v2] cgroup: implement generic child / descendant walk
 macros
Date: Thu, 8 Nov 2012 09:59:46 -0800
Message-ID: <20121108175946.GA9672@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nv/YZpAIJhtCzx5TrjA6HyD11ToAfE603IcP8difyqQ=;
        b=u2nK+Ygtt9TbSggNkyGhDN7rMDDcXtOqtM35E+/JU9oSKR9AX9Anirr/olqhlfMQow
         bmy1/0TbfRtVKNggyUWm0TuSQEVyrBjsBpuqr4zuGQ2UZDMtHi6+vptrptFT1NmdiJHy
         5McfQbVwHSyF9O3SyGcFbX8hRgp4GOQ6Lnx0+kDhQI/lTkLB7EdF7TSWmJDP8NfUewn6
         zcnBwJoW8I263F3jLyOdfbPWNLRznixoZhg+QMIGDi5JjxtTNHaCKz0y06Ho+WgScAHq
         3t/CH8rbO+gTqFc9B+ZmW7bdqt2sGTr+VFes/82KsT74RtbB03PrYYPKURL//voywk9G
         G6aw==
Content-Disposition: inline
In-Reply-To: <1351931915-1701-4-git-send-email-tj@kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

Currently, cgroup doesn't provide any generic helper for walking a
given cgroup's children or descendants.  This patch adds the following
three macros.

* cgroup_for_each_child() - walk immediate children of a cgroup.

* cgroup_for_each_descendant_pre() - visit all descendants of a cgroup
  in pre-order tree traversal.

* cgroup_for_each_descendant_post() - visit all descendants of a
  cgroup in post-order tree traversal.

All three only require the user to hold RCU read lock during
traversal.  Verifying that each iterated cgroup is online is the
responsibility of the user.  When used with proper synchronization,
cgroup_for_each_descendant_pre() can be used to propagate state
updates to descendants in reliable way.  See comments for details.

v2: s/config/state/ in commit message and comments per Michal.  More
    documentation on synchronization rules.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup.c        |   86 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -534,6 +534,100 @@ static inline struct cgroup* task_cgroup
 	return task_subsys_state(task, subsys_id)->cgroup;
 }
 
+/**
+ * cgroup_for_each_child - iterate through children of a cgroup
+ * @pos: the cgroup * to use as the loop cursor
+ * @cgroup: cgroup whose children to walk
+ *
+ * Walk @cgroup's children.  Must be called under rcu_read_lock().  A child
+ * cgroup which hasn't finished ->post_create() or already has finished
+ * ->pre_destroy() may show up during traversal and it's each subsystem's
+ * responsibility to verify that each @pos is alive.
+ *
+ * If a subsystem synchronizes against the parent in its ->post_create()
+ * and before starting iterating, a cgroup which finished ->post_create()
+ * is guaranteed to be visible in the future iterations.
+ */
+#define cgroup_for_each_child(pos, cgroup)				\
+	list_for_each_entry_rcu(pos, &(cgroup)->children, sibling)
+
+struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
+					  struct cgroup *cgroup);
+
+/**
+ * cgroup_for_each_descendant_pre - pre-order walk of a cgroup's descendants
+ * @pos: the cgroup * to use as the loop cursor
+ * @cgroup: cgroup whose descendants to walk
+ *
+ * Walk @cgroup's descendants.  Must be called under rcu_read_lock().  A
+ * descendant cgroup which hasn't finished ->post_create() or already has
+ * finished ->pre_destroy() may show up during traversal and it's each
+ * subsystem's responsibility to verify that each @pos is alive.
+ *
+ * If a subsystem synchronizes against the parent in its ->post_create()
+ * and before starting iterating, and synchronizes against @pos on each
+ * iteration, any descendant cgroup which finished ->post_create() is
+ * guaranteed to be visible in the future iterations.
+ *
+ * In other words, the following guarantees that a descendant can't escape
+ * state updates of its ancestors.
+ *
+ * my_post_create(@cgrp)
+ * {
+ *	Lock @cgrp->parent and @cgrp;
+ *	Inherit state from @cgrp->parent;
+ *	Unlock both.
+ * }
+ *
+ * my_update_state(@cgrp)
+ * {
+ *	Lock @cgrp;
+ *	Update @cgrp's state;
+ *	Unlock @cgrp;
+ *
+ *	cgroup_for_each_descendant_pre(@pos, @cgrp) {
+ *		Lock @pos;
+ *		Verify @pos is alive and inherit state from @pos->parent;
+ *		Unlock @pos;
+ *	}
+ * }
+ *
+ * As long as the inheriting step, including checking the parent state, is
+ * enclosed inside @pos locking, double-locking the parent isn't necessary
+ * while inheriting.  The state update to the parent is guaranteed to be
+ * visible by walking order and, as long as inheriting operations to the
+ * same @pos are atomic to each other, multiple updates racing each other
+ * still result in the correct state.  It's guaranateed that at least one
+ * inheritance happens for any cgroup after the latest update to its
+ * parent.
+ *
+ * If checking parent's state requires locking the parent, each inheriting
+ * iteration should lock and unlock both @pos->parent and @pos.
+ *
+ * Alternatively, a subsystem may choose to use a single global lock to
+ * synchronize ->post_create() and ->pre_destroy() against tree-walking
+ * operations.
+ */
+#define cgroup_for_each_descendant_pre(pos, cgroup)			\
+	for (pos = cgroup_next_descendant_pre(NULL, (cgroup)); (pos);	\
+	     pos = cgroup_next_descendant_pre((pos), (cgroup)))
+
+struct cgroup *cgroup_next_descendant_post(struct cgroup *pos,
+					   struct cgroup *cgroup);
+
+/**
+ * cgroup_for_each_descendant_post - post-order walk of a cgroup's descendants
+ * @pos: the cgroup * to use as the loop cursor
+ * @cgroup: cgroup whose descendants to walk
+ *
+ * Similar to cgroup_for_each_descendant_pre() but performs post-order
+ * traversal instead.  Note that the walk visibility guarantee described in
+ * pre-order walk doesn't apply the same to post-order walks.
+ */
+#define cgroup_for_each_descendant_post(pos, cgroup)			\
+	for (pos = cgroup_next_descendant_post(NULL, (cgroup)); (pos);	\
+	     pos = cgroup_next_descendant_post((pos), (cgroup)))
+
 /* A cgroup_iter should be treated as an opaque object */
 struct cgroup_iter {
 	struct list_head *cg_link;
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2984,6 +2984,92 @@ static void cgroup_enable_task_cg_lists(
 	write_unlock(&css_set_lock);
 }
 
+/**
+ * cgroup_next_descendant_pre - find the next descendant for pre-order walk
+ * @pos: the current position (%NULL to initiate traversal)
+ * @cgroup: cgroup whose descendants to walk
+ *
+ * To be used by cgroup_for_each_descendant_pre().  Find the next
+ * descendant to visit for pre-order traversal of @cgroup's descendants.
+ */
+struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
+					  struct cgroup *cgroup)
+{
+	struct cgroup *next;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	/* if first iteration, pretend we just visited @cgroup */
+	if (!pos) {
+		if (list_empty(&cgroup->children))
+			return NULL;
+		pos = cgroup;
+	}
+
+	/* visit the first child if exists */
+	next = list_first_or_null_rcu(&pos->children, struct cgroup, sibling);
+	if (next)
+		return next;
+
+	/* no child, visit my or the closest ancestor's next sibling */
+	do {
+		next = list_entry_rcu(pos->sibling.next, struct cgroup,
+				      sibling);
+		if (&next->sibling != &pos->parent->children)
+			return next;
+
+		pos = pos->parent;
+	} while (pos != cgroup);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(cgroup_next_descendant_pre);
+
+static struct cgroup *cgroup_leftmost_descendant(struct cgroup *pos)
+{
+	struct cgroup *last;
+
+	do {
+		last = pos;
+		pos = list_first_or_null_rcu(&pos->children, struct cgroup,
+					     sibling);
+	} while (pos);
+
+	return last;
+}
+
+/**
+ * cgroup_next_descendant_post - find the next descendant for post-order walk
+ * @pos: the current position (%NULL to initiate traversal)
+ * @cgroup: cgroup whose descendants to walk
+ *
+ * To be used by cgroup_for_each_descendant_post().  Find the next
+ * descendant to visit for post-order traversal of @cgroup's descendants.
+ */
+struct cgroup *cgroup_next_descendant_post(struct cgroup *pos,
+					   struct cgroup *cgroup)
+{
+	struct cgroup *next;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	/* if first iteration, visit the leftmost descendant */
+	if (!pos) {
+		next = cgroup_leftmost_descendant(cgroup);
+		return next != cgroup ? next : NULL;
+	}
+
+	/* if there's an unvisited sibling, visit its leftmost descendant */
+	next = list_entry_rcu(pos->sibling.next, struct cgroup, sibling);
+	if (&next->sibling != &pos->parent->children)
+		return cgroup_leftmost_descendant(next);
+
+	/* no sibling left, visit parent */
+	next = pos->parent;
+	return next != cgroup ? next : NULL;
+}
+EXPORT_SYMBOL_GPL(cgroup_next_descendant_post);
+
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
 	__acquires(css_set_lock)
 {
