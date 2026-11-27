Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790187;
	b=1dfe2jm5L+aS/xlj0mOR+LkpgwDDVT+zbwGfTaThHT2N3eDjPg7b9XmmlXb5OQFmbx3/
	 mD/cfb2fJjvG/sHwRPDzQZrMcJ25EGQ125x24IycGpZ+oFfoOOnXxIJC5QT2cbLYjyGAf
	 95Fq97DNPwqQVwF4tdYY2By8Urd5I+pyUr9BF4VpS2ug4P11ueU20C/gqaM2b1HilShFv
	 ZaLtFVEgNeIpOHkri7UbfA0VSn++KINgF+HRRIpnuJmyzOlfqfBLtAo8d2MRnBadeHoOa
	 p0x9cU6QYXCdZHLuGIYg2RMS11vB5IuMuQ0tTDzzuz+MmkYyr8SMPj2z1thYc7iwLtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F70wYfHpb7eRz9tPDAYNhrZLCIQZ6QvghIBt91bo+VU=;
	b=4wdnetFQjWR5xNCIlNZ4bygI+84xY7MZ0pJNWQCadjVQfZcGiYYFnDgs++KLXDVl8bxA
	 zoUG02nJP2v0QdqUjTu563jb7B0BWdopWPUii6qdg2Navg2TvUT+GDARVq2hjPbVl9XAz
	 ROpsEDRJ/bcb/vrv2taOXCNjBVL8v8GbQ7kWqlddi+EBjrHI6s9FI2IeZioQHZ2lKy2AS
	 i6aC7BBrplLRZZafVnoZs/RHAEstXW5gdwy/0znRMvdD2d2ENRc4vecAzXmM0bWA066+0
	 L1kqetq/LWLcaFtu9J1bK16psQIvQyw07/bc1MByau1TYrU1f8yLT/HLuuu+yq0qtfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=lKi67kbk;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA84606A689;
	Fri, 27 Nov 2026 14:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDA84606A689
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=lKi67kbk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790180;
	bh=F70wYfHpb7eRz9tPDAYNhrZLCIQZ6QvghIBt91bo+VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKi67kbk6qGG34IoJHGIwNf31iz5kvgl+AemjVlQVVxB4v4cKANekiIIUTKoFQBWl
	 ny5PrTyzacBMU6ot/nvqVqqibSLNhZXa4cmQDxU/fVBVs+lYAraDd1mpU9yMQV0C+b
	 Ms+UFdkOYyRmnU+Npsv+zt1N5/+zT5mVPDUhXF9oAYcJQaN+e+YpwQaTcXN4X6Rt9F
	 ISFRDeybmxm1DyGTrsZ5NVG1L0Li3sCVxe3Xt8x8fgMsnbFLVmEFC3I52+UAP+uPMZ
	 /Q3JJKn/asIJQV+uI8XrRgVyu7btrMdWRiaF9k+knMnm4rJlL3M/2Ra0bNoO55hSa6
	 m7YA8m8ggzfRQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZX56FzzXK8;
	Fri, 27 Nov 2026 09:36:20 -0500 (EST)
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
Subject: [PATCH v12 41/43] sched/deadline: Run a boost held at its first refill on a donor period
Date: Fri, 27 Nov 2026 09:36:08 -0500
Message-ID: <5b1fecd307f51ac34910dc854f64c64a63dbb7e3.1795771148.git.mathieu.desnoyers@efficios.com>
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
 kernel/sched/deadline.c | 74 ++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b9dd7ec10e7d..f4e07aa47715 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -196,28 +196,32 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 	return pi_of(dl_se) != dl_se;
 }
 
-static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
+static bool dl_hold_refilled_boost(struct sched_dl_entity *dl_se);
 
 /*
  * Record that a replenishment changes the runtime of @dl_se while
- * boosted. At the first refill, hold the boost: dl_hold_refilled_boost()
- * saves the task's own period. Call this before the replenishment moves
- * the deadline or adds runtime. A task with no parameters of its own at the
- * first refill, or no period yet, has no period to save. Later refills of
- * its boost leave it
- * as it is, even if the task gets parameters meanwhile.
+ * boosted. At the first refill of a boost that is not held, hold it. Call
+ * this before the replenishment changes the deadline and the runtime:
+ * dl_hold_refilled_boost() saves them, and places a period of the donor.
+ * Return true if it placed one: the caller must keep that period. It
+ * places none if the donor's parameters were cleared. A task with no
+ * parameters of its own at the first refill, or no period yet, has no
+ * period to save. Later
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
-	if (first && dl_se->dl_runtime && dl_se->deadline &&
-	    !dl_se->dl_boost_held)
-		dl_hold_refilled_boost(dl_se);
+	if (!first || !dl_se->dl_runtime || !dl_se->deadline ||
+	    dl_se->dl_boost_held)
+		return false;
+	return dl_hold_refilled_boost(dl_se);
 }
 
 static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task);
@@ -626,8 +630,9 @@ static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 	return dl_se;
 }
 
-static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
+static inline bool dl_note_donor_refill(struct sched_dl_entity *dl_se)
 {
+	return false;
 }
 
 static inline void dl_request_owner_boost(struct task_struct *p)
@@ -1741,11 +1746,13 @@ static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags);
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
@@ -6101,11 +6108,14 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
 
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
@@ -6115,11 +6125,15 @@ static bool dl_setattr_period(struct sched_dl_entity *dl_se, u64 old_runtime,
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
@@ -6142,6 +6156,14 @@ static void dl_hold_refilled_boost(struct sched_dl_entity *dl_se)
 				 old_runtime, old_deadline, old_period, false, false);
 	else if (!dl_time_before(now, dl_se->own_deadline))
 		dl_se->own_runtime = 0;
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

