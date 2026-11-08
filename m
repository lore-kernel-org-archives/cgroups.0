Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164061;
	b=FipDSkVEYEl9yOHM20CZAyNlEqNkNEPfE08d7uPcJlFuVBTb8g9mkGVtD1fJSXsmbvrG
	 SidcZi7EG9kBU8INxQdq8xe+l0q5bxtlcCnTIVI5J311Zf6aHcor8EULmpBUGxWerl7l5
	 bt/v92aDHR5cg5NEgSJDG+RHxFqs9mO0KcV5kFjisKp2JwqMG3NtNDfgcTEzebWprA7cv
	 oVghUE4Thf1mE8kNZYyLu2+77ly6KGGSB5gplSsdCTY0vHySO9fOTFUCuRMSRODLgchvf
	 S5wwTdQrK7AvWH52D86g7yaz1xuazHEvaWTcK1dLZtnMRGbTzw+/pr+PAPtnib1IrvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164061;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ltuseFT1g5L26BNcvKAsBcY2Qumxtv+AU9lJzzmN/H8=;
	b=kboVVA8/JIj7+XlRROGQWzxrJZsAIBLkRf0EmUJ08/ZpMH32umNTfLhGuyLM4OBDAHv8
	 xZVx4m9jhlUt3MGfgxYgYkeb56M6WGRoOApIvRRzaA2gZxdE68Pl/4ZmN88Pi4F6BhTCh
	 AahCSWAmLZfW/E5XGzqzRBHUW2mXvmIdlniwdwJOLAx2hdD2MgLEJbXrdIZFPanuQuMQ0
	 S0P4cLYJKGvIPXFNtdd9XO+xBHH95+HMNtfZVelTF4c5CXAoO0f8ERN+8m8cjWx+iCfil
	 Z14L6xtTfWAj8zZGuZrqob7AwEuJ2kXjwF4wlq8itrxGeBZcMESWpwNI4eSp4SwZ1EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=G5EaMXkU;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E09606EE85;
	Sun,  8 Nov 2026 18:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79E09606EE85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=G5EaMXkU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164060;
	bh=ltuseFT1g5L26BNcvKAsBcY2Qumxtv+AU9lJzzmN/H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5EaMXkUzyQeivO8bB04kJmdkz4xb5wNSOcrKH7vQxfrgww5v9SFV1H3CPHVlw3bn
	 lUyUqCNBRrdn69pZabk/phwSsc1pWY5TfzT7H1wLE9HWkcadD/af5W7tIxgu1spX8i
	 M+usRbXulCturBF+tyKyY1IB6TxvgwGTtHQ0hBCeiMnE41eUNj6cK85VIeGVu8naez
	 6jLcv9NTtnOTNUNBKO05qkNYp6OkJmVM2y3Mtxgb/VGRYl5Ix4nlpmT2sduVrdmFOW
	 1L6iXVWAXFT0OCT7EissE1Su4DlVxYD180/tkDW21qeWPA559Dr4Ivn2avBOy9A/dK
	 /LvOoluGnDAEQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C03WzqzM5t;
	Sun, 08 Nov 2026 13:54:20 -0500 (EST)
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
Subject: [PATCH v5 10/29] sched/deadline: Reset the donor's runtime at a deboost in the class
Date: Sun,  8 Nov 2026 13:53:47 -0500
Message-Id: <20261108185406.1549770-11-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

A task boosted by a deadline waiter runs on the waiter's reservation.
Commit 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance
logic") uses the waiter's parameters "during the whole period it holds
the pi-lock".

A task that leaves the class at its deboost has its deadline and
runtime checked. "sched/deadline: Reset the deadline and the runtime
with the parameters" resets them for a task with no parameters. For a
task with parameters, task_non_contending() clears them if the runtime
does not fit the task's own bandwidth.

But a deadline task stays in the class. rt_mutex_setprio() only clears
dl_boosted. enqueue_dl_entity() keeps a deadline that is ahead. So the
task runs on the waiter's runtime until that deadline. A task that
sched_setattr() makes SCHED_DEADLINE while boosted ends the same way.

In one period, the task can then run what the waiter left on top of
its own runtime. Other deadline tasks can miss deadlines.

The task's own reservation never gives it a runtime above dl_runtime.
Fix this by resetting the deadline and the runtime when a boost ends in
the class with a runtime above dl_runtime. The next enqueue then starts
a new period. A runtime of dl_runtime or less is kept, with its
deadline. By that deadline, the task then runs at most one runtime of
its own. A new period would give it a full runtime.

The Sashiko AI review of the fourth posting found the sched_setattr()
case. The deboost_in_class_resets_period case of deadline_bw_test,
added later in this series, tests it.

Fixes: 2d3d891d3344 ("sched/deadline: Add SCHED_DEADLINE inheritance logic")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/core.c     |  2 +-
 kernel/sched/deadline.c | 16 ++++++++++++++++
 kernel/sched/sched.h    |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e4d299acb1fc..bf722f5ff97e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7898,7 +7898,7 @@ void rt_mutex_setprio(struct task_struct *p, struct task_struct *pi_task)
 				dl_boost(&p->dl, &pi->dl);
 				scope->flags |= ENQUEUE_REPLENISH;
 			} else {
-				p->dl.dl_boosted = 0;
+				dl_deboost(&p->dl);
 			}
 		} else if (rt_prio(prio)) {
 			if (dl_prio(oldprio))
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index cc43c5eeae51..e6c55afcfd01 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -118,6 +118,22 @@ void dl_boost(struct sched_dl_entity *dl_se, const struct sched_dl_params *param
 	dl_se->pi_params = *params;
 	dl_se->dl_boosted = 1;
 }
+
+/*
+ * End the boost of @dl_se, a task that stays in the class. Its own
+ * reservation never gives it a runtime above dl_runtime. A larger runtime
+ * is what the donor left. In that case, reset the runtime and the
+ * deadline. The next enqueue then starts a new period. The caller holds
+ * the rq lock and the pi_lock of the task.
+ */
+void dl_deboost(struct sched_dl_entity *dl_se)
+{
+	if (dl_se->dl_boosted && dl_se->runtime > (s64)dl_se->dl_runtime) {
+		dl_se->deadline = 0;
+		dl_se->runtime = 0;
+	}
+	dl_se->dl_boosted = 0;
+}
 #else /* !CONFIG_RT_MUTEXES: */
 static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a06cf2e0d983..d0f5ed98ef48 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -358,6 +358,7 @@ extern int  sched_dl_overflow(struct task_struct *p, int policy, const struct sc
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
 #ifdef CONFIG_RT_MUTEXES
 extern void dl_boost(struct sched_dl_entity *dl_se, const struct sched_dl_params *params);
+extern void dl_deboost(struct sched_dl_entity *dl_se);
 #endif
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
 extern bool __checkparam_dl(const struct sched_attr *attr);
-- 
2.47.3

