From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: remove unused parameter in cgroup_task_migrate().
Date: Mon,  1 Apr 2013 00:08:10 +0300
Message-ID: <1364764090-26369-1-git-send-email-wkevils@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=BpKwBb8PKCUHJ9xXQ1SeC+2hRHhgWgsLLddWmWs5Pck=;
        b=QcIrQdlsdxdxl6WgqHZzmXHQ47VICgwyYAcB/78a8xnchpHURPv46fHeX7v/7/OwGP
         d2KSKdicbY139N7YxdU8prjwD2NR5vl79KGfJTWVy2SraBOABsZYs0KP+Rmm4gPI1Fz/
         huRM4fA2nKxXd9y2+8hWNSgk/gehEU5YVaLb+TGhM+7U1qpiQqbWInhlNFFvDNWpsMVm
         RKbcHZS3vQAWgiTrkxLeBujRvPWSIyzoveO4B/cHH/oqLcmTdgcp/AJNJ4uCLgiWZUK7
         ig+7n/zn/aG+ygjuai3/+IdUm2Ny2HFcEj9q8V3RCgZmK22Q45wuEHoXRzco3t0JxW1n
         NJtA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch removes unused parameter from cgroup_task_migrate().

Signed-off-by: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..33fd0b4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1900,7 +1900,7 @@ EXPORT_SYMBOL_GPL(cgroup_taskset_size);
  *
  * Must be called with cgroup_mutex and threadgroup locked.
  */
-static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
+static void cgroup_task_migrate(struct cgroup *oldcgrp,
 				struct task_struct *tsk, struct css_set *newcg)
 {
 	struct css_set *oldcg;
@@ -1983,7 +1983,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 		goto out;
 	}
 
-	cgroup_task_migrate(cgrp, oldcgrp, tsk, newcg);
+	cgroup_task_migrate(oldcgrp, tsk, newcg);
 
 	for_each_subsys(root, ss) {
 		if (ss->attach)
@@ -2143,7 +2143,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
-		cgroup_task_migrate(cgrp, tc->cgrp, tc->task, tc->cg);
+		cgroup_task_migrate(tc->cgrp, tc->task, tc->cg);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
-- 
1.8.1.4
