From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 2/8] cgroup: use bitmask to filter for_each_subsys
Date: Tue, 19 May 2015 00:51:01 +1000
Message-ID: <1431960667-26593-3-git-send-email-cyphar@cyphar.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431960667-26593-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Add a new macro for_each_subsys_which that allows all enabled cgroup
subsystems to be filtered by a bitmask, such that mask & (1 << ssid)
determines if the subsystem is to be processed in the loop body (where
ssid is the unique id of the subsystem).

Also replace the need_forkexit_callback with two separate bitmasks for
each callback to make (ss->{fork,exit}) checks unnecessary.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 15896ed..d66fb20 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -175,12 +175,13 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
  */
 static u64 css_serial_nr_next = 1;
 
-/* This flag indicates whether tasks in the fork and exit paths should
- * check for fork/exit handlers to call. This avoids us having to do
- * extra work in the fork/exit path if none of the subsystems need to
- * be called.
+/*
+ * These bitmask flags indicate whether tasks in the fork and exit paths have
+ * fork/exit handlers to call. This avoids us having to do extra work in the
+ * fork/exit path to check which subsystems have fork/exit callbacks.
  */
-static int need_forkexit_callback __read_mostly;
+static unsigned long have_fork_callback __read_mostly;
+static unsigned long have_exit_callback __read_mostly;
 
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
@@ -409,6 +410,22 @@ static int notify_on_release(const struct cgroup *cgrp)
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
 	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
 
+
+/**
+ * for_each_subsys_which - filter for_each_subsys with a bitmask
+ * @ss: the iteration cursor
+ * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
+ * @ss_maskp: a pointer to the bitmask
+ *
+ * The block will only run for cases where the ssid-th bit (1 << ssid) of
+ * mask is set to 1.
+ */
+#define for_each_subsys_which(ss, ssid, ss_maskp)			\
+	for_each_set_bit(ssid, ss_maskp, CGROUP_SUBSYS_COUNT)		\
+		if (((ss) = cgroup_subsys[ssid]) && false)		\
+			;						\
+		else
+
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
 	list_for_each_entry((root), &cgroup_roots, root_list)
@@ -4932,7 +4949,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	 * init_css_set is in the subsystem's root cgroup. */
 	init_css_set.subsys[ss->id] = css;
 
-	need_forkexit_callback |= ss->fork || ss->exit;
+	have_fork_callback |= (bool)ss->fork << ss->id;
+	have_exit_callback |= (bool)ss->exit << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5242,11 +5260,8 @@ void cgroup_post_fork(struct task_struct *child)
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
 	 */
-	if (need_forkexit_callback) {
-		for_each_subsys(ss, i)
-			if (ss->fork)
-				ss->fork(child);
-	}
+	for_each_subsys_which(ss, i, &have_fork_callback)
+		ss->fork(child);
 }
 
 /**
@@ -5290,16 +5305,12 @@ void cgroup_exit(struct task_struct *tsk)
 	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
-	if (need_forkexit_callback) {
-		/* see cgroup_post_fork() for details */
-		for_each_subsys(ss, i) {
-			if (ss->exit) {
-				struct cgroup_subsys_state *old_css = cset->subsys[i];
-				struct cgroup_subsys_state *css = task_css(tsk, i);
+	/* see cgroup_post_fork() for details */
+	for_each_subsys_which(ss, i, &have_exit_callback) {
+		struct cgroup_subsys_state *old_css = cset->subsys[i];
+		struct cgroup_subsys_state *css = task_css(tsk, i);
 
-				ss->exit(css, old_css, tsk);
-			}
-		}
+		ss->exit(css, old_css, tsk);
 	}
 
 	if (put_cset)
-- 
2.4.1
