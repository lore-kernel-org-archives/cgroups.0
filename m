From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem
Date: Wed, 13 May 2015 16:35:17 -0400
Message-ID: <1431549318-16756-3-git-send-email-tj@kernel.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bPFvsrB+xyE2HfUxcFle7MfuPUCBz+3QA6p56Zc61yo=;
        b=nOX0K6CSCj+rZhuYF62BaL9MBuxvlB556iOt0YCYQDaONpS1FT7VymmH/wn2EflRiW
         DnMEwdklydClWR5xM4zpeH5PSI2GAp0MZ/0kZGq4rb0ewqD/oS2UoQW8AsUffmSveaka
         Buby2bZWmTHnuBlprsiHwwbXqEAod9ai5SH6ylj8GrLXQuWZoW/1e/ugPCx074mnd4gw
         5LtowEcHe+WVuekZQ8Ea81wCSHZW/irtkP9toeHagXiPmQo5khJy+4sVjHJnR66mTKAk
         ZTu6Ch1ZeILmpwPjIL7yeBBTfdE+2hUDozZzbgalD6xT0rNiYPX+rwgqdsSmuSTkacbu
         MPUg==
In-Reply-To: <1431549318-16756-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

The cgroup side of threadgroup locking uses signal_struct->group_rwsem
to synchronize against threadgroup changes.  This per-process rwsem
adds small overhead to thread creation, exit and exec paths, forces
cgroup code paths to do lock-verify-unlock-retry dance in a couple
places and makes it impossible to atomically perform operations across
multiple processes.

This patch replaces signal_struct->group_rwsem with a global
percpu_rwsem cgroup_threadgroup_rwsem which is cheaper on the reader
side and contained in cgroups proper.  This patch converts one-to-one.

This does make writer side heavier and lower the granularity; however,
cgroup process migration is a fairly cold path, we do want to optimize
thread operations over it and cgroup migration operations don't take
enough time for the lower granularity to matter.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/cgroup-defs.h | 27 ++++++++++++++--
 include/linux/init_task.h   |  8 -----
 include/linux/sched.h       | 12 -------
 init/Kconfig                |  1 +
 kernel/cgroup.c             | 77 ++++++++++++---------------------------------
 kernel/fork.c               |  4 ---
 6 files changed, 46 insertions(+), 83 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1b8c938..7d83d7f 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -461,8 +461,31 @@ struct cgroup_subsys {
 	unsigned int depends_on;
 };
 
