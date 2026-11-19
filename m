Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105504;
	b=sf5iDbNFcL1P906fsoMKoloNcCEXQbHejB43gCIxGACg5l7kvcXKIWJdIHGy5nBFlx0I
	 sAR4DOefkY8hd7CwuPrGZvcbhvQLX3iVn5j4DTy28z5ygIB9Izz7a+6qSIVL5h9QBQ+L7
	 jQSYwN6dVPVY3854DIYZ/QCBJImYzHhd/0sLOey3cG+Gu/2VA1/cW6eSCFRFb9CiuagJK
	 htErdKpC9H3yPz7WLjMiCcM1s6pPyGYRJyXhkuB6hPz/HoDNsjHSjfehw/n2a+J5Eo1GS
	 taASPt3NDtTsHA8nkCudBHILECUXqlk+zFvOvoC+vHA8m6+MJ4tZlDvXEkHWPOU/kPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105504;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BhOtU90QChI4MV+CFuZYuouzsBkSjlKgdR13L9qHB5s=;
	b=Nac99f366318Sg1cyMbKZ7uopLkZHOW3ouNKpzIgc9TlENWG7acNhW4fcYlRbo3uvM4t
	 50FdMGxJ+XNpwOsG/1vQQjDRDiwgjPHZpN2JfX9i6hVV2oezqCIgpfGK3bQUvCtPJo/Q4
	 DWH/lsi9WhHPJVKLS1hftlvCMttpeKsWj8RwD3L2QJx8afsBiMx2yj+0ZX4G9RZMtPHMk
	 JXH5I2hGdIRXYZ6+30jo7b1BXhuehF/QhNnvFJKnDRPkYMIxKIxdT0WWtgSZWKs+JZuWo
	 J5thEfKHEMiF4/oq/06k2+k/lses+v3HYDcun4qX0BwZlHreh/IF6DzOKMmvAR1Jnkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qiaoeT5Z;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB0660A2619;
	Thu, 19 Nov 2026 16:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AB0660A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=qiaoeT5Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795105502;
	bh=BhOtU90QChI4MV+CFuZYuouzsBkSjlKgdR13L9qHB5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiaoeT5ZoBR2oL02AEHI+G6cpfBog4FVRRB1hHCoeq/4iY75m2Dk/BfCTmd9Sg5XG
	 T6nNcGwa3JYPd0iIgw+sczKjvxFnF4bS0UsHVVVSLSG8QHUD9Qv4iJXlBvObv/jFoW
	 ljEp/kBShBx4ujwmdmyPvgKjEgFjEUqxN7lNvzNH9XuHNcMF8k90TMO9ok6jnmijWM
	 9V5yFwX71FvVgkNM+z/lbuEIxqMSQWqO8DZKDNksqSvdsnHJT6e0fL0/Fljk1ue/SZ
	 cg1rYujp53J6CMyLION5/g/SXeoiwMyveFya94eR6cFn6c+pvU+BbW7BHoNsIUZRF1
	 x9rS7KRCmopug==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVkMf5sqvzTnJ;
	Thu, 19 Nov 2026 11:25:02 -0500 (EST)
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
Subject: [RESEND PATCH v4 06/17] sched: Take cpuset_mutex for a deadline policy change only with pi
Date: Thu, 19 Nov 2026 11:24:46 -0500
Message-Id: <9194486f15bb0cb36b51e4525f471d1150c0d58b.1795105408.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
References: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() takes cpuset_mutex for a change that involves
SCHED_DEADLINE. On success, it releases it only when pi is set.
normalize_rt_tasks(), for sysrq-n, is the one caller with pi unset. It
runs under read_lock(&tasklist_lock). So sysrq-n takes the mutex in
atomic context for a deadline task, and never releases it. Every later
change that involves SCHED_DEADLINE then blocks forever.

Commit 710da3c8ea7d ("sched/core: Prevent race condition between cpuset
and __sched_setscheduler()") took the cpuset lock only when pi is set.
normalize_rt_tasks() cannot take it under tasklist_lock. Its changelog
accepts this: after sysrq-n, the deadline guarantees are gone anyway.
Commit 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex") then took
the mutex only for deadline tasks. It replaced the pi test by a policy
test, and left the release under pi.

Fix this by taking the mutex for a deadline change only when pi is
set.

The policy test reads p->policy before the runqueue lock. It is checked
again under the lock only when the caller gave no policy. Otherwise,
the task can enter SCHED_DEADLINE in between. The call then takes it
out of the class without the mutex. A rebuild of the root domain
accounting could run at the same time. So check again under the
runqueue lock, and retry with the mutex.

sysrq-n on v7.4-rc2, with a deadline task and lockdep on:

  sysrq: Nice All RT Tasks
  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4356, name: deadline_switch
  locks held by deadline_switch/4356: 4, on CPU#3:
   ...
   #3: ffffffff83006098 (tasklist_lock){.+.+}-{3:3}, at: normalize_rt_tasks+0x34/0x150

A sched_setattr(SCHED_DEADLINE) after it never returned, in 8 VMs of 8.
The sysrq_normalize case of deadline_switch_test, added later in this
series, tests this with DEADLINE_TEST_SYSRQ=1. It passes with this
series.

Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/syscalls.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index cb115aa9b0b3..9b04e77297ae 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -561,9 +561,11 @@ int __sched_setscheduler(struct task_struct *p,
 
 	/*
 	 * SCHED_DEADLINE bandwidth accounting relies on stable cpusets
-	 * information.
+	 * information. Do not take cpuset_mutex when pi is unset: the
+	 * caller is normalize_rt_tasks(), which holds tasklist_lock and
+	 * cannot sleep.
 	 */
-	if (dl_policy(policy) || dl_policy(p->policy)) {
+	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
 		cpuset_lock();
 	}
@@ -643,7 +645,13 @@ int __sched_setscheduler(struct task_struct *p,
 		}
 	}
 
-	/* Re-check policy now with rq lock held: */
+	/*
+	 * The caller gave no policy (SETPARAM_POLICY): the request was
+	 * derived from an unlocked read of p->policy above. If the task
+	 * changed policy since, re-derive the request from scratch, and
+	 * release cpuset_mutex: the re-derived request re-decides whether
+	 * it is needed.
+	 */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
@@ -654,6 +662,18 @@ int __sched_setscheduler(struct task_struct *p,
 		goto recheck;
 	}
 
+	/*
+	 * The caller gave an explicit policy, so the request needs no
+	 * re-derivation (oldpolicy is -1 above). But the decision to
+	 * take cpuset_mutex used the same unlocked read: the task
+	 * entered SCHED_DEADLINE since, and the change below would take
+	 * it out of the class. Retry to take the mutex.
+	 */
+	if (unlikely(pi && !cpuset_locked && task_has_dl_policy(p))) {
+		task_rq_unlock(rq, p, &rf);
+		goto recheck;
+	}
+
 	oldprio = p->prio;
 
 	newprio = __normal_prio(policy, attr->sched_priority, attr->sched_nice);
-- 
2.47.3

