From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/15] kernel: convert user_struct.__count from atomic_t to refcount_t
Date: Fri,  7 Jul 2017 12:04:17 +0300
Message-ID: <1499418269-3686-4-git-send-email-elena.reshetova@intel.com>
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
 include/linux/sched/user.h | 5 +++--
 kernel/user.c              | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 5d5415e..0a9953d 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -3,6 +3,7 @@
 
 #include <linux/uidgid.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct key;
 
@@ -10,7 +11,7 @@ struct key;
  * Some day this will be a full-fledged user tracking system..
  */
 struct user_struct {
-	atomic_t __count;	/* reference count */
+	refcount_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_FANOTIFY
@@ -53,7 +54,7 @@ extern struct user_struct root_user;
 extern struct user_struct * alloc_uid(kuid_t);
 static inline struct user_struct *get_uid(struct user_struct *u)
 {
-	atomic_inc(&u->__count);
+	refcount_inc(&u->__count);
 	return u;
 }
 extern void free_uid(struct user_struct *);
diff --git a/kernel/user.c b/kernel/user.c
index 00281ad..c072348 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -90,7 +90,7 @@ static DEFINE_SPINLOCK(uidhash_lock);
 
 /* root_user.__count is 1, for init task cred */
 struct user_struct root_user = {
-	.__count	= ATOMIC_INIT(1),
+	.__count	= REFCOUNT_INIT(1),
 	.processes	= ATOMIC_INIT(1),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
@@ -116,7 +116,7 @@ static struct user_struct *uid_hash_find(kuid_t uid, struct hlist_head *hashent)
 
 	hlist_for_each_entry(user, hashent, uidhash_node) {
 		if (uid_eq(user->uid, uid)) {
-			atomic_inc(&user->__count);
+			refcount_inc(&user->__count);
 			return user;
 		}
 	}
@@ -163,7 +163,7 @@ void free_uid(struct user_struct *up)
 		return;
 
 	local_irq_save(flags);
-	if (atomic_dec_and_lock(&up->__count, &uidhash_lock))
+	if (refcount_dec_and_lock(&up->__count, &uidhash_lock))
 		free_user(up, flags);
 	else
 		local_irq_restore(flags);
@@ -184,7 +184,7 @@ struct user_struct *alloc_uid(kuid_t uid)
 			goto out_unlock;
 
 		new->uid = uid;
-		atomic_set(&new->__count, 1);
+		refcount_set(&new->__count, 1);
 
 		/*
 		 * Before adding this, check whether we raced
-- 
2.7.4
