From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v13 1/5] cgroup: use bitmask to filter for_each_subsys
Date: Sat,  6 Jun 2015 10:02:14 +1000
Message-ID: <1433548938-32560-1-git-send-email-cyphar@cyphar.com>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org
Cc: richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>

Add a new macro for_each_subsys_which that allows all enabled cgroup
subsystems to be filtered by a bitmask, such that mask & (1 << ssid)
determines if the subsystem is to be processed in the loop body (where
ssid is the unique id of the subsystem).

Also replace the need_forkexit_callback with two separate bitmasks for
each callback to make (ss->{fork,exit}) checks unnecessary.

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 include/linux/cgroup-defs.h |  2 ++
 kernel/cgroup.c             | 54 ++++++++++++++++++++++++++++-----------------
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 26d1cea..c5588c4 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -490,6 +490,8 @@ static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
 
 #else	/* CONFIG_CGROUPS */
 
+#define CGROUP_SUBSYS_COUNT 0
+
 static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk) {}
 static inline void cgroup_threadgroup_change_end(struct task_struct *tsk) {}
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0fd5227..5734717 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -178,12 +178,13 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
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
@@ -412,6 +413,25 @@ static int notify_on_release(const struct cgroup *cgrp)
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
+	if (!CGROUP_SUBSYS_COUNT)					\
+		;							\
+	else								\
+		for_each_set_bit(ssid, ss_maskp, CGROUP_SUBSYS_COUNT)	\
+			if (((ss) = cgroup_subsys[ssid]) && false)	\
+				break;					\
+			else
+
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
 	list_for_each_entry((root), &cgroup_roots, root_list)
@@ -4914,7 +4934,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	 * init_css_set is in the subsystem's root cgroup. */
 	init_css_set.subsys[ss->id] = css;
 
-	need_forkexit_callback |= ss->fork || ss->exit;
+	have_fork_callback |= (bool)ss->fork << ss->id;
+	have_exit_callback |= (bool)ss->exit << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5225,11 +5246,8 @@ void cgroup_post_fork(struct task_struct *child)
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
@@ -5273,16 +5291,12 @@ void cgroup_exit(struct task_struct *tsk)
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
2.4.2
