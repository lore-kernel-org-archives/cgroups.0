Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD889386426;
	Sat, 18 Jul 2026 08:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362655; cv=none; b=QaYev65BnrZX5oL11P3MRh1gDOoVWmX3Jlm0hu4l/nY9e77MWLOHrRCkk+z0dQHmUyjp4Aj4+kkG4vrTYkSLLtrITI5FzHL8WP6EJbLwg8GsSuq1GsmrgOcUhGzGVzB/ghWEkBQax16qGNubiHTv3K2m4L6N9lPAqQ7+2iZpxBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362655; c=relaxed/simple;
	bh=ZZdsoaNqjRsCK2YzvzFWkcRN8G2T44Ho8bFMDVkGRug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F18ctkdPm02DMY+h7lnqzfQbXZ+BeuvMru+jZv8GLeOyvOmJV4mm0/Sc23ZJdlPx8Xjb4JmYIVrvHDkoRU03OSOciVAUlTHJXRrca0cBiBNksn7K/cqVdenJv/mj4/LPQ74icTZZr5q1vNpTdYg6JzAtL7+Y5J8OjIUPw3/yC8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRXHENlh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRXHENlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9767C1F00A3A;
	Sat, 18 Jul 2026 08:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362653;
	bh=QX5OCvkSWhwiyN3UtHAqpfquPj1Uwt8ux+A1O2J+fTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRXHENlhWxPv/5JxQ5xsNKRhVGGH7VGid70CWow+F6LC6TX4RdhGMSr9BR7GDQMDW
	 pXkzqXTBUAr+jLqLRlkqNxu+sycsBPiiMwn61+jWN3qB01k5ApiVv9QQnFdAZanRDf
	 gzTttNi4t6TnbnqFCPEoAWt8uM1lUKOwqK7qHWWOhnMz7/Z3DVE/Xjg28o6wlWPoSv
	 2l6AqOGh9DN1/D5YAXr8cYSZZOcl9Ch4ryCeOwjRQJ0J3e/agKoWbzZZ8YX+e4Qwn9
	 d+9nQ4JB47RJ+kkFLRm5UR2t+h2tqgRkd2SY4D1d/VwxED7Xmi+io3zBFGCRNFgQ7D
	 +zKdmP7TSlvZA==
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
Subject: [PATCH 5/8] sched_ext: Deliver cgroup ops to each task_group's sched
Date: Fri, 17 Jul 2026 22:17:24 -1000
Message-ID: <20260718081727.582037-6-tj@kernel.org>
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

With sub-schedulers claiming cgroup subtrees, cgroup ops must be delivered
to each task_group's sched rather than always to root. Add tg->scx.sched to
track which sched initialized the task_group. It is set and cleared together
with SCX_TG_INITED.

Deliver the ops accordingly:

- ops.cgroup_exit() goes to the sched whose ops.cgroup_init() it pairs with.

- ops.cgroup_prep_move/move/cancel_move() go to the task's sched, and only
  for moves that don't re-home the task. A re-homing move is reported
  through the ops.exit_task/init_task() pair instead. The cgroups passed to
  the move ops can be outside the sched's inited set as the cpu controller
  can be coarser than the sub-scheduler topology.

- Knobs of a cgroup belong to the parent, so ops.set_weight/idle/bandwidth()
  go to the parent task_group's sched.

All task_groups currently resolve to the root sched, so no behavior changes
until sub-schedulers start claiming cgroups.

