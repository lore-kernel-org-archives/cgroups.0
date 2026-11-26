Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655360;
	b=ahvaYlNgbdFTMjPaEFEHpHcJ1Pbh13iKlFxLTCBWF0ylrKM0ucuwa+zAgnhfJxZC3jg8
	 wJi4Es6I0nKd+/GMsIKHktBJ/VnhwxGcwWwdscNzsDepPR+cihkpxj9FsqzMdKYo71owt
	 hPkkZWnOWyLPKvOnCUYKmQfZDyA/tD5r+oHepm6J9XaWJzQGiPk2V374XVIvrh8i+V5Vq
	 0QgUxEpc30aat/cacjiICcMZYdNPmcEoMCs1aPhZL6g5PRKTVZdjGESY2aGY291cimsFv
	 gRTq+nELGg2X2nZmU0R25CwpxI0t6wrZ6hU/JtGxNlY2PPweKPzHMKDDGphmefgW7Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655360;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Gj7cQyLqbkfd+mvPCfwN5H4avZFH51htWBsAS1Pa0GY=;
	b=P+2nZkjwQ3Sxb6puleXDPSY1U051k/DmQuyzbRgd40dgqP8131T1Gj4vIBR7NMWUqus2
	 VRf5JxpqG7Tg9SSY6+UCsKa2PU4HaqiC4JIzMusk5bltkVkVfLRMOKRnyHT1b0/IkBXoA
	 cJng0c8uWmMYcRuMUEbC4PeHZn3uRg8Kk1wK0ekA6XlvcJDaY2uYbIVN36sR9ZR9qJctz
	 ayxxiDlXgG1ksaSbt9oBZqoo9sPVvKbaYVQIfVGLMrhalodNKTmAERr4EF6Y6YxmyZEZM
	 +XedExjTG3R1C3MVMH90T5IGpYVRe78dW5jmYKlpyYpMFywwY53axNjIOMz+RVLH5zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PsTwabY8;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5A36072D96;
	Thu, 26 Nov 2026 01:09:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B5A36072D96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PsTwabY8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655358;
	bh=Gj7cQyLqbkfd+mvPCfwN5H4avZFH51htWBsAS1Pa0GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsTwabY8+KFxuguZdQYveGOGseri4Qs931uINWFIPLHZrw3v4huWVSGBNGnUnXHOi
	 f4FJIs0t1jgPRUFSn1OJQWBxERnMnivGHAWhSvmzefP9OuC1VYwjg2pSOKLBLpBgEt
	 z9m11gQmpmkEwSRn29ShKHMXh0Cf4O5ZPNSamV05BZlVFi76mdFitMGgcSky4EIyku
	 4x0aDXs64sGIqj/BYjmt5gM+IBNzszycDfu5DZeOSRdDIG8qaHs2BDALgStpqHHmF6
	 1DQ2oHacMLnpT8TU2mNnnhLigRt3ZPKsloPCeY+6yTQ4hC85qomiVNBwu4hPuuOUfl
	 HI7j/MuIi1hxQ==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjn5jQzzWx7;
	Wed, 25 Nov 2026 20:09:17 -0500 (EST)
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
Subject: [PATCH v11 41/43] sched/deadline: Run a boost held at its first refill on a donor period
Date: Wed, 25 Nov 2026 20:08:40 -0500
Message-ID: <a6b6005cb9ccdba38560bbc40d1a22649432b14d.1795646915.git.mathieu.desnoyers@efficios.com>
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

"sched/deadline: Restore the owner's period at a deboost in the class",
earlier in this series, holds a boost at its first refill from the
donor. It saves the owner's own period, and puts it back at the
deboost. But the refill itself is the one of replenish_dl_entity(): it
adds the donor's runtime, and moves the owner's own deadline by the
donor's period. That deadline is often later than the waiter's. The
donor's runtime also pays for the owner's overrun.

"sched/deadline: Boost an owner that cannot run on its own
reservation" runs a boost held from its start on a donor period
instead: a period with the donor's parameters, which starts at the
boost. It also limits the owner to one donor runtime per donor period:
the next held boost resumes the donor period of the last one. A boost
held at its first refill gets neither. A waiter that times out on the
lock again and again would then give the owner one donor runtime per
boost. Other deadline tasks would then miss their deadlines.

Fix this by running a boost held at its first refill on a donor period
too. dl_hold_refilled_boost() calls dl_boost_donor_period(), which
resumes the donor period of the last held boost, or starts a new one.
dl_note_donor_refill() returns true when a donor period was placed, and
replenish_dl_new_period() then keeps it. None is placed when the
donor's parameters were cleared: replenish_dl_entity() adds no runtime
then.

This was found in a user-space model of the CBS, not reproduced on a
kernel. No case of deadline_bw_test fails without this patch.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 70 +++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 52095e24638c..3d573bf812ee 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -172,26 +172,30 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 	return pi_of(dl_se) != dl_se;
 }
 
