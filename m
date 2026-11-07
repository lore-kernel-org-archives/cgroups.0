Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015905;
	b=BHRwi9p7nqlziOnHdR1XYmsAI6rboHv/GaYDeW8+ppaXZYEcKTjbpwLfwkv8FIG1Ry3h
	 rmFljnUOY8o1PWfTa1F9D25yax7cl/J74lhdLvgWCH1yYzQyVv9+f/iqWwZYgbsbFsfj1
	 RT3r4ihPDM4g1yEGZaZO/MyHsYWVgEbPr3zAl+UAW9K8pmGdHHRWnMjrie7Li9nncaDj3
	 5SJ7QRB81tATfeA3auCHcvexyBGE0q1iejX4y0Pv2mUOk4DPKtZU+WOLdUAGqOGsuew0e
	 RmHKdmEN9YmVJvAQ91BhE4IRZoECQcATRk5k42gMANU0Kx7yDe8bq0TDEVSUhocDIsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015905;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=P4M40Pbp/UsS2G/H7tLl1GqXJTVqiEJtQmQGN/kS8J4=;
	b=u0mIs8IMC+JGHoL9EPsIHTHPIIuEakMv2+toKhZg7EI+M08Q4+sWDKZ/SMgkC1kMLnU0
	 uedD9U5sRcH0ZyziF/kqMS4sn6knLyAk0rGp9wtGVRMyp+Tm6/CyxbOuGiRkzOmARCkBZ
	 IxomUPTc++32plIVm2lrA+dRgO9NyJnBPR7BJB2ks71vsXD4uAIEhEe7bWyaGhJ2zAUwg
	 rXRs+0AnA+ffMvibvkwO3sP+Je9KU3r4qk/GvRYGJUbR7bUsIeMQ36wa2ghS2l/+KdUix
	 walwkSl4fyt5898mFdZeyuN9DPXGrO5fz03JZ/35WeQEonByisL39Qaz0d8PpyTgfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ChCnfQA7;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F3606EE89;
	Sat,  7 Nov 2026 01:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 976F3606EE89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ChCnfQA7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015903;
	bh=P4M40Pbp/UsS2G/H7tLl1GqXJTVqiEJtQmQGN/kS8J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChCnfQA7IT1vfQKbMBQZ5jYjSB4lrnXDVej9bdqwoxPt/1IniyO4qelvMkJAFtQjf
	 lcQGYVCxQNGffdLieI4ue7ZviggNpOnsvmsq3tk4hQ6SAOw0/cx8aa4VYVBQxltgiu
	 cNcQQ12BnbAvjGpxPM3zaDLr/7mWCEMwVh9jhEcCeNW4ZDq6kBxDQoaB9FtFf+++77
	 El6TvIaBaNOEimyg8o3AILlSu12PwISSx9ncAjMAnd9W4odD5qPmcOCZBWh62yIl8d
	 sn3V01ps9b+S1pJal1hMIG01BldP1s7YeJad496uThmqbYLouTyZ/dUvmXDEYW/ik4
	 URN7jX/fV687A==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPq3nxQzLKd;
	Fri, 06 Nov 2026 20:45:03 -0500 (EST)
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
Subject: [PATCH v4 13/26] sched/deadline: Do not take a waking task's bandwidth off a runqueue it left
Date: Fri,  6 Nov 2026 20:44:38 -0500
Message-Id: <20261107014451.1487825-14-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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
the CPU it wakes on while its bandwidth is on no runqueue at all. What
happens to the task in that window takes its bandwidth from a runqueue
that does not have it, or gives it to one that already does:

 - sched_setattr(), finding the task off the runqueues, has
   dl_change_utilization() take its old bandwidth off the runqueue of
   task_cpu(): this_bw of that CPU underflows, costing every other task
   and the fair server there their own, for good. switched_from_dl()
   leaves the class through the same hole;
 - a switch out of SCHED_DEADLINE and back in has switched_to_dl()
   charge the runqueue of task_cpu(), and the enqueue charges it again,
   task_contending() going by ENQUEUE_MIGRATED: this_bw counts the task
   twice, and underflows later.

Record in the entity whether a runqueue counts its bandwidth,
dl_bw_oncpu, and have add_rq_bw() and sub_rq_bw() add and subtract it
once each: an add where it is counted, or a subtraction where it is not,
changes nothing, and dl_change_utilization() acts on a runqueue only
while one counts it. The servers keep their own tally, dl_bw_attached,
and call __add_rq_bw() and __sub_rq_bw() directly.

The first case needs a wakeup that migrates, in a root domain of more
than one CPU, all taken; CONFIG_SCHED_PROXY_EXEC=y makes it easier,
migrating a task blocked on a mutex to the CPU of its owner and waking
it back on its own. In 8 VMs of 8 vCPUs, a task of 10ms every 100ms that
sleeps and wakes in a two-CPU partition root whose CPUs run deadline
tasks of an earlier deadline, its runtime changed between 10ms and 20ms
from outside, warns in all 8 within a second, and the warnings spread to
the idle task's accounting of both CPUs:

  WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
   __sub_rq_bw(): this_bw underflow
  WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
   __add_running_bw(): running_bw overflow

With this change none of the 8 warns. deadline_bw_test, added later in
this series, has the case, params_waking, which fails on every one of
those VMs without this change, and random_mix on one of three. The
double charge was found by the Sashiko AI review of the first posting of
this series, as was a bit the first version of this patch left set for
an entity with no bandwidth of its own.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index eb06c541927e..6df7d20cbb97 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -714,6 +714,10 @@ struct sched_dl_entity {
 	 * entities (@dl_server == 1). Allows toggling the reservation on/off
 	 * without losing the configured @dl_runtime/@dl_period.
 	 *
+	 * @dl_bw_oncpu tells if the this_bw of a runqueue counts the task's
+	 * @dl_bw: add_rq_bw() and sub_rq_bw() set and clear it, under that
+	 * runqueue's lock. Not for servers, which keep @dl_bw_attached.
+	 *
 	 * @dl_boosted tells if priority inheritance boosted the entity: it
 	 * runs on the parameters copied in @pi_params.
 	 */
@@ -728,6 +732,7 @@ struct sched_dl_entity {
 	unsigned int			dl_defer_running  : 1;
 	unsigned int			dl_defer_idle     : 1;
 	unsigned int			dl_bw_attached    : 1;
+	unsigned int			dl_bw_oncpu       : 1;
 	unsigned int			dl_boosted        : 1;
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4f69ac1846ac..6b0ec2003857 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -391,18 +391,31 @@ void __sub_rq_bw(u64 dl_bw, struct dl_rq *dl_rq)
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
@@ -471,6 +484,14 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
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
 
@@ -2833,6 +2854,11 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
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
@@ -4256,6 +4282,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_bw_oncpu		= 0;
 	dl_se->dl_boosted		= 0;
 }
 
-- 
2.47.3

