From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] cgroup: reorder css_set fields
Date: Tue, 20 Dec 2016 16:08:20 -0500
Message-ID: <20161220210827.11176-2-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o4caZvKmPcJ2rxtztA0aTznwbjrpftqZX9xb6smLaR4=;
        b=cnomrsntoyPvDK+eQICSPrO9t2SbhvJ+ZwfaLY3Wwkj7mWV8yDUp9x/XYGJh5SyFF1
         08RIS6JNETep5mLiAvRnVW2WisrZeOFkS935PgwaNuAxZZFrz00eSY6qWhgI/6Z1IgXx
         X7SRIxY+LvxdkcM8AbWA2wjgm4E7Nz9TpQy16zZ0MLdVU4/c+fBM2NtT6Q53jfs0eel4
         gbwVBSKcwJmP77iKN9hjdHKCj9CSaDQ2PtNyw+trAktPOARK1WGGEs2dZhzwojwgUfLM
         lMeO0zOHUTwk33T58s4YRRjOwkCEzn5GUeWLEE+wGgPuI3A8rLUAauQCqrAI3AaVQCLP
         mbxQ==
In-Reply-To: <20161220210827.11176-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Reorder css_set fields so that they're roughly in the order of how hot
they are.  The rough order is

1. the actual csses
2. reference counter and the default cgroup pointer.
3. task lists and iterations
4. fields used during merge including css_set lookup
5. the rest

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h | 54 ++++++++++++++++++++++-----------------------
 kernel/cgroup.c             | 13 ++++++-----
 2 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a916dc..3c02404 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -148,14 +148,18 @@ struct cgroup_subsys_state {
  * set for a task.
  */
 struct css_set {
-	/* Reference count */
-	atomic_t refcount;
-
 	/*
-	 * List running through all cgroup groups in the same hash
-	 * slot. Protected by css_set_lock
+	 * Set of subsystem states, one for each subsystem. This array is
+	 * immutable after creation apart from the init_css_set during
+	 * subsystem registration (at boot time).
 	 */
-	struct hlist_node hlist;
+	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+
+	/* reference count */
+	atomic_t refcount;
+
+	/* the default cgroup associated with this css_set */
+	struct cgroup *dfl_cgrp;
 
 	/*
 	 * Lists running through all tasks using this cgroup group.
@@ -167,21 +171,29 @@ struct css_set {
 	struct list_head tasks;
 	struct list_head mg_tasks;
 
+	/* all css_task_iters currently walking this cset */
+	struct list_head task_iters;
+
 	/*
-	 * List of cgrp_cset_links pointing at cgroups referenced from this
-	 * css_set.  Protected by css_set_lock.
+	 * On the default hierarhcy, ->subsys[ssid] may point to a css
+	 * attached to an ancestor instead of the cgroup this css_set is
+	 * associated with.  The following node is anchored at
+	 * ->subsys[ssid]->cgroup->e_csets[ssid] and provides a way to
+	 * iterate through all css's attached to a given cgroup.
 	 */
-	struct list_head cgrp_links;
+	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
 
-	/* the default cgroup associated with this css_set */
-	struct cgroup *dfl_cgrp;
+	/*
+	 * List running through all cgroup groups in the same hash
+	 * slot. Protected by css_set_lock
+	 */
+	struct hlist_node hlist;
 
 	/*
-	 * Set of subsystem states, one for each subsystem. This array is
-	 * immutable after creation apart from the init_css_set during
-	 * subsystem registration (at boot time).
+	 * List of cgrp_cset_links pointing at cgroups referenced from this
+	 * css_set.  Protected by css_set_lock.
 	 */
-	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+	struct list_head cgrp_links;
 
 	/*
 	 * List of csets participating in the on-going migration either as
@@ -201,18 +213,6 @@ struct css_set {
 	struct cgroup *mg_dst_cgrp;
 	struct css_set *mg_dst_cset;
 
-	/*
-	 * On the default hierarhcy, ->subsys[ssid] may point to a css
-	 * attached to an ancestor instead of the cgroup this css_set is
-	 * associated with.  The following node is anchored at
-	 * ->subsys[ssid]->cgroup->e_csets[ssid] and provides a way to
-	 * iterate through all css's attached to a given cgroup.
-	 */
-	struct list_head e_cset_node[CGROUP_SUBSYS_COUNT];
-
-	/* all css_task_iters currently walking this cset */
-	struct list_head task_iters;
-
 	/* dead and being drained, ignore for migration */
 	bool dead;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b9e2d85..1a815f2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -647,12 +647,12 @@ struct cgrp_cset_link {
  */
 struct css_set init_css_set = {
 	.refcount		= ATOMIC_INIT(1),
-	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
 	.mg_tasks		= LIST_HEAD_INIT(init_css_set.mg_tasks),
+	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
+	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
-	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 };
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
@@ -1095,13 +1095,13 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	}
 
 	atomic_set(&cset->refcount, 1);
-	INIT_LIST_HEAD(&cset->cgrp_links);
 	INIT_LIST_HEAD(&cset->tasks);
 	INIT_LIST_HEAD(&cset->mg_tasks);
-	INIT_LIST_HEAD(&cset->mg_preload_node);
-	INIT_LIST_HEAD(&cset->mg_node);
 	INIT_LIST_HEAD(&cset->task_iters);
 	INIT_HLIST_NODE(&cset->hlist);
+	INIT_LIST_HEAD(&cset->cgrp_links);
+	INIT_LIST_HEAD(&cset->mg_preload_node);
+	INIT_LIST_HEAD(&cset->mg_node);
 
 	/* Copy the set of subsystem state objects generated in
 	 * find_existing_css_set() */
@@ -4384,6 +4384,9 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	struct task_struct *task;
 	int ret;
 
+	if (cgroup_on_dfl(to))
+		return -EINVAL;
+
 	if (!cgroup_may_migrate_to(to))
 		return -EBUSY;
 
-- 
2.9.3

