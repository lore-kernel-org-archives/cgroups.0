Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164067;
	b=DKDHG71Kf1TSMmV63c55fuHmKAeGbSIUoqWtsfdywWFZz4Dg6vvSK8f9JQCMW6Ya0RRo
	 iSbE2IM5okHLDAhaeNbQcTVr8Q7uHMurf9lxaZpJC2I7TmyfzeN6NksL/LbYFpfOsrHQT
	 gEClwTnL5lAto5+1m4/K+9i7xxy1N02gWe1ZcT11aBomBwN08b7p6IEvgkDvsT0SI0iXV
	 /4xF+0RH2KFNL3liYKNtzBSTMfntrBsWwACFVWV3Q43Lm3uUeiOeDOVfokLdNm28JnZLZ
	 OnQ+1yarKeSsM/ahcBH8ZA1BMrf1OOuZiA+s/vlzA7iUQxZzvD5C4AjFUiYhQF28Pag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164067;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OpprsyFOamAoJWvZTUHD+iE00S0KZyiYAKtZMoYolVw=;
	b=bdFgdXlaGyuJsyO9elXe7UoRM6/QKGTseTazB5Ij7TOMVY7AJ4p6qXApl2olNFYSLW7A
	 3BQ/K3e2wgSTJmm4Rfq8IHYIvVudFY/XYCehO6EgZOkCqdOcoBgtrOWzP4DzVcCruo3Xu
	 aF4nv7k1n4Dh+P+3zPUkRsXlW+WBqNEl7OuTCG9hju5fQ59hbARKk0y1xJdtMMpgA2x4N
	 GWstFAZpVz1xSv9HeIn4eo+fKNW0nIg13ab83WaOVzBQagUqiXeQ206SPidHbCAl8XAC7
	 9B/hgxXe4hPBz1uL1zuAfoUQlBiCxkMTSdVflU0U8QRa/tjbXluLJ8aBFfp5owt09+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=F2TT8Lji;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AF5608361D;
	Sun,  8 Nov 2026 18:54:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9AF5608361D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=F2TT8Lji
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164066;
	bh=OpprsyFOamAoJWvZTUHD+iE00S0KZyiYAKtZMoYolVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2TT8Lji9cTl54OFK6i9x9t8zGutJmrMNQos3fsr55YzpRb8MwU+9lnOZldGHFHL1
	 gugJ5sMOPCPG8hrcEOKBlk3G5eE48bbxTs4LAGvcy6nCW8UoZ1Tm+f7lmFe8rem6wk
	 WjKSLVRp7sQEQUhGkV2O5cU1l4iU+W0gWpETEGM9QrEduR1pLMJMWNuC3iD6W8YQkb
	 Lx/jcCLeKnMi6zOqI/7q40LXytrmiscTHbq0SMrI2xDIHGb4vf5TLrx6Y+hhhVkPqt
	 ohnal00KnusFn0mKPyWUKrWnRsYkCjZiOi4GWXK4gpeyBb1brt+AHsZ2UWp5xl0ukj
	 PqvRGPu4lPZew==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C55kdCzM5y;
	Sun, 08 Nov 2026 13:54:25 -0500 (EST)
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
Subject: [PATCH v5 23/29] sched/deadline: Move a task's bandwidth when it must leave its CPU
Date: Sun,  8 Nov 2026 13:54:00 -0500
Message-Id: <20261108185406.1549770-24-mathieu.desnoyers@efficios.com>
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

When a CPU goes offline, a deadline task asleep on it moves at its
wakeup. select_fallback_rq() picks the new CPU. balance_push() moves a
queued task the same way. The new CPU can be in another root domain.
With isolcpus="domain", the isolated CPUs are in the default root
domain, and the housekeeping CPUs in another one. A cpuset that is not
a partition can hold both.

Commit 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all
levels after offline migration") fixed this for a throttled task.
dl_task_offline_migration() moves its bandwidth with it. A task that
select_fallback_rq() places still moves no bandwidth.

The rebuild of the accounting at the offline runs before the wakeup.
So the task runs in a root domain that does not count its bandwidth,
until the next rebuild. That root domain can admit deadline tasks
beyond its capacity.

Fix this in migrate_task_rq_dl(). When a task leaves a CPU that is
inactive or not in its mask, move its bandwidth to the root domain of
the new CPU. Record that CPU. As dl_task_offline_migration() does, add
the bandwidth even without room, since the task runs there. Add it also
if a rebuild left the task out.

