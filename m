From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Wed, 10 Apr 2013 10:50:35 -0700
Message-ID: <20130410175035.GA17641@mtj.dyndns.org>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=703tGcw+6Y2Kp5SfxQNdYtbXpg/nNfGVncmcf6Zrdp8=;
        b=aTuub7hlljlWMHOzSBh8Ywk9S155/8lecgl9X/G60gVKxrYSQ+i8tzVo6+ppzuhdEk
         BdxoK9IIp+BunVEhadkaKwCSTYST1C20xYWRHwf2sPBIHStT4Jv37pJtpSlyHP/u0i5O
         yeai3TSJ6/ZRl4UyQ1YoFKoM+0E74e6f+JfUSdzuNKGb3N07uCGP6tzKWhKMqKV7T6lj
         m+yWBlUa/iEVNeQfKzyEmsfTsWwRSqBaxuwXHC5tUNywK5E1CwpO+s73ojC4DY/Wl/Ky
         u47vGPTLrZLC9aS+6pZK2kxIkv8yuh1YD5oneQ950UpoPTRbAKNky/JhpeLYnAeagQg5
         LUvA==
Content-Disposition: inline
In-Reply-To: <1365594077-17655-1-git-send-email-ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From 84cfb6ab484b442d5115eb3baf9db7d74a3ea626 Mon Sep 17 00:00:00 2001
From: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 10 Apr 2013 14:41:17 +0300

The bind() method of cgroup_subsys is not used in any of the
controllers (cpuset, freezer, blkio, net_cls, memcg, net_prio,
devices, perf, hugetlb, cpu and cpuacct)

tj: Removed the entry on ->bind() from
    Documentation/cgroups/cgroups.txt.  Also updated a couple
    paragraphs which were suggesting that dynamic re-binding may be
    implemented.  It's not gonna.

Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-3.10 with documentation updated.

Thanks!

 Documentation/cgroups/cgroups.txt | 20 +++++---------------
 include/linux/cgroup.h            |  2 --
 kernel/cgroup.c                   |  4 ----
 3 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 638bf17..2b51e12 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -211,10 +211,9 @@ matches, and any of the requested subsystems are in use in an existing
 hierarchy, the mount will fail with -EBUSY. Otherwise, a new hierarchy
 is activated, associated with the requested subsystems.
 
-It's not currently possible to bind a new subsystem to an active
-cgroup hierarchy, or to unbind a subsystem from an active cgroup
-hierarchy. This may be possible in future, but is fraught with nasty
-error-recovery issues.
+It's not possible to bind a new subsystem to an active cgroup
+hierarchy, or to unbind a subsystem from an active cgroup
+hierarchy.
 
 When a cgroup filesystem is unmounted, if there are any
 child cgroups created below the top-level cgroup, that hierarchy
@@ -382,10 +381,8 @@ To Specify a hierarchy's release_agent:
 
 Note that specifying 'release_agent' more than once will return failure.
 
-Note that changing the set of subsystems is currently only supported
-when the hierarchy consists of a single (root) cgroup. Supporting
-the ability to arbitrarily bind/unbind subsystems from an existing
-cgroup hierarchy is intended to be implemented in the future.
+Note that changing the set of subsystems is only supported when the
+hierarchy consists of a single (root) cgroup.
 
 Then under /sys/fs/cgroup/rg1 you can find a tree that corresponds to the
 tree of the cgroups in the system. For instance, /sys/fs/cgroup/rg1
@@ -643,13 +640,6 @@ void exit(struct task_struct *task)
 
 Called during task exit.
 
-void bind(struct cgroup *root)
-(cgroup_mutex held by caller)
-
-Called when a cgroup subsystem is rebound to a different hierarchy
-and root cgroup. Currently this will only involve movement between
-the default hierarchy (which never has sub-cgroups) and a hierarchy
-that is being created/destroyed (and hence has no sub-cgroups).
 
 4. Extended attribute usage
 ===========================
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 515927e..92acf86 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -483,8 +483,6 @@ struct cgroup_subsys {
 	void (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 		     struct task_struct *task);
-	void (*bind)(struct cgroup *root);
-
 	int subsys_id;
 	int active;
 	int disabled;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ba3e24a..fd38e1c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1064,16 +1064,12 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
-			if (ss->bind)
-				ss->bind(cgrp);
 			/* refcount was already taken, and we're keeping it */
 		} else if (bit & removed_mask) {
 			/* We're removing this subsystem */
 			BUG_ON(ss == NULL);
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
-			if (ss->bind)
-				ss->bind(dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			subsys[i]->root = &rootnode;
-- 
1.8.1.4
