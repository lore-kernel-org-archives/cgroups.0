From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Date: Wed, 6 Mar 2013 11:28:01 +0800
Message-ID: <5136B7C1.6030403@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

cgroup_event_wake() is called with hardirq-safe wqh->lock held, so
the nested cgrp->event_list_lock should also be hardirq-safe.

Fortunately I don't think the deadlock can happen in real life.

Lockdep never complained, maybe because it never found wqh->lock was
held in irq context?

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7a6c4c7..e72c44e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3845,9 +3845,10 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 	struct cgroup_event *event = container_of(wait,
 			struct cgroup_event, wait);
 	struct cgroup *cgrp = event->cgrp;
-	unsigned long flags = (unsigned long)key;
+	unsigned long poll_flags = (unsigned long)key;
+	unsigned long flags;
 
-	if (flags & POLLHUP) {
+	if (poll_flags & POLLHUP) {
 		/*
 		 * If the event has been detached at cgroup removal, we
 		 * can simply return knowing the other side will cleanup
@@ -3857,7 +3858,7 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 		 * side will require wqh->lock via remove_wait_queue(),
 		 * which we hold.
 		 */
-		spin_lock(&cgrp->event_list_lock);
+		spin_lock_irqsave(&cgrp->event_list_lock, flags);
 		if (!list_empty(&event->list)) {
 			list_del_init(&event->list);
 			/*
@@ -3866,7 +3867,7 @@ static int cgroup_event_wake(wait_queue_t *wait, unsigned mode,
 			 */
 			schedule_work(&event->remove);
 		}
-		spin_unlock(&cgrp->event_list_lock);
+		spin_unlock_irqrestore(&cgrp->event_list_lock, flags);
 	}
 
 	return 0;
@@ -3981,9 +3982,9 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	 */
 	dget(cgrp->dentry);
 
-	spin_lock(&cgrp->event_list_lock);
+	spin_lock_irq(&cgrp->event_list_lock);
 	list_add(&event->list, &cgrp->event_list);
-	spin_unlock(&cgrp->event_list_lock);
+	spin_unlock_irq(&cgrp->event_list_lock);
 
 	fput(cfile);
 	fput(efile);
@@ -4406,12 +4407,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * Notify userspace about cgroup removing only after rmdir of cgroup
 	 * directory to avoid race between userspace and kernelspace.
 	 */
-	spin_lock(&cgrp->event_list_lock);
+	spin_lock_irq(&cgrp->event_list_lock);
 	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
 		list_del_init(&event->list);
 		schedule_work(&event->remove);
 	}
-	spin_unlock(&cgrp->event_list_lock);
+	spin_unlock_irq(&cgrp->event_list_lock);
 
 	return 0;
 }
-- 
1.8.0.2
