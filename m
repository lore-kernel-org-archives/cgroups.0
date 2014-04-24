From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: make flags and subsys_masks unsigned int
Date: Thu, 24 Apr 2014 17:02:08 -0400
Message-ID: <1398373333-1521-2-git-send-email-tj@kernel.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G9ZkQnrxxOk5tAabHUtLnXHy263v0YBjgSKp3v41nzE=;
        b=k3zgGF9cS0bQPxwKpb3KYCFL/uIeSsAqq4kEAjXJMdEbEtgqkBvZP1r6L/mlGN5WYa
         lk+Tnqs5zkg7Rx36J5w41SmBDvjn9Ughg1ykMJld5GUpHaTLQ9CK3O0VhCTIrnpbEvpw
         ix0BlSc2+Wyd4A7RwIT96FVUNZRmzuJ0Ej8tsTTo07vgdKC/9hhuH7jO6vN3bsybUxmt
         vWOYBCNQaIFz/TXw+md2UZgEnfMgVBkVVurWoVRdox3VeosEoLlJ6gy1i1QFZ7NhZfXe
         pEQzyoNiSA7CfqOUP6D4MXilovflCO2K6InXTkfLWHLRcre3Q6NJzck6/s3j6DKOHQrN
         vnOA==
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, nasa4836@gmail.com, Tejun Heo <tj@kernel.org>

There's no reason to use atomic bitops for cgroup_subsys_state->flags,
cgroup_root->flags and various subsys_masks.  This patch updates those
to use bitwise and/or operations instead and converts them form
unsigned long to unsigned int.

This makes the fields occupy (marginally) smaller space and makes it
clear that they don't require atomicity.

This patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  8 ++++----
 kernel/cgroup.c        | 37 ++++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4b38e2d..c6c703f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -62,7 +62,7 @@ struct cgroup_subsys_state {
 	/* the parent css */
 	struct cgroup_subsys_state *parent;
 
-	unsigned long flags;
+	unsigned int flags;
 
 	/* percpu_ref killing and RCU release */
 	struct rcu_head rcu_head;
@@ -185,7 +185,7 @@ struct cgroup {
 	u64 serial_nr;
 
 	/* the bitmask of subsystems enabled on the child cgroups */
-	unsigned long child_subsys_mask;
+	unsigned int child_subsys_mask;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
@@ -312,7 +312,7 @@ struct cgroup_root {
 	struct kernfs_root *kf_root;
 
 	/* The bitmask of subsystems attached to this hierarchy */
-	unsigned long subsys_mask;
+	unsigned int subsys_mask;
 
 	/* Unique id for this hierarchy. */
 	int hierarchy_id;
@@ -327,7 +327,7 @@ struct cgroup_root {
 	struct list_head root_list;
 
 	/* Hierarchy-specific flags */
-	unsigned long flags;
+	unsigned int flags;
 
 	/* IDs for cgroups in this hierarchy */
 	struct idr cgroup_idr;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3873267..21667f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -181,7 +181,7 @@ static struct cftype cgroup_base_files[];
 
 static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
-			     unsigned long ss_mask);
+			     unsigned int ss_mask);
 static void cgroup_destroy_css_killed(struct cgroup *cgrp);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss);
@@ -963,7 +963,7 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask);
+static int cgroup_populate_dir(struct cgroup *cgrp, unsigned int subsys_mask);
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -1079,7 +1079,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
  * @cgrp: target cgroup
  * @subsys_mask: mask of the subsystem ids whose files should be removed
  */
-static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
+static void cgroup_clear_dir(struct cgroup *cgrp, unsigned int subsys_mask)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -1087,15 +1087,14 @@ static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 	for_each_subsys(ss, i) {
 		struct cftype *cfts;
 
-		if (!test_bit(i, &subsys_mask))
+		if (!(subsys_mask & (1 << i)))
 			continue;
 		list_for_each_entry(cfts, &ss->cfts, node)
 			cgroup_addrm_files(cgrp, cfts, false);
 	}
 }
 
