Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207360;
	b=LbsnfrvaARULYaVlSgFE/PK82t0+Fm/SUWENLb3XjdLlty3mnFCO6tb2kcGFNlnLyU8M
	 VQjnU4UlmuAcnd59va3HtdnJxWHX7TIazCf+3EWkfLDAErbqH4vFog38V1ZJgdVW/VDcu
	 AGqQaiexTdyERTb1jGe7LB12nFXFL1dk8ZgRb+/jTuQ2aZFS74b87TtQ8n94ACgOsVlBE
	 4KfOjc5Js1cDvyNOv7ClfMepDNTNIy144f6wSg7Z7QtfAF4FWipTyzXUMzXyaibdRcykU
	 GqXXV2j5JdGVNKTfq982rc+q4JebyC1PPcwjk4KzfpNPT/ab2z5VypBzH9ZV0AqCEEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207360;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I487XIc3524w3N0uKJeUY/n5tZAUwXIO/cYrSOhII1k=;
	b=FBoJ9ApRRlVtmpC5nUs50VXSFMmmVhCsRJCGfCaID5Q7Mlgfvx5n/a0XOxN8yudF1lmJ
	 RO0VPgZqdd7ywiMCjRS3rCPCNNbG0kmIV4L5WpY4sIqjVA6ik3u9Kw7K7DaWN/gJzRMf8
	 8tJ8H+wvrR6LX+CaASlmlZ9kTLTeBc6KQioeLsVRPixqNxVQ8gzKW+31WdcTgjEGFkvoH
	 t5de7VjHNHPOOsIcb0X4JvbPQYrE70wD8Tgl4x01pMOkNmJ3ArX6+jIg6IqF+imAVzx3E
	 VRGKGuiq/w75v6gM2jEHnX27gm/bOeogmTJ+e0y4k56JAtWuX16/CWpj8zrO/+rg4mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RUOzcLJy;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB50F606A332;
	Fri, 20 Nov 2026 20:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB50F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RUOzcLJy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207352;
	bh=I487XIc3524w3N0uKJeUY/n5tZAUwXIO/cYrSOhII1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUOzcLJyre423LkOPm+7FZdlRFP8a9613UrWCr0MSzrVs1btztoFL1ynTDuKsKJ9x
	 pxP+4M2o4IvuRX1AEPiBEUKdeNy/yne3WBOyofH2+hz7IO+xZu9lldI6D1SYLOJMoV
	 aIBvF0IK6o2/T2oyUX6vTwQrMP4cegQBl5F7Wl0+gfP62HRRCgnAXSFvsRqhoikF8I
	 HB5EaV+HC+3Jtvli6Ms6af6YqpaC58B59JXD0ilbvqSDmoc6avqcrMQ63I3x9tDLaM
	 LHvuZn9H7Uq23e0aTWujlEcqgCFAHP/S69yx+Yzs2yBuNBJ+ywLdFSuGKyHhG1OqYM
	 CkLhn6CrRfKAA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2J1RkVzVGH;
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
Subject: [PATCH v10 09/40] sched: Make deadline policy and affinity changes wait for a cpuset attach
Date: Fri, 20 Nov 2026 15:41:46 -0500
Message-Id: <427932da1fb3e9a82c2264cd44919d0e052df229.1795207232.git.mathieu.desnoyers@efficios.com>
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
asks for that test. After a race with a cpuset update,
__sched_setaffinity() sets the mask a second time, within the cpuset.
That second change waits for an attach too, so that the test cannot
skip it. It reads the cpuset mask again after the wait, since the
attach can move the task.

For user-space, these calls now wait until a cpuset attach in progress
ends:

 - sched_setattr() and sched_setscheduler() on a deadline task
 - sched_setattr() that makes a task a deadline task
 - sched_setaffinity() on a deadline task

The attach can be the move of any process. The wait is not
interruptible: a signal does not end it. Outside that window, the
results of these calls are unchanged.

Three cases, added to deadline_bw_test later in this series, test this.
move_became_deadline and move_became_deadline_no_room fail without this
patch. move_affinity_changed fails once the bandwidth is reserved on one
CPU, if sched_setaffinity() does not wait.

A fourth case, move_affinity_became_deadline, covers the second test of
the policy. Its window is a few instructions wide. A delay added after
the first test, for testing only, widens it. The case then fails without
the second test in 3 guests of 3. It passes with it.

Fixes: 710da3c8ea7d ("sched/core: Prevent race condition between cpuset and __sched_setscheduler()")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/cpuset.h  |  2 ++
 kernel/cgroup/cpuset.c  | 11 ++++++++
 kernel/sched/core.c     | 10 +++++++
 kernel/sched/sched.h    |  2 ++
 kernel/sched/syscalls.c | 59 +++++++++++++++++++++++++++++++++++------
 5 files changed, 76 insertions(+), 8 deletions(-)

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
index bd5f3dfa50ac..c0a714dde425 100644
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
index 61c73c7d3f27..f4cd35811b96 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2975,6 +2975,8 @@ extern struct task_struct *pick_task_idle(struct rq *rq, struct rq_flags *rf);
 #define SCA_DL_CHECK		0x10
 /* The caller made room for the deadline bandwidth in the new root domain. */
 #define SCA_DL_BW_RESERVED	0x20
+/* The caller did not wait for a cpuset attach: -EAGAIN for a deadline task. */
+#define SCA_DL_NOWAIT		0x40
 
 extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 95181e5de8da..bcc89a7013d6 100644
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
 
@@ -1253,6 +1258,23 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 
 	cpuset_cpus_allowed(p, cpus_allowed);
 	if (!cpumask_subset(new_mask, cpus_allowed)) {
+		bool locked = false;
+
+		/*
+		 * A sched_setattr() may have made @p a deadline task since
+		 * the first call. SCA_DL_NOWAIT would then skip the second
+		 * call. Wait for a cpuset attach in progress instead, as
+		 * sched_setaffinity() does for a deadline task. That attach
+		 * can move @p to another cpuset: read its mask again after
+		 * the wait.
+		 */
+		if (ctx->flags & SCA_DL_NOWAIT) {
+			ctx->flags &= ~SCA_DL_NOWAIT;
+			cpuset_lock_no_attach();
+			locked = true;
+			cpuset_cpus_allowed(p, cpus_allowed);
+		}
+
 		/*
 		 * We must have raced with a concurrent cpuset update.
 		 * Just reset the cpumask to the cpuset's cpus_allowed.
@@ -1281,6 +1303,8 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 		 */
 		ctx->flags &= ~SCA_DL_CHECK;
 		__set_cpus_allowed_ptr(p, ctx);
+		if (locked)
+			cpuset_unlock();
 		retval = -EINVAL;
 	}
 
@@ -1296,6 +1320,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct affinity_context ac;
 	struct cpumask *user_mask;
 	int retval;
+	bool dl;
 
 	CLASS(find_get_task, p)(pid);
 	if (!p)
@@ -1325,13 +1350,31 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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

