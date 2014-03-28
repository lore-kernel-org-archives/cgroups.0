From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] cgroup: teach css_task_iter about effective csses
Date: Thu, 27 Mar 2014 22:40:55 -0400
Message-ID: <1395974461-12735-7-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FUsqqWJRO9IfOcm3qRU11fsyhGkMI16TfkDvch4gLEs=;
        b=B+02xuG8Z+uRsU+OK8EVVtdE/2WDSrwqj9VLOvPtqgVmSXTvMZmAcMYsxWeguYOPC8
         f1hDNXMMpO/wfX2zCr8mvwJ7usUf0xvVvyHt1OR7DKF8BPnSOGRSEf6zgh9G9d9CJo2w
         9bqT9yew026IsQjdXAjfbf1mTcRx0pY0akV9RnLjFCNJTDAqZCCLPwnGjLlIXcrIupEH
         3hRPrRRaE1LTpkaEdol9gq/9Ra/L392dPkm1r1+s6ljGIRSAAb3jq6fY9pojP89Qd+bj
         d8JGjL6K4jMoVAka4K2BE4HVc2W569yxwob5kUjrk/PWQrsRwh0wo0DoVs8S/O+C7aVj
         dr4Q==
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
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
index 6bbe143..cbfd8be 100644
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
index 318b6a2..e3aa2aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2850,8 +2850,14 @@ static void css_advance_task_iter(struct css_task_iter *it)
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
@@ -2888,7 +2894,13 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
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
1.8.5.3
