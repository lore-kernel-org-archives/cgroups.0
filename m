From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] cgroup: Fix line length to 80 characters
Date: Tue, 15 Dec 2015 13:20:41 +0100
Message-ID: <1450182045-27480-2-git-send-email-kuba.kunert@gmail.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=emnTes4jp8RetSB36PN97Y7ir6Vbr54O5jy6BWXef90=;
        b=anhDVjR5fbA84WOX9clonwyYeyVam+a/AiJTtzr9TsPMHbu7dQEs+Woh0aLktRBdrQ
         A0+WVJPiZjn8Bhf8gXiWWKnmidJkvroxccNNxFKsadwsYrvfyftmvKv7UL3mOMdGuD8e
         sqW67xdZkprnbgNJxYDU+XHxQLvnYwG31kELiEn0f1te6fi51CNTpKxgwbyCJIDBzcnU
         tJbLTJx5CqgdXwhGQSzCKDKwq+r1kNezU4IcxlbbAEkblGtgMPC6si1EVkb6jqv4Qx1R
         AI7ep7AUzG6Lqia6FuK2BlmOowoKNT7bUKexU2a+mZ5gq9cW3+YT0ZoFjGujdzFIpmPf
         lhKQ==
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Fix checkpatch.pl warnings with lines over 80 characters.

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 51 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d848888..c512ae0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -144,11 +144,13 @@ static const char *cgroup_subsys_name[] = {
 };
 #undef SUBSYS
 
-/* array of static_keys for cgroup_subsys_enabled() and cgroup_subsys_on_dfl() */
-#define SUBSYS(_x)								\
-	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_enabled_key);			\
-	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_on_dfl_key);			\
-	EXPORT_SYMBOL_GPL(_x ## _cgrp_subsys_enabled_key);			\
+/*
+ * array of static_keys for cgroup_subsys_enabled() and cgroup_subsys_on_dfl()
+ */
+#define SUBSYS(_x)							\
+	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_enabled_key);		\
+	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_on_dfl_key);		\
+	EXPORT_SYMBOL_GPL(_x ## _cgrp_subsys_enabled_key);		\
 	EXPORT_SYMBOL_GPL(_x ## _cgrp_subsys_on_dfl_key);
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
@@ -682,7 +684,8 @@ static void css_set_update_populated(struct css_set *cset, bool populated)
  * @from_cset and @to_cset's reference counts.
  */
 static void css_set_move_task(struct task_struct *task,
-			      struct css_set *from_cset, struct css_set *to_cset,
+			      struct css_set *from_cset,
+			      struct css_set *to_cset,
 			      bool use_mg_tasks)
 {
 	lockdep_assert_held(&css_set_lock);
@@ -723,8 +726,8 @@ static void css_set_move_task(struct task_struct *task,
 		if (!css_set_populated(to_cset))
 			css_set_update_populated(to_cset, true);
 		rcu_assign_pointer(task->cgroups, to_cset);
-		list_add_tail(&task->cg_list, use_mg_tasks ? &to_cset->mg_tasks :
-							     &to_cset->tasks);
+		list_add_tail(&task->cg_list,
+			use_mg_tasks ? &to_cset->mg_tasks : &to_cset->tasks);
 	}
 }
 
@@ -2402,7 +2405,8 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	 */
 	spin_lock_bh(&css_set_lock);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
-		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list) {
+		list_for_each_entry_safe(task, tmp_task,
+					&cset->mg_tasks, cg_list) {
 			struct css_set *from_cset = task_css_set(task);
 			struct css_set *to_cset = cset->mg_dst_cset;
 
@@ -2464,7 +2468,8 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_bh(&css_set_lock);
-	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets, mg_preload_node) {
+	list_for_each_entry_safe(cset, tmp_cset, preloaded_csets,
+				mg_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
 		list_del_init(&cset->mg_preload_node);
@@ -2545,7 +2550,8 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 		return -EBUSY;
 
 	/* look up the dst cset for each src cset and link it to src */
-	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets, mg_preload_node) {
+	list_for_each_entry_safe(src_cset, tmp_cset, preloaded_csets,
+				mg_preload_node) {
 		struct css_set *dst_cset;
 
 		dst_cset = find_css_set(src_cset,
@@ -3007,7 +3013,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			/* unavailable or not enabled on the parent? */
 			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
 			    (cgroup_parent(cgrp) &&
-			     !(cgroup_parent(cgrp)->subtree_control & (1 << ssid)))) {
+			     !(cgroup_parent(cgrp)->subtree_control &
+						(1 << ssid)))) {
 				ret = -ENOENT;
 				goto out_unlock;
 			}
@@ -3677,9 +3684,11 @@ struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
 	 * races against release and the race window is very small.
 	 */
 	if (!pos) {
-		next = list_entry_rcu(parent->children.next, struct cgroup_subsys_state, sibling);
+		next = list_entry_rcu(parent->children.next,
+				struct cgroup_subsys_state, sibling);
 	} else if (likely(!(pos->flags & CSS_RELEASED))) {
-		next = list_entry_rcu(pos->sibling.next, struct cgroup_subsys_state, sibling);
+		next = list_entry_rcu(pos->sibling.next,
+				struct cgroup_subsys_state, sibling);
 	} else {
 		list_for_each_entry_rcu(next, &parent->children, sibling)
 			if (next->serial_nr > pos->serial_nr)
@@ -4152,7 +4161,8 @@ static void cgroup_pidlist_destroy_all(struct cgroup *cgrp)
 
 	mutex_lock(&cgrp->pidlist_mutex);
 	list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
-		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork, 0);
+		mod_delayed_work(cgroup_pidlist_destroy_wq,
+				&l->destroy_dwork, 0);
 	mutex_unlock(&cgrp->pidlist_mutex);
 
 	flush_workqueue(cgroup_pidlist_destroy_wq);
@@ -4968,7 +4978,8 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	cgrp->self.serial_nr = css_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
-	list_add_tail_rcu(&cgrp->self.sibling, &cgroup_parent(cgrp)->self.children);
+	list_add_tail_rcu(&cgrp->self.sibling,
+			&cgroup_parent(cgrp)->self.children);
 	atomic_inc(&root->nr_cgrps);
 	cgroup_get(parent);
 
@@ -5337,7 +5348,8 @@ int __init cgroup_init(void)
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
 			WARN_ON(cgroup_add_dfl_cftypes(ss, ss->dfl_cftypes));
-			WARN_ON(cgroup_add_legacy_cftypes(ss, ss->legacy_cftypes));
+			WARN_ON(cgroup_add_legacy_cftypes(ss,
+							ss->legacy_cftypes));
 		}
 
 		if (ss->bind)
@@ -5408,8 +5420,9 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		if (root != &cgrp_dfl_root)
 			for_each_subsys(ss, ssid)
 				if (root->subsys_mask & (1 << ssid))
-					seq_printf(m, "%s%s", count++ ? "," : "",
-						   ss->legacy_name);
+					seq_printf(m, "%s%s",
+						count++ ? "," : "",
+						ss->legacy_name);
 		if (strlen(root->name))
 			seq_printf(m, "%sname=%s", count ? "," : "",
 				   root->name);
-- 
2.6.2
