Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826734;
	b=JCVjnTjRfn2uHyKyPpB5www/ggyIZrExxkuHMuKmWnQecjFYcupeDiOCCpt1gdYE6Vrn
	 4/qdn2U1UuIDxW7zCxmlWiLfWCAvuJKwlpPWSCmI6EfiVQKEWYDpR4MqqHzikkDZ0+dIr
	 nZqWzoOYrT2ETkxtkixeCXMKPC9nNwtQkKCr4JG4FWS618OO/i5ya6M/Vy+QmMb0jR/Cw
	 JLQ9xG2zQA/hF6SVkAqfyHq7QSiYDAEW5zUvkBronydRswlR35ZELk3GMr2Sk4PQkf2qq
	 OF+es73M6mOsj4FTt4HpV98s65GK8+0rxep+6Eces4taKnH1p03MBMnNBwhONJvkHxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826734;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JFjXz+DM4ofvkk2EmcoTPHQH7AEhGNy+pLKqdHTFcPQ=;
	b=Z6D3dY9AdwoIPqQFHK+eOG9AGtkRUhUvFurUBhlBtCmPHUEZVXvgH72M6gyQ3fd0q8uk
	 qVV56mOjbT1BNWUe85qVH7i99I3OHzP0+zbngcykbx0y3MQIDzFkzV/nGkXVFRvFMDLbd
	 jUcseg9cDYg8r9OwE++7vbLwbgUGPEMro3knv0Wc/HyaikH/yX6dp7qNIjvOuw4C0uOsE
	 +XOZrgGQw0q2I2B9b+O3kXaMWapepla7cTJ+5q056QJOfv8G881rePa8QEE97Uyw0lOJE
	 S9he9VV5vQdxBn8+mBps8xbMmojPcP9dhhJKOrLtd8ffivXrVKIINBB/bkp0+9BgI4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=otqzSyQM;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD160807BC;
	Wed,  4 Nov 2026 21:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ABD160807BC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=otqzSyQM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826732;
	bh=JFjXz+DM4ofvkk2EmcoTPHQH7AEhGNy+pLKqdHTFcPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otqzSyQMKqpnnLHGpSDU7oEOEL+HANFaa2pQ6RfXyo4VRmtnPdO7+V02NQW6v2o7e
	 EUb6jP8wMfwZ67KTfTosnxm9v3U63CxNa3l4W+px9QC0grtQH4bxR2szOQhF7W1LW2
	 oekEP3cgXpf5BYRyPSCyMmVVL51a9pdjPzHmxgcloEjFURwYL78vYnDlI2fERIZJmu
	 3HK4cAryC25/LKxQ2setbzEA+Hrq4gqLL6Vn0L6EYWFcShXIzuDPy62c5gKny9sPa4
	 oAW1p1G8wDqQFoPt4N15dwA5RzUNUSu6Y5/PusqslDvzytrsWsDs+Z0BAEOrlnJ20W
	 krMyV1IJiD6YQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRw4YfKzLcZ;
	Wed, 04 Nov 2026 16:12:12 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v2 01/21] sched: Reject SCHED_FLAG_KEEP_PARAMS before reserving deadline bandwidth
Date: Wed,  4 Nov 2026 16:11:47 -0500
Message-Id: <20261104211207.1392343-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() returns -EINVAL for a SCHED_FLAG_KEEP_PARAMS
request that would change scheduling class, after sched_dl_overflow()
has reserved the bandwidth of the request, and nothing gives it back.
Switching a SCHED_OTHER task to SCHED_DEADLINE that way fails and leaks
the runtime that sched_setattr() filled in from the task's slice, up to
100ms with a custom one, into the root domain's total_bw. Repeated, it
makes the root domain refuse every deadline task, and refuse to offline
its last CPU.

Reserve the bandwidth after that check, last of the checks. A refused
request also leaves sched_reset_on_fork as it was again.

Fixes: 8a70415351ba ("sched: Reject SCHED_FLAG_KEEP_PARAMS when it would change scheduling class")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 3fa447aabe7f..f0b7b2d52614 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -655,17 +655,6 @@ int __sched_setscheduler(struct task_struct *p,
 		goto recheck;
 	}
 
-	/*
-	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
-	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
-	 * is available.
-	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
-		retval = -EBUSY;
-		goto unlock;
-	}
-
-	p->sched_reset_on_fork = reset_on_fork;
 	oldprio = p->prio;
 
 	newprio = __normal_prio(policy, attr->sched_priority, attr->sched_nice);
@@ -699,6 +688,19 @@ int __sched_setscheduler(struct task_struct *p,
 		queue_flags |= DEQUEUE_CLASS;
 	}
 
+	/*
+	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
+	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
+	 * is available. Last of the checks: nothing gives back the
+	 * bandwidth it reserves.
+	 */
+	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+		retval = -EBUSY;
+		goto unlock;
+	}
+
+	p->sched_reset_on_fork = reset_on_fork;
+
 	scx_prepare_setscheduler(p, policy);
 
 	scoped_guard (sched_change, p, queue_flags) {
-- 
2.47.3