While at it, scx_cgroup_init() is restructured so both paths share the
recording.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched/ext.h   |   2 +
 kernel/sched/ext/ext.c      | 157 ++++++++++++++++++++++++++----------
 kernel/sched/ext/internal.h |  34 +++++++-
 3 files changed, 146 insertions(+), 47 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index cce42b21f5f5..a6db5d300f30 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -298,6 +298,8 @@ static inline bool scx_rcu_cpu_stall(const struct cpumask *stalled_mask) { retur
 
 struct scx_task_group {
 #ifdef CONFIG_EXT_GROUP_SCHED
+	struct scx_sched	*sched;
+
 	u32			flags;		/* SCX_TG_* */
 	u32			weight;
 	u64			bw_period_us;
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 6bac68758704..b542900da5a3 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4339,6 +4339,51 @@ void scx_tg_init(struct task_group *tg)
 	tg->scx.idle = false;
 }
 
+/**
+ * scx_tg_sched - Resolve a task_group's sched
+ * @tg: task_group of interest
+ *
+ * Return the sched that @tg's ops.cgroup_init() succeeded on, %NULL if @tg
+ * isn't inited. An autogroup tg has no cgroup of its own and resolves to the
+ * root sched.
+ *
+ * Safe for callers read-locking the ops rwsem. tg->scx.sched rewrites
+ * write-lock it, and tg on/offline can't overlap such callers as a css's files
+ * are created after online and drained before offline.
+ */
+static struct scx_sched *scx_tg_sched(struct task_group *tg)
+{
+	lockdep_assert(lockdep_is_held(&cgroup_mutex) ||
+		       lockdep_is_held(&scx_cgroup_ops_rwsem));
+
+	if (!tg->css.cgroup)
+		tg = &root_task_group;
+	return tg->scx.sched;
+}
+
+/**
+ * scx_tg_knob_sched - Resolve the sched receiving a task_group's knob updates
+ * @tg: task_group of interest
+ *
+ * Knobs of a cgroup belong to the parent. Deliver the set_* ops to the
+ * parent task_group's sched, which equals @tg's own sched everywhere except
+ * at a sub-scheduler attach point, where the sub's parent sched receives
+ * them.
+ *
+ * The callers sit in @tg's cgroup file writes holding the ops rwsem read
+ * side. That extends scx_tg_sched()'s file-write argument to the parent's
+ * sched read: a parent css outlives its children's files.
+ */
+static struct scx_sched *scx_tg_knob_sched(struct task_group *tg)
+{
+	lockdep_assert(lockdep_is_held(&cgroup_mutex) ||
+		       lockdep_is_held(&scx_cgroup_ops_rwsem));
+
+	if (!tg->css.cgroup || !tg->css.parent)
+		return scx_tg_sched(&root_task_group);
+	return scx_tg_sched(css_tg(tg->css.parent));
+}
+
 int scx_tg_online(struct task_group *tg)
 {
 	struct scx_sched *sch = scx_root;
@@ -4359,8 +4404,10 @@ int scx_tg_online(struct task_group *tg)
 			if (ret)
 				ret = scx_ops_sanitize_err(sch, "cgroup_init", ret);
 		}
-		if (ret == 0)
+		if (ret == 0) {
+			tg->scx.sched = sch;
 			tg->scx.flags |= SCX_TG_ONLINE | SCX_TG_INITED;
+		}
 	} else {
 		tg->scx.flags |= SCX_TG_ONLINE;
 	}
@@ -4370,19 +4417,30 @@ int scx_tg_online(struct task_group *tg)
 
 void scx_tg_offline(struct task_group *tg)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch = tg->scx.sched;
 
 	WARN_ON_ONCE(!(tg->scx.flags & SCX_TG_ONLINE));
 
-	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_exit) &&
-	    (tg->scx.flags & SCX_TG_INITED))
+	/* INITED implies non-NULL @sch, test before SCX_HAS_OP() derefs */
+	if (scx_cgroup_enabled && (tg->scx.flags & SCX_TG_INITED) &&
+	    SCX_HAS_OP(sch, cgroup_exit))
 		SCX_CALL_OP(sch, cgroup_exit, NULL, tg->css.cgroup);
+	tg->scx.sched = NULL;
 	tg->scx.flags &= ~(SCX_TG_ONLINE | SCX_TG_INITED);
 }
 