-static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
+static bool dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
 
 /*
  * Record that a replenishment changes the runtime of @dl_se while
- * boosted. At the first refill, hold the boost: dl_hold_refilled_boost()
- * saves the task's own period. Call this before the replenishment moves
- * the deadline or adds runtime. A task with no parameters of its own at the
- * first refill has no period to save. Later refills of its boost leave it
- * as it is, even if the task gets parameters meanwhile.
+ * boosted. At the first refill of a boost that is not held, hold it. Call
+ * this before the replenishment changes the deadline and the runtime:
+ * dl_hold_refilled_boost() saves them, and places a period of the donor.
+ * Return true if it placed one: the caller must keep that period. It
+ * places none if the donor's parameters were cleared. A task with no
+ * parameters of its own at the first refill has no period to save. Later
+ * refills of its boost leave it as it is, even if the task gets
+ * parameters meanwhile.
  */
-static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+static inline bool dl_note_donor_refill(struct sched_dl_entity *dl_se)
 {
 	bool first;
 
 	if (!is_dl_boosted(dl_se))
-		return;
+		return false;
 	first = !dl_se->dl_donor_refill;
 	dl_se->dl_donor_refill = 1;
-	if (first && dl_se->dl_runtime && !dl_se->dl_boost_held)
-		dl_hold_refilled_boost(dl_se);
+	if (!first || !dl_se->dl_runtime || dl_se->dl_boost_held)
+		return false;
+	return dl_hold_refilled_boost(dl_se);
 }
 
 static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
@@ -563,8 +567,9 @@ static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 	return dl_se;
 }
 
-static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+static inline bool dl_note_donor_refill(struct sched_dl_entity *dl_se)
 {
+	return false;
 }
 
 static inline void dl_request_owner_boost(struct task_struct *p)
@@ -1663,11 +1668,13 @@ static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
 static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 					    struct rq *rq)
 {
-	dl_note_donor_refill(dl_se);
-	/* for non-boosted task, pi_of(dl_se) == dl_se */
-	dl_se->period_start = rq_clock(rq);
-	dl_se->deadline = dl_se->period_start + pi_of(dl_se)->dl_deadline;
-	dl_se->runtime = pi_of(dl_se)->dl_runtime;
+	/* A boost held from this refill keeps the period it placed. */
+	if (!dl_note_donor_refill(dl_se)) {
+		/* for non-boosted task, pi_of(dl_se) == dl_se */
+		dl_se->period_start = rq_clock(rq);
+		dl_se->deadline = dl_se->period_start + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
+	}
 
 	/*
 	 * If it is a deferred reservation, and the server
@@ -6002,11 +6009,14 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
 
 #ifdef CONFIG_RT_MUTEXES
 /*
- * A boosted task is refilled from its donor when its runtime is used up,
- * or when its deadline has passed. A wakeup also refills it when the
- * donor's density does not allow the runtime left. From then on, the task
- * runs on the donor's reservation. So save the task's own period in own_*
- * at the first refill: this holds the boost. dl_deboost() puts it back.
+ * A boost that is not held runs the task on its own reservation. The task
+ * is refilled from its donor when its runtime is used up, or when its
+ * deadline has passed. A wakeup also refills it when the donor's density
+ * does not allow the runtime left. From then on, the task runs on the
+ * donor's reservation. So hold the boost at the first refill. Save the
+ * task's own period in own_*, and run the task on a period of the donor,
+ * resumed or new: see dl_boost_donor_period(). dl_boost_start() does the
+ * same at the start of a boost.
  *
  * Keep the runtime left if the task's own deadline is still ahead.
  * Otherwise save no runtime. A negative runtime is an overrun that comes
@@ -6016,11 +6026,15 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
  * If sched_setattr() changed the parameters before this refill,
  * dl_setattr_period() saved the old ones in setattr_*. Fit the period
  * saved in own_* to the new parameters with them. setattr_* share
- * storage with own_*: read them before writing own_*. The caller holds
- * the rq lock of the task, and has updated the rq clock.
+ * storage with own_*: read them before writing own_*. Return true if a
+ * period of the donor was placed. The caller holds the rq lock of the
+ * task, and has updated the rq clock.
  */
-static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
+static bool dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
 {
+	struct sched_dl_entity *pi_se = pi_of(dl_se);
+	u64 donor_runtime = READ_ONCE(pi_se->dl_runtime);
+	u64 donor_deadline = READ_ONCE(pi_se->dl_deadline);
 	u64 old_runtime = dl_se->setattr_runtime;
 	u64 old_deadline = dl_se->setattr_deadline;
 	u64 old_period = dl_se->setattr_period;
@@ -6037,6 +6051,14 @@ static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
 		dl_setattr_place(dl_se, now, &dl_se->own_period_start,
 				 &dl_se->own_deadline, &dl_se->own_runtime,
 				 old_runtime, old_deadline, old_period, false, false);
+	/*
+	 * replenish_dl_entity() checks the donor's parameters: it adds no
+	 * runtime if they were cleared. Start no period from them then.
+	 */
+	if (!donor_runtime || !donor_deadline)
+		return false;
+	dl_boost_donor_period(dl_se);
+	return true;
 }
 #endif /* CONFIG_RT_MUTEXES */
 
-- 
2.47.3

