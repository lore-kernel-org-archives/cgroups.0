From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 04/19] kernel: convert task_struct.usage from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:53 +0200
Message-ID: <1487585948-6401-5-git-send-email-elena.reshetova@intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 include/linux/init_task.h | 2 +-
 include/linux/sched.h     | 6 +++---
 kernel/fork.c             | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f160b2..1c6df0b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -219,7 +219,7 @@ extern struct task_group root_task_group;
 	INIT_TASK_TI(tsk)						\
 	.state		= 0,						\
 	.stack		= init_stack,					\
-	.usage		= ATOMIC_INIT(2),				\
+	.usage		= REFCOUNT_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e90396f..d760ad6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1489,7 +1489,7 @@ struct task_struct {
 #endif
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
-	atomic_t usage;
+	refcount_t usage;
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
 
@@ -2220,13 +2220,13 @@ static inline int is_global_init(struct task_struct *tsk)
 extern struct pid *cad_pid;
 
 extern void free_task(struct task_struct *tsk);
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
index b432d1c..b9b3296 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -383,7 +383,7 @@ static inline void put_signal_struct(struct signal_struct *sig)
 void __put_task_struct(struct task_struct *tsk)
 {
 	WARN_ON(!tsk->exit_state);
-	WARN_ON(atomic_read(&tsk->usage));
+	WARN_ON(refcount_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
 	cgroup_free(tsk);
@@ -533,7 +533,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
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

