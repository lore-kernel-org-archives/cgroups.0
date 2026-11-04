Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826739;
	b=wmbtpKtvG8UXDvQloVkZyudszuWAqCGOS2OYRI3ehzOVNx7zko8hnBtl1wJZpQcnQOsw
	 osEtG5UJnXYAiww64eF9wSrrgaYbKkctW/t/LDm0QzOhysJkxcd8+n1/6apO8cjVjRKgy
	 8x3agtzU/9v/qK1hDSB/MAPnGQMeVn3xUyLdxh7hs1n0FnMKoINlY2KERPF4H68hSZ1Oy
	 lqLaxtthPPm0on+5t+OmHCSTXr2qqDNeCuamyvgo56DHHYRW+Q9PwlgaLm2TJUNX93/n+
	 vc2nt1tXYHmZh4C1Ia3dLUesUiLpznoGkglEFLnb0HSyGQFqm+2dQv/kPkyhiXLwvyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826739;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MgMd+AzH060sFNwkbW6vrD33eL2BOvQkwE24zG+WN90=;
	b=nJvKNdnkWyOaHv57IlrQE8FZNtU7J/gGT0El9gsGy0hLKBDE3ZSyw+7zTvQArDIgnn3O
	 mc73MdZtN5DuEgL7sMhjP5TQWW5MUeUvTSAPXzQ5sVOT9a43aUNtOzwAZqASpAiGVPAWf
	 +Qv+4sdLJAw1wSQAVcVRTd0GC4vxNl28PuS7rVdQE0P2TkiPXwWmq3wFIDwgYHl5AExUp
	 7B5kzA8KfSuzEdsrrO3+Fd3/hCVMSAEPeW0nJ1F2LPUca61HKXkediyIbLusCul+MLPyN
	 pE7LX8bIIDUvLw4+9JyrE5uGhYU61oD61eAEFIhJS65D1b505QaIoQr1t4NROjKUdYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GPOtd51k;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4B60A260B;
	Wed,  4 Nov 2026 21:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFF4B60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GPOtd51k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826736;
	bh=MgMd+AzH060sFNwkbW6vrD33eL2BOvQkwE24zG+WN90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPOtd51kXCDq7fJWdfxHJIlXdnPuD7yFFg0CX6wYz/hC7123ybipLkqiUEUf20scm
	 IYPsDbvgoHnV98auqaMX+9OxDZ8BWVtTD0MnVmtWkrIo7joa26iOsZdOH0gMCZVfJP
	 69+r6yqrvQPrCfTSESUcnW5lzS3fuaKXwqis0StrTZhCLtCkt0jy4mz3WcdeGLZArv
	 7CsUIKQjmS2Pkoy3pCv+JSOxPRDuCqVeGX/zmgoLK9K8i6DvRDLc9PGy1WaFFVybyo
	 XkgA5mSwoyEHriGJukzbKel8f1NglNCsCtZF2s6OYmDALbIO/8YFhg5jNblIfLgxvL
	 0Sqizz+W9BhfA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRz75NjzLXk;
	Wed, 04 Nov 2026 16:12:15 -0500 (EST)
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
Subject: [PATCH v2 21/21] sched/deadline: Count the bandwidth a boosted task is given
Date: Wed,  4 Nov 2026 16:12:07 -0500
Message-Id: <20261104211207.1392343-22-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

The runqueue a sleeping deadline task is on counts the bandwidth of
that task in this_bw, which switched_to_dl() hands it as the task
enters the class. A task that priority inheritance boosted into the
class is in it already: __sched_setscheduler() neither dequeues it nor
enqueues it back, so switched_to_dl() does not run, and sched_setattr()
of SCHED_DEADLINE on such a task leaves this_bw without the bandwidth
the task now has. Its wake-up gives that bandwidth to running_bw alone:

	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);

and the two sums GRUB reclaims from disagree by the bandwidth of the
task until it migrates, where the enqueue adds it (add_rq_bw()).

Change the bandwidth the runqueue counts where the parameters change,
in __setparam_dl(), which every task that gains deadline parameters
goes through, rather than in sched_dl_overflow(), which only a task of
the class reaches that way. A runqueue that counts nothing of the task
takes the new bandwidth, where the previous patch left it to the
enqueue to come: that enqueue finds the bandwidth there and leaves it
(add_rq_bw() of a task a runqueue counts), and a task waking up has
task_cpu() pointing at the runqueue it wakes on. The bandwidth of a
special entity stays counted nowhere.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 15d224846eba..a3b45bb4f35e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -442,22 +442,32 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+/*
+ * The runqueue a sleeping task is on counts the bandwidth the task has:
+ * give it @new_bw in place of what it counts of the task's.
+ */
 static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
-	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq *rq = task_rq(p);
 
-	if (task_on_rq_queued(p))
+	if (task_on_rq_queued(p) || dl_entity_is_special(dl_se))
 		return;
 
 	/*
-	 * Waking up on another CPU, the task has its bandwidth on no
-	 * runqueue: the enqueue to come charges the new one, with the new
-	 * parameters, which __setparam_dl() sets right after this.
+	 * No runqueue counts bandwidth of the task's: this one takes the
+	 * new one, and the enqueue to come leaves it there (add_rq_bw() of
+	 * a task a runqueue counts). A task waking up on another CPU has
+	 * none of its bandwidth on a runqueue, and task_cpu() points at the
+	 * one it wakes on.
 	 */
-	if (!p->dl.dl_bw_oncpu)
+	if (!dl_se->dl_bw_oncpu) {
+		__add_rq_bw(new_bw, &rq->dl);
+		dl_se->dl_bw_oncpu = 1;
 		return;
+	}
 
-	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
@@ -4217,7 +4227,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		if (counted)
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
-		dl_change_utilization(p, new_bw);
 		err = 0;
 	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
 		/*
@@ -4266,6 +4275,18 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
+
+	/*
+	 * The bandwidth of a special entity is counted on no runqueue.
+	 * The rest have theirs changed here, where their parameters are:
+	 * switched_to_dl() hands it to the runqueue of a task that enters
+	 * the class, and a task that priority inheritance boosted into the
+	 * class is in it already, so nothing dequeues it and enqueues it
+	 * back for that.
+	 */
+	if (!(attr->sched_flags & SCHED_FLAG_SUGOV))
+		dl_change_utilization(p, to_ratio(period, attr->sched_runtime));
 
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
-- 
2.47.3

