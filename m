Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182961;
	b=i9hVdjGTl5+mptjVThDCx9LlO15x4MgxVlNg8OEjpWANFN9RIbwXDghstUj8TKM3uusB
	 etDtznezMFNbfwY5vPxmaNwrzlgIEzTBjIbTvfSIc3fwkKFCLq4jtKEK3mj6f+HIAEYpS
	 cL7Fvpc+yVWiKybkhUDcOgptKHUAYIfdh7i3XAfeTNdRQWrqDjNlqE91opS/Z4ogHHG95
	 UE307GWA4zaetEakRYb/WvT7iOsMfTSwATg73v9DhbVsa4bF5KzrlVh2GVddJhqWoK0u3
	 xBrUS7SJsMt9Nu6VHQb+VSSoRlup7U7QqqpRdH5H5z3mYmUilgXYT5LzJeZ1lqwwWXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182961;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kzG9Wdif9PHuy2x93nlVn2FFRwpNvtFTyosmqdk5Wlg=;
	b=T4E0txYV6mk5+nMfVU3icURCAgpJCcNNyxzUtJv7JkgYOPEr5dCx3dW67HupyC60BbyL
	 ZLxqXyVtCq1sw1dEsVVae/F3fYZ0vUhQGV1fRt0y3wiLJhs4D/aaD+Dpb6GcOjMkWIJ2w
	 0v/DpKDSgG9351oXoY/m9iHF7kpoNUCxxYe+v6kX4lQJFe+zvdl241FzO6Zmo57QMIzAE
	 9reZrEl6uDm48vrM8YC7I6VCZf4NJxBr1spF/fBcnSGodokd37cQcNbH2SEeQvYxEf2HI
	 ZYKVqYS+jVoJtcdI7mc51lS5tewXrY5Y7DxX4uTG3tivkxHpcIwkT+fr6QYj4fRoSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZjPwpKgr;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964E606A336;
	Fri, 20 Nov 2026 13:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A964E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZjPwpKgr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182959;
	bh=kzG9Wdif9PHuy2x93nlVn2FFRwpNvtFTyosmqdk5Wlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjPwpKgrwTBSLv3PuarOgoSKwbmw2O3xyJjcxVfljX3RHodEGCRL6/GZkdxBVoJoJ
	 /QrBNcJnHX0wZRCnMPuEJGWMUM0NoZ6kzpys7FcvBrfKCn2HqTXbgGqpRlRzyQ74s4
	 ezvj/S9itQv1Hbj0VlNWDjsv7Rvao3g8keYXaAcP+S45Rf/NElzlCTadJMsaxyuzu5
	 EO+2lzoR9NrX8DlEDHx7DjbFr8liDEECQkmZHjAnK5tnZ6uFJLfippjfn96Xi5FKRN
	 Zc/PfmOJxEgiH+nk/ggLYzYfycHTXtAhXwcCHm/WA0BYjdisWnmLAduiu/0fHcxYIg
	 c3GpfsHTgR8Nw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1C6312zTw5;
	Fri, 20 Nov 2026 08:55:59 -0500 (EST)
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
Subject: [PATCH v9 04/33] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Fri, 20 Nov 2026 08:55:27 -0500
Message-Id: <8ebb61eff7b7f2a3d989b45bc82773e28909569e.1795181240.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
References: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
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
index 1d33f63ee9dd..ac686ee1c450 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3819,6 +3819,17 @@ void dl_add_task_root_domain(struct task_struct *p)
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

