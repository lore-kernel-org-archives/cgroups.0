From: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Thu, 20 Oct 2022 07:47:01 +0000
Message-ID: <20221020074701.84326-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WEv0DAtYrQBEKc4KQv+MDWqqO4sqebBTQ3kaboRnQNg=;
        b=GTQ3+2aB72+kOTV0y/y2Ncy5TWnk/z4Cj5D2tlFLPIwoT+7QGZOijPWbsL6YlAkTR2
         WH6rXobe+/n1Op2T4Bkpy9k87M8Eihx9tndD/7jNX/1bQbEeceTVqzY0GKTOKj5mSIYn
         yX+uFQLqGCfD2BwOppd9RVzffo/ZpfeFt1SGkK9aFWDcLq0Kh8AtY+WHaxEzRe20mDnG
         MKjRrA2S3k7IDrGfHDygEhy5zVbNDzzFDKhkI2oBWOeH0zGZs9+Wa4SbJPTHgw7hGfW4
         7mgZq9Rt5Gr+HE7ElBc8URsjfh7LITM/q6YvddDawZP1iiwOGdcQnuNR/b5RG5tmqDah
         /G3w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Check the populated state of css_set in css_set_update_populated
and update the populated state of to_cset after from_cset is updated.

Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d922773fa90b..6c474be57f91 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -861,7 +861,8 @@ static void css_set_update_populated(struct css_set *cset, bool populated)
 {
 	struct cgrp_cset_link *link;
 
-	lockdep_assert_held(&css_set_lock);
+	if (!cset || css_set_populated(cset))
+		return;
 
 	list_for_each_entry(link, &cset->cgrp_links, cgrp_link)
 		cgroup_update_populated(link->cgrp, populated);
@@ -903,16 +904,12 @@ static void css_set_move_task(struct task_struct *task,
 {
 	lockdep_assert_held(&css_set_lock);
 
-	if (to_cset && !css_set_populated(to_cset))
-		css_set_update_populated(to_cset, true);
-
 	if (from_cset) {
 		WARN_ON_ONCE(list_empty(&task->cg_list));
 
 		css_set_skip_task_iters(from_cset, task);
 		list_del_init(&task->cg_list);
-		if (!css_set_populated(from_cset))
-			css_set_update_populated(from_cset, false);
+		css_set_update_populated(from_cset, false);
 	} else {
 		WARN_ON_ONCE(!list_empty(&task->cg_list));
 	}
@@ -926,6 +923,7 @@ static void css_set_move_task(struct task_struct *task,
 		WARN_ON_ONCE(task->flags & PF_EXITING);
 
 		cgroup_move_task(task, to_cset);
+		css_set_update_populated(to_cset, true);
 		list_add_tail(&task->cg_list, use_mg_tasks ? &to_cset->mg_tasks :
 							     &to_cset->tasks);
 	}
-- 
2.25.1

