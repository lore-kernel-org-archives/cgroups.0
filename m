Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164060;
	b=z0RnW9nGXt4xPztEx2U1STtYv6KDfTAL2uy6Wshw/8ut+k2Ia+vXRHt0JjUCjdwD3OJ4
	 XCas+E732ZP7XIMSdfRYMD5/3RWUgUzJseE/ktMA87CRJe2gRImxXMcKczmnhaiGc0Lx6
	 2zuBEyM+eXNCDUUhDKGuqtgvQ4SArDmksnVy4j4xuc1eo1fBfMNRgL3jY3Fh0wfU9nBzd
	 BiQ91E/QwzkHBfyh9i8R63IDEpUy7jpl7g6tY9Lt1DcEbkVQjFLQ8cdTrDfX07YJhb979
	 dzcVb7kHnAUKqFqV9DcnZTBdsukuB2VfNPGLBK5pmpX+Msy3RHtYIxfifCWMtCsC9sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164060;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SS+vpTwF7aYGcVFIu25OvHq8MDgMdEnsaAm/PnqTQBk=;
	b=d+agdUEQuWqWDyHPK435XwDaw6BLGdWRMewI+Qn1wI2nMpr1tj2yRe3MhjvXZOLuxz3N
	 sppjY0Q1G7mHb/zvdM4mzuDPUCcAl+KvzfZxmMUNlU+XmkJvN8euKb+j6Lso9VDGXWuWK
	 FusaeJN8MrYxzp0hBtEiiXIAsjY0pM7p/jyyD4NyHmwRZE4Dq9wVMOUeZP1Mmgww121fF
	 hc92tUXOdeV6C+raNooiiJq+0jbDom+GdD4SBUuwnMD8ehrmqGgu+ZYT/qaw+++Cb08wi
	 0QJuanYO3QXim7sV4jH8wQON5mDXVImw0KOhPFfHCQ5kyML6ExxvUvIm8JHiW4uid6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qfCDaPHJ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EE6606D80F;
	Sun,  8 Nov 2026 18:54:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64EE6606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qfCDaPHJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164058;
	bh=SS+vpTwF7aYGcVFIu25OvHq8MDgMdEnsaAm/PnqTQBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfCDaPHJGAM3H6tRuzcVIxsmH9HgdSQ8k6cHJHQtMqjsFjcMrNKPq8hCOKuJ0/uB2
	 IHJlq8PqFL1oTZCGjebA9TTu9pcmRXWg/nA/GnMsrqUHhUQ72cYoEImchpwnxCOL3O
	 zvq2feqhkAFwvmCtRGam414wUc0f7kE/vfr8Lg2ecjxGOxDYloomY0dMRQjhlPU9iF
	 qhpUkBZaaknBjYLKmY9IvT5EIIwJFmb9+cv82rBPXYI/OqUqIPI5S3nB0q8ADcFFl5
	 Jp9FNkWGOLJMS50TI3Roj1LikUH8RCAilQA7jkK0fks8Z3vhRNv0kHBYhRoJ+nU/se
	 rZKFqBVbWaJ1Q==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2By2bB4zMG8;
	Sun, 08 Nov 2026 13:54:18 -0500 (EST)
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
Subject: [PATCH v5 05/29] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Sun,  8 Nov 2026 13:53:42 -0500
Message-Id: <20261108185406.1549770-6-mathieu.desnoyers@efficios.com>
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

__dl_sub() and __dl_add() divide by their cpus argument. Most callers
pass dl_bw_cpus(), the number of active CPUs of a root domain. That
number can be 0, and the division then traps.

Commit daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl
tasks") added extra_bw, the bandwidth that deadline tasks can reclaim
on a runqueue. A change of a root domain's total_bw is shared by the
extra_bw of its active CPUs.

During hotplug, a CPU sits in the default root domain, which can then
have no active CPU. This lasts from the rebuild in
sched_cpu_deactivate() to the offline, and from the online to
sched_cpu_activate(). A debugfs write to its fair server's runtime or
period divides there. Commit 4043f5498416 ("sched/deadline: Reject
debugfs dl_server writes for offline CPUs") refuses the write only once
the CPU is offline. A write of the same bandwidth passes admission in
the window. In 8-CPU VMs of v7.4-rc1, a loop of such writes oopses at
the first offline and online:

  Oops: divide error: 0000 [#1] SMP NOPTI
  RIP: 0010:dl_server_apply_params+0x335/0x380
  Call Trace:
   sched_server_write_common.isra.0+0x1c0/0x260
   full_proxy_write+0x58/0x90
   vfs_write+0xcb/0x550

By reading, two other paths would divide by zero:
- inactive_task_timer(), for a task that left SCHED_DEADLINE or died,
  if its CPU went offline.
- sched_setattr(SCHED_DEADLINE) on a task asleep on an offline CPU,
  with admission control off.

Fix this in two places:
- Refuse the debugfs write while the runqueue is offline. The server's
  bandwidth is not counted then. rq->online is set under the runqueue
  lock when the CPU joins a root domain that counts it, after
  cpu_active() is set.
- With no active CPU, have __dl_sub() and __dl_add() change total_bw
  alone. This covers the other paths.

With this patch, the reproducer survives 20 rounds with no warning.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 11 +++++++++--
 kernel/sched/debug.c    | 10 +++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342..b614d5fc1a1a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -189,18 +189,25 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
 	}
 }
 
+/*
+ * Spread a change of total_bw over the extra_bw of the active CPUs of the
+ * root domain. @cpus is their number. With no active CPU, as can happen
+ * during CPU hotplug, change total_bw alone.
+ */
 static inline
 void __dl_sub(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw -= tsk_bw;
-	__dl_update(dl_b, (s32)tsk_bw / cpus);
+	if (cpus)
+		__dl_update(dl_b, (s32)tsk_bw / cpus);
 }
 
 static inline
 void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw += tsk_bw;
-	__dl_update(dl_b, -((s32)tsk_bw / cpus));
+	if (cpus)
+		__dl_update(dl_b, -((s32)tsk_bw / cpus));
 }
 
 static inline bool
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..e0d6cd3bd607 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,15 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Refuse the write while the runqueue is offline. This
+		 * includes the windows where the CPU goes offline or comes
+		 * online. The root domain then does not count the server's
+		 * bandwidth, and may have no active CPU. rq->online is set
+		 * under this lock when the CPU joins a root domain that
+		 * counts it. cpu_active() is set before that.
+		 */
+		if (!rq->online)
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

