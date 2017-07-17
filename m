From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: introduce cgroup->dom_cgrp and threaded css_set handling
Date: Sun, 16 Jul 2017 22:07:18 -0400
Message-ID: <20170717020721.3612468-4-tj@kernel.org>
References: <20170717020721.3612468-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E9XCS1eWO2fFHJjQqWBMu+adQYwPZKuR4C7mpHW51r4=;
        b=a6YTYok44zd8WS0dEtGxQon9TtjyBUx1GpERRFJlH536za0K1a2aDCRQhemRrrWY66
         XciIhyxc91tkf9MfgkjeLyBPurh1/RFEbDgheZySrgPlF52l4QWhdLWlGw06QXDqNMYc
         vFxT5qEI/7Xds6KvTGID2JpLmLIl/hg6NAUqdyY8K+FJSXUCPa1ddpcyV97kP23v1dKM
         KC3pmRnBoDY8IjWqCbnbOhvHi6GFo+n5h6JL6tsmIEp+NbvCgbhTVadSSv7Qz0YMh1xb
         7o9dM/0WGxFZhUWCawZp9rNyi6idYPq4Ot238hOb5u2/uOOvT9xXXz15IFuD+sxYzHFL
         OhQg==
In-Reply-To: <20170717020721.3612468-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

cgroup v2 is in the process of growing thread granularity support.  A
threaded subtree is composed of a thread root and threaded cgroups
which are proper members of the subtree.

The root cgroup of the subtree serves as the domain cgroup to which
the processes (as opposed to threads / tasks) of the subtree
conceptually belong and domain-level resource consumptions not tied to
any specific task are charged.  Inside the subtree, threads won't be
subject to process granularity or no-internal-task constraint and can
be distributed arbitrarily across the subtree.

This patch introduces cgroup->dom_cgrp along with threaded css_set
handling.

* cgroup->dom_cgrp points to self for normal and thread roots.  For
  proper thread subtree members, points to the dom_cgrp (the thread
  root).

* css_set->dom_cset points to self if for normal and thread roots.  If
  threaded, points to the css_set which belongs to the cgrp->dom_cgrp.
  The dom_cgrp serves as the resource domain and keeps the matching
  csses available.  The dom_cset holds those csses and makes them
  easily accessible.

* All threaded csets are linked on their dom_csets to enable iteration
  of all threaded tasks.

* cgroup->nr_threaded_children keeps track of the number of threaded
  children.

This patch adds the above but doesn't actually use them yet.  The
following patches will build on top.

v4: ->nr_threaded_children added.

v3: ->proc_cgrp/cset renamed to ->dom_cgrp/cset.  Updated for the new
    enable-threaded-per-cgroup behavior.

