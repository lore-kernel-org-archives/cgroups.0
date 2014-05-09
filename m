From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] cgroup: move cgroup->serial_nr into cgroup_subsys_state
Date: Fri,  9 May 2014 17:31:25 -0400
Message-ID: <1399671091-23867-9-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XHf6R49wdcvy85zTvtvpc2g9XbnCjDLLVjL69g51ZGo=;
        b=lObzEwriX14Ru7SDapRqARx2bLQBO2CTQEohU23O4juKspWrR/Pan4nwlxtP7b2Avs
         Odmr1g7SA5XehVLNGBweiootlvu3fgyiCz8k3zoit2whVz9a5As26ofzuMqyOXsOFlaL
         h3URA64WggjKW9dqy6aXlVJspm9CS7aCA0unnQV6Z1qhsKirk+SLgJGG1iQXLNLCBEaf
         kQz+RhHgc8nlaDfNqUmD+I3M/dDTMnkzFrTdRl0/leaWTCffdDQ39yVgGAkKU/RXwpYX
         9aTiRCli7M1pP0oQt7NtzCQg9wHJxF0IVNPz8OfIIq2O1M+StqcQJevCotxW+27BSJhq
         7Vfw==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

We're moving towards using cgroup_subsys_states as the fundamental
structural blocks.  All csses including the cgroup->self and actual
ones now form trees through css->children and ->sibling which follow
the same rules as what cgroup->children and ->sibling followed.  This
patch moves cgroup->serial_nr which is used to implement css iteration
into css.

Note that all csses, regardless of their types, allocate their serial
numbers from the same monotonically increasing counter.  This doesn't
affect the ordering needed by css iteration or cause any other
material behavior changes.  This will be used to update css iteration.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 16 ++++++++--------
 kernel/cgroup.c        | 20 +++++++++++---------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index db8d8c2..e65cc0f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -80,6 +80,14 @@ struct cgroup_subsys_state {
 
 	unsigned int flags;
 
+	/*
+	 * Monotonically increasing unique serial number which defines a
+	 * uniform order among all csses.  It's guaranteed that all
+	 * ->children lists are in the ascending order of ->serial_nr and
+	 * used to allow interrupting and resuming iterations.
+	 */
+	u64 serial_nr;
+
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
 	struct work_struct destroy_work;
@@ -173,14 +181,6 @@ struct cgroup {
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
-	/*
-	 * Monotonically increasing unique serial number which defines a
-	 * uniform order among all cgroups.  It's guaranteed that all
-	 * ->children lists are in the ascending order of ->serial_nr.
-	 * It's used to allow interrupting and resuming iterations.
-	 */
-	u64 serial_nr;
-
 	/* the bitmask of subsystems enabled on the child cgroups */
 	unsigned int child_subsys_mask;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6930b78..3eda323 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -157,14 +157,13 @@ static int cgroup_root_count;
 static DEFINE_IDR(cgroup_hierarchy_idr);
 
 /*
- * Assign a monotonically increasing serial number to cgroups.  It
- * guarantees cgroups with bigger numbers are newer than those with smaller
- * numbers.  Also, as cgroups are always appended to the parent's
- * ->children list, it guarantees that sibling cgroups are always sorted in
- * the ascending serial number order on the list.  Protected by
- * cgroup_mutex.
+ * Assign a monotonically increasing serial number to csses.  It guarantees
+ * cgroups with bigger numbers are newer than those with smaller numbers.
+ * Also, as csses are always appended to the parent's ->children list, it
+ * guarantees that sibling csses are always sorted in the ascending serial
+ * number order on the list.  Protected by cgroup_mutex.
  */
-static u64 cgroup_serial_nr_next = 1;
+static u64 css_serial_nr_next = 1;
 
 /* This flag indicates whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
@@ -3132,7 +3131,7 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 		next = list_entry_rcu(pos->self.sibling.next, struct cgroup, self.sibling);
 	} else {
 		list_for_each_entry_rcu(next, &cgrp->self.children, self.sibling)
-			if (next->serial_nr > pos->serial_nr)
+			if (next->self.serial_nr > pos->self.serial_nr)
 				break;
 	}
 
@@ -4167,6 +4166,8 @@ static void css_release(struct percpu_ref *ref)
 static void init_and_link_css(struct cgroup_subsys_state *css,
 			      struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
+	lockdep_assert_held(&cgroup_mutex);
+
 	cgroup_get(cgrp);
 
 	memset(css, 0, sizeof(*css));
@@ -4174,6 +4175,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	css->ss = ss;
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
+	css->serial_nr = css_serial_nr_next++;
 
 	if (cgroup_parent(cgrp)) {
 		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
@@ -4347,7 +4349,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 */
 	kernfs_get(kn);
 
-	cgrp->serial_nr = cgroup_serial_nr_next++;
+	cgrp->self.serial_nr = css_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
 	list_add_tail_rcu(&cgrp->self.sibling, &cgroup_parent(cgrp)->self.children);
-- 
1.9.0
