Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032412;
	b=QB/S3lYIO+jSWpezl9RFP/PEbPk9bHQt4PsJMQVC7nBlgGBKVFeBycItGyQN/a9kiIiO
	 xpFLQc9OENTI4ki/aS8hbJ9q8t5URptT/eQO53LJhpRhe1RbFb1xpdNiWfMh2JkQDRh0T
	 BZjTPnto9V0Bfe57AVecgT8BKqIs7yu2FMajCfWpK3FxdX9Y77xX8xLnU+UR/uIwfpAfA
	 789VmqiGujbbmmQzEsPN+l+Yyj/Au2XqkoumcqWqWM/4JjIp1ovMMhpc2TSINjwKX6veH
	 wxLodvmDet4LwOcoKbVllyyR6f1g5PwN9rKFj3ZkRhqZUPd+Mx/1VKIHLvTDNU1dL9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032412;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	b=F5LHGE7oHlkmu6me4NU0a7FmQY2WP9oK5wkU5TQFBpa+hytFxFB0tpHrMivJvaavKAhO
	 yCSpPnc0fpajvHRTzXhPYNGMSYSolUCh5e5D6HxNfdE2x5s+RJ8QWPPVJEFvhBUpuSexj
	 QxCekeIGJabfYCL11PbLDn6v2ysXLarw7HC+W5iHbmF/vidfOzOWXuUI/P7LN/OrXntpO
	 3KLc/zsrOgPkuKt/sWpyjTjz6jxJvR+EnModXrkcJz7n5HFVXOquIoZa3XL0KA/w+apFt
	 JE+t3DsduGJY3d7Q1u/K+6OnMBqEYdLb/CaOJG+QmEyZa09UDIlFLWo2uk1Kqcp/Rhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NJIARl8O;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118360A3813;
	Wed, 18 Nov 2026 20:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4118360A3813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NJIARl8O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032406;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJIARl8OD2eibOjqLlwf1B7aPpPPxER49yLVp43jfUKa9763yyrqJBVUNSfAabddv
	 RREIh4N7N/OQnz7fp2Fetjf0DTAdPRDOp5zI6QWsy/SvqDMBqupNTsHm3rYPMrOV9i
	 vC7ui8n5wQzk61fgBBU+fT0et5dJuRS+rbC548ao+bXOIP53nixWVL1o+HOdQ55qNp
	 9PsNc/x5XNPIeHr+6RdyTiCrteZ7+Fhutl+HFxBr9tu63/Nt40dT/AiR4oImUwKOVt
	 UcsrB+Qd8Hfq7dQxM/3FV1f4jTZAC0d54T36NqjiNxWH1pkWTcj0re3DTxvkgJ6rkM
	 oSntgWuzwUucA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKy12vvzRXX;
	Wed, 18 Nov 2026 15:06:46 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 14/16] sched/debug: Show the deadline bandwidth of each runqueue
Date: Wed, 18 Nov 2026 15:06:39 -0500
Message-Id: <e5539bf182028d7a1f13c579dc5edd4bf364048e.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
References: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
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

For each CPU, sched_debug prints the deadline bandwidth of its root
domain. It does not print the two sums of its runqueue. this_bw is the
bandwidth of the deadline tasks assigned to the CPU. running_bw is the
part of it that belongs to active tasks.

GRUB reclaiming depends on both sums. grub_reclaim() takes this_bw -
running_bw as the inactive bandwidth of the CPU. The more inactive
bandwidth, the slower a reclaiming task uses up its runtime.

The kernel warns when a sum wraps around, and when running_bw exceeds
this_bw. Bandwidth left behind in this_bw triggers no warning.

Print both sums. The deadline_bw_test selftest added later in this
series reads this_bw in its params_waking case. It checks that this_bw
is back to its first value once the tasks of the case are gone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ddb382df454b..2c373adf3196 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1175,6 +1175,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