v2: Added cgroup_is_threaded() helper.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h | 33 +++++++++++++++++++---
 include/linux/cgroup.h      |  3 +-
 kernel/cgroup/cgroup.c      | 69 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ae7bc1e..651c436 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -172,6 +172,14 @@ struct css_set {
 	/* reference count */
 	refcount_t refcount;
 
+	/*
+	 * For a domain cgroup, the following points to self.  If threaded,
+	 * to the matching cset of the nearest domain ancestor.  The
+	 * dom_cset provides access to the domain cgroup and its csses to
+	 * which domain level resource consumptions should be charged.
+	 */
+	struct css_set *dom_cset;
+
 	/* the default cgroup associated with this css_set */
 	struct cgroup *dfl_cgrp;
 
@@ -200,6 +208,10 @@ struct css_set {
 	 */
 	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
 
+	/* all threaded csets whose ->dom_cset points to this cset */
+	struct list_head threaded_csets;
+	struct list_head threaded_csets_node;
+
 	/*
 	 * List running through all cgroup groups in the same hash
 	 * slot. Protected by css_set_lock
@@ -267,12 +279,16 @@ struct cgroup {
 	 * doesn't have any tasks.
 	 *
 	 * All children which have non-zero nr_populated_csets and/or
-	 * nr_populated_children of their own contribute one to
-	 * nr_populated_children.  The counter is zero iff this cgroup's
-	 * subtree proper doesn't have any tasks.
+	 * nr_populated_children of their own contribute one to either
+	 * nr_populated_domain_children or nr_populated_threaded_children
+	 * depending on their type.  Each counter is zero iff all cgroups
+	 * of the type in the subtree proper don't have any tasks.
 	 */
 	int nr_populated_csets;
-	int nr_populated_children;
+	int nr_populated_domain_children;
+	int nr_populated_threaded_children;
+
+	int nr_threaded_children;	/* # of live threaded child cgroups */
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct cgroup_file procs_file;	/* handle for "cgroup.procs" */
@@ -311,6 +327,15 @@ struct cgroup {
 	struct list_head e_csets[CGROUP_SUBSYS_COUNT];
 
 	/*
+	 * If !threaded, self.  If threaded, it points to the nearest
+	 * domain ancestor.  Inside a threaded subtree, cgroups are exempt
+	 * from process granularity and no-internal-task constraint.
+	 * Domain level resource consumptions which aren't tied to a
+	 * specific task are charged to the dom_cgrp.
+	 */
+	struct cgroup *dom_cgrp;
+
+	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
 	 * for tasks); created on demand.
 	 */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index cae5831..b7dd230 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -541,7 +541,8 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_is_populated(struct cgroup *cgrp)
 {
-	return cgrp->nr_populated_csets + cgrp->nr_populated_children;
+	return cgrp->nr_populated_csets + cgrp->nr_populated_domain_children +
+		cgrp->nr_populated_threaded_children;
 }
 
 /* returns ino associated with a cgroup */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3c5a37a..c7e1c24 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -330,6 +330,11 @@ static bool cgroup_has_tasks(struct cgroup *cgrp)
 	return cgrp->nr_populated_csets;
 }
 
+static bool cgroup_is_threaded(struct cgroup *cgrp)
+{
+	return cgrp->dom_cgrp != cgrp;
+}
+
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
@@ -565,9 +570,11 @@ EXPORT_SYMBOL_GPL(of_css);
  */
 struct css_set init_css_set = {
 	.refcount		= REFCOUNT_INIT(1),
+	.dom_cset		= &init_css_set,
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
+	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
@@ -575,6 +582,11 @@ struct css_set init_css_set = {
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
+static bool css_set_threaded(struct css_set *cset)
+{
+	return cset->dom_cset != cset;
+}
+
 /**
  * css_set_populated - does a css_set contain any tasks?
  * @cset: target css_set
@@ -618,10 +630,14 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 	do {
 		bool was_populated = cgroup_is_populated(cgrp);
 
-		if (!child)
+		if (!child) {
 			cgrp->nr_populated_csets += adj;
-		else
-			cgrp->nr_populated_children += adj;
+		} else {
+			if (cgroup_is_threaded(child))
+				cgrp->nr_populated_threaded_children += adj;
+			else
+				cgrp->nr_populated_domain_children += adj;
+		}
 
 		if (was_populated == cgroup_is_populated(cgrp))
 			break;
@@ -747,6 +763,8 @@ void put_css_set_locked(struct css_set *cset)
 	if (!refcount_dec_and_test(&cset->refcount))
 		return;
 
+	WARN_ON_ONCE(!list_empty(&cset->threaded_csets));
+
 	/* This css_set is dead. unlink it and release cgroup and css refs */
 	for_each_subsys(ss, ssid) {
 		list_del(&cset->e_cset_node[ssid]);
@@ -763,6 +781,11 @@ void put_css_set_locked(struct css_set *cset)
 		kfree(link);
 	}
 
+	if (css_set_threaded(cset)) {
+		list_del(&cset->threaded_csets_node);
+		put_css_set_locked(cset->dom_cset);
+	}
+
 	kfree_rcu(cset, rcu_head);
 }
 
@@ -781,6 +804,7 @@ static bool compare_css_sets(struct css_set *cset,
 			     struct cgroup *new_cgrp,
 			     struct cgroup_subsys_state *template[])
 {
+	struct cgroup *new_dfl_cgrp;
 	struct list_head *l1, *l2;
 
 	/*
@@ -791,6 +815,16 @@ static bool compare_css_sets(struct css_set *cset,
 	if (memcmp(template, cset->subsys, sizeof(cset->subsys)))
 		return false;
 
+
+	/* @cset's domain should match the default cgroup's */
+	if (cgroup_on_dfl(new_cgrp))
+		new_dfl_cgrp = new_cgrp;
+	else
+		new_dfl_cgrp = old_cset->dfl_cgrp;
+
+	if (new_dfl_cgrp->dom_cgrp != cset->dom_cset->dfl_cgrp)
+		return false;
+
 	/*
 	 * Compare cgroup pointers in order to distinguish between
 	 * different cgroups in hierarchies.  As different cgroups may
@@ -998,9 +1032,11 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	}
 
 	refcount_set(&cset->refcount, 1);
+	cset->dom_cset = cset;
 	INIT_LIST_HEAD(&cset->tasks);
 	INIT_LIST_HEAD(&cset->mg_tasks);
 	INIT_LIST_HEAD(&cset->task_iters);
+	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
 	INIT_LIST_HEAD(&cset->mg_preload_node);
@@ -1038,6 +1074,28 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * If @cset should be threaded, look up the matching dom_cset and
+	 * link them up.  We first fully initialize @cset then look for the
+	 * dom_cset.  It's simpler this way and safe as @cset is guaranteed
+	 * to stay empty until we return.
+	 */
+	if (cgroup_is_threaded(cset->dfl_cgrp)) {
+		struct css_set *dcset;
+
+		dcset = find_css_set(cset, cset->dfl_cgrp->dom_cgrp);
+		if (!dcset) {
+			put_css_set(cset);
+			return NULL;
+		}
+
+		spin_lock_irq(&css_set_lock);
+		cset->dom_cset = dcset;
+		list_add_tail(&cset->threaded_csets_node,
+			      &dcset->threaded_csets);
+		spin_unlock_irq(&css_set_lock);
+	}
+
 	return cset;
 }
 
@@ -1680,6 +1738,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	mutex_init(&cgrp->pidlist_mutex);
 	cgrp->self.cgroup = cgrp;
 	cgrp->self.flags |= CSS_ONLINE;
+	cgrp->dom_cgrp = cgrp;
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -4408,6 +4467,7 @@ static void kill_css(struct cgroup_subsys_state *css)
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
+	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys_state *css;
 	struct cgrp_cset_link *link;
 	int ssid;
@@ -4452,6 +4512,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	kernfs_remove(cgrp->kn);
 
+	if (parent && cgroup_is_threaded(cgrp))
+		parent->nr_threaded_children--;
+
 	cgroup1_check_for_release(cgroup_parent(cgrp));
 
 	/* put the base reference */
-- 
2.9.3

