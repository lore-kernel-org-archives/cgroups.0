From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 05/15] kernel: convert task_struct.stack_refcount from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:16 +0300
Message-ID: <1500288206-12074-6-git-send-email-elena.reshetova@intel.com>
References: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, tglx@linutronix.de, Elena Reshetova <elena.reshetova@intel.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 include/linux/init_task.h        | 3 ++-
 include/linux/sched.h            | 2 +-
 include/linux/sched/task_stack.h | 2 +-
 kernel/fork.c                    | 6 +++---
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 7ba3fca..8be9369 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -12,6 +12,7 @@
 #include <linux/securebits.h>
 #include <linux/seqlock.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <linux/sched/autogroup.h>
 #include <net/net_namespace.h>
 #include <linux/sched/rt.h>
@@ -214,7 +215,7 @@ extern struct cred init_cred;
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 # define INIT_TASK_TI(tsk)			\
 	.thread_info = INIT_THREAD_INFO(tsk),	\
-	.stack_refcount = ATOMIC_INIT(1),
+	.stack_refcount = REFCOUNT_INIT(1),
 #else
 # define INIT_TASK_TI(tsk)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9380e44..bd49917 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1078,7 +1078,7 @@ struct task_struct {
 #endif
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/* A live task holds one reference: */
-	atomic_t			stack_refcount;
+	refcount_t			stack_refcount;
 #endif
 #ifdef CONFIG_LIVEPATCH
 	int patch_state;
diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index df6ea66..aab3809 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -60,7 +60,7 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 static inline void *try_get_task_stack(struct task_struct *tsk)
 {
-	return atomic_inc_not_zero(&tsk->stack_refcount) ?
+	return refcount_inc_not_zero(&tsk->stack_refcount) ?
 		task_stack_page(tsk) : NULL;
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index cfd8a42..6fd6be0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -354,7 +354,7 @@ static void release_task_stack(struct task_struct *tsk)
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 void put_task_stack(struct task_struct *tsk)
 {
-	if (atomic_dec_and_test(&tsk->stack_refcount))
+	if (refcount_dec_and_test(&tsk->stack_refcount))
 		release_task_stack(tsk);
 }
 #endif
@@ -372,7 +372,7 @@ void free_task(struct task_struct *tsk)
 	 * If the task had a separate stack allocation, it should be gone
 	 * by now.
 	 */
-	WARN_ON_ONCE(atomic_read(&tsk->stack_refcount) != 0);
+	WARN_ON_ONCE(refcount_read(&tsk->stack_refcount) != 0);
 #endif
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
@@ -532,7 +532,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->stack_vm_area = stack_vm_area;
 #endif
 #ifdef CONFIG_THREAD_INFO_IN_TASK
-	atomic_set(&tsk->stack_refcount, 1);
+	refcount_set(&tsk->stack_refcount, 1);
 #endif
 
 	if (err)
-- 
2.7.4

