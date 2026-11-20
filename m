Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207368;
	b=YTNY8ZSU+keEM2f08pjYM0kYkrEiTLlCXldRUJoRVkgou/ClGF13D1fVJ1rNG/KejOyH
	 FLPLB6xYncpJFgURHJoENTotHTe0cIKDcIKCDDqs6jf1F8ZGe9mgr2j8pyDrwP/2/TeIN
	 nKvt4mH6peDtn/Me3r3YtSIeQ/nosbvhKmfB28kHPJ6NJUQImDtcMqZspjV0KZLC86ogW
	 PmiXfp3jqpENfBQcwM2evhQ1K0SrlNzjvI8eCzCIvW3iR8TOqpQsxPnir6EnVtEH6x82o
	 6Wuem4oe0woiHteIjqAh3PUajl+oImcS63EUSBRmXSukBaMWbh4fQOH53N0w1SUnNyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207368;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TxvxQMkXa7o3fwojYn6lBFWEhgxcusn/QjTf5hpFuLg=;
	b=jiHmdpwq6vrVuzFzA6/0qgpvDzf9+1oFDJHA6r2Oc4XzW1OwH/pp3Pa9ASDdpW+AOf+j
	 xUwapCgmASMGsUVoZkza0hib/SOZJO0kzkTkKCbnr4D/+TzFPXaxcAdJZgs/NYLRMUSra
	 MyB4tierFDezyqK9PMWB/76tTYHuOvXVyTuxbmyf6OiZvithyGz2w+5ki/XGja0T08loO
	 IakOPrWqfWyMQipUiyD3XW7LWJXBaMIQX+52CE9tQWIF8e/AwSCd3Zvjvj61bNOsW+n3L
	 8I6o6Ua0CPMXoY23N94hbDlCeYjDD77hMnmRKZDHWDUyREeeU/TetUAMRLX793S2IDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sdHkuGZW;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC44060A5BFE;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC44060A5BFE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sdHkuGZW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207359;
	bh=TxvxQMkXa7o3fwojYn6lBFWEhgxcusn/QjTf5hpFuLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdHkuGZWQQxvwgywuNaGujyJ/cEI0Q/okajCXgYLD0ZXd/YXDOPSYz9LXs2PpobrF
	 BDgaO7dgYMq/AfoFTAQKV6wvFGSS8QTx7ehFgMeiePHr0knZv+w9UTmzTf67hQLIGY
	 bEYfv1g5T5PnjhXteDdX7en2KhtV6eesCyEV3qeK56XSqhfiopwZxmwHWKBcZr+DHW
	 GeeGbGcknh2bJ8T0Apvxlg/kKk+nzF4HWbAhIQ/OWFV3OdLU3QbJd4da8w5RZfOwro
	 Q+4XWjHM9BncLksTKJXXuSZDfPQESGrsvfqm2mObccBwicxj0Yy63cNGF2Nwom0SDC
	 VyOTQjobcBjiA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2Q5QzzzTql;
	Fri, 20 Nov 2026 15:42:38 -0500 (EST)
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
Subject: [PATCH v10 33/40] sched/deadline: Cap the runtime left of a constrained task at dl_runtime
Date: Fri, 20 Nov 2026 15:42:10 -0500
Message-Id: <c755a9fbae63650dffdebfc715d8be46ab605b29.1795207233.git.mathieu.desnoyers@efficios.com>
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

sched_setattr() can change the parameters of a SCHED_DEADLINE task. The
task keeps its runtime and its absolute deadline: the new parameters
take effect at the next period. At the next wakeup, update_dl_entity()
checks the runtime left against the new parameters.

For a constrained task, that check uses the density, dl_runtime /
dl_deadline. Commit 2317d5f1c349 ("sched/deadline: Use deadline instead
of period when calculating overflow") made dl_entity_overflow() compare
with it: "We care about if the runtime can make its deadline, not its
period." Commit 3effcb4247e7 ("sched/deadline: Use the revised wakeup
rule for suspending constrained dl tasks") then cut the runtime of a
constrained task that overflows to density * laxity. Both bound the
runtime by dl_runtime only while the deadline is at most dl_deadline
ahead.

A change to a shorter dl_deadline breaks that. The old deadline can be
farther ahead. The check then keeps more runtime than the new
dl_runtime, or computes more. For example, take a task of 50ms every
100ms with 49ms left. Changed to 8ms in 20ms every 100ms, it would wake
with 39.6ms. It would then run far more than its new runtime in this
period. Admission control already counts the new, smaller bandwidth. So
other deadline tasks could miss their deadlines.

An implicit task is not affected. Its check compares with its
bandwidth, which bounds the runtime for any deadline.

Fix this by keeping no more than dl_runtime before the check, for a
constrained task. A boosted task runs on the parameters of its donor,
and is left alone. The runtime is signed and can be negative there, so
compare it as signed.

The cases change_constrained_new_params and wake_constrained_new_params,
added to deadline_bw_test later in this series, test this. The first
changes a running task, the second a sleeping one. Both fail without
this patch.

The Sashiko AI review of this series found this.

Fixes: 2317d5f1c349 ("sched/deadline: Use deadline instead of period when calculating overflow")
Fixes: 3effcb4247e7 ("sched/deadline: Use the revised wakeup rule for suspending constrained dl tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9f87315d3d6e..b6fecf4c0324 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1539,6 +1539,25 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = rq_of_dl_se(dl_se);
 
+	/*
+	 * The checks below compare the runtime left with the density,
+	 * dl_runtime / dl_deadline. That bounds the runtime by dl_runtime
+	 * only while the deadline is at most dl_deadline ahead. After a
+	 * change to a shorter dl_deadline, the deadline can be farther
+	 * ahead, and the runtime left larger than dl_runtime. A constrained
+	 * task would then run more than dl_runtime in a period. Keep no
+	 * more than dl_runtime.
+	 *
+	 * An implicit task is checked against its bandwidth, which holds
+	 * for any deadline. A boosted task runs on the parameters of its
+	 * donor. Leave both alone.
+	 *
+	 * The runtime is signed, and can be negative here.
+	 */
+	if (!dl_is_implicit(dl_se) && !is_dl_boosted(dl_se) &&
+	    dl_se->runtime > (s64)dl_se->dl_runtime)
+		dl_se->runtime = dl_se->dl_runtime;
+
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
 	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
-- 
2.47.3

