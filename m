From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.15-rc1
Date: Mon, 7 Apr 2014 17:23:05 -0400
Message-ID: <20140407212305.GE27461@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=NIkJNwyNUTdsbdPF4HhTvjgA2dUbJsbSHWm1KcYo7Zg=;
        b=dMXbNlMUFVOudOCmBFErElHTBOEfVZdi35X98VFvWCe+YVkUn+ckRVF2vRye3ZCmga
         JunM4VA/kwSHXb9qdlEIvA1p+EUP8kZ11XsDTRbxY3GuHEdbBd7FmK1uxgVYPtAEhGoL
         FMi5Zrvv4aulrQRgGF6p9hw+/Y95v6qXr18FZITXa7C64CrwnRVKgLZGXngWFQxLlb0J
         qQxcQFnZb7lvI/fatPFtfcQgrZXlKkV2pS9NRlOoUxGhNEObwY4XM0lGXluTjhSA9cp7
         DBQzb0vibyH6u6p3UlUYlV8sx/ihTayEF8UQR1T6FWPClFwhuGSYDo8n/QWI5oWW2Rnh
         DliA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello, Linus.

Two patches to fix fallouts from the kernfs conversion.  Li's patch to
stop leaking cgroup_root refs across multiple mounts and the other
fixes the 90s hang during shutdown caused by always using root's
uid/gid for new cgroup dirs and files.

The following changes since commit 4a4389abdd9822fdf3cc2ac6ed87eb811fd43acc:

  Merge branch 'linux_next' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac (2014-04-03 17:07:17 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15-fixes

for you to fetch changes up to 49957f8e2a43035a97d05bddefa394492a969c0d:

  cgroup: newly created dirs and files should be owned by the creator (2014-04-07 16:44:47 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cgroup: fix top cgroup refcnt leak

Tejun Heo (1):
      cgroup: newly created dirs and files should be owned by the creator

 kernel/cgroup.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fede3d3..9fcdaa7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1487,6 +1487,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	bool new_sb;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1603,8 +1604,8 @@ out_unlock:
 	if (ret)
 		return ERR_PTR(ret);
 
-	dentry = kernfs_mount(fs_type, flags, root->kf_root, NULL);
-	if (IS_ERR(dentry))
+	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
+	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
 	return dentry;
 }
@@ -2345,11 +2346,26 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	return ret;
 }
 
+/* set uid and gid of cgroup dirs and files to that of the creator */
+static int cgroup_kn_set_ugid(struct kernfs_node *kn)
+{
+	struct iattr iattr = { .ia_valid = ATTR_UID | ATTR_GID,
+			       .ia_uid = current_fsuid(),
+			       .ia_gid = current_fsgid(), };
+
+	if (uid_eq(iattr.ia_uid, GLOBAL_ROOT_UID) &&
+	    gid_eq(iattr.ia_gid, GLOBAL_ROOT_GID))
+		return 0;
+
+	return kernfs_setattr(kn, &iattr);
+}
+
 static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 {
 	char name[CGROUP_FILE_NAME_MAX];
 	struct kernfs_node *kn;
 	struct lock_class_key *key = NULL;
+	int ret;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	key = &cft->lockdep_key;
@@ -2357,7 +2373,13 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 	kn = __kernfs_create_file(cgrp->kn, cgroup_file_name(cgrp, cft, name),
 				  cgroup_file_mode(cft), 0, cft->kf_ops, cft,
 				  NULL, false, key);
-	return PTR_ERR_OR_ZERO(kn);
+	if (IS_ERR(kn))
+		return PTR_ERR(kn);
+
+	ret = cgroup_kn_set_ugid(kn);
+	if (ret)
+		kernfs_remove(kn);
+	return ret;
 }
 
 /**
@@ -3752,6 +3774,10 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	 */
 	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
+	err = cgroup_kn_set_ugid(kn);
+	if (err)
+		goto err_destroy;
+
 	err = cgroup_addrm_files(cgrp, cgroup_base_files, true);
 	if (err)
 		goto err_destroy;
