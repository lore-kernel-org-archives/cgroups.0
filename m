Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F7B4C6EF6
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721221; cv=none; b=CtzaoIxlXHufWWe9rwGi09B3n37Qx482f+7FxySCx7i1SRS3khCgWaHTnN+WQgqgg2OOQSe313u2IDZN49PFMcaIvxekWM9Se9opgcJ9/vmRFvvvJSleMu0u7HHzPam9PcD+fbcN9/PO1xvVfcKEHQt1KfVD74bxH9gbc7agh8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721221; c=relaxed/simple;
	bh=kCIbQODaPIFKjJj/fH0W+dkBFWKUA23nflhhqT1ggho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtRCu71MfZ5DVdrx7tg0vPsjKwBgzT7IcfHsW094kZEPfoQOBdpb6t36UVtv0Iv3DOokWwTMY/4ACHIdovH8aoytlClA0aicQVMvP3DUVLUXp7f8/FV6UB4YQqN7Cg0L85Q2N1SSTtuDnGqwWLKHcYg0OVcfMNRlKXQgg/uudZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pyHTGln3; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pyHTGln3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784721217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZarCgVr6XKsuj6RlRk5qNVeMs/1XC2cyTfQWnkNpbBA=;
	b=pyHTGln336t7kNvG9iLgbqJrrpi7Yc8EBmesFSJLVvA39EZTL94SZN5g+3XRFTyMQtxjE+
	uFUD8rgOhDhANHhtyQ9yj6khGEGui4r5FoO8/rgbVd2EYQl4Ns/F0AhzakHFd0VBPJlUMP
	/Or00ZIr4YMGRzD9dzcix92FMUr7FaE=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [RFC PATCH 2/3] sched: Allow isolated CPUs as a last resort during CPU freeze
Date: Wed, 22 Jul 2026 19:52:37 +0800
Message-ID: <20260722115238.351821-3-guopeng.zhang@linux.dev>
In-Reply-To: <20260722115238.351821-1-guopeng.zhang@linux.dev>
References: <20260722115238.351821-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

task_cpu_fallback_mask() normally excludes domain-isolated CPUs. During
CPU freeze, however, every CPU except the suspend primary is taken
offline. If the primary CPU is excluded from HK_TYPE_DOMAIN, the normal
fallback mask eventually contains no active CPU and select_fallback_rq()
can exhaust its fallback states.

When CPU freeze is in progress and the normal fallback mask contains no
active CPU, use task_cpu_possible_mask() as a temporary last resort if it
still contains an active CPU. select_fallback_rq() will select only an
active CPU from that mask, while architecture-specific task CPU
capability constraints remain intact.

Keep the normal housekeeping fallback while it contains an active CPU.
The temporary affinity is preserved and restored by the preceding
change.

Fixes: bf5b0c27fad2 ("sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/sched/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8160d3287ad9..5f8ffded1a20 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2806,8 +2806,10 @@ do_set_cpus_allowed(struct task_struct *p, struct affinity_context *ctx)
 static DEFINE_RAW_SPINLOCK(cpu_fallback_lock);
 static bool cpu_fallback_active;
 
-static bool mark_cpu_fallback(struct task_struct *p)
+static bool mark_cpu_fallback(struct task_struct *p,
+			      const struct cpumask **fallback_mask)
 {
+	const struct cpumask *possible_mask;
 	unsigned long flags;
 	bool temporary = false;
 
@@ -2817,6 +2819,11 @@ static bool mark_cpu_fallback(struct task_struct *p)
 	raw_spin_lock_irqsave(&cpu_fallback_lock, flags);
 	if (cpu_fallback_active) {
 		p->migration_flags |= MDF_CPUHP_FALLBACK;
+		if (!cpumask_intersects(*fallback_mask, cpu_active_mask)) {
+			possible_mask = task_cpu_possible_mask(p);
+			if (cpumask_intersects(possible_mask, cpu_active_mask))
+				*fallback_mask = possible_mask;
+		}
 		temporary = true;
 	}
 	raw_spin_unlock_irqrestore(&cpu_fallback_lock, flags);
@@ -2842,7 +2849,7 @@ void set_cpus_allowed_force(struct task_struct *p, const struct cpumask *new_mas
 	};
 
 	scoped_guard (__task_rq_lock, p) {
-		if (mark_cpu_fallback(p))
+		if (mark_cpu_fallback(p, &ac.new_mask))
 			ac.flags = 0;
 		do_set_cpus_allowed(p, &ac);
 	}
-- 
2.43.0

