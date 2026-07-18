Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3E8384258;
	Sat, 18 Jul 2026 08:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362659; cv=none; b=YGx5QCPs6B4UTfC3kUk7YIJ+s/pGczO4b2yx7o5baNznKQpJ9OqsYzltwDI1j0sK/OLvMi8hS9+1clanQClBpoxr00rWyTu2LcDRKuQctRrk6fGwbyCC39yLWSIlaAUKog6ktaAdqM+x/Roc1lZLgApFwhPKcPp81ZiOmeTGhLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362659; c=relaxed/simple;
	bh=geZLt1/lCAtzSYgi5u1S6zdCBqK4oz8e6i/7UWeNdZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9gWP08UOjOSwdjdOG3QluBXEeVqiwo85jN5dzd9dozq38AQftUketJn+tnu2hSpuvvU1k+mDd3o4yw/Vz/3d2qFK2ggARVioxqx8C7KL/JbLOpuV3NtR/OJtH+mkaCW1CNN91Tyl9YL3rHJMa4ABJ6U4V8lL0kVtXl5nIhcuVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gz2J4KnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gz2J4KnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993481F00A3D;
	Sat, 18 Jul 2026 08:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362654;
	bh=LAndj6kpWpqnSt0JVMcABxbITAM11K2vFQKrM6pvSHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gz2J4KnS+DRzbSdl3OH5XkhxPEUtJCW9+5iqeMz3jwlFgdiB1tjy3u7RIut/RaPoX
	 LpJaZ0ujLq99TScZYAl6sOc+nEBprV7aUkopgiuVga2IY4Y2Ikqf/guGO/HmkefZ8h
	 AJenZNNq3aR/zIw88i70Ijc9z3gH0Va0G0r5eDEbjLkN+1uQeEx++gQu9P2CZGxD1o
	 Lx71jMir3Zzg66cEt7mN/NPnJ9xDccUgZ7gQ/UIll35dRYMLdxap4eZlYydIoK6fww
	 iAPqkIDo9juaSoF49buylegB++hujGJDNzcc0YZ+7GbotnmZtIuL528VaHjRrvpvkF
	 VLZaHK5AAGHUw==
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
Subject: [PATCH 6/8] sched_ext: Hand over cgroups at sub-scheduler enable/disable
Date: Fri, 17 Jul 2026 22:17:25 -1000
Message-ID: <20260718081727.582037-7-tj@kernel.org>
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

Sub-schedulers don't get cgroups yet: every task_group is inited on the root
sched and the routing added by the previous patches always resolves to it.
Add the handover: an enabling sub-scheduler takes over the cgroups in its
subtree and a disabling one returns them to its parent.

scx_cgroup_claim_subtree() runs while the sub enables, after the subtree's
cgrp->scx_sched's are set and before any task is claimed. It inits each
subtree task_group on the sub, exits it from the parent and updates
tg->scx.sched. A failed ops.cgroup_init() unwinds the sub-side inits and
aborts the enable with the parent untouched.

Disabling reverses it with scx_cgroup_return_subtree(): exit each cgroup
from the sub, then re-init it on the parent with the current tg->scx.*
values, resyncing weight and bandwidth changes made while the sub had it.
When a re-init fails, the parent is failed and the remaining task_groups
still transfer uninited and get no cgroup ops - the same punting done for
tasks. The dying parent's own disable moves them onward.

