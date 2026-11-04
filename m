Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826738;
	b=ct+7dW+M1LxsdUbyeHQ0rXMseqffucT8+ni8ACqRP+Zqzv8RKY5NxiS7eFEAwOKtLSBO
	 ABL89sZXQB/QoT5DH8XZpVfJzzb9BU5v2WhJ284Udnem8EMpOZYxJTw+v0Hq7xnZ+l5/e
	 F/8EkhjbiE8SXLf6AExeB9YTvlBPkCweWwh5wmaQVxWt9CaN5QOANAPMnjol77lZCDI5j
	 6H3Nh0vZ4WQlA7vZ6bbMzRhSbvd8Yp23OQ6j8vycHeuyNeBrd8ERdJ0NGtK18MDOoRrv9
	 XFnUQ4BqoHOZcSPJli1wUD0BlvLqRztR75Q74I7jBXxSCQ9C7cx634Q8BnHKyK30BqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826738;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W1mKRs0LM9yM85rfKo7VsdleSmQP3VzwQ3CUf1XJXIk=;
	b=ApV16va+YTm0PmjzmNBIHaLOtBW/bBC9Ab39r4qvWYV3Xw8gH9brzCWmrxmXE4T/qYIy
	 iYXReo6O4Td8dnWFRkY8U8mDt35HirZp2Lfatnfmk/V6FCAEgfWuQkyAD1+8ITDZN2wlG
	 jw8nzJ6y3DC75g4ew6FpKQEq4oNZeVYu9ab8Zl8LtiHsAm56Jk9T3PF+2emTzjxS1w6gv
	 fzwargd0rwZLPYpGQ4ajMTxdO65I0qifrfikg3zXPAgkAiFR4dM5UcUE0VORSft1JIvoL
	 E56d0yhDa4+hfgzV6luC8PnolQREIqdnv78/Wylsmi9Wwbgt6PYmtIfkINzPapBqsPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Sk+ugbGV;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5789C608419B;
	Wed,  4 Nov 2026 21:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5789C608419B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Sk+ugbGV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826735;
	bh=W1mKRs0LM9yM85rfKo7VsdleSmQP3VzwQ3CUf1XJXIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk+ugbGVT0BS6DCf/K6hOowud2RHNADFYTfQ+SWI9w5t7rdLAACSFCrTeu7YEU6gJ
	 +hsuCXLJaODG0aL0Dfa7CsSYZEyp67xpEWmgMIhT6WwCLksfR0SZ1qNxLcSPS72Pov
	 +ZaeK080Fe41xBAYwfeCdJC96yYiX9qg53GiZKbA4cYdUmuovyuMRLJQnCNSnXN69/
	 8+EYhTteiHhV+Kcy7Eu2smuSDK0GyuV/uPIpxmvUSxNZnpTg6BGTpJl6IoMfmGX/Wi
	 ShVknVes3urDtKsVVKEB9HPoZotirjEOHx7oxX15KXFBrkQiqYkydn5eqiuw1Cm3LT
	 k9bdcAfEMcjoQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRz4cfBzLXj;
	Wed, 04 Nov 2026 16:12:15 -0500 (EST)
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
Subject: [PATCH v2 19/21] sched: Clear cpuset_locked where the policy check retries
Date: Wed,  4 Nov 2026 16:12:05 -0500
Message-Id: <20261104211207.1392343-20-mathieu.desnoyers@efficios.com>
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

The retry of the policy check in __sched_setscheduler() drops
cpuset_mutex and leaves cpuset_locked saying it is held:

	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
		policy = oldpolicy = -1;
		task_rq_unlock(rq, p, &rf);
		if (cpuset_locked) {
			dl_accounting_unlock();
			cpuset_unlock();
		}
		goto recheck;
	}

sched_setparam(), and sched_setattr() with SCHED_FLAG_KEEP_POLICY, take
the policy they check from the task with no lock held, and take
cpuset_mutex for a task of SCHED_DEADLINE. A switch of that task out of
the class meanwhile makes the check retry; the second pass finds no
deadline policy to take the lock for, and the exit path unlocks a
cpuset_mutex that belongs to whoever holds it by then.
dl_accounting_mutex, added earlier in this series, goes the same way.
CONFIG_DEBUG_MUTEXES reports the unlock of a mutex the task does not
own.

Clear the flag with the lock.

Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b1fc4fadd689..d541f4fc7252 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -654,6 +654,7 @@ int __sched_setscheduler(struct task_struct *p,
 		if (cpuset_locked) {
 			dl_accounting_unlock();
 			cpuset_unlock();
+			cpuset_locked = false;
 		}
 		goto recheck;
 	}
-- 
2.47.3

