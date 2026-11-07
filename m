Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015907;
	b=DqLjMMkfWaZwRwSuY8NIrCjh5SQks17LeP2JF76IYCJuO7502RCnj8rzxnzq7/tJYRjj
	 t9Q2rUYSrWhJFiNZlxbwRsYWnpQFtLDHkPvgS8/fHPFGz291JOoxOtUGt/uKl2kDwgufe
	 4VKIWrt1TcvAHO6ejFbeqwv9jTXEgSEVGo+XjOInYWropn6f7+DSmwCj3KRwN7nXAcli4
	 W2k7kW7dy/v7oQEOPcFRH+QuNk7k24hmqL42f7DCXoKOCQ2bXDijoDqkqS8oIQal2p4Ea
	 K0IcOMUN19Ff5NEbd1pQVuibzXb2UNSnUaRLbVm+d8v0wfO+q1chBRpb9KHcFTwJpUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015907;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8VhKLiQa+qgSHc2MwBwT5JarahUkxGmCBQ2Ckl4WmaI=;
	b=FhhmU15LQ/gvxK4NDrjdSKgE4ugYATbOb64L8f2abvQQ6MTbDvVVIUFvojdLAGqYxgXU
	 nHRqUOcJFPFTRECQwVviXyHybmJuWB/yIkQzitxaa0vnTmLhOKEvOmApqcOOErhyRMQVx
	 Anf1fiy32/8+rn3N+YZ0lcBouITxklnUDOqXA5XaQjewK82/lm6WMV4WHu2aMdqehUzCk
	 SEQvfVMD6DaqzkI0mAoyNZVfFLnIO3Xazw08GxHHeE3cTBoxq4Zj9xBZaO8uzoz/lpjuC
	 IkNUUluKffdoeTSeFTkMZqGkQq44avhfWGCndzmsaUkQm9tjN+ckyEYeprxI7hB1eIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Tbph6roN;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C09D606EEA9;
	Sat,  7 Nov 2026 01:45:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C09D606EEA9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Tbph6roN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015905;
	bh=8VhKLiQa+qgSHc2MwBwT5JarahUkxGmCBQ2Ckl4WmaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tbph6roNO8XSbXZ129PsTSKd3RLjsA0Iw9l0X42fNzOIe+D+m9v4z1tM2ms+K6ytU
	 HGEAqPiZ9xCa8/s1bYNp9n665a3BhOPXLQnuO6+8GinUK9vsAJZAEwSCDwwwjdLuKT
	 D6QcqCNJPHmJc2DMsBiCqlG4So6+ViWpv5onnhx2DVYA/FhB9A0rJz9Ttwz71c30Hw
	 r9dRCRfZqrXcrvaX6RasfXt1ESplMdy8wYGsg+KnaXwM/2aKHgVqaTAThWTerQ2DsI
	 X+0NL6bWUDzSr/jt7M6yQ9l6Fp2Mn0qwpmtmdjK2+M4acSa5cSwex2MMtcgISpjkNf
	 cBC2NoWNwL2pA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPs4h7szMFH;
	Fri, 06 Nov 2026 20:45:05 -0500 (EST)
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
Subject: [PATCH v4 18/26] cgroup/cpuset: Wait for an attach before rebuilding the sched domains
Date: Fri,  6 Nov 2026 20:44:43 -0500
Message-Id: <20261107014451.1487825-19-mathieu.desnoyers@efficios.com>
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

cpuset_can_attach() sets aside, in the destination's root domain, the
bandwidth of the deadline tasks it is about to move, and drops
cpuset_mutex until cpuset_attach() moves them. A rebuild of the sched
domains in between, from a write of sched_rt_runtime_us or from the
energy model, takes cpuset_mutex, clears the root domains and counts
each task where its cpuset says: the reservation is gone. The attach
then moves each task's bandwidth on the strength of it, and the
destination's total_bw ends short of what its tasks hold: it admits
deadline tasks beyond its capacity, and underflows when they leave.

The writes of a cpuset's files wait for an attach in progress,
wait_attach_done_lock(), since commit 75f7a25ec6bb ("cgroup/cpuset:
Prevent race between task attach and cpuset state change"), and CPU
hotplug holds cpus_write_lock, which an attach holds for reading
throughout. Wait in rebuild_sched_domains_cpuslocked() as well, where a
rebuild from hotplug finds no attach in progress, and in
cpuset_full_lock(), which the cgroup v1 writes of sched_load_balance and
sched_relax_domain_level and hk_sd_workfn() rebuild under, in the order
the writes of cpus and cpus.partition take it. The other rebuilds, at
the online, offline and kill of a cpuset, run under cgroup_mutex, which
the attach holds throughout.

The move_vs_rebuild case of deadline_bw_test, added later in this
series, moves a process of 2049 threads, the last a deadline task
asleep, in and out of a one-CPU partition root while sched_rt_runtime_us
is written 20 times, 5ms apart, six rounds. Without this patch a round
fails in 5 VMs of 8, the partition root left admitting no task at all,
or the other CPUs admitting 3 deadline tasks of 10% more than they have
room for; with it, it passes in 8 of 8. A rebuild later in the attach
does no harm until the next patch gives back what an attach did not
move: it would then give back a reservation already gone.

Found by the Sashiko AI review of the second posting of this series, the
cgroup v1 writes by that of the third.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/cgroup/cpuset.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bf9a7f88c0ed..2ee58d46da0e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -296,17 +296,19 @@ void lockdep_assert_cpuset_lock_held(void)
 	lockdep_assert_held(&cpuset_mutex);
 }
 
+static void wait_attach_done_lock(void) __acquires(&cpuset_mutex);
+
 /**
  * cpuset_full_lock - Acquire full protection for cpuset modification
  *
  * Takes both CPU hotplug read lock (cpus_read_lock()) and cpuset mutex
- * to safely modify cpuset data.
+ * to safely modify cpuset data, the latter once no attach is in progress.
  */
 void cpuset_full_lock(void)
 {
 	mutex_lock(&cpuset_top_mutex);
 	cpus_read_lock();
-	mutex_lock(&cpuset_mutex);
+	wait_attach_done_lock();
 }
 
 void cpuset_full_unlock(void)
@@ -1005,7 +1007,13 @@ void rebuild_sched_domains_locked(void)
 
 static void rebuild_sched_domains_cpuslocked(void)
 {
-	mutex_lock(&cpuset_mutex);
+	/*
+	 * An attach in progress has set aside, in the root domain its tasks
+	 * move to, the deadline bandwidth it moves once it takes
+	 * cpuset_mutex again: the rebuild of the accounting would drop that
+	 * reservation, and the move would go through on its strength.
+	 */
+	wait_attach_done_lock();
 	rebuild_sched_domains_locked();
 	mutex_unlock(&cpuset_mutex);
 }
-- 
2.47.3

