From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: avoid accessing modular cgroup subsys structure
 without locking
Date: Tue, 5 Mar 2013 10:57:03 +0800
Message-ID: <51355EFF.3080804@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

subsys[i] is set to NULL in cgroup_unload_subsys() at modular unload,
and that's protected by cgroup_mutex, and then the memory *subsys[i]
resides will be freed.

So this is unsafe without any locking:

  if (!ss || ss->module)
  ...

v2:
- add a comment for enum cgroup_subsys_id
- simplify the comment in cgroup_exit()

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 17 ++++++++++++++---
 kernel/cgroup.c        | 28 ++++++++++++++--------------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c6ec1..5f76829 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -44,14 +44,25 @@ extern void cgroup_unload_subsys(struct cgroup_subsys *ss);
 
 extern const struct file_operations proc_cgroup_operations;
 
-/* Define the enumeration of all builtin cgroup subsystems */
+/*
+ * Define the enumeration of all cgroup subsystems.
+ *
+ * We define ids for builtin subsystems and then modular ones.
+ */
 #define SUBSYS(_x) _x ## _subsys_id,
-#define IS_SUBSYS_ENABLED(option) IS_ENABLED(option)
 enum cgroup_subsys_id {
+#define IS_SUBSYS_ENABLED(option) IS_BUILTIN(option)
+#include <linux/cgroup_subsys.h>
+#undef IS_SUBSYS_ENABLED
+	CGROUP_BUILTIN_SUBSYS_COUNT,
+
+	__CGROUP_SUBSYS_TEMP_PLACEHOLDER = CGROUP_BUILTIN_SUBSYS_COUNT - 1,
+
+#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
 #include <linux/cgroup_subsys.h>
+#undef IS_SUBSYS_ENABLED
 	CGROUP_SUBSYS_COUNT,
 };
-#undef IS_SUBSYS_ENABLED
 #undef SUBSYS
 
 /* Per-subsystem/per-cgroup state maintained by the system. */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9df799d..7a6c4c7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4940,17 +4940,17 @@ void cgroup_post_fork(struct task_struct *child)
 	 * and addition to css_set.
 	 */
 	if (need_forkexit_callback) {
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * fork/exit callbacks are supported only for builtin
+		 * subsystems, and the builtin section of the subsys
+		 * array is immutable, so we don't need to lock the
+		 * subsys array here. On the other hand, modular section
+		 * of the array can be freed at module unload, so we
+		 * can't touch that.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			/*
-			 * fork/exit callbacks are supported only for
-			 * builtin subsystems and we don't need further
-			 * synchronization as they never go away.
-			 */
-			if (!ss || ss->module)
-				continue;
-
 			if (ss->fork)
 				ss->fork(child);
 		}
@@ -5015,13 +5015,13 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	tsk->cgroups = &init_css_set;
 
 	if (run_callbacks && need_forkexit_callback) {
-		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		/*
+		 * fork/exit callbacks are supported only for builtin
+		 * subsystems, see cgroup_post_fork() for details.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			/* modular subsystems can't use callbacks */
-			if (!ss || ss->module)
-				continue;
-
 			if (ss->exit) {
 				struct cgroup *old_cgrp =
 					rcu_dereference_raw(cg->subsys[i])->cgroup;
-- 
1.8.0.2
