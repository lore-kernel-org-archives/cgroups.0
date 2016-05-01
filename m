From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH v2] cgroup: allow management of subtrees by new cgroup namespaces
Date: Sun,  1 May 2016 23:41:05 +1000
Message-ID: <1462110065-4904-2-git-send-email-asarai@suse.de>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462110065-4904-1-git-send-email-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org, Aleksa Sarai <cyphar@cyphar.com>, Aleksa Sarai <asarai@suse.de>

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
processes from modifying the subtrees it set up. Such a process can do
so by creating another cgroup namespace with a subtree it owns as the
root of that namespace (then changing the file mode such that only
sufficiently capable processes in the associated user namespace can
modify the subtree setup).

Signed-off-by: Aleksa Sarai <asarai@suse.de>
Cc: dev@opencontainers.org
---
 kernel/cgroup.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 909a7d3..8f944f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3554,6 +3554,14 @@ static int cgroup_kn_set_ugid(struct kernfs_node *kn)
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
@@ -6228,8 +6236,12 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
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
 
@@ -6244,11 +6256,54 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 
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
+	 *    write access to two subtrees unless they also have write access to
+	 *    the common ancestor of the two subtrees. Thus you cannot use a
+	 *    complicit process in less restrictive cgroup to overcome your own
+	 *    cgroup restriction.
+	 *
+	 * Therefore, we can safely change the mode of the cgroup without any
+	 * ill effects. We don't do this on cgroupns_install(), because the
+	 * owner of the cgroup may have decided to disallow modifications to
+	 * the hierarchy (which can be done by creating a nested cgroup
+	 * namespace in a cgroup you now own).
+	 */
+	rcu_read_lock();
+	for_each_subsys(ss, ssid) {
+		struct kernfs_node *kn = cset->subsys[ssid]->cgroup->kn;
+
+		kernfs_get(kn);
+		kernfs_break_active_protection(kn);
+		mode[ssid] = kn->mode;
+		err = cgroup_kn_set_mode(kn, mode[ssid] |
+					     (S_IROTH | S_IWOTH | S_IXOTH));
+		kernfs_unbreak_active_protection(kn);
+		kernfs_put(kn);
+		if (err)
+			goto err_unset_mode;
+
+		updated_mask |= 1 << ssid;
+	}
+	rcu_read_unlock();
+
 	mutex_unlock(&cgroup_mutex);
 
 	new_ns = alloc_cgroup_ns();
@@ -6261,6 +6316,21 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
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

