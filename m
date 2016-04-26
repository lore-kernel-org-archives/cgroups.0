From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v4 13/21] fs: Update posix_acl support to
	handle user namespace mounts
Date: Tue, 26 Apr 2016 14:36:26 -0500
Message-ID: <1461699396-33000-14-git-send-email-seth.forshee@canonical.com>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

ids in on-disk ACLs should be converted to s_user_ns instead of
init_user_ns as is done now. This introduces the possibility for
id mappings to fail, and when this happens syscalls will return
EOVERFLOW.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/posix_acl.c                  | 67 ++++++++++++++++++++++++++---------------
 fs/xattr.c                      | 19 +++++++++---
 include/linux/posix_acl_xattr.h | 17 ++++++++---
 3 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 711dd5170376..dac2842dd4cb 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -595,59 +595,77 @@ EXPORT_SYMBOL_GPL(posix_acl_create);
 /*
  * Fix up the uids and gids in posix acl extended attributes in place.
  */
-static void posix_acl_fix_xattr_userns(
+static int posix_acl_fix_xattr_userns(
 	struct user_namespace *to, struct user_namespace *from,
 	void *value, size_t size)
 {
 	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
 	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
 	int count;
-	kuid_t uid;
-	kgid_t gid;
+	kuid_t kuid;
+	uid_t uid;
+	kgid_t kgid;
+	gid_t gid;
 
 	if (!value)
-		return;
+		return 0;
 	if (size < sizeof(posix_acl_xattr_header))
-		return;
+		return 0;
 	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
-		return;
+		return 0;
 
 	count = posix_acl_xattr_count(size);
 	if (count < 0)
-		return;
+		return 0;
 	if (count == 0)
-		return;
+		return 0;
 
 	for (end = entry + count; entry != end; entry++) {
 		switch(le16_to_cpu(entry->e_tag)) {
 		case ACL_USER:
-			uid = make_kuid(from, le32_to_cpu(entry->e_id));
-			entry->e_id = cpu_to_le32(from_kuid(to, uid));
+			kuid = make_kuid(from, le32_to_cpu(entry->e_id));
+			if (!uid_valid(kuid))
+				return -EOVERFLOW;
+			uid = from_kuid(to, kuid);
+			if (uid == (uid_t)-1)
+				return -EOVERFLOW;
+			entry->e_id = cpu_to_le32(uid);
 			break;
 		case ACL_GROUP:
-			gid = make_kgid(from, le32_to_cpu(entry->e_id));
-			entry->e_id = cpu_to_le32(from_kgid(to, gid));
+			kgid = make_kgid(from, le32_to_cpu(entry->e_id));
+			if (!gid_valid(kgid))
+				return -EOVERFLOW;
+			gid = from_kgid(to, kgid);
+			if (gid == (gid_t)-1)
+				return -EOVERFLOW;
+			entry->e_id = cpu_to_le32(gid);
 			break;
 		default:
 			break;
 		}
 	}
+
+	return 0;
 }
 
-void posix_acl_fix_xattr_from_user(void *value, size_t size)
+int
+posix_acl_fix_xattr_from_user(struct user_namespace *target_ns, void *value,
+			      size_t size)
 {
-	struct user_namespace *user_ns = current_user_ns();
-	if (user_ns == &init_user_ns)
-		return;
-	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, value, size);
+	struct user_namespace *source_ns = current_user_ns();
+	if (source_ns == target_ns)
+		return 0;
+	return posix_acl_fix_xattr_userns(target_ns, source_ns, value, size);
 }
 
-void posix_acl_fix_xattr_to_user(void *value, size_t size)
+int
+posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+			    size_t size)
 {
-	struct user_namespace *user_ns = current_user_ns();
-	if (user_ns == &init_user_ns)
-		return;
-	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, value, size);
+	struct user_namespace *target_ns = current_user_ns();
+	if (target_ns == source_ns)
+		return 0;
+	return posix_acl_fix_xattr_userns(target_ns, source_ns, value, size);
 }
 
 /*
@@ -780,7 +798,7 @@ posix_acl_xattr_get(const struct xattr_handler *handler,
 	if (acl == NULL)
 		return -ENODATA;
 
-	error = posix_acl_to_xattr(&init_user_ns, acl, value, size);
+	error = posix_acl_to_xattr(dentry->d_sb->s_user_ns, acl, value, size);
 	posix_acl_release(acl);
 
 	return error;
@@ -806,7 +824,8 @@ posix_acl_xattr_set(const struct xattr_handler *handler,
 		return -EPERM;
 
 	if (value) {
-		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		acl = posix_acl_from_xattr(dentry->d_sb->s_user_ns, value,
+					   size);
 		if (IS_ERR(acl))
 			return PTR_ERR(acl);
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 4861322e28e8..c541121945cd 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -330,8 +330,12 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
 			goto out;
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(kvalue, size);
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)) {
+			error = posix_acl_fix_xattr_from_user(d->d_sb->s_user_ns,
+							      kvalue, size);
+			if (error)
+				goto out;
+		}
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
@@ -427,9 +431,14 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
 	error = vfs_getxattr(d, kname, kvalue, size);
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(kvalue, size);
-		if (size && copy_to_user(value, kvalue, error))
+		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0)) {
+			int ret;
+			ret = posix_acl_fix_xattr_to_user(d->d_sb->s_user_ns,
+							  kvalue, size);
+			if (ret)
+				error = ret;
+		}
+		if (error > 0 && size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
 		/* The file system tried to returned a value bigger
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index e5e8ec40278d..5dec6b10951a 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -49,14 +49,23 @@ posix_acl_xattr_count(size_t size)
 }
 
 #ifdef CONFIG_FS_POSIX_ACL
-void posix_acl_fix_xattr_from_user(void *value, size_t size);
-void posix_acl_fix_xattr_to_user(void *value, size_t size);
+int posix_acl_fix_xattr_from_user(struct user_namespace *target_ns,
+				  void *value, size_t size);
+int posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+				size_t size);
 #else
-static inline void posix_acl_fix_xattr_from_user(void *value, size_t size)
+static inline int
+posix_acl_fix_xattr_from_user(struct user_namespace *target_ns, void *value,
+			      size_t size)
 {
+	return 0;
 }
-static inline void posix_acl_fix_xattr_to_user(void *value, size_t size)
+
+static inline int
+posix_acl_fix_xattr_to_user(struct user_namespace *source_ns, void *value,
+			    size_t size)
 {
+	return 0;
 }
 #endif
 
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
