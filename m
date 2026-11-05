Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907260;
	b=sry6fpQQezU+h0EdYSRYGjkOmyz7NHUS/C/Q6TOIXjkbJqY3QWqKzw6cQ83WNm3XuCVG
	 SLyR4hDDKMAK8vYab9WZO/VWvnCD8T8ylU5UHHmAwdeoR+WL5OlE70NDGenH5Vjijg8XU
	 pDIR0c3eJwxU1oIkEj3qTC6WJQLj257EnW0nKndzVZ9uWOJWZs8Cqh5QYX4EnRXuMj+UY
	 h7h1Jvxf0Cp14DSGAKATp5+VUqkmYy3hPtRQKhu9DAoI1NYNKlvuPLDZmoNyx0nSpYssk
	 nsos5LVUfSyKeph0uK1dFDWigJ699uoVr6Zcr7tPzKGAjC32nuRI5+0EPB9pZObNNPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907260;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9xcKHMbn3SsYLrcgRVCN+uYKxdH8XYhCdsy+dXlYLgA=;
	b=rVfOFRxcMpwKg8KDRuJ224qM3RpiTpGe5+F4E4NBv+CZ4tMUJ06NZoohrySvstRGPTlK
	 6NOtDfv/yM8GKmG6Do0E5VstLD1uK8rYNcxShD2vHlmxnLDwdzbx9uWhJb2LZEguLbLzk
	 7dHQeqN4jANpUUhzAwiY4hZ1hMr1LEZFzjLXlhTTVxOE9QTvUY/ac78zK1CUwxWh/sp77
	 rwSH2houii2AcYNM30bc8Le25BJ70d1EzGGjTq7s9CegFUImCMH97ryR+JGFywwtro1Ae
	 EF+FwntCSrDLjfUXmANJt4jlnJ/1w5KATI3mVD17YfCD0N1Sq87WKVg2O0uKOe1X3HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=T3Y2FqCm;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF58C60A2611;
	Thu,  5 Nov 2026 19:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF58C60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=T3Y2FqCm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907252;
	bh=9xcKHMbn3SsYLrcgRVCN+uYKxdH8XYhCdsy+dXlYLgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3Y2FqCmR8Ff1NGspV0s2QL4Ofq2YBYPDEBhyEuWSZzWYspvomB1y2OD/y0AX/RoJ
	 aQ8pxHH1F4/0Yn/8i0Zu2eFtKoInygXHy2MewI8XnmqtevneJg/o5AjmEVaF1Rh86i
	 kpXV+S6rVdHfHB9rXYtfzwjBtlG1HPejMXUm8+TRZWADazBb9UZ5nLEXZ8IV2By8J6
	 PMy3jD1RQl5xnwa9DzAcik9sCaLbpPdAUbTh7SPYP71xQQdQZ7OVk62Mq/gQvFYylt
	 cUkzEO8hJvxOsbCL7pkT7sfEGwc/m8f01mVoHoLkoJnA8dpYM6SUI4UdKTrr3Gw8oq
	 875HSx7K4kruQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDN2YBbzLkq;
	Thu, 05 Nov 2026 14:34:12 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 21/24] sched/debug: Show the deadline bandwidth of each runqueue
Date: Thu,  5 Nov 2026 14:33:56 -0500
Message-Id: <20261105193359.1450487-22-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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
index a4ae092e0a68..c8a2cf18fdd1 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1171,6 +1171,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

