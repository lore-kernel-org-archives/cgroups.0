From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] cgroup: introduce cgroup->proc_cgrp and threaded css_set handling
Date: Sat, 10 Jun 2017 10:03:46 -0400
Message-ID: <20170610140351.10703-6-tj@kernel.org>
References: <20170610140351.10703-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O2HWS9hD1OY6v+traEbn34rIXstLDka5UBgMpgrLpKE=;
        b=E3asb91377FuHWd3Dg8jitBvDu9Xfob65h0sEMDtN3I+K5jrKShJDdcMHVY818BxnK
         SBCSTcTkB7xrWmzMeFc9d3nb/93P7kUEcHdYW/qk+/PgHSY7gVXUhDke4VlTvttur0c4
         7SoE0S88jNlpXc+1no0RGbux8EexKOuf6UnkFwGl3gqwRemo7kPHfolK9flIKZqLUi0M
         lR5zGxjO6N94d+pPLmTeUoTTH3Tw+vUdrxsDZkJtXBPaAYmk8MmNvZwkuDGSUAQ3SI6a
         iO9o9MkFqhTmL9okZBfOM7vmD66G1hYO8JTjpFng6vgtfc3SZBA/uvW7u5RuVHFLBvuN
         am6Q==
In-Reply-To: <20170610140351.10703-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Tejun Heo <tj@kernel.org>

cgroup v2 is in the process of growing thread granularity support.
Once thread mode is enabled, the root cgroup of the subtree serves as
the proc_cgrp to which the processes of the subtree conceptually
belong and domain-level resource consumptions not tied to any specific
task are charged.  In the subtree, threads won't be subject to process
granularity or no-internal-task constraint and can be distributed
arbitrarily across the subtree.

This patch introduces cgroup->proc_cgrp along with threaded css_set
handling.

* cgroup->proc_cgrp is NULL if !threaded.  If threaded, points to the
  proc_cgrp (root of the threaded subtree).

* css_set->proc_cset points to self if !threaded.  If threaded, points
  to the css_set which belongs to the cgrp->proc_cgrp.  The proc_cgrp
  serves as the resource domain and needs the matching csses readily
  available.  The proc_cset holds those csses and makes them easily
  accessible.

* All threaded csets are linked on their proc_csets to enable
  iteration of all threaded tasks.

This patch adds the above but doesn't actually use them yet.  The
following patches will build on top.

v2: Added cgroup_is_threaded() helper.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h | 22 +++++++++++
 kernel/cgroup/cgroup.c      | 93 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ec47101cb1bf..471773792557 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -163,6 +163,15 @@ struct css_set {
 	/* reference count */
 	refcount_t refcount;
 
+	/*
+	 * If not threaded, the following points to self.  If threaded, to
+	 * a cset which belongs to the top cgroup of the threaded subtree.
+	 * The proc_cset provides access to the process cgroup and its
+	 * csses to which domain level resource consumptions should be
+	 * charged.
+	 */
+	struct css_set __rcu *proc_cset;
+
 	/* the default cgroup associated with this css_set */
 	struct cgroup *dfl_cgrp;
 
@@ -188,6 +197,10 @@ struct css_set {
 	 */
 	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
 
+	/* all csets whose ->proc_cset points to this cset */
+	struct list_head threaded_csets;
+	struct list_head threaded_csets_node;
+
 	/*
 	 * List running through all cgroup groups in the same hash
 	 * slot. Protected by css_set_lock
@@ -294,6 +307,15 @@ struct cgroup {
 	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
 
 	/*
+	 * If !threaded, NULL.  If threaded, it points to the top cgroup of
+	 * the threaded subtree, on which it points to self.  Threaded
+	 * subtree is exempt from process granularity and no-internal-task
+	 * constraint.  Domain level resource consumptions which aren't
+	 * tied to a specific task should be charged to the proc_cgrp.
+	 */
+	struct cgroup *proc_cgrp;
+
+	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
 	 * for tasks); created on demand.
 	 */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6efd44cfec22..0fa4ffe84933 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -325,6 +325,12 @@ static struct cgroup *cgroup_parent(struct cgroup *cgrp)
 	return NULL;
 }
 
