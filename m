From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: fix top cgroup refcnt leak
Date: Sat, 15 Feb 2014 12:03:04 +0800
Message-ID: <52FEE6F8.8030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If we mount the same cgroupfs in serveral mount points, and then
umount all of them, kill_sb() will be called only once.

Therefore it's wrong to increment top_cgroup's refcnt when we find
an existing cgroup_root.

Try:
        # mount -t cgroup -o cpuacct xxx /cgroup
        # mount -t cgroup -o cpuacct xxx /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1
        # umount /cgroup
        # umount /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1

You'll see cgroupfs will never be freed.

v2: change to take the refcnt and drop it after kernfs_mount().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 37d94a2..eaffc08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1477,6 +1477,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	bool new_root = false;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1536,6 +1537,10 @@ retry:
 		 * destruction to complete so that the subsystems are free.
 		 * We can use wait_queue for the wait but this path is
 		 * super cold.  Let's just sleep for a bit and retry.
+		 *
+		 * Take a reference so root won't be freed after we drop
+		 * cgroup mutexes, and drop it after we've done the real
+		 * mount through kernfs.
 		 */
 		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
@@ -1551,6 +1556,7 @@ retry:
 	}
 
 	/* no such thing, create a new one */
+	new_root = true;
 	root = cgroup_root_from_opts(&opts);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
@@ -1572,7 +1578,7 @@ out_unlock:
 		return ERR_PTR(ret);
 
 	dentry = kernfs_mount(fs_type, flags, root->kf_root);
-	if (IS_ERR(dentry))
+	if (IS_ERR(dentry) || !new_root)
 		cgroup_put(&root->top_cgroup);
 	return dentry;
 }
-- 
1.8.0.2
