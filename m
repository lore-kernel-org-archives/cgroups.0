From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 2/2] cgroup: implement subtree creation on copy_cgroup_ns()
Date: Sat, 14 May 2016 13:20:00 +1000
Message-ID: <1463196000-13900-3-git-send-email-asarai@suse.de>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463196000-13900-1-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

Allow unprivileged processes to control subtrees of their associated
processes, a necessary feature if a rootless container wishes to take
advantage of cgroups for its own processes.

As cgroups are hierarchical, having the ability to set limits in a
subtree does not preclude the ability to modify the limits imposed by
parent cgroups. In addition, in the default hierarchy a process must
have write access to the common ancestor of the two (src and dest)
cgroups' cgroup.procs file. This makes this change safe against cgroup
escape.

There isn't a way to disable this at the moment.

Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
---
 kernel/cgroup.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 120 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f1c798b69561..f455488dc899 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -62,6 +62,7 @@
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
 #include <linux/proc_ns.h>
+#include <linux/time.h>
 #include <net/sock.h>
 
 /*
@@ -5269,34 +5270,40 @@ out_destroy:
 	return ERR_PTR(ret);
 }
 
-static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
-			umode_t mode)
+/**
+ * cgroup_create_subtree - creates a new subtree of a cgroup
+ * @parent: the parent cgroup to create the subtree under
+ * @name: the name of the cgroup in kernfs
+ * @mode: the mode of the cgroup in kernfs
+ *
+ * Creates a new cgroup under the given @parent, with the given @name and @mode.
+ * The caller must hold cgroup_mutex, and must not be under active protection of
+ * kernfs.
+ */
+static struct cgroup *cgroup_create_subtree(struct cgroup *parent,
+					    const char *name, umode_t mode)
 {
-	struct cgroup *parent, *cgrp;
+	struct cgroup *child;
 	struct kernfs_node *kn;
-	int ret;
+	int ret = 0;
+
+	lockdep_assert_held(&cgroup_mutex);
 
 	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
 	if (strchr(name, '\n'))
-		return -EINVAL;
-
-	parent = cgroup_kn_lock_live(parent_kn, false);
-	if (!parent)
-		return -ENODEV;
+		return ERR_PTR(-EINVAL);
 
-	cgrp = cgroup_create(parent);
-	if (IS_ERR(cgrp)) {
-		ret = PTR_ERR(cgrp);
-		goto out_unlock;
-	}
+	child = cgroup_create(parent);
+	if (IS_ERR(child))
+		return child;
 
 	/* create the directory */
-	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
+	kn = kernfs_create_dir(parent->kn, name, mode, child);
 	if (IS_ERR(kn)) {
 		ret = PTR_ERR(kn);
 		goto out_destroy;
 	}
-	cgrp->kn = kn;
+	child->kn = kn;
 
 	/*
 	 * This extra ref will be put in cgroup_free_fn() and guarantees
@@ -5308,22 +5315,51 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	if (ret)
 		goto out_destroy;
 
-	ret = css_populate_dir(&cgrp->self);
+	ret = css_populate_dir(&child->self);
 	if (ret)
 		goto out_destroy;
 
-	ret = cgroup_apply_control_enable(cgrp);
+	ret = cgroup_apply_control_enable(child);
 	if (ret)
 		goto out_destroy;
 
 	/* let's create and online css's */
 	kernfs_activate(kn);
 
-	ret = 0;
-	goto out_unlock;
+	return child;
 
 out_destroy:
-	cgroup_destroy_locked(cgrp);
+	cgroup_destroy_locked(child);
+	return ERR_PTR(ret);
+}
+
+/*
+ * cgroup directories starting with this prefix are forbidden from being created
+ * from userspace. This prefix is used internally to make sure that there's no
+ * conflicts with userspace when creating cgroups inside copy_cgroup_ns().
+ */
+#define CGROUPNS_INTERNAL_PREFIX ".__cgroupns_subtree:"
+
+static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
+			umode_t mode)
+{
+	struct cgroup *parent, *cgrp;
+	int ret = 0;
+
+	if (strncmp(CGROUPNS_INTERNAL_PREFIX, name,
+		    strlen(CGROUPNS_INTERNAL_PREFIX)) == 0)
+		return -EINVAL;
+
+	parent = cgroup_kn_lock_live(parent_kn, false);
+	if (!parent)
+		return -ENODEV;
+
+	cgrp = cgroup_create_subtree(parent, name, mode);
+	if (IS_ERR(cgrp)) {
+		ret = PTR_ERR(cgrp);
+		goto out_unlock;
+	}
+
 out_unlock:
 	cgroup_kn_unlock(parent_kn);
 	return ret;
@@ -6298,7 +6334,9 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 					struct cgroup_namespace *old_ns)
 {
 	struct cgroup_namespace *new_ns;
+	struct cgroup_root *root;
 	struct css_set *cset;
+	char id[16], id_string[1+2*ARRAY_SIZE(id)] = {0};
 
 	BUG_ON(!old_ns);
 
@@ -6311,12 +6349,71 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
+	/*
+	 * In order to make sure that the dirname we create is unique, we use a
+	 * random id for all of the subtrees. The ID is the same to reduce
+	 * confusion when reading /proc/<pid>/cgroup.
+	 */
+	get_random_bytes(id, ARRAY_SIZE(id));
+	bin2hex(id_string, id, ARRAY_SIZE(id));
+
+	/*
+	 * Create a new subtree in every cgroup the task is associated with.
+	 * The cgroup is owned by the task uid and gid, to allow for management
+	 * of subtrees in cgroup namespaces. This is safe because:
+	 *
+	 * 1. cgroups are hierarchical, so having the ability to set limits in
+	 *    a subtree does not preclude the ability to modify the limits
+	 *    imposed by parent cgroups.
+	 *
+	 * 2. cgroup_procs_write_permission() does checks to ensure that a
+	 *    task cannot move other tasks into its cgroup unless they are both
+	 *    running as the same user (or the task moving the process has
+	 *    CAP_SYS_ADMIN in the user namespace of the process being moved).
+	 *    This means that a misbehaving process can't start messing around
+	 *    with other processes' cgroup associations.
+	 *
+	 * 3. On the default hierarchy, you cannot migrate a process to a
+	 *    non-descendant cgroup unless you have write access to the
+	 *    cgroup.procs file in the common ancestor of the two cgroups. This
+	 *    means that two cooperative processes in the default hierarchy
+	 *    can't move processes between their cgroups (if the admin
+	 *    disallows it). Unfortunately, this functionality doesn't exist in
+	 *    the other hierarchies (for backwards compatibility reasons).
+	 *    However, this requirement isn't as important as the previous two.
+	 */
 	mutex_lock(&cgroup_mutex);
-	spin_lock_bh(&css_set_lock);
+	for_each_root(root) {
+		struct cgroup *parent, *child;
+		char namebuf[CGROUP_FILE_NAME_MAX];
+		bool is_dfl = cgroup_on_dfl(&root->cgrp);
+
+		spin_lock_bh(&css_set_lock);
+		parent = task_cgroup_from_root(current, root);
+		spin_unlock_bh(&css_set_lock);
+
+		snprintf(namebuf, CGROUP_FILE_NAME_MAX,
+			 CGROUPNS_INTERNAL_PREFIX "%s", id_string);
+
+		/* This should not fail, since we're under &cgroup_mutex. */
+		child = cgroup_create_subtree(parent, namebuf, 0755);
+		if (WARN_ON(IS_ERR(child)))
+			continue;
 
+		/*
+		 * Move the task to the new cgroup, which is owned by the user.
+		 * Should never fail, since we're under &cgroup_mutex here.
+		 */
+		rcu_read_lock();
+		if (WARN_ON(cgroup_attach_task(child, current, is_dfl)))
+			cgroup_destroy_locked(child);
+		rcu_read_unlock();
+
+	}
+
+	spin_lock_bh(&css_set_lock);
 	cset = task_css_set(current);
 	get_css_set(cset);
-
 	spin_unlock_bh(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 
-- 
2.8.2
