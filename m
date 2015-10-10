From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] cgroup: keep css_set and task lists in chronological order
Date: Fri,  9 Oct 2015 23:29:35 -0400
Message-ID: <1444447781-16182-9-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O9ZuFPhKZ8EFrebrfWsR7VxL7ixJ3VQSBpD+BMRNbkk=;
        b=zahsJDWwbLeKh2GN3IspcYpvaUp4Y+qOjyMUCi6r8UWcR9XlRlqqXSGKg4VOkjdTlg
         iPsUp8uv6Ya0IH7+DuB+aeQwA8ypohm0f27JTRrGihBUCLit3zMUMkgIKcT/qMG0BEC3
         ChSor3G6H1DQkri+pru2ERY/ASz8/USUTEJNcN5CK7ABEojEdewOVM4mKylCRzPPdWCu
         xPdcL/hySqYLhNsbP2Vsk6qTfUN1YC13mX3f4Tu8HxhfC3Ggo2uuvXrtLbLjtfxJixru
         H7EzpgaIPZ6gWPJAo2pa/OCPJPZh78mXWB0g2G0xMSAj+zTRbefvWbclY5R1EANr5Mvw
         CUhw==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

css task iteration will be updated to not leak cgroup internal locking
to iterator users.  In preparation, update css_set and task lists to
be in chronological order.

For tasks, as migration path is already using list_splice_tail_init(),
only cgroup_enable_task_cg_lists() and cgroup_post_fork() need
updating.  For css_sets, link_css_set() is the only place which needs
to be updated.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b8da97a..5cb28d2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -913,12 +913,11 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	link->cset = cset;
 	link->cgrp = cgrp;
 
-	list_move(&link->cset_link, &cgrp->cset_links);
-
 	/*
-	 * Always add links to the tail of the list so that the list
-	 * is sorted by order of hierarchy creation
+	 * Always add links to the tail of the lists so that the lists are
+	 * in choronological order.
 	 */
+	list_move_tail(&link->cset_link, &cgrp->cset_links);
 	list_add_tail(&link->cgrp_link, &cset->cgrp_links);
 
 	cgroup_get(cgrp);
@@ -1778,7 +1777,7 @@ static void cgroup_enable_task_cg_lists(void)
 
 			if (!css_set_populated(cset))
 				css_set_update_populated(cset, true);
-			list_add(&p->cg_list, &cset->tasks);
+			list_add_tail(&p->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
 		spin_unlock_irq(&p->sighand->siglock);
@@ -5478,7 +5477,7 @@ void cgroup_post_fork(struct task_struct *child,
 		cset = task_css_set(current);
 		if (list_empty(&child->cg_list)) {
 			rcu_assign_pointer(child->cgroups, cset);
-			list_add(&child->cg_list, &cset->tasks);
+			list_add_tail(&child->cg_list, &cset->tasks);
 			get_css_set(cset);
 		}
 		up_write(&css_set_rwsem);
-- 
2.4.3
