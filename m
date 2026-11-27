Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790183;
	b=LYX5NxCVUhx7KY85uoTvp9LSWGUB657VHFYom5ldiooQshDQsa8qgtqIg3Rrs+VG43VI
	 N6UZclxqSi9Vt/T2c5apRHI0J7GUdiT+4WvkzEUXdKIoduaDzdcFWHHg4Hw36eiwX8b+J
	 TXGCCHMBgMQc3v6+RiJJpTFm7yccEcvNd8H7q/Kkoxo393IholrbfI5MZcw8F8a6fP5L9
	 FTfzoSgx9jfB3slqOPIF80ZrlSEEwmvzAmaTSn4NCsVWkR9B3ycPAxLC1ZyNMdXFRpB6N
	 lpjbRj9FrmZtFMxFlv38oG39watrzbGboHLwja7BYWH/FXoqcmBWvZBJuBRpZancwTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790183;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OX796UPvIDnxa1QufWrOPwcADy6PJwcuEsDsM/bwBj8=;
	b=HPZzsgwgGTdnnbABhl0rpN1+ndA6alBzpicvpEmj825KJFONIsOqvNOZWTqoOsdjZ3fi
	 d+tpd8lB78T29MYWyoodGE7jZ5wGowrYHX5viboAW5LTepfEiipMiQl+S7DF0nCkeSa57
	 P8JO4luj7eLq784K7GCD2ehh2F6ImzwKtmy54QTze09oYHUj8yAXoRLphdjohq69hd++9
	 XNK4l7nDVN9PiULrTQ3AAXBv/5jk7LZdKvYeHOZAujU8QuaHz9qL71PYYYKmTt+SOh1q4
	 TdCjfmTv3J+K0hKFQfS+dbpmweehnYyymJM1IS2OpaC0bwFJBfcLjukmG7TVDnpe5lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bi4lbHkF;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929C606A324;
	Fri, 27 Nov 2026 14:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3929C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bi4lbHkF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790179;
	bh=OX796UPvIDnxa1QufWrOPwcADy6PJwcuEsDsM/bwBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi4lbHkFsWIMh4Pk3mJGSAn0Hz85Gwn0GfigeXRK3EnX3XWwwsj6Cw8WtN80Vn9iM
	 rgWk7gZLI5PM5UaL8Fp8GULIykz40fRtBHK1p+JWq4ExGSq6+sVSz/jr0a+W8hNN+1
	 9ssp7jkJ+wnILrYdmblmjlnuthhJhCARsOfwioAQVXo548HmGW7XJLmzJJONo41HBg
	 rn+4GIK46zXReWrhr0Dx5YGwqvEA55nSmbCninD3DC+gZwkwaoe+6fapUjh5NUpQy1
	 SewdDZid8eT/Oj8HuLhBnG1NQID6jDIcsnWZ1L60ejOjwsw95uCaWc7XjnaUXi2g1o
	 hdz8jkq6AicvA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZW0WSpzXSJ;
	Fri, 27 Nov 2026 09:36:19 -0500 (EST)
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
Subject: [PATCH v12 32/43] sched/deadline: Start a period for a task requeued onto an rt_mutex
Date: Fri, 27 Nov 2026 09:35:59 -0500
Message-ID: <108966f2fba71871167eb2108c0bb126aa2e8668.1795771148.git.mathieu.desnoyers@efficios.com>
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

The waiter node of an rt_mutex holds the deadline of its task, as a sort
key. task_blocks_on_rt_mutex() copies it when the task blocks. A task
that blocks by itself is running, so its deadline is a current one.

FUTEX_CMP_REQUEUE_PI is different. It makes a task that sleeps in
FUTEX_WAIT_REQUEUE_PI wait on the rt_mutex of a PI futex, with
rt_mutex_start_proxy_lock(). That task is not running. Its deadline can
be one that it would never run with:
- 0, if sched_setattr() made it SCHED_DEADLINE while it slept.
  switched_to_dl() leaves its deadline to its next wakeup.
- one that has passed, if it slept past it.
- one with more runtime left than its bandwidth allows until then. Its
  wakeup would give it a new period.

The waiter then sorts before the waiters with a real deadline. At the
unlock, it gets the lock before waiters with earlier deadlines. Its
deadline also decides the boost of the owner.

Fix this in __rt_mutex_start_proxy_lock(), before its trylock: the
trylock reads the deadline too. Add dl_proxy_block(), which applies the
wakeup rule of update_dl_entity() to the requeued task:
- A deadline of 0 gets a new period. So does a deadline that has
  passed, or a runtime that overflows it. For a boosted task, it is a
  period of its donor.
- A task past its deadline and before its next period keeps its
  deadline: its wakeup throttles it until that period. A period started
  now would come before that next period, which the constrained gap
  forbids. So its waiter still sorts first.

__rt_mutex_start_proxy_lock() drops the pi_lock of the task after
dl_proxy_block(). sched_setattr() can then make the task a deadline
task, before task_blocks_on_rt_mutex() sets its waiter node. So
task_blocks_on_rt_mutex() calls dl_proxy_block() again, under that
pi_lock.

futex_lock_pi() also calls __rt_mutex_start_proxy_lock(), with the
current task. That task is running, so its deadline is up to date.
dl_proxy_block() is not called for it.

