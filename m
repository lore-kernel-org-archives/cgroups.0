From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/15] kernel: convert task_struct.usage from atomic_t to refcount_t
Date: Fri,  7 Jul 2017 12:04:18 +0300
Message-ID: <1499418269-3686-5-git-send-email-elena.reshetova@intel.com>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499418269-3686-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/init_task.h  | 2 +-
 include/linux/sched.h      | 3 ++-
 include/linux/sched/task.h | 4 ++--
 kernel/fork.c              | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 369211d..348466a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -228,7 +228,7 @@ extern struct cred init_cred;
 	INIT_TASK_TI(tsk)						\
 	.state		= 0,						\
 	.stack		= init_stack,					\
-	.usage		= ATOMIC_INIT(2),				\
+	.usage		= REFCOUNT_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4e933f3..6a01517 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -20,6 +20,7 @@
 #include <linux/seccomp.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <linux/resource.h>
 #include <linux/latencytop.h>
 #include <linux/sched/prio.h>
@@ -516,7 +517,7 @@ struct task_struct {
 	randomized_struct_fields_start
 
 	void				*stack;
-	atomic_t			usage;
+	refcount_t			usage;
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index c97e5f0..afd5e58 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -86,13 +86,13 @@ extern void sched_exec(void);
 #define sched_exec()   {}
 #endif
 
-#define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
+#define get_task_struct(tsk) do { refcount_inc(&(tsk)->usage); } while(0)
 
 extern void __put_task_struct(struct task_struct *t);
 
 static inline void put_task_struct(struct task_struct *t)
 {
-	if (atomic_dec_and_test(&t->usage))
+	if (refcount_dec_and_test(&t->usage))
 		__put_task_struct(t);
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index a9763f6..c549b0b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -406,7 +406,7 @@ static inline void put_signal_struct(struct signal_struct *sig)
 void __put_task_struct(struct task_struct *tsk)
 {
 	WARN_ON(!tsk->exit_state);
-	WARN_ON(atomic_read(&tsk->usage));
+	WARN_ON(refcount_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
 	cgroup_free(tsk);
@@ -561,7 +561,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	 * One for us, one for whoever does the "release_task()" (usually
 	 * parent)
 	 */
-	atomic_set(&tsk->usage, 2);
+	refcount_set(&tsk->usage, 2);
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	tsk->btrace_seq = 0;
 #endif
-- 
2.7.4
