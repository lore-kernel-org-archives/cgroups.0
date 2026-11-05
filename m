Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907258;
	b=N8woq2+eaQn/DI2ArVUmTmuf1fzYUzaec3iYauszt7R+NhkadPmsOuTpcVmf92rouLR6
	 L5dIg5E2RAc00R70RiAPJCpxnmu03Jp5g3vRb96nRpGA11/uw41bUd8GIDVEWz4oJr7fV
	 nDj22dubEUgqR5sF1kQELTuxLwFczHlKJQtIGmEMa/L/lNmZYCWqQh8woOCermx4Dab0t
	 BG1JHsp2lVS3YuM8WFPM0SpE28XWRFe01vIdFptk6DQqT5bMKE3Zy2kowixO0hvRtoxfB
	 C4iAVSzU460kZIPWRPSYKLyq2dBYALS8RZd3+Hddal1G+mb6cXEL9uleOc/XHHkxhGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907258;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PXzZs0S60nPwFAawFAM1P7kB6paIaMENZssdjTCs6jE=;
	b=4MlvU9TYFXuVBVnTRwz7zRuTzzs3Ie/YED8bzaYviMqca2XCl9wTSJieU1X/mZrkSdVM
	 QH9MkwYWDYTZkcoP6Ospa9eZObB2Q6/tMKea4QwjsvXJ5a98Jy8JnQS+zaAmGsVGXeUD9
	 fvm1K+cNODOrpvrtMptUTuVgcDM8tmyaPziZ/Mqsv352tEK9piBjIOwuI3dw/lKeoo0Uu
	 EHMfnvBdF2X3B3l9QwUrBArP1ztUYaNIM1WPBJlOw8FngDTeUT6nUek0pWY5b5ZMlAM0h
	 v9Y/8ati3lFGupYPigg2VvMzopNYwVSAc9Rwiq2Gs487/cQQiiDhzYzPx2EIKOAUWvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ITrkeQwL;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57C6606EEB6;
	Thu,  5 Nov 2026 19:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A57C6606EEB6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ITrkeQwL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907249;
	bh=PXzZs0S60nPwFAawFAM1P7kB6paIaMENZssdjTCs6jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITrkeQwLf7L41ZRGD0zenSL82pf+tZTHHBp6IbwMtp/Ji3bwfHXPMWRjLfSSoRpOu
	 0HTSHeEAPABfUrLRo7V/RI6nYJx6rX60NbDAgRdGHcGpXCRHiHPymCHtb70KA3N96E
	 6EfdyuBknaLfQfH6JyI2Wp7IKB962HoMqeVJsbL5C/EEe5AX0WwZGElzkLTvZ2PFym
	 jqwFhmac227/e5Z92vgsXgadT3zTmqsIuOjlmXp6l7zHZ/XHdeuGgh/ah/KrgZIA3e
	 O8ZPftIRMaNv8wdeZXAj+QErRL+ysou+ShLKrgdpEe2Ai6Didc6qb7aqNA/YFk9OIv
	 O1qqAMbT0S7Gg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDK59qwzLwb;
	Thu, 05 Nov 2026 14:34:09 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 05/24] sched: Take cpuset_mutex for a deadline policy change only with pi
Date: Thu,  5 Nov 2026 14:33:40 -0500
Message-Id: <20261105193359.1450487-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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
 kernel/sched/syscalls.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b8c036d03d6f..bffeb4143161 100644
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
-- 
2.47.3

