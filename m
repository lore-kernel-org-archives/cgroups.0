Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=ytCzKd+wJ1xXcTjVs0INiIJDU9LXpXA3rT52FZOZ5ER5kcPlsxuy4vLYlIYNYjvP3cYi
	 kBjwxHh7jHNqEArzcokqcRDwO8o13ljkZ8Zv4aMM9FagOM097raAloys1VtOA4uls4KSJ
	 02Tk3K8LXdvbVzNbPdk4VMYM9RFePaoaJU5kk2sZPRvbp9IdCvMwWQP4oD5Z881e2QIFT
	 pmPVlnNj+kuBKrJYIeZpTRU80Ot8TBJRkHdov0v1MF38NPqdBKUOLGtEroFxH0X+LGzrZ
	 h62GFBFC2tCeK4gDVdRdKqwxjKoZDsN3W+noqZd1lwRbZHDCL0yEONzI5ZE13rMrgPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fWil3vWwZBjDfrY6/0MxE0VkkOzcUTAcZEwLWrvpsQs=;
	b=ajGcs82451/MPakM+j7IHu55+u2alUk1BY9paQ2WVakrCpp2WTLkEp+oNo5XYV9vC2nn
	 sDLpqod6af4CdlNi+jIbcH6khL7rShA9b7PSMgZeH9G2NqxhzdVvmy9+wdLaazr+pbkMa
	 GiGW6uqdymxDtG+tA2FZNMWG9yoUsK4vS1VuUDFNaAff1yeItB9t2TLZD5Gpre4As5OcF
	 Itkpnf0p5w7RqFWKHPGhCMftdeIuH9p2m3EvDK4IkRi9IHFOyBSXEgESbsScFvHf4ZNEh
	 zPsmDQ0iVcXZQosFOebxnMPNECtPLQUbbhJ0LV0876Kn0egawC5Wmk+GxPsRQdQLE/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=q3ReVCTB;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4121E60A5BC7;
	Thu, 19 Nov 2026 20:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4121E60A5BC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=q3ReVCTB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119381;
	bh=fWil3vWwZBjDfrY6/0MxE0VkkOzcUTAcZEwLWrvpsQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3ReVCTBkotlUimbIB6soUJJNuFmqCQqPIHG6+xPfBf6ks1fEt0Ws+offPHcHJpUx
	 Uictm10NmrUKuFk6qAWGxYtMMhvdB+qeBE/XPnfB1tFRdsoIQnnT3OOuZNTdZwkMSw
	 1gv2nQimY0xikcWKuN7ftiqOFEyG4wBGPS+DCRdO2O10HEdIHuDERK/Tv9d/GswAHm
	 pQU0zNmiuXH6UCX4HFByPvIcGV36Ot2oxCwLxZ0n5UmdHdNtY0UVCwYg2v1qit8UNz
	 ZuwR6vanV/XVE6n8HgP3CUv/R+CN1udBYmmcaUiXWdA4NCKhqxCSeJF9QZ/2rXEhgF
	 zfEBKA1l25wog==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVY02W0zT9f;
	Thu, 19 Nov 2026 15:16:21 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v8 19/33] sched/deadline: Count only active CPUs when spreading extra_bw
Date: Thu, 19 Nov 2026 15:15:58 -0500
Message-Id: <d130b4060adc4715da93ad5d3dcd9b00bfa8fc11.1795116791.git.mathieu.desnoyers@efficios.com>
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

__dl_add() and __dl_sub() change the total_bw of a root domain. They
also spread the change over the extra_bw of its CPUs, which GRUB uses
for SCHED_FLAG_RECLAIM tasks. __dl_update() changes only the active
CPUs, so the cpus argument must count those. Most callers pass
dl_bw_cpus(), which does.

dl_task_offline_migration() and dl_add_task_root_domain() pass
cpumask_weight(rd->span) instead. That also counts the inactive CPUs of
the span. A span holds one while that CPU goes offline, which is when
dl_task_offline_migration() runs. Each active CPU then gets a smaller
share of the change than it should. A later change made with
dl_bw_cpus() does not undo it exactly. extra_bw stays off until the
next rebuild of the root domains resets it. SCHED_FLAG_RECLAIM tasks
would reclaim a little more or less than their share meanwhile. This
was found by reading.

Fix this by passing dl_bw_cpus() of the CPU whose root domain changes.

Fixes: 59d06cea1198 ("sched/deadline: Fix bandwidth accounting at all levels after offline migration")
Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 641674f65931..914915abb912 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1016,7 +1016,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			dl_b = &src_rq->rd->dl_bw;
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw,
-				 cpumask_weight(src_rq->rd->span));
+				 dl_bw_cpus(cpu_of(src_rq)));
 			raw_spin_unlock(&dl_b->lock);
 		}
 		/*
@@ -1028,7 +1028,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 		dl_b = &later_rq->rd->dl_bw;
 		raw_spin_lock(&dl_b->lock);
 		__dl_add(dl_b, p->dl.dl_bw,
-			 cpumask_weight(later_rq->rd->span));
+			 dl_bw_cpus(cpu_of(later_rq)));
 		raw_spin_unlock(&dl_b->lock);
 		p->dl.dl_bw_cpu = later_rq->cpu;
 		p->dl.dl_bw_gen = dl_bw_gen;
@@ -4217,7 +4217,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	dl_b = &rq->rd->dl_bw;
 
 	raw_spin_lock(&dl_b->lock);
-	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
+	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
 	raw_spin_unlock(&dl_b->lock);
 	p->dl.dl_bw_cpu = cpu;
 	p->dl.dl_bw_gen = dl_bw_gen;
-- 
2.47.3

