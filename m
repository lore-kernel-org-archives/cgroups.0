From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v3 2/2] cgroup: allow management of subtrees by new cgroup namespaces
Date: Tue,  3 May 2016 00:01:21 +1000
Message-ID: <1462197681-6879-3-git-send-email-asarai@suse.de>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462197681-6879-1-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

Allow an unprivileged processes to control subtrees of their associated
cgroup, a necessary feature if an unprivileged container (set up with an
unprivileged user namespace) wishes to take advantage of cgroups for its
own subprocesses.

Change the mode of the cgroup directory for each cgroup association,
allowing the process to create subtrees and modify the limits of the
subtrees *without* allowing the process to modify its own limits. Due to
the cgroup core restrictions and unix permission model, this allows for
processes to create new subtrees without breaking the cgroup limits for
the process.

In addition, this change doesn't add any odd or new functionality (it
essentially emulates a privileged user allowing a process to create
subtrees of its current cgroup association). This means that client code
can take advantage of this without being aware of the kernel change.

It should be noted that the mode changing isn't done when a process
attaches to an existing cgroup namespace, because the process which
created the cgroup namespace may have decided to disallow other
processes from adding subtrees to its namespace. The mode changing is
also not done if the original mode of the cgroup didn't have a+rx, so
administrators can opt-out of this feature on a cgroup-by-cgroup basis.

Cc: dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org
Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
---
 kernel/cgroup.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 149217681054..2b44b6e4fa60 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3562,6 +3562,14 @@ static int cgroup_kn_set_ugid(struct kernfs_node *kn)
 	return kernfs_setattr(kn, &iattr);
 }
 
+static int cgroup_kn_set_mode(struct kernfs_node *kn, umode_t mode)
+{
+	struct iattr iattr = { .ia_valid = ATTR_MODE,
+			       .ia_mode = mode, };
+
+	return kernfs_setattr(kn, &iattr);
+}
+
 static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 			   struct cftype *cft)
 {
@@ -6233,12 +6241,18 @@ void free_cgroup_ns(struct cgroup_namespace *ns)
 }
 EXPORT_SYMBOL(free_cgroup_ns);
 
+#define S_IRXO (S_IROTH | S_IXOTH)
+
 struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 					struct user_namespace *user_ns,
 					struct cgroup_namespace *old_ns)
 {
+	struct cgroup_subsys *ss;
 	struct cgroup_namespace *new_ns;
 	struct css_set *cset;
+	int ssid, err;
+	umode_t mode[CGROUP_SUBSYS_COUNT];
+	u16 updated_mask = 0;
 
 	BUG_ON(!old_ns);
 
@@ -6253,11 +6267,60 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 
 	mutex_lock(&cgroup_mutex);
 	spin_lock_bh(&css_set_lock);
-
 	cset = task_css_set(current);
 	get_css_set(cset);
-
 	spin_unlock_bh(&css_set_lock);
+
+	/*
+	 * When creating a new cgroup namespace, we change the permissions of
+	 * the cgroup's directory to be a+w. This is necessary in order to
+	 * allow new cgroup namespaces to manage their own subtrees. This does
+	 * not allow for an escape from cgroup policy for three reasons:
+	 *
+	 * 1. cgroups are hierarchical, so any subtree must (at the very least)
+	 *    obey the original cgroup's restrictions.
+	 *
+	 * 2. The unix permission model for directories does not allow a user
+	 *    with write access to a directory to directly modify the dentries.
+	 *    While a user can unlink such files in a normal directory, in
+	 *    cgroupfs this is not allowed.
+	 *
+	 * 3. cgroup core doesn't allow tasks to be migrated by users that have
+	 *    write access to two subtrees' cgroup.procs files unless they also
+	 *    have write access to the common ancestor of the two subtrees'
+	 *    cgroup.procs file. Thus you cannot use a complicit process in
+	 *    less restrictive cgroup to overcome your own cgroup restriction.
+	 *
+	 * Therefore, we can safely change the mode of the cgroup without any
+	 * ill effects. We don't do this on cgroupns_install(), because an
+	 * process might not want to allow other processes to create subtrees in
+	 * a cgroup namespace they've created.
+	 *
+	 * In addition, we only change the permission if the cgroup directory
+	 * already has a+rx. This means that an administrator can disable this
+	 * functionality for a cgroup by making it no longer world rx.
+	 */
+	rcu_read_lock();
+	for_each_subsys(ss, ssid) {
+		struct kernfs_node *kn = cset->subsys[ssid]->cgroup->kn;
+
+		kernfs_get(kn);
+		kernfs_break_active_protection(kn);
+
+		mode[ssid] = kn->mode;
+		if (mode & S_IRXO == S_IRXO)
+			err = cgroup_kn_set_mode(kn, mode[ssid] | S_IWOTH);
+
+		kernfs_unbreak_active_protection(kn);
+		kernfs_put(kn);
+
+		if (err)
+			goto err_unset_mode;
+
+		updated_mask |= 1 << ssid;
+	}
+	rcu_read_unlock();
+
 	mutex_unlock(&cgroup_mutex);
 
 	new_ns = alloc_cgroup_ns();
@@ -6270,6 +6333,21 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 	new_ns->root_cset = cset;
 
 	return new_ns;
+
+err_unset_mode:
+	/* Clean up the mode changes. */
+	do_each_subsys_mask(ss, ssid, updated_mask) {
+		struct kernfs_node *kn = cset->subsys[ssid]->cgroup->kn;
+
+		kernfs_break_active_protection(kn);
+		cgroup_kn_set_mode(kn, mode[ssid]);
+		kernfs_unbreak_active_protection(kn);
+	} while_each_subsys_mask();
+
+	rcu_read_unlock();
+	mutex_unlock(&cgroup_mutex);
+
+	return ERR_PTR(err);
 }
 
 static inline struct cgroup_namespace *to_cg_ns(struct ns_common *ns)
-- 
2.8.1
