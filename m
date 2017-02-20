From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/19] kernel: convert cred.usage from atomic_t to refcount_t
Date: Mon, 20 Feb 2017 12:19:03 +0200
Message-ID: <1487585948-6401-15-git-send-email-elena.reshetova@intel.com>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487585948-6401-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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
 include/linux/cred.h |  6 +++---
 kernel/cred.c        | 44 ++++++++++++++++++++++----------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index c837f2d..25fdc87 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -108,7 +108,7 @@ extern bool may_setgroups(void);
  * same context as task->real_cred.
  */
 struct cred {
-	atomic_t	usage;
+	refcount_t	usage;
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	atomic_t	subscribers;	/* number of processes subscribed */
 	void		*put_addr;
@@ -221,7 +221,7 @@ static inline bool cap_ambient_invariant_ok(const struct cred *cred)
  */
 static inline struct cred *get_new_cred(struct cred *cred)
 {
-	atomic_inc(&cred->usage);
+	refcount_inc(&cred->usage);
 	return cred;
 }
 
@@ -261,7 +261,7 @@ static inline void put_cred(const struct cred *_cred)
 	struct cred *cred = (struct cred *) _cred;
 
 	validate_creds(cred);
-	if (atomic_dec_and_test(&(cred)->usage))
+	if (refcount_dec_and_test(&(cred)->usage))
 		__put_cred(cred);
 }
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 3afeea6..31ebce0 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -41,7 +41,7 @@ struct group_info init_groups = { .usage = REFCOUNT_INIT(2) };
  * The initial credentials for the initial task
  */
 struct cred init_cred = {
-	.usage			= ATOMIC_INIT(4),
+	.usage			= REFCOUNT_INIT(4),
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	.subscribers		= ATOMIC_INIT(2),
 	.magic			= CRED_MAGIC,
@@ -100,17 +100,17 @@ static void put_cred_rcu(struct rcu_head *rcu)
 
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	if (cred->magic != CRED_MAGIC_DEAD ||
-	    atomic_read(&cred->usage) != 0 ||
+	    refcount_read(&cred->usage) != 0 ||
 	    read_cred_subscribers(cred) != 0)
 		panic("CRED: put_cred_rcu() sees %p with"
 		      " mag %x, put %p, usage %d, subscr %d\n",
 		      cred, cred->magic, cred->put_addr,
-		      atomic_read(&cred->usage),
+		      refcount_read(&cred->usage),
 		      read_cred_subscribers(cred));
 #else
-	if (atomic_read(&cred->usage) != 0)
+	if (refcount_read(&cred->usage) != 0)
 		panic("CRED: put_cred_rcu() sees %p with usage %d\n",
-		      cred, atomic_read(&cred->usage));
+		      cred, refcount_read(&cred->usage));
 #endif
 
 	security_cred_free(cred);
@@ -134,10 +134,10 @@ static void put_cred_rcu(struct rcu_head *rcu)
 void __put_cred(struct cred *cred)
 {
 	kdebug("__put_cred(%p{%d,%d})", cred,
-	       atomic_read(&cred->usage),
+	       refcount_read(&cred->usage),
 	       read_cred_subscribers(cred));
 
-	BUG_ON(atomic_read(&cred->usage) != 0);
+	BUG_ON(refcount_read(&cred->usage) != 0);
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	BUG_ON(read_cred_subscribers(cred) != 0);
 	cred->magic = CRED_MAGIC_DEAD;
@@ -158,7 +158,7 @@ void exit_creds(struct task_struct *tsk)
 	struct cred *cred;
 
 	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid, tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
+	       refcount_read(&tsk->cred->usage),
 	       read_cred_subscribers(tsk->cred));
 
 	cred = (struct cred *) tsk->real_cred;
@@ -193,7 +193,7 @@ const struct cred *get_task_cred(struct task_struct *task)
 	do {
 		cred = __task_cred((task));
 		BUG_ON(!cred);
-	} while (!atomic_inc_not_zero(&((struct cred *)cred)->usage));
+	} while (!refcount_inc_not_zero(&((struct cred *)cred)->usage));
 
 	rcu_read_unlock();
 	return cred;
