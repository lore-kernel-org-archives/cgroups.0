From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Date: Mon, 18 Feb 2013 14:12:23 +0800
Message-ID: <5121C647.7030608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
warning for event_control") solved a deadlock by introducing a new
bug.

Move cgrp->event_list to a temporary list doesn't mean you can traverse
this list locklessly, because at the same time cgroup_event_wake() can
be called and remove the event from the list. The result of this race
is disastrous.

We adopt the way how kvm irqfd code implements race-free event removal,
which is now described in the comments in cgroup_event_wake().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 26c071c..65c8101 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -217,6 +217,10 @@ struct cgroup_event {
 	 */
 	struct list_head list;
 	/*
+	 * Need to notify userspace when this event is removed?
+	 */
+	bool signal_on_remove;
+	/*
 	 * All fields below needed to unregister event when
 	 * userspace closes eventfd.
 	 */
@@ -3833,8 +3837,17 @@ static void cgroup_event_remove(struct work_struct *work)
 			remove);
 	struct cgroup *cgrp = event->cgrp;
 
+	remove_wait_queue(event->wqh, &event->wait);
+
 	event->cft->unregister_event(cgrp, event->cft, event->eventfd);
 
+	/*
+	 * If this event is to be removed due to cgroup removal,
+	 * we notify userspace.
+	 */
+	if (event->signal_on_remove)
+		eventfd_signal(event->eventfd, 1);
+
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
 	dput(cgrp->dentry);
@@ -3854,15 +3867,25 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	unsigned long flags = (unsigned long)key;
 
 	if (flags & POLLHUP) {
-		__remove_wait_queue(event->wqh, &event->wait);
-		spin_lock(&cgrp->event_list_lock);
-		list_del_init(&event->list);
-		spin_unlock(&cgrp->event_list_lock);
 		/*
-		 * We are in atomic context, but cgroup_event_remove() may
-		 * sleep, so we have to call it in workqueue.
+		 * If the event has been detached at cgroup removal, we
+		 * can simply return knowing the other side will cleanup
+		 * for us.
+		 *
+		 * We can't race against event freeing since the other
+		 * side will require wqh->lock via remove_wait_queue(),
+		 * which we hold.
 		 */
-		schedule_work(&event->remove);
+		spin_lock(&cgrp->event_list_lock);
+		if (!list_empty(&event->list)) {
+			list_del_init(&event->list);
+			/*
+			 * We are in atomic context, but cgroup_event_remove()
+			 * may sleep, so we have to call it in workqueue.
+			 */
+			schedule_work(&event->remove);
+		}
+		spin_unlock(&cgrp->event_list_lock);
 	}
 
 	return 0;
@@ -4428,20 +4451,15 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/*
 	 * Unregister events and notify userspace.
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace. Use
-	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
-	 * cgroup_event_wake() is called with the wait queue head locked,
-	 * remove_wait_queue() cannot be called while holding event_list_lock.
+	 * directory to avoid race between userspace and kernelspace.
 	 */
 	spin_lock(&cgrp->event_list_lock);
-	list_splice_init(&cgrp->event_list, &tmp_list);
-	spin_unlock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		event->signal_on_remove = true;
 		list_del_init(&event->list);
-		remove_wait_queue(event->wqh, &event->wait);
-		eventfd_signal(event->eventfd, 1);
 		schedule_work(&event->remove);
 	}
+	spin_unlock(&cgrp->event_list_lock);
 
 	return 0;
 }
-- 
1.8.0.2
