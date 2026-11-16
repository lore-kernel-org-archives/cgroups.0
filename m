Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855968;
	b=IRQrXBg0IoKjo3xE74G4o/OgVlfB0nosS6JNdPL5Rdu3Il7H3at6yWQHf9UXOwg1FSGB
	 74NTx4TBERuaLF8bkSuamhHzY8ad6kDqsBLeVXV0bg3w8xum38hDGuV2aMWfrumZ7xC2s
	 fyZe0BdKoYfGtAmY8lpNgOFt303mLXJ423i3UdIzr1CZcYqaJ6bCzAwjIdjMEhcShc+87
	 PnGBE4NZ7Sxs+W3mBpt83XGZlc1maB+DnhpkUUJ5WnBDYeiIvmsGSvUHDwvKAgf7vl4aA
	 rysKZuwdyCJoLOT1zr4gLevRQ5GGEg1heAAC7pHUZqLTHFDHm5/AwGCOsjNIImVbPTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fZ8Enw30wviSg8JLsteg3jvTnTtyUQCTo/8IOBhcAc4=;
	b=hSulZbkkoGEljP5iQaY7lDAg5k23N9R/7oyTRdHUmWL8DjRwN8wpBVnynwUOFk09gEr9
	 636pVbVJWp+N7uYPipp9qYa7nuiWvcxxecSgD/hilBHeHFLw+A4gEXBmMyPfNI4sVfrhx
	 KwqdKfE5ESUtP4QXnDLHkowIh78+EhoPFZngT/6Hgh8FpdjBUpNouOutVQTDtMI0HkUjF
	 HtimuUR8K5gxFBW3zbGYstvIEOthSzLFpO/uy9SA+E77A+xDQz0RbafmsJY9Aeyt/ZQEX
	 nyJI3TOh/T8n7eCVeIbi6379pY/l+kRNsfVXP9NygyuabvoRKBqfDf1mzijgTiW3+QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wDlTGY9Z;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247E1606A8B8;
	Mon, 16 Nov 2026 19:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 247E1606A8B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wDlTGY9Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855957;
	bh=fZ8Enw30wviSg8JLsteg3jvTnTtyUQCTo/8IOBhcAc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDlTGY9ZEWZFiJWrjpqIfz88G+wJrx+ZYOGiuHXQF4nTLF0CsqNSaE60jd8aGMnGn
	 LfJmhtRzG+8mpzhovnQCfw56WHg0YgnXs62IfSinLIkg18O8dxeWfYtYOf3HbGqD6x
	 tnpuWfOgHQZoSVQifcvwpxz/yufWW9P4D6I52Jz3i2vMbXQ0os5Y/wS5rhDahbEQCj
	 6LrcUkybofKAhyLlO5P97OxnVEvbMY7+mr8AmG0oMISIpZScL8IXUEV6bDfYgI6q7n
	 DQ7vcTdDDp9ccP3QOKOrpVEX2px7mfDDtL93WpmMxX3kXtEDCyrILwHr0pxoSxhXb0
	 JaR7KZhEGhAVw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4j4CrMzQjH;
	Mon, 16 Nov 2026 14:05:57 -0500 (EST)
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
Subject: [PATCH v6 21/37] sched: Make deadline policy and affinity changes wait for a cpuset attach
Date: Mon, 16 Nov 2026 14:05:33 -0500
Message-Id: <20261116190549.230119-22-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() takes cpuset_mutex for a change that involves
SCHED_DEADLINE. Commit 710da3c8ea7d ("sched/core: Prevent race condition
between cpuset and __sched_setscheduler()") added that lock. It keeps
the cpuset code from changing the root domains while the deadline
admission test runs.

But a cpuset attach drops cpuset_mutex between cpuset_can_attach() and
cpuset_attach(). A sched_setattr() can run in between. Take a process
in the root cgroup. It has deadline threads, and a thread T that is not
a deadline task. The process is moved into a partition root P:

  echo PID > P/cgroup.procs              sched_setattr(T, SCHED_DEADLINE)

  cpuset_can_attach()
    lock cpuset_mutex
    reserve room in P for the deadline
      threads: T is not one of them
    unlock cpuset_mutex
                                         lock cpuset_mutex
                                         admit T in the root domain it
                                           is still in
                                         unlock cpuset_mutex
  cpuset_attach()
    lock cpuset_mutex
    move T to P, where nothing is
      reserved for it
    unlock cpuset_mutex

The attach still moves the bandwidth of T. It is freed in the root
domain T left, and P has no room reserved to count it. No root domain
counts it any more, and P can admit deadline tasks beyond its capacity.

In testing, P was a one-CPU partition root, which admits 95%. The
process had two sleeping deadline threads of 30% each, and
sched_setattr() made T a deadline task of 40%. The move and the
sched_setattr() both succeeded, with no room in P for the three. With
threads of 20% and a T of 30%, P then admitted five more tasks of 10%,
where it had room for two.

Fix this by taking cpuset_mutex in __sched_setscheduler() only when no
attach is in progress. cpuset_partition_write() and
cpuset_hotplug_update_tasks() already wait for an attach that way. A
deadline policy change then comes before the attach, and is part of its
reservation, or after it.

With this patch, and no room in P for the three, the two never both
succeed. If the sched_setattr() comes first, the move is refused with
EBUSY. If it comes after, T has its new CPUs and has not run on them.
The call is then refused with EPERM, as for any sleeping task moved to
another partition.

sched_setaffinity() on a deadline task can run in between as well. A
later patch of this series reserves the bandwidth of the task on one CPU
of its new affinity, and records that CPU with the task. It is
"cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
to". A new affinity in between could leave that CPU out. cpuset_attach()
would then move no bandwidth, and the task would stay counted in the
root domain it left. So sched_setaffinity() waits the same way when the
task is a deadline task.

sched_setaffinity() tests the policy with no lock, before it decides to
wait. A sched_setattr() can make the task a deadline task right after
that test. So test the policy again under the runqueue lock, where the
mask changes. If the task is a deadline task there and the caller did
not wait, the call starts over, and waits. The new SCA_DL_NOWAIT flag
asks for that test.

For user-space, these calls now wait until a cpuset attach in progress
ends:

 - sched_setattr() and sched_setscheduler() on a deadline task
 - sched_setattr() that makes a task a deadline task
 - sched_setaffinity() on a deadline task

The attach can be the move of any process. The wait is not
interruptible: a signal does not end it. Outside that window, the
results of these calls are unchanged.

Three cases of deadline_bw_test, added later in this series, test this.
move_became_deadline and move_became_deadline_no_room fail without this
patch. move_affinity_changed fails once the bandwidth is reserved on
one CPU, if sched_setaffinity() does not wait.

A fourth case, move_affinity_became_deadline, covers the second test of
the policy. Its window is a few instructions wide. A delay added after
the first test, for testing only, widens it. The case then fails without
the second test in 3 guests of 3. It passes with it.

Fixes: 710da3c8ea7d ("sched/core: Prevent race condition between cpuset and __sched_setscheduler()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h  |  2 ++
 kernel/cgroup/cpuset.c  | 11 +++++++++++
 kernel/sched/core.c     | 10 ++++++++++
 kernel/sched/sched.h    |  2 ++
 kernel/sched/syscalls.c | 40 ++++++++++++++++++++++++++++++++--------
 5 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index db1cc2fc0324..5d0c01a25354 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -73,6 +73,7 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_lock(void);
+extern void cpuset_lock_no_attach(void);
 extern void cpuset_unlock(void);
 extern void lockdep_assert_cpuset_lock_held(void);
 extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
@@ -192,6 +193,7 @@ static inline void cpuset_update_active_cpus(void)
 }
 
 static inline void cpuset_lock(void) { }
+static inline void cpuset_lock_no_attach(void) { }
 static inline void cpuset_unlock(void) { }
 static inline void lockdep_assert_cpuset_lock_held(void) { }
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 51b6be460794..ce9c57617f49 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -378,6 +378,17 @@ static void wait_attach_done_lock(void)
 	}
 }
 
