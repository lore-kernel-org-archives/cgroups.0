Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207365;
	b=AlpPj/zCySGK0I1GunV6SXq7uBDgqhQ8nnqfsv3VtT5JLxDf+O9aHa6vJh5YBrP1ED4N
	 hn+8/9C27DfjNKS0V52FyJtysUyrVBZ47IkWSHVLp1YL72WyNptAwXBvPFt+n/YDNzDNM
	 SlZcS3Z39IVVZe0QX0I/ob3cLUkLJFWgJL6LHyaN0NA2REy41Gt0FpGt+oc4TeTC0o+Hq
	 fjHmh5mI6Nm7iGLUhgUxItdtQCwOqkCNYM0kcJCyfd4tJnhMRLC8AregiGoj0jzfpCB4U
	 bwylo8rxuk+5zKKY8z2CnVCPrHXGNqc4KCHuKZvkcd8Vf3+vD+m9Pim2PecqXTRAQNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207365;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hnZN3YRZ98GVF++w/YTWvIy7nXP4wGKxJAAnzb2UsdA=;
	b=Wuvfm+qrGYGL95taEqVmGX263WoidCkNkSm+E9opoGcZgH+XvwsKlwk2aVC96G1NEn8z
	 b6YeFo+lstvAk/W+DDPmjDHUDFQew2fiVTukvTodSJObLzxPTOVSFeqJbfywW0eNG3dVc
	 Gcs7M9kA1zjLjPPzMvwWVkeHjU2IysDb0wV40Jhlu5QwJXsBS+0yywKLl1ARYN/5uoFlY
	 g2tkXfy9r+JWYooT9BiEg2OuPMpBPE+KtUycj/56IWDJ0B4SOuJRkYW0nfI/n42DUMPUP
	 3vNM+KUQdncAwVCe99WnE324DBQk4BY6mD+Av62gNDFQXu11ve5gyaF07JYEp50ZZ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RNtVmi56;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7BE606A6C1;
	Fri, 20 Nov 2026 20:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC7BE606A6C1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RNtVmi56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207353;
	bh=hnZN3YRZ98GVF++w/YTWvIy7nXP4wGKxJAAnzb2UsdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNtVmi56Og6HpP1TaMO+H5Q4Kfe+Y9lITZVPTMt7v2o158KVhzsXHlSN7JeMMQr+n
	 ymXgOQ95cCir7A3e6wrs249NSi1Iw0Ymm6asdvZqvmW1AtoVF9Va4e+QrTNwRC2Jz6
	 XolxyzIHBfIOZGj5xa06hKpRDi6Uto+x7r1lW9fR1+URwp5Gb2q6z8Dc4PwnT5DxHu
	 K/5rN29VQOHsOV0xIy/HG+oarkxYqt/v78r5lCIfphklKwQbygHMJpJ5M//+n61rov
	 m8EC75C3nZKJiYO66TYRZYSBip4F+4gs6AG+fz1zKBLowEE8Zi4LRZLDvNmvJmlxxJ
	 KF5j2yZmbkmKQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2J4BmKzVBF;
	Fri, 20 Nov 2026 15:42:32 -0500 (EST)
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
Subject: [PATCH v10 10/40] cgroup/cpuset: Give back the bandwidth an attach did not move
Date: Fri, 20 Nov 2026 15:41:47 -0500
Message-Id: <ef7bab599d38abb18f430bdab29cd3470a4b9b45.1795207232.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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
index e35d4c3045b3..a67a50ecd525 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3672,6 +3672,9 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * Otherwise, the bandwidth stays where it is counted, until the next
 	 * rebuild of the accounting. Moving it without room would leave no
 	 * root domain counting it.
+	 *
+	 * Report in @ctx the bandwidth moved. The caller made its own test
+	 * without the runqueue lock, so it must count only what this reports.
 	 */
 	if ((ctx->flags & SCA_DL_BW_RESERVED) &&
 	    dl_task_needs_bw_move(p, ctx->new_mask)) {
@@ -3700,6 +3703,7 @@ static void set_cpus_allowed_dl(struct task_struct *p,
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

