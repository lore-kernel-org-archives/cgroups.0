Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164068;
	b=yZ2F7kCf9nKWVQUHNpLdAak8+a47nnF7vFgJ59m/OcOWCPlPALrVR0zcJ2yONMgScYC7
	 rzXnMBpqLUlKFeXhNnIPrzGxiVZlMZTl1eaMvUlSBDwt+T1KVClDB9M6lxRDBbiEUDfHN
	 Vg+PkQBJZzfxGfI+yXoLfZ+T4pXOHljDvgczmtgFS5CDK/AeVXo6aje+C0bd+e0huEVf4
	 2vX0A3NWORbLhEs3UYs5O4RkSQDpWL4DGDmDn8ogYpeIFN1JwMghKsBH/yfv0ED8nbTuy
	 KDa2EzD5F3nVYucPxfbtWLu+k6zmAoE98AscGWpn/PYrc/lcCOHrzB8j6PmRxEXGAog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164068;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eC94u6hDuVR5e/ux+QurOxV6RQO2Prbl2yuzY3/UcgQ=;
	b=b7Wac1cPv70Pcw2C+TCpZyOWqqGT5ajYL8te1LjOX5zqllyiQEQDUgMDwLIqK7COg5bF
	 /TelWQWiKQswTyOQFur+hL7ufs6vuB7x37D1gaH4PqsxmJ+Bbp2j+fZr2vMqhPm5+1b9M
	 hHmxFkYJa3iy1BMw2NuXqx0Prqz4SX7RzvY5iXUlcEmO7LjdGSIbKiSfiKaKI0A7E5YiE
	 UTOXovaxLrnAhQRT/77PPw13PK8XTeXtlh28CtSIHBFi9nxDf/sGzbXn4v4CB8UfLaoRQ
	 p1R6ptGU23N8xHQ6LPMbyxQOgtHSOTYJubhGAAgYvHYeP6ohwmy9zLfi+S3AZBJNIOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GrZseIx8;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F816083633;
	Sun,  8 Nov 2026 18:54:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1F816083633
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=GrZseIx8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164066;
	bh=eC94u6hDuVR5e/ux+QurOxV6RQO2Prbl2yuzY3/UcgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrZseIx87XhImroHVRZVfKCBPsw2xbJPlQpxcwVHt6c3xXk/sEALKdTmx8j7Yn7rr
	 4FgRL7ZnkPB91wvTvBCLqHYmnm/4gX35COK3PVl9v+fMw7cXHX65aYeFS0uokqNKJf
	 GgkqolTGummUOI0MVIzylwGHH71oZW3/KuIqzp3544wfnG6LUOWZ16pROyN7D+YOg1
	 JfC2873UmZhv9NJ2ts/LRz5zLSx95YT80nB4UGwN8TiJRqx0MNVtnZjsJw4dqoxq3v
	 LA8rNDkqBrUjDmgeptsuAMQEYvSYZpPOigFCrufrBwWwHSlu3cBZS9Np1YyXi3fbEO
	 QHgUt7iu4WYtA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C64l0bzM61;
	Sun, 08 Nov 2026 13:54:26 -0500 (EST)
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
Subject: [PATCH v5 25/29] sched/deadline: Count the bandwidth a boosted task is given
Date: Sun,  8 Nov 2026 13:54:02 -0500
Message-Id: <20261108185406.1549770-26-mathieu.desnoyers@efficios.com>
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

sched_setattr(SCHED_DEADLINE) on a sleeping task that priority
inheritance boosted into the class leaves the new bandwidth out of
this_bw. switched_to_dl() does not run, since the task is in the class
already. sched_dl_overflow() changes this_bw only for a task of the
deadline policy. When the task wakes up, __add_running_bw() warns:

	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);

When the task leaves the runqueue, this_bw would stay short by that
bandwidth, and skew GRUB reclaiming on that CPU.

Fix this by changing this_bw in __setparam_dl(), which every task that
gains deadline parameters goes through. If no runqueue counts the
bandwidth of the task, dl_change_utilization() now adds the new one. It
now also runs when the bandwidth does not change. It then returns early,
so that a sleeping task keeps its running_bw and its inactive timer.

