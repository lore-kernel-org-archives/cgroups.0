From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: convert for_each_subsys_which() to do-while style
Date: Mon, 22 Feb 2016 18:05:47 -0500
Message-ID: <1456182349-18156-5-git-send-email-tj@kernel.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pk9AMkvw+AXSJS7Uefe7cPh9ojrxHitoJiiEDMpbFbk=;
        b=OS0gHVj20UwyVM7QXsJ3xfeT+ws9OOUZp7hPkdZ42y9CUJBabP+cPh5wIJi+ntH86j
         Q/Loo4hy6ATyyb5dDxz31ahBuL6CBv8wm34CYTNgmv5iuxz4ZF6DqFIjoB7NEoCBIfCG
         iWsO4DUzuna2G4qKzzu7pGCyOZIQio1YfoIH712OkFndCN8y58lEYdQ4YdVwVoMJs7Mt
         oB7fKgxQ5bBXpVSkBNFQY+qC/SxDd4RZEDa6odSUxGkCGVKhBk3atAvC9WYHz7HBnESc
         scoLNMciOtYoySdnDDL++hDHEcXulPhInx643vBHwek32nYpLQq6R91QHI+qavY6j+3g
         SA3w==
In-Reply-To: <1456182349-18156-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>

for_each_subsys_which() allows iterating subsystems specified in a
subsystem bitmask; unfortunately, it requires the mask to be an
unsigned long l-value which can be inconvenient and makes it awkward
to use a smaller type for subsystem masks.

This patch converts for_each_subsy_which() to do-while style which
allows it to drop the l-value requirement.  The new iterator is named
do_each_subsys_mask() / while_each_subsys_mask().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup.c | 72 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f3cd67b..5d10298 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -514,22 +514,28 @@ static int notify_on_release(const struct cgroup *cgrp)
 	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
 
 /**
- * for_each_subsys_which - filter for_each_subsys with a bitmask
+ * do_each_subsys_mask - filter for_each_subsys with a bitmask
  * @ss: the iteration cursor
  * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
- * @ss_maskp: a pointer to the bitmask
+ * @ss_mask: the bitmask
  *
  * The block will only run for cases where the ssid-th bit (1 << ssid) of
- * mask is set to 1.
+ * @ss_mask is set.
  */
-#define for_each_subsys_which(ss, ssid, ss_maskp)			\
-	if (!CGROUP_SUBSYS_COUNT) /* to avoid spurious gcc warning */	\
+#define do_each_subsys_mask(ss, ssid, ss_mask) do {			\
+	unsigned long __ss_mask = (ss_mask);				\
+	if (!CGROUP_SUBSYS_COUNT) { /* to avoid spurious gcc warning */	\
 		(ssid) = 0;						\
-	else								\
-		for_each_set_bit(ssid, ss_maskp, CGROUP_SUBSYS_COUNT)	\
-			if (((ss) = cgroup_subsys[ssid]) && false)	\
-				break;					\
-			else
+		break;							\
+	}								\
+	for_each_set_bit(ssid, &__ss_mask, CGROUP_SUBSYS_COUNT) {	\
+		(ss) = cgroup_subsys[ssid];				\
+		{
+
+#define while_each_subsys_mask()					\
+		}							\
+	}								\
+} while (false)
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
@@ -1284,8 +1290,9 @@ static unsigned long cgroup_calc_subtree_ss_mask(struct cgroup *cgrp,
 	while (true) {
 		unsigned long new_ss_mask = cur_ss_mask;
 
-		for_each_subsys_which(ss, ssid, &cur_ss_mask)
+		do_each_subsys_mask(ss, ssid, cur_ss_mask) {
 			new_ss_mask |= ss->depends_on;
+		} while_each_subsys_mask();
 
 		/*
 		 * Mask out subsystems which aren't available.  This can
@@ -1469,7 +1476,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	for_each_subsys_which(ss, ssid, &ss_mask) {
+	do_each_subsys_mask(ss, ssid, ss_mask) {
 		/* if @ss has non-root csses attached to it, can't move */
 		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
 			return -EBUSY;
@@ -1477,14 +1484,14 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		/* can't move between two non-dummy roots either */
 		if (ss->root != &cgrp_dfl_root && dst_root != &cgrp_dfl_root)
 			return -EBUSY;
-	}
+	} while_each_subsys_mask();
 
 	/* skip creating root files on dfl_root for inhibited subsystems */
 	tmp_ss_mask = ss_mask;
 	if (dst_root == &cgrp_dfl_root)
 		tmp_ss_mask &= ~cgrp_dfl_root_inhibit_ss_mask;
 
-	for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
+	do_each_subsys_mask(ss, ssid, tmp_ss_mask) {
 		struct cgroup *scgrp = &ss->root->cgrp;
 		int tssid;
 
@@ -1507,19 +1514,19 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 			continue;
 		}
 