+/*
+ * @p's sched for the cgroup migration paths. Stable as re-homes happen either
+ * at CGROUP_TASK_MIGRATED of the same migration or under scx_cgroup_lock(),
+ * both while holding cgroup_mutex.
+ */
+static struct scx_sched *scx_cgroup_task_sched(struct task_struct *p)
+{
+	return rcu_dereference_protected(p->scx.sched, lockdep_is_held(&cgroup_mutex));
+}
+
 int scx_cgroup_can_attach(struct cgroup_taskset *tset)
 {
-	struct scx_sched *sch = scx_root;
 	struct cgroup_subsys_state *css;
 	struct task_struct *p;
 	int ret;
@@ -4391,6 +4449,7 @@ int scx_cgroup_can_attach(struct cgroup_taskset *tset)
 		return 0;
 
 	cgroup_taskset_for_each(p, css, tset) {
+		struct scx_sched *sch = scx_cgroup_task_sched(p);
 		struct cgroup *from = tg_cgrp(task_group(p));
 		struct cgroup *to = tg_cgrp(css_tg(css));
 
@@ -4404,11 +4463,22 @@ int scx_cgroup_can_attach(struct cgroup_taskset *tset)
 		if (from == to)
 			continue;
 
+		/*
+		 * The cgroup_move ops are delivered to @p's sched, and only for
+		 * moves that don't re-home @p. A re-homing move changes the dfl
+		 * cgroup's sched and is reported through the
+		 * exit_task/init_task pair that the re-homing generates.
+		 */
+		if (!sch || sch != task_css_set(p)->mg_dst_cset->dfl_cgrp->scx_sched)
+			continue;
+
 		if (SCX_HAS_OP(sch, cgroup_prep_move)) {
 			ret = SCX_CALL_OP_RET(sch, cgroup_prep_move, NULL,
 					      p, from, css->cgroup);
-			if (ret)
+			if (ret) {
+				ret = scx_ops_sanitize_err(sch, "cgroup_prep_move", ret);
 				goto err;
+			}
 		}
 
 		p->scx.cgrp_moving_from = from;
@@ -4418,41 +4488,41 @@ int scx_cgroup_can_attach(struct cgroup_taskset *tset)
 
 err:
 	cgroup_taskset_for_each(p, css, tset) {
-		if (SCX_HAS_OP(sch, cgroup_cancel_move) &&
-		    p->scx.cgrp_moving_from)
+		struct scx_sched *sch = scx_cgroup_task_sched(p);
+
+		/* cgrp_moving_from implies non-NULL @sch, test it first */
+		if (p->scx.cgrp_moving_from && SCX_HAS_OP(sch, cgroup_cancel_move))
 			SCX_CALL_OP(sch, cgroup_cancel_move, NULL,
 				    p, p->scx.cgrp_moving_from, css->cgroup);
 		p->scx.cgrp_moving_from = NULL;
 	}
 
-	return scx_ops_sanitize_err(sch, "cgroup_prep_move", ret);
+	return ret;
 }
 
 void scx_cgroup_move_task(struct task_struct *p)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch;
 
 	if (!scx_cgroup_enabled)
 		return;
 
 	/*
-	 * scx_cgroup_can_attach() sets cgrp_moving_from only when the task's
-	 * cgroup changes. Migration keys off css rather than cgroup identity,
-	 * so it can hand an unchanged-cgroup task here with cgrp_moving_from
-	 * NULL. Nothing to report to the BPF scheduler then, so skip it and
-	 * keep prep_move and move paired. Cgroup ops run on the root sched,
-	 * dispatch on the explicit @sch.
+	 * Migration keys off css rather than cgroup identity, so it can hand an
+	 * unchanged-cgroup task here with cgrp_moving_from NULL. Nothing to
+	 * report to the BPF scheduler then, so skip it and keep prep_move and
+	 * move paired.
 	 */
-	if (SCX_HAS_OP(sch, cgroup_move) && p->scx.cgrp_moving_from)
-		__SCX_CALL_OP_TASK(sch, ops, cgroup_move, task_rq(p),
-				   p, p->scx.cgrp_moving_from,
-				   tg_cgrp(task_group(p)));
+	sch = scx_cgroup_task_sched(p);
+	if (p->scx.cgrp_moving_from && SCX_HAS_OP(sch, cgroup_move))
+		SCX_CALL_OP_TASK(sch, cgroup_move, task_rq(p),
+				 p, p->scx.cgrp_moving_from,
+				 tg_cgrp(task_group(p)));
 	p->scx.cgrp_moving_from = NULL;
 }
 
 void scx_cgroup_cancel_attach(struct cgroup_taskset *tset)
 {
-	struct scx_sched *sch = scx_root;
 	struct cgroup_subsys_state *css;
 	struct task_struct *p;
 
@@ -4460,8 +4530,10 @@ void scx_cgroup_cancel_attach(struct cgroup_taskset *tset)
 		return;
 
 	cgroup_taskset_for_each(p, css, tset) {
-		if (SCX_HAS_OP(sch, cgroup_cancel_move) &&
-		    p->scx.cgrp_moving_from)
+		struct scx_sched *sch = scx_cgroup_task_sched(p);
+
+		/* cgrp_moving_from implies non-NULL @sch, test it first */
+		if (p->scx.cgrp_moving_from && SCX_HAS_OP(sch, cgroup_cancel_move))
 			SCX_CALL_OP(sch, cgroup_cancel_move, NULL,
 				    p, p->scx.cgrp_moving_from, css->cgroup);
 		p->scx.cgrp_moving_from = NULL;
@@ -4473,7 +4545,7 @@ void scx_group_set_weight(struct task_group *tg, unsigned long weight)
 	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
-	sch = scx_root;
+	sch = scx_tg_knob_sched(tg);
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_weight) &&
 	    tg->scx.weight != weight)
