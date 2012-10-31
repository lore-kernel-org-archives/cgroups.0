From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in cgroup_create()
Date: Wed, 31 Oct 2012 11:16:26 -0700
Message-ID: <1351707391-22287-4-git-send-email-tj@kernel.org>
References: <1351707391-22287-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=y2fVm+7ZCB5+T7oTns7izw8/Um2WAyVdJNWfFe8EpLc=;
        b=tC20WPY90a54cv2bIRpDIMKaPEHJNywnFPHpUOMcJNmM6wVOLLehB4nccz9BkEonp7
         yw4FMS6GJDUjuBL6fV6wZzamQ4VA0txS34r2kghSHeHfDrcievSxSDtkQL959mnzLLR9
         oLXlNUAbFm8X4h1VGoPDxvPm3o+JlpwVPsDpnYwGKeOkaS4vzlpf4fi/64v3eEWqmbbQ
         02BIL0FO3dtfLd0BtWxsFlNTBXGhaUipu1dGtOR3a1H1YsvIcbtUM9VNiJUXgnSpKul6
         sRTtIwQ0+4AxNzB7+gacJQIfbFzTS9bd1zILFM8ofeJDyzhY6P0YVHNAK6f8p8lgJMae
         CGSA==
In-Reply-To: <1351707391-22287-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

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

Signed-off-by: Tejun Heo <tj@kernel.org>
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
