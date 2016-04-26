From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v4 17/21] capabilities: Allow privileged user
	in s_user_ns to set security.* xattrs
Date: Tue, 26 Apr 2016 14:36:30 -0500
Message-ID: <1461699396-33000-18-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

A privileged user in s_user_ns will generally have the ability to
manipulate the backing store and insert security.* xattrs into
the filesystem directly. Therefore the kernel must be prepared to
handle these xattrs from unprivileged mounts, and it makes little
sense for commoncap to prevent writing these xattrs to the
filesystem. The capability and LSM code have already been updated
to appropriately handle xattrs from unprivileged mounts, so it
is safe to loosen this restriction on setting xattrs.

The exception to this logic is that writing xattrs to a mounted
filesystem may also cause the LSM inode_post_setxattr or
inode_setsecurity callbacks to be invoked. SELinux will deny the
xattr update by virtue of applying mountpoint labeling to
unprivileged userns mounts, and Smack will deny the writes for
any user without global CAP_MAC_ADMIN, so loosening the
capability check in commoncap is safe in this respect as well.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 security/commoncap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index e657227d221e..12477afaa8ed 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -664,15 +664,17 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
 int cap_inode_setxattr(struct dentry *dentry, const char *name,
 		       const void *value, size_t size, int flags)
 {
+	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
+
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
+		if (!ns_capable(user_ns, CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !ns_capable(user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
@@ -690,15 +692,17 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
  */
 int cap_inode_removexattr(struct dentry *dentry, const char *name)
 {
+	struct user_namespace *user_ns = dentry->d_sb->s_user_ns;
+
 	if (!strcmp(name, XATTR_NAME_CAPS)) {
-		if (!capable(CAP_SETFCAP))
+		if (!ns_capable(user_ns, CAP_SETFCAP))
 			return -EPERM;
 		return 0;
 	}
 
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
 		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !ns_capable(user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
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
