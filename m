Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015909;
	b=ITF/8U3zqrd8Pp4OuDcDL1e0s9BI4oijk5pKfFTjsL6Z99FMHAeY+iuSftybgpYcxA7e
	 ibRUnvcZvk94/uPe5iT4Y1jWArsvX0HiI+L5X0bqg84u0JSUZPa+ay6ZozuYHx7SAgQ9V
	 mOiJVOp5ksHthlnu3L7NIVWorldJ31vJ03lrPGBSgdZyeFDeVpi8WOmG+1wrvX/WYnoqG
	 L+HISZCFsZ8Dv+m74sPd4oEcz0pBk3+l6ofROYi5qE7xUQopwJkfHYGmoFxOBdj7mLX4M
	 TDh2p1d9oXI815eYuYekorkpzz/HQnPI2FqUu4y5KqJ/5okorcOcVEWL85SaTYBtb6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015909;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jaFm8OyVjpPaxcIZbvFKaesEcny64h/xIcDTESD9ZJo=;
	b=S1rQlnnTVfGR8Jp42cg7RwhKe6RCu0ckt0MeCwCOt1zp418Z742Yl3fY3lypp0qtoFIV
	 vyIFrUxY2aXKZIcC7s+5H2p1M3SKMLSGOuEbfg6ZkN6cblyijWn2fYLIOSXIt69geIHfF
	 AOB6drMIEBmrXqYi8HLoNEOYC7ZcFwP6JR37oaGwz1cAfmKvt3wbJrZJ5D0i5k5qzLYnH
	 fJIZ/wxjaWNoNlTRdN0NO+71XwJdPaZ+SDyGKlfx+c5sc7/8rdbIoJwfLJfaeyx5zIFAr
	 gtZEG6yMCejQCd/SmCAB9tlcC3nQJxVhBzhRNDqCrlmaCQmFIesJuqH7q0EfU+admaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Dl+CdHBV;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93514606D821;
	Sat,  7 Nov 2026 01:45:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93514606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Dl+CdHBV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015907;
	bh=jaFm8OyVjpPaxcIZbvFKaesEcny64h/xIcDTESD9ZJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl+CdHBVGVgEvvkkqahjYX7nZuWLSDaXOxlwOCbXrTrecTwL+Q/AmEOxDVfLEHiA2
	 fCpVJT76R6uv0C3o+rUrotiFUfjg0qpRI1ufy30EtNc9HjqL++9yUqDvFJxqNf7tVl
	 880DaYHBCSpEs80Z43AL+nYk8p5caYj559Bwvuhx1Lhy7SU32nr1GAes1PhEw92UVC
	 6Jzc/xCNETSf9Mz0BZSmygWUbqEWd21X7K9vx0aMfEeSMjTeY3fIH8I6jE3V6+JXu/
	 gyBgaQOfSnyaIEwP/LvaCTdwUF+lATS+qnOQrDvjQBqEjMIBINphT5McGVhUUMzHei
	 ei3pMn3xjvP8g==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPv4T2jzLxR;
	Fri, 06 Nov 2026 20:45:07 -0500 (EST)
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
Subject: [PATCH v4 23/26] sched/debug: Show the deadline bandwidth of each runqueue
Date: Fri,  6 Nov 2026 20:44:48 -0500
Message-Id: <20261107014451.1487825-24-mathieu.desnoyers@efficios.com>
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
index 5f8303630296..463f077fa703 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1173,6 +1173,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

