From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] cgroup: Fix trailing */ in block comments.
Date: Tue, 15 Dec 2015 13:20:42 +0100
Message-ID: <1450182045-27480-3-git-send-email-kuba.kunert@gmail.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4fjpbT4eDFbQDr/PNtNXcIOPTbB9/9ZeWuOZjP4f2FE=;
        b=HjLxXwTKVqzmsWfMyq/pH4tRDsepk43ldmRdokzQP/ODUVfWGMQ7x0pshPO4EqItAM
         v2KaSfv2pOxQTrAkV9VObm5LfBZ82CEJq/4Mf98JYLQMVV3gSYcYnt8ePpGfcJriJSGr
         OKgMxTCZpjFVpmhl5pJbBgyXhy4nTMohcRtTnUPlT0AaoE4sqJgEDd9nx2aPxUwTjg9i
         UpcuCavGoQTWW+XJACAZTTJZ3Jeb/CPfA20H7pAJZFpQOFMXTIHW+exvZh6XQs/hTQ7T
         PimHh+6aHL7Ud6lA+KaE/+snUUuUeM9ZzoHQF4Mm2oZCkHwkQGUjcLg+pv3cczAmpxTI
         5jRg==
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Fix checkpatch.pl warning:

WARNING: Block comments use a trailing */ on a separate line

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c512ae0..3e1e112 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1015,8 +1015,10 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	/* First see if we already have a cgroup group that matches
-	 * the desired set */
+	/*
+	 * First see if we already have a cgroup group that matches
+	 * the desired set
+	 */
 	spin_lock_bh(&css_set_lock);
 	cset = find_existing_css_set(old_cset, cgrp, template);
 	if (cset)
@@ -1045,8 +1047,10 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	INIT_LIST_HEAD(&cset->task_iters);
 	INIT_HLIST_NODE(&cset->hlist);
 
-	/* Copy the set of subsystem state objects generated in
-	 * find_existing_css_set() */
+	/*
+	 * Copy the set of subsystem state objects generated in
+	 * find_existing_css_set()
+	 */
 	memcpy(cset->subsys, template, sizeof(cset->subsys));
 
 	spin_lock_bh(&css_set_lock);
@@ -5227,10 +5231,12 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 		BUG_ON(css->id < 0);
 	}
 
-	/* Update the init_css_set to contain a subsys
+	/*
+	 * Update the init_css_set to contain a subsys
 	 * pointer to this state - since the subsystem is
 	 * newly registered, all tasks and hence the
-	 * init_css_set is in the subsystem's root cgroup. */
+	 * init_css_set is in the subsystem's root cgroup.
+	 */
 	init_css_set.subsys[ss->id] = css;
 
 	have_fork_callback |= (bool)ss->fork << ss->id;
@@ -5238,9 +5244,11 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	have_free_callback |= (bool)ss->free << ss->id;
 	have_canfork_callback |= (bool)ss->can_fork << ss->id;
 
-	/* At system boot, before all subsystems have been
+	/*
+	 * At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
-	 * need to invoke fork callbacks here. */
+	 * need to invoke fork callbacks here.
+	 */
 	BUG_ON(!list_empty(&init_task.tasks));
 
 	BUG_ON(online_css(css));
-- 
2.6.2
