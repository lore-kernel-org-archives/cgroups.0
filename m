From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: grab cgroup_mutex earlier in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 16:19:29 -0400
Message-ID: <1399407574-21472-4-git-send-email-tj@kernel.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RWobBymw4MCF1UEFfvcg36Gk6d2aVpEtbEFubAhxWFk=;
        b=QMT/QaeUGrYgKxhuz1a1sI58Y7yiOJzgZH3HSzlLTMc36QUTw4anBzScDggRQ+Oe5q
         vZ15mXR3adDXN9GZvHemyLrtkRzXsJp5u2japvqoSZBBdwY0ZLirTFOOwRqpoyyt9zWl
         rzE1pIKOawZ/AkB1/XmP5lvDyA5VDigVzLwgyS9vVyIkvsN7CMoQgxrxT/5TOI52uLv6
         cM8/eHYuA3EbDejlacc7f3HboDF0SgnuB2mQoM6/+yTBM8FFha8XsHe0J2uet5SEB45h
         ihZEFMAGJyYPcH8+GREmUNSPROdwi6vd6dx7YbS17oSq9o7e89h5kNpmt1eIcWi/WruH
         /5YQ==
In-Reply-To: <1399407574-21472-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Move cgroup_lock_live_group() invocation upwards to right below
cgroup_tree_mutex in cgroup_subtree_control_write().  This is to help
the planned locking simplification.

This doesn't make any userland-visible behavioral changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 69c0ed9..f544e46 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2583,6 +2583,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 
 	mutex_lock(&cgroup_tree_mutex);
+	if (!cgroup_lock_live_group(cgrp)) {
+		ret = -ENODEV;
+		goto out_unlock_tree;
+	}
 
 	for_each_subsys(ss, ssid) {
 		if (enable & (1 << ssid)) {
@@ -2606,6 +2610,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				cgroup_get(child);
 				prepare_to_wait(&child->offline_waitq, &wait,
 						TASK_UNINTERRUPTIBLE);
+				mutex_unlock(&cgroup_mutex);
 				mutex_unlock(&cgroup_tree_mutex);
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
@@ -2620,7 +2625,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			    (cgrp->parent &&
 			     !(cgrp->parent->child_subsys_mask & (1 << ssid)))) {
 				ret = -ENOENT;
-				goto out_unlock_tree;
+				goto out_unlock;
 			}
 		} else if (disable & (1 << ssid)) {
 			if (!(cgrp->child_subsys_mask & (1 << ssid))) {
@@ -2632,7 +2637,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 			cgroup_for_each_live_child(child, cgrp) {
 				if (child->child_subsys_mask & (1 << ssid)) {
 					ret = -EBUSY;
-					goto out_unlock_tree;
+					goto out_unlock;
 				}
 			}
 		}
@@ -2640,12 +2645,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 	if (!enable && !disable) {
 		ret = 0;
-		goto out_unlock_tree;
-	}
-
-	if (!cgroup_lock_live_group(cgrp)) {
-		ret = -ENODEV;
-		goto out_unlock_tree;
+		goto out_unlock;
 	}
 
 	/*
-- 
1.9.0
