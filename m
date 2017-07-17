From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 02/15] kernel: convert signal_struct.sigcnt from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:13 +0300
Message-ID: <1500288206-12074-3-git-send-email-elena.reshetova@intel.com>
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
 include/linux/sched/signal.h | 2 +-
 kernel/fork.c                | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 4d5cdf1..c5f1a67 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -77,7 +77,7 @@ struct thread_group_cputimer {
  * the locking of signal_struct.
  */
 struct signal_struct {
-	atomic_t		sigcnt;
+	refcount_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
 	struct list_head	thread_head;
diff --git a/kernel/fork.c b/kernel/fork.c
index 60bd7bf..337904a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -399,7 +399,7 @@ static inline void free_signal_struct(struct signal_struct *sig)
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt))
+	if (refcount_dec_and_test(&sig->sigcnt))
 		free_signal_struct(sig);
 }
 
@@ -1379,7 +1379,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	sig->nr_threads = 1;
 	atomic_set(&sig->live, 1);
-	atomic_set(&sig->sigcnt, 1);
+	refcount_set(&sig->sigcnt, 1);
 
 	/* list_add(thread_node, thread_head) without INIT_LIST_HEAD() */
 	sig->thread_head = (struct list_head)LIST_HEAD_INIT(tsk->thread_node);
@@ -1888,7 +1888,7 @@ static __latent_entropy struct task_struct *copy_process(
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

