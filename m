From: Roman Gushchin <guro@fb.com>
Subject: [PATCH 1/2] cgroup: prevent spurious transition into non-frozen state
Date: Fri, 26 Apr 2019 10:59:44 -0700
Message-ID: <20190426175945.2559865-2-guro@fb.com>
References: <20190426175945.2559865-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+UMTNtxqzrE5Cg6Nx66l9gCl1GIuLMdJPrf2D2IS40w=;
 b=qD9mwkaVodyVgKBnuir2SAFuzqVcSGfFaaj/1HyJqtNPbxJUA2vdEtJFd4mrmo3DCpUD
 GKIV56DQWSiH6CO3mzTg/XWPu+iqo7I5h3DJNkVlth6iKpBviCJUjlk3pqaVOp+7tTxq
 Sa4sRe5ZknIc5k5hUnhHRVNbeB0rXkJm/ws= 
In-Reply-To: <20190426175945.2559865-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

If freezing of a cgroup races with waking of a task from
the frozen state (like waiting in vfork() or in do_signal_stop()),
a spurious transition of the cgroup state can happen.

The task enters cgroup_leave_frozen(true), the cgroup->nr_frozen_tasks
counter decrements, and the cgroup is switched to the unfrozen state.

To prevent it, let's reserve cgroup_leave_frozen(true) for
terminating processes and use cgroup_leave_frozen(false) otherwise.

To avoid busy-looping in the signal handling loop waiting
for JOBCTL_TRAP_FREEZE set from the cgroup freezing path,
let's do it explicitly in cgroup_leave_frozen(), if the task
is going to stay frozen.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/cgroup/freezer.c | 16 +++++-----------
 kernel/signal.c         |  2 +-
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 3bfbb3c8baf3..c321e768f8d3 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -139,19 +139,13 @@ void cgroup_leave_frozen(bool always_leave)
 		cgroup_update_frozen(cgrp);
 		WARN_ON_ONCE(!current->frozen);
 		current->frozen = false;
+	} else if (!(current->jobctl & JOBCTL_TRAP_FREEZE)) {
+		spin_lock(&current->sighand->siglock);
+		current->jobctl |= JOBCTL_TRAP_FREEZE;
+		set_thread_flag(TIF_SIGPENDING);
+		spin_unlock(&current->sighand->siglock);
 	}
 	spin_unlock_irq(&css_set_lock);
-
-	if (unlikely(current->frozen)) {
-		/*
-		 * If the task remained in the frozen state,
-		 * make sure it won't reach userspace without
-		 * entering the signal handling loop.
-		 */
-		spin_lock_irq(&current->sighand->siglock);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
 }
 
 /*
diff --git a/kernel/signal.c b/kernel/signal.c
index 095e0fc57b25..16b72f4f14df 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2514,7 +2514,7 @@ bool get_signal(struct ksignal *ksig)
 		 */
 		if (unlikely(cgroup_task_frozen(current))) {
 			spin_unlock_irq(&sighand->siglock);
-			cgroup_leave_frozen(true);
+			cgroup_leave_frozen(false);
 			goto relock;
 		}
 
-- 
2.20.1