@@ -211,7 +211,7 @@ struct cred *cred_alloc_blank(void)
 	if (!new)
 		return NULL;
 
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
@@ -257,7 +257,7 @@ struct cred *prepare_creds(void)
 	old = task->cred;
 	memcpy(new, old, sizeof(struct cred));
 
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
 	get_uid(new->user);
@@ -334,7 +334,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		get_cred(p->cred);
 		alter_cred_subscribers(p->cred, 2);
 		kdebug("share_creds(%p{%d,%d})",
-		       p->cred, atomic_read(&p->cred->usage),
+		       p->cred, refcount_read(&p->cred->usage),
 		       read_cred_subscribers(p->cred));
 		atomic_inc(&p->cred->user->processes);
 		return 0;
@@ -425,7 +425,7 @@ int commit_creds(struct cred *new)
 	const struct cred *old = task->real_cred;
 
 	kdebug("commit_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
+	       refcount_read(&new->usage),
 	       read_cred_subscribers(new));
 
 	BUG_ON(task->cred != old);
@@ -434,7 +434,7 @@ int commit_creds(struct cred *new)
 	validate_creds(old);
 	validate_creds(new);
 #endif
-	BUG_ON(atomic_read(&new->usage) < 1);
+	BUG_ON(refcount_read(&new->usage) < 1);
 
 	get_cred(new); /* we will require a ref for the subj creds too */
 
@@ -499,13 +499,13 @@ EXPORT_SYMBOL(commit_creds);
 void abort_creds(struct cred *new)
 {
 	kdebug("abort_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
+	       refcount_read(&new->usage),
 	       read_cred_subscribers(new));
 
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	BUG_ON(read_cred_subscribers(new) != 0);
 #endif
-	BUG_ON(atomic_read(&new->usage) < 1);
+	BUG_ON(refcount_read(&new->usage) < 1);
 	put_cred(new);
 }
 EXPORT_SYMBOL(abort_creds);
@@ -522,7 +522,7 @@ const struct cred *override_creds(const struct cred *new)
 	const struct cred *old = current->cred;
 
 	kdebug("override_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
+	       refcount_read(&new->usage),
 	       read_cred_subscribers(new));
 
 	validate_creds(old);
@@ -533,7 +533,7 @@ const struct cred *override_creds(const struct cred *new)
 	alter_cred_subscribers(old, -1);
 
 	kdebug("override_creds() = %p{%d,%d}", old,
-	       atomic_read(&old->usage),
+	       refcount_read(&old->usage),
 	       read_cred_subscribers(old));
 	return old;
 }
@@ -551,7 +551,7 @@ void revert_creds(const struct cred *old)
 	const struct cred *override = current->cred;
 
 	kdebug("revert_creds(%p{%d,%d})", old,
-	       atomic_read(&old->usage),
+	       refcount_read(&old->usage),
 	       read_cred_subscribers(old));
 
 	validate_creds(old);
@@ -610,7 +610,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	validate_creds(old);
 
 	*new = *old;
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
@@ -734,7 +734,7 @@ static void dump_invalid_creds(const struct cred *cred, const char *label,
 	printk(KERN_ERR "CRED: ->magic=%x, put_addr=%p\n",
 	       cred->magic, cred->put_addr);
 	printk(KERN_ERR "CRED: ->usage=%d, subscr=%d\n",
-	       atomic_read(&cred->usage),
+	       refcount_read(&cred->usage),
 	       read_cred_subscribers(cred));
 	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
 		from_kuid_munged(&init_user_ns, cred->uid),
@@ -808,7 +808,7 @@ void validate_creds_for_do_exit(struct task_struct *tsk)
 {
 	kdebug("validate_creds_for_do_exit(%p,%p{%d,%d})",
 	       tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
+	       refcount_read(&tsk->cred->usage),
 	       read_cred_subscribers(tsk->cred));
 
 	__validate_process_creds(tsk, __FILE__, __LINE__);
-- 
2.7.4
