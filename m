Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826735;
	b=xkbG3QubSCGyD2GHOW5gOSA4IS0OMSaJvzOnV2Gh6ISnH2INSl2f7jM9ShitsaVYsanf
	 uxXUgzgIIxm2+Fqv75ri01SjIH5+uMbU1NMeHaye+4wEcqlT4Y1oZrWTvS1Fypf4aQIHY
	 uv/d7B+DF4BsgifmRVzsEXfkZJxiSO6mI0I2jOQcMxSeSfnb6wv/xMF8KrilZWC1q3HX9
	 sRcPF825API4OUPpITUo4W+6VrIIWM3xNS5CBIuH7zojFvCucuXz0FVDxlbW2DdbssTKU
	 4NcuJ6zpeyyurc5CWpoyvyyELtYxSFu/Yf3nE7Wcwvz6fxUACKIkckAjPkopUyaGvaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826735;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IOgn3ctLBE8a6sSlOdKZ1KbLeEdy9wt0omNXDn9Tcg8=;
	b=wCEGMvrWWGVJ+RGceP1RYS1VonFetN/Shql8SSih0hqIj1ZNj2AXp8rbJeFbrPdjFP2H
	 qarQnQvB2cOmh664xWtpdSV0RZFnhhJx/sQFnuO/mY4GhBo0SthkJ2Q+rU3FDNG36RpnB
	 Tulnu1tpjC7VSr5dqHzrD0ks27vSOTdWn77mxVrtnPfVVSLSD1uMjRR9JS/f+jpjBjNVb
	 TBdp0DE8P63pdX/+4yqG8BlX0UCmdw7ZqUd0sfujNXlPs0jliB1H55PddXybLN3WIATSd
	 qs7wrZ2DWwjmFdvr4gfsisIXHk2mNNirgO0/VTmmlays+CDPF63kRnbCfd16LUcJmjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="d/Y5HTZu";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0076A6081741;
	Wed,  4 Nov 2026 21:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0076A6081741
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=d/Y5HTZu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826733;
	bh=IOgn3ctLBE8a6sSlOdKZ1KbLeEdy9wt0omNXDn9Tcg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Y5HTZuHVnoC0pSyJpQYiYzAyckNRQWBx7Gp1MzT+xuLz1Xz+3Lu//g5+tSLwiEP
	 0WvuHrdyYbK0hGnsawsvhWRgV7lccTF7x36rItEMXc7i8u4ec8Q1Xx6r/X/rrP1/v1
	 FWudHieZmRS0QunSRUXr+lrlkXl+uI5X+bpKc51a4BRNKG1BGkQScsdfIhkjAkOLSg
	 XmPhYkde9tvidvlzD4AjiMogG19xpMeYCc67lGx5vx5auwOuImpYQjKRGYCGvJrb9/
	 LkONcb3mamxjibwtejP7wuDzY1Fw3RFXVKuHYHzOJdJB8DkPzc/rb7WKmAcsyqiLnT
	 YELnQsBJSOjvw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRx15JkzKqZ;
	Wed, 04 Nov 2026 16:12:13 -0500 (EST)
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
Subject: [PATCH v2 04/21] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Wed,  4 Nov 2026 16:11:50 -0500
Message-Id: <20261104211207.1392343-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
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

