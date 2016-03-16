From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-4.6] cgroup: ignore css_sets associated with dead cgroups
 during migration
Date: Tue, 15 Mar 2016 20:43:04 -0400
Message-ID: <20160316004304.GC3447@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wWoYxbUgx3e350tQ2MdNzxxHLxBwEJOOnE79XyHO9SQ=;
        b=ZrSRhjGhX2TaoeO4RuCtv4/E+3r/Qy5JMeT3iPiunjDlWPhpHC5DaTlrBFcVK7AEnS
         bQt8SHw33hpTNQOR8K3lxvbXIp99TCWMtFLr34b9r8c+E6eK0xMKBgFfatTXxUwe+Hnq
         /R+u/b+pgDnguqCMYXd9hxTWBX5homn1h2huzlxg4dHjLY+IzjtvWaFfRPmHDZwqX1Rr
         qh4Ib39CoHpnXhVlhv9qw8+6vYJBG0o786ZikG4oxxdEadoDjxsIpDSJA5c320IBUO66
         anGIHGA91ABnCnwf2Yi8MaOJLA2FNwj5ccJOCJ9GAkqCJFNqyYNNMlnVEtGvT66/H4ml
         3YqA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Before 2e91fa7f6d45 ("cgroup: keep zombies associated with their
original cgroups"), all dead tasks were associated with init_css_set.
If a zombie task is requested for migration, while migration prep
operations would still be performed on init_css_set, the actual
migration would ignore zombie tasks.  As init_css_set is always valid,
this worked fine.

However, after 2e91fa7f6d45, zombie tasks stay with the css_set it was
associated with at the time of death.  Let's say a task T associated
with cgroup A on hierarchy H-1 and cgroup B on hiearchy H-2.  After T
becomes a zombie, it would still remain associated with A and B.  If A
only contains zombie tasks, it can be removed.  On removal, A gets
marked offline but stays pinned until all zombies are drained.  At
this point, if migration is initiated on T to a cgroup C on hierarchy
H-2, migration path would try to prepare T's css_set for migration and
trigger the following.

 WARNING: CPU: 0 PID: 1576 at kernel/cgroup.c:474 cgroup_get+0x121/0x160()
 CPU: 0 PID: 1576 Comm: bash Not tainted 4.4.0-work+ #289
 ...
 Call Trace:
  [<ffffffff8127e63c>] dump_stack+0x4e/0x82
  [<ffffffff810445e8>] warn_slowpath_common+0x78/0xb0
  [<ffffffff810446d5>] warn_slowpath_null+0x15/0x20
  [<ffffffff810c33e1>] cgroup_get+0x121/0x160
  [<ffffffff810c349b>] link_css_set+0x7b/0x90
  [<ffffffff810c4fbc>] find_css_set+0x3bc/0x5e0
  [<ffffffff810c5269>] cgroup_migrate_prepare_dst+0x89/0x1f0
  [<ffffffff810c7547>] cgroup_attach_task+0x157/0x230
  [<ffffffff810c7a17>] __cgroup_procs_write+0x2b7/0x470
  [<ffffffff810c7bdc>] cgroup_tasks_write+0xc/0x10
  [<ffffffff810c4790>] cgroup_file_write+0x30/0x1b0
  [<ffffffff811c68fc>] kernfs_fop_write+0x13c/0x180
  [<ffffffff81151673>] __vfs_write+0x23/0xe0
  [<ffffffff81152494>] vfs_write+0xa4/0x1a0
  [<ffffffff811532d4>] SyS_write+0x44/0xa0
  [<ffffffff814af2d7>] entry_SYSCALL_64_fastpath+0x12/0x6f

It doesn't make sense to prepare migration for css_sets pointing to
dead cgroups as they are guaranteed to contain only zombies which are
ignored later during migration.  This patch makes cgroup destruction
path mark all affected css_sets as dead and updates the migration path
to ignore them during preparation.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 2e91fa7f6d45 ("cgroup: keep zombies associated with their original cgroups")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.4+
---
 include/linux/cgroup-defs.h |    3 +++
 kernel/cgroup.c             |   20 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -212,6 +212,9 @@ struct css_set {
 	/* all css_task_iters currently walking this cset */
 	struct list_head task_iters;
 
+	/* dead and being drained, ignore for migration */
+	bool dead;
+
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
 };
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2516,6 +2516,14 @@ static void cgroup_migrate_add_src(struc
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_lock);
 
+	/*
+	 * If ->dead, @src_set is associated with one or more dead cgroups
+	 * and doesn't contain any migratable tasks.  Ignore it early so
+	 * that the rest of migration path doesn't get confused by it.
+	 */
+	if (src_cset->dead)
+		return;
+
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
 	if (!list_empty(&src_cset->mg_preload_node))
@@ -5258,6 +5266,7 @@ static int cgroup_destroy_locked(struct
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct cgroup_subsys_state *css;
+	struct cgrp_cset_link *link;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -5278,11 +5287,18 @@ static int cgroup_destroy_locked(struct
 		return -EBUSY;
 
 	/*
-	 * Mark @cgrp dead.  This prevents further task migration and child
-	 * creation by disabling cgroup_lock_live_group().
+	 * Mark @cgrp and the associated csets dead.  The former prevents
+	 * further task migration and child creation by disabling
+	 * cgroup_lock_live_group().  The latter makes the csets ignored by
+	 * the migration path.
 	 */
 	cgrp->self.flags &= ~CSS_ONLINE;
 
+	spin_lock_bh(&css_set_lock);
+	list_for_each_entry(link, &cgrp->cset_links, cset_link)
+		link->cset->dead = true;
+	spin_unlock_bh(&css_set_lock);
+
 	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
