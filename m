From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] cgroup: introduce CSS_RELEASED and reduce css iteration fallback window
Date: Fri,  9 May 2014 17:31:26 -0400
Message-ID: <1399671091-23867-10-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pkRKWCBgqYpTqCwQjtXXZOP1GLjZ2vYvf4aqSh/2nFY=;
        b=fLYjDEUfuVQlnrV88pq1zPJSjDOkCA0wZDEUp/WTIuxjk2ClnhA71aLC9ky9nBFrdV
         A6OT+IzEdKv9pBdik9uKuzi0Mpq5U93wviJjT6Z5im4/FSDSMfQpZA9Y3pEY+XhYo73s
         lJWlG4AYZFxYlOX8Y6U/TGFyNplcj5w6z/v5pZyoRv2MXhJwE4QAVUVjWSxiDYDfd15n
         kV/PKwM0tB2CL5PhzaqeRpyrA8N0lyvECGRpCtovFFcbt25PqZNjCvyVu6/2DokMP/1i
         Pb1hw5Oqonh8WF++zMiUyZPzYZTAl6XR/MPNzue0K4w+G+KC9d4ZBU47YH//0XeQL+o5
         sfYQ==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>

css iterations allow the caller to drop RCU read lock.  As long as the
caller keeps the current position accessible, it can simply re-grab
RCU read lock later and continue iteration.  This is achieved by using
CGRP_DEAD to detect whether the current positions next pointer is safe
to dereference and if not re-iterate from the beginning to the next
position using ->serial_nr.

CGRP_DEAD is used as the marker to invalidate the next pointer and the
only requirement is that the marker is set before the next sibling
starts its RCU grace period.  Because CGRP_DEAD is set at the end of
cgroup_destroy_locked() but the cgroup is unlinked when the reference
count reaches zero, we currently have a rather large window where this
fallback re-iteration logic can be triggered.

This patch introduces CSS_RELEASED which is set when a css is unlinked
from its sibling list.  This still keeps the re-iteration logic
working while drastically reducing the window of its activation.
While at it, rewrite the comment in css_next_child() to reflect the
new flag and better explain the synchronization.

This will also enable iterating csses directly instead of through
cgroups.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 41 ++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e65cc0f..634ecc1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -95,6 +95,7 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
+	CSS_RELEASED	= (1 << 0), /* refcnt reached zero, released */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3eda323..eaea062 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3107,27 +3107,28 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	cgroup_assert_mutex_or_rcu_locked();
 
 	/*
-	 * @pos could already have been removed.  Once a cgroup is removed,
-	 * its ->sibling.next is no longer updated when its next sibling
-	 * changes.  As CGRP_DEAD assertion is serialized and happens
-	 * before the cgroup is taken off the ->sibling list, if we see it
-	 * unasserted, it's guaranteed that the next sibling hasn't
-	 * finished its grace period even if it's already removed, and thus
-	 * safe to dereference from this RCU critical section.  If
-	 * ->sibling.next is inaccessible, cgroup_is_dead() is guaranteed
-	 * to be visible as %true here.
+	 * @pos could already have been unlinked from the sibling list.
+	 * Once a cgroup is removed, its ->sibling.next is no longer
+	 * updated when its next sibling changes.  CSS_RELEASED is set when
+	 * @pos is taken off list, at which time its next pointer is valid,
+	 * and, as releases are serialized, the one pointed to by the next
+	 * pointer is guaranteed to not have started release yet.  This
+	 * implies that if we observe !CSS_RELEASED on @pos in this RCU
+	 * critical section, the one pointed to by its next pointer is
+	 * guaranteed to not have finished its RCU grace period even if we
+	 * have dropped rcu_read_lock() inbetween iterations.
 	 *
-	 * If @pos is dead, its next pointer can't be dereferenced;
-	 * however, as each cgroup is given a monotonically increasing
-	 * unique serial number and always appended to the sibling list,
-	 * the next one can be found by walking the parent's children until
-	 * we see a cgroup with higher serial number than @pos's.  While
-	 * this path can be slower, it's taken only when either the current
-	 * cgroup is removed or iteration and removal race.
+	 * If @pos has CSS_RELEASED set, its next pointer can't be
+	 * dereferenced; however, as each css is given a monotonically
+	 * increasing unique serial number and always appended to the
+	 * sibling list, the next one can be found by walking the parent's
+	 * children until the first css with higher serial number than
+	 * @pos's.  While this path can be slower, it happens iff iteration
+	 * races against release and the race window is very small.
 	 */
 	if (!pos) {
 		next = list_entry_rcu(cgrp->self.children.next, struct cgroup, self.sibling);
-	} else if (likely(!cgroup_is_dead(pos))) {
+	} else if (likely(!(pos->self.flags & CSS_RELEASED))) {
 		next = list_entry_rcu(pos->self.sibling.next, struct cgroup, self.sibling);
 	} else {
 		list_for_each_entry_rcu(next, &cgrp->self.children, self.sibling)
@@ -4138,6 +4139,7 @@ static void css_release_work_fn(struct work_struct *work)
 
 	mutex_lock(&cgroup_mutex);
 
+	css->flags |= CSS_RELEASED;
 	list_del_rcu(&css->sibling);
 
 	if (ss) {
@@ -4524,10 +4526,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-	 * creation by disabling cgroup_lock_live_group().  Note that
-	 * CGRP_DEAD assertion is depended upon by css_next_child() to
-	 * resume iteration after dropping RCU read lock.  See
-	 * css_next_child() for details.
+	 * creation by disabling cgroup_lock_live_group().
 	 */
 	set_bit(CGRP_DEAD, &cgrp->flags);
 
-- 
1.9.0
