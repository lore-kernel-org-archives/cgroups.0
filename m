From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Wed, 24 Apr 2019 18:02:38 +0200
Message-ID: <20190424160237.GH16167@redhat.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190405174708.1010-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 04/05, Roman Gushchin wrote:
>
> @@ -5830,6 +5926,12 @@ void cgroup_exit(struct task_struct *tsk)
>  		spin_lock_irq(&css_set_lock);
>  		css_set_move_task(tsk, cset, NULL, false);
>  		cset->nr_tasks--;
> +
> +		if (unlikely(cgroup_task_frozen(tsk)))
> +			cgroup_freezer_frozen_exit(tsk);
> +		else if (unlikely(cgroup_task_freeze(tsk)))
> +			cgroup_update_frozen(task_dfl_cgroup(tsk));
> +

Now that I actually applied these patches, I can't understand how can
cgroup_exit() hit cgroup_task_frozen(current)...

A cgroup_task_frozen() task must never return to user-mode or escape
from get_signal() without leave_frozen() or we have a bug?

I must have missed something, could you explain why the patch below is
wrong?

Oleg.


diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3e2efd4..24b8757 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -889,7 +889,6 @@ void cgroup_update_frozen(struct cgroup *cgrp);
 void cgroup_freeze(struct cgroup *cgrp, bool freeze);
 void cgroup_freezer_migrate_task(struct task_struct *task, struct cgroup *src,
 				 struct cgroup *dst);
-void cgroup_freezer_frozen_exit(struct task_struct *task);
 static inline bool cgroup_task_freeze(struct task_struct *task)
 {
 	bool ret;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6f09f9b..3d5f76a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6008,11 +6008,8 @@ void cgroup_exit(struct task_struct *tsk)
 		css_set_move_task(tsk, cset, NULL, false);
 		cset->nr_tasks--;
 
-		if (unlikely(cgroup_task_frozen(tsk)))
-			cgroup_freezer_frozen_exit(tsk);
-		else if (unlikely(cgroup_task_freeze(tsk)))
+		if (unlikely(cgroup_task_freeze(tsk)))
 			cgroup_update_frozen(task_dfl_cgroup(tsk));
-
 		spin_unlock_irq(&css_set_lock);
 	} else {
 		get_css_set(cset);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index b5ccc87..68aa506 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -249,16 +249,6 @@ void cgroup_freezer_migrate_task(struct task_struct *task,
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

