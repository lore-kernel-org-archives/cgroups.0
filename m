Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855973;
	b=3U66vuUpW9YL4eyAJhLJQ/DlYlQ/w+Hb9yt0V5jMqFjssbJKzNHVdlMn3TEtBUHAZQPB
	 DZIYtzNnaTpDoTgYe3la+YYqsPsVZ/3UBvojdfMfAE0rvcy7GhgNChG4Nrf5e5HSjw2EI
	 nsiuIlGPRO2ZLPp0XEJgD0O6tt2OQUf+98u7epbRvwDWcRFF360nBVTht0RZjX5hsxVuA
	 W/QwYkeWT2TpbccOenIx9BFA19pRtL4OrPZsKNfNFoqitKoR/Mp55QvkpAm33AuToiBCG
	 O4u3B3TKPIMOXmcqJVGEhebJTJWVbZ0XeK+YzwED4e3ZSwFVoer7ov1CnNhwIV3YkFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855973;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uPvzHKbCYsmnpAcj4LIasyOK0nOREWo/Tw63aL3+pxk=;
	b=iSDBwg9WX/EtztIRkIy3PpHUWmGY9xUzdJXC+8d8QAqtOoRjpnnx+HwfpobY4oxgI40P
	 LgrndR07wALorm+p8lmfVR1cu6Nc0rMO24jJthF/qptKeIFiYOKLMyZcYucRgcN1cljaw
	 Q1gNSuxLPDyhkb/J5YrqZgMuPtEW31RU6t2HQM92MyaWndOEc9OeXGj6QiOh8yO2Tr8lA
	 ZtHEhZrfKOtQmeFTsu8spO5/2Ta8jqf+voZgztYyus6XEmDmdSO5KE4j6zb7wmM6bfbq2
	 UdLAOoOuyW/Cg+mvb/TanEJWmYNmvzsP754h/MBKSOB2IWfwiV4y/OgWkUJal7HxPhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JVnypFgx;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4C60A5BDC;
	Mon, 16 Nov 2026 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EA4C60A5BDC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JVnypFgx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855959;
	bh=uPvzHKbCYsmnpAcj4LIasyOK0nOREWo/Tw63aL3+pxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVnypFgxOGT+/IkdnLSZxlF6xglO0ZAoA/Is2YGQ/5JFABauHDh9iI5Ud2wbwdde5
	 e9rasNTg785MtDzgezPLIShZ990vNgUdHy6ODePNEOtN+UOB6n4/fk1V8wSVL1/3yy
	 alxZwJC0lThXaR+us2VCvPNvAzmCkhZttYJ9FF01ZYvgDHUq3Yum9hqsIrYmA/WiZe
	 LzcdDglU7XfDqNHFP70DLCWO7em7vlU5dqPVLNsHW/TpgcvYN1KbEwj3oXmOKSd3uf
	 u3oyPQsx08TqVQjzV69sX5cvM/9aaystP2RpXjZ+RIEJqOYoBScRBcmLM+z9+qVJ5e
	 VVPV6YHNm4R2w==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4l3HZrzQtk;
	Mon, 16 Nov 2026 14:05:59 -0500 (EST)
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
Subject: [PATCH v6 31/37] sched/deadline: Start a period for a task that enters the class blocked
Date: Mon, 16 Nov 2026 14:05:43 -0500
Message-Id: <20261116190549.230119-32-mathieu.desnoyers@efficios.com>
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

Commit fb00aca47440 ("rtmutex: Turn the plist into an rb-tree") sorts
the waiters of an rt_mutex by priority. For deadline tasks, "the one
with the earliest deadline wins". A waiter takes the deadline of its
task.

A task can enter the class while it waits on an rt_mutex.
sched_setattr() can make it SCHED_DEADLINE. A priority inheritance
boost can also put it in the class, if it owns another rt_mutex.
switched_to_dl() leaves a task that is not queued to its wakeup. But
the chain walk reads the deadline first, and copies it into the waiter.
A task new to the class has a deadline of 0.

So the waiter goes before every other deadline waiter. It takes the
rt_mutex first, whatever their deadlines. Those waiters can then miss
their deadlines. It also boosts a deadline owner whose own deadline is
earlier.

Fix this by starting a new period in switched_to_dl() for a task that
waits on an rt_mutex, if its deadline has passed. The period uses the
reservation the task runs on: its own, or the copy a boost made. This
is what setup_new_dl_entity() does at an enqueue. At the wakeup,
update_dl_entity() then checks that period as for any wakeup.

The setattr_blocked_keeps_order and boost_blocked_keeps_order cases of
deadline_bw_test, added later in this series, test this. Both fail on
v7.4-rc1 and on the series without this patch. The triage of the Sashiko
AI review of the fifth posting found the bug.

Fixes: fb00aca47440 ("rtmutex: Turn the plist into an rb-tree")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 69a338c1526d..ffa8b946e804 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -125,6 +125,12 @@ void dl_deboost(struct sched_dl_entity *dl_se)
 	}
 	dl_drop_boost(dl_se);
 }
+
+/* Return true if @p waits on an rt_mutex. The caller holds its pi_lock. */
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return p->pi_blocked_on;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
 {
@@ -135,6 +141,11 @@ static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
 	return false;
 }
+
+static inline bool dl_task_pi_blocked(struct task_struct *p)
+{
+	return false;
+}
 #endif /* !CONFIG_RT_MUTEXES */
 
 static inline u8 dl_get_type(struct sched_dl_entity *dl_se, struct rq *rq)
@@ -4352,6 +4363,17 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 	if (!task_on_rq_queued(p)) {
 		add_rq_bw(&p->dl, &rq->dl);
 
+		/*
+		 * A task that waits on an rt_mutex cannot wait for its wakeup.
+		 * The chain walk sorts its waiter by its deadline first. A task
+		 * new to the class has a deadline of 0, which goes before every
+		 * real one. Start a new period now, as setup_new_dl_entity()
+		 * does at an enqueue.
+		 */
+		if (dl_task_pi_blocked(p) && !p->dl.dl_throttled &&
+		    dl_time_before(p->dl.deadline, rq_clock(rq)))
+			replenish_dl_new_period(&p->dl, rq);
+
 		return;
 	}
 
-- 
2.47.3