@@ -4489,7 +4561,7 @@ void scx_group_set_idle(struct task_group *tg, bool idle)
 	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
-	sch = scx_root;
+	sch = scx_tg_knob_sched(tg);
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_idle))
 		SCX_CALL_OP(sch, cgroup_set_idle, NULL, tg_cgrp(tg), idle);
@@ -4506,7 +4578,7 @@ void scx_group_set_bandwidth(struct task_group *tg,
 	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
-	sch = scx_root;
+	sch = scx_tg_knob_sched(tg);
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_bandwidth) &&
 	    (tg->scx.bw_period_us != period_us ||
@@ -4718,6 +4790,7 @@ static void scx_cgroup_exit(struct scx_sched *sch)
 
 		if (!(tg->scx.flags & SCX_TG_INITED))
 			continue;
+		tg->scx.sched = NULL;
 		tg->scx.flags &= ~SCX_TG_INITED;
 
 		if (!sch->ops.cgroup_exit)
@@ -4738,28 +4811,26 @@ static int scx_cgroup_init(struct scx_sched *sch)
 	 */
 	css_for_each_descendant_pre(css, &root_task_group.css) {
 		struct task_group *tg = css_tg(css);
-		struct scx_cgroup_init_args args = {
-			.weight = tg->scx.weight,
-			.bw_period_us = tg->scx.bw_period_us,
-			.bw_quota_us = tg->scx.bw_quota_us,
-			.bw_burst_us = tg->scx.bw_burst_us,
-		};
 
-		if ((tg->scx.flags &
-		     (SCX_TG_ONLINE | SCX_TG_INITED)) != SCX_TG_ONLINE)
+		if ((tg->scx.flags & (SCX_TG_ONLINE | SCX_TG_INITED)) != SCX_TG_ONLINE)
 			continue;
 
-		if (!sch->ops.cgroup_init) {
-			tg->scx.flags |= SCX_TG_INITED;
-			continue;
-		}
+		if (sch->ops.cgroup_init) {
+			struct scx_cgroup_init_args args = {
+				.weight = tg->scx.weight,
+				.bw_period_us = tg->scx.bw_period_us,
+				.bw_quota_us = tg->scx.bw_quota_us,
+				.bw_burst_us = tg->scx.bw_burst_us,
+			};
 
-		ret = SCX_CALL_OP_RET(sch, cgroup_init, NULL,
-				      css->cgroup, &args);
-		if (ret) {
-			scx_error(sch, "ops.cgroup_init() failed (%d)", ret);
-			return ret;
+			ret = SCX_CALL_OP_RET(sch, cgroup_init, NULL, css->cgroup, &args);
+			if (ret) {
+				scx_error(sch, "ops.cgroup_init() failed (%d)", ret);
+				return ret;
+			}
 		}
+
+		tg->scx.sched = sch;
 		tg->scx.flags |= SCX_TG_INITED;
 	}
 
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 23fc95502ea6..ad90d4645a33 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -645,8 +645,14 @@ struct sched_ext_ops {
 	 * @cgrp: cgroup being initialized
 	 * @args: init arguments, see the struct definition
 	 *
-	 * Either the BPF scheduler is being loaded or @cgrp created, initialize
-	 * @cgrp for sched_ext. This operation may block.
+	 * Initialize @cgrp for sched_ext, delivered to @cgrp's sched either
+	 * when the BPF scheduler is being loaded or when @cgrp is created. This
+	 * operation may block.
+	 *
+	 * When the BPF scheduler is being loaded or cgroups are being handed
+	 * over, @cgrp may already have been removed by userspace: a removed
+	 * cgroup stays schedulable until its dying tasks finish their final
+	 * context switches.
 	 *
 	 * Return 0 for success, -errno for failure. An error return while
 	 * loading will abort loading of the BPF scheduler. During cgroup
@@ -659,8 +665,13 @@ struct sched_ext_ops {
 	 * @cgroup_exit: Exit a cgroup
 	 * @cgrp: cgroup being exited
 	 *
-	 * Either the BPF scheduler is being unloaded or @cgrp destroyed, exit
-	 * @cgrp for sched_ext. This operation my block.
+	 * Exit @cgrp for sched_ext, delivered to the sched whose
+	 * ops.cgroup_init() it pairs with, either when the BPF scheduler is
+	 * being unloaded or when @cgrp is destroyed. This operation may block.
+	 *
+	 * For a destroyed @cgrp, delivery follows the last scheduling event on
+	 * it: a removed cgroup stays schedulable until its dying tasks finish
+	 * their final context switches.
 	 */
 	void (*cgroup_exit)(struct cgroup *cgrp);
 
@@ -673,6 +684,12 @@ struct sched_ext_ops {
 	 * Prepare @p for move from cgroup @from to @to. This operation may
 	 * block and can be used for allocations.
 	 *
+	 * The cgroup_move ops are delivered to @p's sched, and only for moves
+	 * that don't re-home @p. A re-homing move is reported through
+	 * ops.exit_task() and ops.init_task() instead. @from and @to can
+	 * reference cgroups the sched never received ops.cgroup_init() for, as
+	 * the cpu controller can be coarser than the sub-scheduler topology.
+	 *
 	 * Return 0 for success, -errno for failure. An error return aborts the
 	 * migration.
 	 */
@@ -708,6 +725,11 @@ struct sched_ext_ops {
 	 * @weight: new weight [1..10000]
 	 *
 	 * Update @cgrp's weight to @weight.
+	 *
+	 * Knobs of a cgroup belong to the parent, so the set_* ops are
+	 * delivered to @cgrp's parent's sched. That sched may never have seen
+	 * ops.cgroup_init() for @cgrp - at a sub-scheduler attach point, the
+	 * parent sched tracks @cgrp through ops.sub_attach() instead.
 	 */
 	void (*cgroup_set_weight)(struct cgroup *cgrp, u32 weight);
 
@@ -728,6 +750,8 @@ struct sched_ext_ops {
 	 * burst temporarily. The specific control mechanism and thus the
 	 * interpretation of @period_us and burstiness is up to the BPF
 	 * scheduler.
+	 *
+	 * Delivery follows the same rule as cgroup_set_weight().
 	 */
 	void (*cgroup_set_bandwidth)(struct cgroup *cgrp,
 				     u64 period_us, u64 quota_us, u64 burst_us);
@@ -740,6 +764,8 @@ struct sched_ext_ops {
 	 * Update @cgrp's idle state to @idle. This callback is invoked when
 	 * a cgroup transitions between idle and non-idle states, allowing the
 	 * BPF scheduler to adjust its behavior accordingly.
+	 *
+	 * Delivery follows the same rule as cgroup_set_weight().
 	 */
 	void (*cgroup_set_idle)(struct cgroup *cgrp, bool idle);
 
-- 
2.55.0

