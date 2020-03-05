From: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: [PATCH v2 3/4] kernfs: Add option to enable user xattrs
Date: Thu,  5 Mar 2020 13:16:31 -0800
Message-ID: <20200305211632.15369-4-dxu@dxuuu.xyz>
References: <20200305211632.15369-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=M+E5QimJJ7S/c
        0nKhArR5IdwBJvASG/qtOi1ZOkT6yA=; b=RttiWcZO+PdSXEE+KsQx/dSlOr8YV
        h9aSp6oZFw0vCpd5xCYNmPbZy7wgYpto9CRxx635Hdu7cCM/JECkl+xY2wJG4hai
        FLSpZfakIHwrMWPANvfGOab003opNvHcfdb1F1WRqg/p94Mhxz7XnzS6Zq06oihT
        yEqAgnf7Vav+CU48CMfourjkkxg8WIkUyDahF6VoAHrLzpBKscTDF0oeBRdLlHpl
        uU7qs7xYXpTTHWqZTw+pnnyLOahJeOgrbYq1G37cCuNq2xKwHSCnPzH2F+OA+vxh
        LOLV1+QtMhH2ivo3RlugDmw10UYYs2HAkMTXjP+TQlUTuKh73nvBpQs7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=M+E5QimJJ7S/c0nKhArR5IdwBJvASG/qtOi1ZOkT6yA=; b=JBTQRkKp
        UqLFsth9OoPCGb3I2r186opnlu22MVpWi/HdgleQZR9ZUExbLu6RjfgG6FlWH7d2
        jg1/3QvrYKoT/+ZTryxuLS8X+0Yh/9sg2vntiNzHH83QA8lOKXknaDITLMn7WpjS
        tLJGKiWi3jJYeekImgKSOUnZ+C6Xa+QMkqb+2EgNxBF8WLm573G9mb1h4GSIORZl
        FhNWPe4SRT3TT3Xdi223yZIZa3YquuSNCvPwWXtI3Ti63WheEpRPU84Vqk6No7Vu
        xlfISxaSgPZ6x3fUoU5bjfsn41G6nPlsHLCTn2+awRtB3erGSUVhAw2t+M5xi2E6
        UI6bscKZ+krR0Q==
In-Reply-To: <20200305211632.15369-1-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

User extended attributes are useful as metadata storage for kernfs
consumers like cgroups. Especially in the case of cgroups, it is useful
to have a central metadata store that multiple processes/services can
use to coordinate actions.

A concrete example is for userspace out of memory killers. We want to
let delegated cgroup subtree owners (running as non-root) to be able to
say "please avoid killing this cgroup". This is especially important for
desktop linux as delegated subtrees owners are less likely to run as
root.

This patch introduces a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR, that
lets kernfs consumers enable user xattr support. An initial limit of 128
entries or 128KB -- whichever is hit first -- is placed per cgroup
because xattrs come from kernel memory and we don't want to let
unprivileged users accidentally eat up too much kernel memory.

Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
---
 fs/kernfs/inode.c           | 89 +++++++++++++++++++++++++++++++++++++
 fs/kernfs/kernfs-internal.h |  2 +
 include/linux/kernfs.h      | 11 ++++-
 3 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 5f10ae95fbfa..fc2469a20fed 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -53,6 +53,8 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, int alloc)
 	kn->iattr->ia_ctime = kn->iattr->ia_atime;
 
 	simple_xattrs_init(&kn->iattr->xattrs);
+	atomic_set(&kn->iattr->nr_user_xattrs, 0);
+	atomic_set(&kn->iattr->user_xattr_size, 0);
 out_unlock:
 	ret = kn->iattr;
 	mutex_unlock(&iattr_mutex);
@@ -327,6 +329,86 @@ static int kernfs_vfs_xattr_set(const struct xattr_handler *handler,
 	return kernfs_xattr_set(kn, name, value, size, flags);
 }
 
