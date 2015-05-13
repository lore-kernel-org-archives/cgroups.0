From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] sched, cgroup: reorganize threadgroup locking
Date: Wed, 13 May 2015 16:35:16 -0400
Message-ID: <1431549318-16756-2-git-send-email-tj@kernel.org>
References: <1431549318-16756-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+AErZP/f1rZDPd9oIIhqXeN42uUIyH7SCNm++e8lOU4=;
        b=l1XO/PsAwFczeaGPtixYE4MspZL0XeYcIrVZ3spdO6GP1/KqwcTdwBXaDWXSr6Fc+4
         I7QmnaYHC21bG+yIIfTgVviaDzWOc4v8CedWNrEOK+t+Vx1/tEgr3fdiDXdsr90maDev
         Ift4a5zpmREYPIVPKDnwEoyYL/qHN9h3EQM5MeOuVzNV8IlEJ4I81Mim1CyB52NajO0A
         vAs/P1LfJW7UERNiyd5uc3mYUvzTz1UiygRkJvTKajh2GsE+6pB8VGOhC0yX5DgwBwWa
         aoaRuTciBhr6/mRtu4Fotuh/EU6T6Sm3Sz8C4NMMmzHKohNOI7V4qj+Fbu8qmZXWT2vy
         LycA==
In-Reply-To: <1431549318-16756-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

threadgroup_change_begin/end() are used to mark the beginning and end
of threadgroup modifying operations to allow code paths which require
a threadgroup to stay stable across blocking operations to synchronize
against those sections using threadgroup_lock/unlock().

It's currently implemented as a general mechanism in sched.h using
per-signal_struct rwsem; however, this never grew non-cgroup use cases
and becomes noop if !CONFIG_CGROUPS.  It turns out that cgroups is
gonna be better served with a different sycnrhonization scheme and is
a bit silly to keep cgroups specific details as a general mechanism.

What's general here is identifying the places where threadgroups are
modified.  This patch restructures threadgroup locking so that
threadgroup_change_begin/end() become a place where subsystems which
need to sycnhronize against threadgroup changes can hook into.

cgroup_threadgroup_change_begin/end() which operate on the
per-signal_struct rwsem are created and threadgroup_lock/unlock() are
moved to cgroup.c and made static.

This is pure reorganization which doesn't cause any functional
changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 include/linux/cgroup-defs.h | 10 +++++++++
 include/linux/sched.h       | 53 +++++++++++++++------------------------------
 kernel/cgroup.c             | 42 +++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 36 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 55f3120..1b8c938 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
+#include <linux/percpu-rwsem.h>
 #include <linux/workqueue.h>
 
 #ifdef CONFIG_CGROUPS
@@ -460,5 +461,14 @@ struct cgroup_subsys {
 	unsigned int depends_on;
 };
 
+void cgroup_threadgroup_change_begin(struct task_struct *tsk);
+void cgroup_threadgroup_change_end(struct task_struct *tsk);
+
+#else	/* CONFIG_CGROUPS */
+
+static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk) {}
+static inline void cgroup_threadgroup_change_end(struct task_struct *tsk) {}
+
 #endif	/* CONFIG_CGROUPS */
+
 #endif	/* _LINUX_CGROUP_DEFS_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8222ae4..5ee2900 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -58,6 +58,7 @@ struct sched_param {
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
 #include <linux/magic.h>
+#include <linux/cgroup-defs.h>
 
 #include <asm/processor.h>
 
@@ -2648,53 +2649,33 @@ static inline void unlock_task_sighand(struct task_struct *tsk,
 	spin_unlock_irqrestore(&tsk->sighand->siglock, *flags);
 }
 
-#ifdef CONFIG_CGROUPS
-static inline void threadgroup_change_begin(struct task_struct *tsk)
-{
-	down_read(&tsk->signal->group_rwsem);
-}
-static inline void threadgroup_change_end(struct task_struct *tsk)
-{
-	up_read(&tsk->signal->group_rwsem);
-}
-
 /**
- * threadgroup_lock - lock threadgroup
- * @tsk: member task of the threadgroup to lock
- *
- * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
- * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * change ->group_leader/pid.  This is useful for cases where the threadgroup
- * needs to stay stable across blockable operations.
+ * threadgroup_change_begin - mark the beginning of changes to a threadgroup
+ * @tsk: task causing the changes
  *
- * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
- * synchronization.  While held, no new task will be added to threadgroup
- * and no existing live task will have its PF_EXITING set.
- *
- * de_thread() does threadgroup_change_{begin|end}() when a non-leader
- * sub-thread becomes a new leader.
+ * All operations which modify a threadgroup - a new thread joining the
+ * group, death of a member thread (the assertion of PF_EXITING) and
+ * exec(2) dethreading the process and replacing the leader - are wrapped
+ * by threadgroup_change_{begin|end}().  This is to provide a place which
+ * subsystems needing threadgroup stability can hook into for
+ * synchronization.
  */
-static inline void threadgroup_lock(struct task_struct *tsk)
+static inline void threadgroup_change_begin(struct task_struct *tsk)
 {
-	down_write(&tsk->signal->group_rwsem);
+	might_sleep();
+	cgroup_threadgroup_change_begin(tsk);
 }
 
 /**
- * threadgroup_unlock - unlock threadgroup
- * @tsk: member task of the threadgroup to unlock
+ * threadgroup_change_end - mark the end of changes to a threadgroup
+ * @tsk: task causing the changes
  *
- * Reverse threadgroup_lock().
+ * See threadgroup_change_begin().
  */
-static inline void threadgroup_unlock(struct task_struct *tsk)
+static inline void threadgroup_change_end(struct task_struct *tsk)
 {
-	up_write(&tsk->signal->group_rwsem);
+	cgroup_threadgroup_change_end(tsk);
 }
-#else
-static inline void threadgroup_change_begin(struct task_struct *tsk) {}
-static inline void threadgroup_change_end(struct task_struct *tsk) {}
-static inline void threadgroup_lock(struct task_struct *tsk) {}
-static inline void threadgroup_unlock(struct task_struct *tsk) {}
-#endif
 
 #ifndef __HAVE_THREAD_FUNCTIONS
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cfa27f9..9309452 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -848,6 +848,48 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	return cset;
 }
 
+void cgroup_threadgroup_change_begin(struct task_struct *tsk)
+{
+	down_read(&tsk->signal->group_rwsem);
+}
+
+void cgroup_threadgroup_change_end(struct task_struct *tsk)
+{
+	up_read(&tsk->signal->group_rwsem);
+}
+
+/**
+ * threadgroup_lock - lock threadgroup
+ * @tsk: member task of the threadgroup to lock
+ *
+ * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
+ * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
+ *
+ * fork and exit explicitly call threadgroup_change_{begin|end}() for
+ * synchronization.  While held, no new task will be added to threadgroup
+ * and no existing live task will have its PF_EXITING set.
+ *
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
+ */
+static void threadgroup_lock(struct task_struct *tsk)
+{
+	down_write(&tsk->signal->group_rwsem);
+}
+
+/**
+ * threadgroup_unlock - unlock threadgroup
+ * @tsk: member task of the threadgroup to unlock
+ *
+ * Reverse threadgroup_lock().
+ */
+static inline void threadgroup_unlock(struct task_struct *tsk)
+{
+	up_write(&tsk->signal->group_rwsem);
+}
+
 static struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root)
 {
 	struct cgroup *root_cgrp = kf_root->kn->priv;
-- 
2.1.0
