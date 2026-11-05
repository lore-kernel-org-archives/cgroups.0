Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907259;
	b=e+LMQVUO2s9aq17tRZ2TrbK1RBdDWhtvQsZJcGBWTL7qZqlYxAZ/XXjPyZINkC/26ivO
	 0iDQxdd76RT3KeZXvk55F5uyiKGOGcam8avBXYWc8JkD7VfwtYfb/0xsF7fmLfjI2ZZ+0
	 24lzyP/4KJ08gIJMtUNCXHj9xVIYzBO4tq/K3R6E+Z94CvjJRrczaAb/Y6bPNcpVbzCPr
	 nUUOpVrWECamaZxE4hz1uEbEwayFK9My5lw0AAopLW+3SB6rJpEq965hSpsB8RlRM2FlK
	 JJGBLLQqNkbGfo29Wb+GK3MZ5lGUkl73oxQU91udRnuAlbGGjKbOaurY3VcBvIuwUbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907259;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WucqaX82oakzzf1Xbtddnhr1ODU+ffiW2oltSXpboBg=;
	b=ARY/7ktQs7JBlQ2tfej3D779FtI945qJS/b7YW0UMGBGsU/yUSCc9EK4Xhdt0HDL0KGg
	 xxNUkIXNiaqNuEjQ6ys4uq+UGKtJn21o7UROCZxChbWrjkQT/gcxoUlofdihpa1ebQTdQ
	 4Mb8M52Dmv3MdRRSgM58JH4eQIA2uufdf2M3ZmWj/h0v0aqHMWoChDfgIA5Z2DhkhaKj7
	 tGZIy1tiN9qj/3C4KxRl9do2cjDHVHFDGYLb9c3ZlkHifiQDsaAsjpzeiu8feZE0xfGlC
	 +hXogUhj7BCc8CtVeTkxCqQhEUL3e4lYcPnQunN9rqIwZa/6F++WqN0QcjTwb01BY2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KSKmGsM8;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E81606F59E;
	Thu,  5 Nov 2026 19:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6E81606F59E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=KSKmGsM8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907250;
	bh=WucqaX82oakzzf1Xbtddnhr1ODU+ffiW2oltSXpboBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSKmGsM8/Q5E1WFO7Uy9R9emrjEl00CsdY9ZTWhCL6uOF1dR/F16I6IPILcrwvNfw
	 GX3TYIKO4dTQS7Zk5XsIaBjWWQ/S/733osG9M/RQonHk9DhsHLJCAh0bGbUCBZkCrc
	 dnQipbxAfNnYrXCRAznmlfkic20cu4RVO538PAX/kHQerzxfWq6FAWiXJxrwmIQ/fw
	 8Zbb1CJH9fIB25iAjaaSj2ia87uN9h7tt1C/0UCH2c+LqktG4Dp27+QnvXuZXDLDA4
	 iHNDn0ah51r/YEC5Otoc62/U3vW2v1yFynshBfJQmVoqGTPEYWnKNMdd6eV2FpSode
	 RJURnKrrQLWCA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDL51BXzLPR;
	Thu, 05 Nov 2026 14:34:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 11/24] sched/deadline: Do not take a waking task's bandwidth off a runqueue it left
Date: Thu,  5 Nov 2026 14:33:46 -0500
Message-Id: <20261105193359.1450487-12-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

Whatever happens to the task in that window takes its bandwidth from a
runqueue that does not have it, or gives it to one that already does:

 - sched_setattr() finds it off the runqueues, and
   dl_change_utilization() takes its old bandwidth off the runqueue of
   task_cpu(), which never held it. this_bw of that CPU underflows,
   which costs every other task and the fair server there their own, for
   good. switched_from_dl() leaves the class through the same hole;
 - a switch out of SCHED_DEADLINE and back in that window has
   switched_to_dl() charge the runqueue of task_cpu(), and the enqueue
   that lands later charges it a second time, since task_contending()
   goes by ENQUEUE_MIGRATED. this_bw of that CPU then counts the task
   twice, and the release of one of the two underflows it later.

