Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207372;
	b=0EN8d7OWYIyIIqaaPK6MW+JYivkhwPbxgnFJAtYtyisTOCPTJ4/vrkkGpT04ENozUcFE
	 XJbhwnL8tJgzgiz2RvLAMk0CEnFx3Tfysh4u+6YV93uLVrll+8rwqmsfzppBw71gBXFrA
	 gqFWZYjVItfM5eJXX7HYX7R5K5M+ROOh7yzCm3wUpyFs4+n7/DSwSzKT8cGoyIwQLs+wi
	 cyfbkhi2M3rf3jYqakqqUxg/GCbMdnpVxpFPbf4gZ7i+BxifGeJNiGNNcFcDk2oTcPKGG
	 ZxJnbhbGLdefPz9DVeKQSK4N8LEQlQp2z2eqcrpOsuTHkYDO9JXM4MOiVqdEqQEtNxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207372;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vE+uNjXsB2iA/fb83lE/XKLUhCwUuFaXjUJLCJJWSCI=;
	b=I870YI4skev3rZUC2ihgBUXa1ez8wKW/E6JoVxlgdN5yqRZIW53psRqzqUISztLbXOxD
	 mG1fGGwD9mtaJgH6pvTChDHSirjW2lvCSWEjxh0R/vGeOJH6k3ad/Oak8uHf9VaDLSZ8T
	 ED81hbvWWLccBXmmH/4UWv8sXy55S2DiulJo61YPRdSk8f2AdHkg/TKvTtnYV5vYxqNir
	 Z52iLSxlQDZCLEMn7mDUlSsPQyVH5il3kXu9IWbFXhg8ZaCwrU/jmSt3uopc9pRSB9QcG
	 csgHrdTH2wmx1xKHVZ2GtVL8gnq2IcQNRjMgK4ODr8AHHAQo5xVBGSRTbzHqMsfx6Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=J0Ebh9eN;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E8A60A6F4C;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9E8A60A6F4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=J0Ebh9eN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207360;
	bh=vE+uNjXsB2iA/fb83lE/XKLUhCwUuFaXjUJLCJJWSCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0Ebh9eNqdwgHF3sJSdkQVj4yXGzfbxfno1u1Q16gCnI6Y08MQyRzk8zpJSY4o/wY
	 w/MY4tlTAbdVE55FzRPZ3Hw69XyvyA65MZtZxg8PQjmR7rDp+Er7r3qlR5BnM6LEb0
	 7wPILlp+/BM7rXLblMye6TG1u1EXb7FpDYQ6L9RoG9dwNOkRrPH0KZphCaiUD+Ek4T
	 UESTEXhSuMQPEv1saN3QyAjUaK+W6CiUTKZUQ6JkZBNV9v2Q1xBfldR7hgW3aQcKcR
	 PM5D30EqvkaSmldtwB729MUDNSqbgQx/HHsmhXMiwvPKLXkbBO7PdDjEhem50/9grD
	 0DCMi8+sQiSYg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2S3r6qzV52;
	Fri, 20 Nov 2026 15:42:40 -0500 (EST)
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
Subject: [PATCH v10 37/40] sched/deadline: Keep the start of the period across a change of dl_deadline
Date: Fri, 20 Nov 2026 15:42:14 -0500
Message-Id: <3360961974ba9401f7d6d4d7d5fd513db04c9fc5.1795207233.git.mathieu.desnoyers@efficios.com>
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

