Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0B385506;
	Sat, 18 Jul 2026 08:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362654; cv=none; b=EVemMAFNAAZbvJQpQYNt6Sij2KCBGaFVYPCgHZ47igiwL2jr2fkbnmxrRupKI9juxFb01HDXKQemMfWEDg9/YQKLmcsiq8tZiwaM/IiOPc8Mw8II2o2vhQOC+eJJGfEIWT6wGd1NAWeQ32spm7HFqzWKA6IByixqnBYvDj3ZO58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362654; c=relaxed/simple;
	bh=LzVYM0G3rTbPSRCaQzn51s7OchTJdHGpGlE1eKzGXYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UggbBpWFuP/mtZiy1jAd8fCdQYgd7oxmaPzc1frOH8vNDMo/s+JT7xRufCgRI/lFgGs/J9plUNZNtElbFDFyGAVtAeZgpIa8OF//RYGYs3HPUkxOHkeLztKuvCZYEv6J1Mz57Na5lChv56Rr+zs9shnoszKczhrxpFukaUPKsUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HljTG8z4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HljTG8z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949FF1F000E9;
	Sat, 18 Jul 2026 08:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362652;
	bh=bum8SlmQ0ceBjxlFkPed9Upqkvz003novEgerR7kv9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HljTG8z4Xc1Rt4KFi+/5BSre64glZGlimdsUwxBicdI7qgCfhLKWmkkYbUyWZ40bo
	 bkUolkwG7tnS1wk18H+R7PXzEoRTXMkJvO/+E2DAARRAVRUS89MJ4GERCA3+jLSNAW
	 fqg7MCloUhrbLNbAHQRXVqv4MvWmzZ1mfptbybViq33ijnjTRMajjqMzx+UeS5K0+C
	 nGMNoK/uXTi7RO6U8t1tJ/LybJPUgwdBNTz3T9CiCwiDgnPda3RwwYHVhgwn2uludY
	 3/2xwomHGQ2QzA3e9z//xM3n1osjB5IrvX5wlOMCrhOcifEhecWaqdGXlIpPJEVALb
	 NWH306/Y9PKew==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] sched_ext: Re-home tasks on cgroup migration
Date: Fri, 17 Jul 2026 22:17:23 -1000
Message-ID: <20260718081727.582037-5-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260718081727.582037-1-tj@kernel.org>
References: <20260718081727.582037-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A task's sched (p->scx.sched) must match its cgroup's owner
(cgrp->scx_sched). cgroup migration breaks the invariant:
scx_cgroup_move_task() only fires root's ops.cgroup_move() and never
re-homes the task, leading to wrong-sched scheduling and, once the stale
sched is freed, a use-after-free.

Hook into the new cgroup task migration events and re-home each task whose
destination cgroup is owned by a different sched. The events map naturally
to the transfer: MIGRATING runs the fallible init for the destination sched,
letting it reject the migration the same way ops.cgroup_prep_move() can,
MIGRATED does the re-home, which can't fail, and CANCELED undoes the init
when the migration falls through.

Pre-commit, the task's task_group still reflects the source, so
__scx_init_task() grows an explicit cgroup argument for the migration path
to hand ops.init_task() the destination cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext/ext.c      |  29 +++++---
 kernel/sched/ext/internal.h |   3 +-
 kernel/sched/ext/sub.c      | 135 ++++++++++++++++++++++++++++++++++--
 3 files changed, 152 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index cd99947b4229..6bac68758704 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3485,15 +3485,28 @@ static struct cgroup *tg_cgrp(struct task_group *tg)
 		return &cgrp_dfl_root.cgrp;
 }
 
-#define SCX_INIT_TASK_ARGS_CGROUP(tg)		.cgroup = tg_cgrp(tg),
+#define SCX_INIT_TASK_ARGS_CGROUP(cgrp)		.cgroup = (cgrp),
 
 #else	/* CONFIG_EXT_GROUP_SCHED */
 