-static int rebind_subsystems(struct cgroup_root *dst_root,
-			     unsigned long ss_mask)
+static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 {
 	struct cgroup_subsys *ss;
 	int ssid, i, ret;
@@ -1128,7 +1127,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		 * Just warn about it and continue.
 		 */
 		if (cgrp_dfl_root_visible) {
-			pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
+			pr_warn("failed to create files (%d) while rebinding 0x%x to default root\n",
 				ret, ss_mask);
 			pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
 		}
@@ -1214,8 +1213,8 @@ static int cgroup_show_options(struct seq_file *seq,
 }
 
 struct cgroup_sb_opts {
-	unsigned long subsys_mask;
-	unsigned long flags;
+	unsigned int subsys_mask;
+	unsigned int flags;
 	char *release_agent;
 	bool cpuset_clone_children;
 	char *name;
@@ -1227,12 +1226,12 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data;
 	bool all_ss = false, one_ss = false;
-	unsigned long mask = (unsigned long)-1;
+	unsigned int mask = -1U;
 	struct cgroup_subsys *ss;
 	int i;
 
 #ifdef CONFIG_CPUSETS
-	mask = ~(1UL << cpuset_cgrp_id);
+	mask = ~(1U << cpuset_cgrp_id);
 #endif
 
 	memset(opts, 0, sizeof(*opts));
@@ -1313,7 +1312,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			/* Mutually exclusive option 'all' + subsystem name */
 			if (all_ss)
 				return -EINVAL;
-			set_bit(i, &opts->subsys_mask);
+			opts->subsys_mask |= (1 << i);
 			one_ss = true;
 
 			break;
@@ -1342,7 +1341,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		if (all_ss || (!one_ss && !opts->none && !opts->name))
 			for_each_subsys(ss, i)
 				if (!ss->disabled)
-					set_bit(i, &opts->subsys_mask);
+					opts->subsys_mask |= (1 << i);
 
 		/*
 		 * We either have to specify by name or by subsystems. (So
@@ -1373,7 +1372,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_sb_opts opts;
-	unsigned long added_mask, removed_mask;
+	unsigned int added_mask, removed_mask;
 
 	if (root->flags & CGRP_ROOT_SANE_BEHAVIOR) {
 		pr_err("sane_behavior: remount is not allowed\n");
@@ -1398,7 +1397,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	/* Don't allow flags or name to change at remount */
 	if (((opts.flags ^ root->flags) & CGRP_ROOT_OPTION_MASK) ||
 	    (opts.name && strcmp(opts.name, root->name))) {
-		pr_err("option or name mismatch, new: 0x%lx \"%s\", old: 0x%lx \"%s\"\n",
+		pr_err("option or name mismatch, new: 0x%x \"%s\", old: 0x%x \"%s\"\n",
 		       opts.flags & CGRP_ROOT_OPTION_MASK, opts.name ?: "",
 		       root->flags & CGRP_ROOT_OPTION_MASK, root->name);
 		ret = -EINVAL;
@@ -1522,7 +1521,7 @@ static void init_cgroup_root(struct cgroup_root *root,
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
-static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
+static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
@@ -2507,7 +2506,7 @@ out_finish:
 static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 					struct cftype *cft, char *buffer)
 {
-	unsigned long enable_req = 0, disable_req = 0, enable, disable;
+	unsigned int enable_req = 0, disable_req = 0, enable, disable;
 	struct cgroup *cgrp = dummy_css->cgroup, *child;
 	struct cgroup_subsys *ss;
 	char *tok, *p;
@@ -3998,7 +3997,7 @@ static struct cftype cgroup_base_files[] = {
  *
  * On failure, no file is added.
  */
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
+static int cgroup_populate_dir(struct cgroup *cgrp, unsigned int subsys_mask)
 {
 	struct cgroup_subsys *ss;
 	int i, ret = 0;
@@ -4007,7 +4006,7 @@ static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 	for_each_subsys(ss, i) {
 		struct cftype *cfts;
 
-		if (!test_bit(i, &subsys_mask))
+		if (!(subsys_mask & (1 << i)))
 			continue;
 
 		list_for_each_entry(cfts, &ss->cfts, node) {
-- 
1.9.0
