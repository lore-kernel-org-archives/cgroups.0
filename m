From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 01/19] kernel: convert sighand_struct.count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:50 +0200
Message-ID: <1487585948-6401-2-git-send-email-elena.reshetova@intel.com>
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
 fs/exec.c                 | 4 ++--
 include/linux/init_task.h | 2 +-
 include/linux/sched.h     | 3 ++-
 kernel/fork.c             | 8 ++++----
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 698a860..3f78ff2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1174,7 +1174,7 @@ static int de_thread(struct task_struct *tsk)
 	flush_itimer_signals();
 #endif
 
-	if (atomic_read(&oldsighand->count) != 1) {
+	if (refcount_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
 		/*
 		 * This ->sighand is shared with the CLONE_SIGHAND
@@ -1184,7 +1184,7 @@ static int de_thread(struct task_struct *tsk)
 		if (!newsighand)
 			return -ENOMEM;
 
-		atomic_set(&newsighand->count, 1);
+		refcount_set(&newsighand->count, 1);
 		memcpy(newsighand->action, oldsighand->action,
 		       sizeof(newsighand->action));
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 3a85d61..1f160b2 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -82,7 +82,7 @@ extern struct fs_struct init_fs;
 extern struct nsproxy init_nsproxy;
 
 #define INIT_SIGHAND(sighand) {						\
-	.count		= ATOMIC_INIT(1), 				\
+	.count		= REFCOUNT_INIT(1), 				\
 	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f0d497..a0430aa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -42,6 +42,7 @@ struct sched_param {
 #include <linux/seccomp.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
+#include <linux/refcount.h>
 #include <linux/rtmutex.h>
 
 #include <linux/time.h>
@@ -527,7 +528,7 @@ static inline int get_dumpable(struct mm_struct *mm)
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
 struct sighand_struct {
-	atomic_t		count;
+	refcount_t		count;
 	struct k_sigaction	action[_NSIG];
 	spinlock_t		siglock;
 	wait_queue_head_t	signalfd_wqh;
diff --git a/kernel/fork.c b/kernel/fork.c
index e96e256..9488f01 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1285,7 +1285,7 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 	struct sighand_struct *sig;
 
 	if (clone_flags & CLONE_SIGHAND) {
-		atomic_inc(&current->sighand->count);
+		refcount_inc(&current->sighand->count);
 		return 0;
 	}
 	sig = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
@@ -1293,14 +1293,14 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
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
 		 * sighand_cachep is SLAB_DESTROY_BY_RCU so we can free it
@@ -2170,7 +2170,7 @@ static int check_unshare_flags(unsigned long unshare_flags)
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

