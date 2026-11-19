Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119386;
	b=diaRgU7pExr2Mz6/ENWrf3IsQkv90gSd3jX2I2nITaAacqDb9X8Mw0wJ++ryV30MQrCJ
	 Dg108yQjUqljw4AGXevGqGRTlQ9qfE7FVvSxHxksxq0uWrHIIkqPDKC86HFnYR6myMb/2
	 YobsVqcOdoTdMPMOG7yYbvySj1TjOzRjB7nQ9uuEXSiRs6K2BM2+Zm8d10emtKE8xmuQo
	 Lg+B+yCTIceuGrW/EVYmJZJAU3qxXqbg348GO7EZCbxQ/8rUMtVWZC7sKQyUXObj3l6KL
	 g5a1XNzw3ZTvcheHEd59/wVPqqMAkSToTDlva4nRnK/3iY7Wbv/Ab1z0xP+AOYMowtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119386;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1niHJE8KpaB+3FD8FFzW+KdbDjOVqnK04qvj+tdDC20=;
	b=BkJEgv1lTQfiNTQd+U4fi+7THpwCBSsVC0APsl+0mZ+MLAF5ZSSCWvUy0xSpuPSyHkw4
	 hjdaa4EPc4hTe3l9QQEbyNmmU3OujnNaKTCs1J1VrYQ5GR34PqEmICr2CnZkqRiSHctid
	 TssaNKpGqiK/zEGsBmRwc3L4hgOAslW7lP9FFFhmh7WfpWt69JxdF1he9t1uk5E4kyxCA
	 OO4/yctHKU6A2qDwtoMqVQUuMFYllWiyNmsnFij4kMPzFkn0ocltjIT2BE0dVCMaSnCNo
	 b7MoVfSFps5Hb4VPc+rXR/ERmf0VZe59iAO+vPrF58yXf+rnqQh0bsKDZPkCdgBn94g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LI3fwdT4;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962D606A32A;
	Thu, 19 Nov 2026 20:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9962D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LI3fwdT4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119378;
	bh=1niHJE8KpaB+3FD8FFzW+KdbDjOVqnK04qvj+tdDC20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LI3fwdT4LwVCSle3OmwTB/1ocHOPl/kTTGE5PMZsOPdCuQrKJIBzBmvP+iKcU/HUD
	 D9IIEoID2ojmJ36lCmmI+aV3/5ft8rQwzSY/J5Xxkvn9x85v9XDmVhDMcNpww4ZvCw
	 1rq2bHU0l1nnH9OWpr1IXkeCsBkaWOhNh0fXuVXv01cUSNqzIsaJgGgMf/uNTsOS3H
	 ioAzumBKO6dMoQzejviHRL5TG9sYiiRjY5m4ya3RK6P631PTC8Qzxs5bZpsgwgPf1n
	 ui++MLJLYToBHf0OTylKAB2KxtiGjDnPfgHykP3EMMR3yrZ2cdoXSoHedicf4ImDr7
	 a461op0b575nA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVV20KrzTsF;
	Thu, 19 Nov 2026 15:16:18 -0500 (EST)
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
Subject: [PATCH v8 04/33] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Thu, 19 Nov 2026 15:15:43 -0500
Message-Id: <9dad2be2f8c85b6f5e6dc758cb4b2cbc47ba4a95.1795116790.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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
index 5a8f38632e54..40d87cd31d33 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3777,6 +3777,17 @@ void dl_add_task_root_domain(struct task_struct *p)
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

