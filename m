From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 16/23] cgroup: relocate cgroup_advance_iter()
Date: Thu,  1 Aug 2013 17:49:54 -0400
Message-ID: <1375393801-4817-17-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
	:references; bh=kgOFJJrPVuJp10tRjSPNprX4S8tRsR9Ej/fDw2ZQhZo=;
	b=V97LQe15DRdWoRFX/CLF+fYc3UwPSrJExx5W74nBCLAr+0HocNuVqJIOp6fIQKhHw2
	j3DtYD0apy5Aq5lV+LCqDbFOa8t5AOL9AMMcmoxn4NDqcLZ7ZDciKCzcvu9J7G5Ym5sU
	e0P5J2+1cKFxKd2scoP0KsVPhhclj3QTRrQgQa11RJGoyYolbg76cBFk7zEJ5mdmzvPU
	9Wdvfre5GIUgfwti2OVnnzk113cvmd84m9oJqY/g1hpIy5wvKsl6pdW8LjSgVS2Ug56C
	tjuodgsjdKswBYMcxnWvYrjnatHxuzrcTnaTd5QOvFb7YurfpkM2zS7VDIyb8ZLgbBlj
	7RpA==
In-Reply-To: <1375393801-4817-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

For some reason, cgroup_advance_iter() is standing lonely all away
from its iter comrades.  Relocate it.

This is cosmetic.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 850ad87..1085439 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2975,30 +2975,6 @@ int cgroup_task_count(const struct cgroup *cgrp)
 }
 
 /*
- * Advance a list_head iterator.  The iterator should be positioned at
- * the start of a css_set
- */
-static void cgroup_advance_iter(struct cgroup *cgrp, struct cgroup_iter *it)
-{
-	struct list_head *l = it->cset_link;
-	struct cgrp_cset_link *link;
-	struct css_set *cset;
-
-	/* Advance to the next non-empty css_set */
-	do {
-		l = l->next;
-		if (l == &cgrp->cset_links) {
-			it->cset_link = NULL;
-			return;
-		}
-		link = list_entry(l, struct cgrp_cset_link, cset_link);
-		cset = link->cset;
-	} while (list_empty(&cset->tasks));
-	it->cset_link = l;
-	it->task = cset->tasks.next;
-}
-
-/*
  * To reduce the fork() overhead for systems that are not actually
  * using their cgroups capability, we don't maintain the lists running
  * through each css_set to its tasks until we see the list actually
@@ -3216,6 +3192,30 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 }
 EXPORT_SYMBOL_GPL(css_next_descendant_post);
 
+/*
+ * Advance a list_head iterator.  The iterator should be positioned at
+ * the start of a css_set
+ */
+static void cgroup_advance_iter(struct cgroup *cgrp, struct cgroup_iter *it)
+{
+	struct list_head *l = it->cset_link;
+	struct cgrp_cset_link *link;
+	struct css_set *cset;
+
+	/* Advance to the next non-empty css_set */
+	do {
+		l = l->next;
+		if (l == &cgrp->cset_links) {
+			it->cset_link = NULL;
+			return;
+		}
+		link = list_entry(l, struct cgrp_cset_link, cset_link);
+		cset = link->cset;
+	} while (list_empty(&cset->tasks));
+	it->cset_link = l;
+	it->task = cset->tasks.next;
+}
+
 void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
 	__acquires(css_set_lock)
 {
-- 
1.8.3.1
