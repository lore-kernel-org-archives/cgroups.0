Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855961;
	b=h2jrQbS+Sn1MWfn0mKF8H0XWqSK0QSakJoIN7zZeJTeErKHjUMpHc4afgmXAJMPXEKBe
	 ik++2qP2lZHVxPzuKm+h6XSaQBZV/Y9rKVJRsYG+A1z2bKw/6TVLZfBi4eQRMtZ1VFKBM
	 JyrKeEFA/bQN9vPm+WHazxW3Q4vz4gZrgoKsysxeh2K44comA/qjUSu0Osd+P2Mz0iz0b
	 LysFWaCZjdba9w4ELYvd/AaeqKLjbgiVGfpSlwTK2pUjtWws8jM1YmsNES78piSmpmnsa
	 HxRvGH9hzIt5AMr+wJY2MLGC/eAMT51cUVG9+BMBm7Qwr+h74yjRSGXj7sR0SaE25dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855961;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Bz63C07qNTrJNIT7ciigC4ityK+fnROxTDmBGBinnp0=;
	b=4Gvh11G2ZvIvmnpOnmf5nYDin758MXObkOe/KAB2u1GO+837RyI7muZGOB4pW97KxB0/
	 L5wPfczvpP9o0Ytt6fX53AU/EOqTyHlTxBWlnPSP1gH8gbqJos78kg7Slm/KLlyqxtM62
	 x9kNbc6cFg7cQAX4GqNg+Fiujwb4PkhKW+QrJhV+PkjZ8BaNClcOQ6MwxroJRyf4LIKyo
	 NDu4TYEQe+/y+kST+y9Cey3FvsZL2jFUHHMlTdLcbeV0fxt+AzIfz+8BxA6O9Azm6TMJZ
	 86hXcPPAqsKLGyHQyVbbvQ4Z+uZUCOsJtMh2tIctoFmcJMgeqvHuV5YrnGHspYayiaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UjOJLzNl;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0082A606A883;
	Mon, 16 Nov 2026 19:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0082A606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UjOJLzNl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855954;
	bh=Bz63C07qNTrJNIT7ciigC4ityK+fnROxTDmBGBinnp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjOJLzNldjgdmJ8SFyTNtpNG/A1CsSLw1HmLZBGd3D6F3kaWWjwWFzbF5Z76ZsYA5
	 vAFf0yob/qLQZL2itKh9CnGtM6g6qC+mVeIStsMvBx4w11H/c1KVEUcAzZ75SJejmy
	 1zgrXiSoT9spGY9HgOgjounhX7yELd5X+e4ewhqARhj8624IqEiI5YMXjd/9EeedTM
	 WbylaeQITvDF14bYdKq0vgnH8L55p7f+bLVHqCA6plnQgjls13wokorRf7N6XqgPFy
	 R/hkdmx3ZNUStErhrMh8tbCyPpfcEnVqFViKuH6bJ+4usYAuhN1mmq2rkCZuRC5tV/
	 /lhyA3kwUHghg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4f2N6CzRGb;
	Mon, 16 Nov 2026 14:05:54 -0500 (EST)
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
Subject: [PATCH v6 04/37] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Mon, 16 Nov 2026 14:05:16 -0500
Message-Id: <20261116190549.230119-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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

__dl_sub() and __dl_add() divide by their cpus argument. Most callers
pass dl_bw_cpus(), the number of active CPUs of a root domain. That
number can be 0, and the division then traps.

Commit daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl
tasks") added extra_bw, the bandwidth that deadline tasks can reclaim
on a runqueue. A change of a root domain's total_bw is spread over the
extra_bw of its active CPUs.

During hotplug, a CPU sits in the default root domain, which can then
have no active CPU. This lasts from the rebuild in
sched_cpu_deactivate() to the offline, and from the online to
sched_cpu_activate(). A debugfs write to the runtime or period of its
fair or ext server divides there. A write of the current value passes
admission in the window. In 8-CPU VMs of v7.4-rc1, a loop of such writes
oopses at the first offline and online:

  Oops: divide error: 0000 [#1] SMP NOPTI
  RIP: 0010:dl_server_apply_params+0x335/0x380
  Call Trace:
   sched_server_write_common.isra.0+0x1c0/0x260
   full_proxy_write+0x58/0x90
   vfs_write+0xcb/0x550

By reading, two other paths would divide by zero:
- inactive_task_timer(), for a task that left SCHED_DEADLINE or died,
  if its CPU went offline.
- sched_setattr(SCHED_DEADLINE) on a task asleep on an offline CPU,
  with admission control off.

Fix this by changing total_bw alone when the root domain has no active
CPU.

With this patch, the reproducer survives 20 rounds with no warning.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342..b614d5fc1a1a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -189,18 +189,25 @@ void __dl_update(struct dl_bw *dl_b, s64 bw)
 	}
 }
 
+/*
+ * Spread a change of total_bw over the extra_bw of the active CPUs of the
+ * root domain. @cpus is their number. With no active CPU, as can happen
+ * during CPU hotplug, change total_bw alone.
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

