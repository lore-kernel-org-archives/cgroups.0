From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 13/15] sched: convert numa_group.refcount from atomic_t to refcount_t
Date: Mon, 17 Jul 2017 13:43:24 +0300
Message-ID: <1500288206-12074-14-git-send-email-elena.reshetova@intel.com>
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
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c95880e..5f7f997 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1130,7 +1130,7 @@ static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 }
 
 struct numa_group {
-	atomic_t refcount;
+	refcount_t refcount;
 
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
@@ -2177,12 +2177,12 @@ static void task_numa_placement(struct task_struct *p)
 
 static inline int get_numa_group(struct numa_group *grp)
 {
-	return atomic_inc_not_zero(&grp->refcount);
+	return refcount_inc_not_zero(&grp->refcount);
 }
 
 static inline void put_numa_group(struct numa_group *grp)
 {
-	if (atomic_dec_and_test(&grp->refcount))
+	if (refcount_dec_and_test(&grp->refcount))
 		kfree_rcu(grp, rcu);
 }
 
@@ -2203,7 +2203,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 		if (!grp)
 			return;
 
-		atomic_set(&grp->refcount, 1);
+		refcount_set(&grp->refcount, 1);
 		grp->active_nodes = 1;
 		grp->max_faults_cpu = 0;
 		spin_lock_init(&grp->lock);
-- 
2.7.4

