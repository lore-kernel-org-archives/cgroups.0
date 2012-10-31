From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
Date: Tue, 30 Oct 2012 21:22:40 -0700
Message-ID: <1351657365-25055-4-git-send-email-tj@kernel.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=y2fVm+7ZCB5+T7oTns7izw8/Um2WAyVdJNWfFe8EpLc=;
        b=Zq3AWA53PcmXgvAyfJOd+2c6A40J4/V7+CxEQIQ73jT/YoLpElWOTlOHTwe1JicfAk
         vrAEx8kVxksz9vhd21rNwItl1fB2Kzs4ty15h4FKYUjJAPxnbgzd9g1P1LoJs3rsuodw
         x6O+0kpyWFRk7/55c6gFytvMW0ceU+g/TjFd0OEIk5oTe6X+V4mHgLo4hcekyU096/jc
         pAMGLfXmohZxTynx1gbY7BA4xhxaY0RrEKbP9yDCzrb9Nkr4EJ2aBCxObvwa37jZPTEc
         tFnpB5LYPwpQ3IFaXGG9pin3HrWMjIOSCFOnYsPSsaQWN75GGp8MMSMySZJcMXtB024x
         Ckdw==
In-Reply-To: <1351657365-25055-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This patch makes cgroup_create() fail if @parent is marked removed.
This is to prepare for further updates to cgroup_rmdir() path.

Note that this change isn't strictly necessary.  cgroup can only be
created via mkdir and the removed marking and dentry removal happen
without releasing cgroup_mutex, so cgroup_create() can never race with
cgroup_rmdir().  Even after the scheduled updates to cgroup_rmdir(),
cgroup_mkdir() and cgroup_rmdir() are synchronized by i_mutex
rendering the added liveliness check unnecessary.

Do it anyway such that locking is contained inside cgroup proper and
we don't get nasty surprises if we ever grow another caller of
cgroup_create().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a49cdbc..b3010ae 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3906,6 +3906,18 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (!cgrp)
 		return -ENOMEM;
 
+	/*
+	 * Only live parents can have children.  Note that the liveliness
+	 * check isn't strictly necessary because cgroup_mkdir() and
+	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
+	 * anyway so that locking is contained inside cgroup proper and we
+	 * don't get nasty surprises if we ever grow another caller.
+	 */
+	if (!cgroup_lock_live_group(parent)) {
+		err = -ENODEV;
+		goto err_free;
+	}
+
 	/* Grab a reference on the superblock so the hierarchy doesn't
 	 * get deleted on unmount if there are child cgroups.  This
 	 * can be done outside cgroup_mutex, since the sb can't
@@ -3913,8 +3925,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 * fs */
 	atomic_inc(&sb->s_active);
 
-	mutex_lock(&cgroup_mutex);
-
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
@@ -3985,7 +3995,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
-
+err_free:
 	kfree(cgrp);
 	return err;
 }
-- 
1.7.11.7
