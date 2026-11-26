Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655343;
	b=WQL7fkSJAqxUlMEYVdKsgytW1FKwI8VhWIAVj+p4mFsSiJIQ40PY2u3NRuuDm0XvJXXI
	 It67304IGYDP19YuR91AGwjqLZehqeDROJji8+SacO+S0YBSq2HWsG+T/z0mQNZlyCZ96
	 0tccy6KAy8uPmWsDNdQXDyr0K2KzXddi9kqsX4k62TcAf/YfywUdFN/RjV5h0zkmyo1fy
	 dqKWD9vY375UGZXW3WqUV1vGjR+5jWLe77wgv66J5FNVZXkoXqpGra0qhxXFMKzDNG0IV
	 MgPhKjoGaoNrIpdxXfqPe64nzFNfvd3x3m18xsPHigdn1rVfT2lbibjLqC4WN8wWU1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655343;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=H5QhXznND6BTbSk5hUu1eTUy8f5KgP0zL0Nh/RXtERo=;
	b=36QYgkR+IkeZHGT1BfD+1ZACuHoISbkf478M97Apgvc7M26s8LBj3YgMr5QkA+EQA2hw
	 H0Ty6oL5q1wOcI5ZF478eQBdiSJsyBB8/q5ZLDoH1w8m+2UoT3AKvaNztiqNjRXYazq0S
	 Pyg5yBLnJKpqOPK7x+BVcKsEUKOLdXudUyeJW4C7YY94Qn4oRaqRtwh6Zim1t1pW6pyT7
	 jL0nTsixOEAkrXn4/WpXst/asaNZxLcnu4S7mbUggZekmbE3Uv62iKU/8D8nHDA/ruaRr
	 h+gmb5u1yZobmCDJYK5HF19i+qi0VJLXpcjzwjkc608rXyIoNPSIHEIpqhLsASQJC0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=BilemX53;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C3660A5BDD;
	Thu, 26 Nov 2026 01:09:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70C3660A5BDD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=BilemX53
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655342;
	bh=H5QhXznND6BTbSk5hUu1eTUy8f5KgP0zL0Nh/RXtERo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BilemX53sqHfRJtwpi7hKbX0dxwLDIKgvn5HRojXMWRib7iSFYSGpfrkHHMxnGS82
	 DU2h/giwo6kWg4N8T9IhuqPaKHg5pN4nrVq29EJur/H+s7CapH4+KGy46WyAXNZ8y5
	 UVjMsOeERopMTrRayhu1FNkJFyMgrNJuXQiyvhoZsB+uEoNY+dPAHdiw+ecTTwRLhr
	 8Bp+ygMscARvTboQm382fJ4/T1BcKxDOX2V+4eXksvPF0TddwI2KyeEPanrryE7QE2
	 62ZYED7ljIa1Y4FXy0mfJhy1d6tn4RIOTJXBXyy6XIHg6xPfU89foE2MkxjRTo1+RF
	 S6Mx9RlCQadRA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjT6qY9zWp6;
	Wed, 25 Nov 2026 20:09:01 -0500 (EST)
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
Subject: [PATCH v11 19/43] sched/deadline: Count only active CPUs when spreading extra_bw
Date: Wed, 25 Nov 2026 20:08:18 -0500
Message-ID: <8ecd494e3b3a427f2c6a79cfb104c416eb2bb5ef.1795646914.git.mathieu.desnoyers@efficios.com>
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
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index aa35933c0550..347db90e9e9b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1076,7 +1076,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 			dl_b = &src_rq->rd->dl_bw;
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw,
-				 cpumask_weight(src_rq->rd->span));
+				 dl_bw_cpus(cpu_of(src_rq)));
 			raw_spin_unlock(&dl_b->lock);
 		}
 		/*
@@ -1088,7 +1088,7 @@ static struct rq *dl_task_offline_migration(struct rq *rq, struct task_struct *p
 		dl_b = &later_rq->rd->dl_bw;
 		raw_spin_lock(&dl_b->lock);
 		__dl_add(dl_b, p->dl.dl_bw,
-			 cpumask_weight(later_rq->rd->span));
+			 dl_bw_cpus(cpu_of(later_rq)));
 		raw_spin_unlock(&dl_b->lock);
 		dl_record_bw_cpu(&p->dl, later_rq->cpu);
 		p->dl.dl_bw_gen = dl_bw_gen;
@@ -4366,7 +4366,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	dl_b = &rq->rd->dl_bw;
 
 	raw_spin_lock(&dl_b->lock);
-	__dl_add(dl_b, p->dl.dl_bw, cpumask_weight(rq->rd->span));
+	__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
 	raw_spin_unlock(&dl_b->lock);
 	dl_record_bw_cpu(&p->dl, cpu);
 	p->dl.dl_bw_gen = dl_bw_gen;
-- 
2.47.3

