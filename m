From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v3 08/21] userns: Replace in_userns with
	current_in_userns
Date: Fri, 22 Apr 2016 10:38:25 -0500
Message-ID: <1461339521-123191-9-git-send-email-seth.forshee@canonical.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461339521-123191-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

All current callers of in_userns pass current_user_ns as the
first argument. Simplify by replacing in_userns with
current_in_userns which checks whether current_user_ns is in the
namespace supplied as an argument.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/namespace.c                 | 2 +-
 include/linux/user_namespace.h | 6 ++----
 kernel/user_namespace.c        | 6 +++---
 security/commoncap.c           | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6e9db4c166b4..0ad8e4a4f50b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3294,7 +3294,7 @@ bool mnt_may_suid(struct vfsmount *mnt)
 	 * in other namespaces.
 	 */
 	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
-	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+	       current_in_userns(mnt->mnt_sb->s_user_ns);
 }
 
 static struct ns_common *mntns_get(struct task_struct *task)
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a43faa727124..9217169c64cb 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -72,8 +72,7 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
 extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
-extern bool in_userns(const struct user_namespace *ns,
-		      const struct user_namespace *target_ns);
+extern bool current_in_userns(const struct user_namespace *target_ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -103,8 +102,7 @@ static inline bool userns_may_setgroups(const struct user_namespace *ns)
 	return true;
 }
 
-static inline bool in_userns(const struct user_namespace *ns,
-			     const struct user_namespace *target_ns)
+static inline bool current_in_userns(const struct user_namespace *target_ns)
 {
 	return true;
 }
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index dee3be5445da..68f594212759 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -942,10 +942,10 @@ bool userns_may_setgroups(const struct user_namespace *ns)
  * Returns true if @ns is the same namespace as or a descendant of
  * @target_ns.
  */
-bool in_userns(const struct user_namespace *ns,
-	       const struct user_namespace *target_ns)
+bool current_in_userns(const struct user_namespace *target_ns)
 {
-	for (; ns; ns = ns->parent) {
+	struct user_namespace *ns;
+	for (ns = current_user_ns(); ns; ns = ns->parent) {
 		if (ns == target_ns)
 			return true;
 	}
diff --git a/security/commoncap.c b/security/commoncap.c
index a306c5d90709..e657227d221e 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -461,7 +461,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	 * explicit that capability bits are limited to s_user_ns and its
 	 * descendants.
 	 */
-	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
+	if (!current_in_userns(bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
-- 
1.9.1


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel
