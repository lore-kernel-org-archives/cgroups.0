From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/14] cgroup: iterate cgroup_subsys_states directly
Date: Fri,  9 May 2014 17:31:27 -0400
Message-ID: <1399671091-23867-11-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I2Tp9pwApF4twwGZ9j70LIUrMPozlMeXqVq1ZyW6nGI=;
        b=HwRjn//OHTwpWnb9bX2RtblClrKNamTf9TEZGrcLNCRkurRrLxLd9CYAotvIHNXoaQ
         4D7RakcKSdbHqFzH+4A3qrLymSznuT/j+e7hCM4q9pqnsw6kRa22p//yE/QDIPcpRx8x
         rpJD+g+x1hoHrLt0foHuq7Qr5a7RGfQ9PcWL75doQ2khwCbi1LQoTDmiwKqwjf5OateP
         SWmzve5YKK5qsVgnhsJaZ9Zawbe9+5mAwgIvRblSHn3zFsAHlAgbk4lMITJjV7l8/4bD
         3WrhY7mmTKhGWmgH5PtKSIY2s62W2dZQKdDBnWb0K0hoeMNJUgaloF4DtH54DB3SIxRg
         GbRQ==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

Currently, css_next_child() is implemented as finding the next child
cgroup which has the css enabled, which used to be the only way to do
it as only cgroups participated in sibling lists and thus could be
iteratd.  This works as long as what's required during iteration is
not missing online csses; however, it turns out that there are use
cases where offlined but not yet released csses need to be iterated.
This is difficult to implement through cgroup iteration the unified
hierarchy as there may be multiple dying csses for the same subsystem
associated with single cgroup.

After the recent changes, the cgroup self and regular csses behave
identically in how they're linked and unlinked from the sibling lists
including assertion of CSS_RELEASED and css_next_child() can simply
switch to iterating csses directly.  This both simplifies the logic
and ensures that all visible non-released csses are included in the
iteration whether there are multiple dying csses for a subsystem or
not.

As all other iterators depend on css_next_child() for sibling
iteration, this changes behaviors of all css iterators.  Add and
update explanations on the css states which are included in traversal
to all iterators.

As css iteration could always contain offlined csses, this shouldn't
break any of the current users and new usages which need iteration of
all on and offline csses can make use of the new semantics.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/cgroup.h | 44 ++++++++++++++++++++---------------
 kernel/cgroup.c        | 62 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 634ecc1..58867ed 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -759,14 +759,14 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
  * @pos: the css * to use as the loop cursor
  * @parent: css whose children to walk
  *
- * Walk @parent's children.  Must be called under rcu_read_lock().  A child
- * css which hasn't finished ->css_online() or already has finished
- * ->css_offline() may show up during traversal and it's each subsystem's
- * responsibility to verify that each @pos is alive.
+ * Walk @parent's children.  Must be called under rcu_read_lock().
  *
- * If a subsystem synchronizes against the parent in its ->css_online() and
- * before starting iterating, a css which finished ->css_online() is
- * guaranteed to be visible in the future iterations.
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
  *
  * It is allowed to temporarily drop RCU read lock during iteration.  The
  * caller is responsible for ensuring that @pos remains accessible until
@@ -789,17 +789,16 @@ css_rightmost_descendant(struct cgroup_subsys_state *pos);
  * @root: css whose descendants to walk
  *
  * Walk @root's descendants.  @root is included in the iteration and the
- * first node to be visited.  Must be called under rcu_read_lock().  A
- * descendant css which hasn't finished ->css_online() or already has
- * finished ->css_offline() may show up during traversal and it's each
- * subsystem's responsibility to verify that each @pos is alive.
+ * first node to be visited.  Must be called under rcu_read_lock().
  *
- * If a subsystem synchronizes against the parent in its ->css_online() and
- * before starting iterating, and synchronizes against @pos on each
- * iteration, any descendant css which finished ->css_online() is
- * guaranteed to be visible in the future iterations.
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
  *
- * In other words, the following guarantees that a descendant can't escape
+ * For example, the following guarantees that a descendant can't escape
  * state updates of its ancestors.
  *
  * my_online(@css)
@@ -855,8 +854,17 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
  *
  * Similar to css_for_each_descendant_pre() but performs post-order
  * traversal instead.  @root is included in the iteration and the last
