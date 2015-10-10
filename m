From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 03/14] cgroup: replace cgroup_has_tasks() with cgroup_is_populated()
Date: Fri,  9 Oct 2015 23:29:30 -0400
Message-ID: <1444447781-16182-4-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vs6FIuL9prCJvatCOT6faReneuAlmK8OdqhbO3VBeUY=;
        b=r+Khl27FG/mvNq43m56vwPMfaxIvobQ8xlFVXMdycRrMA3O6FdGgZ2Sor1xNY02oT6
         IDcnlEn2CTVPo0B+eGda5W0q6gSuKdzhkoWyVlVcmyLlyuU2zZI3mVy5hUfOPv2Nfl9T
         WVjXW2zSJVOEfB0hW0uhu+VlKszlkoUagk6Gb1r9Tl/FL2ua2TYgDxsyELnFWFLLzt2+
         fjwEyGP/R123njnvZ0fZXoafz4PaqQg3syP5oPrUgWpbwlHYEl9R2d9EMcSr7TgL5mCo
         CBaBgd1OF1XvDHS99kVyj0ST7hfbKtvuqYjQXdeFISKFSSAEMA981vQ4O1rUPe9/J/ch
         /tHA==
In-Reply-To: <1444447781-16182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, cgroup_has_tasks() tests whether the target cgroup has any
css_set linked to it.  This works because a css_set's refcnt converges
with the number of tasks linked to it and thus there's no css_set
linked to a cgroup if it doesn't have any live tasks.

To help tracking resource usage of zombie tasks, putting the ref of
css_set will be separated from disassociating the task from the
css_set which means that a cgroup may have css_sets linked to it even
when it doesn't have any live tasks.

This patch replaces cgroup_has_tasks() with cgroup_is_populated()
which tests cgroup->nr_populated instead which locally counts the
number of populated css_sets.  Unlike cgroup_has_tasks(),
cgroup_is_populated() is recursive - if any of the descendants is
populated, the cgroup is populated too.  While this changes the
meaning of the test, all the existing users are okay with the change.

While at it, replace the open-coded ->populated_cnt test in
cgroup_events_show() with cgroup_is_populated().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 4 ++--
 kernel/cgroup.c        | 6 +++---
 kernel/cpuset.c        | 2 +-
 mm/memcontrol.c        | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e9c3eac..bdfdb3a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -456,9 +456,9 @@ static inline struct cgroup *task_cgroup(struct task_struct *task,
 }
 
 /* no synchronization, the result can only be used as a hint */
-static inline bool cgroup_has_tasks(struct cgroup *cgrp)
+static inline bool cgroup_is_populated(struct cgroup *cgrp)
 {
-	return !list_empty(&cgrp->cset_links);
+	return cgrp->populated_cnt;
 }
 
 /* returns ino associated with a cgroup */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e5231d0..435aa68 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3121,7 +3121,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 static int cgroup_events_show(struct seq_file *seq, void *v)
 {
 	seq_printf(seq, "populated %d\n",
-		   (bool)seq_css(seq)->cgroup->populated_cnt);
+		   cgroup_is_populated(seq_css(seq)->cgroup));
 	return 0;
 }
 
@@ -5558,7 +5558,7 @@ void cgroup_exit(struct task_struct *tsk)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	if (notify_on_release(cgrp) && !cgroup_has_tasks(cgrp) &&
+	if (notify_on_release(cgrp) && !cgroup_is_populated(cgrp) &&
 	    !css_has_online_children(&cgrp->self) && !cgroup_is_dead(cgrp))
 		schedule_work(&cgrp->release_agent_work);
 }
@@ -5806,7 +5806,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 
 static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
 {
-	return (!cgroup_has_tasks(css->cgroup) &&
+	return (!cgroup_is_populated(css->cgroup) &&
 		!css_has_online_children(&css->cgroup->self));
 }
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e4d9999..d7ccb87 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -498,7 +498,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_has_tasks(cur->css.cgroup) || cur->attach_in_progress)) {
+	if ((cgroup_is_populated(cur->css.cgroup) || cur->attach_in_progress)) {
 		if (!cpumask_empty(cur->cpus_allowed) &&
 		    cpumask_empty(trial->cpus_allowed))
 			goto out;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 33c8dad..0ddd0ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2920,7 +2920,7 @@ static int memcg_activate_kmem(struct mem_cgroup *memcg,
 	 * of course permitted.
 	 */
 	mutex_lock(&memcg_create_mutex);
-	if (cgroup_has_tasks(memcg->css.cgroup) ||
+	if (cgroup_is_populated(memcg->css.cgroup) ||
 	    (memcg->use_hierarchy && memcg_has_children(memcg)))
 		err = -EBUSY;
 	mutex_unlock(&memcg_create_mutex);
-- 
2.4.3
