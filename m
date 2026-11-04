Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805149;
	b=oX2gXTaYhTyrwAvBpHtxoKr2L04VeScqm5GACCoQZTCDQQOhAY/C1w1CQYUBJv90zk1F
	 YzOra2TpqaPPOq8l8QmSDnVxVkEmEg64KtVE0M9NQc544FkETyUxT2oaA2SKhKzVdVKJt
	 8Z9N1YSbpQvFTsuxajQSqEkPUHQ4xCSBc+PB0Cnaft9vTmmtFZ/OyF3ebBNFw9QV2hX9v
	 yAMoPXfJ42apuXGiaTbRMsGXzbFlTPt/wN4vBp9jbu6LmLod+tb7hpXNiUx6c1gnmHX7c
	 JAXE8s4v0CYrBdYauFzWmmKrTTXLGTmRMkL2a0mPs1Tb/lgK27em3EwzH7AGRmTNEjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805149;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Iq+pznlnzu/qU50yyJxufWBiCcDbgVCSPC0v09LMgfw=;
	b=jLwHPjxPevwF25Zj0d+r3RT1XQRKruAp9AG8js0OV0EU9EJaillUDfrJMUzI7Kz1nB14
	 kLIwNdbviIva5dAXXRtcLb+WGrtyDH4jDOV6soWxRRQN9iGzkugGR2cvSYifaLzRpZtY3
	 StGu+WofqpbJr3kQtJrvils4LEj1tnFvdpAUposubYJrptRwllSqRyTfO5OthoYIS1rAs
	 ttmOR9Kgt5ffMLDLN1+W0NgCAW8h16nNbUDy2rTWOufwACdoXoOmCDWhvMzyEFD9pF+NW
	 N1q58s+G507wCZS8jnyN68AomoBlJfDQp5UrxHlmbUSmWVQ3yXKzsIGdK/A2UuPk9cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QGc1VVjs;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CF9606D820;
	Wed,  4 Nov 2026 15:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1CF9606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=QGc1VVjs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793805141;
	bh=Iq+pznlnzu/qU50yyJxufWBiCcDbgVCSPC0v09LMgfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGc1VVjsUdrN2U6dHi4+3xWa/riLF9jAn7MURij3IfJepBkFIdSTxdLvdG139CD8N
	 beAkYG/89r26wQmkUc2taras878FC/643wmlb7+EhiJFe/gchMzY9W2G010QDLM0zV
	 88y2nbxtdo0IMNYfLrkCV4yVLOXHn1kKqX4f5B31VfzeGZm3DEMdlBEIiK0IpkmFyl
	 ridJfqF7dID1rDvXO2HU/auzgs3KYRWbGB33pdR5ZjatFWSyYCaNQ1BXpjUalcfJjf
	 hykbZxdULm7c0tkFh7DwKSBZ02FCRkPSOGleYw2EY2hLjnCsdH9WVLuq06k9B4q3So
	 8teqrqBoFx0Zw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jKTSj2sLlzKJ4;
	Wed, 04 Nov 2026 10:12:21 -0500 (EST)
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
Subject: [PATCH 10/12] sched/debug: Show the deadline bandwidth of each runqueue
Date: Wed,  4 Nov 2026 10:10:31 -0500
Message-Id: <f67fc6f8ee934d03960de70fe5404072ea59e83f.1793804635.git.mathieu.desnoyers@efficios.com>
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

sched_debug prints the bandwidth each root domain has handed out
(dl_bw->total_bw), and nothing of the two sums each runqueue keeps:
this_bw, the bandwidth of every deadline task of that CPU, and
running_bw, the part of it whose tasks are active. GRUB drains the
runtime of a reclaiming task at the rate the two give, the bandwidth of
its CPU that is reserved and active (grub_reclaim(): max_bw - (this_bw -
running_bw) - extra_bw): the less of its CPU is active, the slower its
runtime drains, and the longer it runs on.

Both sums have invariants a test can check, which the kernel itself
warns about when they break: neither may wrap, and running_bw never
exceeds this_bw. Print them.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..8a726817baa0 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1166,6 +1166,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

