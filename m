Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015908;
	b=U4e7wJWTh8aPrmLwpFHB6+kMUdli9GRA/1D0D3MAqcWp8ULLV7eeKfx8bWFHuQ0gpsSw
	 l3K4k79s9h0e/4X3wBIRmgSLoAajXBh7AiMCfCc9J2SBH2oQM0nrzQHYIfK91jFoftVnQ
	 /wXorEFUZVY+LazIDEZ6OJmtG4W28YnHW7L1qn0xNLdCCQF+3kZON4/mFp9wddxC1S1pq
	 8NQ/YTYt6Knf1Wos3MXyBkba/NhaX6W0NkK0rNAE1yfm31CcPUBXcnq2ywhpIqgbnlI13
	 HCZHDS5GRePeHlM72MT5wOSzocsuCB7J0IHaAl2xicpx+PyQMym9d+SDAipyCR4mxpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015908;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kqG3jTYaF+H3E6DAXY3JrDW7WyVRSM/4CYCmAXpj9U=;
	b=pd4MxEUPdW2yjWFeuBZRimefXqGvkHMtkIqdgFxGXiz+mRZFsy/WZ+HSV+sqBNjNs59x
	 LNuUhIcaNVNH/HB9grMqmgFFM3kl9YKygVVZTjgpwc5LhGbFlsVdEDLVgSlRDyakYzdqq
	 pkgsCnpqIWS9YaKUwQK74Fa0t4JJKjl25zTb5HAFqpKB3hUVA/AkgSqgjV6SfpKGsHrxn
	 tLN8lIyO6Uqd7AD4I+SWsoTiphocUWsJNd+Bo6sI3+DGAc4CzWMcnlA3hsHjMh6tdeseM
	 NJ2JsQofhf1toUUKoX5NUtlFBes2oL6BwUPCPW8aq6yJubEMLhRcaroGq1ok28VFSRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="Ds/DsLY8";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042F5606EEBA;
	Sat,  7 Nov 2026 01:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 042F5606EEBA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ds/DsLY8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015906;
	bh=/kqG3jTYaF+H3E6DAXY3JrDW7WyVRSM/4CYCmAXpj9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ds/DsLY8TM29pqQ9eT9jKlmH4OmS3GeKXXTeXt+JzRN1qnamV/kPNYvuhmhmZp8Jf
	 gwNIl5HcNDQxm97lV7ANYahNuxjQH+uJjZXrGcqbLYPKwRSBf619FM7OuIH71bE9/0
	 I+Q/VAVo1Er+xqfbSDDKdt9b9vmTHvMfiAZPUJHaPU2GO2y0KjiDPR9D4PPdrUUQ/0
	 uJUrQ0AHoXt5l86t52tLQ4zgmqhJ1bg2m9XothRD53GtdomJJkmXwXHkJ0fGG86Kep
	 WtfL8rRiWeeW4/DF7KnOHS00DTxGiaQdTjechQ5mV0kGXwSkWw6l9amjcpdNf8igt+
	 ZGzTOsajVxa+Q==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPt0GsjzMR7;
	Fri, 06 Nov 2026 20:45:06 -0500 (EST)
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
Subject: [PATCH v4 19/26] cgroup/cpuset: Give back the bandwidth an attach did not move
Date: Fri,  6 Nov 2026 20:44:44 -0500
Message-Id: <20261107014451.1487825-20-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

cpuset_can_attach() counts the bandwidth of every migrating deadline
task in sum_migrate_dl_bw, and cpuset_reserve_dl_bw() sets that sum
aside in the destination's root domain. The attach that follows moves
the bandwidth of each task that is still a deadline task, and nothing
answers for the reservation of one that is not: what was set aside for a
task that left SCHED_DEADLINE, or died, since it was counted stays in
the destination's total_bw, which admits that much less until the next
rebuild of the accounting. A task that flips between SCHED_DEADLINE and
SCHED_OTHER every millisecond while it is moved in and out of a one-CPU
partition root 200 times leaves total_bw of the partition at 367000,
681572 or 2^64 - 576716, where it was 52428, its fair server, in 4 VMs
of 10 of v7.4-rc1 with the patches of this series before this one.

Keep the tally of what the attach moves, and give the rest back once it
is through. The tally takes what set_cpus_allowed_dl() moved, written
into the affinity context under the runqueue lock: the root domain that
cpuset_attach_task() reads without that lock can change under it, CPU
hotplug moving the task in dl_task_offline_migration(), and the tally
would count a move that did not happen. With this change, total_bw of
the partition is 52428 after those 200 moves, in 6 VMs of 6.