- * node to be visited.  Note that the walk visibility guarantee described
- * in pre-order walk doesn't apply the same to post-order walks.
+ * node to be visited.
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
+ *
+ * Note that the walk visibility guarantee example described in pre-order
+ * walk doesn't apply the same to post-order walks.
  */
 #define css_for_each_descendant_post(pos, css)				\
 	for ((pos) = css_next_descendant_post(NULL, (css)); (pos);	\
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index eaea062..e0953f7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3088,21 +3088,25 @@ static int cgroup_task_count(const struct cgroup *cgrp)
 
 /**
  * css_next_child - find the next child of a given css
- * @pos_css: the current position (%NULL to initiate traversal)
- * @parent_css: css whose children to walk
+ * @pos: the current position (%NULL to initiate traversal)
+ * @parent: css whose children to walk
  *
- * This function returns the next child of @parent_css and should be called
+ * This function returns the next child of @parent and should be called
  * under either cgroup_mutex or RCU read lock.  The only requirement is
- * that @parent_css and @pos_css are accessible.  The next sibling is
- * guaranteed to be returned regardless of their states.
+ * that @parent and @pos are accessible.  The next sibling is guaranteed to
+ * be returned regardless of their states.
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
  */
-struct cgroup_subsys_state *
-css_next_child(struct cgroup_subsys_state *pos_css,
-	       struct cgroup_subsys_state *parent_css)
+struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
+					   struct cgroup_subsys_state *parent)
 {
-	struct cgroup *pos = pos_css ? pos_css->cgroup : NULL;
-	struct cgroup *cgrp = parent_css->cgroup;
-	struct cgroup *next;
+	struct cgroup_subsys_state *next;
 
 	cgroup_assert_mutex_or_rcu_locked();
 
@@ -3127,27 +3131,21 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	 * races against release and the race window is very small.
 	 */
 	if (!pos) {
-		next = list_entry_rcu(cgrp->self.children.next, struct cgroup, self.sibling);
-	} else if (likely(!(pos->self.flags & CSS_RELEASED))) {
-		next = list_entry_rcu(pos->self.sibling.next, struct cgroup, self.sibling);
+		next = list_entry_rcu(parent->children.next, struct cgroup_subsys_state, sibling);
+	} else if (likely(!(pos->flags & CSS_RELEASED))) {
+		next = list_entry_rcu(pos->sibling.next, struct cgroup_subsys_state, sibling);
 	} else {
-		list_for_each_entry_rcu(next, &cgrp->self.children, self.sibling)
-			if (next->self.serial_nr > pos->self.serial_nr)
+		list_for_each_entry_rcu(next, &parent->children, sibling)
+			if (next->serial_nr > pos->serial_nr)
 				break;
 	}
 
 	/*
 	 * @next, if not pointing to the head, can be dereferenced and is
-	 * the next sibling; however, it might have @ss disabled.  If so,
-	 * fast-forward to the next enabled one.
+	 * the next sibling.
 	 */
-	while (&next->self.sibling != &cgrp->self.children) {
-		struct cgroup_subsys_state *next_css = cgroup_css(next, parent_css->ss);
-
-		if (next_css)
-			return next_css;
-		next = list_entry_rcu(next->self.sibling.next, struct cgroup, self.sibling);
-	}
+	if (&next->sibling != &parent->children)
+		return next;
 	return NULL;
 }
 
@@ -3164,6 +3162,13 @@ css_next_child(struct cgroup_subsys_state *pos_css,
  * doesn't require the whole traversal to be contained in a single critical
  * section.  This function will return the correct next descendant as long
  * as both @pos and @root are accessible and @pos is a descendant of @root.
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
  */
 struct cgroup_subsys_state *
 css_next_descendant_pre(struct cgroup_subsys_state *pos,
@@ -3251,6 +3256,13 @@ css_leftmost_descendant(struct cgroup_subsys_state *pos)
  * section.  This function will return the correct next descendant as long
  * as both @pos and @cgroup are accessible and @pos is a descendant of
  * @cgroup.
+ *
+ * If a subsystem synchronizes ->css_online() and the start of iteration, a
+ * css which finished ->css_online() is guaranteed to be visible in the
+ * future iterations and will stay visible until the last reference is put.
+ * A css which hasn't finished ->css_online() or already finished
+ * ->css_offline() may show up during traversal.  It's each subsystem's
+ * responsibility to synchronize against on/offlining.
  */
 struct cgroup_subsys_state *
 css_next_descendant_post(struct cgroup_subsys_state *pos,
-- 
1.9.0
