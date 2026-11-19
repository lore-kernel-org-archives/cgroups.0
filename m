Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=SL7CWLmtqPmNyujAUqznkDdsQtJbE92C2KPziM6NMWExZlBFRfq+FjccbOsDTZsKumt0
	 rkgK+d3DIzmh6hs/hQz0mpQj6MKIMPnzrc3ZD3SDwACC4iSC/clBTyCNV+gAKOP3QbKmF
	 d6DEQ2f5b32DXg46L/PSWL/xihhwgfIsIyqLLRT1ByoZbD3BKHJnJB7j9sSUko8NIMgZj
	 kutctBNDfsIn0ksNNopMGsltL/FffCO/gks7u32z4P5S+hU2qv9Hg3prmKZA/ZO3HxWK4
	 xGxdRNhR72Q35lmuYqPcCF6AN7zc2/LnQF480zBO9E2NtGcCLSvq5CcNJ4DF9/Q+W2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SemKFv7v8Y7xI9oXjPWF2JxMyCsFOSCzfVeU/neTudo=;
	b=sS5vmDbBPmqhS+e+mv2hajIkCBEsQWGzgAQ5ujFD4ytn6v/P1CVQNnq9Smmat2XxFnKh
	 I5wzYJLRVi4jejh4KwCA9oH3mz/IYNHv0MFTlV/3cB66uaxnr76H5cm0IRx1r5U0TWspj
	 Cb/Rp9xeKYFYeUNAGr4iJPEufngO1s8S0zqhEkKPZxaCiaVuNRMN7Sk5f7Bnk0hVD1j53
	 WLeo9M89gkzed5fBXrZBxjxr9VUOY4BhAR4G1jkG5KpsBLatzqQME8536vB+E6Ydp1G2x
	 37gAsZr/kJu9Psd/iuTM9eQbnZ+E325iXODUfxelmPpqwO09u4DmZzQlY2uCBL5Zaow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=DMC1jiZ0;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195960A6F4C;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C195960A6F4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=DMC1jiZ0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119382;
	bh=SemKFv7v8Y7xI9oXjPWF2JxMyCsFOSCzfVeU/neTudo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMC1jiZ0NfUC7nJUDUsA/Uk+opuhR3xbxfQ09nCr5OzCp5mEwCs76QE7huKwFORJD
	 oLBgOBZ0oRAnftCuaH++G3LM4EMcqeXWPtSh/CzNSE44X4Gs8LWbJSVdMNym5yCBmB
	 xKURXDYOvnE929G9r6rlBZVXTgdPrtW4bXum7XRaCV5OvDv4n9Zq75PtgMp0VsP36k
	 Vg0BucjaflNVquSOrfoULQeqWbO+JN7mNF98TRvzeUohLLxMTXl9LiymgqDlcLhpMO
	 QFa4grbN0rB7EfbmOuRNWWlbfS0Sq7TXBh9EEYecfz3nmASIYTeQqgee3SZQwact92
	 hUmJC7sY150GQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVZ2zndzRqh;
	Thu, 19 Nov 2026 15:16:22 -0500 (EST)
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
Subject: [PATCH v8 27/33] sched/deadline: Start a period at a deboost out of the class
Date: Thu, 19 Nov 2026 15:16:06 -0500
Message-Id: <9663a1e69055f16fb3e828fb0b47cb79dd020439.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its parameters, runtime and
deadline until its 0-lag time. Commit a649f237db18 ("sched,dl: Fix sched
class hopping CBS hole") keeps them. So leaving and coming back gains
nothing. A priority inheritance boost before then keeps them too.
replenish_dl_entity() takes the donor's runtime and deadline only for a
task with no parameters of its own.

A boosted task is not throttled. When it runs out of runtime, it is
refilled from the donor's parameters. If the task stays in the class at
its deboost, "sched/deadline: Reset the donor's runtime at a deboost in
the class" starts a new period.

A task that leaves the class at its deboost is missed. switched_from_dl()
calls task_non_contending(), which computes the 0-lag time from the
runtime and deadline of the donor's refills, with the task's own
dl_runtime and dl_period. The root domain then keeps the task's
bandwidth in total_bw for too long, or releases it too early. Until it
is released, deadline tasks that would fit are refused.

Fix this by starting a period of its own in switched_from_dl(), as
dl_deboost() does. Share that code in dl_start_own_period(). The 0-lag
time of the new period is now, or has passed, so the bandwidth is
released at once.

The Sashiko AI review found this, on "sched/deadline: Reset the
deadline and the runtime with the parameters" of the first series. The
deboost_out_after_donor_refill case, added to deadline_bw_test later in
this series, tests it. An owner of 5ms every 100ms leaves the class
while it holds the lock, and is refilled by a donor of 2ms every 10ms.
Without this patch, its bandwidth was still in total_bw right after the
unlock, in 40 runs of 40. With it, the bandwidth was gone in 60 runs of
60.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 77a1d1f463f6..d284036ecb8a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -83,6 +83,16 @@ static inline int on_dl_rq(struct sched_dl_entity *dl_se)
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
 
+/*
+ * Start a period of the reservation of @dl_se now. The caller holds the rq
+ * lock and has updated the rq clock.
+ */
+static inline void dl_start_own_period(struct sched_dl_entity *dl_se)
+{
+	dl_se->deadline = rq_clock(rq_of_dl_se(dl_se)) + dl_se->dl_deadline;
+	dl_se->runtime = dl_se->dl_runtime;
+}
+
 #ifdef CONFIG_RT_MUTEXES
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -117,12 +127,8 @@ static inline void dl_note_donor_refill(struct sched_dl_entity *dl_se)
  */
 void dl_deboost(struct sched_dl_entity *dl_se)
 {
-	struct rq *rq = rq_of_dl_se(dl_se);
-
-	if (dl_se->dl_donor_refill) {
-		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
-	}
+	if (dl_se->dl_donor_refill)
+		dl_start_own_period(dl_se);
 	dl_drop_boost(dl_se);
 }
 
@@ -4504,6 +4510,17 @@ void dl_clear_root_domains(void)
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
+	/*
+	 * The boost of a task with parameters of its own ends, and the task
+	 * leaves the class. If the boost refilled its runtime from the
+	 * donor's parameters, its runtime and deadline are not those of its
+	 * reservation. task_non_contending() would mix them with its own
+	 * dl_runtime and dl_period. Start a period of its own instead, as
+	 * dl_deboost() does. Its 0-lag time is then now, or has passed.
+	 */
+	if (p->dl.dl_runtime && p->dl.dl_donor_refill)
+		dl_start_own_period(&p->dl);
+
 	/*
 	 * task_non_contending() can start the "inactive timer" (if the 0-lag
 	 * time is in the future). If the task switches back to dl before
-- 
2.47.3

