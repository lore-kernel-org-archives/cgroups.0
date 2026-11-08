Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164063;
	b=poGQoCQ/GV48Jd6TWGDezr8iny4/kehtkueOahNtB6viJn3xCqvL3SIqntfshKvmWKql
	 5CLoLIEU8dpNIlhleFhitt5oUwaJV8chgrrUmw8UMEtXLJQX2J2OCbXS9TsOY1mcZHRNk
	 GnGusGalZoAiSP4EoGDMqlWxf+3129r2URRPiswG35PrndlD0kTSAtHSjDUvQMWabx4Z1
	 SyJZHGVppv3Ga5vr2afs1p4fs2HqIfL26xGiGeq3W2xcQohHKQlVJaKcbayiKISvGzu8Q
	 wLiXd+x1MXXAAgQPNg52SZYd9k4x+TkliniBJXHTcvKvHhfLPywbEAGadVifCH1qzRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164063;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ipDXJ/+b/pjA4wENTBw6Dus30xb7+TjZTpQhY7T/2qE=;
	b=L8aBAXkS5ExMBrIsKuqhLHX8psjoWw5nIVz2O4ygHSz8weFgH0ECt+Uvahyj1ncrPSR/
	 xjmQK7l0wha90LQC3gh7quVfS/9mwKfvKKOH2cGkuXl+Ak6VTWppDCGZgCu8F16RT6NNs
	 MjawVCiDK88YET+ZYqlNgkL2PZeAg8SiGdojneBIrSkxyLiWwY3chjQUMyBG9oD9oJjWi
	 gFJQfY4XXsn89SxrqX3xgVC+WQN5AKKO0Xbc9aWJ7Odq1Ok/R9+P1Py2WSH4QAF0WwH2a
	 K2id38c6li+1ykc+BuSDq/R18pZBsY2AoMWgCZg0Pna3PLZBxuOHxESlPigT+8W+z4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xQZGXht1;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C0606EE9A;
	Sun,  8 Nov 2026 18:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 547C0606EE9A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xQZGXht1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164061;
	bh=ipDXJ/+b/pjA4wENTBw6Dus30xb7+TjZTpQhY7T/2qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQZGXht1ucKMUlZfd4p7V+2pLMpiz0I/Be72r+z4OX7LAatH3L3K9Crv+6izPNk4J
	 kAGqJbZiRrZjhL791ePITEUF4t8CRg6UlUYzLjHTT9KrZ3K2HWRZqs25NAKJy4VXg0
	 N1f3FvmwAVrCdu87AZ50tMV9Tfe7J1WtHX1bANCqAchPRlML81z4HleQMfu4nv0oyQ
	 V10LYXBOaRFJwlxI8WGtnDEmN1G5BMGqtSHm9q7XfvPUZk5b1eSqNuDolUS291nUKs
	 AFjM72qVdZaGmcFhZwVxa1bSfEuukxCwYNFZ3AiqfZB42ls7WTBwlZrXfg9T+fejPY
	 fKHkdDBxN/UKg==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C12QGwzMkF;
	Sun, 08 Nov 2026 13:54:21 -0500 (EST)
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
Subject: [PATCH v5 12/29] sched/deadline: Reject SCHED_DEADLINE on exited tasks
Date: Sun,  8 Nov 2026 13:53:49 -0500
Message-Id: <20261108185406.1549770-13-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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
index b13a9f0143f3..c71208b7f9f2 100644
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

