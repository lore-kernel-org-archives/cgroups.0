Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805148;
	b=4edVvI88Mqb+K8o7aBhVrMXWyzyeK+HHVUDfWRk1qFRlpbUqurXfNAHAjI1dAZ9ADlQD
	 bty1MojcPfFPclwUfKOuIPKc5r9vllTYLH3rtDPw2tZ1kHOvZxZwbfPxuOEKF6xB1lGYW
	 IDhVO1Hp3sKvaA+9wTLm/KLBvbJbcxcupP6MXhTGr5FIRjzTDDCJbSjx1j0L0gvSKeJu0
	 XZOa7+WQmNzmMleBukWQu6Xz8OmWo8e2UxW1ESkqcJaPQftFW++tsOmvEFyndw3o9YVqt
	 EqbsgeAIG5ZdVN7pPFtw+FQsj35iTVx+e3neKKI9CL8GSlvtUk0O3ZZ2BZDSFs7OFUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805148;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IOgn3ctLBE8a6sSlOdKZ1KbLeEdy9wt0omNXDn9Tcg8=;
	b=bl5vYQ5c9qs7ByHBnEa2YjnDzhewiSJrAqB4iVjpLEIQiVbMJncKwUXxoeqmcCd1/t0L
	 aIUZFVMtBmnT/56GF9HrTQnwMF2tXrK3lWnPSJybstqGSuhvnQx/bCE0tKW93Tlguzg8i
	 0Kkgds+eT52yEjxisVe8Xjiyb2QqSThCDfxJqJTzcTYbkuK7EpxGynq8QEdSrOGA6/4fE
	 8kSwx0N3ab5uJvxqdB93iK/Ts1OIeL9EFNZAWkNM/TitkZ/BatzQf/2SksQ9WydZVaYu8
	 WB/y1lXtDDzFPY1gJUHgKsxcmXqxwzGBNkrBXXxo6iHjySyv8cmhLEujEIqbymXcyDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wh9yiUp3;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BF2606A31B;
	Wed,  4 Nov 2026 15:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12BF2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wh9yiUp3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805140;
	bh=IOgn3ctLBE8a6sSlOdKZ1KbLeEdy9wt0omNXDn9Tcg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wh9yiUp3JWE9XY6TmYlixEFNfJu7reo1ZCKOqfdsgtKBV53Wu1nTJGEpFrYMzizRY
	 810FswWMMyE3187fkdNioRkZZGvDTaLa5PWw7PFWF99ayReYHLlGiR2sGmW+aHxqkv
	 MabU+kmjhRvd2k1V072P73UfGw8zx6WL9eTpk6gOx1ry61lLP+eaPiJajMrM3qLozm
	 MXwsrouezVSoWFGB0zozbE2C1m3+7WMRSvLy/lODYHybvQFxrRm2N/Iolitd8h8VAq
	 RbDfMOEYGaawY1m7eDzunGrvxPSjO4YczqShpySEs55d01K2KxBsfEuK765tYLc4fv
	 zfROv2FUT9+hg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSh0kJvzJqw;
	Wed, 04 Nov 2026 10:12:20 -0500 (EST)
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
	Claudio Scordino <claudio@evidence.eu.com>,
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
Subject: [PATCH 02/12] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Wed,  4 Nov 2026 10:10:23 -0500
Message-Id: <2912ea258a6cc7fb26a5ca97296550c020daf2ac.1793804635.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
References: <cover.1793804635.git.mathieu.desnoyers@efficios.com>
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

__dl_sub() and __dl_add() spread a change of a root domain's total_bw
over the extra_bw of its active CPUs, dividing it by their number, which
their callers take from dl_bw_cpus(). That number is 0 for a root domain
whose CPUs all went offline, such as the default root domain, which
holds the offline CPUs: the division then traps.

A debugfs write of a fair server's runtime or period reaches it while
its CPU goes offline or comes online. From the rebuild of the root
domains in sched_cpu_deactivate() until the CPU is offline, and from the
CPU online until sched_cpu_activate(), the CPU sits in the default root
domain, with no active CPU. A write that leaves the server's bandwidth
as it is passes admission there, __dl_overflow() comparing that root
domain's capacity, 0, with total_bw less the old bandwidth plus the new,
0 as well, and dl_server_apply_params() divides. Any other value is
refused with EBUSY, higher directly, lower through the unsigned
subtraction. Once the CPU is offline the write is refused, since
commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
for offline CPUs").

Writing a fair server's own runtime back in a loop while its CPU goes
offline and online oopses on the first round, in 8-CPU VMs of v7.4-rc1
with the four deadline fixes of sched/urgent:

  Oops: divide error: 0000 [#1] SMP NOPTI
  CPU: 6 UID: 0 PID: 110 Comm: dl_server_div0
  RIP: 0010:dl_server_apply_params+0x335/0x380
  Call Trace:
   <TASK>
   sched_server_write_common.isra.0+0x1c0/0x260
   full_proxy_write+0x58/0x90
   vfs_write+0xcb/0x550
   ksys_write+0x6c/0xe0
   do_syscall_64+0x109/0x5d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

inactive_task_timer() can reach it too, found by reading: it releases
the bandwidth of a task that left SCHED_DEADLINE, or died, before its
0-lag time from the root domain of the CPU the task is on, and that CPU
may go offline before the timer fires. With admission control off, so
may sched_setattr() to SCHED_DEADLINE of a task asleep on an offline
CPU.

With no active CPU there is no extra_bw to update: change total_bw
alone. 20 rounds of the reproducer leave no warning then.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 963fda6ddb7f..dadda1a528ec 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -189,18 +189,25 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
 	}
 }
 
+/*
+ * @cpus is the number of active CPUs of the root domain, whose extra_bw
+ * shares the change: none once they all went offline, and total_bw alone
+ * changes then.
+ */
 static inline
 void __dl_sub(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw -= tsk_bw;
-	__dl_update(dl_b, (s32)tsk_bw / cpus);
+	if (cpus)
+		__dl_update(dl_b, (s32)tsk_bw / cpus);
 }
 
 static inline
 void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw += tsk_bw;
-	__dl_update(dl_b, -((s32)tsk_bw / cpus));
+	if (cpus)
+		__dl_update(dl_b, -((s32)tsk_bw / cpus));
 }
 
 static inline bool
-- 
2.47.3

