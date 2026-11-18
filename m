Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032412;
	b=0OwsXvdsGOjJEtr+tkB0MQVK7rN77h1SX88hYDcgpRvfezf3Fotab3NHcMgSJT0kwuqc
	 6iaTc6pepf2wHl29WBZNrcL5OvOi8mUdLicbT4dV2qKfMQadMaIxYRD5OZBocqN5GLQ0h
	 q6d8qRa+fQD+bAO+9JVbCgWe0MQulPHMm7cTV+njaoU4SW5SgRJDYd+0HmbuH0tV1Gti1
	 RYDmu16vsiBNLTbhk9aVTHF2Rq2AmI77Mq9GqJhBNSyvl5IQOwPHBrKutCJSmn5ikM96h
	 oC1CG+DOmbM1cnLMDdYez5pateFwN8TVeK9YdFMRiC9tV/7NiBWNifOvecEWLnZx70A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032412;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hjTYAqi/gpMkX55Y0igyLpnABuy/mfhM7aTE6x5O19I=;
	b=zeY6x7HW+6WI8KbHKctpw/Vb8gdtuYeMyx6LDtmv09oKmUrBc0gvfuk9lplzoOIPjcQD
	 xsSmxvhK8y+txzP9jgwjr1vJk4y7tmh93LgxjUzKqVA0VRztTW30JPJCfPA4F8yu4QdiS
	 Bt6EQQ19l3njL2IibdhPH7pJxr31I002gThv4oNkgwhtaNXFNP6IcffsFVycjyDOY4dG2
	 Gefp63u7L0yepBVzyAcGd/G4kELKgFRsRNKH2nTijlpIXc30A1MxZYXb1cxNo5Tgt7G5D
	 7LDfjTXaeB5Qo+2lofaQ5sNUDTPltYrHOYUCLuutjldM4ksfj2wBNeoL+evIEFhBxRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Dz1xEwdE;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3270260A380C;
	Wed, 18 Nov 2026 20:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3270260A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Dz1xEwdE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032405;
	bh=hjTYAqi/gpMkX55Y0igyLpnABuy/mfhM7aTE6x5O19I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz1xEwdEGPu5BKm87rISbIOB0UeuA5dCYW/Xe7hefx3HxojAZJVcOnHagDKZmbuiP
	 3uLYj8HJczStJkkk82f11enmL3ALgNYZ0geklKuYbe29u1oCaS8UcE2Y0D82FaWVRD
	 wjzfKjZG9LFD1GG9FWj4gKSmpv8Dt/jQt4oM4WffXpFiVhG+ldOugnDtIwolWajX9r
	 OYREJhH5yfyylNJ1xfDgjieGu6NDdi2rNw0DL4g8C4Fyb6TvNjNE+G9o6Y7Qac+D/7
	 TuehWbyBdcfGYz9FIVxnApoz+w6k6dXwYRIA5nJHgBtkmWWJVm2eJVxoUKyEWOlWch
	 EGxmsGWG5QxOA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKx49shzRpg;
	Wed, 18 Nov 2026 15:06:45 -0500 (EST)
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
Subject: [PATCH 11/16] sched/deadline: Reject SCHED_DEADLINE on exited tasks
Date: Wed, 18 Nov 2026 15:06:36 -0500
Message-Id: <3f5d0beb852a58150b446567b50d35098b8c9380.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
References: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
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

From: Juri Lelli <juri.lelli@redhat.com>

sched_setattr(SCHED_DEADLINE) on a zombie task succeeds and charges
total_bw via sched_dl_overflow(), but the task has already done its
final schedule() and will never run again. Nothing releases the reserved
bandwidth. Repeating this fills total_bw to the admission cap, after
which sched_setattr(SCHED_DEADLINE) and CPU offline fail with -EBUSY.

Reject sched_setattr(SCHED_DEADLINE) on exited tasks with -ESRCH.

A task of the class that exited, switched to another policy, runs
switched_from_dl(), which decrements the count of deadline tasks of its
cpuset that cgroup_task_dead() decremented already: at 0 with a deadline
task left in it, the cpuset is skipped by the next rebuild of the root
domains' accounting, and that task's bandwidth with it. Reject that as
well. The deadline_bw_test selftest added later in this series has the
case, death_zombie_switched: on v7.4-rc1 the switch is accepted, and
the one-CPU partition root the zombie ran in admits 9 tasks of 10% after
a rebuild, with a task of 30% still in it, where 6 are due.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Reported-by: Weiheng Qiu <weihengqiuu@gmail.com>
Closes: https://lore.kernel.org/all/3f6e6c87-645b-45fd-8fc6-8da5bc5b82d8@gmail.com/
Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-4-dd761fe005b4@redhat.com/
Cc: stable@vger.kernel.org
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
[mathieu: reject a task of the class leaving it too, found by the
 Sashiko AI review of the patch]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 9b04e77297ae..b87b878be63f 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -592,6 +592,19 @@ int __sched_setscheduler(struct task_struct *p,
 	if (retval)
 		goto unlock;
 
+	/*
+	 * Reject SCHED_DEADLINE on exited tasks. A zombie will never be
+	 * scheduled again, so sched_dl_overflow() would charge total_bw
+	 * that nothing will ever release. And reject a change of policy of
+	 * one in the class: cgroup_task_dead() took it off the count of
+	 * deadline tasks of its cpuset, which switched_from_dl() would
+	 * decrement a second time.
+	 */
+	if ((dl_policy(policy) || dl_task(p)) && p->exit_state) {
+		retval = -ESRCH;
+		goto unlock;
+	}
+
 	/*
 	 * If not changing anything there's no need to proceed further,
 	 * but store a possible modification of reset_on_fork.
-- 
2.47.3

