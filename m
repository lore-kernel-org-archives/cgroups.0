From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v3 06/21] fs: Treat foreign mounts as nosuid
Date: Fri, 22 Apr 2016 10:38:23 -0500
Message-ID: <1461339521-123191-7-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>

If a process gets access to a mount from a different user
namespace, that process should not be able to take advantage of
setuid files or selinux entrypoints from that filesystem.  Prevent
this by treating mounts from other mount namespaces and those not
owned by current_user_ns() or an ancestor as nosuid.

This will make it safer to allow more complex filesystems to be
mounted in non-root user namespaces.

This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
setgid, and file capability bits can no longer be abused if code in
a user namespace were to clear nosuid on an untrusted filesystem,
but this patch, by itself, is insufficient to protect the system
from abuse of files that, when execed, would increase MAC privilege.

As a more concrete explanation, any task that can manipulate a
vfsmount associated with a given user namespace already has
capabilities in that namespace and all of its descendents.  If they
can cause a malicious setuid, setgid, or file-caps executable to
appear in that mount, then that executable will only allow them to
elevate privileges in exactly the set of namespaces in which they
are already privileges.

On the other hand, if they can cause a malicious executable to
appear with a dangerous MAC label, running it could change the
caller's security context in a way that should not have been
possible, even inside the namespace in which the task is confined.

As a hardening measure, this would have made CVE-2014-5207 much
more difficult to exploit.

Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/exec.c                |  2 +-
 fs/namespace.c           | 13 +++++++++++++
 include/linux/mount.h    |  1 +
 security/commoncap.c     |  8 +++++++-
 security/selinux/hooks.c |  2 +-
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c4010b8207a1..706088dd0cb1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1391,7 +1391,7 @@ static void bprm_fill_uid(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return;
 
 	if (task_no_new_privs(current))
diff --git a/fs/namespace.c b/fs/namespace.c
index c133318bec35..6e9db4c166b4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3284,6 +3284,19 @@ found:
 	return visible;
 }
 
+bool mnt_may_suid(struct vfsmount *mnt)
+{
+	/*
+	 * Foreign mounts (accessed via fchdir or through /proc
+	 * symlinks) are always treated as if they are nosuid.  This
+	 * prevents namespaces from trusting potentially unsafe
+	 * suid/sgid bits, file caps, or security labels that originate
+	 * in other namespaces.
+	 */
+	return !(mnt->mnt_flags & MNT_NOSUID) && check_mnt(real_mount(mnt)) &&
+	       in_userns(current_user_ns(), mnt->mnt_sb->s_user_ns);
+}
+
 static struct ns_common *mntns_get(struct task_struct *task)
 {
 	struct ns_common *ns = NULL;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f822c3c11377..54a594d49733 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -81,6 +81,7 @@ extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+extern bool mnt_may_suid(struct vfsmount *mnt);
 
 struct path;
 extern struct vfsmount *clone_private_mount(struct path *path);
diff --git a/security/commoncap.c b/security/commoncap.c
index 8912ef117faa..a306c5d90709 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -453,8 +453,14 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return 0;
+
+	/*
+	 * This check is redundant with mnt_may_suid() but is kept to make
+	 * explicit that capability bits are limited to s_user_ns and its
+	 * descendants.
+	 */
 	if (!in_userns(current_user_ns(), bprm->file->f_path.mnt->mnt_sb->s_user_ns))
 		return 0;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 912deee3f01e..1350167635cb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2234,7 +2234,7 @@ static int check_nnp_nosuid(const struct linux_binprm *bprm,
 			    const struct task_security_struct *new_tsec)
 {
 	int nnp = (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
-	int nosuid = (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+	int nosuid = !mnt_may_suid(bprm->file->f_path.mnt);
 	int rc;
 
 	if (!nnp && !nosuid)
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
