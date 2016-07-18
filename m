From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v1 2/3] cgroup: allow for unprivileged subtree management
Date: Tue, 19 Jul 2016 02:18:15 +1000
Message-ID: <20160718161816.13040-3-asarai@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718161816.13040-1-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Use the new custom ->permission hook to allow unprivileged processes to
mkdir new sub-cgroup directories of the root_cset of their current
cgroup namespace. No process outside of the cgroup namespace (or in a
sub-namespace) has this ability, and thus a process must have sufficient
privileges to setns to a cgroup namespace in order to create cgroups in
a cgroup they are not currently residing in.

Only privileged processes in the user namespace pinned to the cgroup
namespace have this new ability. This further restricts any oddness from
happening with the creation of many cgroups which the process cannot
effectively join.

This change only applies to the default hierarchy, as cgroupv1 cgroups
are not necessarily hierarchical (thus allowing the creating of new
sub-cgroups would allow for circumvention of cgroup limits). However,
since cgroupv2 cgroups are strictly hierarchical as a design constraint
this is possible.

It should be noted that cgroupv2 also has attaching restrictions that
make this process safe against two complicit processes from migrating
a process to the less restrictive cgroup of the two.

Cc: dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org
Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
---
 kernel/cgroup.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8647f3112f5c..4559baa7eabd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5490,6 +5490,67 @@ static int cgroup_rmdir(struct kernfs_node *kn)
 	return ret;
 }
 
+/*
+ * We have specific rules when deciding if a process can write to a cgroup
+ * directory, based on their current state inside cgroupns.
+ */
+static int cgroup_permission(struct inode *inode, struct kernfs_node *kn,
+			     int mask)
+{
+	int ret;
+	struct cgroup *cgroup;
+	struct cgroup_namespace *cgroupns;
+
+	/*
+	 * First, compute the generic_permission return value. In most cases
+	 * this will succeed and we can also avoid duplicating this code.
+	 */
+
+	cgroup = kn->priv;
+	cgroup_get(cgroup);
+
+	/* First, try the generic method which should work in most cases. */
+	ret = generic_permission(inode, mask);
+
+	/* If the generic check succeeded, then we're all good. */
+	if (!ret)
+		goto out_put_cgroup;
+
+	/* We're only interested in cgroup directories. */
+	if (kernfs_type(kn) != KERNFS_DIR)
+		goto out_put_cgroup;
+
+	/* ... and in may_create() operations only. */
+	if ((mask & (MAY_WRITE | MAY_EXEC)) != (MAY_WRITE | MAY_EXEC))
+		goto out_put_cgroup;
+
+	/*
+	 * This only applies for cgroups on the default hierarchy, as cgroupv1
+	 * was not truly hierarchical this operation was not safe.
+	 */
+	if (!cgroup_on_dfl(cgroup))
+		goto out_put_cgroup;
+
+	cgroupns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(cgroupns);
+
+	ret = -EPERM;
+	if (cgroupns->root_cset->dfl_cgrp == cgroup) {
+		/*
+		 * Check CAP_SYS_ADMIN, to make sure that unprivileged
+		 * processes inside a cgroup namespace they don't "own" don't
+		 * get any special treatment.
+		 */
+		if (ns_capable(cgroupns->user_ns, CAP_SYS_ADMIN))
+			ret = 0;
+	}
+
+	put_cgroup_ns(cgroupns);
+out_put_cgroup:
+	cgroup_put(cgroup);
+	return ret;
+}
+
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.remount_fs		= cgroup_remount,
 	.show_options		= cgroup_show_options,
@@ -5497,6 +5558,7 @@ static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.rmdir			= cgroup_rmdir,
 	.rename			= cgroup_rename,
 	.show_path		= cgroup_show_path,
+	.permission		= cgroup_permission,
 };
 
 static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
-- 
2.9.0
