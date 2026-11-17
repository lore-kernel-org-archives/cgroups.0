Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924672;
	b=4paqDdW9uqxVzd/6QcaBeR/w1OGPYCLAu7TOQ3zxJivcZch2N8ncKz/HSuTlpJqGsbUl
	 IvdOpJQfBNDaeB2i5JUPHmKUkvdU/W+/Ww213hyYvf118xxLEcCyNFlD3HW7KOiuo+Niy
	 UcAvg/GWKfkHTA6Mtoi0yXCsWqbBAdm6NFKnPk6f7naCQZ5IahagXyJiqvMYAqGtulhF2
	 VR+S7t41zXVZhwgRXhpnyB01yEFppxMHw33KlTuwiCrsdKES54iINXVQEfn4AdShDF4Lo
	 CRy85XhAiVObSVpBW3otHrKSpMvbrr77wxS8DPT+BJSH2c7MO9kR6kSST97fBGfDeHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924672;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lFP7Jb5QnBavccKZP1TiZmt+Fu/KItkai8FCKofUJpE=;
	b=HNUVSLKPtFNh7cA9RkU8DucmGrXDyGu6/5LHYk4f0OXeENe1cXLLy3I3QTv5SDHr1psz
	 1IxRDdal5KkVFcJs84lmQkzbuRO91HZl6f3IAiFDG1fS4jx7oJ8S6iKmTkHiTRN0S6qNZ
	 w6fhOsYKGlUQPHaP19akWLv6wBdSgYnNUehLsWefsD9UsGMsi7kDJn0k4plBS20DmEwQf
	 kCSMtEDDa/i0u5vrEXCrJcRbuCb4O0pxiD2qCKGrXZNfEBA6r57lr8jUUXADJa/BWMJ9x
	 POW5mpr8PXdvHBWHG3E0SqlCvF8/bk9u4H9fFYlFsLv76v8fpzPRcSndxEoDU/KmHiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=gogpd7mf;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31480606A89B;
	Tue, 17 Nov 2026 14:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31480606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=gogpd7mf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924667;
	bh=lFP7Jb5QnBavccKZP1TiZmt+Fu/KItkai8FCKofUJpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gogpd7mf04Jgr7IlyWrr0imevP79mmfNZw/KWYtHGE1dAdz8RkHw2SODVHzWpUPgc
	 MBLwmSAVCT1XVtfVCMittQftpuLkrTfZyNAmJEb7hPhECj3QaDcyFzqIBTs6DAicR4
	 NVJbGl74liPtVmO7Q4t2Js4RcISXBeghAbQcH/hRRjfUZ+I94Nh58VDnB6FjlpdPWB
	 rnoWQZ0ICOyEDGTs8ib0cUNPVZOa8alMeAL2MA3OOWnKR4qu+/iZZL5SgNMQIeBz7t
	 uy2UqE2UuLN+EXfDFAOWp4cqRUfLpsQwY1AJAkGA4HfDZKYFMC5jwzvhRscqp+NS+6
	 pJ/Ik3fM0z6Cg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV35pdZzRTN;
	Tue, 17 Nov 2026 09:11:07 -0500 (EST)
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
Subject: [PATCH v7 19/40] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Tue, 17 Nov 2026 09:10:40 -0500
Message-Id: <f9efeeae47bd95ba9f775750b1ac399e71d1e17f.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

The Sashiko AI review of v2 of this series found this window. Its review
of v4 found a gap in the first version of this fix. That version also
left out a task between TASK_DEAD and its last schedule, with its 0-lag
time ahead.

This patch completes "sched/deadline: Rebuild the root domains'
accounting from the task list". The walk of that patch finds exiting
tasks, which the cpuset iterator skipped. The fix needs the record
that "sched/deadline: Record the root domain holding a task's
bandwidth" adds. The three go to stable together.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 01fbbd02cf8d..779acb9836dc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3787,6 +3787,17 @@ void dl_add_task_root_domain(struct task_struct *p)
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

