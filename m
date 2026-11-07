Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015902;
	b=4tQCSvK4zzF6vIxVEZXOTxC+tmvdu/jcnTe1PNAtWvVT7HgFNXdNkL6R9HQpSt/TaEqD
	 aKvPka3cl1KTT5zHmQkpG97ZKnWeRooHsAqRave381morq95iEC/ybQ3/5HbvM0BkMLv9
	 Qb6KCGJRTvtvI8+2qYIcWAgCAc37bmq0ZiPrbtJ1bZ6V+qR7t0eIdrSrKb5IDhCBY5gvd
	 eJT8hS7h9+EQ1oNTMD9ZqyaTrMIFd6TvRaWmv2i9mLufSOSdC1MBdsk5Q1rp7fpRLFtqB
	 RUOORUgyWOPk5KOAHR7YJcOILOT1+GsNpB+m9FNlUcNwFKdHeB//b8RethX0uR8Kb5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015902;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ufKD3yo0IU8O9h+5AOdnMqxb+tYGqKSNZQWh8YpfE7s=;
	b=5E8MqIykmcv9gXw1p4pxn2STGWSc7RsTVCzMiT7/XIHRYeEQCfYEUem2oJyN4eQYXUWR
	 ejy+doP1s/zCdts+gGyTyTKCVcc0nnr5Zcf5yAzXW6iPy7FkIs4kSN96JUIBBAK+aw9+k
	 +dh2G8q+wQB0F45+fBU3CEbuj3V96L013pfnCeU6U0NvTHq9mUe0xCjldleJ7mmUeMBAM
	 qfBUavmd+tq8ejAg0clAtCOP9ASIqEb8xtq64PJpA66bhGeUEwiHuyduu8c0pUmXwys4y
	 EWPJjSufPbv05sWO3MXDDnxc3nMxSkIDFOGHUcI5ECZpTo3zBHPLqi9ytdGX0QazxFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m0KNl5gN;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE7606D813;
	Sat,  7 Nov 2026 01:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BDE7606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m0KNl5gN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015900;
	bh=ufKD3yo0IU8O9h+5AOdnMqxb+tYGqKSNZQWh8YpfE7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0KNl5gNgQVilcQ6DGQivWxnzyaz3mViWGDftwT4aV0FlFigFFs0yoD7YuAcZEOrL
	 rtdrgJuOnxS5jJwwTOjvw+eA9xIK7fRNOA5G3bq3z2U6Ho2kKfgHHStCHNE5UyOoM2
	 wLr+rEC9hP8ZnQKMvNAnykBz/rilxxMoOGj1KgE2lli6hi6IsS3j7MW208MjdGJnnc
	 i35nWn09f2/NPExXpRxHTESHhWVD5U/gLMF/Vwue5878881XAtVLRKfPC5vzImJRll
	 n2IsLUX8Hj06MB0ZIIZpZvOG/Xj88Bc+cSoKmGXgZo/Fhzy9pGCAG23qon8DweWPr6
	 Nmk3eu8dfkSmQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPm0j2vzLgS;
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
Subject: [PATCH v4 05/26] sched/deadline: Do not divide by zero active CPUs of a root domain
Date: Fri,  6 Nov 2026 20:44:30 -0500
Message-Id: <20261107014451.1487825-6-mathieu.desnoyers@efficios.com>
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

__dl_sub() and __dl_add() spread a change of a root domain's total_bw
over the extra_bw of its active CPUs, dividing it by their number,
dl_bw_cpus(). That number is 0 for a root domain whose CPUs all went
offline, such as the default root domain, which holds the offline CPUs:
the division traps.

A debugfs write of a fair server's runtime or period divides there while
its CPU goes offline or comes online: the CPU sits in the default root
domain from the rebuild in sched_cpu_deactivate() until it is offline,
and from its online until sched_cpu_activate(), and
commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
for offline CPUs") refuses the write only once the CPU is offline. A
write that leaves the server's bandwidth as it is passes admission
there. Writing a fair server's own runtime back in a loop while its CPU
goes offline and online oopses on the first round, in 8-CPU VMs of
v7.4-rc1:

  Oops: divide error: 0000 [#1] SMP NOPTI
  RIP: 0010:dl_server_apply_params+0x335/0x380
  Call Trace:
   sched_server_write_common.isra.0+0x1c0/0x260
   full_proxy_write+0x58/0x90
   vfs_write+0xcb/0x550

inactive_task_timer() can divide too, found by reading: it releases the
bandwidth of a task that left SCHED_DEADLINE, or died, from the root
domain of its CPU, which may have gone offline since. With admission
control off, so can sched_setattr(SCHED_DEADLINE) of a task asleep on an
offline CPU.

Refuse the write while the runqueue is offline, as once the CPU is: the
server's bandwidth is not counted then, and the rebuild at the CPU's
activation counts what the server has. rq->online is set under the
runqueue lock by the attach to a root domain that counts the CPU, and
cleared before the rebuild that drops it, where cpu_active() is set
before the attach and would be read without cpus_read_lock(). With no
active CPU there is no extra_bw to update either: change total_bw alone,
for the paths that have no write to refuse. 20 rounds of the reproducer
leave no warning then, its writes refused with EBUSY in the window.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 11 +++++++++--
 kernel/sched/debug.c    |  9 ++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342..00983487bff3 100644
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
index e6a3b516c703..5f8303630296 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,14 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Nor while its runqueue is offline, the CPU going offline or
+		 * coming online: the server's bandwidth is not counted in a
+		 * root domain then, which has no active CPU to spread a
+		 * change over. rq->online follows the attach to a root domain
+		 * under this lock; cpu_active() is set before it.
+		 */
+		if (!rq->online)
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