-void cgroup_threadgroup_change_begin(struct task_struct *tsk);
-void cgroup_threadgroup_change_end(struct task_struct *tsk);
+extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
+
+/**
+ * cgroup_threadgroup_change_begin - threadgroup exclusion for cgroups
+ * @tsk: target task
+ *
+ * Called from threadgroup_change_begin() and allows cgroup operations to
+ * synchronize against threadgroup changes using a percpu_rw_semaphore.
+ */
+static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk)
+{
+	percpu_down_read(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_threadgroup_change_end - threadgroup exclusion for cgroups
+ * @tsk: target task
+ *
+ * Called from threadgroup_change_end().  Counterpart of
+ * cgroup_threadcgroup_change_begin().
+ */
+static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
+{
+	percpu_up_read(&cgroup_threadgroup_rwsem);
+}
 
 #else	/* CONFIG_CGROUPS */
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 696d223..0cc0bbf 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -25,13 +25,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
-#ifdef CONFIG_CGROUPS
-#define INIT_GROUP_RWSEM(sig)						\
-	.group_rwsem = __RWSEM_INITIALIZER(sig.group_rwsem),
-#else
-#define INIT_GROUP_RWSEM(sig)
-#endif
-
 #ifdef CONFIG_CPUSETS
 #define INIT_CPUSET_SEQ(tsk)							\
 	.mems_allowed_seq = SEQCNT_ZERO(tsk.mems_allowed_seq),
@@ -56,7 +49,6 @@ extern struct fs_struct init_fs;
 	},								\
 	.cred_guard_mutex =						\
 		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
-	INIT_GROUP_RWSEM(sig)						\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ee2900..add524a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -743,18 +743,6 @@ struct signal_struct {
 	unsigned audit_tty_log_passwd;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
-#ifdef CONFIG_CGROUPS
-	/*
-	 * group_rwsem prevents new tasks from entering the threadgroup and
-	 * member tasks from exiting,a more specifically, setting of
-	 * PF_EXITING.  fork and exit paths are protected with this rwsem
-	 * using threadgroup_change_begin/end().  Users which require
-	 * threadgroup to remain stable should use threadgroup_[un]lock()
-	 * which also takes care of exec path.  Currently, cgroup is the
-	 * only user.
-	 */
-	struct rw_semaphore group_rwsem;
-#endif
 
 	oom_flags_t oom_flags;
 	short oom_score_adj;		/* OOM kill score adjustment */
diff --git a/init/Kconfig b/init/Kconfig
index dc24dec..b9b824b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -938,6 +938,7 @@ config NUMA_BALANCING_DEFAULT_ENABLED
 menuconfig CGROUPS
 	bool "Control Group support"
 	select KERNFS
+	select PERCPU_RWSEM
 	help
 	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9309452..5435b9d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
+#include <linux/percpu-rwsem.h>
 #include <linux/string.h>
 #include <linux/sort.h>
 #include <linux/kmod.h>
@@ -103,6 +104,8 @@ static DEFINE_SPINLOCK(cgroup_idr_lock);
  */
 static DEFINE_SPINLOCK(release_agent_path_lock);
 
+struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
+
 #define cgroup_assert_mutex_or_rcu_locked()				\
 	rcu_lockdep_assert(rcu_read_lock_held() ||			\
 			   lockdep_is_held(&cgroup_mutex),		\
@@ -848,48 +851,6 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	return cset;
 }
 
-void cgroup_threadgroup_change_begin(struct task_struct *tsk)
-{
-	down_read(&tsk->signal->group_rwsem);
-}
-
-void cgroup_threadgroup_change_end(struct task_struct *tsk)
-{
-	up_read(&tsk->signal->group_rwsem);
-}
-
-/**
- * threadgroup_lock - lock threadgroup
- * @tsk: member task of the threadgroup to lock
- *
- * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
- * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * change ->group_leader/pid.  This is useful for cases where the threadgroup
- * needs to stay stable across blockable operations.
- *
- * fork and exit explicitly call threadgroup_change_{begin|end}() for
- * synchronization.  While held, no new task will be added to threadgroup
- * and no existing live task will have its PF_EXITING set.
- *
- * de_thread() does threadgroup_change_{begin|end}() when a non-leader
- * sub-thread becomes a new leader.
- */
-static void threadgroup_lock(struct task_struct *tsk)
-{
-	down_write(&tsk->signal->group_rwsem);
-}
-
-/**
- * threadgroup_unlock - unlock threadgroup
- * @tsk: member task of the threadgroup to unlock
- *
- * Reverse threadgroup_lock().
- */
-static inline void threadgroup_unlock(struct task_struct *tsk)
-{
-	up_write(&tsk->signal->group_rwsem);
-}
-
 static struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
 {
 	struct cgroup *root_cgrp = kf_root->kn->priv;
@@ -2094,9 +2055,9 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	lockdep_assert_held(&css_set_rwsem);
 
 	/*
-	 * We are synchronized through threadgroup_lock() against PF_EXITING
-	 * setting such that we can't race against cgroup_exit() changing the
-	 * css_set to init_css_set and dropping the old one.
+	 * We are synchronized through cgroup_threadgroup_rwsem against
+	 * PF_EXITING setting such that we can't race against cgroup_exit()
+	 * changing the css_set to init_css_set and dropping the old one.
 	 */
 	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	old_cset = task_css_set(tsk);
@@ -2153,10 +2114,11 @@ static void cgroup_migrate_finish(struct list_head *preloaded_csets)
  * @src_cset and add it to @preloaded_csets, which should later be cleaned
  * up by cgroup_migrate_finish().
  *
- * This function may be called without holding threadgroup_lock even if the
- * target is a process.  Threads may be created and destroyed but as long
- * as cgroup_mutex is not dropped, no new css_set can be put into play and
- * the preloaded css_sets are guaranteed to cover all migrations.
+ * This function may be called without holding cgroup_threadgroup_rwsem
+ * even if the target is a process.  Threads may be created and destroyed
+ * but as long as cgroup_mutex is not dropped, no new css_set can be put
+ * into play and the preloaded css_sets are guaranteed to cover all
+ * migrations.
  */
 static void cgroup_migrate_add_src(struct css_set *src_cset,
 				   struct cgroup *dst_cgrp,
@@ -2259,7 +2221,7 @@ err:
  * @threadgroup: whether @leader points to the whole process or a single task
  *
  * Migrate a process or task denoted by @leader to @cgrp.  If migrating a
- * process, the caller must be holding threadgroup_lock of @leader.  The
+ * process, the caller must be holding cgroup_threadgroup_rwsem.  The
  * caller is also responsible for invoking cgroup_migrate_add_src() and
  * cgroup_migrate_prepare_dst() on the targets before invoking this
  * function and following up with cgroup_migrate_finish().
@@ -2387,7 +2349,7 @@ out_release_tset:
  * @leader: the task or the leader of the threadgroup to be attached
  * @threadgroup: attach the whole threadgroup?
  *
- * Call holding cgroup_mutex and threadgroup_lock of @leader.
+ * Call holding cgroup_mutex and cgroup_threadgroup_rwsem.
  */
 static int cgroup_attach_task(struct cgroup *dst_cgrp,
 			      struct task_struct *leader, bool threadgroup)
@@ -2480,7 +2442,7 @@ retry_find_task:
 	get_task_struct(tsk);
 	rcu_read_unlock();
 
-	threadgroup_lock(tsk);
+	percpu_down_write(&cgroup_threadgroup_rwsem);
 	if (threadgroup) {
 		if (!thread_group_leader(tsk)) {
 			/*
@@ -2490,7 +2452,7 @@ retry_find_task:
 			 * try again; this is
 			 * "double-double-toil-and-trouble-check locking".
 			 */
-			threadgroup_unlock(tsk);
+			percpu_up_write(&cgroup_threadgroup_rwsem);
 			put_task_struct(tsk);
 			goto retry_find_task;
 		}
@@ -2498,7 +2460,7 @@ retry_find_task:
 
 	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
 
-	threadgroup_unlock(tsk);
+	percpu_up_write(&cgroup_threadgroup_rwsem);
 
 	put_task_struct(tsk);
 out_unlock_cgroup:
@@ -2703,17 +2665,17 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 				goto out_finish;
 			last_task = task;
 
-			threadgroup_lock(task);
+			percpu_down_write(&cgroup_threadgroup_rwsem);
 			/* raced against de_thread() from another thread? */
 			if (!thread_group_leader(task)) {
-				threadgroup_unlock(task);
+				percpu_up_write(&cgroup_threadgroup_rwsem);
 				put_task_struct(task);
 				continue;
 			}
 
 			ret = cgroup_migrate(src_cset->dfl_cgrp, task, true);
 
-			threadgroup_unlock(task);
+			percpu_up_write(&cgroup_threadgroup_rwsem);
 			put_task_struct(task);
 
 			if (WARN(ret, "cgroup: failed to update controllers for the default hierarchy (%d), further operations may crash or hang\n", ret))
@@ -5031,6 +4993,7 @@ int __init cgroup_init(void)
 	unsigned long key;
 	int ssid, err;
 
+	BUG_ON(percpu_init_rwsem(&cgroup_threadgroup_rwsem));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 03c1eaa..9531275 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1144,10 +1144,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	tty_audit_fork(sig);
 	sched_autogroup_fork(sig);
 
-#ifdef CONFIG_CGROUPS
-	init_rwsem(&sig->group_rwsem);
-#endif
-
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
-- 
2.1.0
