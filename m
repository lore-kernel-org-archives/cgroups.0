Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655339;
	b=LMp0Z5tdKizK6HXSyOa/j7wEFcFRCxja2/zH2O3XGQCHjx4XZWFzyeaFLgLh4dPh1pwE
	 dVibDoc4MpRaDVCTEn9SKVwlC7ROd9z61MxYNrH5mvaleDTb2yYuOGjzsSLMWnWJDIybz
	 jlVjjNqDYsO7aLCkt/DTVhHS8lfk5YJL16UKWNXtoOxus2nfWFkmr7ZYbSfzuRQKF6zpR
	 WQ2nf95nNP/YLPLleaQ3pBBsaIpghq29qUCH5pZFZL4ZF4FYdnGqvQ4hmozu6OGU38ODD
	 lhogTJTpRF6ofKAq7ZDSxMu9vz5sCNVKTuV51GSoKntB5Pwm2KRchAV4RUaR0ZeHbnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655339;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Dfv08/N+kF+Mvy690ORsGCHE5ksDbaHpXa/TyHWA4Dw=;
	b=j+s8lcNCKMN79ZpWVme4j/+OI/99Yqo5/8SZ1s0Dm4i2lRbJRO+YrYpy/WkkvK18jWVo
	 1YgnR5DbIfKz5gph6DNTVPa3pS/fG4NHCIf9351m00o51j1haLk/mXyag2SVDX+RfoNkj
	 WIxnGSBEvx1HodIH9NoGtxBz8ih42e/t5bfLgWauYN+VbQ09tzXIilXa3XKybGcPcreaS
	 nctC1DnUsjgNyW00pGZvLcmvfRW0DZsRnHsqcpH9IXIc/6DirGWOsSzhZLc31IlFQEP6F
	 sG7KojYhqffcYXUnV+Uv22YMA8Hq2T5tC2d8dEnL69YrEMJZtRX2YkeAcqu/FWbtDbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=A2FCa8z5;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684B606A335;
	Thu, 26 Nov 2026 01:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9684B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=A2FCa8z5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655331;
	bh=Dfv08/N+kF+Mvy690ORsGCHE5ksDbaHpXa/TyHWA4Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2FCa8z5tCpzOQeQJJDl6UhDqmCU/RBoTtE9aM40y2GpfNwhQ3toRC5lz0/5CBNV+
	 0F5Lir6M85uxevWfMLHDYukveHG4E1DAuZ8WTHGjDSWF/5DZoFAEuTPVBRW90Ku0pc
	 Wfp+68AwPs7Ymxlv/ki/VMfxgUyXpUnEI7mrWQSLxOayWyQRflUxcom5zHNGM2Cnro
	 YEjceuM7IUGC6WhXdBnYc2IgH473nCy76xYhl9GugwDkubKLmXTelc21SGIwsMy9NC
	 CkrnmLJS5AuitpDUbvGBOTRBxDseQOZnDZE9VM55DiUcxFh+2JvlusX7+dVGy9m1iF
	 0PQ4/fnSe+9kw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjH31dKzW9r;
	Wed, 25 Nov 2026 20:08:51 -0500 (EST)
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
Subject: [PATCH v11 04/43] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Wed, 25 Nov 2026 20:08:03 -0500
Message-ID: <257df8bcd4ff70527a197a7be6cea3bb9202b01a.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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

