Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790177;
	b=1LB+9+ON1RTI4VFaQE454Z+xDhWmXNb55/YNFjHpFmGDBaOqPq2QVfDNjluDaIzO4/A4
	 Kx5cYyLUNmpb7s+3SaQ1pA2XBofk10Guh5bBAO29qsb+pSapNlpNlw9KwlTyQyT/4Df2g
	 j5db7zcNo9HeX4V8frw0si4jegJC7CQPsuLvRKak84nA5VEzEhyqjrenlMPvaDmHlnZqy
	 fNepeNpFYC6qp7gW56PqgyJmdo2lP1s3Hd1/2Uu4tDT7kod15KpqWpyqqZZQWLnF6RKTQ
	 VaIXj/6KLVVJ12aeGIVc6c6a6BFLBhqU23sx2M1jNfEf454bgShYQwFRTDIq1a2cJuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790177;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YHg0RSkp6rv43zSMGCvkJFmKSujUoZgZ5+ECAqiyJcM=;
	b=ffW+zzjxCIJn1ZH4jrUazpzWjO4OwKvWhxTM8ZVWxGjFgni+Va/xmwJFbAz9IM9Z1fGq
	 wN9hGOIW16HDbmUGb78Nnmvu+Y1rlu+WEJzbzOf2ew8wCFO3TIj432//Z8PoIO3vGZ4KI
	 ey7QvlyKSjpgwzed9Spb7WjhMAs0vjPBloHwYqkA3DZy31LrYUDGojOyEfLEWYZoWoL1M
	 dKYQnrTrEihyky+Oah35/Yry1RZzv8xaHNM/6CPxctpKe1zYqpdeQRLAtrAaDen/ATe8F
	 tVWuHOTgwL4/O8alLYTIXj4KeLqq8jAEPYBTTMbsQiQAPlTLB93rxFVfjvuARBY4bhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="UtYVP/VO";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC58B606A6AE;
	Fri, 27 Nov 2026 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC58B606A6AE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UtYVP/VO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790174;
	bh=YHg0RSkp6rv43zSMGCvkJFmKSujUoZgZ5+ECAqiyJcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtYVP/VORfrg5t2R4t6ku2Tte3neFayWIiwSTtp6MFNXkk9fvX8/OgevIW82dhusZ
	 +LgD+g7eKFJ6AQbqWmKG0jHExiLiex07km3aIv2l/D8UBH6/A4Iw/EwMv6UtvLUAfv
	 BW3wMq/e2Vf4SfwAAQVP+F1Gj1WVIGld3GhFa6SzyYpDMLWB2/r8WFgVNkSlzdUhDa
	 GfaaM0YszJeU7d/DXl+tcy1wvSHhWQm7DeVMw0OZZb5+TGJwnqX/zO8Q0akJIF1Sow
	 xWKmL0xeIX8FAXUS2duu5dcR+rzuIjAKYRDTP8IZAvwiOBHi4/0JSI1JXUjwKYf7P0
	 ePGb9KRNVvONg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZQ5vLbzX2D;
	Fri, 27 Nov 2026 09:36:14 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	tommaso.cucinotta@gmail.com,
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
	stable@vger.kernel.org
Subject: [PATCH v12 08/43] cgroup/cpuset: Wait for an attach before rebuilding the sched domains
Date: Fri, 27 Nov 2026 09:35:35 -0500
Message-ID: <a77b49a403a11625373b999d6e2acc55a981ab36.1795771147.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

Since commit 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case
can_attach() fails"), cpuset_can_attach() reserves the bandwidth of the
deadline tasks it moves in the destination root domain. cpuset_attach()
moves their bandwidth later, on the strength of that reservation. A
rebuild of the sched domains in between counts the deadline bandwidth
again from the task list. That count drops the reservation, since the
tasks have not moved yet.

