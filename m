Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655343;
	b=Hap+BR6+F03PpwE97kP027jeLoMEsOEKjcBcXJARm/tkAXBDrPh8lQSozpJQAu+F5Ad7
	 gsiIjD0MlvsZFnNKOvt3cyMKHsR6Y1DKEE8zd+EhMcWDnEMSoXmhVOunmukWGn49l1Lpe
	 pOyfSF+hL7v04+M8i1JR9SqZJjSLCfTXn5U/TKnaWiox3TC2eNEYAXpcN6ASL9QtfbwEy
	 AFFWL79tz2gNcRdX9JNeww928sIY1vadt58ODU3gmnwq5pV4y5aJP6qK5zMTdxt8EQi+M
	 b9Fu+/VKh5Hh1q8SFFV8EbtFQu/tj1SVvA4i/U5IkPgFohNXv6e6OrBPFK9vQurTvsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655343;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XDq+3X545PA8F8c37o3ENx666m4LHKwQ8B0p9Pluvns=;
	b=SKX+aW3Ws5NRtRwEmGL7colPiJ2Njk7xbKUK9NovQb+mOGbm97D8R6Y69YP5nd09ox0M
	 8uMbLfYmXUZGkox/hqNjKapelPc1Yny2ulAMe6rnKRJeTtudnheR1aYcmBmSqtMDg90jW
	 TtvZJPSUkOFgJU/gX8voZvD5pRdx4N1w9qvq2l2uA+jhl9d+cIlVnJe1nHIl/OZUxfhEt
	 hHDYAyira6dAD8TFVMN/3FXdhpEISixrYyBnSqcX9Z2Nn5tIRb6J3zPgaHehioHZZxEBu
	 hjeWIDhPhmb3UBgqWPebtBK02szPuWbzh8rWyTto7ESoYz4Nb0vex6aA5vxbqg688aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=h+TQFj3b;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08260A3829;
	Thu, 26 Nov 2026 01:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE08260A3829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=h+TQFj3b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655341;
	bh=XDq+3X545PA8F8c37o3ENx666m4LHKwQ8B0p9Pluvns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+TQFj3be/UJYWLO6TS48+zdmz4x9kaUZQy503SypJgOwNwZgKOpioOb/O7i2D+D5
	 p2syPopC9cpKc3X1GmwfFRtQ9o9u5+foC4b74Yb8Rekk/Xt+E5rJ//2eINVSX66VC4
	 3TMX5X96YfVflU12C3I5Ll4UFRsN4BjSPCQzJKoaJoryREByHvM/fRQsbKqT5Npdbi
	 O9QhG16OMPodO5FDStTmQDgMlAX/zo5JYmWmlcjzFVOnu4DpDbFzljSgG8ttgIjvgi
	 QvzLq/YRXvWMpLvsLGVRZv4Cr2M7Aw4b4LIBAkvgtZBT0/Oha2dXsc8jLq2tr79cIt
	 UjrXGVFOBwS1Q==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjS30r7zWkx;
	Wed, 25 Nov 2026 20:09:00 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	tommaso.cucinotta@gmail.com,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v11 17/43] cgroup/cpuset: Refuse to take a deadline task out of its root domain
Date: Wed, 25 Nov 2026 20:08:16 -0500
Message-ID: <2a3cf1f221564450a14f75f0f4eeebc3379a992e.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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

A task goes to another root domain by a move to another cpuset, which
asks for room. So refuse both changes:

 - A write to cpuset.cpus fails with EBUSY, and changes nothing. The
   cpuset.cpus file of cgroup v1 gets the same check.
 - The write that makes the partition root, or makes it grow, still
   succeeds. cpuset makes the partition root invalid. For a "root"
   partition, cpuset.cpus.partition then reads "root invalid (Deadline
   task would leave its root domain)".

A change that leaves each deadline task a CPU in its root domain is
accepted as before.

Like __set_cpus_allowed_ptr(), the check keeps the new mask within the
affinity set by the user, if they intersect. So a mask that grows can
also take a task out of its root domain, and it is checked too.

cpuset cannot refuse these changes, so they are not checked:
 - disabling a partition;
 - a partition that cpuset makes invalid;
 - a CPU that comes online.

dl_task_keeps_root_domain() tells whether a new mask keeps a task in the
root domain that counts it. It accepts any mask for a dead task, which
does not run again. Without admission control it accepts any mask: there
is no limit to exceed. An administrator who needs the change can turn
admission control off, by writing -1 to
/proc/sys/kernel/sched_rt_runtime_us.

