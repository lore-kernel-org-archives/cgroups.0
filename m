From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/5] cgroup: make __cgroup_from_dentry() and
 __cgroup_dput() global
Date: Mon, 5 Aug 2013 13:08:34 -0400
Message-ID: <20130805170834.GA23751@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Bzuaaa3ZUk1/+GRrTcnreybV+s+GtxW5v/1vjUe4DDU=;
        b=aBDN0ZBv+bkXwVop6Y04p1I38kJx3F7j97Qk4Ud1zXZcboYJRXOiSyStcuA7oyp39t
         iJSDs+Jx6/9ed4oPB06TT3gc65pwzkZ5W8yqFu6MhjloW+lXgT66akc+Vfeb+lUqQpEu
         0efBunplQdLyjv+lZyO0P99GdullGb+WxCjxcRNU0LU8OqSQjCifVfeUkcQ2mjV/ha1L
         LTxrqzqcGtzzCbq0hVIEYmbzD4C53mY5MSYexEoyGhJdnd1POBE8N8pc85CkVKitW4KA
         raqmBb6Ew1RhUFvVc2CzN8VGbc/7QP2EGX/kEVxAsAMB+phFxih3oeIz5wAvpaAOe3lV
         LIdw==
Content-Disposition: inline
In-Reply-To: <1375632446-2581-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From eb06a03636eb8477ea034780c37463a086112115 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 5 Aug 2013 12:00:23 -0400

cgroup_event will no longer be supported as cgroup generic mechanism
and be moved to memcg.  To enable the relocation, implement and expose
__cgroup_from_dentry() which combines cgroup file dentry -> croup
mapping and cft discovery, and prefix cgroup_dput() with __ and make
it global.

These functions exist and are exported only to enable moving
cgroup_event implementation to memcg and shouldn't grow any new users
and thus the __ prefix.

This patch is pure reorganization and doesn't introduce any functional
difference.

v2: The original patch had EXPORT_SYMBOL_GPL() for the two functions
    because I for some reason thought that memcg could be built as
    module.  Removed as suggested by Li Zefan.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |  4 ++++
 kernel/cgroup.c        | 29 +++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 30d6ec4..2ac1021 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -923,6 +923,10 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
+/* do not add new users of the following two functions */
+struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp);
+void __cgroup_dput(struct cgroup *cgrp);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1b87e2b..568d031 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2661,14 +2661,16 @@ static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, un
 	return NULL;
 }
 
-/*
- * Check if a file is a control file
- */
-static inline struct cftype *__file_cft(struct file *file)
+/* do not add new users */
+struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp)
 {
-	if (file_inode(file)->i_fop != &cgroup_file_operations)
-		return ERR_PTR(-EINVAL);
-	return __d_cft(file->f_dentry);
+	if (!dentry->d_inode ||
+	    dentry->d_inode->i_op != &cgroup_file_inode_operations)
+		return NULL;
+
+	if (cftp)
+		*cftp = __d_cft(dentry);
+	return __d_cgrp(dentry->d_parent);
 }
 
 static int cgroup_create_file(struct dentry *dentry, umode_t mode,
@@ -3953,7 +3955,7 @@ static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
  *
  * That's why we hold a reference before dput() and drop it right after.
  */
-static void cgroup_dput(struct cgroup *cgrp)
+void __cgroup_dput(struct cgroup *cgrp)
 {
 	struct super_block *sb = cgrp->root->sb;
 
@@ -3983,7 +3985,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	cgroup_dput(cgrp);
+	__cgroup_dput(cgrp);
 }
 
 /*
@@ -4095,9 +4097,9 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	if (ret < 0)
 		goto out_put_cfile;
 
-	event->cft = __file_cft(cfile);
-	if (IS_ERR(event->cft)) {
-		ret = PTR_ERR(event->cft);
+	cgrp_cfile = __cgroup_from_dentry(cfile->f_dentry, &event->cft);
+	if (!cgrp_cfile) {
+		ret = -EINVAL;
 		goto out_put_cfile;
 	}
 
@@ -4105,7 +4107,6 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	 * The file to be monitored must be in the same cgroup as
 	 * cgroup.event_control is.
 	 */
-	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
 	if (cgrp_cfile != cgrp) {
 		ret = -EINVAL;
 		goto out_put_cfile;
@@ -4272,7 +4273,7 @@ static void css_dput_fn(struct work_struct *work)
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
 
-	cgroup_dput(css->cgroup);
+	__cgroup_dput(css->cgroup);
 }
 
 static void css_release(struct percpu_ref *ref)
-- 
1.8.3.1