-#define SCX_INIT_TASK_ARGS_CGROUP(tg)
+#define SCX_INIT_TASK_ARGS_CGROUP(cgrp)
 
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 
-int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork)
+/**
+ * __scx_init_task - Initialize a task for a sched
+ * @sch: sched to initialize @p for
+ * @p: task of interest
+ * @cgrp: cgroup @p is joining, %NULL for @p's current task_group's cgroup
+ * @fork: %true if @p is being forked
+ *
+ * Pre-commit cgroup migration passes @cgrp explicitly as @p's task_group
+ * still reflects the source.
+ *
+ * Return 0 on success, -errno on failure.
+ */
+int __scx_init_task(struct scx_sched *sch, struct task_struct *p,
+		    struct cgroup *cgrp, bool fork)
 {
 	int ret;
 
@@ -3501,7 +3514,7 @@ int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork)
 
 	if (SCX_HAS_OP(sch, init_task)) {
 		struct scx_init_task_args args = {
-			SCX_INIT_TASK_ARGS_CGROUP(task_group(p))
+			SCX_INIT_TASK_ARGS_CGROUP(cgrp ?: tg_cgrp(task_group(p)))
 			.fork = fork,
 		};
 
@@ -3747,7 +3760,7 @@ int scx_fork(struct task_struct *p, struct kernel_clone_args *kargs)
 		struct scx_sched *sch = scx_root;
 #endif
 		scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
-		ret = __scx_init_task(sch, p, true);
+		ret = __scx_init_task(sch, p, NULL, true);
 		if (unlikely(ret)) {
 			scx_set_task_state(p, SCX_TASK_NONE);
 			return ret;
@@ -5969,8 +5982,8 @@ static void scx_root_disable(struct scx_sched *sch)
 	WRITE_ONCE(scx_switching_all, false);
 
 	/*
-	 * Shut down cgroup support before tasks so that the cgroup attach path
-	 * doesn't race against scx_disable_and_exit_task().
+	 * Shut down cgroup support before tasks so that the cgroup attach and
+	 * migration paths don't race against scx_disable_and_exit_task().
 	 */
 	scx_cgroup_lock();
 	scx_cgroup_enabled = false;
@@ -7263,7 +7276,7 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 		scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
 		scx_task_iter_unlock(&sti);
 
-		ret = __scx_init_task(sch, p, false);
+		ret = __scx_init_task(sch, p, NULL, false);
 
 		scx_task_iter_relock(&sti, p);
 
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index d76ac22019af..23fc95502ea6 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -1920,7 +1920,8 @@ void scx_flush_dispatch_buf(struct scx_sched *sch, struct rq *rq);
 void scx_kick_cpu(struct scx_sched *sch, s32 cpu, u64 flags);
 void schedule_dsq_reenq(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 			u64 reenq_flags, struct rq *locked_rq);
-int __scx_init_task(struct scx_sched *sch, struct task_struct *p, bool fork);
+int __scx_init_task(struct scx_sched *sch, struct task_struct *p,
+		    struct cgroup *cgrp, bool fork);
 void scx_enable_task(struct scx_sched *sch, struct task_struct *p);
 void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p);
 void scx_sub_init_cancel_task(struct scx_sched *sch, struct task_struct *p);
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index 5f7ac6696d17..393dbd00d2f7 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -906,7 +906,7 @@ void scx_sub_disable(struct scx_sched *sch)
 		 * parent. A child can't directly affect the parent through its
 		 * own failures.
 		 */
-		ret = __scx_init_task(parent, p, false);
+		ret = __scx_init_task(parent, p, NULL, false);
 		if (ret) {
 			scx_fail_parent(sch, p, ret);
 			put_task_struct(p);
@@ -1212,7 +1212,7 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 		 * As $p is still on $parent, it can't be transitioned to INIT.
 		 * Let's worry about task state later. Use __scx_init_task().
 		 */
-		ret = __scx_init_task(sch, p, false);
+		ret = __scx_init_task(sch, p, NULL, false);
 		if (ret)
 			goto abort;
 
@@ -1336,6 +1336,99 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 	cmd->ret = 0;
 }
 
+/**
+ * scx_cgroup_task_migrating - Prepare a task for a cgroup migration
+ * @ctx: migration being prepared
+ *
+ * A task's sched must match its cgroup's owner, so a migration that crosses a
+ * sched boundary re-homes the task once committed. Run the fallible part here,
+ * before the migration commits: initialize the task for the destination sched.
+ * A rejection fails the cgroup.procs write.
+ */
+static s32 scx_cgroup_task_migrating(struct cgroup_task_migrate_ctx *ctx)
+{
+	struct task_struct *p = ctx->task;
+	struct scx_sched *to;
+	int ret;
+
+	/*
+	 * Cleared under scx_cgroup_lock() before root disable starts tearing
+	 * down tasks. As cgroup_mutex is held, a set flag guarantees that the
+	 * teardown loop is not running concurrently.
+	 */
+	if (!scx_cgroup_enabled)
+		return NOTIFY_OK;
+
+	to = ctx->dst_dcgrp->scx_sched;
+	if (scx_task_on_sched(to, p))
+		return NOTIFY_OK;
+
+	ret = __scx_init_task(to, p, ctx->dst_dcgrp, false);
+	if (ret)
+		return notifier_from_errno(ret);
+
+	return NOTIFY_OK;
+}
+
+/**
+ * scx_cgroup_task_migrated - Re-home a task that changed cgroups
+ * @ctx: committed migration
+ *
+ * Move the task to its new cgroup's sched, which scx_cgroup_task_migrating()
+ * already initialized it for. Can't fail.
+ *
+ * This is safe against all phases of the destination sched's destruction. A
+ * disable resets cgroup ownership to the parent and re-homes tasks in one
+ * scx_cgroup_lock() section. If that section already ran, the destination would
+ * be the parent. Otherwise, the re-home loop is still ahead and guaranteed to
+ * visit the task, now in the destination cgroup.
+ */
+static void scx_cgroup_task_migrated(struct cgroup_task_migrate_ctx *ctx)
+{
+	struct task_struct *p = ctx->task;
+	struct scx_sched *to;
+	struct rq *rq;
+	struct rq_flags rf;
+
+	if (!scx_cgroup_enabled)
+		return;
+
+	to = ctx->dst_dcgrp->scx_sched;
+	if (scx_task_on_sched(to, p))
+		return;
+
+	rq = task_rq_lock(p, &rf);
+	scx_rehome_task(to, p);
+	task_rq_unlock(rq, p, &rf);
+}
+
+/**
+ * scx_cgroup_task_migrate_canceled - Undo migration preparation
+ * @ctx: canceled migration
+ *
+ * The migration failed after scx_cgroup_task_migrating() initialized the task
+ * for the destination sched. The task stays on its current sched in the source
+ * cgroup. Undo the destination's init.
+ */
+static void scx_cgroup_task_migrate_canceled(struct cgroup_task_migrate_ctx *ctx)
+{
+	struct task_struct *p = ctx->task;
+	struct scx_sched *to;
+	struct rq *rq;
+	struct rq_flags rf;
+
+	if (!scx_cgroup_enabled)
+		return;
+
+	to = ctx->dst_dcgrp->scx_sched;
+	if (scx_task_on_sched(to, p))
+		return;
+
+	rq = task_rq_lock(p, &rf);
+	scx_sub_init_cancel_task(to, p);
+	task_rq_unlock(rq, p, &rf);
+}
+
 static s32 scx_cgroup_lifetime_notify(struct notifier_block *nb,
 				      unsigned long action, void *data)
 {
@@ -1367,12 +1460,42 @@ static struct notifier_block scx_cgroup_lifetime_nb = {
 	.notifier_call = scx_cgroup_lifetime_notify,
 };
 
-static s32 __init scx_cgroup_lifetime_notifier_init(void)
+static s32 scx_cgroup_task_notify(struct notifier_block *nb,
+				  unsigned long action, void *data)
+{
+	struct cgroup_task_migrate_ctx *ctx = data;
+
+	switch (action) {
+	case CGROUP_TASK_MIGRATING:
+		return scx_cgroup_task_migrating(ctx);
+	case CGROUP_TASK_MIGRATED:
+		scx_cgroup_task_migrated(ctx);
+		break;
+	case CGROUP_TASK_MIGRATE_CANCELED:
+		scx_cgroup_task_migrate_canceled(ctx);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block scx_cgroup_task_nb = {
+	.notifier_call = scx_cgroup_task_notify,
+};
+
+static s32 __init scx_cgroup_notifier_init(void)
 {
-	return blocking_notifier_chain_register(&cgroup_lifetime_notifier,
-						&scx_cgroup_lifetime_nb);
+	s32 ret;
+
+	ret = blocking_notifier_chain_register(&cgroup_lifetime_notifier,
+					       &scx_cgroup_lifetime_nb);
+	if (ret)
+		return ret;
+
+	return blocking_notifier_chain_register(&cgroup_task_notifier,
+						&scx_cgroup_task_nb);
 }
-core_initcall(scx_cgroup_lifetime_notifier_init);
+core_initcall(scx_cgroup_notifier_init);
 
 static void scx_pstack_recursion(struct bpf_prog *prog, const char *op)
 {
-- 
2.55.0

