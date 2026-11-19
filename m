Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105504;
	b=MCfQeZ7k1C1iv7No2ywfEGKIT7JlFq33CmGanlhGtAivDvDJZMvhXPb5r1T8PdJL2u4M
	 2IUnX/1l/q8IUjMIdvNV36sJ70GGx2zTxXvvmX6fe+LIs50Vy++00xsAMsqymFJAEwxRY
	 eAMXDQKdWPN4cZLMx5Xu3h3E097ow8gkieMtXzWjWn57WDD7ZdRcwUC1USxkly5yO1FXt
	 sHSrxCm8SrsFYAf1VxdgOZg8Rxhiz4Mr3bLID3r//aYr8HVEPHCvq9FDPKbZt90Y8/f3z
	 zhE2oXIKitN+fc5mwdGC1mJwQEiOUJ4SpB98Cx7rwdmJ1RuCK5u4b++VyKBJVViUgiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105504;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sYEvR0y/S587RGU4gKT0zwa1IWS1hIurv3wif+IluiY=;
	b=bYdJWvGG9G8Y4CDPZkezO5oyh2IPxAy7lmlmC1zKLMZg4UR0yIY0xJnzIodRan3Jpl8z
	 vBpsYMxTCaLGYK9VbSBJ3OjrUQI6Ms5mUTbHSvEJFgfSL1x3Z+vPCl94pij+80SnLuBwP
	 56OjGTIWky/0VuDMCu0rKbK3YFWcB1rpICPk7kdaPhhI3Idk54rHHCnqmyRCjj3eY++IQ
	 jEVRh5dPMK69NnmvZUqzgOVpSpPdLEVYpkacaaIS04liaNIIldk6N0DsrNQft5E435Ovv
	 45fXvWHoEwJ+hHrE3FNrBFYKd6xKqlzvB7ocudwxFEt72o5Z9rRd96MTK3m+xIW0W/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PFEYjZCG;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AAE606A331;
	Thu, 19 Nov 2026 16:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13AAE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PFEYjZCG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795105502;
	bh=sYEvR0y/S587RGU4gKT0zwa1IWS1hIurv3wif+IluiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFEYjZCG1ThuHNYXlLNPncsXca401/Zsd9C7RBHXkbbhr1ZYcyMc5Lnm5Gt1OD059
	 XEjQUJzHz/DG7/GSJBXoQhkozO4KzIhfPqhBClKJ/Z9S5lAvCHmwR3RMjZfpo7BOKz
	 D87Q0AOKAiJ7V/r7mHVayDpSbQm/cxG1qn7n7c8vB4fkO/W7PGyA3O1NmiD4Kaw+z1
	 NbQXqOmap2rA6IdcEpyg8hFFBjhurILy6+4qNmXXORZG1zIBqDAjr47mV4sFbzFDGy
	 f5MnihDsXCROvl1rRHJrj+qAtw9MUBZWrZ5wkZLaBVpsLtzzy3TUKsTITg3M0wDeky
	 bcxORNsX2ALWw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVkMf26grzS4b;
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
Subject: [RESEND PATCH v4 03/17] sched: Let a task boosted by a deadline waiter change its policy
Date: Thu, 19 Nov 2026 11:24:43 -0500
Message-Id: <32e83abf79c6cebb23193478bdfea27e3525b025.1795105408.git.mathieu.desnoyers@efficios.com>
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

A SCHED_OTHER or SCHED_FIFO task that holds an rt_mutex can be boosted
into the deadline class by a deadline waiter. Then a sched_setattr() or
sched_setscheduler() call on it fails with EBUSY, unless it asks for
SCHED_DEADLINE. sysrq-n would not reset it either.

The admission test runs "if setscheduling to SCHED_DEADLINE (or
changing the parameters of a SCHED_DEADLINE task)", as its comment
says. sched_dl_overflow() then handles three cases, by the task's
policy: the task enters, leaves or stays in SCHED_DEADLINE. But the
call site tests dl_task(p). That tests the priority, so a boosted task
passes it. For such a task and another policy, sched_dl_overflow()
matches no case and returns -1.

Fix this by testing the policy, with task_has_dl_policy(). A boosted
task has no bandwidth of its own to admit or release.

Now sysrq-n can take a boosted task out of the class.
normalize_rt_tasks() calls __sched_setscheduler() without pi, so the
task gets its normal priority. Nothing then drops the boost. At the
unlock, rt_mutex_setprio() sees no change of priority. The pi_se of the
task would keep pointing to the waiter, which can exit. So also drop the
boost in __setscheduler_dl_pi() when the task leaves the class, as
rt_mutex_setprio() does.

The boosted_owner_policy case of deadline_bw_test, added later in this
series, fails with EBUSY on v7.4-rc2. It passes with this series. The
sysrq_boosted_owner case of deadline_switch_test tests the sysrq-n path.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/syscalls.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 6f8ce5fd94a1..cb115aa9b0b3 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -304,6 +304,13 @@ static inline void __setscheduler_dl_pi(int newprio, int policy,
 			scope->flags |= ENQUEUE_REPLENISH;
 		}
 	}
+
+	/*
+	 * Without pi, as from normalize_rt_tasks(), a boosted task can leave
+	 * the class. Drop its boost then, as rt_mutex_setprio() does.
+	 */
+	if (!dl_prio(newprio))
+		p->dl.pi_se = &p->dl;
 }
 #else /* !CONFIG_RT_MUTEXES */
 static inline void __setscheduler_dl_pi(int newprio, int policy,
@@ -691,6 +698,10 @@ int __sched_setscheduler(struct task_struct *p,
 	 * is available. Keep this check last. If a later check failed,
 	 * nothing would give back the bandwidth it reserves.
 	 *
+	 * Test the policy, not the priority. A task boosted into the class
+	 * by priority inheritance has no bandwidth of its own to admit or
+	 * release.
+	 *
 	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
 	 * there is nothing to admit. Such a call changes other attributes,
 	 * such as the utilization clamps. A deadline task does not use its
@@ -699,7 +710,8 @@ int __sched_setscheduler(struct task_struct *p,
 	 * them from the task without a lock.
 	 */
 	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
-	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	    (dl_policy(policy) || task_has_dl_policy(p)) &&
+	    sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

