From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 2/2] cgroup: get rid of cgroup_freezer_frozen_exit()
Date: Fri, 26 Apr 2019 10:59:45 -0700
Message-ID: <20190426175945.2559865-3-guro@fb.com>
References: <20190426175945.2559865-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=GwFOGfYx+Z1jgC8YSP6xVOVt+bV6jEaQATYAcfMEIUM=;
 b=M2N/Q29YPQUd6z1Dn0McgNiECLg7kMpcU6SG41IjD0GImjjsNydzQWjR0ouWcd3O8EGQ
 j6g8ACOKL7w0VdwMKFGCIvsIy81RRlEaSikgaWSNVql2hJtyQ4lfT+eJ3TrSkINc540d
 Rg4qE8XuewG+GHqpK6iMjWanSGoNsO1tDl8= 
In-Reply-To: <20190426175945.2559865-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

A task should never enter the exit path with the task->frozen bit set.
Any frozen task must enter the signal handling loop and the only
way to escape is through cgroup_leave_frozen(true), which
unconditionally drops the task->frozen bit. So it means that
cgroyp_freezer_frozen_exit() has zero chances to be called and
has to be removed.

Let's put a WARN_ON_ONCE() instead of the cgroup_freezer_frozen_exit()
call to catch any potential leak of the task's frozen bit.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
---
 include/linux/cgroup.h  |  2 +-
 kernel/cgroup/cgroup.c  |  5 ++---
 kernel/cgroup/freezer.c | 10 ----------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3e2efd412dfa..c0077adeea83 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -889,7 +889,7 @@ void cgroup_update_frozen(struct cgroup *cgrp);
 void cgroup_freeze(struct cgroup *cgrp, bool freeze);
 void cgroup_freezer_migrate_task(struct task_struct *task, struct cgroup *src,
 				 struct cgroup *dst);
-void cgroup_freezer_frozen_exit(struct task_struct *task);
+
 static inline bool cgroup_task_freeze(struct task_struct *task)
 {
 	bool ret;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 57edcf398d71..622ae7452969 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5929,9 +5929,8 @@ void cgroup_exit(struct task_struct *tsk)
 		css_set_move_task(tsk, cset, NULL, false);
 		cset->nr_tasks--;
 
-		if (unlikely(cgroup_task_frozen(tsk)))
-			cgroup_freezer_frozen_exit(tsk);
-		else if (unlikely(cgroup_task_freeze(tsk)))
+		WARN_ON_ONCE(cgroup_task_frozen(tsk));
+		if (unlikely(cgroup_task_freeze(tsk)))
 			cgroup_update_frozen(task_dfl_cgroup(tsk));
 
 		spin_unlock_irq(&css_set_lock);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index c321e768f8d3..8cf010680678 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -248,16 +248,6 @@ void cgroup_freezer_migrate_task(struct task_struct *task,
 	cgroup_freeze_task(task, test_bit(CGRP_FREEZE, &dst->flags));
 }
 
-void cgroup_freezer_frozen_exit(struct task_struct *task)
-{
-	struct cgroup *cgrp = task_dfl_cgroup(task);
-
-	lockdep_assert_held(&css_set_lock);
-
-	cgroup_dec_frozen_cnt(cgrp);
-	cgroup_update_frozen(cgrp);
-}
-
 void cgroup_freeze(struct cgroup *cgrp, bool freeze)
 {
 	struct cgroup_subsys_state *css;
-- 
2.20.1

