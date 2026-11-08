Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164066;
	b=EEsfpwDykku3QiuCg59P77BuRsUMib0+D0hmWzl2rZ5/+xvXE4za4HGF5iUtImfhmd7T
	 xYNqOypbDh/gpvpI+dBywbYR1ZS1R0SbtWBfZlRtXnWYltSeWHbOg+3rqJPAbeWwGD0/N
	 nB0K+8/3qwoqGM230hk5h9yLH289b8eClIIDEer5rfsbEDBNGGtAPpEy/mbmvJNoeNFjW
	 bpEaQp7EBQD0qWph/mVH9oyhSoZaR0/+EApKTHLAT0Kyhb63HbV/5mHbdMCJoL84nF3kV
	 QBfOmzIWgT0BGLZSHhbN+Ku89t4TCrU/LaGiPMTm7dyoEYcw8COrpPrYqolDOU+UXEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164066;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hHjKqhMtVx9g+eFlxICIArzoHmA8v/M0FJ40WOOvbGQ=;
	b=5IG2enzSwa15HRDhi9aicYpxAUW49UTgdidpdEnkZ0G2TlOcXefZrapqEdhHAJubDjGn
	 h2l8ULJ6qXpUbi+FOP43iWLifIW7Vqnqmcd6iioCTU+GeWYqK8LK+k/7+cHovyqWwOuij
	 wlNs/fzE1vP/9iKPxZ1Z0hexPVgDMAK8ojF3X3jtncu+js2lTGODdHC+fE187oNdoVbcl
	 O3WQX3XHG37xdDTfUZKti04qPADCY445JW2mzj/cDsKxn/paVc4sNSX3q3DlPnqtB7hrr
	 Oswy/ZIy2/duCNNsVP+32XBpPZE8Qv0Zu4ZmS8p7KgcwATiY34vI+WiKvCtpmqkk3xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eO7wzZbO;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838986082BF4;
	Sun,  8 Nov 2026 18:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838986082BF4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eO7wzZbO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164064;
	bh=hHjKqhMtVx9g+eFlxICIArzoHmA8v/M0FJ40WOOvbGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eO7wzZbOUiqG+5a0J5x0ythAROi8ADoj6GSx5AczcrAHHyNRH7X+Xp22sZ9QgIpNd
	 3WGaO1Lui2AIpRXjF9bDVEAbNHnBGcbQPGcwRsiJj9kiksILlLtYOj8RJcDxfpamaC
	 +j+y2TpeVhxNgC6LcTk/ky07tBxCc1/3WWtmfjIHl3zVZS6c0uKuYqIm980WcZUWTB
	 pOaj2dZMNWa4g8cmh3vJlKacDVR9M/KIpNxXidniguX+mZdLP80qKtBwgBb3cgW2Ph
	 VQ3N0AEqF3HAzuupNWa2qWMqYjLrl05cS+PC6PPDspyJ5EoYdeyfKU4+4g8VwTaXHK
	 jfFNup/63ycSg==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C443ktzMvc;
	Sun, 08 Nov 2026 13:54:24 -0500 (EST)
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
Subject: [PATCH v5 20/29] cgroup/cpuset: Give back the bandwidth an attach did not move
Date: Sun,  8 Nov 2026 13:53:57 -0500
Message-Id: <20261108185406.1549770-21-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

Commit 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach()
fails") reserves the bandwidth of an attach as one sum.
cpuset_can_attach() adds up the bandwidth of the deadline tasks it
moves. Once all tasks pass their checks, it reserves the sum in the
destination root domain. If another controller refuses the attach,
cpuset_cancel_attach() frees the sum. If the attach goes through, the
move of each task uses its part of the sum.

But a task can change its policy, or die, before the attach:

 - A task that left SCHED_DEADLINE, or died, moves no bandwidth. Its
   part of the reservation stays in the destination's total_bw, until
   the next rebuild of the accounting.
 - A task that became a deadline task has nothing reserved. The attach
   still moves its bandwidth. The destination lacks it, and its
   total_bw underflows when the task leaves.

In testing, a task switched between SCHED_DEADLINE and SCHED_OTHER
while it was moved 200 times into a one-CPU partition root and back.
On v7.4-rc1 with the patches before this one, the partition's total_bw
ended wrong in 5 of 6 VMs with 8 CPUs. It kept up to two reservations,
or wrapped below zero.

Fix this by keeping the tally of what the attach moves, in
sum_moved_dl_bw. Flag the move of a task only if the rest of the
reservation covers its bandwidth. Once the attach is through, give back
what it did not move.