A sugov kthread given a reservation of its own now has its bandwidth
counted in this_bw. It reaches dl_change_utilization(), so the
WARN_ON_ONCE() for SCHED_FLAG_SUGOV there goes. sched_dl_overflow()
returned early for an unchanged bandwidth, even if no root domain counts
it. That is the case for such a kthread, and for a task that a rebuild
left out. Admit such a bandwidth as new. Without room, that fails with
EBUSY. The Sashiko AI review of the third posting found this early
return.

A reproducer shows the warning, and this_bw unchanged by the change.
With this patch, this_bw takes the new bandwidth, and nothing warns.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 54 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 47adff100392..bc76203ab506 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -507,22 +507,37 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+/*
+ * Make the runqueue of a sleeping task count @new_bw as the bandwidth of
+ * the task. Do nothing for a queued task. The dequeue and the enqueue
+ * around the change of its parameters update this_bw.
+ */
 static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 {
-	WARN_ON_ONCE(p->dl.flags & SCHED_FLAG_SUGOV);
+	struct sched_dl_entity *dl_se = &p->dl;
+	struct rq *rq = task_rq(p);
 
 	if (task_on_rq_queued(p))
 		return;
 
 	/*
-	 * The task is waking up on another CPU, and no runqueue counts its
-	 * bandwidth. The enqueue adds it, with the new parameters that
-	 * __setparam_dl() sets right after this.
+	 * No runqueue counts the bandwidth of the task. Add the new one to
+	 * this runqueue, so that add_rq_bw() adds nothing later. A task that
+	 * enters the class asleep comes here, and so does a special entity
+	 * given a reservation of its own. So does a task waking up on
+	 * another CPU: task_cpu() already points at the CPU it wakes on.
 	 */
-	if (!p->dl.dl_bw_oncpu)
+	if (!dl_se->dl_bw_oncpu) {
+		__add_rq_bw(new_bw, &rq->dl);
+		dl_se->dl_bw_oncpu = 1;
+		return;
+	}
+
+	/* Same bandwidth: leave running_bw and the inactive timer alone. */
+	if (new_bw == dl_se->dl_bw)
 		return;
 
-	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
@@ -4407,10 +4422,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (attr->sched_flags & SCHED_FLAG_SUGOV)
 		return 0;
 
-	/* !deadline task may carry old deadline bandwidth */
-	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
-		return 0;
-
 	/*
 	 * Change the bandwidth of a deadline task where it is counted: in
 	 * the root domain of the CPU recorded with it. A task moved asleep
@@ -4425,6 +4436,16 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 */
 	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
 		  p->dl.dl_bw_gen == dl_bw_gen;
+
+	/*
+	 * !deadline task may carry old deadline bandwidth. The same
+	 * bandwidth needs no admission if it is counted. If it is not, admit
+	 * it as new below. A special entity given a reservation of its own
+	 * has no bandwidth counted, nor has a task that a rebuild left out.
+	 */
+	if (new_bw == p->dl.dl_bw && counted)
+		return 0;
+
 	cpu = counted && p->dl.dl_bw ? p->dl.dl_bw_cpu : task_cpu(p);
 	dl_b = dl_bw_of(cpu);
 
@@ -4454,7 +4475,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		if (counted)
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
-		dl_change_utilization(p, new_bw);
 		err = 0;
 	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
 		/*
@@ -4504,6 +4524,18 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
+
+	/*
+	 * Change the bandwidth that the runqueue counts here, with the
+	 * parameters. A task that priority inheritance boosted into the
+	 * class is in it already, so switched_to_dl() does not run for it.
+	 *
+	 * A special entity has no bandwidth on a runqueue. Test the flags
+	 * of the request, since those of the entity are still the old ones.
+	 */
+	if (!(attr->sched_flags & SCHED_FLAG_SUGOV))
+		dl_change_utilization(p, to_ratio(period, attr->sched_runtime));
 
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
-- 
2.47.3