+static int kernfs_vfs_user_xattr_add(struct kernfs_node *kn,
+				     const char *full_name,
+				     struct simple_xattrs *xattrs,
+				     const void *value, size_t size, int flags)
+{
+	atomic_t *sz = &kn->iattr->user_xattr_size;
+	atomic_t *nr = &kn->iattr->nr_user_xattrs;
+	ssize_t removed_size;
+	int ret;
+
+	if (atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
+		ret = -ENOSPC;
+		goto dec_count_out;
+	}
+
+	if (atomic_add_return(size, sz) > KERNFS_USER_XATTR_SIZE_LIMIT) {
+		ret = -ENOSPC;
+		goto dec_size_out;
+	}
+
+	ret = simple_xattr_set(xattrs, full_name, value, size, flags,
+			       &removed_size);
+
+	if (!ret && removed_size >= 0)
+		size = removed_size;
+	else if (!ret)
+		return 0;
+dec_size_out:
+	atomic_sub(size, sz);
+dec_count_out:
+	atomic_dec(nr);
+	return ret;
+}
+
+static int kernfs_vfs_user_xattr_rm(struct kernfs_node *kn,
+				    const char *full_name,
+				    struct simple_xattrs *xattrs,
+				    const void *value, size_t size, int flags)
+{
+	atomic_t *sz = &kn->iattr->user_xattr_size;
+	atomic_t *nr = &kn->iattr->nr_user_xattrs;
+	ssize_t removed_size;
+	int ret;
+
+	ret = simple_xattr_set(xattrs, full_name, value, size, flags,
+			       &removed_size);
+
+	if (removed_size >= 0) {
+		atomic_sub(removed_size, sz);
+		atomic_dec(nr);
+	}
+
+	return ret;
+}
+
+static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
+				     struct dentry *unused, struct inode *inode,
+				     const char *suffix, const void *value,
+				     size_t size, int flags)
+{
+	const char *full_name = xattr_full_name(handler, suffix);
+	struct kernfs_node *kn = inode->i_private;
+	struct kernfs_iattrs *attrs;
+
+	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR))
+		return -EOPNOTSUPP;
+
+	attrs = kernfs_iattrs(kn);
+	if (!attrs)
+		return -ENOMEM;
+
+	if (value)
+		return kernfs_vfs_user_xattr_add(kn, full_name, &attrs->xattrs,
+						 value, size, flags);
+	else
+		return kernfs_vfs_user_xattr_rm(kn, full_name, &attrs->xattrs,
+						value, size, flags);
+
+}
+
 static const struct xattr_handler kernfs_trusted_xattr_handler = {
 	.prefix = XATTR_TRUSTED_PREFIX,
 	.get = kernfs_vfs_xattr_get,
@@ -339,8 +421,15 @@ static const struct xattr_handler kernfs_security_xattr_handler = {
 	.set = kernfs_vfs_xattr_set,
 };
 
+static const struct xattr_handler kernfs_user_xattr_handler = {
+	.prefix = XATTR_USER_PREFIX,
+	.get = kernfs_vfs_xattr_get,
+	.set = kernfs_vfs_user_xattr_set,
+};
+
 const struct xattr_handler *kernfs_xattr_handlers[] = {
 	&kernfs_trusted_xattr_handler,
 	&kernfs_security_xattr_handler,
+	&kernfs_user_xattr_handler,
 	NULL
 };
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 2f3c51d55261..7ee97ef59184 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,6 +26,8 @@ struct kernfs_iattrs {
 	struct timespec64	ia_ctime;
 
 	struct simple_xattrs	xattrs;
+	atomic_t		nr_user_xattrs;
+	atomic_t		user_xattr_size;
 };
 
 /* +1 to avoid triggering overflow warning when negating it */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index dded2e5a9f42..89f6a4214a70 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -37,8 +37,10 @@ enum kernfs_node_type {
 	KERNFS_LINK		= 0x0004,
 };
 
-#define KERNFS_TYPE_MASK	0x000f
-#define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
+#define KERNFS_TYPE_MASK		0x000f
+#define KERNFS_FLAG_MASK		~KERNFS_TYPE_MASK
+#define KERNFS_MAX_USER_XATTRS		128
+#define KERNFS_USER_XATTR_SIZE_LIMIT	(128 << 10)
 
 enum kernfs_node_flag {
 	KERNFS_ACTIVATED	= 0x0010,
@@ -78,6 +80,11 @@ enum kernfs_root_flag {
 	 * fhandle to access nodes of the fs.
 	 */
 	KERNFS_ROOT_SUPPORT_EXPORTOP		= 0x0004,
+
+	/*
+	 * Support user xattrs to be written to nodes rooted at this root.
+	 */
+	KERNFS_ROOT_SUPPORT_USER_XATTR		= 0x0008,
 };
 
 /* type-specific structures for kernfs_node union members */
-- 
2.21.1