The handover walks include dying but not yet offlined task_groups, the same
as root's bulk walks: a removed cgroup keeps hosting scheduling events until
its dying tasks finish their final context switches, and its
ops.cgroup_exit() must follow the last of them. tg on/offlining is excluded
through cgroup_lock(), so either ordering against an rmdir of a subtree
cgroup delivers balanced init/exit pairs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched/ext.h   |  13 +++
 kernel/sched/ext/ext.c      |  45 +++++---
 kernel/sched/ext/internal.h |   6 ++
 kernel/sched/ext/sub.c      | 199 ++++++++++++++++++++++++++++++++++++
 4 files changed, 250 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index a6db5d300f30..78b2f289cb98 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -298,6 +298,19 @@ static inline bool scx_rcu_cpu_stall(const struct cpumask *stalled_mask) { retur
 
 struct scx_task_group {
 #ifdef CONFIG_EXT_GROUP_SCHED
+	/*
+	 * The sched this tg is on, NULL if none. SCX_TG_INITED tracks whether
+	 * ops.cgroup_init() succeeded on it. When a child sched exits and its
+	 * tgs move to the parent, a failed init leaves the tg on the parent
+	 * with INITED clear (see scx_cgroup_return_subtree()).
+	 *
+	 * This is tracked separately from cgrp->scx_sched because the tg
+	 * hierarchy can diverge from the cgroup2 hierarchy in both lifetime and
+	 * shape. A tg stays online past its cgroup's removal while the
+	 * cgrp->scx_sched rewrites visit only live cgroups, leaving a removed
+	 * cgroup's pointer stale. The cpu controller can also be mounted on
+	 * cgroup1.
+	 */
 	struct scx_sched	*sched;
 
 	u32			flags;		/* SCX_TG_* */
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index b542900da5a3..58cd971e5fc5 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -4347,6 +4347,11 @@ void scx_tg_init(struct task_group *tg)
  * isn't inited. An autogroup tg has no cgroup of its own and resolves to the
  * root sched.
  *
+ * When a child sched exits, its task_groups are moved to the parent and
+ * re-inited on it. A failed re-init fails the parent in turn and leaves the
+ * task_group without a sched it's inited on, resolving to %NULL. See
+ * scx_cgroup_return_subtree().
+ *
  * Safe for callers read-locking the ops rwsem. tg->scx.sched rewrites
  * write-lock it, and tg on/offline can't overlap such callers as a css's files
  * are created after online and drained before offline.
@@ -4358,7 +4363,8 @@ static struct scx_sched *scx_tg_sched(struct task_group *tg)
 
 	if (!tg->css.cgroup)
 		tg = &root_task_group;
-	return tg->scx.sched;
+	/* INITED means ops.cgroup_init() succeeded on @tg->scx.sched */
+	return (tg->scx.flags & SCX_TG_INITED) ? tg->scx.sched : NULL;
 }
 
 /**
@@ -4370,6 +4376,9 @@ static struct scx_sched *scx_tg_sched(struct task_group *tg)
  * at a sub-scheduler attach point, where the sub's parent sched receives
  * them.
  *
+ * Return %NULL if the parent task_group has no sched. That can happen when the
+ * parent's ops.cgroup_init() fails while a sub-scheduler is being disabled.
+ *
  * The callers sit in @tg's cgroup file writes holding the ops rwsem read
  * side. That extends scx_tg_sched()'s file-write argument to the parent's
  * sched read: a parent css outlives its children's files.
@@ -4386,12 +4395,24 @@ static struct scx_sched *scx_tg_knob_sched(struct task_group *tg)
 
 int scx_tg_online(struct task_group *tg)
 {
-	struct scx_sched *sch = scx_root;
 	int ret = 0;
 
 	WARN_ON_ONCE(tg->scx.flags & (SCX_TG_ONLINE | SCX_TG_INITED));
 
 	if (scx_cgroup_enabled) {
+		struct scx_sched *sch;
+
+		/*
+		 * The cgroup lifetime notifier populates cgrp->scx_sched before
+		 * css_online, but only on the default hierarchy. Sub-scheds are
+		 * attached to the cgroup2 hierarchy, so a cgroup1 task_group
+		 * always belongs to the root sched.
+		 */
+		if (cgroup_on_dfl(tg->css.cgroup))
+			sch = tg->css.cgroup->scx_sched;
+		else
+			sch = scx_tg_sched(&root_task_group);
+
 		if (SCX_HAS_OP(sch, cgroup_init)) {
 			struct scx_cgroup_init_args args =
 				{ .weight = tg->scx.weight,
@@ -4547,7 +4568,7 @@ void scx_group_set_weight(struct task_group *tg, unsigned long weight)
 	percpu_down_read(&scx_cgroup_ops_rwsem);
 	sch = scx_tg_knob_sched(tg);
 
-	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_weight) &&
+	if (scx_cgroup_enabled && sch && SCX_HAS_OP(sch, cgroup_set_weight) &&
 	    tg->scx.weight != weight)
 		SCX_CALL_OP(sch, cgroup_set_weight, NULL, tg_cgrp(tg), weight);
 
@@ -4563,7 +4584,7 @@ void scx_group_set_idle(struct task_group *tg, bool idle)
 	percpu_down_read(&scx_cgroup_ops_rwsem);
 	sch = scx_tg_knob_sched(tg);
 
-	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_idle))
+	if (scx_cgroup_enabled && sch && SCX_HAS_OP(sch, cgroup_set_idle))
 		SCX_CALL_OP(sch, cgroup_set_idle, NULL, tg_cgrp(tg), idle);
 
 	/* Update the task group's idle state */