Found by the randomized case of the selftest added earlier in this
series, which caught a fair server it could no longer lower in a
partition root with no room left.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           |  3 ++-
 kernel/cgroup/cpuset-internal.h |  2 ++
 kernel/cgroup/cpuset.c          | 39 ++++++++++++++++++++++++++-------
 kernel/sched/core.c             | 11 +++++++---
 kernel/sched/deadline.c         |  5 ++++-
 kernel/sched/sched.h            |  2 ++
 6 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0c36891415d..bd611dbb57b0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1980,7 +1980,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
  */
 extern int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask);
 extern int set_cpus_allowed_bw_reserved(struct task_struct *p,
-					const struct cpumask *new_mask);
+					const struct cpumask *new_mask,
+					u64 *moved);
 extern int dup_user_cpus_ptr(struct task_struct *dst, struct task_struct *src, int node);
 extern void release_user_cpus_ptr(struct task_struct *p);
 extern int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask);
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 153067b164c1..6f3d43d8dbad 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -170,6 +170,8 @@ struct cpuset {
 	int nr_migrate_dl_tasks;
 	/* DL bandwidth that needs destination reservation for this attach. */
 	u64 sum_migrate_dl_bw;
+	/* Of that bandwidth, what the attach moved: the rest is given back. */
+	u64 sum_moved_dl_bw;
 	/*
 	 * CPU used for temporary DL bandwidth allocation during attach;
 	 * -1 if no DL bandwidth was allocated in the current attach.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2ee58d46da0e..f93f5547714a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3127,10 +3127,24 @@ static void clear_attach_data(struct llist_head *head, bool cancel)
 	llist_for_each_entry_safe(cs, next, lnode, attach_node) {
 		init_llist_node(&cs->attach_node);
 		if (cs->nr_migrate_dl_tasks) {
-			if (cancel && cs->dl_bw_cpu >= 0)
-				dl_bw_free(cs->dl_bw_cpu, cs->sum_migrate_dl_bw);
+			/*
+			 * Give back the bandwidth the attach did not move:
+			 * all of the reservation when it is cancelled, and
+			 * what was set aside for the tasks that are no
+			 * longer deadline tasks otherwise. Theirs is
+			 * released by the class they left, from the root
+			 * domain that counts it.
+			 */
+			if (cs->dl_bw_cpu >= 0) {
+				u64 bw = cancel ? cs->sum_migrate_dl_bw :
+					 cs->sum_migrate_dl_bw - cs->sum_moved_dl_bw;
+
+				if (bw)
+					dl_bw_free(cs->dl_bw_cpu, bw);
+			}
 			cs->nr_migrate_dl_tasks = 0;
 			cs->sum_migrate_dl_bw = 0;
+			cs->sum_moved_dl_bw = 0;
 			cs->dl_bw_cpu = -1;
 		}
 	}
@@ -3281,19 +3295,28 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 			       subpartitions_cpus);
 	/*
 	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
-	 * deadline tasks cpuset_can_attach() counted: say so, so that this
-	 * task's bandwidth moves there with it.
+	 * deadline tasks cpuset_can_attach() counted: offer it, so that this
+	 * task's bandwidth moves there with it. A task that became a
+	 * deadline task since has nothing set aside, so it moves its
+	 * bandwidth only where the rest of the reservation covers it.
 	 */
-	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus))
+	if (dl_task(task) && dl_task_needs_bw_move(task, cs->effective_cpus) &&
+	    cs->sum_moved_dl_bw + task->dl.dl_bw <= cs->sum_migrate_dl_bw)
 		reserved = true;
 	/*
 	 * can_attach beforehand should guarantee that this doesn't
 	 * fail.  TODO: have a better way to handle failure here
 	 */
-	if (reserved)
-		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach));
-	else
+	if (reserved) {
+		u64 moved;
+
+		/* The move decides: the tally counts what it moved. */
+		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach,
+							  &moved));
+		cs->sum_moved_dl_bw += moved;
+	} else {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+	}
 
 	if (cpuset_v2() && !attach_ctx.mems_updated)
 		return;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6a2d660ffea1..494a815c6bb0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3274,16 +3274,21 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 
 /*
  * The same, for a caller that has made room in the root domain of @new_mask
- * for the deadline bandwidth of @p: that bandwidth moves there with it.
+ * for the deadline bandwidth of @p: that bandwidth moves there with it, and
+ * @moved takes what the move counts there, 0 where it moved none.
  */
-int set_cpus_allowed_bw_reserved(struct task_struct *p, const struct cpumask *new_mask)
+int set_cpus_allowed_bw_reserved(struct task_struct *p,
+				 const struct cpumask *new_mask, u64 *moved)
 {
 	struct affinity_context ac = {
 		.new_mask  = new_mask,
 		.flags     = SCA_DL_BW_RESERVED,
 	};
+	int ret;
 
-	return __set_cpus_allowed_ptr(p, &ac);
+	ret = __set_cpus_allowed_ptr(p, &ac);
+	*moved = ac.dl_bw_moved;
+	return ret;
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1b730e22ee6c..f169cf35e313 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3544,7 +3544,9 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * The bandwidth of a task whose move no one made room for stays
 	 * where it is counted, for the next rebuild of the accounting to
 	 * attribute, rather than leaving the root domain it moves to short
-	 * of what its tasks hold.
+	 * of what its tasks hold. @ctx tells the caller what moved: the
+	 * record of a task is read here, under its runqueue lock, and the
+	 * caller cannot keep a reservation for a move this decides against.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
 	    dl_task_needs_bw_move(p, ctx->new_mask)) {
@@ -3572,6 +3574,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
 		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
 		p->dl.dl_bw_gen = dl_bw_gen;
+		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
 
 	set_cpus_allowed_common(p, ctx);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 57aadc5b1ba6..10a4750af6f3 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2662,6 +2662,8 @@ extern const u32		sched_prio_to_wmult[40];
 struct affinity_context {
 	const struct cpumask	*new_mask;
 	struct cpumask		*user_mask;
+	/* Out: the deadline bandwidth the move counts in the new root domain. */
+	u64			dl_bw_moved;
 	unsigned int		flags;
 };
 
-- 
2.47.3

