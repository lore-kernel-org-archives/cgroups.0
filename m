From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-5.6-fixes] cgroup: init_tasks shouldn't be linked
 to the root cgroup
Date: Thu, 30 Jan 2020 11:47:17 -0500
Message-ID: <20200130164717.GE180576@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cRkmfZ70e1FN/dai6WJTy1Ty8v4BIDTiaHK0pQLcbpM=;
        b=msmlzcdjC+TyANKBhZKTl1h2yOagQ43WqHjcbrMtcNUrNzFU/gaLY2HBa5xN/2WODX
         h6+ZcRFdLaex3hEqFCWiVEGhC+QV99QFD9W9wOcspZRPS53Q3+iJe/MhBvWz94UMeViM
         vWjDkkpxkBSr7yDexhoHJoUGfy58IVK8w3Yd3eO3yVJtt8omAFB4Xxa90XCI8gjeDJpA
         0QKylSioDjUDa49oOuBRM6YPDiqfMHq3qM8OuqFeP4ZBOBtEMDDzrmlOAJYbGXc7vh93
         L+GzYcO2xV/5CnDlVJfq6hy5QoyR/BvcSzHOByrmhKlMurzLQ6JTBtemCSDu4yv7HRUn
         f4nQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From 0cd9d33ace336bc424fc30944aa3defd6786e4fe Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 30 Jan 2020 11:37:33 -0500

5153faac18d2 ("cgroup: remove cgroup_enable_task_cg_lists()
optimization") removed lazy initialization of css_sets so that new
tasks are always lniked to its css_set. In the process, it incorrectly
ended up adding init_tasks to root css_set. They show up as PID 0's in
root's cgroup.procs triggering warnings in systemd and generally
confusing people.

Fix it by skip css_set linking for init_tasks.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: https://github.com/joanbm
Link: https://github.com/systemd/systemd/issues/14682
Fixes: 5153faac18d2 ("cgroup: remove cgroup_enable_task_cg_lists() optimization")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v5.5+
---
 kernel/cgroup/cgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3744872263e..cf8a36bdf5c8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5932,11 +5932,14 @@ void cgroup_post_fork(struct task_struct *child)
 
 	spin_lock_irq(&css_set_lock);
 
-	WARN_ON_ONCE(!list_empty(&child->cg_list));
-	cset = task_css_set(current); /* current is @child's parent */
-	get_css_set(cset);
-	cset->nr_tasks++;
-	css_set_move_task(child, NULL, cset, false);
+	/* init tasks are special, only link regular threads */
+	if (likely(child->pid)) {
+		WARN_ON_ONCE(!list_empty(&child->cg_list));
+		cset = task_css_set(current); /* current is @child's parent */
+		get_css_set(cset);
+		cset->nr_tasks++;
+		css_set_move_task(child, NULL, cset, false);
+	}
 
 	/*
 	 * If the cgroup has to be frozen, the new task has too.  Let's set
-- 
2.24.1

