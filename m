From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 03/19] kernel: convert user_struct.__count from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:18:52 +0200
Message-ID: <1487585948-6401-4-git-send-email-elena.reshetova@intel.com>
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
 include/linux/sched.h | 4 ++--
 kernel/user.c         | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6aad885..e90396f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -844,7 +844,7 @@ static inline int signal_group_exit(const struct signal_struct *sig)
  * Some day this will be a full-fledged user tracking system..
  */
 struct user_struct {
-	atomic_t __count;	/* reference count */
+	refcount_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_FANOTIFY
@@ -2694,7 +2694,7 @@ extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 extern struct user_struct * alloc_uid(kuid_t);
 static inline struct user_struct *get_uid(struct user_struct *u)
 {
-	atomic_inc(&u->__count);
+	refcount_inc(&u->__count);
 	return u;
 }
 extern void free_uid(struct user_struct *);
diff --git a/kernel/user.c b/kernel/user.c
index b069ccb..d9dff8e 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -89,7 +89,7 @@ static DEFINE_SPINLOCK(uidhash_lock);
 
 /* root_user.__count is 1, for init task cred */
 struct user_struct root_user = {
-	.__count	= ATOMIC_INIT(1),
+	.__count	= REFCOUNT_INIT(1),
 	.processes	= ATOMIC_INIT(1),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
@@ -115,7 +115,7 @@ static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
 
 	hlist_for_each_entry(user, hashent, uidhash_node) {
 		if (uid_eq(user->uid, uid)) {
-			atomic_inc(&user->__count);
+			refcount_inc(&user->__count);
 			return user;
 		}
 	}
@@ -162,7 +162,7 @@ void free_uid(struct user_struct *up)
 		return;
 
 	local_irq_save(flags);
-	if (atomic_dec_and_lock(&up->__count, &uidhash_lock))
+	if (refcount_dec_and_lock(&up->__count, &uidhash_lock))
 		free_user(up, flags);
 	else
 		local_irq_restore(flags);
@@ -183,7 +183,7 @@ struct user_struct *alloc_uid(kuid_t uid)
 			goto out_unlock;
 
 		new->uid = uid;
-		atomic_set(&new->__count, 1);
+		refcount_set(&new->__count, 1);
 
 		/*
 		 * Before adding this, check whether we raced
-- 
2.7.4

