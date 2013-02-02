From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/4] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Sat, 2 Feb 2013 14:51:15 +0800
Message-ID: <510CB763.3020700@huawei.com>
References: <510CB733.2080904@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <510CB733.2080904@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Davide Libenzi <davidel@xmailserver.org>, Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>

commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
warning for event_control") sovled a deadlock by introducing a new
bug.

We can't access @event without event_list_lock, otherwise we'll race
with cgroup_event_wake() called when closing the eventfd, and then
both threads will try to free the same @event.

CPU0                                  CPU1
---------------------------           -----------------------------
cgroup_rmdir()                        close(eventfd)
  list_for_each_entry()                 cgroup_event_wake()
                                          list_del(event)
    list_del(event)
    cgroup_event_remove(event)
                                          cgroup_event_remove(event)

To fix this, use the new eventfd_signal_hangup() to notify userspace
cgroup is removed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3d21adf..a3d361b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4302,9 +4302,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	struct dentry *d = cgrp->dentry;
 	struct cgroup *parent = cgrp->parent;
 	DEFINE_WAIT(wait);
-	struct cgroup_event *event, *tmp;
+	struct eventfd_ctx *ctx;
+	struct cgroup_event *event;
 	struct cgroup_subsys *ss;
-	LIST_HEAD(tmp_list);
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
@@ -4359,20 +4359,27 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Unregister events and notify userspace.
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace. Use
-	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
+	 * directory to avoid race between userspace and kernelspace. Since
 	 * cgroup_event_wake() is called with the wait queue head locked,
-	 * remove_wait_queue() cannot be called while holding event_list_lock.
+	 * eventfd_signal() cannot be called while holding event_list_lock.
 	 */
 	spin_lock(&cgrp->event_list_lock);
-	list_splice_init(&cgrp->event_list, &tmp_list);
-	spin_unlock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
-		list_del_init(&event->list);
-		remove_wait_queue(event->wqh, &event->wait);
-		eventfd_signal(event->eventfd, 1);
-		schedule_work(&event->remove);
+	while (true) {
+		if (list_empty(&cgrp->event_list))
+			break;
+
+		event = list_first_entry(&cgrp->event_list,
+					 struct cgroup_event, list);
+		ctx = eventfd_ctx_get(event->eventfd);
+		spin_unlock(&cgrp->event_list_lock);
+
+		eventfd_signal(ctx, 1);
+		eventfd_signal_hangup(ctx);
+		eventfd_ctx_put(ctx);
+
+		spin_lock(&cgrp->event_list_lock);
 	}
+	spin_unlock(&cgrp->event_list_lock);
 
 	return 0;
 }
-- 
1.8.0.2
