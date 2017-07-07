From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 12/15] kernel: convert cred.usage from atomic_t to refcount_t
Date: Fri,  7 Jul 2017 12:04:26 +0300
Message-ID: <1499418269-3686-13-git-send-email-elena.reshetova@intel.com>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>

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
 include/linux/cred.h |  6 +++---
 kernel/cred.c        | 44 ++++++++++++++++++++++----------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 00948dd..a9f217b 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -109,7 +109,7 @@ extern bool may_setgroups(void);
  * same context as task->real_cred.
  */
 struct cred {
-	atomic_t	usage;
+	refcount_t	usage;
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	atomic_t	subscribers;	/* number of processes subscribed */
 	void		*put_addr;
@@ -222,7 +222,7 @@ static inline bool cap_ambient_invariant_ok(const struct cred *cred)
  */
 static inline struct cred *get_new_cred(struct cred *cred)
 {
-	atomic_inc(&cred->usage);
+	refcount_inc(&cred->usage);
 	return cred;
 }
 
@@ -262,7 +262,7 @@ static inline void put_cred(const struct cred *_cred)
 	struct cred *cred = (struct cred *) _cred;
 
 	validate_creds(cred);
-	if (atomic_dec_and_test(&(cred)->usage))
+	if (refcount_dec_and_test(&(cred)->usage))
 		__put_cred(cred);
 }
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 8122d7c..49664e5 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -42,7 +42,7 @@ struct group_info init_groups = { .usage = REFCOUNT_INIT(2) };
  * The initial credentials for the initial task
  */
 struct cred init_cred = {
-	.usage			= ATOMIC_INIT(4),
+	.usage			= REFCOUNT_INIT(4),
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	.subscribers		= ATOMIC_INIT(2),
 	.magic			= CRED_MAGIC,
@@ -101,17 +101,17 @@ static void put_cred_rcu(struct rcu_head *rcu)
 
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
@@ -135,10 +135,10 @@ static void put_cred_rcu(struct rcu_head *rcu)
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
@@ -159,7 +159,7 @@ void exit_creds(struct task_struct *tsk)
 	struct cred *cred;
 
 	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid, tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
+	       refcount_read(&tsk->cred->usage),
 	       read_cred_subscribers(tsk->cred));
 
 	cred = (struct cred *) tsk->real_cred;
@@ -194,7 +194,7 @@ const struct cred *get_task_cred(struct task_struct *task)
 	do {
 		cred = __task_cred((task));
 		BUG_ON(!cred);
-	} while (!atomic_inc_not_zero(&((struct cred *)cred)->usage));
+	} while (!refcount_inc_not_zero(&((struct cred *)cred)->usage));
 
 	rcu_read_unlock();
 	return cred;
@@ -212,7 +212,7 @@ struct cred *cred_alloc_blank(void)
 	if (!new)
 		return NULL;
 
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 #ifdef CONFIG_DEBUG_CREDENTIALS
 	new->magic = CRED_MAGIC;
 #endif
@@ -258,7 +258,7 @@ struct cred *prepare_creds(void)
 	old = task->cred;
 	memcpy(new, old, sizeof(struct cred));
 
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
 	get_uid(new->user);
@@ -335,7 +335,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 		get_cred(p->cred);
 		alter_cred_subscribers(p->cred, 2);
 		kdebug("share_creds(%p{%d,%d})",
-		       p->cred, atomic_read(&p->cred->usage),
+		       p->cred, refcount_read(&p->cred->usage),
 		       read_cred_subscribers(p->cred));
 		atomic_inc(&p->cred->user->processes);
 		return 0;
@@ -426,7 +426,7 @@ int commit_creds(struct cred *new)
 	const struct cred *old = task->real_cred;
 
 	kdebug("commit_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
+	       refcount_read(&new->usage),
 	       read_cred_subscribers(new));
 
 	BUG_ON(task->cred != old);
@@ -435,7 +435,7 @@ int commit_creds(struct cred *new)
 	validate_creds(old);
 	validate_creds(new);
 #endif
-	BUG_ON(atomic_read(&new->usage) < 1);
+	BUG_ON(refcount_read(&new->usage) < 1);
 
 	get_cred(new); /* we will require a ref for the subj creds too */
 
@@ -500,13 +500,13 @@ EXPORT_SYMBOL(commit_creds);
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
@@ -523,7 +523,7 @@ const struct cred *override_creds(const struct cred *new)
 	const struct cred *old = current->cred;
 
 	kdebug("override_creds(%p{%d,%d})", new,
-	       atomic_read(&new->usage),
+	       refcount_read(&new->usage),
 	       read_cred_subscribers(new));
 
 	validate_creds(old);
@@ -534,7 +534,7 @@ const struct cred *override_creds(const struct cred *new)
 	alter_cred_subscribers(old, -1);
 
 	kdebug("override_creds() = %p{%d,%d}", old,
-	       atomic_read(&old->usage),
+	       refcount_read(&old->usage),
 	       read_cred_subscribers(old));
 	return old;
 }
@@ -552,7 +552,7 @@ void revert_creds(const struct cred *old)
 	const struct cred *override = current->cred;
 
 	kdebug("revert_creds(%p{%d,%d})", old,
-	       atomic_read(&old->usage),
+	       refcount_read(&old->usage),
 	       read_cred_subscribers(old));
 
 	validate_creds(old);
@@ -611,7 +611,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	validate_creds(old);
 
 	*new = *old;
-	atomic_set(&new->usage, 1);
+	refcount_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
@@ -735,7 +735,7 @@ static void dump_invalid_creds(const struct cred *cred, const char *label,
 	printk(KERN_ERR "CRED: ->magic=%x, put_addr=%p\n",
 	       cred->magic, cred->put_addr);
 	printk(KERN_ERR "CRED: ->usage=%d, subscr=%d\n",
-	       atomic_read(&cred->usage),
+	       refcount_read(&cred->usage),
 	       read_cred_subscribers(cred));
 	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
 		from_kuid_munged(&init_user_ns, cred->uid),
@@ -809,7 +809,7 @@ void validate_creds_for_do_exit(struct task_struct *tsk)
 {
 	kdebug("validate_creds_for_do_exit(%p,%p{%d,%d})",
 	       tsk->real_cred, tsk->cred,
-	       atomic_read(&tsk->cred->usage),
+	       refcount_read(&tsk->cred->usage),
 	       read_cred_subscribers(tsk->cred));
 
 	__validate_process_creds(tsk, __FILE__, __LINE__);
-- 
2.7.4

