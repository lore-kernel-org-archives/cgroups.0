From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 02/19] kernel: convert signal_struct.sigcnt from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:51 +0200
Message-ID: <1487585948-6401-3-git-send-email-elena.reshetova@intel.com>
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
 include/linux/sched.h | 2 +-
 kernel/fork.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a0430aa..6aad885 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -659,7 +659,7 @@ struct autogroup;
  * the locking of signal_struct.
  */
 struct signal_struct {
-	atomic_t		sigcnt;
+	refcount_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
 	struct list_head	thread_head;
diff --git a/kernel/fork.c b/kernel/fork.c
index 9488f01..b432d1c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -376,7 +376,7 @@ static inline void free_signal_struct(struct signal_struct *sig)
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt))
+	if (refcount_dec_and_test(&sig->sigcnt))
 		free_signal_struct(sig);
 }
 
@@ -1347,7 +1347,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	sig->nr_threads = 1;
 	atomic_set(&sig->live, 1);
-	atomic_set(&sig->sigcnt, 1);
+	refcount_set(&sig->sigcnt, 1);
 
 	/* list_add(thread_node, thread_head) without INIT_LIST_HEAD() */
 	sig->thread_head = (struct list_head)LIST_HEAD_INIT(tsk->thread_node);
@@ -1826,7 +1826,7 @@ static __latent_entropy struct task_struct *copy_process(
 		} else {
 			current->signal->nr_threads++;
 			atomic_inc(&current->signal->live);
-			atomic_inc(&current->signal->sigcnt);
+			refcount_inc(&current->signal->sigcnt);
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
 			list_add_tail_rcu(&p->thread_node,
-- 
2.7.4

