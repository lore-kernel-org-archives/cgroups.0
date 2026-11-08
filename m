Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164063;
	b=UPCIZCy4dXsDI6CQTZ3X5kjQKgt5N6g3X/bB0aNdDbNvhYOdVH2IUbfbtsyN6TFIf5GL
	 xsqEWA2VEDbpzDK9rXYQPe0LQFjMoXZeFbPvsCjumeSfKdw2FscXP/8GCtWjtMpnQ6/HT
	 Dwe2R4cmkT5jJf2jdEZ96j6wvSnCK1eaci33JhyUBo23Kfla7ld2LaDTwI4iPUpWHYz7X
	 tXmn7mzWEHCUWF5iD/Rp6a0W3OmbY7/U8dNt639bZYS+YQNaSnKjmTPlo0Kqnqj5WQYQX
	 lh3ISPVKiLcp5ydZLRoKco/pP+Qi0RETxZmThMzJ4Z3p0ljdlfuN2+z4y2S2PlALBTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164063;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gr/KS4J+5/GoQpqdBIxVjPTFwudi4EEH0JD8vsFcU7I=;
	b=liaqSr01JC4I/9wdmtNAVIAENRY3Q7PdE2BsedX2RIvYMoZRHBrKw6d5kQWIVJ+I3uMQ
	 QON9yWZu+FQzExk+15t5d2JLLWIpeiqg/3mcaKSybwASdOoM4Q3Nv+Dw3jj292FG3rRvk
	 kUv64JK+SgYqNzYha1Uu7xL+fK/fL+mRMFE5Pvh+OihbiJCaviwRL+S98KhD/IArVAi5s
	 YEWKh/a+g25BjBsRrBDKH5qVqw6KD8/04tTXuWSMJzs8PoTks1NQQ3AZhJSmvOnQmI5xc
	 BtfDRZgQ7sBe51KEag9z6SmXIxMLAj/wnvRDEb97HCgv9yZiXH6ayLTSQhCLdQALinw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sSBEs2vE;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52621606EEAE;
	Sun,  8 Nov 2026 18:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52621606EEAE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sSBEs2vE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164062;
	bh=gr/KS4J+5/GoQpqdBIxVjPTFwudi4EEH0JD8vsFcU7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSBEs2vEqfvUROGMNXKnW2Vgybx9n+KD3CnWdIVREbIHYqm7RStJ9IvXrCVXE/NY/
	 M87Ieys/9brh1Ex8iYNBYGxQbFUkFblnPp/0cOg7rH9pJtTf/Rk4oF75t/SeAVvJhG
	 +eTeKoOvPT/yqxcjRGpSn0aBbnSsEcCByLFdYzKdHQD/1tzLZwc6Rt1NzZ0HQSgShB
	 WcEERbU2xcXxtePWthTpDkGflx2Jp6IgXph+VH88Th1iDbkxIGQhNP1kMuyh/JYxg/
	 bmKfxfNq0zvgVqa2ETcNovaDLyltMq/g0m504qhgoEef23ioOgclxbwbAzG9drXqi3
	 FzgLbeaejns6g==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C21FK5zM5w;
	Sun, 08 Nov 2026 13:54:22 -0500 (EST)
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
Subject: [PATCH v5 14/29] sched/deadline: Fix this_bw when a task is changed during a remote wakeup
Date: Sun,  8 Nov 2026 13:53:51 -0500
Message-Id: <20261108185406.1549770-15-mathieu.desnoyers@efficios.com>
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

The this_bw of a runqueue is the bandwidth of the deadline tasks
assigned to it, running or not. GRUB uses it to compute the inactive
utilization of the runqueue. When a task wakes up on another CPU,
migrate_task_rq_dl() takes its bandwidth off the old runqueue. The
enqueue adds it to the new one.

Between these two steps, no runqueue counts the bandwidth.
try_to_wake_up() can leave the enqueue to the wake list of the new CPU,
and return before it runs. task_cpu() already points at the new CPU. A
change of the task in that window gets this_bw wrong.