Say in the entity whether a runqueue counts its bandwidth, as
dl_bw_oncpu, and have add_rq_bw() and sub_rq_bw() put it there and take
it away once each: an add on a runqueue that counts it already, and a
subtraction from one that does not, then change nothing, and
dl_change_utilization() has a runqueue to act on only while one counts
it. The servers keep their own tally, dl_bw_attached, and go through
__add_rq_bw() and __sub_rq_bw() directly.

Reaching the first needs a deadline task whose wakeup migrates, which
asks for more than one CPU in its root domain and for them to be taken.
It is easier to reach with CONFIG_SCHED_PROXY_EXEC=y, where a task
blocked on a mutex is migrated to the CPU of its owner and wakes back on
its own.

In 8 VMs of 8 vCPUs, a task of 10ms every 100ms that sleeps and wakes in
a partition root of two CPUs, both taken by deadline tasks of an earlier
deadline, its runtime changed between 10ms and 20ms from a CPU outside,
warns in all 8 within a second, and the warnings spread to the idle
task's accounting of both CPUs:

  WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
   __sub_rq_bw(): this_bw underflow
  WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
   __add_running_bw(): running_bw overflow

The 8 VMs above warn no more with this change. deadline_bw_test, added
later in this series, has params_waking for it: without this change it
fails on every one of those VMs, and random_mix on one of three.

The double charge of the second case was found by the Sashiko AI review
of the first posting of this series, which also pointed out that the
first version of this patch left its bit set for an entity with no
bandwidth of its own; a bit that says where the bandwidth is, rather
than where it is not, has neither fault.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  1 +
 kernel/sched/deadline.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0633a73579db..6803df5ab13c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -718,6 +718,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_bw_oncpu       : 1;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 37b931fc2faf..d4cd5b5fb27b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -353,18 +353,31 @@ void __sub_rq_bw(u64 dl_bw, struct dl_rq *dl_rq)
 	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);
 }
 
+/*
+ * @dl_bw_oncpu tells whether this_bw of a runqueue counts @dl_se's
+ * bandwidth, so that these two put it there and take it away once each:
+ * a wakeup takes it off the runqueue the task slept on and the enqueue on
+ * the one it wakes on puts it back, and what happens to the task in
+ * between must not count it twice, nor take it from a runqueue that does
+ * not have it. The servers keep their own tally, dl_bw_attached, and go
+ * through __add_rq_bw() and __sub_rq_bw() directly.
+ */
 static inline
 void add_rq_bw(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
-	if (!dl_entity_is_special(dl_se))
-		__add_rq_bw(dl_se->dl_bw, dl_rq);
+	if (dl_entity_is_special(dl_se) || dl_se->dl_bw_oncpu)
+		return;
+	__add_rq_bw(dl_se->dl_bw, dl_rq);
+	dl_se->dl_bw_oncpu = 1;
 }
 
 static inline
 void sub_rq_bw(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
-	if (!dl_entity_is_special(dl_se))
-		__sub_rq_bw(dl_se->dl_bw, dl_rq);
+	if (dl_entity_is_special(dl_se) || !dl_se->dl_bw_oncpu)
+		return;
+	__sub_rq_bw(dl_se->dl_bw, dl_rq);
+	dl_se->dl_bw_oncpu = 0;
 }
 
 static inline
@@ -433,6 +446,14 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	if (task_on_rq_queued(p))
 		return;
 
+	/*
+	 * Waking up on another CPU, the task has its bandwidth on no
+	 * runqueue: the enqueue to come charges the new one, with the new
+	 * parameters, which __setparam_dl() sets right after this.
+	 */
+	if (!p->dl.dl_bw_oncpu)
+		return;
+
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
@@ -2789,6 +2810,11 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 		 */
 		cancel_inactive_timer(&p->dl);
 	}
+	/*
+	 * Until the enqueue on the CPU it wakes on charges it there, this
+	 * bandwidth is on no runqueue: the rq of task_cpu() is not the one
+	 * it was taken from, which dl_bw_oncpu now says.
+	 */
 	sub_rq_bw(&p->dl, &rq->dl);
 	rq_unlock(rq, &rf);
 }
@@ -4206,6 +4232,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_bw_oncpu		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.47.3