The check runs before the rebuild of the sched domains, which ends the
change. A partition root whose CPUs grew can then have tasks counted in
a root domain that does not span the new CPUs yet. A check of that
span alone would refuse a valid child partition. It would stay invalid
until the next change. So for a root partition, the CPUs it has after
the change count too: the rebuild gives them to its root domain.

The cases mask_out_refused and partition_takes_refused, added to
deadline_bw_test later in this series, test this. Without this patch the
write is accepted and the partition root is valid. These cases test the
other paths:
- partition_takes_fallback_refused: the CPUs of an ancestor;
- mask_grows_refused: a mask that grows;
- partition_swap_refused: a partition root that takes and gives CPUs in
  one change;
- partition_refused_no_warn: a refusal with no warning;
- partition_grows_child_valid: a child partition made valid by CPUs
  that its parent just got.

Fixes: f82f80426f7a ("sched/deadline: Ensure that updates to exclusive cpusets don't break AC")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h  |   3 +
 kernel/cgroup/cpuset-internal.h |   1 +
 kernel/cgroup/cpuset.c          | 213 +++++++++++++++++++++++++++++++-
 kernel/sched/deadline.c         |  39 ++++++
 4 files changed, 253 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 8eb5cd13b9dd..fa66e75cbdd8 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -63,6 +63,9 @@ extern int dl_task_bw_reserve_cpu(struct task_struct *p,
 				  const struct cpumask *new_mask);
 extern int dl_task_bw_reserved_cpu(struct task_struct *p);
 extern void dl_task_bw_unreserve(struct task_struct *p);
