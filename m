From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] cgroup: remove unused parameter in cgroup_task_migrate().
Date: Mon,  1 Apr 2013 10:51:37 +0300
Message-ID: <1364802697-7875-1-git-send-email-wkevils@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=l1+Ah7u59dFHLqHUOClhjO8bWiCfNb1o++2ONeVTcXA=;
        b=MGyvl1fSyAZfvI5MgqyJ2oOx+xBjqO5OvknAXur9yDUnSJBY+nykFFMQZ06IpVhBFm
         yLbaeICeLdCDytJKCWYREi+sU1hqIsiLgZ6vZU08W87nq95xxWNAB3dsCSsrFKQCwkji
         0eb9Q96KLAksRwD/xZK04aImko2A+AzXWg5lzn8wO9IdxlIrkGtWcEv2xikfFyBm3V8k
         A8GHWPp6Kdtqam9jUEm6oe4hVunIEFvnHcodmBBbfm2OaIDjLueeN0wIwzW7oZkfsQw+
         HvllK+gp7h2x7rNFfpSYHbEPOieiVE3o6AsBoIDnnh8BZQSv0NWq9BOJ36Q20wuApGcs
         l4BA==
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
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 04fa2ab..4aee5bd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1911,7 +1911,7 @@ EXPORT_SYMBOL_GPL(cgroup_taskset_size);
  *
  * Must be called with cgroup_mutex and threadgroup locked.
  */
-static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
+static void cgroup_task_migrate(struct cgroup *oldcgrp,
 				struct task_struct *tsk, struct css_set *newcg)
 {
 	struct css_set *oldcg;
@@ -2084,7 +2084,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 */
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
-		cgroup_task_migrate(cgrp, tc->cgrp, tc->task, tc->cg);
+		cgroup_task_migrate(tc->cgrp, tc->task, tc->cg);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
-- 
1.8.1.4
