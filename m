From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] cgroup: teach css_task_iter about effective csses
Date: Mon, 14 Apr 2014 17:37:04 -0400
Message-ID: <1397511430-2673-7-git-send-email-tj@kernel.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PbGGtMN5Mnx9m0Y747e5zwmpXd/7peLVt4TfAvj8PRQ=;
        b=wwUS+TaKy1jixw+cqVEQ5oUqYFrTthUTEMPP161+MYTN2T+XSZkU14mVJ8ednmvwRw
         X+PuggsPKodahhoiGN7cu8psk28NxG+Udf2I26q6NquBdR4/c93MFx3o6YvYkRp83Tnj
         /qaBrNa1RHq4YGT6kAJDEINb0ZRfhuFl1GZFAIwke/mF8WbU+RYGDzTZIWNjpkE1AB0G
         OyFEdm/r+pBTmFKEdgxynfpCoMAIT+RJsc01+UDBKXqNVaBwrAWnjLfUlOVn+bhNR2uR
         zGcEdLTzQghkerlMvg8kj2htem06FbAXY8ktaB3Nin3B+LyK6ylgol0sRnB/VXsfd6dI
         W32A==
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Currently, css_task_iter iterates tasks associated with a css by
visiting each css_set associated with the owning cgroup and walking
tasks of each of them.  This works fine for !unified hierarchies as
each cgroup has its own css for each associated subsystem on the
hierarchy; however, on the planned unified hierarchy, a cgroup may not
have csses associated and its tasks would be considered associated
with the matching css of the nearest ancestor which has the subsystem
enabled.

This means that on the default unified hierarchy, just walking all
tasks associated with a cgroup isn't enough to walk all tasks which
are associated with the specified css.  If any of its children doesn't
have the matching css enabled, task iteration should also include all
tasks from the subtree.  We already added cgroup->e_csets[] to list
all css_sets effectively associated with a given css and walk css_sets
on that list instead to achieve such iteration.

This patch updates css_task_iter iteration such that it walks css_sets
on cgroup->e_csets[] instead of cgroup->cset_links if iteration is
requested on an non-dummy css.  Thanks to the previous iteration
update, this change can be achieved with the addition of
css_task_iter->ss and minimal updates to css_advance_task_iter() and
css_task_iter_start().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index bee3905..18fcae3 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -842,6 +842,8 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 
 /* A css_task_iter should be treated as an opaque object */
 struct css_task_iter {
+	struct cgroup_subsys		*ss;
+
 	struct list_head		*cset_pos;
 	struct list_head		*cset_head;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bcf390f..0318bfc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2872,8 +2872,14 @@ static void css_advance_task_iter(struct css_task_iter *it)
 			it->cset_pos = NULL;
 			return;
 		}
-		link = list_entry(l, struct cgrp_cset_link, cset_link);
-		cset = link->cset;
+
+		if (it->ss) {
+			cset = container_of(l, struct css_set,
+					    e_cset_node[it->ss->id]);
+		} else {
+			link = list_entry(l, struct cgrp_cset_link, cset_link);
+			cset = link->cset;
+		}
 	} while (list_empty(&cset->tasks) && list_empty(&cset->mg_tasks));
 
 	it->cset_pos = l;
@@ -2910,7 +2916,13 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	down_read(&css_set_rwsem);
 
-	it->cset_pos = &css->cgroup->cset_links;
+	it->ss = css->ss;
+
+	if (it->ss)
+		it->cset_pos = &css->cgroup->e_csets[css->ss->id];
+	else
+		it->cset_pos = &css->cgroup->cset_links;
+
 	it->cset_head = it->cset_pos;
 
 	css_advance_task_iter(it);
-- 
1.9.0
