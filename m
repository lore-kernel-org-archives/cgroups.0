From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 13/21] fs: Update posix_acl support to handle user namespace mounts
Date: Fri, 22 Apr 2016 10:38:30 -0500
Message-ID: <1461339521-123191-14-git-send-email-seth.forshee@canonical.com>
References: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6uB4AqUIN0xMCdU9g428yPeWaV5TbO2iemvqfNcQLig=;
        b=yYm4EkghufQN8h7NXMemEgyvfARAUJEnaWLdece+cvDg/2En/8cQWKRih4SX0WYHng
         ftGIR3HTYAUiw0Q1wBeseNh/u6UTQ+tFMJO+afOwlrB6BnpsJtQ7BCHKOJ/8iVIn4sBA
         q+Xxf9PQJLfMGPbeTaMq1LYlm5PVZMDJ5YO0lnn95UToJWZkyf9VUmWxUcJwU5Q/e2am
         NFKNXTa/srCr1flKkQ03ZjRcc1KCw88CoamziYMXMPa1pqCXi9UsSEmQFHUrSbNpFjOU
         Q24ne1tsPLl2b+6pdj6jKABcmHZnRRqnWRDXT4wzwKYigSFVi80hjUiqAjG83OHzEAW8
         ExCQ==
In-Reply-To: <1461339521-123191-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

ids in on-disk ACLs should be converted to s_user_ns instead of
init_user_ns as is done now. This introduces the possibility for
id mappings to fail, and when this happens syscalls will return
EOVERFLOW.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
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
1.9.1

