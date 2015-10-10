From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/14] cgroup: remove an unused parameter from cgroup_task_migrate()
Date: Fri,  9 Oct 2015 23:29:28 -0400
Message-ID: <1444447781-16182-2-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ax7NtDX1o1hADXhDi05KhooKB856Xnduu7VB5crM3qo=;
        b=1GlyXdCR+v27X5K/b3WIwOy1CkuJkerRq8L1KXFzdCQp7JEmIiwCUWQHLNrvg7k39o
         u+HChG+82UBGKAnTgaSrXRpNu7xx9/SiQPTg5E3dctaaPw3uFwNDwJBkcdSxyT8xub7H
         uNSxI2aAFokhAFS+XLLH8jUTHPrGHN260Ruz3XSjodHqL1eCkRrPjwpzQ2Gq5Ta+L1DJ
         qAXF5Wt+nO0S1YldWISGkmrRuqhLbENws59XqyYA+aaDQsEMI/JvGhRN5sWvI1gz6o+j
         IEZbh2ehwkz5apXgsUkW6kflFn1IoA9DbUlIRDcOaIlk6IsP/76EeZ9Gz6GGyfJaUxXK
         5b1w==
In-Reply-To: <1444447781-16182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_task_migrate() no longer uses @old_cgrp.  Remove it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ae23814..49f30f1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2235,14 +2235,12 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 
 /**
  * cgroup_task_migrate - move a task from one cgroup to another.
- * @old_cgrp: the cgroup @tsk is being migrated from
  * @tsk: the task being migrated
  * @new_cset: the new css_set @tsk is being attached to
  *
  * Must be called with cgroup_mutex, threadgroup and css_set_rwsem locked.
  */
-static void cgroup_task_migrate(struct cgroup *old_cgrp,
-				struct task_struct *tsk,
+static void cgroup_task_migrate(struct task_struct *tsk,
 				struct css_set *new_cset)
 {
 	struct css_set *old_cset;
@@ -2311,8 +2309,7 @@ static int cgroup_taskset_migrate(struct cgroup_taskset *tset,
 	down_write(&css_set_rwsem);
 	list_for_each_entry(cset, &tset->src_csets, mg_node) {
 		list_for_each_entry_safe(task, tmp_task, &cset->mg_tasks, cg_list)
-			cgroup_task_migrate(cset->mg_src_cgrp, task,
-					    cset->mg_dst_cset);
+			cgroup_task_migrate(task, cset->mg_dst_cset);
 	}
 	up_write(&css_set_rwsem);
 
-- 
2.4.3