dl_next_period() works out the start of the next period of a deadline
entity as deadline - dl_deadline + dl_period.
Commit 5ac69d37784b ("sched/deadline: Make sure the replenishment timer
fires in the next period") added it. The replenishment timer of a task
with a constrained deadline then fires at its next period, not at its
deadline. Commit df8eac8cafce ("sched/deadline: Throttle a constrained
deadline task activated after the deadline") uses it too. It throttles a
constrained task that wakes between its deadline and its next period.

The formula assumes that the deadline was set with the current
dl_deadline. But sched_setattr() can change dl_deadline during a
period, and the deadline stays. The start of the next period then moves
by the old dl_deadline minus the new one:
- A shorter dl_deadline moves it later. A task that wakes after its
  period ended is throttled until that later time. For an implicit task
  made constrained, that is up to dl_period - dl_deadline.
- A longer dl_deadline moves it earlier. A constrained task that wakes
  between its deadline and its real next period is not throttled. It
  gets a new runtime before its next period.

Fix this by recording the start of each period in period_start, where
the deadline is set. dl_next_period() and dl_in_constrained_gap() use
it.

The Sashiko AI review of this series found this. The case
wake_after_deadline_shrunk of deadline_bw_test, added later in this
series, tests the shorter dl_deadline. It fails without this patch.

Fixes: 5ac69d37784b ("sched/deadline: Make sure the replenishment timer fires in the next period")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 include/linux/sched.h   |  1 +
 kernel/sched/deadline.c | 25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 491ddeea7d65..244e57fa8c21 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -661,6 +661,7 @@ struct sched_dl_entity {
 	 */
 	s64				runtime;	/* Remaining runtime for this instance	*/
 	u64				deadline;	/* Absolute deadline for this instance	*/
+	u64				period_start;	/* Absolute start of this instance	*/
 	unsigned int			flags;		/* Specifying the scheduler behaviour	*/
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b9c206a59c16..e9b3d3ec71d7 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -89,7 +89,8 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
  */
 static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
 {
-	dl_se->deadline = rq_clock(rq_of_dl_se(dl_se)) + dl_se->dl_deadline;
+	dl_se->period_start = rq_clock(rq_of_dl_se(dl_se));
+	dl_se->deadline = dl_se->period_start + dl_se->dl_deadline;
 	dl_se->runtime = dl_se->dl_runtime;
 }
 
@@ -103,7 +104,7 @@ static inline bool dl_in_constrained_gap(struct sched_dl_entity *dl_se)
 	u64 now = rq_clock(rq_of_dl_se(dl_se));
 
 	return !dl_is_implicit(dl_se) && dl_time_before(dl_se->deadline, now) &&
-	       dl_time_before(now, dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period);
+	       dl_time_before(now, dl_se->period_start + dl_se->dl_period);
 }
 
 #ifdef CONFIG_RT_MUTEXES
@@ -1260,7 +1261,8 @@ static inline void replenish_dl_new_period(struct sched_dl_entity *dl_se,
 					    struct rq *rq)
 {
 	/* for non-boosted task, pi_of(dl_se) == dl_se */
-	dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+	dl_se->period_start = rq_clock(rq);
+	dl_se->deadline = dl_se->period_start + pi_of(dl_se)->dl_deadline;
 	dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	dl_note_donor_refill(dl_se);
 
@@ -1384,6 +1386,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 		WARN_ON_ONCE(!is_dl_boosted(dl_se));
 		if (!dl_se->dl_deadline) {
 			dl_se->deadline = rq_clock(rq);
+			dl_se->period_start = dl_se->deadline;
 			dl_se->runtime = 0;
 			dl_note_donor_refill(dl_se);
 		}
@@ -1406,7 +1409,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_se->dl_deadline == 0 ||
 	    (dl_se->dl_defer_armed && dl_entity_overflow(dl_se, rq_clock(rq)))) {
-		dl_se->deadline = rq_clock(rq) + deadline;
+		dl_se->period_start = rq_clock(rq);
+		dl_se->deadline = dl_se->period_start + deadline;
 		dl_se->runtime = runtime;
 		dl_note_donor_refill(dl_se);
 	}
@@ -1425,6 +1429,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	while (dl_se->runtime <= 0) {
 		dl_se->deadline += period;
+		dl_se->period_start += period;
 		dl_se->runtime += runtime;
 	}
 
@@ -1658,9 +1663,14 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	}
 }
 
+/*
+ * Return the start of the next period of @dl_se. Do not work it out from
+ * the deadline and dl_deadline: sched_setattr() can change dl_deadline
+ * during the period.
+ */
 static inline u64 dl_next_period(struct sched_dl_entity *dl_se)
 {
-	return dl_se->deadline - dl_se->dl_deadline + dl_se->dl_period;
+	return dl_se->period_start + dl_se->dl_period;
 }
 
 #ifdef CONFIG_RT_MUTEXES
@@ -1728,7 +1738,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se)
 		WARN_ON_ONCE(!dl_se->dl_throttled);
 		act = ns_to_ktime(dl_se->deadline - dl_se->runtime);
 	} else {
-		/* act = deadline - rel-deadline + period */
+		/* act = the start of the next period */
 		act = ns_to_ktime(dl_next_period(dl_se));
 	}
 
@@ -2603,6 +2613,7 @@ int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 perio
 
 	dl_se->runtime = 0;
 	dl_se->deadline = 0;
+	dl_se->period_start = 0;
 
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_density = to_ratio(dl_se->dl_deadline, dl_se->dl_runtime);
@@ -4848,6 +4859,7 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 */
 	if (!p->dl.dl_runtime) {
 		p->dl.deadline = 0;
+		p->dl.period_start = 0;
 		p->dl.runtime = 0;
 	}
 
@@ -5394,6 +5406,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_density		= 0;
 
 	dl_se->deadline			= 0;
+	dl_se->period_start		= 0;
 	dl_se->runtime			= 0;
 
 	dl_se->dl_throttled		= 0;
-- 
2.47.3