In this example, T is a deadline task that blocks on CPU 0. A timer
wakes it up there, and try_to_wake_up() picks CPU 1. S, on CPU 2,
changes the bandwidth of T from "old bw" to "new bw":

  CPU 0                               CPU 1                       CPU 2
  T blocks
  this_bw of CPU 0 counts T
  <timer> try_to_wake_up(T)
    set_task_cpu(T, 1)
      migrate_task_rq_dl()
        sub_rq_bw(): CPU 0 drops T
    T on the wake list of CPU 1
    return
                                                                  S: sched_setattr(T)
                                                                    task_rq_lock(T): CPU 1
                                                                    T is not queued
                                                                    dl_change_utilization()
                                                                      this_bw of CPU 1:
                                                                      - old bw + new bw
                                      sched_ttwu_pending()
                                        enqueue_task_dl(T)
                                          task_contending()
                                            add_rq_bw():
                                            this_bw of CPU 1:
                                            + new bw

CPU 1 then counts the new bandwidth twice, less the old one. Repeated,
this makes this_bw drift until it underflows. If T left the class in
that window, switched_from_dl() would take its bandwidth off CPU 1 the
same way. A task that enters the class in that window would be counted
twice, by switched_to_dl() and by the enqueue.

This needs a wakeup that moves the task, so a root domain of more than
one CPU, with busy CPUs. CONFIG_SCHED_PROXY_EXEC=y makes such wakeups
more common. In testing, a task sleeps and wakes in a busy two-CPU
partition root, and another CPU changes its runtime. The kernel warns
within a second in each of 8 VMs:

  WARNING: kernel/sched/deadline.c:352 at dl_rq_change_utilization+0x71/0x2e0, CPU#0: wake_race/109
   __sub_rq_bw(): this_bw underflow
  WARNING: kernel/sched/deadline.c:316 at task_contending+0x244/0x260, CPU#6: swapper/6/0
   __add_running_bw(): running_bw overflow

Fix this with a new bit, dl_bw_oncpu, that tells whether a runqueue
counts the bandwidth of the task. add_rq_bw() adds the bandwidth only if
no runqueue counts it. sub_rq_bw() takes it off only if one does.
dl_change_utilization() does nothing while no runqueue counts the
bandwidth. The enqueue adds the new one.

With this patch, none of the 8 VMs warns. deadline_bw_test, added later
in this series, tests this in params_waking and random_mix. The Sashiko
AI review of the first posting found the double count, and a bit that
the first version of this patch left set.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/sched.h   |  5 +++++
 kernel/sched/deadline.c | 39 +++++++++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5b58ba2003bb..8412fcedb03b 100644
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
index 14d93fe65521..9ced697da07c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -413,18 +413,35 @@ void __sub_rq_bw(u64 dl_bw, struct dl_rq *dl_rq)
 	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);
 }
 
+/*
+ * @dl_se->dl_bw_oncpu tells whether the this_bw of a runqueue counts the
+ * bandwidth of @dl_se. add_rq_bw() adds the bandwidth only if no runqueue
+ * counts it. sub_rq_bw() subtracts it only if one does.
+ *
+ * A wakeup on another CPU takes the bandwidth off the old runqueue. The
+ * enqueue on the new CPU adds it back later. A change of the task in
+ * between must not count the bandwidth twice, nor take it off a runqueue
+ * that does not count it.
+ *
+ * The servers track their bandwidth with dl_bw_attached. They call
+ * __add_rq_bw() and __sub_rq_bw() directly.
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
@@ -493,6 +510,14 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 	if (task_on_rq_queued(p))
 		return;
 
+	/*
+	 * The task is waking up on another CPU, and no runqueue counts its
+	 * bandwidth. The enqueue adds it, with the new parameters that
+	 * __setparam_dl() sets right after this.
+	 */
+	if (!p->dl.dl_bw_oncpu)
+		return;
+
 	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
 }
 
@@ -2852,6 +2877,11 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 		 */
 		cancel_inactive_timer(&p->dl);
 	}
+	/*
+	 * set_task_cpu() points task_cpu() at the new CPU next. The runqueue
+	 * of that CPU counts this bandwidth only once the enqueue there adds
+	 * it. Until then, no runqueue counts it, as dl_bw_oncpu now says.
+	 */
 	sub_rq_bw(&p->dl, &rq->dl);
 	rq_unlock(rq, &rf);
 }
@@ -4276,6 +4306,7 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_defer			= 0;
 	dl_se->dl_defer_running		= 0;
 	dl_se->dl_defer_armed		= 0;
+	dl_se->dl_bw_oncpu		= 0;
 	dl_se->dl_boosted		= 0;
 }
 
-- 
2.47.3