This also covers a change of the mask that made no room for the task,
such as sched_setaffinity() without admission control. The bandwidth
now moves when the task leaves its CPU. Before, it stayed in the old
root domain until the next rebuild.

migrate_task_rq_dl() runs under the task's pi_lock for a wakeup, and
under its rq lock otherwise. With dl_departed_lock, either keeps the
record stable.

The hotplug_fallback cases of deadline_bw_test, added later in this
series, fail without this patch. A task woken on an isolated CPU stays
counted in the housekeeping root domain. This follows the Sashiko AI
review of v4.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 58 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index bc31045e4686..a35609a10ec5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2873,11 +2873,54 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 	return cpu;
 }
 
-static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused)
+/*
+ * Move the bandwidth of @p to the root domain of @new_cpu. Count it there
+ * also if a rebuild left @p out. Add it even without room, since @p runs
+ * there. The caller holds the rq lock of @p, or its pi_lock for a wakeup.
+ */
+static void dl_task_move_bw(struct task_struct *p, int new_cpu)
+{
+	struct dl_bw *dl_b;
+	int cpu;
+
+	if (dl_entity_is_special(&p->dl) || !p->dl.dl_bw)
+		return;
+
+	guard(raw_spinlock)(&dl_departed_lock);
+	cpu = p->dl.dl_bw_cpu;
+	if (cpu < 0)
+		return;
+	if (p->dl.dl_bw_gen == dl_bw_gen) {
+		if (cpu_rq(cpu)->rd == cpu_rq(new_cpu)->rd)
+			return;
+		dl_b = dl_bw_of(cpu);
+		raw_spin_lock(&dl_b->lock);
+		__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
+		raw_spin_unlock(&dl_b->lock);
+	}
+	dl_b = dl_bw_of(new_cpu);
+	raw_spin_lock(&dl_b->lock);
+	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(new_cpu));
+	raw_spin_unlock(&dl_b->lock);
+	p->dl.dl_bw_cpu = new_cpu;
+	p->dl.dl_bw_gen = dl_bw_gen;
+}
+
+static void migrate_task_rq_dl(struct task_struct *p, int new_cpu)
 {
+	int cpu = task_cpu(p);
 	struct rq_flags rf;
 	struct rq *rq;
 
+	/*
+	 * The task must leave a CPU that is no longer active, or that its
+	 * mask no longer holds. The new CPU can then be in another root
+	 * domain. Move the bandwidth there, as dl_task_offline_migration()
+	 * does for a throttled task.
+	 */
+	if (unlikely(!cpu_active(cpu) || !cpumask_test_cpu(cpu, p->cpus_ptr)))
+		dl_task_move_bw(p, new_cpu);
+
 	if (READ_ONCE(p->__state) != TASK_WAKING)
 		return;
 
@@ -3577,9 +3620,10 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	 * (different root_domains) entails a bandwidth update. Move the
 	 * bandwidth only if the caller made room for it in the destination,
 	 * as SCA_DL_BW_RESERVED says. Only cpuset_attach_task() sets it.
-	 * Otherwise, the bandwidth stays where it is counted, until the next
-	 * rebuild of the accounting. Moving it without room would leave no
-	 * root domain counting it.
+	 * Otherwise, the bandwidth stays where it is counted, until the task
+	 * leaves a CPU that the new mask does not hold (migrate_task_rq_dl()),
+	 * or the next rebuild of the accounting. Freeing it here without room
+	 * would leave no root domain counting it.
 	 *
 	 * The caller made room in the root domain of ctx->dl_bw_cpu, the CPU
 	 * it expects the move to record. Move the bandwidth only if the move
@@ -3734,7 +3778,7 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
  * task runs, or wakes up, in the root domain of that CPU. A mask can hold
  * CPUs of two root domains: housekeeping CPUs and CPUs isolated by
  * isolcpus="domain". When every CPU of a mask goes offline,
- * select_fallback_rq() can widen it to both. It moves no bandwidth.
+ * select_fallback_rq() can widen it to both.
  *
  * Else prefer the CPU recorded with the bandwidth, if it is active and in
  * the mask. It is in the root domain that admitted the bandwidth, or that
@@ -3801,8 +3845,8 @@ void dl_add_task_root_domain(struct task_struct *p)
 		/*
 		 * No active CPU can count the bandwidth of this task. Leave it
 		 * out of this rebuild. dl_bw_gen then keeps its release from
-		 * removing anything. A later rebuild, or
-		 * dl_task_offline_migration(), counts it again.
+		 * removing anything. A later rebuild counts it again. So does
+		 * the move of the task to an active CPU.
 		 */
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
-- 
2.47.3

