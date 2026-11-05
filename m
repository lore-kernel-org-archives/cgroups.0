Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907257;
	b=cVeyG6Mda140LpOMjTiNy52T9zta31b4klTCP9CPC5+W8wf62qkcvfdURq+B+znC0STD
	 vrwYL41JnMdIcJNmoJZ9jPsv5eAbkW81TgFHzD65WwsSpjx8f3v6LPvXDvLDKvjjdWWOR
	 TqxpgDoJifusJm+0YSt5JO8CcxoLFuTwbR7SK4IamGztD7ElwdStUHfL/1aGpUxvPHWFD
	 IKfFbOEjd6PwZEQYZkpY++GAtvFibGo8Lu2belsMRMBNm3t+OONpwA+4+a2nBTqaqkZcG
	 AFkYpaObQpdLyRYgo23NsCsVmShSSGghpRHWoEk6hUE5TStztQ5dpgKpXbDbWBVO5Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Dwu+w6nprYKMghj7ImzZruQ8WOAD5f4IrsT3udHNgFA=;
	b=cOtRxJQztT82x6fURVrEN98ShVRRDU1GF1ezSi41/pwR50stIaFoxcCAixafqjNweVQl
	 3Y4ztPDruLknsQIGFY0aONSWvHCx/Bgx9jRCDAczuc4B6iLKMqm6natdGxo0GFPn2D5h+
	 PbatH2NyjCBZw8nrW5SV/2tlRWx3z4vyGw8y0KRKHJI6GdZ7+om0usjVmwBdnslxd0LdL
	 gMhz5kwmoAdgb2rN70JA6pTwNq5MwpGWg1tugyVYYYMC8dAahk14JosyEiPlvEU8jXFe3
	 /myEh/kwEK/0JJrR8Mdp+LwIjuR8hYZHIiAh1BWovbM+C5XCOcFRLlkVHEQqf4xGK2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10728606B04D;
	Thu,  5 Nov 2026 19:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10728606B04D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907249;
	bh=Dwu+w6nprYKMghj7ImzZruQ8WOAD5f4IrsT3udHNgFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLOFZRqHGkbRk1JF7270nxuXKvXdMY5v5n1BMxA8s13eHDvOesMKsM+5e5VCPcGAo
	 rv64FZ6IUjm8cZmopazZbPOj4a8SAXwJXS0T/z9YPzMEcd03atXm/DZdbdF/upFDHa
	 PcvEMaRbIA4CYh2Uj+LjpT6dlXjiaIXWNPB0TTBlVrcKDpFvs+wHw27Vs77uAJAVBj
	 hF3nhrWX0VoRQ73+ce91RXVCQAMu3Y/Co78Z6tc8yzeGDt78En7C+w7H/oNYgvYP4f
	 4P3y+lOOBH2AVtPReva4baH7wCF7Ltk08qgw9u43o2me1sHc6ejhbqWYFaEw3BrSgt
	 QJWQjz+cQznfw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDK40jzzLfJ;
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
Subject: [PATCH v3 04/24] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Thu,  5 Nov 2026 14:33:39 -0500
Message-Id: <20261105193359.1450487-5-mathieu.desnoyers@efficios.com>
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

__dl_sub() and __dl_add() spread a change of a root domain's total_bw
over the extra_bw of its active CPUs, dividing it by their number, which
their callers take from dl_bw_cpus(). That number is 0 for a root domain
whose CPUs all went offline, such as the default root domain, which
holds the offline CPUs: the division then traps.

A debugfs write of a fair server's runtime or period reaches it while
its CPU goes offline or comes online. From the rebuild of the root
domains in sched_cpu_deactivate() until the CPU is offline, and from the
CPU online until sched_cpu_activate(), the CPU sits in the default root
domain, with no active CPU, and the write is refused only once the CPU
is offline, since commit 4043f5498416 ("sched/deadline: Reject debugfs
dl_server writes for offline CPUs"). A write that leaves the server's
bandwidth as it is passes admission there, __dl_overflow() comparing
that root domain's capacity, 0, with total_bw less the old bandwidth
plus the new, 0 as well, and dl_server_apply_params() divides. Any other
value is refused with EBUSY, higher directly, lower through the unsigned
subtraction.

Writing a fair server's own runtime back in a loop while its CPU goes
offline and online oopses on the first round, in 8-CPU VMs of v7.4-rc1:

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

Refuse the write while the CPU is inactive, as it is refused once
offline: the server's bandwidth is not counted while the CPU is
inactive, and the rebuild at its activation counts whatever the server
has then. With no active CPU there is no extra_bw to update either:
change total_bw alone, for the paths that have no write to refuse. 20
rounds of the reproducer leave no warning then, its writes refused with
EBUSY in the window.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 11 +++++++++--
 kernel/sched/debug.c    |  7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5fe5..4650bed9cc3f 100644
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
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..a4ae092e0a68 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,12 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Nor while it is inactive, going offline or coming online: the
+		 * server's bandwidth is not counted in its root domain then,
+		 * which has no active CPU to spread a change over.
+		 */
+		if (!cpu_active(cpu_of(rq)))
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