+/* is @cgrp threaded? regardless of mixed / root / member? */
+static bool cgroup_is_threaded(struct cgroup *cgrp)
+{
+	return cgrp->proc_cgrp;
+}
+
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
@@ -560,9 +566,11 @@ EXPORT_SYMBOL_GPL(of_css);
  */
 struct css_set init_css_set = {
 	.refcount		= REFCOUNT_INIT(1),
+	.proc_cset		= RCU_INITIALIZER(&init_css_set),
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
+	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
@@ -570,6 +578,17 @@ struct css_set init_css_set = {
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
+static struct css_set *proc_css_set(struct css_set *cset)
+{
+	return rcu_dereference_protected(cset->proc_cset,
+					 lockdep_is_held(&css_set_lock));
+}
+
+static bool css_set_threaded(struct css_set *cset)
+{
+	return proc_css_set(cset) != cset;
+}
+
 /**
  * css_set_populated - does a css_set contain any tasks?
  * @cset: target css_set
@@ -756,6 +775,8 @@ void put_css_set_locked(struct css_set *cset)
 	if (!refcount_dec_and_test(&cset->refcount))
 		return;
 
+	WARN_ON_ONCE(!list_empty(&cset->threaded_csets));
+
 	/* This css_set is dead. unlink it and release cgroup and css refs */
 	for_each_subsys(ss, ssid) {
 		list_del(&cset->e_cset_node[ssid]);
@@ -772,6 +793,11 @@ void put_css_set_locked(struct css_set *cset)
 		kfree(link);
 	}
 
+	if (css_set_threaded(cset)) {
+		list_del(&cset->threaded_csets_node);
+		put_css_set_locked(proc_css_set(cset));
+	}
+
 	kfree_rcu(cset, rcu_head);
 }
 
@@ -781,6 +807,7 @@ void put_css_set_locked(struct css_set *cset)
  * @old_cset: existing css_set for a task
  * @new_cgrp: cgroup that's being entered by the task
  * @template: desired set of css pointers in css_set (pre-calculated)
+ * @for_pcset: the comparison is for a new proc_cset
  *
  * Returns true if "cset" matches "old_cset" except for the hierarchy
  * which "new_cgrp" belongs to, for which it should match "new_cgrp".
@@ -788,7 +815,8 @@ void put_css_set_locked(struct css_set *cset)
 static bool compare_css_sets(struct css_set *cset,
 			     struct css_set *old_cset,
 			     struct cgroup *new_cgrp,
-			     struct cgroup_subsys_state *template[])
+			     struct cgroup_subsys_state *template[],
+			     bool for_pcset)
 {
 	struct list_head *l1, *l2;
 
@@ -800,6 +828,32 @@ static bool compare_css_sets(struct css_set *cset,
 	if (memcmp(template, cset->subsys, sizeof(cset->subsys)))
 		return false;
 
+	if (for_pcset) {
+		/*
+		 * We're looking for the pcset of @old_cset.  As @old_cset
+		 * doesn't have its ->proc_cset pointer set yet (we're
+		 * trying to find out what to set it to), @old_cset itself
+		 * may seem like a match here.  Explicitly exlude identity
+		 * matching.
+		 */
+		if (css_set_threaded(cset) || cset == old_cset)
+			return false;
+	} else {
+		bool is_threaded;
+
+		/*
+		 * Otherwise, @cset's threaded state should match the
+		 * default cgroup's.
+		 */
+		if (cgroup_on_dfl(new_cgrp))
+			is_threaded = cgroup_is_threaded(new_cgrp);
+		else
+			is_threaded = cgroup_is_threaded(old_cset->dfl_cgrp);
+
+		if (is_threaded != css_set_threaded(cset))
+			return false;
+	}
+
 	/*
 	 * Compare cgroup pointers in order to distinguish between
 	 * different cgroups in hierarchies.  As different cgroups may
@@ -852,10 +906,12 @@ static bool compare_css_sets(struct css_set *cset,
  * @old_cset: the css_set that we're using before the cgroup transition
  * @cgrp: the cgroup that we're moving into
  * @template: out param for the new set of csses, should be clear on entry
+ * @for_pcset: looking for a new proc_cset
  */
 static struct css_set *find_existing_css_set(struct css_set *old_cset,
 					struct cgroup *cgrp,
-					struct cgroup_subsys_state *template[])
+					struct cgroup_subsys_state *template[],
+					bool for_pcset)
 {
 	struct cgroup_root *root = cgrp->root;
 	struct cgroup_subsys *ss;
@@ -886,7 +942,7 @@ static struct css_set *find_existing_css_set(struct css_set *old_cset,
 
 	key = css_set_hash(template);
 	hash_for_each_possible(css_set_table, cset, hlist, key) {
-		if (!compare_css_sets(cset, old_cset, cgrp, template))
+		if (!compare_css_sets(cset, old_cset, cgrp, template, for_pcset))
 			continue;
 
 		/* This css_set matches what we need */
@@ -968,12 +1024,13 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
  * find_css_set - return a new css_set with one cgroup updated
  * @old_cset: the baseline css_set
  * @cgrp: the cgroup to be updated
+ * @for_pcset: looking for a new proc_cset
  *
  * Return a new css_set that's equivalent to @old_cset, but with @cgrp
  * substituted into the appropriate hierarchy.
  */
 static struct css_set *find_css_set(struct css_set *old_cset,
-				    struct cgroup *cgrp)
+				    struct cgroup *cgrp, bool for_pcset)
 {
 	struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT] = { };
 	struct css_set *cset;
@@ -988,7 +1045,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
 	spin_lock_irq(&css_set_lock);
-	cset = find_existing_css_set(old_cset, cgrp, template);
+	cset = find_existing_css_set(old_cset, cgrp, template, for_pcset);
 	if (cset)
 		get_css_set(cset);
 	spin_unlock_irq(&css_set_lock);
@@ -1007,9 +1064,11 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	}
 
 	refcount_set(&cset->refcount, 1);
+	RCU_INIT_POINTER(cset->proc_cset, cset);
 	INIT_LIST_HEAD(&cset->tasks);
 	INIT_LIST_HEAD(&cset->mg_tasks);
 	INIT_LIST_HEAD(&cset->task_iters);
+	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
 	INIT_LIST_HEAD(&cset->mg_preload_node);
@@ -1047,6 +1106,28 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * If @cset should be threaded, look up the matching proc_cset and
+	 * link them up.  We first fully initialize @cset then look for the
+	 * pcset.  It's simpler this way and safe as @cset is guaranteed to
+	 * stay empty until we return.
+	 */
+	if (!for_pcset && cgroup_is_threaded(cset->dfl_cgrp)) {
+		struct css_set *pcset;
+
+		pcset = find_css_set(cset, cset->dfl_cgrp->proc_cgrp, true);
+		if (!pcset) {
+			put_css_set(cset);
+			return NULL;
+		}
+
+		spin_lock_irq(&css_set_lock);
+		rcu_assign_pointer(cset->proc_cset, pcset);
+		list_add_tail(&cset->threaded_csets_node,
+			      &pcset->threaded_csets);
+		spin_unlock_irq(&css_set_lock);
+	}
+
 	return cset;
 }
 
@@ -2268,7 +2349,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 		struct cgroup_subsys *ss;
 		int ssid;
 
-		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp);
+		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp, false);
 		if (!dst_cset)
 			goto err;
 
-- 
2.13.0

