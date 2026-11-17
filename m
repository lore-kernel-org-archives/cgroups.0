Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924669;
	b=XOv5WxnmPmP7UqgsX/+SDzod0nYqH3SwgbDUVK2+vcMTngd1bASTEn8xdQkGrdjnq82Q
	 RSjr5l6VSso8NQkCB7cCLUyOaF/kCDUkSebDlXTCsLjSJbDaQRqDmlfURgDskrVkw41AW
	 WWAMYC2qucbD8eFNgeDRyso391Y2RDYEW32W1g04Spm0XVvPxoJ/FF4fH9/HYd4Ep3KBt
	 MGoV5m6yoifYSrNintbEm+7XCsgPgIpzBcsCIRZmOE5bcOYD5BWY/U1mP5YdSxOjwMsiO
	 SNEaU3bAvAnbIooo6PPGjNxzz4yscgAlPhIaduzyli2k1zPmhxQAIb+dgB/AAZRVMzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924669;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sYEvR0y/S587RGU4gKT0zwa1IWS1hIurv3wif+IluiY=;
	b=LePbAO3kta0vdywAFykemYEpH6YbRJKkyC8eU3B9tUnvXjCqROILgnt24S4QwewZYeE6
	 LTPdpq2o6IEAGvrv1nsjrZrR4IrkEjxMYmkTcMkRLZ40keEM9k1HRrBIcIvfZD8zbHDBT
	 ruqaRfRWxYJaMTpHGQTd5KbfyH42MDg8H1z2q0bYp8y2R1v3hZtA44sT5+kztSCfrLvNl
	 vVvWdS1az8Wa9hC4mFf7JchCme9OtRD3ScXMB2FRlICeLo45X5xRmJwoO2Vhuarza+aZp
	 tTyr3Nm3m6aplw4WcIdg+gVqQtc19ua5/yxsVIzPaFtaHrRbKDBQS1A1KNpIQjDBlIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="ET30B//a";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF87606A88D;
	Tue, 17 Nov 2026 14:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FF87606A88D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ET30B//a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924664;
	bh=sYEvR0y/S587RGU4gKT0zwa1IWS1hIurv3wif+IluiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ET30B//aODFgRQm8Vbgl7+Cgwx7bPMty5bW0aREb8IupvAYrnkM4VIrTiifPlFPfJ
	 y1dr9iGyWJciIzbOIucDtF9isVNQERVeP1e99oFgXXvvgAhNRqEw03tkgG4gmIF7Pu
	 wHhxWmxF7WZstQ71vKtOC4csmhaSBMeZ2PhSmlwaBO8QXcEaZtEGZC8wlfaF7ilcoT
	 KWcZbypJVSXgDJO9+2Ew3nsuIeQ3XX1RFG89YkJ1OTVXYPfGScnX8blB9pktK5TnWA
	 Cfg3Up/22XEbrdSftxwOLbxa2ilMi9THzky84M8R8ctIvJvHGzDT/WDMeajhemgIuj
	 GHxrksX2VBs6A==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV04sdSzRgp;
	Tue, 17 Nov 2026 09:11:04 -0500 (EST)
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
Subject: [PATCH v7 03/40] sched: Let a task boosted by a deadline waiter change its policy
Date: Tue, 17 Nov 2026 09:10:24 -0500
Message-Id: <5734c5a12c6cee0a459aa772d3edac6eb8a247ec.1794922146.git.mathieu.desnoyers@efficios.com>
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

