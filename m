Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015902;
	b=oypBqOPY0DktGR5Xy1TE5oH8eaS7VBwg9jifq7vdjjxD2lABz9ROnT1a0pLBIwWZfGDw
	 SOMUBfQ/RWjL9OApD1m3WkjebeE+NJfuGjoeWm4JUjsDf3SHXcWv+rhCX6U6fvk1lPACW
	 oS06+TNz74ZldkBB53dCRyaq+tzDtkBnraF7oI1AasTGHOgnsVatRmlpsKzme58Iiok/A
	 I/x6dwPFzvJp7vx1L7PcO4QlbSYOxuOvdDetxMJpVsY9lPoRi7eDtLUhqHb/oL5Z2xFXK
	 cb7olL45E+yCCPSL8BtUy6Jib0ZAs3HK0G3o2v1FmC4FP6yguIzpDwiIB1D/dSlYxxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015902;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=spgTF+ZorZrFLxowzHeNt4zJ7sbdfzQLGrzjG6MDAPY=;
	b=3T8j/zDYOW4z9xuzrHr2jgv/xjYaAeDVl/2OyvRvsISD4rzMBWW8pPfuPDJUdtxFpnqv
	 yW7eZFyMo9DodpHEz+49HKa5jDbggLmrfbzeC4DYiO0lwgL7cHZ5VHCl3kZvSyRmshYnr
	 OeweabCwVSVJam0F4mVKmhQGZMMvVj4nuP491j9HAazbrNuw+/4x59vjPHZ43kR3ElCMw
	 6zB+h48uvZWC0K7KKQ/uCJFjiokhLOtb2g8ZjZJqDwPnc8YZPPa9Ili9ATW/yHZpCzj1r
	 u2LoSiBQczn1644wioDHzVD5mYPQV+OS8g4nmy02+t0yCR3E0+MXt9tMZPEbUj46MAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JLDhFj91;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B0D606D816;
	Sat,  7 Nov 2026 01:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97B0D606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=JLDhFj91
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015900;
	bh=spgTF+ZorZrFLxowzHeNt4zJ7sbdfzQLGrzjG6MDAPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLDhFj91hcsDGS/D2S6KWj3iX6eB66catdblN0/0KO3r1Vz7I6P98aUOmulVcLMuw
	 Jb9j/FClZ1L84bBlvaf5XYtfl8AHv6wmO4Zf/uqnbtIzJk9xicohgLI5xFZmNfHuaq
	 aPut0D9A8Akwqpx15/r+R4bMXRAAo2cElCpjLbEe0V8QJtMpYIlTZkgSxndhYh96bj
	 X1Z5+cbz/Ppshog6+LO7RlsWrpaB34Fp9M6z5wdT2vz/ILpKmRXnEt1vK8qFpyC7S/
	 5JLt0tdM4HmmGZxeXJDxCCFSEU4Vid8cv+sKbd4d5K3RhuAxIU46ydvpLeFxtzsFgY
	 jW4LAgw8n2zkA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPm4T2qzLZ6;
	Fri, 06 Nov 2026 20:45:00 -0500 (EST)
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
Subject: [PATCH v4 06/26] sched: Take cpuset_mutex for a deadline policy change only with pi
Date: Fri,  6 Nov 2026 20:44:31 -0500
Message-Id: <20261107014451.1487825-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
References: <20261107014451.1487825-1-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() takes cpuset_mutex for a change of or into
SCHED_DEADLINE, and releases it on success only where pi is set, with
rt_mutex_adjust_pi(). normalize_rt_tasks(), the one caller with pi
unset, then takes a mutex under read_lock(&tasklist_lock) for every
deadline task it finds, and never releases it: sysrq-n on a system with
a deadline task sleeps in atomic context, and every later change of or
into SCHED_DEADLINE blocks on cpuset_mutex for good.

Commit 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex") made the
lock depend on the policy where it depended on pi before, and left the
release where it was. Take it where pi is set, as before:
normalize_rt_tasks() takes tasks out of the class, which admits no
bandwidth and needs no stable cpusets.

The policy the decision reads is the task's before the runqueue lock, and
only a caller that gave none has it read again under the lock. Given
another policy than SCHED_DEADLINE, a change into the class by another
caller in between makes the call a change out of it without the mutex.
Decide again under the lock, where the policy is settled: a change out
of the class needs no mutex, but the decision follows the policy the
call acts on.

sysrq-n on v7.4-rc1 with a deadline task, lockdep on, in 8-CPU VMs:

  sysrq: Nice All RT Tasks
  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:623
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4356, name: deadline_switch
  locks held by deadline_switch/4356: 4, last CPU#3:
   ...
   #3: ffffffff83006098 (tasklist_lock){.+.+}-{3:3}, at: normalize_rt_tasks+0x34/0x150

and a sched_setattr(SCHED_DEADLINE) after it never returns, in 2 VMs of
2. The deadline_switch_test selftest added later in this series has the
case, sysrq_normalize, which passes with this change.

Fixes: 111cd11bbc54 ("sched/cpuset: Bring back cpuset_mutex")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index bdffe5452dc8..c3f404cddb9e 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -554,9 +554,10 @@ int __sched_setscheduler(struct task_struct *p,
 
 	/*
 	 * SCHED_DEADLINE bandwidth accounting relies on stable cpusets
-	 * information.
+	 * information. Not where pi is unset: normalize_rt_tasks() takes
+	 * tasks out of the class under tasklist_lock, which admits none.
 	 */
-	if (dl_policy(policy) || dl_policy(p->policy)) {
+	if (pi && (dl_policy(policy) || dl_policy(p->policy))) {
 		cpuset_locked = true;
 		cpuset_lock();
 	}
@@ -647,6 +648,16 @@ int __sched_setscheduler(struct task_struct *p,
 		goto recheck;
 	}
 
+	/*
+	 * The policy read before this lock decided against cpuset_mutex: a
+	 * change into the class since makes this one a change out of it.
+	 * Decide again with the lock held.
+	 */
+	if (pi && !cpuset_locked && task_has_dl_policy(p)) {
+		task_rq_unlock(rq, p, &rf);
+		goto recheck;
+	}
+
 	oldprio = p->prio;
 
 	newprio = __normal_prio(policy, attr->sched_priority, attr->sched_nice);
-- 
2.47.3

