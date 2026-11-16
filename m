Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855973;
	b=zd2robAtwj1fB8tiR6xEa8tU5X3WedFYjMS+K0qpu0dOqOS4tge3/BV4j4lorn3gfEq8
	 Qai3WqkXxNtXk7kTnXQOLGSTPwco8TU3O/+PdSEfXq4oAqZMhL1jFobNNXPG2qLSMA368
	 aTg0WyOpKWb3+W1y2yFhngRIvNC8lC3DtnCfL2c6VjPz6jS2NNoTQcCRfJptmuFTZjNdY
	 9z33VOwfrY6NIgha2J6hkyCVfpVBFmHbvwijqBI/ZnbUyAnDpiLZYTsOclUmW6+ocwg3D
	 jTIBX+41GVqJZoatI7Zp8SFG4p5aliCmDyvG0Gc/Iyv7yhoT3M8cK6awNDbyhl5V6AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855973;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	b=UKWtAbvfbEHagjQN5ulbhsYWgeOaDQtfwnQ7gLxGY8eHy4AabF7WUI+C0MzwEIBs5XNe
	 KsY1APxf21Xvg8KQ+QE3IQsDeMXbeMx1EK0B8QFqotPXuuSrnW5ks1rJlCAQgNNXYwBpC
	 VfjoRqfXTdY8Mhil6NHKvFl8VBgv/mw7e+FvUhb75DbEPHKW18oXubsp03zCifWUwaRN1
	 mZaQ5u0pHQIuEZiWfeG3AZenqU2dY5bde/O86iD9/yrPsRf0a/zNgwVZc9inSYu2jZzVt
	 F0p0ODr82ajePPXVQTB9Sjo8y98NPS8XtLa1KHGZOqzFqRBAMT44XhUYYdqNWmNaKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="w/BNoDEE";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31B3606F162;
	Mon, 16 Nov 2026 19:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D31B3606F162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=w/BNoDEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855960;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/BNoDEEg6J2jdVGyxymjyYtSGOYqqlaoDv2RU6acNEa8OXmKpdJNA+kg5LafAvk4
	 U03Ome/UmX+Yz7qynZRBcfxxSrKBsbyKwt6+f9NME2w6H/gCmnbHbG9Q+BRlJSfQxs
	 Hy5f0Z6rv3+HiB8/MT9hqlzZbny3OpOHNUxZUe10ptXursxa2qwUaKdcO4NcLwAL0l
	 Vx+pNYnGRdOeuq7yOkKCcQK90YZ3B1/1IazJt9mSZGuXxwnpIQwnY2v77b51iA+6r+
	 wYcPoU5NW8ZI676PQCkiNBNqSHkz/+Tjv0j3tEmNNKWMbIkklWNpBQF/oUWT8qN9e0
	 lnNI61fnSUXhw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4m06MHzRM9;
	Mon, 16 Nov 2026 14:06:00 -0500 (EST)
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
Subject: [PATCH v6 34/37] sched/debug: Show the deadline bandwidth of each runqueue
Date: Mon, 16 Nov 2026 14:05:46 -0500
Message-Id: <20261116190549.230119-35-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
References: <20261116190549.230119-1-mathieu.desnoyers@efficios.com>
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
series reads this_bw in its params_waking and random_mix cases. It
checks that this_bw is back to its first value once their tasks are
gone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e0d6cd3bd607..3dbe1d7d2d77 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1174,6 +1174,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

