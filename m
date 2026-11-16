Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855970;
	b=5hI/SG8g3+ydoKOh3YZoFq3HecnWLjeh1kWrExaGwT6WSD5fmSvmQV2y9O6xxUpJsx/H
	 ZVLREiDi8ss+/W6jJHFyRSNXDhwfjU78NTB1WKrIl0sA3oyrNhp/sayRQxDLsUAT5p3+W
	 hL8D3lWwXbSk4xwpiCOxRntq6oBXEsNXNsaey9Vxn0DcdljaNim3FKtp300wopqoozwCa
	 sRZnQqmkfllGRCgyO7CLIzmD0Asr304bmdO2uwFAuW+EpIPrRni1DnLMI7/QWbroVIZsc
	 AWZY8gVe3qYDGKA+xHIoPQtUMbxCEP4x8N8oCMPF2R51YlKuvmI/gOaAYouK+WNOyZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CewvABXbciGJVQcqqR61AyfK9UpxpPEaIIe1bjYIC08=;
	b=VGqp2l/GhHkuTZQVGy5m4gMLJ+uyoW6nKAmKj0fjstq9d2tPl/lkQukFDyDwKEyMd8+b
	 pS+VcaVXa8p25vNdUBgv8UcwyHJT05yBQcfVsmLUOzjZv7tcBjLvOtk6LtHj0qMqsoezZ
	 Bp82uQoRhtUM2feXuji1onmAItvbJBEZMuARTYoGh9aiTBwc5Asq3F9Bs7fmuFJ19D9wr
	 a16eF4BNUjyxWevhJmyhiKmQNL3fsl7QLTDlIuWYfESjaR0OB7Gy+P5MVGpgQMK8QoVzb
	 dizZ5zlqCLmOag/U+dBPCGEInOu07KSeuvli/SnlmRaJfYeb0N9BIhHcDb+nuwBaEeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=kfej3n2j;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7460A380B;
	Mon, 16 Nov 2026 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50C7460A380B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=kfej3n2j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855959;
	bh=CewvABXbciGJVQcqqR61AyfK9UpxpPEaIIe1bjYIC08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfej3n2ju94tSynC8ZtXH497MYUFfOpTSNuK73gRyniZKI5oAKQ16xO3Nw1ilqUMt
	 QasfHsQjXW6jzYAwhWPZ7OimhB+PZFjum7T/Yl6Bd1smaSc2dRV/5J3511CMeDmFyk
	 NRO6rfSt7ZiTRSHnbW3RSYO8JfivdK37jWZ14tE4WOmzy0c3OQqiM47CpM1UbHFtid
	 pOtTkTcHF1aKxcK5b+mEadyB2qEqyH/mHQggOGMr8kbLlf7A0qZzropO/Ivr5cdYJR
	 T5uRL/VVmmgkJGmi7d6IzpCl2qNYGMBBGKt2D2Z2nOYdmi1W9j3PfY0TPZepeltlhT
	 LUmxtq8AKHcaw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4l4YhRzQtl;
	Mon, 16 Nov 2026 14:05:59 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v6 32/37] sched/deadline: Check the runtime of a task that comes back runnable
Date: Mon, 16 Nov 2026 14:05:44 -0500
Message-Id: <20261116190549.230119-33-mathieu.desnoyers@efficios.com>
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

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole")
keeps the runtime and the deadline of a task that leaves
SCHED_DEADLINE. A task that comes back before its deadline goes on with
them. So leaving the class and coming back gives no new runtime.

But the task can come back with new parameters. If it is asleep, its
wakeup checks the runtime left against them, with dl_entity_overflow().
If it is runnable, enqueue_dl_entity() starts a new period only if the
deadline has passed. The runtime left is not checked.

So a task can come back with a smaller runtime, and still run on the
old one. Admission control counts only the new one. Juri Lelli found
this case. On v7.4-rc1, a task of 50ms every 100ms came back through
SCHED_OTHER with 10ms every 100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule to a task that enters the class
runnable, with update_dl_entity(). It starts a new period, or reduces
the runtime of a constrained task, if the runtime left does not fit the
new parameters. The task gets no more than a wakeup would give it.

The return_running_new_params case of deadline_bw_test, added later in
this series, tests this. It fails on v7.4-rc1 and passes with this
patch. The return_asleep_new_params case tests the wakeup, and passes
on both.

Fixes: a649f237db18 ("sched,dl: Fix sched class hopping CBS hole")
Reported-by: Juri Lelli <juri.lelli@redhat.com>
Closes: https://lore.kernel.org/all/avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ffa8b946e804..b47c13c8714d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2723,6 +2723,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
+	} else if ((flags & ENQUEUE_CLASS) && !is_dl_boosted(dl_se)) {
+		/*
+		 * The task enters the class runnable. It may come back before
+		 * its deadline, with the runtime left from older parameters.
+		 * Check that runtime against the new parameters, as a wakeup
+		 * does.
+		 */
+		update_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_MOVE) &&
 		   !is_dl_boosted(dl_se) &&
 		   dl_time_before(dl_se->deadline, rq_clock(rq_of_dl_se(dl_se)))) {
-- 
2.47.3

