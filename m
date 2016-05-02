From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v3 1/2] cgroup: apply common ancestor cgroup.procs restriction in cgroupv1
Date: Tue,  3 May 2016 00:01:20 +1000
Message-ID: <1462197681-6879-2-git-send-email-asarai@suse.de>
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

The common ancestor restriction for moving tasks between cgroups (the
process moving the task must have the right to write to cgroup.procs in
both the destination and common ancestor cgroup) only applied for
cgroupv2 (cgroups in the default hierarchy). This meant that there was a
different policy for unprivileged users in the different cgroup
hierarchies.

Update cgroup_procs_write_permission() to apply the cgroup.procs
restriction regardless of the cgroup root of the destination cgroup.
However, if the task doesn't have any association with the destination
hierarchy, there's no permission check to be done. In addition, if the
destination cgroup is a descendant of the task's current cgroup then
there are no further permission checks. This is important for
unprivileged processes creating subtrees.

---
% sudo mount -t cgroup -o pids cgroup /sys/fs/cgroup/pids
% sudo mkdir /sys/fs/cgroup/pids/parent
% sudo chmod a+w /sys/fs/cgroup/pids/parent
% echo $$ | sudo tee /sys/fs/cgroup/pids/parent/cgroup.procs
1337
% mkdir /sys/fs/cgroup/pids/parent/{a,b}
% echo $$ | tee /sys/fs/cgroup/pids/parent/a/cgroup.procs
1337
% echo $$ | tee /sys/fs/cgroup/pids/parent/b/cgroup.procs
tee: /sys/fs/cgroup/pids/parent/b/cgroup.procs: Permission denied
---

Fixes: 187fe84067bd ("cgroup: require write perm on common ancestor when
moving processes on the default hierarchy")
Cc: dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org
Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>

Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
---
 kernel/cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 909a7d31ffd3..149217681054 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2784,7 +2784,7 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	int ret = 0;
 
 	/*
-	 * even if we're attaching all tasks in the thread group, we only
+	 * Even if we're attaching all tasks in the thread group, we only
 	 * need to check permissions on one of them.
 	 */
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
@@ -2792,15 +2792,22 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 	    !uid_eq(cred->euid, tcred->suid))
 		ret = -EACCES;
 
-	if (!ret && cgroup_on_dfl(dst_cgrp)) {
+	if (!ret) {
 		struct super_block *sb = of->file->f_path.dentry->d_sb;
 		struct cgroup *cgrp;
 		struct inode *inode;
 
 		spin_lock_bh(&css_set_lock);
-		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+		cgrp = task_cgroup_from_root(task, dst_cgrp->root);
 		spin_unlock_bh(&css_set_lock);
 
+		/*
+		 * We don't do any cgroup.proc permission checks if the user is trying
+		 * to mode the process to subtree of the current cgroup it is in.
+		 */
+		if (cgroup_is_descendant(dst_cgrp, cgrp))
+			goto out_put_cred;
+
 		while (!cgroup_is_descendant(dst_cgrp, cgrp))
 			cgrp = cgroup_parent(cgrp);
 
@@ -2812,6 +2819,7 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 		}
 	}
 
+out_put_cred:
 	put_cred(tcred);
 	return ret;
 }
@@ -4824,6 +4832,7 @@ static struct cftype cgroup_dfl_base_files[] = {
 static struct cftype cgroup_legacy_base_files[] = {
 	{
 		.name = "cgroup.procs",
+		.file_offset = offsetof(struct cgroup, procs_file),
 		.seq_start = cgroup_pidlist_start,
 		.seq_next = cgroup_pidlist_next,
 		.seq_stop = cgroup_pidlist_stop,
-- 
2.8.1
