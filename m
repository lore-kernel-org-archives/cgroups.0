From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] memcg: introduce assign_new_owner()
Date: Fri, 22 May 2015 20:21:15 +0200
Message-ID: <20150522182115.GB26770@redhat.com>
References: <20150519121321.GB6203@dhcp22.suse.cz> <20150519212754.GO24861@htj.duckdns.org> <20150520131044.GA28678@dhcp22.suse.cz> <20150520132158.GB28678@dhcp22.suse.cz> <20150520175302.GA7287@redhat.com> <20150520202221.GD14256@dhcp22.suse.cz> <20150521192716.GA21304@redhat.com> <20150522093639.GE5109@dhcp22.suse.cz> <20150522162900.GA8955@redhat.com> <20150522182054.GA26770@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150522182054.GA26770-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The code under "assign_new_owner" looks very ugly and suboptimal.

We do not really need get_task_struct/put_task_struct(), we can
simply recheck/change mm->owner under tasklist_lock. And we do not
want to restart from the very beginning if ->mm was changed by the
time we take task_lock(), we can simply continue (if we do not drop
tasklist_lock).

Just move this code into the new simple helper, assign_new_owner().

Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/exit.c |   56 ++++++++++++++++++++++++++------------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 22fcc05..4d446ab 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -293,6 +293,23 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 }
 
 #ifdef CONFIG_MEMCG
+static bool assign_new_owner(struct mm_struct *mm, struct task_struct *c)
+{
+	bool ret = false;
+
+	if (c->mm != mm)
+		return ret;
+
+	task_lock(c); /* protects c->mm from changing */
+	if (c->mm == mm) {
+		mm->owner = c;
+		ret = true;
+	}
+	task_unlock(c);
+
+	return ret;
+}
+
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
  */
@@ -300,7 +317,6 @@ void mm_update_next_owner(struct mm_struct *mm)
 {
 	struct task_struct *c, *g, *p = current;
 
-retry:
 	/*
 	 * If the exiting or execing task is not the owner, it's
 	 * someone else's problem.
@@ -322,16 +338,16 @@ retry:
 	 * Search in the children
 	 */
 	list_for_each_entry(c, &p->children, sibling) {
-		if (c->mm == mm)
-			goto assign_new_owner;
+		if (assign_new_owner(mm, c))
+			goto done;
 	}
 
 	/*
 	 * Search in the siblings
 	 */
 	list_for_each_entry(c, &p->real_parent->children, sibling) {
-		if (c->mm == mm)
-			goto assign_new_owner;
+		if (assign_new_owner(mm, c))
+			goto done;
 	}
 
 	/*
@@ -341,42 +357,22 @@ retry:
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {
-			if (c->mm == mm)
-				goto assign_new_owner;
+			if (assign_new_owner(mm, c))
+				goto done;
 			if (c->mm)
 				break;
 		}
 	}
-	read_unlock(&tasklist_lock);
+
 	/*
 	 * We found no owner yet mm_users > 1: this implies that we are
 	 * most likely racing with swapoff (try_to_unuse()) or /proc or
 	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL.
 	 */
 	mm->owner = NULL;
-	return;
-
-assign_new_owner:
-	BUG_ON(c == p);
-	get_task_struct(c);
-	/*
-	 * The task_lock protects c->mm from changing.
-	 * We always want mm->owner->mm == mm
-	 */
-	task_lock(c);
-	/*
-	 * Delay read_unlock() till we have the task_lock()
-	 * to ensure that c does not slip away underneath us
-	 */
+done:
 	read_unlock(&tasklist_lock);
-	if (c->mm != mm) {
-		task_unlock(c);
-		put_task_struct(c);
-		goto retry;
-	}
-	mm->owner = c;
-	task_unlock(c);
-	put_task_struct(c);
+	return;
 }
 #endif /* CONFIG_MEMCG */
 
-- 
1.5.5.1

