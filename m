From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 6/6] cgroup: make cgroup subsystem masks u16
Date: Mon, 22 Feb 2016 22:27:04 -0500
Message-ID: <20160223032704.GS3965@htj.duckdns.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
 <1456182349-18156-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PHzmmamnqEQjJLlyNVomBc6rYPst9xcmXMa+G3vCdpM=;
        b=X/kxYft0AGCCXydmstxbckqbbqCfmwPAVi2A0Z4n6h1YOOwy6Ifbf05r46KbPqXlqT
         161PR9zCFkMQeiLedPRaKm65aWzQtbTTCrUik1ELuQ7ZAMCP/WVkWjpkcXXL4zCCP3xz
         N2V3km/yZnal9Jy6zmF0MravKKWC2y6JNpzEKtzw0gV+I0DiDUYFB/Led04vDB9/KaEr
         pqlOgVCzkal8otD2K5eJioO0yr6BK4wjubTK0z4Mh30iSq7zQHw0gKPC1dyNzM5cU5hG
         l9wUqirMRO9ya0XKNFQK6QzenZRM7RyHP2+38s864/4lr5SzrORAAP5Aa7mSLlOMdM8y
         Gs5A==
Content-Disposition: inline
In-Reply-To: <1456182349-18156-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 6e5c830770f9045a17b1b931c3e11fbd5591e630 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 22 Feb 2016 22:25:47 -0500

After the recent do_each_subsys_mask() conversion, there's no reason
to use ulong for subsystem masks.  We'll be adding more subsystem
masks to persistent data structures, let's reduce its size to u16
which should be enough for now and the foreseeable future.

This doesn't create any noticeable behavior differences.

v2: Johannes spotted that the initial patch missed cgroup_no_v1_mask.
    Converted.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/cgroup-defs.h |  4 ++--
 kernel/cgroup.c             | 50 ++++++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index c68ae7f..0abf6aa 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -257,8 +257,8 @@ struct cgroup {
 	 * one which may have more subsystems enabled.  Controller knobs
 	 * are made available iff it's enabled in ->subtree_control.
 	 */
-	unsigned long subtree_control;
-	unsigned long subtree_ss_mask;
+	u16 subtree_control;
+	u16 subtree_ss_mask;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1e561bd..7669f68 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -181,10 +181,10 @@ EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 static bool cgrp_dfl_root_visible;
 
 /* Controllers blocked by the commandline in v1 */
-static unsigned long cgroup_no_v1_mask;
+static u16 cgroup_no_v1_mask;
 
 /* some controllers are not supported in the default hierarchy */
-static unsigned long cgrp_dfl_root_inhibit_ss_mask;
+static u16 cgrp_dfl_root_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -208,19 +208,18 @@ static u64 css_serial_nr_next = 1;
  * fork/exit handlers to call. This avoids us having to do extra work in the
  * fork/exit path to check which subsystems have fork/exit callbacks.
  */
-static unsigned long have_fork_callback __read_mostly;
-static unsigned long have_exit_callback __read_mostly;
-static unsigned long have_free_callback __read_mostly;
+static u16 have_fork_callback __read_mostly;
+static u16 have_exit_callback __read_mostly;
+static u16 have_free_callback __read_mostly;
 
 /* Ditto for the can_fork callback. */
-static unsigned long have_canfork_callback __read_mostly;
+static u16 have_canfork_callback __read_mostly;
 
 static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
-static int rebind_subsystems(struct cgroup_root *dst_root,
-			     unsigned long ss_mask);
+static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask);
 static void css_task_iter_advance(struct css_task_iter *it);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss,
@@ -1274,11 +1273,10 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
  * @subtree_control is to be applied to @cgrp.  The returned mask is always
  * a superset of @subtree_control and follows the usual hierarchy rules.
  */
-static unsigned long cgroup_calc_subtree_ss_mask(struct cgroup *cgrp,
-						 unsigned long subtree_control)
+static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	unsigned long cur_ss_mask = subtree_control;
+	u16 cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
 