set_cpus_allowed_dl() decides the move under the runqueue lock.
cpuset_attach_task() does not hold it. dl_task_offline_migration() can
change the task's record meanwhile, for a task throttled on a CPU gone
offline. So the tally counts what set_cpus_allowed_dl() reports in the
affinity context.

With this patch, total_bw ended right in 6 VMs of 6. The random_mix case
of deadline_bw_test, added later in this series, found the bug. It could
no longer lower a fair server in a partition root with no room left.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h           |  3 ++-
 kernel/cgroup/cpuset-internal.h |  2 ++
 kernel/cgroup/cpuset.c          | 37 +++++++++++++++++++++++++++------
 kernel/sched/core.c             | 12 +++++++----
 kernel/sched/deadline.c         |  4 ++++
 kernel/sched/sched.h            |  2 ++
 6 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5f14005d737e..2afa50aa3e54 100644
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
index bf847953c78d..93aa46d76b04 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -170,6 +170,8 @@ struct cpuset {
 	int nr_migrate_dl_tasks;
 	/* DL bandwidth that needs destination reservation for this attach. */
 	u64 sum_migrate_dl_bw;
+	/* The part of sum_migrate_dl_bw moved. The rest is given back. */
+	u64 sum_moved_dl_bw;
 	/*
 	 * CPU used for temporary DL bandwidth allocation during attach;
 	 * -1 if no DL bandwidth was allocated in the current attach.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 51b6be460794..ed77fc915261 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3129,10 +3129,24 @@ static void clear_attach_data(struct llist_head *head, bool cancel)
 	llist_for_each_entry_safe(cs, next, lnode, attach_node) {
 		init_llist_node(&cs->attach_node);
 		if (cs->nr_migrate_dl_tasks) {
-			if (cancel && cs->dl_bw_cpu >= 0)
-				dl_bw_free(cs->dl_bw_cpu, cs->sum_migrate_dl_bw);
+			/*
+			 * Give back the bandwidth the attach did not move.
+			 * If the attach is cancelled, that is all of the
+			 * reservation. Otherwise, it is what no move used,
+			 * such as the part for a task that left
+			 * SCHED_DEADLINE. The class it left releases its own
+			 * bandwidth, from the root domain that counts it.
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
@@ -3285,17 +3299,28 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	 * cpuset_reserve_dl_bw() made room in @cs for the bandwidth of the
 	 * deadline tasks that cpuset_can_attach() counted. Flag the move, so
 	 * that the bandwidth of this task moves with it.
+	 *
+	 * Nothing was reserved for a task that became a deadline task since.
+	 * Flag its move only if the rest of the reservation covers its
+	 * bandwidth.
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
+		/* Count what the move reports it moved. */
+		WARN_ON_ONCE(set_cpus_allowed_bw_reserved(task, cpus_attach,
+							  &moved));
+		cs->sum_moved_dl_bw += moved;
+	} else {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+	}
 
 	if (cpuset_v2() && !attach_ctx.mems_updated)
 		return;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 030106b3d97f..3a538b42dcdd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3275,17 +3275,21 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 /*
  * Like set_cpus_allowed_ptr(), for a caller that has made room for the
  * deadline bandwidth of @p in the root domain of @new_mask. Move that
- * bandwidth there with @p. Return 0 on success, or a negative error
- * code.
+ * bandwidth there with @p, and set @moved to the bandwidth moved, 0
+ * if none. Return 0 on success, or a negative error code.
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
index b365401e7148..0326527dd2d1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3571,6 +3571,9 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * Otherwise, the bandwidth stays where it is counted, until the next
 	 * rebuild of the accounting. Moving it without room would leave no
 	 * root domain counting it.
+	 *
+	 * Report in @ctx the bandwidth moved. The caller read the record
+	 * without the runqueue lock, so it must count only what this reports.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
 	    dl_task_needs_bw_move(p, ctx->new_mask)) {
@@ -3597,6 +3600,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
 		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
 		p->dl.dl_bw_gen = dl_bw_gen;
+		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
 
 	set_cpus_allowed_common(p, ctx);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d7b4cad28262..ed84b7b7161f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2663,6 +2663,8 @@ extern const u32		sched_prio_to_wmult[40];
 struct affinity_context {
 	const struct cpumask	*new_mask;
 	struct cpumask		*user_mask;
+	/* Out: the deadline bandwidth moved to the new root domain. */
+	u64			dl_bw_moved;
 	unsigned int		flags;
 };
 
-- 
2.47.3

