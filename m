Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207366;
	b=iYPV8NEJM5D7YfUMPm+mxZ3Q8Eb5I/ghrA9D0cpZz4PFaeOrN7Tcy1JMlo6i76GGwOJC
	 9UnljB2li2ZHGld/RPnbjFAGriyA5u0BDjgeNtU5zg+a+cQiOmJJO/s8gBQaN1/vO1j9t
	 AlBYaoE6141eY2PXdDqBgtVfp7ARHKxvf1eFpR+d30o1POAw2LRgdflT3cllzu2LsVKr+
	 msS8s2vuP4LK6R8YJ1ju64Oed9T+9FlA9/o1Kvlh/wM1wvG3AbSVuMLc6vlO5hR7F4b0h
	 escjQvBS0p+LrTW0IHbFxd4NgTafHoPAOogN2LOcMCTl4j63dRn5lIZIjqKgLJ+R8Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207366;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QrrArDQOF4dfm32QJuRH/e7c5ZAzldoowdEh2SWWdhU=;
	b=csP25DKX4YP7ZwV1R9TgXvOSKp2CzWty+z8/nTl2AeB3dPYdiplsFNXO1TfV4+I812Mb
	 Cl7I0VsJx3JvzxKiXqfyNnishnIna6DPpirMB/81f/0qmLzniNcpTXWQoKUMcDIvBQxLG
	 RYbBS7STzSEwGeFgKAdJlGlfPgHjs/dfiVEHxi3eYd0M/QsGwAUo0vmCsmY4kJXq39+3s
	 bstW3LyWYTp7FSMct0pEz74b2zRQb33sqmPKE6b3oIVBrjOK35Eny9wl8lfAJhWyMyqmJ
	 767BfAPsEHWRP3ivc40je9C9m3kMqO1MD/jF9eOy3fnEGVjiEWLKcf4OTIRxHkHj2cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=OmIekafS;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6D260A3817;
	Fri, 20 Nov 2026 20:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB6D260A3817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=OmIekafS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207356;
	bh=QrrArDQOF4dfm32QJuRH/e7c5ZAzldoowdEh2SWWdhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmIekafSLEkCL1F5R/kvhy9DZVcpDh5sqDQDvBDrWTYpl39vbpGBGZt8IKI1Lak1q
	 qHJa4MUoke+LUvvQibl9RpLTngqZuq8+Wz8WCHsF43235cTHGQJy/nz5hgli43LCZc
	 U/hDZZYkqkbt1tSHIbVKiwH7NdXud8JyEnuz/WU+rhAya5oWsUSr9rE0HW74oWSU9O
	 hDlmD4ZLoaUsAzlzikbYCUbbTdW7/nWIJ4ks1mBWhxDiqVpiZX6wm90o4IUk9aTxv/
	 w+lyQOcI3g/hIdUynGIHxYsra8kKh3sWcLE379Ig7VIb3v8tEwYc5BcPv4J65+uCJk
	 /RNHvIlApXH7w==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2N0xcrzSrx;
	Fri, 20 Nov 2026 15:42:36 -0500 (EST)
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
Subject: [PATCH v10 23/40] sched/deadline: Hold a reference on the deadline donor of a boosted task
Date: Fri, 20 Nov 2026 15:42:00 -0500
Message-Id: <19834911fdb02b3941d9021425e247c4b597b210.1795207232.git.mathieu.desnoyers@efficios.com>
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

