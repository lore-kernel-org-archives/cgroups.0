From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11] cgroup: fix cgroupfs_root early destruction
 path
Date: Tue, 25 Jun 2013 18:04:54 -0700
Message-ID: <20130626010454.GD30407@mtj.dyndns.org>
References: <51C9D17B.5090208@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=E7lN+xfDEdLGaPhj+Ob06p2x+inbmKJ7SuAQ95SVKbo=;
        b=wHZ/xUUQQ4JzeXvEMsH1PHWsCyVAOO05iA6G/s18ZLdXp0pKnLJHGt+YLJO+qsOIW5
         nGjV4iMOkvINguBhWT864f/GDQutKQLNa9wxqKe6b11Bc4ghxY5GRVm29aEFq2gvN7OR
         K/IxIl46H9eWoF2OWPAlZcmil1V9IQ6GNwbTkxlcFbgc7Gl4wboep15N8YsVJ9tI/kxl
         sbxJHDVFAeudpdZCuITQ5sjVZ4By2ge1Wf2Odnr4M7taEMY5F8uBA00Np1VUOhU6ssgc
         oG1ndPdEe6h1dpR5RN/0AK9NtYCUvYFQ1UeGz4QsnMlcl7fs/pVzdUlO7DR4vykQ0VMR
         jYCQ==
Content-Disposition: inline
In-Reply-To: <51C9D17B.5090208-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trinity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroupfs_root used to have ->actual_subsys_mask in addition to
->subsys_mask.  a8a648c4ac ("cgroup: remove
cgroup->actual_subsys_mask") removed it noting that the subsys_mask is
essentially temporary and doesn't belong in cgroupfs_root; however,
the patch made it impossible to tell whether a cgroupfs_root actually
has the subsystems bound or just have the bits set leading to the
following BUG when trying to mount with subsystems which are already
mounted elsewhere.

 kernel BUG at kernel/cgroup.c:1038!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 ...
 CPU: 1 PID: 7973 Comm: mount Tainted: G        W    3.10.0-rc7-next-20130625-sasha-00011-g1c1dc0e #1105
 task: ffff880fc0ae8000 ti: ffff880fc0b9a000 task.ti: ffff880fc0b9a000
 RIP: 0010:[<ffffffff81249b29>]  [<ffffffff81249b29>] rebind_subsystems+0x409/0x5f0
 ...
 Call Trace:
  [<ffffffff8124bd4f>] cgroup_kill_sb+0xff/0x210
  [<ffffffff813d21af>] deactivate_locked_super+0x4f/0x90
  [<ffffffff8124f3b3>] cgroup_mount+0x673/0x6e0
  [<ffffffff81257169>] cpuset_mount+0xd9/0x110
  [<ffffffff813d2580>] mount_fs+0xb0/0x2d0
  [<ffffffff81404afd>] vfs_kern_mount+0xbd/0x180
  [<ffffffff814070b5>] do_new_mount+0x145/0x2c0
  [<ffffffff814085d6>] do_mount+0x356/0x3c0
  [<ffffffff8140873d>] SyS_mount+0xfd/0x140
  [<ffffffff854eb600>] tracesys+0xdd/0xe2

We still want rebind_subsystems() to take added/removed masks, so
let's fix it by marking whether a cgroupfs_root has finished binding
or not.  Also, document what's going on around ->subsys_mask
initialization so that similar mistakes aren't repeated.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -276,6 +276,7 @@ enum {
 
 	CGRP_ROOT_NOPREFIX	= (1 << 1), /* mounted subsystems have no named prefix */
 	CGRP_ROOT_XATTR		= (1 << 2), /* supports extended attributes */
+	CGRP_ROOT_SUBSYS_BOUND	= (1 << 3), /* subsystems finished binding */
 };
 
 /*
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1086,6 +1086,12 @@ static int rebind_subsystems(struct cgro
 		}
 	}
 
+	/*
+	 * Mark @root has finished binding subsystems.  @root->subsys_mask
+	 * now matches the bound subsystems.
+	 */
+	root->flags |= CGRP_ROOT_SUBSYS_BOUND;
+
 	return 0;
 }
 
@@ -1485,6 +1491,14 @@ static struct cgroupfs_root *cgroup_root
 
 	init_cgroup_root(root);
 
+	/*
+	 * We need to set @root->subsys_mask now so that @root can be
+	 * matched by cgroup_test_super() before it finishes
+	 * initialization; otherwise, competing mounts with the same
+	 * options may try to bind the same subsystems instead of waiting
+	 * for the first one leading to unexpected mount errors.
+	 * SUBSYS_BOUND will be set once actual binding is complete.
+	 */
 	root->subsys_mask = opts->subsys_mask;
 	root->flags = opts->flags;
 	ida_init(&root->cgroup_ida);
@@ -1734,9 +1748,11 @@ static void cgroup_kill_sb(struct super_
 	mutex_lock(&cgroup_root_mutex);
 
 	/* Rebind all subsystems back to the default hierarchy */
-	ret = rebind_subsystems(root, 0, root->subsys_mask);
-	/* Shouldn't be able to fail ... */
-	BUG_ON(ret);
+	if (root->flags & CGRP_ROOT_SUBSYS_BOUND) {
+		ret = rebind_subsystems(root, 0, root->subsys_mask);
+		/* Shouldn't be able to fail ... */
+		BUG_ON(ret);
+	}
 
 	/*
 	 * Release all the links from cset_links to this hierarchy's
