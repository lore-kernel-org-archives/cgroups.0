From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/7] reorder cgroup_migrate()'s parameters
Date: Mon, 18 May 2015 15:49:53 -0400
Message-ID: <1431978595-12176-6-git-send-email-tj@kernel.org>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4B0v5NAjYN7cEsIG3cx9/QsGsbpJBYFCltAJexzE0Xo=;
        b=d4CkKWCo4rZ1ELmBgy/edEU5mmd5nzEXnrXpOedCfoa8XEgzmpp3vKQl6/oe3CA56r
         g+ob+6cPnHzvDkCeYY+iI9KjwKHZFg2cZHKRQnHTxwN3STtO+3fou6osJpFUZRl5lGko
         lHBuNFJNZTrNfXs8oz1O86u/95XPOR57VS6BVbRwGFg2MGBKKen5rIrMZ0KGxX8iTnpi
         88AMhvr5qATun+kNEW9tEcQOPQNlWMcMhcoqnRBTihFt9NetRWdvi1rrOSiByNerf6sb
         JE0Hweoyq2sQ0wRAeO02V3kOSDKw8kaQ+i5Rj5sjoSXJHqTOj+D1OE4vuY3bnpb7Un4V
         etyQ==
In-Reply-To: <1431978595-12176-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_migrate() has the destination cgroup as the first parameter
while cgroup_task_migrate() has the destination cset as the last.
Another migration function is scheduled to be added which can make the
discrepancy further stand out.  Let's reorder cgroup_migrate()'s
parameters so that the destination cgroup is the last.

This doesn't cause any functional difference.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da45ce9..b36707b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2209,9 +2209,9 @@ err:
 
 /**
  * cgroup_migrate - migrate a process or task to a cgroup
- * @cgrp: the destination cgroup
  * @leader: the leader of the process or the task to migrate
  * @threadgroup: whether @leader points to the whole process or a single task
+ * @cgrp: the destination cgroup
  *
  * Migrate a process or task denoted by @leader to @cgrp.  If migrating a
  * process, the caller must be holding cgroup_threadgroup_rwsem.  The
@@ -2225,8 +2225,8 @@ err:
  * decided for all targets by invoking group_migrate_prepare_dst() before
  * actually starting migrating.
  */
-static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
-			  bool threadgroup)
+static int cgroup_migrate(struct task_struct *leader, bool threadgroup,
+			  struct cgroup *cgrp)
 {
 	struct cgroup_taskset tset = {
 		.src_csets	= LIST_HEAD_INIT(tset.src_csets),
@@ -2363,7 +2363,7 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
 	/* prepare dst csets and commit */
 	ret = cgroup_migrate_prepare_dst(dst_cgrp, &preloaded_csets);
 	if (!ret)
-		ret = cgroup_migrate(dst_cgrp, leader, threadgroup);
+		ret = cgroup_migrate(leader, threadgroup, dst_cgrp);
 
 	cgroup_migrate_finish(&preloaded_csets);
 	return ret;
@@ -2640,7 +2640,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 				goto out_finish;
 			last_task = task;
 
-			ret = cgroup_migrate(src_cset->dfl_cgrp, task, true);
+			ret = cgroup_migrate(task, true, src_cset->dfl_cgrp);
 
 			put_task_struct(task);
 
@@ -3711,7 +3711,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			ret = cgroup_migrate(to, task, false);
+			ret = cgroup_migrate(task, false, to);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
-- 
2.4.0
