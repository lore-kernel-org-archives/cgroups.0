From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/8] cgroup: move namespace code to kernel/cgroup/namespace.c
Date: Tue, 20 Dec 2016 16:08:27 -0500
Message-ID: <20161220210827.11176-9-tj@kernel.org>
References: <20161220210827.11176-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IRK+PzSjDnfKq++ILKTABn1352vtnLO8oSOVLWEKjoE=;
        b=fwH8qj3oUuXkv6jvYlcK9BZ5X47NlpgTsX5hLErQTe8z2BrwNYUmTUYJFxZWCMh0LP
         4QKgHVyUNE9eC9XkB/2kll1OHYW9T8mtmIUwA0y8jTMUz+W/udTCHg1xonn2suzY5nsA
         tiF43iOuvBam5UBgKZQYu5gz1eTxaEjjhuSy1748qtPPDrQ3Kc05/dI5Hw6+TVXV9+dn
         PwjzOpJ8Q82gWfittwpmHfp6WQQs+3gbKCXO5QZvEC40HIP2CNPJKTehrW6Ytck8iFZz
         2MffVdZgy+eOdNmoUZhDIM4vA3ttcjZqubD07OMFrwNjVKuutRv+zOAgPk3TCeyDEPh0
         remg==
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

get/put_css_set() get exposed in cgroup-internal.h in the process.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/Makefile          |   2 +-
 kernel/cgroup/cgroup-internal.h |  32 ++++++++
 kernel/cgroup/cgroup.c          | 175 +---------------------------------------
 kernel/cgroup/namespace.c       | 155 +++++++++++++++++++++++++++++++++++
 4 files changed, 189 insertions(+), 175 deletions(-)
 create mode 100644 kernel/cgroup/namespace.c

diff --git a/kernel/cgroup/Makefile b/kernel/cgroup/Makefile
index 719588c..6d42a32 100644
--- a/kernel/cgroup/Makefile
+++ b/kernel/cgroup/Makefile
@@ -1,4 +1,4 @@
-obj-y := cgroup.o cgroup-v1.o
+obj-y := cgroup.o namespace.o cgroup-v1.o
 
 obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 2020d8d..690fa5d 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -63,6 +63,33 @@ static inline bool notify_on_release(const struct cgroup *cgrp)
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
 
+void put_css_set_locked(struct css_set *cset);
+
+static inline void put_css_set(struct css_set *cset)
+{
+	unsigned long flags;
+
+	/*
+	 * Ensure that the refcount doesn't hit zero while any readers
+	 * can see it. Similar to atomic_dec_and_lock(), but for an
+	 * rwlock
+	 */
+	if (atomic_add_unless(&cset->refcount, -1, 1))
+		return;
+
+	spin_lock_irqsave(&css_set_lock, flags);
+	put_css_set_locked(cset);
+	spin_unlock_irqrestore(&css_set_lock, flags);
+}
+
+/*
+ * refcounted get/put for css_set objects
+ */
+static inline void get_css_set(struct css_set *cset)
+{
+	atomic_inc(&cset->refcount);
+}
+
 bool cgroup_ssid_enabled(int ssid);
 bool cgroup_on_dfl(const struct cgroup *cgrp);
 
@@ -106,6 +133,11 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 		     struct kernfs_root *kf_root);
 
 /*
+ * namespace.c
+ */
+extern const struct proc_ns_operations cgroupns_operations;
+
+/*
  * cgroup-v1.c
  */
 extern struct cftype cgroup1_base_files[];
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dcfbeb6..792f151 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -720,7 +720,7 @@ static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
 	return key;
 }
 
-static void put_css_set_locked(struct css_set *cset)
+void put_css_set_locked(struct css_set *cset)
 {
 	struct cgrp_cset_link *link, *tmp_link;
 	struct cgroup_subsys *ss;
@@ -750,31 +750,6 @@ static void put_css_set_locked(struct css_set *cset)
 	kfree_rcu(cset, rcu_head);
 }
 
-static void put_css_set(struct css_set *cset)
-{
-	unsigned long flags;
-
-	/*
-	 * Ensure that the refcount doesn't hit zero while any readers
-	 * can see it. Similar to atomic_dec_and_lock(), but for an
-	 * rwlock
-	 */
-	if (atomic_add_unless(&cset->refcount, -1, 1))
-		return;
-
-	spin_lock_irqsave(&css_set_lock, flags);
-	put_css_set_locked(cset);
-	spin_unlock_irqrestore(&css_set_lock, flags);
-}
-
-/*
- * refcounted get/put for css_set objects
- */
-static inline void get_css_set(struct css_set *cset)
-{
-	atomic_inc(&cset->refcount);
-}
-
 /**
  * compare_css_sets - helper function for find_existing_css_set().
  * @cset: candidate css_set being tested
@@ -5111,154 +5086,6 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
 
 #endif	/* CONFIG_SOCK_CGROUP_DATA */
 
