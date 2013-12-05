From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
Date: Thu, 5 Dec 2013 16:18:14 -0500
Message-ID: <20131205211814.GA29598@mtj.dyndns.org>
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5IoJNxORN5tKVOBATTeVfcQWHejqm8HqbiS59DGecNA=;
        b=pOKEemqLIC3Q340NvVmPO6UQHrDgh4sf0jrlpT622m3nrPdrjah7tiNzqoRbVHBonP
         J28lyQfl5KwglU186zUAR+s08kKpQhjYtEa1hbycyscYlfEMeJZFiZwAyaOjpLnDu9K9
         9zk74noQYcsfLKDdKw3PPTMiYH0OsW608lLpAxOLx2UEbFONV++WmmFzC+vc0zZzg4QO
         Df+wvYCfsOp/Z1v450WPnjR9Qp1KIhuCzRcK9ns/Xyb8zYjo8k0L30XmermBQ3VYmUHF
         rQmcXYVusVNOf4rPtOJkWRVQx+iwa3/KAkfEpKuLzFZKxWWEj6ysfBOUTdQufoq3QWdy
         +xYg==
Content-Disposition: inline
In-Reply-To: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>, Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org

Hello, Vladimir.

Thanks a lot for the report and fix; however, I really wanna make sure
that only online css's become visible, so I wrote up a different fix.
Can you please test this one?

Thanks a lot!

------ 8< ------
ae7f164a0940 ("cgroup: move cgroup->subsys[] assignment to
online_css()") moved cgrp->subsys[] assignment from allocation to
online_css().  This was done to decouple the lifetime of css
(cgroup_subsys_states) from that of the associated cgroup - ie. css
should only become visible only after it's fully online.
Unfortunately, the commit failed to update init failure path
accordingly.

If one of the css fails onlining, cgroup destruction path is invoked
on the partially constructed cgroup; however, the function is not
ready to handle empty slots in cgrp->subsys[] array and triggers the
following oops.

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  IP: [<ffffffff810eeaa8>] cgroup_destroy_locked+0x118/0x2f0
  PGD a780a067 PUD aadbe067 PMD 0
  Oops: 0000 [#1] SMP
  Modules linked in:
  CPU: 6 PID: 7360 Comm: mkdir Not tainted 3.13.0-rc2+ #69
  Hardware name:
  task: ffff8800b9dbec00 ti: ffff8800a781a000 task.ti: ffff8800a781a000
  RIP: 0010:[<ffffffff810eeaa8>]  [<ffffffff810eeaa8>] cgroup_destroy_locked+0x118/0x2f0
  RSP: 0018:ffff8800a781bd98  EFLAGS: 00010282
  RAX: ffff880586903878 RBX: ffff880586903800 RCX: ffff880586903820
  RDX: ffff880586903860 RSI: ffff8800a781bdb0 RDI: ffff880586903820
  RBP: ffff8800a781bde8 R08: ffff88060e0b8048 R09: ffffffff811d7bc1
  R10: 000000000000008c R11: 0000000000000001 R12: ffff8800a72286c0
  R13: 0000000000000000 R14: ffffffff81cf7a40 R15: 0000000000000001
  FS:  00007f60ecda57a0(0000) GS:ffff8806272c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000008 CR3: 00000000a7a03000 CR4: 00000000000007e0
  Stack:
   ffff880586903860 ffff880586903910 ffff8800a72286c0 ffff880586903820
   ffffffff81cf7a40 ffff880586903800 ffff88060e0b8018 ffffffff81cf7a40
   ffff8800b9dbec00 ffff8800b9dbf098 ffff8800a781bec8 ffffffff810ef5bf
  Call Trace:
   [<ffffffff810ef5bf>] cgroup_mkdir+0x55f/0x5f0
   [<ffffffff811c90ae>] vfs_mkdir+0xee/0x140
   [<ffffffff811cb07e>] SyS_mkdirat+0x6e/0xf0
   [<ffffffff811c6a19>] SyS_mkdir+0x19/0x20
   [<ffffffff8169e569>] system_call_fastpath+0x16/0x1b

Fix it by updating cgroup_destroy_locked() skip over empty
cgrp->subsys[] entries and making cgroup_create() free css's which
didn't get onlined in the failure path.  This moves css_free
invocation in the failure path outside cgroup_mutex but the function
is supposed to not care about it and already being called outside
cgroup_mutex in the normal destruction path.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: stable@vger.kernel.org # v3.12+
---
 kernel/cgroup.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4399,13 +4399,13 @@ static long cgroup_create(struct cgroup
 		css = ss->css_alloc(cgroup_css(parent, ss));
 		if (IS_ERR(css)) {
 			err = PTR_ERR(css);
-			goto err_free_all;
+			goto err_deactivate;
 		}
 		css_ar[ss->subsys_id] = css;
 
 		err = percpu_ref_init(&css->refcnt, css_release);
 		if (err)
-			goto err_free_all;
+			goto err_deactivate;
 
 		init_css(css, ss, cgrp);
 	}
@@ -4417,7 +4417,7 @@ static long cgroup_create(struct cgroup
 	 */
 	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
-		goto err_free_all;
+		goto err_deactivate;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	cgrp->serial_nr = cgroup_serial_nr_next++;
@@ -4445,6 +4445,9 @@ static long cgroup_create(struct cgroup
 		if (err)
 			goto err_destroy;
 
+		/* @css successfully attached, now owned by @cgrp */
+		css_ar[ss->subsys_id] = NULL;
+
 		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 		    parent->parent) {
 			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
@@ -4470,15 +4473,7 @@ static long cgroup_create(struct cgroup
 
 	return 0;
 
-err_free_all:
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
-
-		if (css) {
-			percpu_ref_cancel_init(&css->refcnt);
-			ss->css_free(css);
-		}
-	}
+err_deactivate:
 	mutex_unlock(&cgroup_mutex);
 	/* Release the reference count that we took on the superblock */
 	deactivate_super(sb);
@@ -4488,12 +4483,21 @@ err_free_name:
 	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
 	kfree(cgrp);
-	return err;
+	goto out_free_css_ar;
 
 err_destroy:
 	cgroup_destroy_locked(cgrp);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&dentry->d_inode->i_mutex);
+out_free_css_ar:
+	for_each_root_subsys(root, ss) {
+		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
+
+		if (css) {
+			percpu_ref_cancel_init(&css->refcnt);
+			ss->css_free(css);
+		}
+	}
 	return err;
 }
 
@@ -4650,10 +4654,14 @@ static int cgroup_destroy_locked(struct
 	/*
 	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
 	 * will be invoked to perform the rest of destruction once the
-	 * percpu refs of all css's are confirmed to be killed.
+	 * percpu refs of all css's are confirmed to be killed.  Not all
+	 * css's may be present if @cgrp failed init half-way.
 	 */
-	for_each_root_subsys(cgrp->root, ss)
-		kill_css(cgroup_css(cgrp, ss));
+	for_each_root_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
+		if (css)
+			kill_css(cgroup_css(cgrp, ss));
+	}
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
