Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015908;
	b=v9XwFx+KdqtmLzQR17D+2SQqc4Ple5yTv4TM12dO/nCQKJ0y/UF5anDdqUjcu+Q5SYZ1
	 W4zgTw2kgwqykNCLqAhfL+T/zN7V5uiRC3Yk+OGoIe3wUz/R1g0dy5IaBIQBv5T12Lf9t
	 PbymRlIVAWgwgzlBAc1tMa7bNIL3+BEAgbuQYEr/SnCsYCVcoveHII/f0f693GbT/2TB3
	 z+T8HUZYAC80l6HU2AXnnwZdFHyQ/8XmyxFDUfxxKfxG2jCTNNXgo7bCu+XOoOCOmsBiw
	 JYzfd6qMNvLEfm4mmibYQrSzAZTdvw/VH8WQWvvsxPyrSbo199ZaJ690KYBELkL99sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015908;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=slL8NamYR9VzLcTiWfinwEGIUtzbC8eAK69Tm+qZeMU=;
	b=U393ws7oOGhOqIu8lMb8VAoYmesRFHuUjThcFuf0MiHUWFqsUMSruVDYv5eVK7dRWzZY
	 5OScMzxR7HEI0iY6Ds3fbVcSdL80zTlAiX+aALNIQ1uZmLxcgZhNM30RJOWIgKZS/oiMR
	 HP94vnZjhAJQNIFD4x+rZu1hh8GabptTUVFYnQEaX3xzFolZ5rL+P4DH5jz3bcJXWA7cz
	 IHVvPTOneyOeG41Uoonrs1vuSoz9zB2xXGpCckoiCjKqQj9BFC6tQKHMf+MrZV3/FT/lj
	 znOTxUztS8Ry0ZKfLkkPGEt6ls7fzzO/T0Ct2WPYu6Vhq62kggj6zF5F3R+2PdZpaEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qz5T5v9T;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349FD6082BE0;
	Sat,  7 Nov 2026 01:45:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 349FD6082BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qz5T5v9T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015907;
	bh=slL8NamYR9VzLcTiWfinwEGIUtzbC8eAK69Tm+qZeMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz5T5v9THYPEcJfKyWXi4RtbeYgaIppDBM81WuINHwo5P1sr5gUMOITOHNUaRzc6Q
	 oeA7eOKth59p6EA9lyq75VYTNYLOCP6lcFE6TFP096/A5VVoYeZzQFdQN+cYcljpMH
	 k65RXjWe3u+2KkpKzVUqyUODVds86m1iJdz1AWyhhIWBGz5iKSGlu8VgUHzgk1apTh
	 /u4Ea9KlrYA3/4gYeyQGGEZa1FM1LQpz8+/4G07UNgFTJX9fE7Y27cKAt83zGP+LtH
	 88DRnrWVcZq7Uk9JK2AwSuIRJiuRlqH6FWcZYJtP4VPfS8JEtGkBUNyUW4hyiBSgmy
	 IxbLMMVYA0l5g==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPv1lnwzMR9;
	Fri, 06 Nov 2026 20:45:07 -0500 (EST)
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
Subject: [PATCH v4 22/26] sched/deadline: Count the bandwidth a boosted task is given
Date: Fri,  6 Nov 2026 20:44:47 -0500
Message-Id: <20261107014451.1487825-23-mathieu.desnoyers@efficios.com>
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

sched_setattr(SCHED_DEADLINE) on a task that priority inheritance
boosted into the class leaves the this_bw of its runqueue without the
task's new bandwidth: switched_to_dl(), which hands a sleeping task's
bandwidth to this_bw as it enters the class, does not run for a task in
it already. Its wake-up gives that bandwidth to running_bw alone:

	WARN_ON_ONCE(dl_rq->running_bw > dl_rq->this_bw);

and the two sums GRUB reclaims from disagree by that bandwidth until the
task migrates, where the enqueue adds it (add_rq_bw()).

Change the bandwidth the runqueue counts in __setparam_dl(), which every
task that gains deadline parameters goes through, rather than in
sched_dl_overflow(), which only a task of the class reaches that way. A
runqueue that counts nothing of the task takes the new bandwidth now,
where "sched/deadline: Do not take a waking task's bandwidth off a
runqueue it left" left it to the next enqueue: that enqueue finds it
counted and adds nothing, and a waking task's task_cpu() is the runqueue
it wakes on already. The bandwidth of a special entity stays counted
nowhere, the request telling one, since the entity's flags are those of
its old parameters: a sugov kthread given a reservation of its own gets
that one counted.

A reservation with the bandwidth the kthread had needs more:
sched_dl_overflow() returns at once for a task of the class whose
bandwidth does not change, before asking whether that bandwidth is
counted, which a sugov kthread's is not, nor that of a task a rebuild
left out. Ask first, and admit and record bandwidth that is not counted
as new. A runqueue that counts the bandwidth a change keeps has nothing
to change: dl_rq_change_utilization() would take a sleeping task's
running_bw off before its 0-lag time and cancel its inactive timer for
nothing. The early return was found by the Sashiko AI review of the
third posting of this series.

Fixes: 8fd27231c330 ("sched/deadline: Track the "total rq utilization" too")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a0b05ff8c6da..ac01a0023c8f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -478,22 +478,36 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
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
 
 	if (task_on_rq_queued(p))
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
+		return;
+	}
+
+	/* Counted with the bandwidth it keeps: nothing changes. */
+	if (new_bw == dl_se->dl_bw)
 		return;
 
-	dl_rq_change_utilization(task_rq(p), &p->dl, new_bw);
+	dl_rq_change_utilization(rq, dl_se, new_bw);
 }
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
@@ -4274,10 +4288,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	if (attr->sched_flags & SCHED_FLAG_SUGOV)
 		return 0;
 
-	/* !deadline task may carry old deadline bandwidth */
-	if (new_bw == p->dl.dl_bw && task_has_dl_policy(p))
-		return 0;
-
 	/*
 	 * The bandwidth of a task of the class is counted in the root
 	 * domain that took it, which the CPU the task is on does not tell:
@@ -4289,6 +4299,16 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	 */
 	counted = task_has_dl_policy(p) && p->dl.dl_bw_cpu >= 0 &&
 		  p->dl.dl_bw_gen == dl_bw_gen;
+
+	/*
+	 * !deadline task may carry old deadline bandwidth. The same
+	 * bandwidth, counted, is nothing to admit; not counted, a special
+	 * entity given a reservation of its own, or a task a rebuild left
+	 * out, it is admitted as new below.
+	 */
+	if (new_bw == p->dl.dl_bw && counted)
+		return 0;
+
 	cpu = counted ? p->dl.dl_bw_cpu : task_cpu(p);
 	dl_b = dl_bw_of(cpu);
 
@@ -4318,7 +4338,6 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 		if (counted)
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
-		dl_change_utilization(p, new_bw);
 		err = 0;
 	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
 		/*
@@ -4368,6 +4387,20 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 void __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
+
+	/*
+	 * The bandwidth of a special entity is counted on no runqueue, and
+	 * the request tells one, the flags of the entity being those of the
+	 * parameters it had. The rest have theirs changed here, where their
+	 * parameters are:
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