-/* cgroup namespaces */
-
-static struct ucounts *inc_cgroup_namespaces(struct user_namespace *ns)
-{
-	return inc_ucount(ns, current_euid(), UCOUNT_CGROUP_NAMESPACES);
-}
-
-static void dec_cgroup_namespaces(struct ucounts *ucounts)
-{
-	dec_ucount(ucounts, UCOUNT_CGROUP_NAMESPACES);
-}
-
-static struct cgroup_namespace *alloc_cgroup_ns(void)
-{
-	struct cgroup_namespace *new_ns;
-	int ret;
-
-	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
-	if (!new_ns)
-		return ERR_PTR(-ENOMEM);
-	ret = ns_alloc_inum(&new_ns->ns);
-	if (ret) {
-		kfree(new_ns);
-		return ERR_PTR(ret);
-	}
-	atomic_set(&new_ns->count, 1);
-	new_ns->ns.ops = &cgroupns_operations;
-	return new_ns;
-}
-
-void free_cgroup_ns(struct cgroup_namespace *ns)
-{
-	put_css_set(ns->root_cset);
-	dec_cgroup_namespaces(ns->ucounts);
-	put_user_ns(ns->user_ns);
-	ns_free_inum(&ns->ns);
-	kfree(ns);
-}
-EXPORT_SYMBOL(free_cgroup_ns);
-
-struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
-					struct user_namespace *user_ns,
-					struct cgroup_namespace *old_ns)
-{
-	struct cgroup_namespace *new_ns;
-	struct ucounts *ucounts;
-	struct css_set *cset;
-
-	BUG_ON(!old_ns);
-
-	if (!(flags & CLONE_NEWCGROUP)) {
-		get_cgroup_ns(old_ns);
-		return old_ns;
-	}
-
-	/* Allow only sysadmin to create cgroup namespace. */
-	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
-
-	ucounts = inc_cgroup_namespaces(user_ns);
-	if (!ucounts)
-		return ERR_PTR(-ENOSPC);
-
-	/* It is not safe to take cgroup_mutex here */
-	spin_lock_irq(&css_set_lock);
-	cset = task_css_set(current);
-	get_css_set(cset);
-	spin_unlock_irq(&css_set_lock);
-
-	new_ns = alloc_cgroup_ns();
-	if (IS_ERR(new_ns)) {
-		put_css_set(cset);
-		dec_cgroup_namespaces(ucounts);
-		return new_ns;
-	}
-
-	new_ns->user_ns = get_user_ns(user_ns);
-	new_ns->ucounts = ucounts;
-	new_ns->root_cset = cset;
-
-	return new_ns;
-}
-
-static inline struct cgroup_namespace *to_cg_ns(struct ns_common *ns)
-{
-	return container_of(ns, struct cgroup_namespace, ns);
-}
-
-static int cgroupns_install(struct nsproxy *nsproxy, struct ns_common *ns)
-{
-	struct cgroup_namespace *cgroup_ns = to_cg_ns(ns);
-
-	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
-	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
-		return -EPERM;
-
-	/* Don't need to do anything if we are attaching to our own cgroupns. */
-	if (cgroup_ns == nsproxy->cgroup_ns)
-		return 0;
-
-	get_cgroup_ns(cgroup_ns);
-	put_cgroup_ns(nsproxy->cgroup_ns);
-	nsproxy->cgroup_ns = cgroup_ns;
-
-	return 0;
-}
-
-static struct ns_common *cgroupns_get(struct task_struct *task)
-{
-	struct cgroup_namespace *ns = NULL;
-	struct nsproxy *nsproxy;
-
-	task_lock(task);
-	nsproxy = task->nsproxy;
-	if (nsproxy) {
-		ns = nsproxy->cgroup_ns;
-		get_cgroup_ns(ns);
-	}
-	task_unlock(task);
-
-	return ns ? &ns->ns : NULL;
-}
-
-static void cgroupns_put(struct ns_common *ns)
-{
-	put_cgroup_ns(to_cg_ns(ns));
-}
-
-static struct user_namespace *cgroupns_owner(struct ns_common *ns)
-{
-	return to_cg_ns(ns)->user_ns;
-}
-
-const struct proc_ns_operations cgroupns_operations = {
-	.name		= "cgroup",
-	.type		= CLONE_NEWCGROUP,
-	.get		= cgroupns_get,
-	.put		= cgroupns_put,
-	.install	= cgroupns_install,
-	.owner		= cgroupns_owner,
-};
-
-static __init int cgroup_namespaces_init(void)
-{
-	return 0;
-}
-subsys_initcall(cgroup_namespaces_init);
-
 #ifdef CONFIG_CGROUP_BPF
 void cgroup_bpf_update(struct cgroup *cgrp,
 		       struct bpf_prog *prog,
diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
new file mode 100644
index 0000000..cff7ea6
--- /dev/null
+++ b/kernel/cgroup/namespace.c
@@ -0,0 +1,155 @@
+#include "cgroup-internal.h"
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/nsproxy.h>
+#include <linux/proc_ns.h>
+
+
+/* cgroup namespaces */
+
+static struct ucounts *inc_cgroup_namespaces(struct user_namespace *ns)
+{
+	return inc_ucount(ns, current_euid(), UCOUNT_CGROUP_NAMESPACES);
+}
+
+static void dec_cgroup_namespaces(struct ucounts *ucounts)
+{
+	dec_ucount(ucounts, UCOUNT_CGROUP_NAMESPACES);
+}
+
+static struct cgroup_namespace *alloc_cgroup_ns(void)
+{
+	struct cgroup_namespace *new_ns;
+	int ret;
+
+	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
+	if (!new_ns)
+		return ERR_PTR(-ENOMEM);
+	ret = ns_alloc_inum(&new_ns->ns);
+	if (ret) {
+		kfree(new_ns);
+		return ERR_PTR(ret);
+	}
+	atomic_set(&new_ns->count, 1);
+	new_ns->ns.ops = &cgroupns_operations;
+	return new_ns;
+}
+
+void free_cgroup_ns(struct cgroup_namespace *ns)
+{
+	put_css_set(ns->root_cset);
+	dec_cgroup_namespaces(ns->ucounts);
+	put_user_ns(ns->user_ns);
+	ns_free_inum(&ns->ns);
+	kfree(ns);
+}
+EXPORT_SYMBOL(free_cgroup_ns);
+
+struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
+					struct user_namespace *user_ns,
+					struct cgroup_namespace *old_ns)
+{
+	struct cgroup_namespace *new_ns;
+	struct ucounts *ucounts;
+	struct css_set *cset;
+
+	BUG_ON(!old_ns);
+
+	if (!(flags & CLONE_NEWCGROUP)) {
+		get_cgroup_ns(old_ns);
+		return old_ns;
+	}
+
+	/* Allow only sysadmin to create cgroup namespace. */
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	ucounts = inc_cgroup_namespaces(user_ns);
+	if (!ucounts)
+		return ERR_PTR(-ENOSPC);
+
+	/* It is not safe to take cgroup_mutex here */
+	spin_lock_irq(&css_set_lock);
+	cset = task_css_set(current);
+	get_css_set(cset);
+	spin_unlock_irq(&css_set_lock);
+
+	new_ns = alloc_cgroup_ns();
+	if (IS_ERR(new_ns)) {
+		put_css_set(cset);
+		dec_cgroup_namespaces(ucounts);
+		return new_ns;
+	}
+
+	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->ucounts = ucounts;
+	new_ns->root_cset = cset;
+
+	return new_ns;
+}
+
+static inline struct cgroup_namespace *to_cg_ns(struct ns_common *ns)
+{
+	return container_of(ns, struct cgroup_namespace, ns);
+}
+
+static int cgroupns_install(struct nsproxy *nsproxy, struct ns_common *ns)
+{
+	struct cgroup_namespace *cgroup_ns = to_cg_ns(ns);
+
+	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
+	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Don't need to do anything if we are attaching to our own cgroupns. */
+	if (cgroup_ns == nsproxy->cgroup_ns)
+		return 0;
+
+	get_cgroup_ns(cgroup_ns);
+	put_cgroup_ns(nsproxy->cgroup_ns);
+	nsproxy->cgroup_ns = cgroup_ns;
+
+	return 0;
+}
+
+static struct ns_common *cgroupns_get(struct task_struct *task)
+{
+	struct cgroup_namespace *ns = NULL;
+	struct nsproxy *nsproxy;
+
+	task_lock(task);
+	nsproxy = task->nsproxy;
+	if (nsproxy) {
+		ns = nsproxy->cgroup_ns;
+		get_cgroup_ns(ns);
+	}
+	task_unlock(task);
+
+	return ns ? &ns->ns : NULL;
+}
+
+static void cgroupns_put(struct ns_common *ns)
+{
+	put_cgroup_ns(to_cg_ns(ns));
+}
+
+static struct user_namespace *cgroupns_owner(struct ns_common *ns)
+{
+	return to_cg_ns(ns)->user_ns;
+}
+
+const struct proc_ns_operations cgroupns_operations = {
+	.name		= "cgroup",
+	.type		= CLONE_NEWCGROUP,
+	.get		= cgroupns_get,
+	.put		= cgroupns_put,
+	.install	= cgroupns_install,
+	.owner		= cgroupns_owner,
+};
+
+static __init int cgroup_namespaces_init(void)
+{
+	return 0;
+}
+subsys_initcall(cgroup_namespaces_init);
-- 
2.9.3
