From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.12-rc6
Date: Mon, 21 Oct 2013 11:49:20 +0100
Message-ID: <20131021104920.GA26917@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=BfkSYJpdxr36t5h3FsdGvM56kNIB5KLdZlD2zhWwiR0=;
        b=dh71njJij2ncJBLkybw1CLlxR1t6XIw4zFKxzTi8RQRAH/lPJzV8ODei3HLaFC2QbZ
         PlZt4LL/gBaFa8nwEkGTeG8qiL4adHMtC4/k+GSwtFFxZYaOwuCNVUNnMjpTMPLBQopm
         qZIGZWLhhbGShPIhiZoBRRpKyziUFBP5yh3mFcy5cmAdhjNcqCVJHuqDgYsmwCwHKkRw
         l6xvfIrJGYgYJ8odQh1bNlnci5w6USGuzumSkUE7J0jeIN+rzFOuO3HQ5yu45K1zGKyf
         8hJwMqsShFIMA5T2u6b/taD+nQbPC7mh6wIrBr8RcS5xq583lKxKhLGZm/8NySr286eF
         CkfQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Two late fixes for cgroup.  One fixes descendant walk introduced
during this rc1 cycle.  The other fixes a post 3.9 bug during task
attach which can lead to hang.  Both fixes are critical and the fixes
are relatively straight-forward.

The two fixes are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.12-fixes

for you to fetch changes up to ea84753c98a7ac6b74e530b64c444a912b3835ca:

  cgroup: fix to break the while loop in cgroup_attach_task() correctly (2013-10-13 16:07:10 -0400)

Thanks.

----------------------------------------------------------------
Anjana V Kumar (1):
      cgroup: fix to break the while loop in cgroup_attach_task() correctly

Tejun Heo (1):
      cgroup: fix cgroup post-order descendant walk of empty subtree

 kernel/cgroup.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0aeb32..1bf4f7a1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2038,7 +2038,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 
 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2046,7 +2046,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2054,7 +2054,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+	next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);
@@ -3187,11 +3187,9 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	/* if first iteration, visit the leftmost descendant */
-	if (!pos) {
-		next = css_leftmost_descendant(root);
-		return next != root ? next : NULL;
-	}
+	/* if first iteration, visit leftmost descendant which may be @root */
+	if (!pos)
+		return css_leftmost_descendant(root);
 
 	/* if we visited @root, we're done */
 	if (pos == root)
