From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Tue, 3 Jul 2012 15:52:18 -0700
Message-ID: <20120703225218.GF555@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oW6U15vAIwMvYL+qx2KqP9FzDkSCHvZLjqWkEITmY2Q=;
        b=kYFgquRrYX7AADAaPinp3yjTuvJEjmPq10ScDewjyrNOMuVYkLGoe9JWaTF1zq+mBk
         VkIGhxs7mkLfrmFY72SrtvdOPM1bNE15stv805ZpeX8pje48QSzPYz34kY41zTxPYLJf
         dJe6DYLSK1qhFV9R19pS3APYtuSJJWbVAL084QrU615NTcAV0G77Mp6MM2rcwe4LKQtq
         oVe45nDekDIKUJ20GeZG1Oz3wAG5aWP/Up5NFTynIknhAxI1C9N3PGOUgxlCX1l8Xhlr
         cHtrPj+KK/Mbm9ZcktqwalRJn76VVLYpkcMqIscOAJ3M7Z/sV2qAH4JgSYZcv32jFwHI
         2uCQ==
Content-Disposition: inline
In-Reply-To: <20120703170317.GB555-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

Shyju, can you please test the following patch?

Sasha, can you please re-test your test case with this patch?  I don't
think fa980ca87d "cgroup: superblock can't be released with active
dentries" did anything useful.  cgroup always calls d_iput() and
d_release() in succession from the same context.  It may just have
stretched the timing a bit to hide the race.

Li, this patch reverts fa980ca87d and wraps dput() in css_dput_fn()
with s_active refs.  Positive dentry ref means that we have active ref
on sb, so wrapping the final dput() with extra s_active ref should
avoid premature super destruction.  I think we're horridly broken for
root cgroup tho - and it has been broken for very long time.  I think
it's mostly hidden because most (all?) controllers short-circuit root
cgroup.  Eh, well....

Thanks.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b214fc2..15462a0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -901,13 +901,10 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		mutex_unlock(&cgroup_mutex);
 
 		/*
-		 * We want to drop the active superblock reference from the
-		 * cgroup creation after all the dentry refs are gone -
-		 * kill_sb gets mighty unhappy otherwise.  Mark
-		 * dentry->d_fsdata with cgroup_diput() to tell
-		 * cgroup_d_release() to call deactivate_super().
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
 		 */
-		dentry->d_fsdata = cgroup_diput;
+		deactivate_super(cgrp->root->sb);
 
 		/*
 		 * if we're getting rid of the cgroup, refcount should ensure
@@ -933,13 +930,6 @@ static int cgroup_delete(const struct dentry *d)
 	return 1;
 }
 
-static void cgroup_d_release(struct dentry *dentry)
-{
-	/* did cgroup_diput() tell me to deactivate super? */
-	if (dentry->d_fsdata == cgroup_diput)
-		deactivate_super(dentry->d_sb);
-}
-
 static void remove_dir(struct dentry *d)
 {
 	struct dentry *parent = dget(d->d_parent);
@@ -1547,7 +1537,6 @@ static int cgroup_get_rootdir(struct super_block *sb)
 	static const struct dentry_operations cgroup_dops = {
 		.d_iput = cgroup_diput,
 		.d_delete = cgroup_delete,
-		.d_release = cgroup_d_release,
 	};
 
 	struct inode *inode =
@@ -3894,8 +3883,12 @@ static void css_dput_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
+	struct dentry *dentry = css->cgroup->dentry;
+	struct super_block *sb = dentry->d_sb;
 
-	dput(css->cgroup->dentry);
+	atomic_inc(&sb->s_active);
+	dput(dentry);
+	deactivate_super(sb);
 }
 
 static void init_cgroup_css(struct cgroup_subsys_state *css,
