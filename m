From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] cgroup: fix bug on cgroup_create() fail path
Date: Thu, 5 Dec 2013 13:00:06 +0400
Message-ID: <1386234006-1633-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

If cgroup_create() fails to online_css() we will get a bug:

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

The point is that cgroup_destroy_locked() that is called on the fail
path assumes all css's have already been assigned to the cgroup, which
is not true, and calls kill_css() to destroy them.

The patch makes css_online() proceed to assigning css to a cgroup even
if subsys-specific css_online method fails - it only skips setting
CSS_ONLINE flag then. Respectively, offline_css() should skip only
subsys-specific css_offline method if CSS_ONLINE is not set. Besides, it
makes cgroup_create() call online_css() for all css's before going to
cgroup_destroy_locked(). It is not that optimal, but it's only a fail
path.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8b729c2..1846923 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4296,11 +4296,10 @@ static int online_css(struct cgroup_subsys_state *css)
 
 	if (ss->css_online)
 		ret = ss->css_online(css);
-	if (!ret) {
+	if (!ret)
 		css->flags |= CSS_ONLINE;
-		css->cgroup->nr_css++;
-		rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
-	}
+	css->cgroup->nr_css++;
+	rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
 	return ret;
 }
 
@@ -4311,10 +4310,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!(css->flags & CSS_ONLINE))
-		return;
-
-	if (ss->css_offline)
+	if ((css->flags & CSS_ONLINE) && ss->css_offline)
 		ss->css_offline(css);
 
 	css->flags &= ~CSS_ONLINE;
@@ -4437,13 +4433,20 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	/* hold a ref to the parent's dentry */
 	dget(parent->dentry);
 
+	err = 0;
+
 	/* creation succeeded, notify subsystems */
 	for_each_root_subsys(root, ss) {
 		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
+		int ret;
 
-		err = online_css(css);
-		if (err)
-			goto err_destroy;
+		/* Continue assigning css's to this cgroup on failure so that
+		 * all css's will be killed by cgroup_destroy_locked(). */
+		ret = online_css(css);
+		if (ret) {
+			err = ret;
+			continue;
+		}
 
 		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 		    parent->parent) {
@@ -4455,6 +4458,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		}
 	}
 
+	if (err)
+		goto err_destroy;
+
 	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	err = cgroup_addrm_files(cgrp, cgroup_base_files, true);
-- 
1.7.10.4