+extern bool dl_task_keeps_root_domain(struct task_struct *p,
+				      const struct cpumask *new_mask,
+				      const struct cpumask *pending);
 
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
index 37d04b08996e..67b2429c0e22 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -61,6 +61,7 @@ static const char * const perr_strings[] = {
 	[PERR_ACCESS]    = "Enable partition not permitted",
 	[PERR_REMOTE]    = "Have remote partition underneath",
 	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
+	[PERR_DLTASK]    = "Deadline task would leave its root domain",
 };
 
 /*
@@ -1126,6 +1127,38 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 		cpuset_force_rebuild();
 }
 
+/*
+ * Return false if the CPUs of @new_cpus make a deadline task of @cp leave
+ * the root domain that counts its bandwidth. @pending, if not NULL, holds
+ * the CPUs that the rebuild at the end of the change gives to that root
+ * domain. Called under rcu_read_lock(), which it drops and takes again.
+ */
+static bool dl_tasks_keep_cpus(struct cpuset *cp, const struct cpumask *new_cpus,
+			       const struct cpumask *pending)
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
+		keep = dl_task_keeps_root_domain(task, new_cpus, pending);
+	}
+	css_task_iter_end(&it);
+
+	rcu_read_lock();
+	css_put(&cp->css);
+	return keep;
+}
+
 /*
  * Set @new_cpus to the effective CPUs that @cp gets. On entry, @new_cpus
  * holds those that @from gets. @from is @cp or one of its ancestors. Work
@@ -1148,6 +1181,91 @@ static void effective_cpus_below(struct cpuset *cp, struct cpuset *from,
 	}
 }
 
+/*
+ * A scratch mask for dl_tasks_keep_without(). Its callers still need each
+ * mask of their struct tmpmasks after the call. Protected by
+ * cpuset_mutex.
+ */
+static cpumask_var_t dl_keep_cpus, dl_pending_cpus;
+
+/*
+ * Return false if a partition that takes the CPUs of @xcpus makes a
+ * deadline task leave the root domain that counts its bandwidth. A cpuset
+ * can hold CPUs of two root domains: with isolcpus="domain", or on cgroup
+ * v1 with sched_load_balance off. Such a task would run in a root domain
+ * that did not admit it.
+ *
+ * @root is the partition root that gives the CPUs. @part is the cpuset
+ * that takes them. In the same change, @part can give the CPUs of @gives
+ * back to @root. @gives is NULL if it gives none back.
+ *
+ * Work out the new CPUs of each cpuset of @root from the top down, as
+ * update_cpumasks_hier() does, down to the next partition roots. If
+ * @enable, @part becomes a partition root. Then do the same for its own
+ * cpusets, starting from the active CPUs of @xcpus.
+ */
+static bool dl_tasks_keep_without(struct cpuset *root, struct cpuset *part,
+				  const struct cpumask *xcpus,
+				  const struct cpumask *gives, bool enable)
+{
+	struct cpumask *new_cpus = dl_keep_cpus, *pending = NULL;
+	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp;
+	bool keep = true;
+
+	lockdep_assert_cpuset_lock_held();
+	/*
+	 * The CPUs of @root can have changed before the rebuild of the
+	 * sched domains, which ends the change. Then the root domain of a
+	 * task of @root does not span them yet. The rebuild gives the CPUs
+	 * of a root partition to one root domain.
+	 */
+	if (root->partition_root_state == PRS_ROOT) {
+		pending = dl_pending_cpus;
+		cpumask_copy(pending, root->effective_cpus);
+		if (root == &top_cpuset)
+			cpumask_and(pending, pending,
+				    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+	}
+	rcu_read_lock();
+	cpuset_for_each_descendant_pre(cp, pos_css, root) {
+		if (cp == part || (cp != root && is_partition_valid(cp))) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
+		}
+		/* The CPUs that @root has after the change. */
+		cpumask_copy(new_cpus, root->effective_cpus);
+		if (gives) {
+			cpumask_or(new_cpus, new_cpus, gives);
+			cpumask_and(new_cpus, new_cpus, cpu_active_mask);
+		}
+		cpumask_andnot(new_cpus, new_cpus, xcpus);
+		effective_cpus_below(cp, root, new_cpus);
+		if (cpumask_equal(cp->effective_cpus, new_cpus))
+			continue;
+		keep = dl_tasks_keep_cpus(cp, new_cpus, pending);
+		if (!keep)
+			break;
+	}
+	if (keep && enable) {
+		cpuset_for_each_descendant_pre(cp, pos_css, part) {
+			if (cp != part && is_partition_valid(cp)) {
+				pos_css = css_rightmost_descendant(pos_css);
+				continue;
+			}
+			cpumask_and(new_cpus, xcpus, cpu_active_mask);
+			effective_cpus_below(cp, part, new_cpus);
+			if (cpumask_equal(cp->effective_cpus, new_cpus))
+				continue;
+			keep = dl_tasks_keep_cpus(cp, new_cpus, NULL);
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
@@ -1698,6 +1816,8 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_NOCPUS;
 	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
+	if (!dl_tasks_keep_without(&top_cpuset, cs, tmp->new_cpus, NULL, true))
+		return PERR_DLTASK;
 
 	spin_lock_irq(&callback_lock);
 	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
@@ -1801,6 +1921,10 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
 						       excpus, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
+		else if (!dl_tasks_keep_without(&top_cpuset, cs, tmp->addmask,
+						deleting ? tmp->delmask : NULL,
+						false))
+			WRITE_ONCE(cs->prs_err, PERR_DLTASK);
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -1948,6 +2072,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (nocpu)
 			return PERR_NOCPUS;
 
+		if (!dl_tasks_keep_without(parent, cs, tmp->delmask, NULL, true))
+			return PERR_DLTASK;
+
 		/*
 		 * This function will only be called when all the preliminary
 		 * checks have passed. At this point, the following condition
@@ -2035,6 +2162,20 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			deleting = false;
 			adding = cpumask_and(tmp->addmask,
 					     cs->effective_xcpus, parent->effective_xcpus);
+		} else if (deleting &&
+			   !dl_tasks_keep_without(parent, cs, tmp->delmask,
+						  adding ? tmp->addmask : NULL,
+						  is_partition_invalid(cs))) {
+			/*
+			 * As above: the partition is or becomes invalid. Only
+			 * a valid one holds CPUs of its parent to give back.
+			 */
+			part_error = PERR_DLTASK;
+			deleting = false;
+			if (is_partition_valid(cs))
+				adding = cpumask_and(tmp->addmask,
+						     cs->effective_xcpus,
+						     parent->effective_xcpus);
 		}
 	} else {
 		/*
@@ -2106,10 +2247,13 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 				}
 				rcu_read_unlock();
 			}
-			if (exclusive)
-				deleting = !cpumask_empty(tmp->delmask);
-			else
+			if (!exclusive)
 				part_error = PERR_NOTEXCL;
+			else if (!dl_tasks_keep_without(parent, cs, tmp->delmask,
+							NULL, true))
+				part_error = PERR_DLTASK;
+			else
+				deleting = !cpumask_empty(tmp->delmask);
 		}
 		/*
 		 * When both cs and parent remain valid, parent's
@@ -2518,6 +2662,62 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 	}
 }
 
+/*
+ * Set @new_cpus to the effective CPUs that @cp gets if @cs takes the CPUs
+ * of @trialcs. @cp is @cs or one of its descendants.
+ */
+static void trial_effective_cpus(struct cpuset *cp, struct cpuset *cs,
+				 struct cpuset *trialcs, struct cpumask *new_cpus)
+{
+	struct cpuset *parent = parent_cs(cs);
+
+	if (!cpumask_and(new_cpus, trialcs->cpus_allowed, parent->effective_cpus) &&
+	    is_in_v2_mode())
+		cpumask_copy(new_cpus, parent->effective_cpus);
+	effective_cpus_below(cp, cs, new_cpus);
+}
+
+/*
+ * Return false if the CPUs of @trialcs make a deadline task of @cs, or of
+ * a descendant, leave the root domain that counts its bandwidth. A cpuset
+ * can hold CPUs of two root domains: with isolcpus="domain", or on cgroup
+ * v1 with sched_load_balance off. The task would run in a root domain that
+ * did not admit it. Only a move to another cpuset can take the task
+ * there. The move asks the other root domain for room.
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
+		/*
+		 * Test a mask that grows too. A task whose user affinity
+		 * holds none of the old CPUs gets only the new ones.
+		 */
+		if (cpumask_equal(cp->effective_cpus, new_cpus))
+			continue;
+		keep = dl_tasks_keep_cpus(cp, new_cpus, NULL);
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
@@ -2550,6 +2750,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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
@@ -3983,6 +4188,8 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&dl_attach_cpus, GFP_KERNEL));
+	BUG_ON(!alloc_cpumask_var(&dl_keep_cpus, GFP_KERNEL));
+	BUG_ON(!alloc_cpumask_var(&dl_pending_cpus, GFP_KERNEL));
 
 	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		cpumask_andnot(isolated_cpus, cpu_possible_mask,
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cb738ad23b12..aa35933c0550 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -5296,6 +5296,45 @@ int dl_bw_deactivate(int cpu)
 	return ret;
 }
 
