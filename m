Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790175;
	b=YJIZ4cGyiadGOBUyTW4KAJYxVnffYjIkkYoNj2GrNnqQZEvAQzBQ5/IQmcKqWmDBvaki
	 k+MbeiCrC48POtDbeCUjmAxpWAV564bpnfb8ZtYfnXbf3MKFxvYY5QU/LmYTCHUeTBwRA
	 ms7adozKGKeyDeZNxmA8eU+VFoDjm3et26Q+ykLSwlOTmw65l+sdortSdeQ4LG5pDhAoN
	 O4EOrmKRGjgBKepSI2UHMgvc9ssXQ12qWO3NJCuJTNJJLHIoBdvNNCdK6/VcQ7dCPhFeh
	 WH+JO794Lkfr0G019orUTW1bAKHtTzFMDHrkthhJN2ouXJA8AJWeI7zqKL9EHcWGvvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790175;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Dfv08/N+kF+Mvy690ORsGCHE5ksDbaHpXa/TyHWA4Dw=;
	b=LqDqWslRBhVzNQ9g7dt03C8boeqUnMM7qqhR35gPX/0vKmbVE2vVBVcsDtM5OizVXIlK
	 +pOzJN5j7OP/Smr4HUqClhRSnCX9lPE7AZN0Psqd9PPLyYVq4cEYHtOGJf/ru+OQLzVkU
	 emAWlDBnLuN0KZN2Vvi5vknLyq/LKfWYzlDObE/XYaeyi9mC0d1+H59DnB3Novuy7wh9c
	 ArKar5OUEdTRW6iA8R615x/ZZeBjTZt+ll1i/0c+UYI4b3s0zgK0VFXov/wxplkbE7RPO
	 yPN2PwVUWm6Ytd1VufCy/PdPi+/mx6/aJL1UjNgCcNi3ESdrNQ8XIkhxNQ5qPcBDDrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HuIBRMSi;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBA4606A329;
	Fri, 27 Nov 2026 14:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDBA4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HuIBRMSi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790174;
	bh=Dfv08/N+kF+Mvy690ORsGCHE5ksDbaHpXa/TyHWA4Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuIBRMSiYOs//LyjaWIcWEutvTx7KrC7NdeOncGe2NcY3w1Zk1j4PJD320Dkz0cVN
	 mgcSfiApn5hgICeABSJn2QBP61vvBtc+Gj3ZR76xERQqhuTRSBN7sHnzFUOOZlOR+p
	 jUXkET54R/gMThqDncKpyYrvfcLiRf4J/XzNatbqDo+YSNgnAOsub6iRRv3gOPClLq
	 BU6FK+AIL+7h96gWnVk0xg1Qp2DxQLQi05R7Xjd4XlAks57WiALmjmeRN7ogzwX/xD
	 yeMvRiyLRshm+X3qLfp4++hXMNnP4Tu0wRJTvr9eKDapJQSa9HGdt0cAU3kvmbsU9a
	 4pGrK/8EGLXWw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZQ0PPFzXPH;
	Fri, 27 Nov 2026 09:36:14 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	tommaso.cucinotta@gmail.com,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v12 04/43] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Fri, 27 Nov 2026 09:35:31 -0500
Message-ID: <257df8bcd4ff70527a197a7be6cea3bb9202b01a.1795771147.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting takes the pi_lock of each
deadline task, not its rq lock. A dying task past its 0-lag time
releases its bandwidth at its last schedule. It holds its rq lock there,
not its pi_lock. Then it clears dl_bw. The rebuild can find the task
between the two steps.

In this diagram, T is a deadline task that exits on CPU 0 past its 0-lag
time. bw is its dl_bw. CPU 1 rebuilds the accounting:

  CPU 0 (T)                                  CPU 1 (rebuild)

  do_task_dead(): TASK_DEAD, under pi_lock
  __schedule(): T's rq lock taken
    task_non_contending(T)
      dl_task_release_bw(T)
        total_bw -= bw
        dl_bw_gen recorded
        record cleared
                                             dl_rebuild_rd_accounting()
                                               dl_clear_root_domains()
                                                 dl_bw_gen++
                                                 total_bw reset
                                               dl_add_task_root_domain(T)
                                                 T's pi_lock taken
                                                 dl_bw != 0, dl_bw_gen old
                                                 total_bw += bw
      __dl_clear_params(T): dl_bw = 0

dl_bw_gen does not help, since the release came before the rebuild. The
rebuild would count a bandwidth that nothing releases again. The root
domain would then refuse deadline tasks it has room for, until the next
rebuild.

Fix this with the record of the bandwidth, dl_bw_cpu. The release
clears it under dl_departed_lock, which the walk holds. So leave out a
dead task with no record. A dead task with a record has not reached its
last schedule. The walk counts it as a live task. That schedule then
releases the bandwidth, or puts the task on the departed list. A dead
task on the departed list keeps its bandwidth until its timer, and the
rebuild counts it as before.

This patch completes "sched/deadline: Rebuild the root domains'
accounting from the task list". The walk of that patch finds exiting
tasks, which the cpuset iterator skipped. The fix needs the record
that "sched/deadline: Record the root domain holding a task's
bandwidth" adds. The three go to stable together.

The Sashiko AI review of this series found this window. It also found a
gap in the first version of this fix. That version also left out a task
between TASK_DEAD and its last schedule, with its 0-lag time ahead.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 28fa8f0bc81b..5d065ad27cc2 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3834,6 +3834,17 @@ void dl_add_task_root_domain(struct task_struct *p)
 		if (recorded < 0 || !cpu_active(recorded))
 			goto unlock;
 		cpu = recorded;
+	} else if (READ_ONCE(p->__state) == TASK_DEAD && p->dl.dl_bw_cpu < 0) {
+		/*
+		 * Count nothing for a dead task with no record. Its last
+		 * schedule released the bandwidth under its rq lock, and has
+		 * not cleared dl_bw yet. The release clears the record under
+		 * dl_departed_lock, which this walk holds. A dead task with a
+		 * record has not reached its last schedule. Count it as a
+		 * live task. That schedule then releases what the walk
+		 * counted, or puts the task on the departed list.
+		 */
+		goto unlock;
 	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
-- 
2.47.3

