Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805149;
	b=0+M10CPfc32CXBrF9HwbLsCJYlwCipMxxy+fDIqWDULLtxysUQ2+wW+Xa99DXiF6EYrg
	 7LXtd7mA6SXv68ULW8d9H71Zcn4gouLdROk6A8XVyZA7Qa9QF9z3kOffH1W/9rH6TZQYy
	 7/zAVRxp7hL17oWfYCj8EABzXsBS0W7MJRawXq5dP/qpoXZ//8JIbcPlCGY6JKj+vpOHF
	 B+5i8wr6JJ0ZUXypiR3ucIikVSLw0eyR0wJl4wuzVhWPE4rHMcNPzH/i08MZjTyBlhcS8
	 qTwHOvD95jclHNjeaE4ddLu8z7SAFGOG8S0kFmhCuFSYIKocNM9Me7ZUxZg7QS+C2rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805149;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aVWrFhpEnfMXGEZkvUTJyLjJszY90Acq8hqoYwyKwQk=;
	b=BN4vLnARoIb++fJgUj7VHyLyxwt/35t0oexwEM7HILE93bC1eBfKIcaUKxAYh0KeEUnf
	 dDBpHEplRw7CkiDz+vHhOBqlzOuf+bG1LnhBxMCDICF+9TdXIDMGK0QfkoARmnPmqd0Lr
	 D1cGFojWmR+zFNCamej6KhKD7QGv7jKa/2aSrSPqEXykpC+IRK0wlSUzChxTuHVuLV25f
	 qGqKjtUOTo28MZuTl6+/Pu3AXHpi74WMKQDlg9KeS0+EPJr1/FXAxDWlKm4sxjPiHM/Wq
	 jd22z5WpxmO5nMbeazKAsqsgrPVSwmgHtQlmkWcMD2vHsmgmujVss05lAIxXYZnfzqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PydbVvGw;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22773606D827;
	Wed,  4 Nov 2026 15:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22773606D827
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PydbVvGw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805141;
	bh=aVWrFhpEnfMXGEZkvUTJyLjJszY90Acq8hqoYwyKwQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PydbVvGw+oti6Gjb6wiHbcCBrqpJDF6KCxq/kW9aH1+IU2itEbrc/6vmZBNX91F2d
	 /KjeOo4WsgywmJFqj7eBbAoqwc6i7UtZ1OBvLloVUShb/ut7Vu838iQJocqiwxTa3b
	 mmxG7rIl12pVhQFLSC+TpvBM4FgydxNeAlz5dBdd+IKgcvCnQ+EQyb4cpQhTMFPfKR
	 pkxXKpRWU11z4LMSgaq8Fb/zT2v89d943SLauOAGyL+E3XWPUmxbSGw4ai/e8B21qa
	 1UIh1ZaFzy22548xrjuVqW+gC4OGO3lZQajVhpLCc1R5tNFZaRJSRWMAE8ork06WM+
	 Zk3JqHitck9wg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSj1mKFzL1Q;
	Wed, 04 Nov 2026 10:12:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Claudio Scordino <claudio@evidence.eu.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 09/12] sched/deadline: Do not take a waking task's bandwidth off a runqueue it left
Date: Wed,  4 Nov 2026 10:10:30 -0500
Message-Id: <828cd80ec6e4764f04f8667fc98d7aa22d2bf076.1793804635.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
References: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
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

A deadline task that wakes on another CPU has its bandwidth taken off
the runqueue it slept on by migrate_task_rq_dl(), from set_task_cpu(),
and charged to the one it wakes on by the enqueue that follows. That
enqueue can be left to the target CPU through the wake list, and
try_to_wake_up() returns before it runs: the task's task_cpu() is then
the CPU it wakes on while its bandwidth is on no runqueue at all.

sched_setattr() of that task meanwhile finds it off the runqueues, and
dl_change_utilization() takes its old bandwidth off the runqueue of
task_cpu(), which never held it. this_bw of that CPU underflows, which
costs every other task and the fair server there their own, for good.
switched_from_dl() leaves the class through the same hole.

Reaching it needs a deadline task whose wakeup migrates, which asks for
more than one CPU in its root domain and for them to be taken. It is
easier to reach with CONFIG_SCHED_PROXY_EXEC=y, where a task blocked on
a mutex is migrated to the CPU of its owner and wakes back on its own.

In 8 VMs of 8 vCPUs, a task of 10ms every 100ms that sleeps and wakes in
a partition root of two CPUs, both taken by deadline tasks of an earlier
deadline, its runtime changed between 10ms and 20ms from a CPU outside,
warns in all 8 within a second, and the warnings spread to the idle
task's accounting of both CPUs:

  WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
   __sub_rq_bw(): this_bw underflow
  WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
   __add_running_bw(): running_bw overflow

Record that window in the entity, as dl_bw_offrq, and leave the
runqueue alone while it is set: the enqueue to come charges the CPU the
task wakes on, with the new bandwidth, which __setparam_dl() sets right
after sched_dl_overflow(). add_rq_bw() clears it, so every path that
charges a runqueue does. The 8 VMs above warn no more. deadline_bw_test,
added later in this series, has params_waking for this: without this
change it fails on every one of those VMs, and random_mix on one of
three.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  1 +
 kernel/sched/deadline.c | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0633a73579db..8ffc076a485f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -718,6 +718,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_bw_offrq       : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8ead9b050dfc..a8906cf96640 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -358,6 +358,7 @@ void __sub_rq_bw(u64 dl_bw, struct dl_rq *dl_rq)
 static inline
 void add_rq_bw(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
+	dl_se->dl_bw_offrq = 0;
 	if (!dl_entity_is_special(dl_se))
 		__add_rq_bw(dl_se->dl_bw, dl_rq);
 }
@@ -435,6 +436,14 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	if (task_on_rq_queued(p))
 		return;
 
+	/*
+	 * Waking up on another CPU, the task has its bandwidth on no
+	 * runqueue: the enqueue to come charges the new one, with the new
+	 * parameters, which __setparam_dl() sets right after this.
+	 */
+	if (p->dl.dl_bw_offrq)
+		return;
+
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
@@ -2785,6 +2794,12 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 		cancel_inactive_timer(&p->dl);
 	}
 	sub_rq_bw(&p->dl, &rq->dl);
+	/*
+	 * Until the enqueue on the CPU it wakes on charges it there, which
+	 * add_rq_bw() tells of, this bandwidth is on no runqueue: the rq of
+	 * task_cpu() is not the one it was taken from.
+	 */
+	p->dl.dl_bw_offrq = 1;
 	rq_unlock(rq, &rf);
 }
 
@@ -3736,7 +3751,9 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 			dl_task_release_bw(p, dl_task_root_domain_cpu(p));
 			released = true;
 		}
-		sub_rq_bw(&p->dl, &rq->dl);
+		if (!p->dl.dl_bw_offrq)
+			sub_rq_bw(&p->dl, &rq->dl);
+		p->dl.dl_bw_offrq = 0;
 		/*
 		 * Released: reset the parameters, as inactive_task_timer()
 		 * does. Kept, they would make the task one with bandwidth to
@@ -4191,6 +4208,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_bw_offrq		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

