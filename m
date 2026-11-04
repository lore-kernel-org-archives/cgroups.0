Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805149;
	b=XDu9RRW15Gm5UwxXOO6YN1rtJlY0OtY/3GAlaaTMSM91Y1K1tyCWTjmuvxIQbQS3jrkp
	 INpXq/JnUQUmdXwzt8a6u3PSVtHMe6e9xqBDOBrmrtce+KKw33iUgktWyNDtVzh1IE2HY
	 wHBeoAYp7aGf05ZnDBlF+oh1gIk4jhnG1CHhqbIqKCkLcUDkVJ28ETNCx0DA+8rVY1w34
	 9ubjLSEgyawBKmnMlA+TD/mVblyyM8R7IFzvVuJFUVbK75WJmajL3ZMfFkJZpRUaHtzix
	 jdDMVvkGDmgyu3CMSFKDBfIB+iJ1tZpJ/XWpoQehbjrxzXIsidpzGyMCQusEmmk1mXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805149;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o3Cw2LxQFj/sOcaa0cN2pMz0x6px6mdmeBIG0Gey0zs=;
	b=ldQQpwESLNUf8G/qcQOBaS5y1zbxdNyuGPoHsG+2dqfnTJWqZ6/eC5abiam5I2U7XDNU
	 /6OkmSHp+uElQhirIZGkIdlca3qTcBzFKuZnxnweH88NCC2FmWEHKmmKfX567wsTzLFbh
	 HIFt41w8MRPCUyJ/sYlG0I8ZfftXtvvPZfeAnCcuCg0WFZd+iC/Ii6CJv7pDdGNWcpMwC
	 e0BeCtzHe6lzyZMbWiTSMYqHyQwaF8FCE80a0DMIAJBoEMaLcmAdcuajQfTvAtpHw+/yx
	 82k5PtbLtcrM6mywOt4+NS1yZ6LZ150+Fi3go09ngPOCHgwAv/hBvKlA+T24AZPNcig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="wgzWSa/s";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D41606A32C;
	Wed,  4 Nov 2026 15:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12D41606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=wgzWSa/s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805140;
	bh=o3Cw2LxQFj/sOcaa0cN2pMz0x6px6mdmeBIG0Gey0zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgzWSa/s0U/zl/aKzHmYRzgzv+6XVlcMMkphvZpxpp+jiO0P0qVDbKtFoCmWpkrjc
	 hWWLo4HFyXbAoo80fONtCpn6h3bropcm2S5x73wnWKTZd9vK6t2Rmk0r+RgGOTKZjv
	 67kcGZUGrp9s27GGMY+Ei7PNtbhjvmLqt6V3Fd7sswIgi8lTCvDh4arS5jAxySaLRm
	 TWNf8QWxcmHo0EN3Elb3EYrHHYDyJlbYCc06hk8F7/SJ6KlBO7TT/cWZKO923J5kl5
	 98a3f3CXxfxItMZMqfy8M6hW3VXQ7aEf1AbsQ+qfP5jBPyXsVyvpb/QO0odE2DNgdx
	 91MDPYBC6lKPw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSh1sNSzKTG;
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
Subject: [PATCH 03/12] sched/deadline: Do not BUG() on a deadline task with no active CPU allowed
Date: Wed,  4 Nov 2026 10:10:24 -0500
Message-Id: <9cf4959749b84933fa506de5fc43b2dc0e02cd05.1793804635.git.mathieu.desnoyers@efficios.com>
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