+/**
+ * cpuset_lock_no_attach - Acquire cpuset_mutex with no task attach in progress
+ *
+ * A task attach drops cpuset_mutex between cpuset_can_attach() and
+ * cpuset_attach(). Use this to keep a change out of that window.
+ */
+void cpuset_lock_no_attach(void)
+{
+	wait_attach_done_lock();
+}
+
 static inline void check_insane_mems_config(nodemask_t *nodes)
 {
 	if (!cpusets_insane_config() &&
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2a964286a7cd..52c291de384e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3195,6 +3195,16 @@ static int __set_cpus_allowed_ptr_locked(struct task_struct *p,
 		goto out;
 	}
 
+	/*
+	 * sched_setaffinity() tested the policy with no lock, and did not
+	 * wait for a cpuset attach in progress. @p became a deadline task
+	 * since: let the caller wait and try again.
+	 */
+	if ((ctx->flags & SCA_DL_NOWAIT) && task_has_dl_policy(p)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	/*
 	 * Check under the same lock that __sched_setscheduler() holds for
 	 * its admission test, so that p cannot become SCHED_DEADLINE
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9e3ca69abc36..2087ad70c56e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2985,6 +2985,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_DL_CHECK		0x10
 /* The caller made room for the deadline bandwidth in the new root domain. */
 #define SCA_DL_BW_RESERVED	0x20
+/* The caller did not wait for a cpuset attach: -EAGAIN for a deadline task. */
+#define SCA_DL_NOWAIT		0x40
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 4f47b17151ed..70b364b4f82d 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -564,10 +564,15 @@ int __sched_setscheduler(struct task_struct *p,
 	 * information. Do not take cpuset_mutex when pi is unset: the
 	 * caller is normalize_rt_tasks(), which holds tasklist_lock and
 	 * cannot sleep.
+	 *
+	 * Wait for a task attach in progress. cpuset_can_attach() reserved
+	 * the bandwidth of the deadline tasks it saw, and cpuset_attach()
+	 * moves them. A task that enters or leaves the class in between
+	 * would not match that reservation.
 	 */
 	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
-		cpuset_lock();
+		cpuset_lock_no_attach();
 		dl_accounting_lock();
 	}
 
@@ -1289,6 +1294,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct affinity_context ac;
 	struct cpumask *user_mask;
 	int retval;
+	bool dl;
 
 	CLASS(find_get_task, p)(pid);
 	if (!p)
@@ -1318,13 +1324,31 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 		return -ENOMEM;
 	}
 
-	ac = (struct affinity_context){
-		.new_mask  = in_mask,
-		.user_mask = user_mask,
-		.flags     = SCA_USER,
-	};
-
-	retval = __sched_setaffinity(p, &ac);
+	/*
+	 * Wait for a cpuset attach in progress before changing the affinity
+	 * of a deadline task. cpuset_can_attach() reserved the bandwidth of
+	 * the task for the CPUs it moves to, and cpuset_attach() moves it
+	 * there. A new affinity in between could change those CPUs.
+	 *
+	 * The policy is tested here with no lock. A task that becomes a
+	 * deadline task after this test is found under its runqueue lock,
+	 * with SCA_DL_NOWAIT. Wait and try again then.
+	 */
+	for (;;) {
+		dl = task_has_dl_policy(p);
+		ac = (struct affinity_context){
+			.new_mask  = in_mask,
+			.user_mask = user_mask,
+			.flags     = SCA_USER | (dl ? 0 : SCA_DL_NOWAIT),
+		};
+		if (dl)
+			cpuset_lock_no_attach();
+		retval = __sched_setaffinity(p, &ac);
+		if (dl)
+			cpuset_unlock();
+		if (dl || retval != -EAGAIN)
+			break;
+	}
 	kfree(ac.user_mask);
 
 	return retval;
-- 
2.47.3

