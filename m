From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 01/15] kernel: convert sighand_struct.count from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:12 +0300
Message-ID: <1500288206-12074-2-git-send-email-elena.reshetova@intel.com>
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
 fs/exec.c                    | 4 ++--
 fs/proc/task_nommu.c         | 2 +-
 include/linux/init_task.h    | 2 +-
 include/linux/sched/signal.h | 3 ++-
 kernel/fork.c                | 8 ++++----
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 62175cb..75e2800 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1200,7 +1200,7 @@ static int de_thread(struct task_struct *tsk)
 	flush_itimer_signals();
 #endif
 
-	if (atomic_read(&oldsighand->count) != 1) {
+	if (refcount_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
 		/*
 		 * This ->sighand is shared with the CLONE_SIGHAND
@@ -1210,7 +1210,7 @@ static int de_thread(struct task_struct *tsk)
 		if (!newsighand)
 			return -ENOMEM;
 
-		atomic_set(&newsighand->count, 1);
+		refcount_set(&newsighand->count, 1);
 		memcpy(newsighand->action, oldsighand->action,
 		       sizeof(newsighand->action));
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 38ca416..eea6b91 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -63,7 +63,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 	else
 		bytes += kobjsize(current->files);
 
-	if (current->sighand && atomic_read(&current->sighand->count) > 1)
+	if (current->sighand && refcount_read(&current->sighand->count) > 1)
 		sbytes += kobjsize(current->sighand);
 	else
 		bytes += kobjsize(current->sighand);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index a2f6707..61777d6 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -85,7 +85,7 @@ extern struct fs_struct init_fs;
 extern struct nsproxy init_nsproxy;
 
 #define INIT_SIGHAND(sighand) {						\
-	.count		= ATOMIC_INIT(1), 				\
+	.count		= REFCOUNT_INIT(1), 				\
 	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 2a0dd40..4d5cdf1 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -7,13 +7,14 @@
 #include <linux/sched/jobctl.h>
 #include <linux/sched/task.h>
 #include <linux/cred.h>
+#include <linux/refcount.h>
 
 /*
  * Types defining task->signal and task->sighand and APIs using them:
  */
 
 struct sighand_struct {
-	atomic_t		count;
+	refcount_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
 	wait_queue_head_t	signalfd_wqh;
diff --git a/kernel/fork.c b/kernel/fork.c
index 080688f..60bd7bf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1317,7 +1317,7 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 	struct sighand_struct *sig;
 
 	if (clone_flags & CLONE_SIGHAND) {
-		atomic_inc(&current->sighand->count);
+		refcount_inc(&current->sighand->count);
 		return 0;
 	}
 	sig = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
@@ -1325,14 +1325,14 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 	if (!sig)
 		return -ENOMEM;
 
-	atomic_set(&sig->count, 1);
+	refcount_set(&sig->count, 1);
 	memcpy(sig->action, current->sighand->action, sizeof(sig->action));
 	return 0;
 }
 
 void __cleanup_sighand(struct sighand_struct *sighand)
 {
-	if (atomic_dec_and_test(&sighand->count)) {
+	if (refcount_dec_and_test(&sighand->count)) {
 		signalfd_cleanup(sighand);
 		/*
 		 * sighand_cachep is SLAB_TYPESAFE_BY_RCU so we can free it
@@ -2236,7 +2236,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
 			return -EINVAL;
 	}
 	if (unshare_flags & (CLONE_SIGHAND | CLONE_VM)) {
-		if (atomic_read(&current->sighand->count) > 1)
+		if (refcount_read(&current->sighand->count) > 1)
 			return -EINVAL;
 	}
 	if (unshare_flags & CLONE_VM) {
-- 
2.7.4