+/*
+ * Return false if @p has CPUs in the root domain that counts its
+ * bandwidth and @new_mask holds none of them. A cpuset refuses such a
+ * mask: only a move to another cpuset makes room in another root domain.
+ * Like __set_cpus_allowed_ptr(), keep @new_mask within the affinity set by
+ * the user, if they intersect. @pending is NULL, or holds the CPUs that
+ * the rebuild at the end of the change gives to the root domain of a
+ * partition root.
+ */
+bool dl_task_keeps_root_domain(struct task_struct *p,
+			       const struct cpumask *new_mask,
+			       const struct cpumask *pending)
+{
+	const struct cpumask *span, *user = cpu_possible_mask;
+
+	if (!dl_bandwidth_enabled() || !task_has_dl_policy(p))
+		return true;
+	/* A dead task does not run again, so its mask does not matter. */
+	if (READ_ONCE(p->__state) == TASK_DEAD)
+		return true;
+	/* pi_lock also protects p->user_cpus_ptr. */
+	guard(raw_spinlock_irqsave)(&p->pi_lock);
+	guard(rcu)();
+	span = dl_task_bw_span(p);
+	/* A task in a migrate_disable() section has a cpus_ptr of one CPU. */
+	if (!span || !cpumask_intersects(span, &p->cpus_mask))
+		return true;
+	if (p->user_cpus_ptr && cpumask_intersects(new_mask, p->user_cpus_ptr))
+		user = p->user_cpus_ptr;
+	if (cpumask_intersects_and(span, new_mask, user))
+		return true;
+	/*
+	 * The rebuild at the end of the change can give the root domain
+	 * of @p the CPUs of @pending. Test those too.
+	 */
+	return pending && cpumask_intersects(span, pending) &&
+	       cpumask_intersects_and(pending, new_mask, user);
+}
+
 int dl_bw_alloc(int cpu, u64 dl_bw)
 {
 	return dl_bw_manage(dl_bw_req_alloc, cpu, dl_bw);
-- 
2.47.3

