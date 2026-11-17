Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924674;
	b=cGOqEq+vM/s7fXG4lYK5+8lBd87aHJ13TgVlYbA0EGCxh5codkj9EYER5Dsi8abZVmuE
	 mNQxSZaVCXxrVQ40S05FHH0ZCNbOWHr4WXYZn7bD4M7uaLP+cUANaPl9SFLvqvYumzY/w
	 vJ949CFVOyGPqbfZTNCrgmFQkWleY2nua1nPnRS7mHp4PhdEHYdC0l6THGhdqpwS9FY34
	 fA/jR1L2w3ZvPqbFVM0T5EZWj5FLKXK8/yx4cIEudWlLKet6aT7xTuuwxy90q25+jwrxt
	 LZWvlzrFD5aeNfsbE6/1p59g+O6gMvdR1Nnm5yy7tRXoPvUwjuNwkBAo7ar69ilDd2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924674;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9p94hJD2vP0zDldchA7bxwpBsXvy/6CynoDvMnhZnkE=;
	b=COwge/Pta3TeCxBMZAtjDvXYF6repOEZ6n9uipibhC5jG5H6g4/tIlpGRRq1BuEhxEAk
	 yLicyTcXsm/oRZfhnk6ogWDcv7uI2bcx9AOFz+wHfv1chCBU6Aq/pi5w41GkIpXd5gK4m
	 QQ6geQOwMCKu3+TiKGJe+IMrV1GlDzkNJNjYj6uHKzvUDoBXQTNtjNCO5UJBpYPnJvXsf
	 Jgiq5AQlxcCY3ALMJBL+UQXuDyVlEIrnm+aJi/8fKkvFMyVm6N41TyT007exiNqTOBRm7
	 bD6LYB5qmfZI+pdaIzJ6a1b4ERBlJdPQcHO0qnsG9OJYvBJtZtHjR5zTadBlno+Q03Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U8mDQt4B;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A160A6F55;
	Tue, 17 Nov 2026 14:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 907A160A6F55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=U8mDQt4B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924668;
	bh=9p94hJD2vP0zDldchA7bxwpBsXvy/6CynoDvMnhZnkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8mDQt4BlODQO6pkeMr6NR5xlohd9ptKPEfrkt2B98QA0pCmM7fqXD9ENLKBBfzJJ
	 eN9IqU8w9NMzPOO2tTBEzAWNOvEqoJmC7NeZR67mB573nAfQAnGkTQBFjRSVp+5ld+
	 /ARLJxkWxsQgKOL+GhnB4ahmxMIbOwMzlhF2EJ0Jy4xk2LTIZr8Dcmv5ekdPUw9XKV
	 +vsJkPFIbSKziVciMjrMKIVL9a5f1GZFSqhph05rQ89z4Q0o23B7Lco6x0bi36cW7j
	 iAIx+EpmwILwtWu6UzOQ5tyaKNKHTale4W/yvXvCCswJmi7g2kausQcvbh43VD8583
	 s4bbpRRAwUp6g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV42VsXzRZR;
	Tue, 17 Nov 2026 09:11:08 -0500 (EST)
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
Subject: [PATCH v7 22/40] cgroup/cpuset: Wait for an attach before rebuilding the sched domains
Date: Tue, 17 Nov 2026 09:10:43 -0500
Message-Id: <b09e7af5f4bae1fa4b7386d0808b1b536af44553.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

cpuset_can_attach() reserves the bandwidth of the deadline tasks it
moves in the destination root domain. cpuset_attach() moves their
bandwidth later, on the strength of that reservation.

Commit 75f7a25ec6bb ("cgroup/cpuset: Prevent race between task attach
and cpuset state change") lets cpuset_attach() rely on what
cpuset_can_attach() set up. The writes of cpus, mems and cpus.partition
wait for an attach in progress, in wait_attach_done_lock(). CPU hotplug
cannot run in between either: it takes cpus_write_lock, and the attach
holds cpus_read_lock throughout.

But a rebuild of the sched domains does not wait. A write of
sched_rt_runtime_us and the energy model rebuild them through
rebuild_sched_domains(). The cgroup v1 writes of sched_load_balance and
sched_relax_domain_level, and hk_sd_workfn(), use cpuset_full_lock().

In this example, a rebuild drops the reservation. T is a deadline task
asleep in root domain R. Thread A moves T to a partition root P, which
has a root domain of its own. Thread B writes sched_rt_runtime_us:

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
cpus.partition. A rebuild from CPU hotplug finds no attach in progress.
The online, offline and kill of a cpuset never wait: they hold
cgroup_mutex, which the attach holds throughout.

The move_vs_rebuild case of deadline_bw_test, added later in this
series, tests this race. Without this patch, it fails in 5 of 8 VMs with
8 CPUs. With it, the case passes in 8 of 8. The next patch needs this
wait too: without it, it would give back a reservation that a rebuild
dropped already.

Found by the Sashiko AI reviews of v2 (the race) and v3 (the cgroup v1
writes) of this series.

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