-		for_each_subsys_which(ss, tssid, &tmp_ss_mask) {
+		do_each_subsys_mask(ss, tssid, tmp_ss_mask) {
 			if (tssid == ssid)
 				break;
 			css_clear_dir(cgroup_css(scgrp, ss), dcgrp);
-		}
+		} while_each_subsys_mask();
 		return ret;
-	}
+	} while_each_subsys_mask();
 
 	/*
 	 * Nothing can fail from this point on.  Remove files for the
 	 * removed subsystems and rebind each subsystem.
 	 */
-	for_each_subsys_which(ss, ssid, &ss_mask) {
+	do_each_subsys_mask(ss, ssid, ss_mask) {
 		struct cgroup_root *src_root = ss->root;
 		struct cgroup *scgrp = &src_root->cgrp;
 		struct cgroup_subsys_state *css = cgroup_css(scgrp, ss);
@@ -1556,7 +1563,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 		if (ss->bind)
 			ss->bind(css);
-	}
+	} while_each_subsys_mask();
 
 	kernfs_activate(dcgrp->kn);
 	return 0;
@@ -2838,12 +2845,12 @@ static void cgroup_print_ss_mask(struct seq_file *seq, unsigned long ss_mask)
 	bool printed = false;
 	int ssid;
 
-	for_each_subsys_which(ss, ssid, &ss_mask) {
+	do_each_subsys_mask(ss, ssid, ss_mask) {
 		if (printed)
 			seq_putc(seq, ' ');
 		seq_printf(seq, "%s", ss->name);
 		printed = true;
-	}
+	} while_each_subsys_mask();
 	if (printed)
 		seq_putc(seq, '\n');
 }
@@ -2956,11 +2963,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 */
 	buf = strstrip(buf);
 	while ((tok = strsep(&buf, " "))) {
-		unsigned long tmp_ss_mask = ~cgrp_dfl_root_inhibit_ss_mask;
-
 		if (tok[0] == '\0')
 			continue;
-		for_each_subsys_which(ss, ssid, &tmp_ss_mask) {
+		do_each_subsys_mask(ss, ssid, ~cgrp_dfl_root_inhibit_ss_mask) {
 			if (!cgroup_ssid_enabled(ssid) ||
 			    strcmp(tok + 1, ss->name))
 				continue;
@@ -2975,7 +2980,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				return -EINVAL;
 			}
 			break;
-		}
+		} while_each_subsys_mask();
 		if (ssid == CGROUP_SUBSYS_COUNT)
 			return -EINVAL;
 	}
@@ -3049,7 +3054,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * still around.  In such cases, wait till it's gone using
 	 * offline_waitq.
 	 */
-	for_each_subsys_which(ss, ssid, &css_enable) {
+	do_each_subsys_mask(ss, ssid, css_enable) {
 		cgroup_for_each_live_child(child, cgrp) {
 			DEFINE_WAIT(wait);
 
@@ -3066,7 +3071,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 			return restart_syscall();
 		}
-	}
+	} while_each_subsys_mask();
 
 	cgrp->subtree_control = new_sc;
 	cgrp->subtree_ss_mask = new_ss;
@@ -5509,11 +5514,11 @@ int cgroup_can_fork(struct task_struct *child)
 	struct cgroup_subsys *ss;
 	int i, j, ret;
 
-	for_each_subsys_which(ss, i, &have_canfork_callback) {
+	do_each_subsys_mask(ss, i, have_canfork_callback) {
 		ret = ss->can_fork(child);
 		if (ret)
 			goto out_revert;
-	}
+	} while_each_subsys_mask();
 
 	return 0;
 
@@ -5598,8 +5603,9 @@ void cgroup_post_fork(struct task_struct *child)
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
 	 */
-	for_each_subsys_which(ss, i, &have_fork_callback)
+	do_each_subsys_mask(ss, i, have_fork_callback) {
 		ss->fork(child);
+	} while_each_subsys_mask();
 }
 
 /**
@@ -5642,8 +5648,9 @@ void cgroup_exit(struct task_struct *tsk)
 	}
 
 	/* see cgroup_post_fork() for details */
-	for_each_subsys_which(ss, i, &have_exit_callback)
+	do_each_subsys_mask(ss, i, have_exit_callback) {
 		ss->exit(tsk);
+	} while_each_subsys_mask();
 }
 
 void cgroup_free(struct task_struct *task)
@@ -5652,8 +5659,9 @@ void cgroup_free(struct task_struct *task)
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	for_each_subsys_which(ss, ssid, &have_free_callback)
+	do_each_subsys_mask(ss, ssid, have_free_callback) {
 		ss->free(task);
+	} while_each_subsys_mask();
 
 	put_css_set(cset);
 }
-- 
2.5.0

