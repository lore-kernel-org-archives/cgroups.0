Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655340;
	b=vZdgNlVUlqvWegF9KeoiJOi3p5Khag9z/Lkag3todKYNc0yZsSs27GV6bo9bws9vw+tm
	 ZeDqw9nXpsx4YRxQMz1YG+qixs/Xw1l/pqhCaSBYjzenP1QLOMrDh1XCfOtb9matXlzzq
	 qTSiipAGS/VHJOtQvb527FcGCcLMwPZEGsuxibDt4ItkrzWaR1a0T6uS2xxk3scKwYLKV
	 Fv5YcA2lczfXBbwPhdxiexZT/sS1sKfp9ZAaAh3EDw+a0QLSm4igLl79F6rNmOYDzA+Lt
	 f9ssI1iSDRN2gAxjDn1G4B9bUk7SBE8nt3oZmQX+nYFn0/r3jmsXb3Iz0WbrREykkJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655340;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KCPw0IyAxv/MXkTyllmngeHfJlEXbM3T6fKao9wY5XM=;
	b=bgMXZ2CPgO86nbhW98VfcBJ2C87hQOmZ7yXLdbyhwuVBH1CxtZheOVtHCDd76DAHENks
	 gTvISRbkdHt7i8cg8nP/gu4NnG4QtD3gZPNxA00wz4Xzz/ouBN9LLU1R6AMsxS+qBkbCB
	 53ICuMg3uEjBQdMfGytgIg3HaAH3Bb9Lt9j6UkZQPasfZA5yIHmDox1MXrEsjNGViHUu6
	 zMDMvnCyM7lSoSXE4k6eKHE7lRJzJ5dw7Jr34Oayj0XzbN51APfDXIS7WEIlO3qfU9688
	 Y/R/WC2202wjoIakmfwyf2OvWZS7aVx8A5AWparw0QO2utx7JC+IMSFIKNOUaE2C25A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n4OCz8JR;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0D606A6A9;
	Thu, 26 Nov 2026 01:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AD0D606A6A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n4OCz8JR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655335;
	bh=KCPw0IyAxv/MXkTyllmngeHfJlEXbM3T6fKao9wY5XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4OCz8JR6VgKtjvU2JefKKsKI8FnclMmfrUv2PvDEgRJEc77EFQs0KIZwMdeq6OCn
	 KVv2Zt1PlIs0mmOStyue/g6gq/5QLZow4IyhKy4WORITDQU4ZGYHXWx6Dc657N2tye
	 cBCCG9hPUWErjNv6+udRunclaeEotauGpTg9C+lDTaMzmHrogK0HPY4SOkj1utnImo
	 jS71uMg6OqcUOub25WU/ztTPt+I5M3XdUN30dYtTC7f2DZ9qI9awfq1+8u/7KTA/NL
	 nHl2un8E/FYeIz3HCC3E+z1WYjVpqukA6ZItz3aNsSbnJI2O4Ic/nRTPlPWKfcVPbm
	 lagIYO4offBTw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjM2lPFzX09;
	Wed, 25 Nov 2026 20:08:55 -0500 (EST)
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
Subject: [PATCH v11 10/43] cgroup/cpuset: Give back the bandwidth an attach did not move
Date: Wed, 25 Nov 2026 20:08:09 -0500
Message-ID: <ad038e5f0f120a9390347c1e92f0e2811bec1eaa.1795646914.git.mathieu.desnoyers@efficios.com>
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

Commit 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach()
fails") reserves the bandwidth of an attach as one sum.
cpuset_can_attach() adds up the bandwidth of the deadline tasks it
moves. Once all tasks pass their checks, it reserves the sum in the
destination root domain. If another controller refuses the attach,
cpuset_cancel_attach() frees the sum. If the attach goes through, the
move of each task uses its part of the sum.

But a task can leave SCHED_DEADLINE between cpuset_can_attach() and
cpuset_attach(). The previous patch makes sched_setattr() wait for the
attach. sysrq-n does not wait: it cannot sleep. The task then moves no
bandwidth. Its part of the reservation stays in the destination's
total_bw, until the next rebuild of the accounting. The destination can
then refuse deadline tasks that would fit.

Fix this by keeping the tally of what the attach moves, in
sum_moved_dl_bw. Once the attach is through, give back what it did not
move.

set_cpus_allowed_dl() decides the move under the runqueue lock.
cpuset_attach_task() does not hold it. So the tally counts what
set_cpus_allowed_dl() reports in the affinity context.

The random_mix case, added to deadline_bw_test later in this series,
found the bug. It could no longer lower a fair server in a partition
root with no room left.

The move_normalized case, added with that test, fires sysrq-n while a
process with a sleeping deadline thread of 30% moves into a one-CPU
partition root. Without this patch, the partition kept the 30% in 3
guests of 3. It admitted 6 tasks of 10% where it had room for 9.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h           |  3 ++-
 kernel/cgroup/cpuset-internal.h |  2 ++
 kernel/cgroup/cpuset.c          | 30 +++++++++++++++++++++++++-----
 kernel/sched/core.c             | 12 ++++++++----
 kernel/sched/deadline.c         |  4 ++++
 kernel/sched/sched.h            |  2 ++
 6 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e88616448b85..81a8d80a1aee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1967,7 +1967,8 @@ extern void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *
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
index ce9c57617f49..2f39c3d12550 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3140,10 +3140,24 @@ static void clear_attach_data(struct llist_head *head, bool cancel)
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
@@ -3303,10 +3317,16 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
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
index c0a714dde425..fff2725a4cd5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3301,17 +3301,21 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
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
index 67f7180559d5..e2ffdb23ba3e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3676,6 +3676,9 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * Otherwise, the bandwidth stays where it is counted, until the next
 	 * rebuild of the accounting. Moving it without room would leave no
 	 * root domain counting it.
+	 *
+	 * Report in @ctx the bandwidth moved. The caller made its own test
+	 * without the runqueue lock, so it must count only what this reports.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
 	    dl_task_needs_bw_move(p, ctx->new_mask)) {
@@ -3704,6 +3707,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 		cpu = cpumask_any_and(ctx->new_mask, cpu_active_mask);
 		p->dl.dl_bw_cpu = cpu < nr_cpu_ids ? (int)cpu : -1;
 		p->dl.dl_bw_gen = dl_bw_gen;
+		ctx->dl_bw_moved = p->dl.dl_bw;
 	}
 
 	set_cpus_allowed_common(p, ctx);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index f4cd35811b96..65fc17909d56 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2678,6 +2678,8 @@ extern const u32		sched_prio_to_wmult[40];
 struct affinity_context {
 	const struct cpumask	*new_mask;
 	struct cpumask		*user_mask;
+	/* Out: the deadline bandwidth moved to the new root domain. */
+	u64			dl_bw_moved;
 	unsigned int		flags;
 };
 
-- 
2.47.3

