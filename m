Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826738;
	b=iXY2O/oG5z23VbGNr8lugsB2n4O5STaTS9QIMDb5bkf+d7d7nvM5eJk76wM+9b+DC4gg
	 nTLYoQ9jqo+U5oa0v1RQrRuQA7cBU99JlWcwGWMb1onNY2GW8R3WVw79465+WVcRrcvdA
	 WgF3YKTwUwol3lOECIrap8gsxeujaW9fgJTltXlTcgafuoGVdtjIaAdoUK6bx21EYWtcv
	 nvpShmThEl4nIWeNc+NTBsW45n/I4zKouk5klrMcfVZR7WG80zJEGuui8I2twL/kLT69Y
	 +nvBRyh5zXK7mMsleMUc4cuN2nNmlBoxT22vTmTr7HNurZ8Ea+Hs1nY+SHa08XP93iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826738;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=V1VyVBpFyRi1KFcICF9WwDIGHHyfRNBBNyz2t2PbIDk=;
	b=DbUfsjKtjv2CEzeqw4LR06AzeegZoaVL6eBtpXTW0JEvCokkU0ok2wWI5GISwp6ZPdXc
	 qOpT2kra2vtWOmAXhdaSoWk37Iv2B36AVvoN/tfGt3vWurDAjvpETA/p3/jv8GPArDAiA
	 +59RSiW3pRmfA6D+yC7fh2Z2Q7tkACQUO2DArUJC43Tx3qSGN9AZBIGplxvvbdXpY/3s/
	 +Ou1L/ofhTeM6AVCcHYBMqrj6p3VZmdpeUEc4vVwOLANr+JyTYqzELA4ED7dzX0ijbj2e
	 uq1tEGQD+I3j3QysQwMhEY4ndU8z7af1rZGVbjf3wlpkmU3t/7TkrOsKLrrE/0FasWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vyBe6v9H;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07566084180;
	Wed,  4 Nov 2026 21:12:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E07566084180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=vyBe6v9H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793826735;
	bh=V1VyVBpFyRi1KFcICF9WwDIGHHyfRNBBNyz2t2PbIDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyBe6v9HrSHiJ2+ONznyEaktkg6smEuvKRXkaP5VvF6KazFa2WksGwZVfs5kMSE5y
	 6dtncOLsEGHrB4ZB26WlTa2OOj8C9DHmgpjBBWNm6ModNICYSNZMfMT/jTHAW689t8
	 QiUgAIrVYBfEhmXP4U5TyvNvIpsvpr2fsIcFzxl76B03c17sVnvOVj8oXZds9EH1KK
	 JWpXytYgYEXg+11JuwoFfNw0NBg2+4B5EbNlzFnJU/jABH+rXhNPuFninQj60+G1TH
	 9OkZMkr+ab4nAcLfBGf2WS3e5HT9/IFo7/+bMGqZl8VPlTA/HbxGDamIKhdVy5zCNm
	 D1rexeVZu+I8w==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKdRz3NnhzKy5;
	Wed, 04 Nov 2026 16:12:15 -0500 (EST)
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
Subject: [PATCH v2 18/21] sched/deadline: Credit a rebuild to a CPU that can hold the bandwidth
Date: Wed,  4 Nov 2026 16:12:04 -0500
Message-Id: <20261104211207.1392343-19-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting takes a CPU of the task's
cpuset for each deadline task it finds, dl_add_task_root_domain()
through dl_get_task_effective_cpus(), and two things can go wrong with
the CPUs isolated by isolcpu="domain", which belong to the default root
domain:

 - the cpuset of a task that may run on a housekeeping CPU can include
   isolated CPUs beside it, and without cpusets the mask is every CPU
   the task can run on. The first active CPU of it is then an isolated
   one where it comes first, and the task's bandwidth is counted in the
   default root domain instead of the one it belongs to. The root
   domain it belongs to underflows when the task leaves the class, or
   dies;
 - a task confined to isolated CPUs has them all taken offline, which
   nothing refuses: a deadline task of the default root domain does not
   keep the last of its CPUs online, dl_bw_deactivate() asking the root
   domain of the CPU going offline. The rebuild then finds no active
   CPU for it and BUG()s.

Leave the housekeeping CPUs of a task that has them, and leave a task
with no active CPU out of the rebuild: the generation of
"sched/deadline: Keep departing bandwidth across a root domain rebuild"
keeps the release of its bandwidth out as well, so that nothing is taken
from a root domain that no longer counts it, and the next rebuild
counts it again where it can.

Found by the Sashiko AI review of the first posting of this series.

Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 029ec2ba5a66..c0af06d0f368 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3617,6 +3617,16 @@ static void dl_get_task_effective_cpus(struct task_struct *p, struct cpumask *cp
 	 * hierarchy up to the partition root.
 	 */
 	cpuset_cpus_allowed_locked(p, cpus);
+	/*
+	 * Which the CPUs isolated by isolcpu="domain" are not part of: a
+	 * cpuset can include them beside housekeeping CPUs, and without
+	 * cpusets the mask is every CPU the task can run on. The first
+	 * active CPU of it would then be an isolated one, of the default
+	 * root domain, rather than one of the root domain the task's
+	 * bandwidth belongs to.
+	 */
+	if (housekeeping_enabled(HK_TYPE_DOMAIN))
+		cpumask_and(cpus, cpus, hk_msk);
 }
 
 /* The caller should hold cpuset_mutex */
@@ -3637,7 +3647,18 @@ void dl_add_task_root_domain(struct task_struct *p)
 	msk = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
 	dl_get_task_effective_cpus(p, msk);
 	cpu = cpumask_first_and(cpu_active_mask, msk);
-	BUG_ON(cpu >= nr_cpu_ids);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * No active CPU to count this task's bandwidth: the ones it
+		 * may run on all went offline, which the CPUs isolated by
+		 * isolcpu="domain" allow, no deadline task of theirs keeping
+		 * the last of them online. Leave it out of this rebuild,
+		 * where dl_bw_gen keeps its release out as well, until one
+		 * has a CPU for it.
+		 */
+		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
+		return;
+	}
 
 	raw_spin_lock(&dl_departed_lock);
 	/*
-- 
2.47.3

