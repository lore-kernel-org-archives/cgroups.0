Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790177;
	b=GgFd6uzWAWYeS0m1ICIOtZstlNsKa+mvwXtxftpvjDOiYp3yDDWu7cOeNC88YcK+JRjC
	 2KGcaQ3Bsy3JGPzVJFQwGvaNneZEds1/lqx52h0wgQrbUX4ocK7htzY7h59fZ7xkiPZwG
	 DD514a+ykj6tIdrD602B/j9t8x7L05yeG8bTYTTb4SNklGnyDg0QznS2pmT/VGewtOndI
	 Fh+8Wgymd+Py2j+BWedYtlnhpl7SWiNw6GxXrAjreXxAmMlgnZVkMGSlBXFBf7BsGYaNq
	 4Y5RW1N4fUQDD5Z/jYvD02S2t+7PcXrqFv43QD35W+aBvNkfNUq+SFCKmBfcnEhYOjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790177;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F/0ZXZ248yq4kJ5ThhFr2mxlWVc3QcOwqs4pgKtEuc0=;
	b=LFuMSzDm2a42jakbi9KOJKNG40Zi3+QhpkWyOSuoQKc/JreHL86biY6BSUtUco72GG/J
	 XSpTzYfXgp/6klQhH3O8d8VxKjdQBo5b8Lluld9Pkxd2Hc3Eg4hlu3w7LgV0nYxZ47mWy
	 c3zySF48dHcaHVfMLYTDl9/mjsYjoi3gBJJ7iQosN41uQF26FMII7PwmgNe/tq9MxlyiV
	 ZPyyslkisMLVYa2XRQ+G/8altApDDK0D94jDnZHIFSUJ14IjJYaFF9zIJiORcKM3IaEXR
	 dds3M6MtUSxAl40FIG/gAEqLtk0PDfdKECF4gk7qRI8+8rceOx+iQowmJPVPMptaCZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iew95eVd;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B0F606A332;
	Fri, 27 Nov 2026 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2B0F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iew95eVd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790175;
	bh=F/0ZXZ248yq4kJ5ThhFr2mxlWVc3QcOwqs4pgKtEuc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iew95eVdssUWc+QtfbGU6nJ2LZrkZ8cuEkhXAJKsPKCXYOs33hUitaYkSG3di7188
	 v62Jiupl2+s1OIbEnNqVkwlVpXh2ccgqFHtVgTYJaems7xEmM6NJ2V8Foem12eYlkW
	 4f0t9WFP+JxdzolwNemoitkZClhU3zWPWiMY4sKeDMAkGFF8ULu4iwJY3KXp7K/5VK
	 Y6T44BQVlqAKcGhixLVX1KO1ji2kdmwZqhk8xeavM4oxfigqyaGgSrzNQdOWbx965t
	 CWPQqg5mCDuyMf/J+DrLo0K3OJvDPR8RHWhBTG5UyhCOj+zwsIjoPdJzOVZEnjN8La
	 yAtKj5ZKch7bQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZR05czzXFV;
	Fri, 27 Nov 2026 09:36:15 -0500 (EST)
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
Subject: [PATCH v12 09/43] sched: Make deadline policy and affinity changes wait for a cpuset attach
Date: Fri, 27 Nov 2026 09:35:36 -0500
Message-ID: <43274f50e7cf073b6e52908815fe1decdb62b914.1795771147.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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
In testing, P was a one-CPU partition root, which admits 95%. With two
deadline threads of 20% and a T of 30%, P then admitted five more tasks
of 10%, where it had room for two.

Fix this by making these calls wait until no cpuset attach is in
progress:
 - sched_setattr() and sched_setscheduler() on a deadline task
 - sched_setattr() that makes a task a deadline task
 - sched_setaffinity() on a deadline task

They take cpuset_mutex only when no attach is in progress, as
cpuset_partition_write() and cpuset_hotplug_update_tasks() already do.
A policy change then comes before the attach and is part of its
reservation, or comes after it.

sched_setaffinity() needs the wait for a later patch of this series,
"cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
to". That patch reserves the bandwidth of the task on one CPU of its
new affinity, and records that CPU with the task. A new affinity in
between could leave that CPU out. cpuset_attach() would then move no
bandwidth, and the task would stay counted in the root domain it left.

sched_setaffinity() tests the policy with no lock, before it decides to
wait. A sched_setattr() can make the task a deadline task right after
that test. The new SCA_DL_NOWAIT flag tells __set_cpus_allowed_ptr()
that the caller did not wait. It then tests the policy again under the
runqueue lock, where the mask changes. For a deadline task, it returns
-EAGAIN, and sched_setaffinity() starts over and waits.

After a race with a cpuset update, __sched_setaffinity() sets the mask a
second time, within the cpuset. That second change cannot start over.
So it clears SCA_DL_NOWAIT and waits for an attach itself. It reads the
cpuset mask again after the wait, since the attach can move the task.

For user-space, the calls listed above can now wait for the move of any
process. The wait is not interruptible: a signal does not end it.
Outside that window, the results of these calls are unchanged. When P
has no room for the three threads, the move and the sched_setattr() no
longer both succeed:
 - If the sched_setattr() comes first, the move fails with EBUSY.
 - If it comes after, sched_setattr() asks P for room, and fails with
   EBUSY.

Four cases, added to deadline_bw_test later in this series, test this:
 - move_became_deadline: the case above, with room in P. It fails
   without this patch.
 - move_became_deadline_no_room: two threads of 30% and a T of 40%.
   Without this patch, the move and the sched_setattr() both succeeded.
 - move_affinity_changed fails once the bandwidth is reserved on one
   CPU, if sched_setaffinity() does not wait.
 - move_affinity_became_deadline covers the second test of the policy.
   Its window is a few instructions wide. A delay added after the first
   test, for testing only, widens it. The case then fails without the
   second test in 3 guests of 3. It passes with it.

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
index 41c568fc514e..4e0e6a326e5b 100644
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
 
@@ -1254,6 +1259,23 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 
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
@@ -1282,6 +1304,8 @@ int __sched_setaffinity(struct task_struct *p, struct affinity_context *ctx)
 		 */
 		ctx->flags &= ~SCA_DL_CHECK;
 		__set_cpus_allowed_ptr(p, ctx);
+		if (locked)
+			cpuset_unlock();
 		retval = -EINVAL;
 	}
 
@@ -1297,6 +1321,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct affinity_context ac;
 	struct cpumask *user_mask;
 	int retval;
+	bool dl;
 
 	CLASS(find_get_task, p)(pid);
 	if (!p)
@@ -1326,13 +1351,31 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
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