Commit 75f7a25ec6bb ("cgroup/cpuset: Prevent race between task attach
and cpuset state change") lets cpuset_attach() rely on what
cpuset_can_attach() set up. The writes of cpus, mems and cpus.partition
wait for an attach in progress, in wait_attach_done_lock(). CPU hotplug
cannot run in between either: it takes cpus_write_lock, and the attach
holds cpus_read_lock throughout.

But a rebuild of the sched domains does not wait. Two kinds of callers
rebuild them:
- the callers of rebuild_sched_domains(), for example a write of
  sched_rt_runtime_us or the energy model;
- the callers of cpuset_full_lock(): the cgroup v1 writes of
  sched_load_balance and sched_relax_domain_level, and hk_sd_workfn().

In this example, T is a deadline task asleep in root domain R. Thread A
moves T to a partition root P, which has a root domain of its own.
Thread B writes sched_rt_runtime_us:

  A                                      B

  cpuset_can_attach()
    takes cpuset_mutex
    cpuset_reserve_dl_bw()
      P's total_bw += T's bandwidth
    drops cpuset_mutex
                                         rebuild_sched_domains()
                                           takes cpuset_mutex
                                           dl_rebuild_rd_accounting()
                                             clears R's and P's total_bw
                                             counts T in R (not moved yet)
                                           drops cpuset_mutex
  cpuset_attach()
    takes cpuset_mutex
    cpuset_attach_task(T)
      set_cpus_allowed_dl(T)
        R's total_bw -= T's bandwidth
        records a CPU of P

P now lacks the bandwidth of T, and admits deadline tasks beyond its
capacity. When T leaves P, P's total_bw underflows. In testing, the
race left a destination admitting 3 tasks of 10% too many, or P
admitting no task at all.

Fix this by waiting for an attach in progress in
rebuild_sched_domains_cpuslocked() and in cpuset_full_lock(). The
latter then takes its locks in the order of the writes of cpus and
cpus.partition. Two kinds of callers never wait:
- a rebuild from CPU hotplug finds no attach in progress;
- the online, offline and kill of a cpuset hold cgroup_mutex, which the
  attach holds throughout.

The move_vs_rebuild case, added to deadline_bw_test later in this
series, tests this race. It fails in 5 of 8 VMs with 8 CPUs without
this patch, and passes in all 8 with it.

A later patch of this series needs this wait too. It is
"cgroup/cpuset: Give back the bandwidth an attach did not move".
Without the wait, it would give back a reservation that a rebuild
dropped already.

The Sashiko AI reviews of this series found the race and the cgroup v1
writes.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/cgroup/cpuset.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 194a438e25c3..51b6be460794 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -296,17 +296,20 @@ void lockdep_assert_cpuset_lock_held(void)
 	lockdep_assert_held(&cpuset_mutex);
 }
 
+static void wait_attach_done_lock(void) __acquires(&cpuset_mutex);
+
 /**
  * cpuset_full_lock - Acquire full protection for cpuset modification
  *
  * Takes both CPU hotplug read lock (cpus_read_lock()) and cpuset mutex
- * to safely modify cpuset data.
+ * to safely modify cpuset data. Waits for an attach in progress before
+ * it takes cpuset mutex.
  */
 void cpuset_full_lock(void)
 {
 	mutex_lock(&cpuset_top_mutex);
 	cpus_read_lock();
-	mutex_lock(&cpuset_mutex);
+	wait_attach_done_lock();
 }
 
 void cpuset_full_unlock(void)
@@ -1005,7 +1008,14 @@ void rebuild_sched_domains_locked(void)
 
 static void rebuild_sched_domains_cpuslocked(void)
 {
-	mutex_lock(&cpuset_mutex);
+	/*
+	 * Wait for an attach in progress. cpuset_can_attach() has reserved
+	 * the deadline bandwidth of the moving tasks in their new root
+	 * domain, and cpuset_attach() moves it on the strength of that
+	 * reservation. A rebuild of the accounting in between would drop
+	 * the reservation.
+	 */
+	wait_attach_done_lock();
 	rebuild_sched_domains_locked();
 	mutex_unlock(&cpuset_mutex);
 }
-- 
2.47.3

