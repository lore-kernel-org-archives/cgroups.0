From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v7 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed,  1 Apr 2015 13:31:27 +1100
Message-ID: <1427855490-5280-2-git-send-email-cyphar@cyphar.com>
References: <1427855490-5280-1-git-send-email-cyphar@cyphar.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427855490-5280-1-git-send-email-cyphar@cyphar.com>
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

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 29a7b2c..1d69a085 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -175,12 +175,14 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
  */
 static u64 css_serial_nr_next = 1;
 
-/* This flag indicates whether tasks in the fork and exit paths should
+/*
+ * These bitmask flags indicate whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
  * extra work in the fork/exit path if none of the subsystems need to
  * be called.
  */
-static int need_forkexit_callback __read_mostly;
+static int need_fork_callback __read_mostly;
+static int need_exit_callback __read_mostly;
 
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
@@ -409,6 +411,19 @@ static int notify_on_release(const struct cgroup *cgrp)
 	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
 	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
 
+/**
+ * for_each_subsys_which - filter for_each_subsys with a bitmask
+ * @ss_mask: the bitmask
+ * @ss: the iteration cursor
+ * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
+ *
+ * The block will only run for cases where the ssid-th bit (1 << ssid) of
+ * mask is set to 1.
+ */
+#define for_each_subsys_which(ss_mask, ss, ssid) \
+	for_each_subsys((ss), (ssid)) \
+		if ((ss_mask) & (1 << (ssid)))
+
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
 	list_for_each_entry((root), &cgroup_roots, root_list)
@@ -4932,7 +4947,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	 * init_css_set is in the subsystem's root cgroup. */
 	init_css_set.subsys[ss->id] = css;
 
-	need_forkexit_callback |= ss->fork || ss->exit;
+	need_fork_callback |= (bool) ss->fork << ss->id;
+	need_exit_callback |= (bool) ss->exit << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
@@ -5239,11 +5255,8 @@ void cgroup_post_fork(struct task_struct *child)
 	 * css_set; otherwise, @child might change state between ->fork()
 	 * and addition to css_set.
 	 */
-	if (need_forkexit_callback) {
-		for_each_subsys(ss, i)
-			if (ss->fork)
-				ss->fork(child);
-	}
+	for_each_subsys_which(need_fork_callback, ss, i)
+		ss->fork(child);
 }
 
 /**
@@ -5287,16 +5300,12 @@ void cgroup_exit(struct task_struct *tsk)
 	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
-	if (need_forkexit_callback) {
-		/* see cgroup_post_fork() for details */
-		for_each_subsys(ss, i) {
-			if (ss->exit) {
-				struct cgroup_subsys_state *old_css = cset->subsys[i];
-				struct cgroup_subsys_state *css = task_css(tsk, i);
+	/* see cgroup_post_fork() for details */
+	for_each_subsys_which(need_exit_callback, ss, i) {
+		struct cgroup_subsys_state *old_css = cset->subsys[i];
+		struct cgroup_subsys_state *css = task_css(tsk, i);
 
-				ss->exit(css, old_css, tsk);
-			}
-		}
+		ss->exit(css, old_css, tsk);
 	}
 
 	if (put_cset)
-- 
2.3.4
