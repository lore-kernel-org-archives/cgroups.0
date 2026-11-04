Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826735;
	b=ky+z42uw+mvxzQfjPJyZKzJFxmeTqgUjn96WDXn8A1W/rtePV3kEU1Uxgfi91fYaQ09V
	 NYh2alElxAQJ3ffwTB3yfoJ+AslCqnlLpo7R8TcGwNOoT3ZtyDOd39DHiUmZ8R6wHYFfY
	 Yonw7iymU5UeXan7Em+dh1RsV//OGJkqRA9T8gWIf9Qr4wWnLlnEnxrtONbbAyDwc12wN
	 cvnM/P5pVSBqqi2rMSdyn2l5cZFr+smVi8reg61aMMkb9jfETQLJX4DR4Xp8icVvXve8T
	 IHBvi9hjuVhN3cTrY0+F0DsxGC1jgaZcDoQNIS2bAEqMRC/UOgl3AUQv/m/TEPVNxTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826735;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o3Cw2LxQFj/sOcaa0cN2pMz0x6px6mdmeBIG0Gey0zs=;
	b=mKLZx0/vFcDgWDNjyaIcnw+JfwuBsRPitHf5mt9UirjMnlU7vJzEOGjauItw7Qnk1URH
	 0d0HNbHtcy0wxj3l2Gt1NqbG8lghM7tV8iZamfL7fEf983JjJ5BQYDYj7H3FLJse30dir
	 l/PkBgHiw62vNLaBfk3GL8BvCNR6SuIjIxKRvEJq5o29j4FRDJS0Evcw/0CMu+B2meOmj
	 +haEq/56GMEoaXbCmWRmX87Ooar8p30u5PPMbM3qaX5BZDs9qghtlwELSpe5o3uUqSGFk
	 XreTmCS9mXqBSgsoFT9oaiTAUDL6nbXVDxehqrSXaHGXH8HJMR9leId8XRVDhf+I8WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UuwJ90Qb;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2341608175F;
	Wed,  4 Nov 2026 21:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2341608175F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UuwJ90Qb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826733;
	bh=o3Cw2LxQFj/sOcaa0cN2pMz0x6px6mdmeBIG0Gey0zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuwJ90Qbaq6sRM4p+eeIYR1O4CJcTakr4ic9enuvUanG3lzFm4i4AZ1n55kme9u9J
	 DoZBYZR1d3GfExB3yuYV1rcG8GlQSnQMLV5nfnA7EOPuSU5I9DlDBDRGS9rhMn1wpr
	 jOVdDZ1ZdPnmBAuEULIZRr9aFbWUiOWqA9cxH6ykN121RlhPTqaiiUpcAHHx5miNBn
	 meKZXs2wl2pyr4avSlq7FbQt7KB5fCskKFTgpkH/YKUi5Diw1lC71IDAkGkeSZ/318
	 JfRAmtNl8QddsbwizzdejAVV9skn7lqt2LCmBoDg0UKAMNm8j7/u8itEWOS1/AwMVj
	 iHtJAAWIpI2VQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRx29vKzLXS;
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
Subject: [PATCH v2 05/21] sched/deadline: Do not BUG() on a deadline task with no active CPU allowed
Date: Wed,  4 Nov 2026 16:11:51 -0500
Message-Id: <20261104211207.1392343-6-mathieu.desnoyers@efficios.com>
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

dl_task_root_domain_cpu() finds the root domain that holds a deadline
task's bandwidth from the first active CPU of the task's mask, and
BUG()s when the mask has none. A mask can have none:

 - a task boosted into the deadline class by priority inheritance keeps
   the affinity of its own policy, which may allow one CPU alone, or a
   cpuset of one. dl_task_needs_bw_move() and set_cpus_allowed_dl()
   take it for a deadline task, dl_task(p) being true, and look the root
   domain up from the mask they are replacing, which allows that CPU,
   inactive by then: the cpuset code updates the masks of a cpuset's
   tasks once the CPU is inactive, and select_fallback_rq() widens the
   mask of a task it pushes off that CPU;
 - with admission control off (sched_rt_runtime_us at -1), a deadline
   task may be pinned to fewer CPUs than its root domain spans, and
   those may all go offline.

Both take the kernel down on the first try, in 8-CPU VMs of v7.4-rc1
with the four deadline fixes of sched/urgent. The priority inheritance
one, which asks for no unusual configuration, through the wakeup of the
boosted owner:

  kernel BUG at kernel/sched/deadline.c:3340!
  CPU: 7 UID: 0 PID: 0 Comm: swapper/7
  RIP: 0010:set_cpus_allowed_dl+0xf0/0x100
  Call Trace:
   <IRQ>
   set_cpus_allowed_force+0x9f/0xf0
   cpuset_cpus_allowed_fallback+0x12b/0x1d0
   select_fallback_rq+0x238/0x340
   try_to_wake_up+0x2a0/0xb70

Fall back to the CPU the task last ran on, which these callers used
before the commit this one fixes. Its root domain may have no active CPU
left: the previous patch has __dl_sub() and __dl_add() take that. Ten
rounds of each case leave no warning with it.

Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dadda1a528ec..30a52e42c26d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3338,13 +3338,19 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
  * current cpus_mask (not yet updated to the new mask) to find the
  * actual root domain. Use cpus_mask rather than cpus_ptr, which
  * may be temporarily narrowed by migrate_disable().
+ *
+ * The mask has no active CPU left when the CPUs it allows went offline,
+ * which the affinity of a deadline task allows with admission control
+ * off, and that of a task boosted into the deadline class by priority
+ * inheritance always: fall back to the CPU the task last ran on.
  */
 static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
 {
 	unsigned int cpu;
 
 	cpu = cpumask_first_and(&p->cpus_mask, cpu_active_mask);
-	BUG_ON(cpu >= nr_cpu_ids);
+	if (cpu >= nr_cpu_ids)
+		cpu = task_cpu(p);
 	return cpu;
 }
 
-- 
2.47.3

