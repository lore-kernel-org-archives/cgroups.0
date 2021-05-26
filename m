From: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] cgroup: Fix kernel-doc
Date: Wed, 26 May 2021 10:49:09 +0800
Message-ID: <1621997349-118999-1-git-send-email-yang.lee@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Fix function name in cgroup.c and rstat.c kernel-doc comment
to remove these warnings found by clang_w1.

kernel/cgroup/cgroup.c:2401: warning: expecting prototype for
cgroup_taskset_migrate(). Prototype was for cgroup_migrate_execute()
instead.
kernel/cgroup/rstat.c:233: warning: expecting prototype for
cgroup_rstat_flush_begin(). Prototype was for cgroup_rstat_flush_hold()
instead.

Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Fixes: 'commit e595cd706982 ("cgroup: track migration context in cgroup_mgctx")'
Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 kernel/cgroup/rstat.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 21ecc6e..fc344f4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2389,7 +2389,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 }
 
 /**
- * cgroup_taskset_migrate - migrate a taskset
+ * cgroup_migrate_execute - migrate a taskset
  * @mgctx: migration context
  *
  * Migrate tasks in @mgctx as setup by migration preparation functions.
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index cee265c..7f0e589 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -220,7 +220,7 @@ void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp)
 }
 
 /**
- * cgroup_rstat_flush_begin - flush stats in @cgrp's subtree and hold
+ * cgroup_rstat_flush_hold - flush stats in @cgrp's subtree and hold
  * @cgrp: target cgroup
  *
  * Flush stats in @cgrp's subtree and prevent further flushes.  Must be
-- 
1.8.3.1

