From: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: [PATCH 1/2] kernfs: Add option to enable user xattrs
Date: Mon,  2 Mar 2020 17:39:00 -0800
Message-ID: <20200303013901.32150-2-dxu@dxuuu.xyz>
References: <20200303013901.32150-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=766BVSSbl7doT
        GCCsHkHXBjD7nP/xv3/vCxGfSjHZZI=; b=jogTPfXeyy0V2sHXCDtLtmKBXhTOu
        XyVG7LOM0T7QlRtUSxQxkGU9uY1BZUiWuJUEgWBgV/k3VVP8MuLksgl1CjXlfzwp
        izOEbvIjGF8M7MBfb1rtd3Xf1d4/GwpsF8QRtYcCXPRRuCQrRVhzCmDN925SlP5J
        HExE8PAR1g30+ylk1mCr5KK51z4x+GFMEhPHuziLGmjl1KQ67Wm7fNCrAUENpsQV
        AuKonxFF4GykGwvaOr0qNcVv+zn7ecMoELpAKRySOqvDh19pPD6NQQ6w+4X9AHgS
        dgCISFtcyA0gqsDLYp9C2j+ZnVjHK/ABO00Xa8S5NqrRMjfzw6Ah2pE8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=766BVSSbl7doTGCCsHkHXBjD7nP/xv3/vCxGfSjHZZI=; b=FiuHX7mg
        UqSRrDeIGyF5AuVuGBALtFgWxT2tgVws3KxIoj1Xt69Hq+NUVad4anTDwXA/Y3no
        L7uPMcfMNsTkOPuFsUz0rITRv7P5Hkb+jp3vSe4TI1g+8Ec4HHrsCrsocjKbUdPy
        kdQ6kWJPtb8kZa+uM2OWpur0KgBzkug4J3pmHqsEDcwfHeIZ7xtj1dhnf3fN7WU7
        EiHh0YKXimkZS24SuZV3sKG4RbnL+Wre09EYJ/25sZpGvSOEkDBfTAz5uNfaasCP
        Y/OcPfGMmPAxpvyXCwd40OPWwZr9l+etLUqOuja3zhLxGGarEwpmU3B1lhpew3O6
        bOEqW/u1F4Q0Gw==
In-Reply-To: <20200303013901.32150-1-dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

User extended attributes are useful as metadata storage for kernfs
consumers like cgroups. Especially in the case of cgroups, it is useful
to have a central metadata store that multiple processes/services can
use to coordinate actions.

A concrete example is for userspace out of memory killers. We want to
let delegated cgroup subtree owners (running as non-root) to be able to
say "please avoid killing this cgroup". In server environments this is
less important as everyone is running as root. But for desktop linux,
this is more important.

This patch introduces a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR, that
lets kernfs consumers enable user xattr support. An initial limit of 128
entries is placed because xattrs come from kernel memory and we don't
want to let unprivileged users accidentally eat up too much kernel
memory.

Signed-off-by: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
---
 fs/kernfs/inode.c           | 47 +++++++++++++++++++++++++++++++++++++
 fs/kernfs/kernfs-internal.h |  1 +
 include/linux/kernfs.h      |  6 +++++
 3 files changed, 54 insertions(+)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index d0f7a5abd9a9..6d603d1177c4 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -53,6 +53,7 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, int alloc)
 	kn->iattr->ia_ctime = kn->iattr->ia_atime;
 
 	simple_xattrs_init(&kn->iattr->xattrs);
+	atomic_set(&kn->iattr->nr_user_xattrs, 0);
 out_unlock:
 	ret = kn->iattr;
 	mutex_unlock(&iattr_mutex);
@@ -327,6 +328,45 @@ static int kernfs_vfs_xattr_set(const struct xattr_handler *handler,
 	return kernfs_xattr_set(kn, name, value, size, flags);
 }
 
+static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
+				     struct dentry *unused, struct inode *inode,
+				     const char *suffix, const void *value,
+				     size_t size, int flags)
+{
+	struct kernfs_node *kn = inode->i_private;
+	atomic_t *nr = &kn->iattr->nr_user_xattrs;
+	int ret;
+
+	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (value && atomic_inc_return(nr) > KERNFS_MAX_USER_XATTRS) {
+		ret = -ENOSPC;
+		goto dec_out;
+	}
+
+	ret = kernfs_vfs_xattr_set(handler, unused, inode, suffix, value,
+				   size, flags);
+
+	/*
+	 * Don't decrement counter if we successfully added an xattr
+	 */
+	if (value && !ret)
+		goto out;
+
+dec_out:
+	/*
+	 * Removing a nonexistent xattr without XATTR_REPLACE returns success
+	 * so we have to make sure here we don't go negative.
+	 */
+	if (atomic_dec_return(nr) < 0)
+		atomic_inc(nr);
+out:
+	return ret;
+}
+
 static const struct xattr_handler kernfs_trusted_xattr_handler = {
 	.prefix = XATTR_TRUSTED_PREFIX,
 	.get = kernfs_vfs_xattr_get,
@@ -339,8 +379,15 @@ static const struct xattr_handler kernfs_security_xattr_handler = {
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
index 2f3c51d55261..745505ce1f37 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -26,6 +26,7 @@ struct kernfs_iattrs {
 	struct timespec64	ia_ctime;
 
 	struct simple_xattrs	xattrs;
+	atomic_t		nr_user_xattrs;
 };
 
 /* +1 to avoid triggering overflow warning when negating it */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index dded2e5a9f42..0e06d67db05f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -39,6 +39,7 @@ enum kernfs_node_type {
 
 #define KERNFS_TYPE_MASK	0x000f
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
+#define KERNFS_MAX_USER_XATTRS  128
 
 enum kernfs_node_flag {
 	KERNFS_ACTIVATED	= 0x0010,
@@ -78,6 +79,11 @@ enum kernfs_root_flag {
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

