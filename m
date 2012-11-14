From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 04/17] cgroup: create directory before linking while
 creating a new cgroup
Date: Wed, 14 Nov 2012 11:48:35 -0800
Message-ID: <20121114194835.GJ21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bsDuiSrcV4XJLdrGt3GOBdPGOkv1ZoLoqfbBG0p0ZUg=;
        b=W0pKAHR4A2/6NbiYDT4fw+8itwEPPK/Per6SBSQlM6nbWBcaOFfBWOGzNKNjmCpoSC
         Ze90ETRu2qm0LttF9uRQgm9X9cmiGgmjWeb8rIlvanlDKtv4NbgKbLv0IJxUTR2AT6ta
         3Ty15S7/sp86uUTxUCQWGDxR5tVYfg6RbouDR11sz/2wK/hCiLZVVk2tLDN+J2YbjsSj
         v2P91fUkWkCywx6XwD5cVzh2Xuza0G0nrrTuw9O6Bxz/If7xfZNB3dv4qFmYYTvtoQth
         v9hmFCur+wjkUIyiH+zY+EWtIfT+N/TO7ukvvkCjsscruskxNdBhtVGPy8R1ewsw/ghH
         lYdQ==
Content-Disposition: inline
In-Reply-To: <1352775704-9023-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org

While creating a new cgroup, cgroup_create() links the newly allocated
cgroup into various places before trying to create its directory.
Because cgroup life-cycle is tied to the vfs objects, this makes it
impossible to use cgroup_rmdir() for rolling back creation - the
removal logic depends on having full vfs objects.

This patch moves directory creation above linking and collect linking
operations to one place.  This allows directory creation failure to
share error exit path with css allocation failures and any failure
sites afterwards (to be added later) can use cgroup_rmdir() logic to
undo creation.

Note that this also makes the memory barriers around cgroup->dentry,
which currently is misleadingly using RCU operations, unnecessary.
This will be handled in the next patch.

While at it, locking BUG_ON() on i_mutex is converted to
lockdep_assert_held().

v2: Patch originally removed %NULL dentry check in cgroup_path();
    however, Li pointed out that this patch doesn't make it
    unnecessary as ->create() may call cgroup_path().  Drop the
    change for now.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4112,15 +4112,22 @@ static long cgroup_create(struct cgroup
 		}
 	}
 
-	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
-	root->number_of_cgroups++;
-
+	/*
+	 * Create directory.  cgroup_create_file() returns with the new
+	 * directory locked on success so that it can be populated without
+	 * dropping cgroup_mutex.
+	 */
 	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
-		goto err_remove;
+		goto err_destroy;
+	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
+	/* allocation complete, commit to creation */
 	dentry->d_fsdata = cgrp;
 	rcu_assign_pointer(cgrp->dentry, dentry);
+	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
+	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
+	root->number_of_cgroups++;
 
 	for_each_subsys(root, ss) {
 		/* each css holds a ref to the cgroup's dentry */
@@ -4131,11 +4138,6 @@ static long cgroup_create(struct cgroup
 			ss->post_create(cgrp);
 	}
 
-	/* The cgroup directory was pre-locked for us */
-	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
-
-	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-
 	err = cgroup_populate_dir(cgrp, true, root->subsys_mask);
 	/* If err < 0, we have a half-filled directory - oh well ;) */
 
@@ -4144,20 +4146,12 @@ static long cgroup_create(struct cgroup
 
 	return 0;
 
- err_remove:
-
-	list_del_rcu(&cgrp->sibling);
-	root->number_of_cgroups--;
-
- err_destroy:
-
+err_destroy:
 	for_each_subsys(root, ss) {
 		if (cgrp->subsys[ss->subsys_id])
 			ss->destroy(cgrp);
 	}
-
 	mutex_unlock(&cgroup_mutex);
-
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
 err_free:
