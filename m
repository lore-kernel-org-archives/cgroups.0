Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855970;
	b=2ZVLGdfRgBcbfazlNKXoIRGvVGT6m6Ws8faTQFzCB54e4DZwXsmfu9Tu//szgVC50f89
	 iY+e1Fw25pBG4+aI+QJhfM1o0Ipvg36NZAVC649V/y6oDzC0W8wGTI2EFyzDcPQ+/uED8
	 2xRqS380DNPEzW53/7F+jBDYsx8QGvHfckTetrxQ2IGLK160g/lV66RKFpeUikITfedVp
	 lLDfOYa6da9wKmAdrmqWZymA3gxe6WrJhcJ79mi0BAJMhe6EY6XbLYaBkzH34s1aBosY0
	 e6PR9Qm+RAyprrCMgKXqT+kPidLNLBqMJ128h/FkJVWn/NjwqG2KU5KCrP4JM53b65Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bct2+vT3V4ANmb6rte1WMktwtR1FYrZL0Jic2SxiyuM=;
	b=Izvb2Q3NvR7l7pJ6hIRyLW91N+TpB7lpj/0r9xp3hckiKb5sR4EQKsGiG+yZDeFQHVw+
	 PA8Mr7Jrlr8XGLl3l0XN/jUethJehqijfFhBaux25F7o2s0U8iCEEZkMc/qhFCPMohkqX
	 j3/OkmDJXSZ690vAU2MynKfnroZ0sQGpVB35E5de3778OSaD61JPFQNa2qKgM9qPdH71+
	 vb/augOL24//gCIDUEz/PvrySU0Wj3rgH2h6jzNErQV3Cd2Jr3eQ+yVu0j4puc/cL3hh8
	 dy9vi64rXJUMx2LxLpm9Q3lbS/mFW32FPpAylLf/FUOGiO+V+DqvfN26oZ/NkgmaWuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=o82Wecwe;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21B060A5BFD;
	Mon, 16 Nov 2026 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F21B060A5BFD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=o82Wecwe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855959;
	bh=bct2+vT3V4ANmb6rte1WMktwtR1FYrZL0Jic2SxiyuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o82WecweCukx4UppNY50FyEcS/4u+gTjWXT0EFmIj517SQ+Nw6b+O/q1HJ6nawFAI
	 7Gnk80oMgRXmdi3v+n5Aw/xN2dgMIhX61QM9xYaGA2mf7CHsVU7qIPZ4gKVxUp5h1z
	 h/slB0FNjtnZj7OR6UX0zAzXUWrpQ9gY5e3wczpKXG0UGNN7P3uZwbSOTY163ECQIZ
	 2xgAEF506ztTfvpszKIvQe9EjP6+L0sHAu2sO4YB0DXIb+creoppwZtyJaD2iS2EBD
	 9kD8IDaXc2aMh9+YvCEGIkWtPkBw6iZeikH2ChIQg8h7dQFYS+6m1tzgmhy1kK84Rm
	 KKMMusAx+kDjA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4k6LzhzQSx;
	Mon, 16 Nov 2026 14:05:58 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v6 28/37] cgroup/cpuset: Refuse to take a deadline task out of its root domain
Date: Mon, 16 Nov 2026 14:05:40 -0500
Message-Id: <20261116190549.230119-29-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A cpuset attach asks the destination root domain for room before it
moves a deadline task there. A change of the CPUs of a cpuset asks
nothing. validate_change() only checks that a partition root keeps
enough capacity for its deadline bandwidth. That check comes from
commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
cpusets don't break AC").

With isolcpus="domain", a cpuset that is not a partition root can hold
housekeeping CPUs and isolated CPUs, which are in two root domains. Two
changes can take every CPU of one root domain away from that cpuset:

 - a write to cpuset.cpus, of that cpuset or of an ancestor;
 - a partition root that takes those CPUs, when it is created or when
   it grows.

A deadline task counted in that root domain then runs in the other one,
which did not admit it. Its bandwidth follows with no admission test,
and that root domain can exceed its limit.

Refuse both:

 - A write to cpuset.cpus fails with EBUSY, and changes nothing. The
   cpuset.cpus file of cgroup v1 gets the same check.
 - The write that makes the partition root, or makes it grow, still
   succeeds. cpuset makes the partition root invalid. For a "root"
   partition, cpuset.cpus.partition then reads "root invalid (Deadline
   task would leave its root domain)".

A task goes to another root domain by a move to another cpuset, which
asks for room.

A change that leaves each deadline task a CPU in its root domain is
accepted as before.

dl_task_keeps_root_domain() tells whether a new mask keeps a task in
the root domain that counts it. Without admission control it accepts
any mask: there is no limit to exceed. An administrator who needs the
change can turn admission control off, by writing -1 to
/proc/sys/kernel/sched_rt_runtime_us.

The cases mask_out_refused and partition_takes_refused of
deadline_bw_test, added later in this series, test this. Without this
patch the write is accepted and the partition root is valid.

Fixes: f82f80426f7a ("sched/deadline: Ensure that updates to exclusive cpusets don't break AC")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h  |   2 +
 kernel/cgroup/cpuset-internal.h |   1 +
 kernel/cgroup/cpuset.c          | 179 +++++++++++++++++++++++++++++++-
 kernel/sched/deadline.c         |  19 ++++
 4 files changed, 198 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index cbb7cd71db58..d3796d874aa2 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -61,6 +61,8 @@ extern int dl_task_bw_reserve_cpu(struct task_struct *p,
 				  const struct cpumask *new_mask);
 extern int dl_task_bw_reserved_cpu(struct task_struct *p);
 extern void dl_task_bw_unreserve(struct task_struct *p);
+extern bool dl_task_keeps_root_domain(struct task_struct *p,
+				      const struct cpumask *new_mask);
 
 static inline bool dl_server(struct sched_dl_entity *dl_se)
 {
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index a83443dfb788..8fe0225704eb 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -36,6 +36,7 @@ enum prs_errcode {
 	PERR_ACCESS,
 	PERR_REMOTE,
 	PERR_ISOPARENT,
+	PERR_DLTASK,
 };
 
 /* bits in struct cpuset flags field */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ef5ad8e38f06..5b4f7d4ef3ae 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -61,6 +61,7 @@ static const char * const perr_strings[] = {
 	[PERR_ACCESS]    = "Enable partition not permitted",
 	[PERR_REMOTE]    = "Have remote partition underneath",
 	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
+	[PERR_DLTASK]    = "Deadline task would leave its root domain",
 };
 
 /*
@@ -1126,6 +1127,92 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 		cpuset_force_rebuild();
 }
 
+/*
+ * Return false if the CPUs of @new_cpus make a deadline task of @cp leave
+ * the root domain that counts its bandwidth. Called under rcu_read_lock(),
+ * which it drops and takes again.
+ */
+static bool dl_tasks_keep_cpus(struct cpuset *cp, const struct cpumask *new_cpus)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+	bool keep = true;
+
+	if (!css_tryget_online(&cp->css))
+		return true;
+	rcu_read_unlock();
+
+	css_task_iter_start(&cp->css, 0, &it);
+	while (keep && (task = css_task_iter_next(&it))) {
+		/* The top cpuset leaves the mask of these tasks alone. */
+		if (cp == &top_cpuset &&
+		    (task->flags & (PF_KTHREAD | PF_NO_SETAFFINITY)))
+			continue;
+		keep = dl_task_keeps_root_domain(task, new_cpus);
+	}
+	css_task_iter_end(&it);
+
+	rcu_read_lock();
+	css_put(&cp->css);
+	return keep;
+}
+
+/*
+ * Return false if a partition that takes the CPUs of @xcpus makes a
+ * deadline task leave the root domain that counts its bandwidth. A cpuset
+ * holds CPUs of two root domains only with isolcpus="domain". Such a task
+ * would run in a root domain that did not admit it.
+ *
+ * @root is the partition root that gives the CPUs. Its cpusets lose them,
+ * down to the next partition roots. A cpuset left with no CPU gets those
+ * of its nearest ancestor that keeps one. @part is the cpuset that takes
+ * the CPUs. If @enable, it becomes a partition root: its own cpusets keep
+ * only CPUs of @xcpus. @new_cpus is a temporary mask.
+ */
+static bool dl_tasks_keep_without(struct cpuset *root, struct cpuset *part,
+				  const struct cpumask *xcpus, bool enable,
+				  struct cpumask *new_cpus)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp, *a;
+	bool keep = true;
+
+	rcu_read_lock();
+	cpuset_for_each_descendant_pre(cp, pos_css, root) {
+		if (cp == part || (cp != root && is_partition_valid(cp))) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
+		}
+		if (!cpumask_intersects(cp->effective_cpus, xcpus))
+			continue;
+		for (a = cp; ; a = parent_cs(a)) {
+			if (cpumask_andnot(new_cpus, a->effective_cpus, xcpus) ||
+			    a == root)
+				break;
+		}
+		keep = dl_tasks_keep_cpus(cp, new_cpus);
+		if (!keep)
+			break;
+	}
+	if (keep && enable) {
+		cpuset_for_each_descendant_pre(cp, pos_css, part) {
+			if (cp != part && is_partition_valid(cp)) {
+				pos_css = css_rightmost_descendant(pos_css);
+				continue;
+			}
+			if (cpumask_subset(cp->effective_cpus, xcpus))
+				continue;
+			if (!cpumask_and(new_cpus, cp->effective_cpus, xcpus))
+				cpumask_copy(new_cpus, xcpus);
+			keep = dl_tasks_keep_cpus(cp, new_cpus);
+			if (!keep)
+				break;
+		}
+	}
+	rcu_read_unlock();
+	return keep;
+}
+
 /*
  * tasks_nocpu_error - Return true if tasks will have no effective_cpus
  */
@@ -1676,6 +1763,8 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_NOCPUS;
 	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
+	if (!dl_tasks_keep_without(&top_cpuset, cs, tmp->new_cpus, true, tmp->addmask))
+		return PERR_DLTASK;
 
 	spin_lock_irq(&callback_lock);
 	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
@@ -1779,6 +1868,9 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
 						       excpus, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
+		else if (!dl_tasks_keep_without(&top_cpuset, cs, tmp->addmask,
+						false, tmp->new_cpus))
+			WRITE_ONCE(cs->prs_err, PERR_DLTASK);
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -1926,6 +2018,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (nocpu)
 			return PERR_NOCPUS;
 
+		if (!dl_tasks_keep_without(parent, cs, tmp->delmask, true,
+					   tmp->new_cpus))
+			return PERR_DLTASK;
+
 		/*
 		 * This function will only be called when all the preliminary
 		 * checks have passed. At this point, the following condition
@@ -2013,6 +2109,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			deleting = false;
 			adding = cpumask_and(tmp->addmask,
 					     cs->effective_xcpus, parent->effective_xcpus);
+		} else if (deleting &&
+			   !dl_tasks_keep_without(parent, cs, tmp->delmask,
+						  is_partition_invalid(cs),
+						  tmp->new_cpus)) {
+			/* As above: the partition becomes invalid. */
+			part_error = PERR_DLTASK;
+			deleting = false;
+			adding = cpumask_and(tmp->addmask,
+					     cs->effective_xcpus, parent->effective_xcpus);
 		}
 	} else {
 		/*
@@ -2084,10 +2189,13 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 				}
 				rcu_read_unlock();
 			}
-			if (exclusive)
-				deleting = !cpumask_empty(tmp->delmask);
-			else
+			if (!exclusive)
 				part_error = PERR_NOTEXCL;
+			else if (!dl_tasks_keep_without(parent, cs, tmp->delmask,
+							true, tmp->new_cpus))
+				part_error = PERR_DLTASK;
+			else
+				deleting = !cpumask_empty(tmp->delmask);
 		}
 		/*
 		 * When both cs and parent remain valid, parent's
@@ -2496,6 +2604,66 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 	}
 }
 
+/*
+ * Set @new_cpus to the effective CPUs that @cp gets if @cs takes the CPUs
+ * of @trialcs. @cp is @cs or one of its descendants.
+ */
+static void trial_effective_cpus(struct cpuset *cp, struct cpuset *cs,
+				 struct cpuset *trialcs, struct cpumask *new_cpus)
+{
+	struct cpuset *parent = parent_cs(cs), *a;
+	int depth = 0, i;
+
+	if (!cpumask_and(new_cpus, trialcs->cpus_allowed, parent->effective_cpus) &&
+	    is_in_v2_mode())
+		cpumask_copy(new_cpus, parent->effective_cpus);
+	for (a = cp; a != cs; a = parent_cs(a))
+		depth++;
+	/* From the child of @cs down to @cp, as compute_effective_cpumask(). */
+	while (depth--) {
+		for (a = cp, i = 0; i < depth; i++)
+			a = parent_cs(a);
+		if (cpumask_intersects(new_cpus, a->cpus_allowed) || !is_in_v2_mode())
+			cpumask_and(new_cpus, new_cpus, a->cpus_allowed);
+	}
+}
+
+/*
+ * Return false if the CPUs of @trialcs make a deadline task of @cs, or of
+ * a descendant, leave the root domain that counts its bandwidth. A cpuset
+ * holds CPUs of two root domains only with isolcpus="domain". The task
+ * would run in a root domain that did not admit it. A move of the task to
+ * another cpuset is the way there: it asks the other root domain for room.
+ *
+ * A partition root takes its CPUs from its parent, which checks the same
+ * for its own tasks: see dl_tasks_keep_without().
+ */
+static bool dl_tasks_keep_root_domain(struct cpuset *cs, struct cpuset *trialcs,
+				      struct cpumask *new_cpus)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp;
+	bool keep = true;
+
+	if (is_partition_valid(cs))
+		return true;
+	rcu_read_lock();
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		if (is_partition_valid(cp)) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
+		}
+		trial_effective_cpus(cp, cs, trialcs, new_cpus);
+		if (cpumask_subset(cp->effective_cpus, new_cpus))
+			continue;
+		keep = dl_tasks_keep_cpus(cp, new_cpus);
+		if (!keep)
+			break;
+	}
+	rcu_read_unlock();
+	return keep;
+}
+
 /**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
@@ -2528,6 +2696,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (alloc_tmpmasks(&tmp))
 		return -ENOMEM;
 
+	if (!dl_tasks_keep_root_domain(cs, trialcs, tmp.new_cpus)) {
+		free_tmpmasks(&tmp);
+		return -EBUSY;
+	}
+
 	/*
 	 * Check all the descendants in update_cpumasks_hier() if
 	 * effective_xcpus is to be changed.
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 096c0ec55cdc..61b50266468f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -4955,6 +4955,25 @@ int dl_bw_deactivate(int cpu)
 	return ret;
 }
 
+/*
+ * Return false if @p has CPUs in the root domain that counts its
+ * bandwidth and @new_mask holds none of them. A cpuset refuses such a
+ * mask: only a move to another cpuset makes room in another root domain.
+ */
+bool dl_task_keeps_root_domain(struct task_struct *p,
+			       const struct cpumask *new_mask)
+{
+	const struct cpumask *span;
+
+	if (!dl_bandwidth_enabled() || !task_has_dl_policy(p))
+		return true;
+	guard(raw_spinlock_irqsave)(&p->pi_lock);
+	guard(rcu)();
+	span = dl_task_bw_span(p);
+	return !span || !cpumask_intersects(span, p->cpus_ptr) ||
+	       cpumask_intersects(span, new_mask);
+}
+
 int dl_bw_alloc(int cpu, u64 dl_bw)
 {
 	return dl_bw_manage(dl_bw_req_alloc, cpu, dl_bw);
-- 
2.47.3

