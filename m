From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] cgroup: restructure cgroup_procs_write_permission()
Date: Sun, 25 Jun 2017 00:27:59 -0400
Message-ID: <20170625042759.GA9644@htj.duckdns.org>
References: <20170625042717.GA14158@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OUTuzRgKnzmDI+PVdahfrUJV3CrDv64gTF5m8vQG7ww=;
        b=mB1pPZQHezBV0272M6j+DYqeI5dLhtNco9+PgXxTnEtW4TGrwk8I/2hOAp/JKDD3tB
         iL4oHyJXhrnfgUE3JHeWK2k06hcDtqjbU8HsUMxuNX71xhzJg1VqSAh4BfKz8AQpbcoC
         kE/XfWatVS2xdfhR7nLeXR2ghjIhYQ5YJ5njX0o/bR4Pe7d4SgzomzTqmmFpNcttz+7X
         yKhOb6mSB5ia0GyJL/L1jcXP3ppeQWI6p7HBJpm+MZjb5tfmGEspPm0KL/RcjFWD7o4/
         Yb3+GbnTM+uggewMZp1eHnN4TqNxSS3WtKiCTKLeeYrBI26qx/OtHm4/LIqaMDdFe/pM
         C8LQ==
Content-Disposition: inline
In-Reply-To: <20170625042717.GA14158-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aravind Anbudurai <aru7-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Restructure cgroup_procs_write_permission() to make extending
permission logic easier.

This patch doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c |   57 ++++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2363,27 +2363,12 @@ static int cgroup_procs_write_permission
 					 struct cgroup *dst_cgrp,
 					 struct kernfs_open_file *of)
 {
-	int ret = 0;
+	struct super_block *sb = of->file->f_path.dentry->d_sb;
+	struct cgroup *src_cgrp, *com_cgrp;
+	struct inode *inode;
+	int ret;
 
-	if (cgroup_on_dfl(dst_cgrp)) {
-		struct super_block *sb = of->file->f_path.dentry->d_sb;
-		struct cgroup *cgrp;
-		struct inode *inode;
-
-		spin_lock_irq(&css_set_lock);
-		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
-		spin_unlock_irq(&css_set_lock);
-
-		while (!cgroup_is_descendant(dst_cgrp, cgrp))
-			cgrp = cgroup_parent(cgrp);
-
-		ret = -ENOMEM;
-		inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
-		if (inode) {
-			ret = inode_permission(inode, MAY_WRITE);
-			iput(inode);
-		}
-	} else {
+	if (!cgroup_on_dfl(dst_cgrp)) {
 		const struct cred *cred = current_cred();
 		const struct cred *tcred = get_task_cred(task);
 
@@ -2391,14 +2376,38 @@ static int cgroup_procs_write_permission
 		 * even if we're attaching all tasks in the thread group,
 		 * we only need to check permissions on one of them.
 		 */
-		if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
-		    !uid_eq(cred->euid, tcred->uid) &&
-		    !uid_eq(cred->euid, tcred->suid))
+		if (uid_eq(cred->euid, GLOBAL_ROOT_UID) ||
+		    uid_eq(cred->euid, tcred->uid) ||
+		    uid_eq(cred->euid, tcred->suid))
+			ret = 0;
+		else
 			ret = -EACCES;
+
 		put_cred(tcred);
+		return ret;
 	}
 
-	return ret;
+	/* find the source cgroup */
+	spin_lock_irq(&css_set_lock);
+	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	spin_unlock_irq(&css_set_lock);
+
+	/* and the common ancestor */
+	com_cgrp = src_cgrp;
+	while (!cgroup_is_descendant(dst_cgrp, com_cgrp))
+		com_cgrp = cgroup_parent(com_cgrp);
+
+	/* %current should be authorized to migrate to the common ancestor */
+	inode = kernfs_get_inode(sb, com_cgrp->procs_file.kn);
+	if (!inode)
+		return -ENOMEM;
+
+	ret = inode_permission(inode, MAY_WRITE);
+	iput(inode);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 /*
