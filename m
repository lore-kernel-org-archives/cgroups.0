From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.15] cgroup_freezer: document freezer_fork()
 subtleties
Date: Wed, 12 Feb 2014 16:07:59 -0500
Message-ID: <20140212210759.GF26809@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=eZm9VmL23u4f2e9sgO6ZOPM0/75Ovn0QDmNkJSJPHp8=;
        b=OVD1YP3ugz37CnsNqjxgjLDY8mnusYLQp3gOu87J3+ryCVh6+y4Pu0krbi/S+EK1Ua
         dBIioFjf4bkNc0ecpt7IhDw8ATLTJ3WbGVT19YOLSFBkpiHzcLITPIXWQtuUuHmmMOIr
         t8hp4SDoX7qcRixPvp90jWj9M4lgfvVb16hvF9TUOpXX6rAf3uOCxFUdV+Iij248e1wh
         ZpwcwZyBcKw1Dhib6r8HWnySRcyYP+fKUQg+xWC+eHan0X3Z80nXDcbPSnLIaqHYj916
         TyTH6tf8ZA9zrBhrFhBSRFPah34Lp+VlepEzrWiZxYMs+2+5i/mpT9BEQQHPcfJnldaS
         /XBg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup_subsys->fork() callback is special in that it's called outside
the usual cgroup locking and may race with on-going migration.
freezer_fork() currently doesn't consider such race condition;
however, it is still correct thanks to the fact that freeze_task() may
be called spuriously.

This is quite subtle.  Let's explain what's going on and add test to
detect racing and losing to task migration and skip freeze_task() in
such cases for documentation.

This doesn't make any behavior difference meaningful to userland.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
---
 kernel/cgroup_freezer.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -214,6 +214,16 @@ static void freezer_attach(struct cgroup
 	}
 }
 
+/**
+ * freezer_fork - cgroup post fork callback
+ * @task: a task which has just been forked
+ *
+ * @task has just been created and should conform to the current state of
+ * the cgroup_freezer it belongs to.  This function may race against
+ * freezer_attach().  Losing to freezer_attach() means that we don't have
+ * to do anything as freezer_attach() will put @task into the appropriate
+ * state.
+ */
 static void freezer_fork(struct task_struct *task)
 {
 	struct freezer *freezer;
@@ -222,14 +232,26 @@ static void freezer_fork(struct task_str
 	freezer = task_freezer(task);
 
 	/*
-	 * The root cgroup is non-freezable, so we can skip the
-	 * following check.
+	 * The root cgroup is non-freezable, so we can skip locking the
+	 * freezer.  This is safe regardless of race with task migration.
+	 * If we didn't race or won, skipping is obviously the right thing
+	 * to do.  If we lost and root is the new cgroup, noop is still the
+	 * right thing to do.
 	 */
 	if (!parent_freezer(freezer))
 		goto out;
 
+	/*
+	 * Grab @freezer->lock and freeze @task after verifying @task still
+	 * belongs to @freezer and it's freezing.  The former is for the
+	 * case where we have raced against task migration and lost and
+	 * @task is already in a different cgroup which may not be frozen.
+	 * This isn't strictly necessary as freeze_task() is allowed to be
+	 * called spuriously but let's do it anyway for, if nothing else,
+	 * documentation.
+	 */
 	spin_lock_irq(&freezer->lock);
-	if (freezer->state & CGROUP_FREEZING)
+	if (freezer == task_freezer(task) && (freezer->state & CGROUP_FREEZING))
 		freeze_task(task);
 	spin_unlock_irq(&freezer->lock);
 out:
