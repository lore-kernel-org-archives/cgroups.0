Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115241;
	b=us2WjWaBomvIu7Z98sJZtHEoIPDavAEfkyD3XPPIFBq0h9qz20WgW7j6puXab5F2ntey
	 OZTI3/G2xfYVz7NIq20HbhZAwS3AQqGnO+wswSv1RJoUjZ6yZppM8Xmc/Bfr/sKIVjj/p
	 D4JJvqmgk42c9e5brDuy8/7caj19EouhO3pISV1Df9kMQafTegYL/wCJgufS5oF9UDxTX
	 vDa7P8EdgKT0iA/qMfh4SHmgO1psHFRcSOikK8k2dSOecPO5S9gaAuDEcb4viiz1fLOcw
	 ZbneI1altk1STpsNDRfTNmYBiZiMzr2Dc05CPtsVnnC/T0ZaEv0oJqIbvw5owz41njA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115241;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	b=Z7Y9wTnxUR2cdmLBMGYYks/o/mhhJHS4Vj6/kpK4fk+XqTULLHNU5HI5tjB39Bvs9ebf
	 P//qWAnWUdOaQvulP8D8lHwcdip/IsInI/draByoKZCdVDXpGSes7mZxYMKwFTW2ql+VH
	 MVetfAw1Q5kE1wlytgds+k/vBUJ5RruT/27Q9/W3tR5nbRER17gBy0GLqRvgSOChdFkiW
	 8j5viovlJt8Kx38mAXc18hQ2wyS5hTn3buohnYeO2UH3KxprEU7xsIwgZnsQyFqkjZLqC
	 d0vYbsWpqjKa6yj5sj34SCZcUgDIwbv07IVVnFaFZAmcVI6Y3q5OIxhG1OlrfxTIE3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PwKWQwz2;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B3F60A3839;
	Thu, 19 Nov 2026 19:07:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73B3F60A3839
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PwKWQwz2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795115239;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwKWQwz2FcS+cokmdzsoUv3ZTM4iCh8J7kI4aBSl7f/Qx0MOh+HZponEmPYKUQekj
	 7V9FYBJIkILDdQ7pHPaZhW1Al/tAm3LuaPRaKJQZRKtrQOlTylgVLBmt8fnvY+wgFf
	 vU1HZndDQLBllwOuWWRyThdbfh0gLHnWfFmzje+zaZBSJup2kOn4MWzlTrDJ/C6uwS
	 EK+d8rs9nhgRRT66wth2g3eswXotzlTQab3xPGVyur19aPBRuR9OOOLhHrlngrFB3x
	 3KDn5L0IVQQZVLeXdPX0np8XcKCwCOki7tkayyTex4dvfz4k8cafpZSpWyf6xMQDTn
	 jNulYR2q/aLuw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVnyv40ftzSBP;
	Thu, 19 Nov 2026 14:07:19 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v5 15/17] sched/debug: Show the deadline bandwidth of each runqueue
Date: Thu, 19 Nov 2026 14:07:12 -0500
Message-Id: <9a7c654f9a8abde626f2c0e3072d874b2f3bfe41.1795115075.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
References: <cover.1795115075.git.mathieu.desnoyers@efficios.com>
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

