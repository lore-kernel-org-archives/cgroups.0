From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v4 03/21] fs: Allow sysfs and cgroupfs to share
	super blocks between user namespaces
Date: Tue, 26 Apr 2016 14:36:16 -0500
Message-ID: <1461699396-33000-4-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Both of these filesystems already have use cases for mounting the
same super block from multiple user namespaces. For sysfs this
happens when using criu for snapshotting a container, where sysfs
is mounted in the containers network ns but the hosts user ns.
The cgroup filesystem shares the same super block for all mounts
of the same hierarchy regardless of the namespace.

As a result, the restriction on mounting a super block from a
single user namespace creates regressions for existing uses of
these filesystems. For these specific filesystems this
restriction isn't really necessary since the backing store is
objects in kernel memory and thus the ids assigned from inodes
is not subject to translation relative to s_user_ns.

Add a new filesystem flag, FS_USERNS_SHARE_SB, which when set
causes sget_userns() to skip the check of s_user_ns. Set this
flag for the sysfs and cgroup filesystems to fix the
regressions.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 fs/super.c         | 3 ++-
 fs/sysfs/mount.c   | 3 ++-
 include/linux/fs.h | 1 +
 kernel/cgroup.c    | 4 ++--
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 092a7828442e..ead156b44bf8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -472,7 +472,8 @@ retry:
 		hlist_for_each_entry(old, &type->fs_supers, s_instances) {
 			if (!test(old, data))
 				continue;
-			if (user_ns != old->s_user_ns) {
+			if (!(type->fs_flags & FS_USERNS_SHARE_SB) &&
+			    user_ns != old->s_user_ns) {
 				spin_unlock(&sb_lock);
 				if (s) {
 					up_write(&s->s_umount);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index f3db82071cfb..9555accd4322 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -59,7 +59,8 @@ static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.mount		= sysfs_mount,
 	.kill_sb	= sysfs_kill_sb,
-	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT |
+			  FS_USERNS_SHARE_SB,
 };
 
 int __init sysfs_init(void)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index be0f8023e28c..66a639ec1bc4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1988,6 +1988,7 @@ struct file_system_type {
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
 #define FS_USERNS_VISIBLE	32	/* FS must already be visible */
+#define FS_USERNS_SHARE_SB	64	/* Allow sharing sb between userns-es */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 671dc05c0b0f..9c9aa27e531a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2247,14 +2247,14 @@ static struct file_system_type cgroup_fs_type = {
 	.name = "cgroup",
 	.mount = cgroup_mount,
 	.kill_sb = cgroup_kill_sb,
-	.fs_flags = FS_USERNS_MOUNT,
+	.fs_flags = FS_USERNS_MOUNT | FS_USERNS_SHARE_SB,
 };
 
 static struct file_system_type cgroup2_fs_type = {
 	.name = "cgroup2",
 	.mount = cgroup_mount,
 	.kill_sb = cgroup_kill_sb,
-	.fs_flags = FS_USERNS_MOUNT,
+	.fs_flags = FS_USERNS_MOUNT | FS_USERNS_SHARE_SB,
 };
 
 static char *cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
-- 
2.7.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
