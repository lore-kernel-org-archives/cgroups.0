From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 1/7] cgroup: switch to unsigned long for bitmasks
Date: Sat, 16 May 2015 14:13:35 +1000
Message-ID: <1431749621-30451-2-git-send-email-cyphar@cyphar.com>
References: <1431749621-30451-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431749621-30451-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Switch the type of all internal cgroup masks to (unsigned long), which
is the correct type for bitmasks. This is in preparation for the
for_each_subsys_which patch.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 469dd54..15896ed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -156,7 +156,7 @@ static bool cgrp_dfl_root_visible;
 static bool cgroup_legacy_files_on_dfl;
 
 /* some controllers are not supported in the default hierarchy */
-static unsigned int cgrp_dfl_root_inhibit_ss_mask;
+static unsigned long cgrp_dfl_root_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -186,7 +186,7 @@ static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
 static int rebind_subsystems(struct cgroup_root *dst_root,
-			     unsigned int ss_mask);
+			     unsigned long ss_mask);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
 		      bool visible);
@@ -998,7 +998,7 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned int subsys_mask);
+static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask);
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops;
 static const struct file_operations proc_cgroupstats_operations;
 
@@ -1068,11 +1068,11 @@ static void cgroup_put(struct cgroup *cgrp)
  * @subtree_control is to be applied to @cgrp.  The returned mask is always
  * a superset of @subtree_control and follows the usual hierarchy rules.
  */
-static unsigned int cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
-						  unsigned int subtree_control)
+static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
+						  unsigned long subtree_control)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	unsigned int cur_ss_mask = subtree_control;
+	unsigned long cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
 
@@ -1082,7 +1082,7 @@ static unsigned int cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 		return cur_ss_mask;
 
 	while (true) {
-		unsigned int new_ss_mask = cur_ss_mask;
+		unsigned long new_ss_mask = cur_ss_mask;
 
 		for_each_subsys(ss, ssid)
 			if (cur_ss_mask & (1 << ssid))
@@ -1200,7 +1200,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
  * @cgrp: target cgroup
  * @subsys_mask: mask of the subsystem ids whose files should be removed
  */
-static void cgroup_clear_dir(struct cgroup *cgrp, unsigned int subsys_mask)
+static void cgroup_clear_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
 	int i;
@@ -1215,10 +1215,11 @@ static void cgroup_clear_dir(struct cgroup *cgrp, unsigned int subsys_mask)
 	}
 }
 
-static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
+static int rebind_subsystems(struct cgroup_root *dst_root,
+			     unsigned long ss_mask)
 {
 	struct cgroup_subsys *ss;
-	unsigned int tmp_ss_mask;
+	unsigned long tmp_ss_mask;
 	int ssid, i, ret;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -1253,7 +1254,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 		 * Just warn about it and continue.
 		 */
 		if (cgrp_dfl_root_visible) {
-			pr_warn("failed to create files (%d) while rebinding 0x%x to default root\n",
+			pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
 				ret, ss_mask);
 			pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
 		}
@@ -1338,7 +1339,7 @@ static int cgroup_show_options(struct seq_file *seq,
 }
 
 struct cgroup_sb_opts {
-	unsigned int subsys_mask;
+	unsigned long subsys_mask;
 	unsigned int flags;
 	char *release_agent;
 	bool cpuset_clone_children;
@@ -1351,7 +1352,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data;
 	bool all_ss = false, one_ss = false;
-	unsigned int mask = -1U;
+	unsigned long mask = -1UL;
 	struct cgroup_subsys *ss;
 	int nr_opts = 0;
 	int i;
@@ -1495,7 +1496,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_sb_opts opts;
-	unsigned int added_mask, removed_mask;
+	unsigned long added_mask, removed_mask;
 
 	if (root == &cgrp_dfl_root) {
 		pr_err("remount is not allowed\n");
@@ -1641,7 +1642,7 @@ static void init_cgroup_root(struct cgroup_root *root,
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
-static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
+static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
@@ -2542,7 +2543,7 @@ static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static void cgroup_print_ss_mask(struct seq_file *seq, unsigned int ss_mask)
+static void cgroup_print_ss_mask(struct seq_file *seq, unsigned long ss_mask)
 {
 	struct cgroup_subsys *ss;
 	bool printed = false;
@@ -2689,8 +2690,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
 					    loff_t off)
 {
-	unsigned int enable = 0, disable = 0;
-	unsigned int css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
+	unsigned long enable = 0, disable = 0;
+	unsigned long css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -4322,7 +4323,7 @@ static struct cftype cgroup_legacy_base_files[] = {
  *
  * On failure, no file is added.
  */
-static int cgroup_populate_dir(struct cgroup *cgrp, unsigned int subsys_mask)
+static int cgroup_populate_dir(struct cgroup *cgrp, unsigned long subsys_mask)
 {
 	struct cgroup_subsys *ss;
 	int i, ret = 0;
-- 
2.4.1