A task boosted by a SCHED_DEADLINE waiter runs on the parameters of a
donor, dl.pi_se. Since commit 2279f540ea7d ("sched/deadline: Fix
priority inheritance with multiple scheduling classes"),
rt_mutex_setprio() copies the donor of the top waiter to the owner. So
each owner along a chain points at the deadline task at its head.

rt_mutex_setprio() keeps the top waiter, pi_top_task, as a plain
pointer. The top waiter is blocked, so it cannot exit. The donor further
up the chain has no such guarantee. When it stops waiting, the owners
below it are fixed by chain walks. A walk can be preempted, and it runs
in the context of the task that started it, not the donor's.

M, O and P are SCHED_OTHER tasks. W is a SCHED_DEADLINE task:

  P         O              M                          W

  locks L3  locks L2       locks L1
            blocks on L3
                           blocks on L2
                                                      blocks on L1
                                                        M, O, P get W's parameters
                           times out on L2
                             O deboosted
                             walk from O: preempted
                                                      times out on L1
                                                        M not blocked: no walk
                                                      exits
  runs out of runtime
    refill reads P->dl.pi_se:
      W's freed task_struct

P would run on parameters read from freed memory, until M's walk
reaches it.

Setting up the deadline task needs CAP_SYS_NICE. The timeout of a
FUTEX_LOCK_PI needs no privilege. This was found by reading.

Fix this by holding a reference on the donor's task, for each task whose
donor is another task. dl_set_donor() gives a task the donor of its top
waiter. dl_clear_donor() ends the boost. Both move the reference.
put_task_struct() frees the task through call_rcu(), so it can run
under the rq lock. A late walk can still leave P on the parameters of
an exited donor for a while. P now reads them from valid memory.

dl_set_donor() reads the donor of the top waiter without the waiter's
locks. Another CPU can change that donor at the same time, and put the
last reference on the old one. So dl_set_donor() takes its reference
with tryget_task_struct(). If that fails, it reads the new donor
again.

put_task_struct() frees every task through call_rcu() since v6.17:
commit 8671bad873eb ("sched: Do not call __put_task_struct() on rt if
pi_blocked_on is set"). Before it, put_task_struct() frees the task at
once without PREEMPT_RT. So stable trees older than v6.17 need that
commit first.

__dl_clear_params() no longer resets the donor. switched_from_dl() can
call it on a boosted task, before the deboost drops the reference.
init_dl_entity() resets it for a new task, whose copy of the pointer
holds no reference.

No case tests the use after free: it needs a walk preempted at the right
step.

Fixes: 2279f540ea7d ("sched/deadline: Fix priority inheritance with multiple scheduling classes")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org # 6.16.x and older: 8671bad873eb: sched: Do not call __put_task_struct() on rt if pi_blocked_on is set
Cc: stable@vger.kernel.org
---
 kernel/sched/core.c     |  8 +++---
 kernel/sched/deadline.c | 12 ++++++---
 kernel/sched/sched.h    | 56 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/syscalls.c |  4 +--
 4 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3dd42581cc17..9831b4aa5235 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7969,19 +7969,19 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 			if (!dl_prio(p->normal_prio) ||
 			    (pi_task && dl_prio(pi_task->prio) &&
 			     dl_entity_preempt(&pi_task->dl, &p->dl))) {
-				p->dl.pi_se = pi_task->dl.pi_se;
+				dl_set_donor(&p->dl, pi_task);
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				p->dl.pi_se = &p->dl;
+				dl_clear_donor(&p->dl);
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				dl_clear_donor(&p->dl);
 			if (oldprio < prio)
 				scope->flags |= ENQUEUE_HEAD;
 		} else {
 			if (dl_prio(oldprio))
-				p->dl.pi_se = &p->dl;
+				dl_clear_donor(&p->dl);
 			if (rt_prio(oldprio))
 				p->rt.timeout = 0;
 		}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cc5be00b2b0c..a566e9252a41 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -5080,10 +5080,6 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
 	dl_se->dl_bw_oncpu		= 0;
-
-#ifdef CONFIG_RT_MUTEXES
-	dl_se->pi_se			= dl_se;
-#endif
 }
 
 void init_dl_entity(struct sched_dl_entity *dl_se)
@@ -5098,6 +5094,14 @@ void init_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	dl_se->dl_bw = 0;
 	__dl_clear_params(dl_se);
+#ifdef CONFIG_RT_MUTEXES
+	/*
+	 * The copy points at the donor of the parent, without a reference.
+	 * Reset it here only: __dl_clear_params() can run on a boosted entity,
+	 * from switched_from_dl() before the deboost drops its reference.
+	 */
+	dl_se->pi_se = dl_se;
+#endif
 	dl_se->dl_bw_cpu = -1;
 	dl_se->dl_bw_resv_cpu = -1;
 	INIT_LIST_HEAD(&dl_se->dl_departed_node);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e2bb192f1ee6..859d782cc899 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -356,6 +356,62 @@ extern int  sched_dl_global_validate(void);
 extern void sched_dl_do_global(void);
 extern int  sched_dl_overflow(struct task_struct *p, int policy, const struct sched_attr *attr);
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
+#ifdef CONFIG_RT_MUTEXES
+/*
+ * Make @pi_se the deadline donor of @dl_se. The caller holds a reference
+ * on the task of @pi_se, unless @pi_se is @dl_se. Put the reference on
+ * the old donor.
+ */
+static inline void dl_replace_donor(struct sched_dl_entity *dl_se,
+				    struct sched_dl_entity *pi_se)
+{
+	struct sched_dl_entity *old = dl_se->pi_se;
+
+	WRITE_ONCE(dl_se->pi_se, pi_se);
+	if (old != dl_se)
+		put_task_struct(container_of(old, struct task_struct, dl));
+}
+
+/*
+ * Make the deadline donor of the waiter @pi_task the donor of @dl_se. A
+ * boosted entity holds a reference on the task of its donor. The donor
+ * is the deadline task at the head of the chain. It can stop waiting
+ * and exit before the chain walk reaches @dl_se: that walk can be
+ * preempted.
+ *
+ * The donor of @pi_task is read without the locks of @pi_task. Another
+ * CPU can change it meanwhile, and put the last reference on the old
+ * donor. That CPU stores the new donor first: read it again then. The
+ * old task_struct stays readable while the rq lock is held:
+ * put_task_struct() frees it through call_rcu(), and the rq lock holds
+ * off the grace period.
+ *
+ * The caller holds the rq lock and the pi_lock of the task of @dl_se.
+ */
+static inline void dl_set_donor(struct sched_dl_entity *dl_se,
+				struct task_struct *pi_task)
+{
+	struct sched_dl_entity *pi_se;
+
+	for (;;) {
+		pi_se = READ_ONCE(pi_task->dl.pi_se);
+		if (pi_se == dl_se->pi_se)
+			return;
+		if (pi_se == dl_se ||
+		    tryget_task_struct(container_of(pi_se, struct task_struct, dl)))
+			break;
+		/* Pairs with the ordering of refcount_dec_and_test(). */
+		smp_rmb();
+	}
+	dl_replace_donor(dl_se, pi_se);
+}
+
+/* Make @dl_se its own donor. The caller holds the rq lock of its task. */
+static inline void dl_clear_donor(struct sched_dl_entity *dl_se)
+{
+	dl_replace_donor(dl_se, dl_se);
+}
+#endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 2032c37d15e9..0343c7831101 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -300,7 +300,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 		struct task_struct *pi_task = rt_mutex_get_top_task(p);
 
 		if (pi_task) {
-			p->dl.pi_se = pi_task->dl.pi_se;
+			dl_set_donor(&p->dl, pi_task);
 			scope->flags |= ENQUEUE_REPLENISH;
 		}
 	}
@@ -310,7 +310,7 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 	 * the class. Drop its boost then, as rt_mutex_setprio() does.
 	 */
 	if (!dl_prio(newprio))
-		p->dl.pi_se = &p->dl;
+		dl_clear_donor(&p->dl);
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
-- 
2.47.3

