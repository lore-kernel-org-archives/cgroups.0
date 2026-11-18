Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037120;
	b=JuJ35K2EuKHUpp3ruuwdsRvDT/mLiSoC0xb0TbQ+wTlTV6MSYzGf5j3wotk3Ny0zJ+P7
	 pjH9xxnS1JedRS6qgCh8KGvwYvSRb8FQqTutIRXlMSO4gkLKKLQqvyiWwtFt0aPCMrNn5
	 F3mUOc5VgCV3DqTImn/bhXoqJdC7/IT8xPKjz+QxPo3wg8cboDOa1UdVIZQnKdLA48UZB
	 K5Wy3p3+LxN0oAectdo4GoXa6y83BrHwq+bjxAiX1cHREFOppQuT1CCAOFz4VC3xJgnku
	 kS5rKCmropRtuCfYPlOiBYf0Q4OIiMBHdooXCt7dyhMvb0ZRfbM+zTGAVAa3NB9fIYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	b=Y0a827VR6eZGpPB3ficLnhY/Wix1J2ybh0EgrsECheL1S7NnRCchPtCuhQmJffq2NoWt
	 K/cdB7Zb8+VfE5h9KBZfJ5/+yyVNvjCt2EMV+Gu3OahQMxcgHRGc5TlDGPKAW0o9W8b+D
	 IU8C5nLagGYENcY+iFdRKwOpHAeFz0sovUSVeDPTpg21HKZDGWaZcmrn63qqdt0eg1RQP
	 dss0huJG77rX0dxKEBBKSX7lEYk7nm/WOVyJbakdjLaAfm95wqhN45mbVU1+5/djbqiE8
	 lZVyp9/w/AnAsyoZpELBMwDBrswcZCFQ3NeoF2EzQakplunDSs9qWSly4BAlJtBafSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bbq8vMSD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B6760A5BE5;
	Wed, 18 Nov 2026 21:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1B6760A5BE5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Bbq8vMSD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795037118;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bbq8vMSDPZh8j8MkXQiQIVqF9QqnZKy2+JGCs1vH9tj0Z3JfUrhVa0oEkgtgUmLAG
	 ay5KqVcv0lPqQl1kOu7j2A0dwcjLJWmpvqkoyT7ua/Ifxraqeyqib10nxrPCuiELHV
	 834rkwdEPDfBrF4uoIdMYByK30j7fvk6SMyXBvrEIpnBhFOuE2AfTXWZfQ6WYrYoSS
	 ugR7iny5xWxk795W2Wv+lPRuLkCQ3tVKV1uPtDB9o+NqErYCYaw8FCg1yzieFsixSm
	 OboxJm4I8FG50wM/HrH6nPsX4fDfJBUjoXMu4brB7xK/K1VpKw0RHmikEkeWm9su9B
	 WDnk7l9nS4gzA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVF4Z0LFrzSGH;
	Wed, 18 Nov 2026 16:25:18 -0500 (EST)
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
Subject: [PATCH v2 14/16] sched/debug: Show the deadline bandwidth of each runqueue
Date: Wed, 18 Nov 2026 16:25:10 -0500
Message-Id: <e5539bf182028d7a1f13c579dc5edd4bf364048e.1795037078.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
References: <cover.1795037078.git.mathieu.desnoyers@efficios.com>
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