@@ -1288,7 +1286,7 @@ static unsigned long cgroup_calc_subtree_ss_mask(struct cgroup *cgrp,
 		return cur_ss_mask;
 
 	while (true) {
-		unsigned long new_ss_mask = cur_ss_mask;
+		u16 new_ss_mask = cur_ss_mask;
 
 		do_each_subsys_mask(ss, ssid, cur_ss_mask) {
 			new_ss_mask |= ss->depends_on;
@@ -1466,12 +1464,11 @@ static int css_populate_dir(struct cgroup_subsys_state *css,
 	return ret;
 }
 
-static int rebind_subsystems(struct cgroup_root *dst_root,
-			     unsigned long ss_mask)
+static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 {
 	struct cgroup *dcgrp = &dst_root->cgrp;
 	struct cgroup_subsys *ss;
-	unsigned long tmp_ss_mask;
+	u16 tmp_ss_mask;
 	int ssid, i, ret;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -1507,7 +1504,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		 */
 		if (dst_root == &cgrp_dfl_root) {
 			if (cgrp_dfl_root_visible) {
-				pr_warn("failed to create files (%d) while rebinding 0x%lx to default root\n",
+				pr_warn("failed to create files (%d) while rebinding 0x%x to default root\n",
 					ret, ss_mask);
 				pr_warn("you may retry by moving them to a different hierarchy and unbinding\n");
 			}
@@ -1599,7 +1596,7 @@ static int cgroup_show_options(struct seq_file *seq,
 }
 
 struct cgroup_sb_opts {
-	unsigned long subsys_mask;
+	u16 subsys_mask;
 	unsigned int flags;
 	char *release_agent;
 	bool cpuset_clone_children;
@@ -1612,13 +1609,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 {
 	char *token, *o = data;
 	bool all_ss = false, one_ss = false;
-	unsigned long mask = -1UL;
+	u16 mask = U16_MAX;
 	struct cgroup_subsys *ss;
 	int nr_opts = 0;
 	int i;
 
 #ifdef CONFIG_CPUSETS
-	mask = ~(1U << cpuset_cgrp_id);
+	mask = ~((u16)1 << cpuset_cgrp_id);
 #endif
 
 	memset(opts, 0, sizeof(*opts));
@@ -1745,7 +1742,7 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	int ret = 0;
 	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
 	struct cgroup_sb_opts opts;
-	unsigned long added_mask, removed_mask;
+	u16 added_mask, removed_mask;
 
 	if (root == &cgrp_dfl_root) {
 		pr_err("remount is not allowed\n");
@@ -1893,7 +1890,7 @@ static void init_cgroup_root(struct cgroup_root *root,
 		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
 }
 
-static int cgroup_setup_root(struct cgroup_root *root, unsigned long ss_mask)
+static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 {
 	LIST_HEAD(tmp_links);
 	struct cgroup *root_cgrp = &root->cgrp;
@@ -2839,7 +2836,7 @@ static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static void cgroup_print_ss_mask(struct seq_file *seq, unsigned long ss_mask)
+static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 {
 	struct cgroup_subsys *ss;
 	bool printed = false;
@@ -2950,8 +2947,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
 					    loff_t off)
 {
-	unsigned long enable = 0, disable = 0;
-	unsigned long css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
+	u16 enable = 0, disable = 0;
+	u16 css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -5255,7 +5252,7 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static unsigned long cgroup_disable_mask __initdata;
+static u16 cgroup_disable_mask __initdata;
 
 /**
  * cgroup_init - cgroup initialization
@@ -5269,6 +5266,7 @@ int __init cgroup_init(void)
 	unsigned long key;
 	int ssid;
 
+	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
 	BUG_ON(percpu_init_rwsem(&cgroup_threadgroup_rwsem));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
@@ -5754,7 +5752,7 @@ static int __init cgroup_no_v1(char *str)
 			continue;
 
 		if (!strcmp(token, "all")) {
-			cgroup_no_v1_mask = ~0UL;
+			cgroup_no_v1_mask = U16_MAX;
 			break;
 		}
 
-- 
2.5.0