@@ -4580,7 +4601,7 @@ void scx_group_set_bandwidth(struct task_group *tg,
 	percpu_down_read(&scx_cgroup_ops_rwsem);
 	sch = scx_tg_knob_sched(tg);
 
-	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_bandwidth) &&
+	if (scx_cgroup_enabled && sch && SCX_HAS_OP(sch, cgroup_set_bandwidth) &&
 	    (tg->scx.bw_period_us != period_us ||
 	     tg->scx.bw_quota_us != quota_us ||
 	     tg->scx.bw_burst_us != burst_us))
@@ -4788,15 +4809,13 @@ static void scx_cgroup_exit(struct scx_sched *sch)
 	css_for_each_descendant_post(css, &root_task_group.css) {
 		struct task_group *tg = css_tg(css);
 
-		if (!(tg->scx.flags & SCX_TG_INITED))
-			continue;
+		/* also clear the sched of tgs whose ops.cgroup_init() failed */
 		tg->scx.sched = NULL;
-		tg->scx.flags &= ~SCX_TG_INITED;
-
-		if (!sch->ops.cgroup_exit)
-			continue;
-
-		SCX_CALL_OP(sch, cgroup_exit, NULL, css->cgroup);
+		if (tg->scx.flags & SCX_TG_INITED) {
+			tg->scx.flags &= ~SCX_TG_INITED;
+			if (sch->ops.cgroup_exit)
+				SCX_CALL_OP(sch, cgroup_exit, NULL, css->cgroup);
+		}
 	}
 }
 
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index ad90d4645a33..0c0a8fdaa2c4 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -649,6 +649,11 @@ struct sched_ext_ops {
 	 * when the BPF scheduler is being loaded or when @cgrp is created. This
 	 * operation may block.
 	 *
+	 * Cgroup handovers also generate these ops: an enabling sub-scheduler
+	 * receives ops.cgroup_init() for every cgroup in its subtree while the
+	 * previous sched receives ops.cgroup_exit(), and disabling reverses the
+	 * two.
+	 *
 	 * When the BPF scheduler is being loaded or cgroups are being handed
 	 * over, @cgrp may already have been removed by userspace: a removed
 	 * cgroup stays schedulable until its dying tasks finish their final
@@ -1722,6 +1727,7 @@ enum scx_kick_flags {
 enum scx_tg_flags {
 	SCX_TG_ONLINE		= 1U << 0,
 	SCX_TG_INITED		= 1U << 1,
+	SCX_TG_SUB_INIT		= 1U << 2,	/* see scx_cgroup_claim_subtree() */
 };
 
 enum scx_enable_state {
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index 393dbd00d2f7..8d8737149bc0 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -836,6 +836,191 @@ static void scx_fail_parent(struct scx_sched *sch,
 	scx_task_iter_stop(&sti);
 }
 
+#ifdef CONFIG_EXT_GROUP_SCHED
+/**
+ * scx_cgroup_claim_subtree - Claim the subtree's cgroups for an enabling sub
+ * @sch: sub-scheduler being enabled
+ *
+ * Called while enabling @sch, after the subtree's cgrp->scx_sched's are pointed
+ * at @sch and before any task is claimed. This mirrors root enable's
+ * cgroups-before-tasks order. The ops.init_task() args are task_group-granular
+ * and can still reference a cgroup outside the handed-over set when the cpu
+ * controller is coarser than the sub topology or mounted on cgroup1.
+ *
+ * First init each of the parent sched's subtree cgroups on @sch, and only then
+ * exit them from the parent, so that a failed init can be unwound with the
+ * parent untouched. The both-inited transient is invisible outside
+ * scx_cgroup_lock(). %SCX_TG_SUB_INIT tracks the first pass's progress.
+ * %SCX_TG_INITED stays set throughout, except for a task_group whose
+ * ops.cgroup_init() failed on the parent (see scx_cgroup_return_subtree()):
+ * there is nothing to exit from the parent and %SCX_TG_INITED is set back with
+ * the transfer.
+ *
+ * Dying but not yet offlined task_groups are included: a removed cgroup keeps
+ * hosting scheduling events until its dying tasks finish their final context
+ * switches, so it still needs to be inited on a sched, and its offline-time
+ * ops.cgroup_exit() follows the last of those events.
+ *
+ * Return 0 on success, -errno on failure. On failure, @sch has been
+ * scx_error()'d and is left with no cgroups.
+ */
+static s32 scx_cgroup_claim_subtree(struct scx_sched *sch)
+{
+	struct cgroup *sub_cgrp = sch_cgroup(sch);
+	struct cgroup_subsys_state *ecss = cgroup_e_css(sub_cgrp, &cpu_cgrp_subsys);
+	struct scx_sched *parent = scx_parent(sch);
+	struct cgroup_subsys_state *css;
+	int ret;
+
+	css_for_each_descendant_pre(css, ecss) {
+		struct task_group *tg = css_tg(css);
+		struct scx_cgroup_init_args args = {
+			.weight = tg->scx.weight,
+			.bw_period_us = tg->scx.bw_period_us,
+			.bw_quota_us = tg->scx.bw_quota_us,
+			.bw_burst_us = tg->scx.bw_burst_us,
+		};
+
+		if (tg->scx.sched != parent ||
+		    !cgroup_is_descendant(css->cgroup, sub_cgrp))
+			continue;
+
+		if (SCX_HAS_OP(sch, cgroup_init)) {
+			ret = SCX_CALL_OP_RET(sch, cgroup_init, NULL, css->cgroup, &args);
+			if (ret) {
+				scx_error(sch, "ops.cgroup_init() failed (%d)", ret);
+				goto err;
+			}
+		}
+		tg->scx.flags |= SCX_TG_SUB_INIT;
+	}
+
+	css_for_each_descendant_post(css, ecss) {
+		struct task_group *tg = css_tg(css);
+
+		/*
+		 * SUB_INIT is pass 1's progress mark: pass 2 and the err path
+		 * must visit exactly the tgs pass 1 inited.
+		 */
+		if (!(tg->scx.flags & SCX_TG_SUB_INIT))
+			continue;
+
+		/* skip the exit if the parent's ops.cgroup_init() failed */
+		if ((tg->scx.flags & SCX_TG_INITED) && SCX_HAS_OP(parent, cgroup_exit))
+			SCX_CALL_OP(parent, cgroup_exit, NULL, css->cgroup);
+		tg->scx.sched = sch;
+		tg->scx.flags |= SCX_TG_INITED;
+		tg->scx.flags &= ~SCX_TG_SUB_INIT;
+	}
+
+	return 0;
+
+err:
+	css_for_each_descendant_post(css, ecss) {
+		struct task_group *tg = css_tg(css);
+
+		if (!(tg->scx.flags & SCX_TG_SUB_INIT))
+			continue;
+
+		if (SCX_HAS_OP(sch, cgroup_exit))
+			SCX_CALL_OP(sch, cgroup_exit, NULL, css->cgroup);
+		tg->scx.flags &= ~SCX_TG_SUB_INIT;
+	}
+	return ret;
+}
+
+/**
+ * scx_cgroup_return_subtree - Return the subtree's cgroups to the parent sched
+ * @sch: sub-scheduler being disabled
+ *
+ * Called while disabling @sch, after the subtree's cgrp->scx_sched's are reset
+ * to the parent sched and before tasks are re-homed, mirroring root disable's
+ * cgroups-before-tasks teardown order. The reverse of
+ * scx_cgroup_claim_subtree(): exit @sch's cgroups from @sch, then init them on
+ * the parent with the current tg->scx.* values, resyncing settings that changed
+ * while @sch had them.
+ *
+ * When an init on the parent fails, the parent is failed - the same policy as
+ * task re-homing. The remaining task_groups are punted: they move to the parent
+ * anyway with %SCX_TG_INITED cleared, as ops.cgroup_init() failed or never ran
+ * for them. A punted task_group gets no cgroup ops. The dying parent's own
+ * disable moves it one sched up, initing it there. Root ends the chain: root
+ * teardown drops cgroup ops entirely and the next enable's bulk init re-inits
+ * every online task_group.
+ *
+ * The task re-home that follows still delivers ops.init_task() to the dying
+ * parent, including for tasks in punted cgroups it never inited - tolerated
+ * like the downstream failures of task punting (see scx_punt_task()).
+ */
+static void scx_cgroup_return_subtree(struct scx_sched *sch)
+{
+	struct cgroup *sub_cgrp = sch_cgroup(sch);
+	struct cgroup_subsys_state *ecss = cgroup_e_css(sub_cgrp, &cpu_cgrp_subsys);
+	struct scx_sched *parent = scx_parent(sch);
+	struct cgroup_subsys_state *css;
+	bool parent_failed = false;
+	int ret;
+
+	css_for_each_descendant_post(css, ecss) {
+		struct task_group *tg = css_tg(css);
+
+		if (tg->scx.sched != sch ||
+		    !cgroup_is_descendant(css->cgroup, sub_cgrp))
+			continue;
+
+		/* skip the exit if @sch's ops.cgroup_init() failed for the tg */
+		if ((tg->scx.flags & SCX_TG_INITED) && SCX_HAS_OP(sch, cgroup_exit))
+			SCX_CALL_OP(sch, cgroup_exit, NULL, css->cgroup);
+		tg->scx.sched = parent;
+		tg->scx.flags |= SCX_TG_SUB_INIT;
+	}
+
+	css_for_each_descendant_pre(css, ecss) {
+		struct task_group *tg = css_tg(css);
+		struct scx_cgroup_init_args args = {
+			.weight = tg->scx.weight,
+			.bw_period_us = tg->scx.bw_period_us,
+			.bw_quota_us = tg->scx.bw_quota_us,
+			.bw_burst_us = tg->scx.bw_burst_us,
+		};
+
+		/* the first pass must have transferred everything */
+		WARN_ON_ONCE(tg->scx.sched == sch);
+
+		/*
+		 * SUB_INIT distinguishes the tgs pass 1 moved. The sched test
+		 * can't: a tg punted to the parent by an earlier failure would
+		 * also match.
+		 */
+		if (!(tg->scx.flags & SCX_TG_SUB_INIT))
+			continue;
+		tg->scx.flags &= ~(SCX_TG_SUB_INIT | SCX_TG_INITED);
+
+		/*
+		 * A re-init on $parent failed. The task_groups from here on are
+		 * punted: they stay on the dying $parent with INITED clear and
+		 * move onward when it disables.
+		 */
+		if (parent_failed)
+			continue;
+
+		if (SCX_HAS_OP(parent, cgroup_init)) {
+			ret = SCX_CALL_OP_RET(parent, cgroup_init, NULL, css->cgroup, &args);
+			if (ret) {
+				scx_error(parent, "ops.cgroup_init() failed (%d) while disabling a sub-scheduler",
+					  ret);
+				parent_failed = true;
+				continue;
+			}
+		}
+		tg->scx.flags |= SCX_TG_INITED;
+	}
+}
+#else
+static inline s32 scx_cgroup_claim_subtree(struct scx_sched *sch) { return 0; }
+static inline void scx_cgroup_return_subtree(struct scx_sched *sch) {}
+#endif
+
 void scx_sub_disable(struct scx_sched *sch)
 {
 	struct scx_sched *parent = scx_parent(sch);
@@ -871,6 +1056,12 @@ void scx_sub_disable(struct scx_sched *sch)
 
 	set_cgroup_sched(sch_cgroup(sch), parent);
 
+	/*
+	 * Return the subtree's cgroups before re-homing tasks so that any
+	 * ops.init_task() on $parent only sees cgroups it has initialized.
+	 */
+	scx_cgroup_return_subtree(sch);
+
 	scx_task_iter_start(&sti, sch->cgrp);
 	while ((p = scx_task_iter_next_locked(&sti))) {
 		struct rq *rq;
@@ -1172,6 +1363,14 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 		goto err_unlock_and_disable;
 	}
 
+	/*
+	 * Take over the subtree's cgroups before any task is claimed,
+	 * mirroring root enable's cgroups-before-tasks order.
+	 */
+	ret = scx_cgroup_claim_subtree(sch);
+	if (ret)
+		goto err_unlock_and_disable;
+
 	/*
 	 * Initialize tasks for the new child $sch without exiting them for
 	 * $parent so that the tasks can always be reverted back to $parent
-- 
2.55.0