The Sashiko AI review of this series found this. The case
requeue_pi_new_period of deadline_bw_test, added later in this series,
tests the deadline of 0. It fails without this patch.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched/deadline.h |  1 +
 kernel/locking/rtmutex.c       |  8 +++++
 kernel/locking/rtmutex_api.c   | 12 +++++++
 kernel/sched/deadline.c        | 61 ++++++++++++++++++++++++++++++++--
 4 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 26cda4460604..438a54aa95b1 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -63,6 +63,7 @@ extern int dl_task_bw_reserve_cpu(struct task_struct *p,
 				  const struct cpumask *new_mask);
 extern int dl_task_bw_reserved_cpu(struct task_struct *p);
 extern void dl_task_bw_unreserve(struct task_struct *p);
+extern void dl_proxy_block(struct task_struct *p);
 extern bool dl_task_keeps_root_domain(struct task_struct *p,
 				      const struct cpumask *new_mask,
 				      const struct cpumask *pending);
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index b09816977d4e..49caf38759f3 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1245,6 +1245,14 @@ static int __sched task_blocks_on_rt_mutex(struct rt_mutex_base *lock,
 		return -EDEADLK;
 
 	raw_spin_lock(&task->pi_lock);
+	/*
+	 * A proxy lock blocks a task that is not current: see
+	 * __rt_mutex_start_proxy_lock(). sched_setattr() can have made it a
+	 * deadline task since its call of dl_proxy_block(). Update its
+	 * deadline again, before the waiter node takes it.
+	 */
+	if (task != current)
+		dl_proxy_block(task);
 	waiter->task = task;
 	waiter->lock = lock;
 	waiter_update_prio(waiter, task);
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 6bdbd36bac94..f1246efc62d3 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -342,6 +342,18 @@ int __sched __rt_mutex_start_proxy_lock(struct rt_mutex_base *lock,
 
 	lockdep_assert_held(&lock->wait_lock);
 
+	/*
+	 * A requeued @task sleeps, so its deadline can be stale. The trylock
+	 * below and the waiter node both read it: update it first.
+	 * futex_lock_pi() passes current, which is running. Its deadline is
+	 * up to date.
+	 */
+	if (task != current) {
+		raw_spin_lock(&task->pi_lock);
+		dl_proxy_block(task);
+		raw_spin_unlock(&task->pi_lock);
+	}
+
 	if (try_to_take_rt_mutex(lock, task, NULL))
 		return 1;
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6e20efb86359..3eeb4c5cd924 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1717,6 +1717,61 @@ static inline u64 dl_next_period(struct sched_dl_entity *dl_se)
 	return dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period;
 }
 
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * FUTEX_CMP_REQUEUE_PI makes @p wait on an rt_mutex while @p sleeps.
+ * The waiter node of @p takes its deadline before any wakeup. So apply
+ * the wakeup rule of update_dl_entity() to @p now:
+ * - A deadline of 0, which a task that entered the class asleep has,
+ *   gets a new period.
+ * - A constrained task past its deadline and before its next period
+ *   keeps its deadline. Its wakeup throttles it until that period. Its
+ *   waiter node keeps that passed deadline, and sorts first.
+ * - Any other task gets the check of update_dl_entity(). A deadline
+ *   that has passed gets a new period.
+ *
+ * The caller holds the pi_lock of @p.
+ */
+void dl_proxy_block(struct task_struct *p)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq_flags rf;
+	struct rq *rq;
+
+	if (!dl_task(p))
+		return;
+	rq = __task_rq_lock(p, &rf);
+	update_rq_clock(rq);
+	if (task_on_rq_queued(p) || dl_se->dl_throttled)
+		goto unlock;
+	/*
+	 * A boosted task runs on the parameters of its donor. Start a period
+	 * from them if its deadline is 0 or has passed, or if its runtime
+	 * overflows it, as at a wakeup. A task in the class
+	 * with no runtime of its own is always boosted: the test of
+	 * dl_runtime is only a guard.
+	 */
+	if (is_dl_boosted(dl_se) || !dl_se->dl_runtime) {
+		if (!dl_se->deadline ||
+		    dl_time_before(dl_se->deadline, rq_clock(rq)) ||
+		    dl_entity_overflow(dl_se, rq_clock(rq)))
+			replenish_dl_new_period(dl_se, rq);
+		goto unlock;
+	}
+	if (!dl_se->deadline) {
+		replenish_dl_new_period(dl_se, rq);
+		goto unlock;
+	}
+	if (!dl_is_implicit(dl_se) &&
+	    dl_time_before(dl_se->deadline, rq_clock(rq)) &&
+	    dl_time_before(rq_clock(rq), dl_next_period(dl_se)))
+		goto unlock;
+	update_dl_entity(dl_se);
+unlock:
+	__task_rq_unlock(rq, p, &rf);
+}
+#endif
+
 /*
  * If the entity depleted all its runtime, and if we want it to sleep
  * while waiting for some new execution time to become available, we
@@ -4989,9 +5044,9 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 		 * A task that comes back to the class before its 0-lag time
 		 * keeps its deadline. For a constrained task, that deadline
 		 * can have passed before its next period. As
-		 * dl_check_constrained_dl() does, leave such a task alone
-		 * unless it is boosted. Its wakeup throttles it until its
-		 * next period.
+		 * dl_check_constrained_dl() and dl_proxy_block() do, leave
+		 * such a task alone unless it is boosted. Its wakeup
+		 * throttles it until its next period.
 		 */
 		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
 		    dl_time_before(p->dl.deadline, rq_clock(rq)) &&
-- 
2.47.3

