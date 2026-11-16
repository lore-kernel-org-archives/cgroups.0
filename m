Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855969;
	b=3hi6r/QxgNAmjz9YFZLQ9KKGMvDMtoU6tMKO63twFQuO08p+t2d1BGxD2AEo3yj1nMwd
	 dH4mSgtiW7/kWPn7R8yLXv0CrMBcagsul3ocgX73gxy+TjhlllBW5GUHEugP0zNhie9Ed
	 k9/Lpn4MlBtVErxUpY8el5vwEV2Bj+WuTgu9z5arRnAf8rCqZpQcEJOQG44y8u3lbU3s8
	 AyIPSkUuyO5h2jFDl7fV8ZY1z80+fKPo4pxTP2bj860/5A0Re70kiA8jmhIE1NPCwrnUz
	 +fN7sA4gY15kpdE7dirXtdWGup+pXvvpWh4uo4fpqybEe9z5zRHh52qyWXJWVoKDP8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855969;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/4s5+Wpp7dPtti3e4zmIEFc5GLasXKlC0PZTo3zhDUg=;
	b=oKvlnOnv4e8DfUzm+sf56sG0DOMmQRKMFPYIuTfK0xIH+D+VWOtjbuAkkfVvt/gnCv9m
	 HqEeZOEy39hs9A+gagtrFMYxH+S9QekkoyI9ZBoehTsIq4XTlA9LAaduiQXZXqYI9JDbm
	 jmKhnbIW0REqtXXNyGbEZijqV9kMOFp8VNHDMShDyUFRWGJTx1xPzUN5lro+rtCbJhdvD
	 YdWV0mvmmcmxnc4/R9yP9dtPhYIPBE3gtA37ns4ygFJP71ZsJrtEtm1pG3LPcsXVzTqle
	 8ls3d6D1gW3ZGca9Fn2/pESLZmTG2HH5iLpqF5sNzRzHYrUMcHlqI8jymScYESO8fQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZyvOht6X;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32C4606A881;
	Mon, 16 Nov 2026 19:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F32C4606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZyvOht6X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855954;
	bh=/4s5+Wpp7dPtti3e4zmIEFc5GLasXKlC0PZTo3zhDUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyvOht6XWXm3ZFqejYtg9hhFGjDVoPCaw3KmyIb2T6Qd/h7pfoYaMJIAQWpygPwQ8
	 QF5YKt5kOEh0GlcTqRGRLIYItSinuDUXEp7nNcnqaUyje2kCvaU4cCA3ll9aJ/+bfP
	 x4yZX6gjLAkTlvhUFru/awx0b7M6oymjnwN3+Yy0LgaDOp1WhHqMzPx0PHm+lYuh9R
	 cnY7c//9mj9yWl4T0t980BRZzWoQ6Lt/OH1bdgG97rK/WdQcF8lBZZGn6npZ2t7Ggd
	 0KJQtpK5IDQ8B15Veoq7gdJiWOu5mKzxTuZ8zy7F8vC4Y1ShtOkak+63h/15+1llPD
	 LobnhbLxIByBw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4f0rhFzRGZ;
	Mon, 16 Nov 2026 14:05:54 -0500 (EST)
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
Subject: [PATCH v6 03/37] sched: Let a task boosted by a deadline waiter change its policy
Date: Mon, 16 Nov 2026 14:05:15 -0500
Message-Id: <20261116190549.230119-4-mathieu.desnoyers@efficios.com>
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

A SCHED_OTHER or SCHED_FIFO task that holds an rt_mutex can be boosted
into the deadline class by a deadline waiter. Then a sched_setattr() or
sched_setscheduler() call on it fails with EBUSY, unless it asks for
SCHED_DEADLINE. sysrq-n would not reset it either.

The admission test runs "if setscheduling to SCHED_DEADLINE (or
changing the parameters of a SCHED_DEADLINE task)", as its comment
says. sched_dl_overflow() then handles three cases, by the task's
policy: the task enters, leaves or stays in SCHED_DEADLINE. But the
call site tests dl_task(p). That tests the priority, so a boosted task
passes it. For such a task and another policy, sched_dl_overflow()
matches no case and returns -1.

Fix this by testing the policy, with task_has_dl_policy(). A boosted
task has no bandwidth of its own to admit or release.

Now sysrq-n can take a boosted task out of the class.
normalize_rt_tasks() calls __sched_setscheduler() without pi, so the
task gets its normal priority. Nothing then drops the boost. At the
unlock, rt_mutex_setprio() sees no change of priority. The pi_se of the
task would keep pointing to the waiter, which can exit. So also drop the
boost in __setscheduler_dl_pi() when the task leaves the class, as
rt_mutex_setprio() does.

The boosted_owner_policy case of deadline_bw_test, added later in this
series, fails with EBUSY on v7.4-rc1. It passes with this series. The
sysrq_boosted_owner case of deadline_switch_test tests the sysrq-n path.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/syscalls.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 6f8ce5fd94a1..cb115aa9b0b3 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -304,6 +304,13 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 			scope->flags |= ENQUEUE_REPLENISH;
 		}
 	}
+
+	/*
+	 * Without pi, as from normalize_rt_tasks(), a boosted task can leave
+	 * the class. Drop its boost then, as rt_mutex_setprio() does.
+	 */
+	if (!dl_prio(newprio))
+		p->dl.pi_se = &p->dl;
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
@@ -691,6 +698,10 @@ int __sched_setscheduler(struct task_struct *p,
 	 * is available. Keep this check last. If a later check failed,
 	 * nothing would give back the bandwidth it reserves.
 	 *
+	 * Test the policy, not the priority. A task boosted into the class
+	 * by priority inheritance has no bandwidth of its own to admit or
+	 * release.
+	 *
 	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
 	 * there is nothing to admit. Such a call changes other attributes,
 	 * such as the utilization clamps. A deadline task does not use its
@@ -699,7 +710,8 @@ int __sched_setscheduler(struct task_struct *p,
 	 * them from the task without a lock.
 	 */
 	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
-	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	    (dl_policy(policy) || task_has_dl_policy(p)) &&
+	    sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

