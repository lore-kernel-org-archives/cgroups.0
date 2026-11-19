Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115240;
	b=5U0+5UwHkw85RjJzDe1x/6IQ5dpnJPa5g17tmcZCOtnBSg8+uNyc4HdnQ4XaFbg8y0V2
	 khhPdqy+J7pRIT4WOO3Zb9Hq1mLOZsisZRylrBBupwzCX8Rhp1s4gyGBPLdEHrx1kcpT/
	 LSUIPbDlMHpmUEJMJ0XfQL6ppwqD+fcr1Ni8hAJmI88JJcP6ZxA4Zw8hPeUV/Nj+bIomd
	 bzgTppRNofUspBM3Y6AM3THsE9MBG1Kpytkgg8SZyDtHRGmGqbCyw4z+CNsju9wIRS9LF
	 lVH2QAw9RuGOjnMZfww2tuX1rGHbWnqQWieYujlCCPkZ6Ar6fK/8QgZsEU3SbYuW/IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115240;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hjTYAqi/gpMkX55Y0igyLpnABuy/mfhM7aTE6x5O19I=;
	b=awwWUQqXngLeilAQ1u9hiJmWq//1a7zGa0mZ5CT7w46ppXr8YmmatHlH06MicVsuIeky
	 a5ejkP8Wi847MwdMGH+R4m0gq+yC2FGKXZzRqzKn40KV+OEk1PPIQ0d/Uf+HWWq4y+hxz
	 kVyH+3yo4KzA+p9sZobzxszjttJsBGsTDyNdGBSq4ByRW4o6EK6fdFhoez7rD0V7QQrBl
	 INRmJ6OCsTSZ9fOR396lPbAaAIG1SidO+AUrW/nXwIxWeP9IEjKBhnPfZl2co3++BLRUu
	 9WP2WFMBKfEtqJ6czbD9L/2xLQyfJKuCDXeJfyvlr4ZvwaNFcR+eJyIplQ0wjVPt9Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="xv2O/Nma";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7451E606A33B;
	Thu, 19 Nov 2026 19:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7451E606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=xv2O/Nma
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795115239;
	bh=hjTYAqi/gpMkX55Y0igyLpnABuy/mfhM7aTE6x5O19I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xv2O/NmaoletQ0lc4EgaAsfHdoeSM4Zq4kdy3txowrZ0sBxPkTEEsL0Yl/jvMq8qf
	 Epp4qzYTuc4oUUQ1VUndnuoFZzsq7E2vXAUrYhsaMe+w7gOZDfHcHWeKH/I8v+1UR1
	 Mrd0TT++J2D4VFsDVBbpMaVhNT0m6nbUeobT+wAKIepWo3PZEn7sXdsKsrC79ntqAJ
	 oQkqTCm6tUrnwHJzzHjQOTBMtsvOs+CfF/DatvEWcWx3zvEbjUc8poYanHMkAGlbsh
	 WPXk99PxN0TfyrCs8OlUeJHQVI00bzhO/N8BchmgHf6dMddxQMI516XRcgOPyE4XKw
	 mBNkGp8/N9ZAQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVnyv089kzSFB;
	Thu, 19 Nov 2026 14:07:19 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: tglx@kernel.org,
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
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v5 12/17] sched/deadline: Reject SCHED_DEADLINE on exited tasks
Date: Thu, 19 Nov 2026 14:07:09 -0500
Message-Id: <3a0a9885dc017068281e1bea820e11970718fbb5.1795115075.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
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

