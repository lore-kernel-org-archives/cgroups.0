From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/14] cgroup: reorganize css_task_iter functions
Date: Fri,  9 Oct 2015 23:29:37 -0400
Message-ID: <1444447781-16182-11-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nxf1xM6cwuYW4Vz3uRd/FiXOWbHqdmHdt81A/ElU6S4=;
        b=Dse9yd+Ic7UqgQQVnNZKBLJKvoZx7udOfKvQG0ewCqaUQ+0aSN9RhBDNpcOqZK3zbh
         hKnZE+ie7RMoO2b0Vwsyy7uS34EYmec6N9IGJpVE1B0/oMH3WGA+3LgfkrdarQa4XmqY
         Q5q2wjseTPS9EG3Zr7p611YwUTQ/08KRQbmUlHwVO8uw/Luvlzm6VKU3MQFsFYhaaSxT
         BqosqarLcWiWwGyZdLRlW18uMmCU95dF2MVP5yqrX8OXruHInd4XjF+iNpWMbRtxwv4u
         cRk7P+eTuHwD0V/3Bq6vesp49ppum6R/6hrmVetEyb5w1Ds4c5twnCwkjgqxYvSO6GCS
         8dhg==
In-Reply-To: <1444447781-16182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

* Rename css_advance_task_iter() to css_task_iter_advance_css_set()
  and make it clear it->task_pos too at the end of the iteration.

* Factor out css_task_iter_advance() from css_task_iter_next().  The
  new function whines if called on a terminated iterator.

Except for the termination check, this is pure reorganization and
doesn't introduce any behavior changes.  This will help the planned
locking update for css_task_iter.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4e239e4..0a58445 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3791,12 +3791,12 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 }
 
 /**
- * css_advance_task_iter - advance a task itererator to the next css_set
+ * css_task_iter_advance_css_set - advance a task itererator to the next css_set
  * @it: the iterator to advance
  *
  * Advance @it to the next css_set to walk.
  */
-static void css_advance_task_iter(struct css_task_iter *it)
+static void css_task_iter_advance_css_set(struct css_task_iter *it)
 {
 	struct list_head *l = it->cset_pos;
 	struct cgrp_cset_link *link;
@@ -3807,6 +3807,7 @@ static void css_advance_task_iter(struct css_task_iter *it)
 		l = l->next;
 		if (l == it->cset_head) {
 			it->cset_pos = NULL;
+			it->task_pos = NULL;
 			return;
 		}
 
@@ -3830,6 +3831,28 @@ static void css_advance_task_iter(struct css_task_iter *it)
 	it->mg_tasks_head = &cset->mg_tasks;
 }
 
+static void css_task_iter_advance(struct css_task_iter *it)
+{
+	struct list_head *l = it->task_pos;
+
+	WARN_ON_ONCE(!l);
+
+	/*
+	 * Advance iterator to find next entry.  cset->tasks is consumed
+	 * first and then ->mg_tasks.  After ->mg_tasks, we move onto the
+	 * next cset.
+	 */
+	l = l->next;
+
+	if (l == it->tasks_head)
+		l = it->mg_tasks_head->next;
+
+	if (l == it->mg_tasks_head)
+		css_task_iter_advance_css_set(it);
+	else
+		it->task_pos = l;
+}
+
 /**
  * css_task_iter_start - initiate task iteration
  * @css: the css to walk tasks of
@@ -3862,7 +3885,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	it->cset_head = it->cset_pos;
 
-	css_advance_task_iter(it);
+	css_task_iter_advance_css_set(it);
 }
 
 /**
@@ -3876,28 +3899,12 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
 	struct task_struct *res;
-	struct list_head *l = it->task_pos;
 
-	/* If the iterator cg is NULL, we have no tasks */
 	if (!it->cset_pos)
 		return NULL;
-	res = list_entry(l, struct task_struct, cg_list);
-
-	/*
-	 * Advance iterator to find next entry.  cset->tasks is consumed
-	 * first and then ->mg_tasks.  After ->mg_tasks, we move onto the
-	 * next cset.
-	 */
-	l = l->next;
-
-	if (l == it->tasks_head)
-		l = it->mg_tasks_head->next;
-
-	if (l == it->mg_tasks_head)
-		css_advance_task_iter(it);
-	else
-		it->task_pos = l;
 
+	res = list_entry(it->task_pos, struct task_struct, cg_list);
+	css_task_iter_advance(it);
 	return res;
 }
 
-- 
2.4.3
