Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655355;
	b=AKDOjNN455SIT8Hj8brcbyq5jGdFX4q5UfH88lA08rbXAE1Hqxtc1agmuFneXEMiJIlQ
	 7zzZ6iEF37jwbL7yTGgf0RYSXMpPWJD4ti41HpZ0FC+5nuCLcHd3wkyadpzC+5w+ZhLoY
	 K7+XgcoFyiedzbTfrwypb4avG6oULX+DTH4QAy9d2lcJNVpuUWat0RDE7Hl1Z2f9wJnHm
	 UudxHmkeorGxW9SHeVW8sPsqar7ownLbgHZna6jLHkF8x9xT5LkXeA8s5Gh4gjBaFrLVA
	 mVqRXy6kTv+h4zVCfm8KONMUV7RiANFgubFxABgCj4sHZs7SHfZ7QGbTzN7sWTzlcAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655355;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yEFo8uMJw19LKgsB3cspTLqhRiPTeh3thYI25Skdjvw=;
	b=rmnDQGRkgxSbjPfK0xgu8KW9dUpm69TRF8R0w/xsrMBcJ2JYHY00VMXX8HxfmyTjODiJ
	 LMQljXmkaSyyBYQ64GXEaZy383n2/Apz2DQRMjxft4MpFQsMQROijeSFRmBuR5ZqJVglB
	 kyd6eE/ksYsPJzmqArXP9DfkzKANmt09rivAXGTQMwuysep+QMcyS1eLIoZgOC3pA1bdb
	 9otKkae/lsEgA4j1e/ZNZVrp412NlYs4eZz8Of0drUm08esmDFVtGjlAPG17Cii6EWRRj
	 bGqVjah/GcQr75mLh7UQNvr5M2h/JMLgY8zx7/mltmdkOHCouPy46wrk9FIEwe15gWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NFS5w75f;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748F2606FCE1;
	Thu, 26 Nov 2026 01:09:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 748F2606FCE1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NFS5w75f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655354;
	bh=yEFo8uMJw19LKgsB3cspTLqhRiPTeh3thYI25Skdjvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFS5w75f/f/Hbz7OK3cDJj7/+3C01lQGCjuslG0IR2LU/DdQurLw/RlNN+Oe7mS38
	 CnPGBT2WRIL3NDZPZYW/GG0zauQ8b0Ss2Qxb2t7w4rnRpF60qlnqJEVuXg+AFenIW8
	 PySl3ereldl4YLpD0VwJN9QYGAeh8cSISiaxiGaac4bgSVEOnVCAu6262Qpo6ILCva
	 NnYYnFsXbjoRhUEgE6JXIglWCiUGt7Iq+Oyj3ujf9WCaqY7WiY2PECd4BafAa2UiI2
	 Ufi1WgI/yF8QLcueI7wA/nfRFzfLTr+Yp8vZyGed69BylT/EnFIWRnVmiqxW9Gc1je
	 p2YCXTRc/INJg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjk0861zWWF;
	Wed, 25 Nov 2026 20:09:13 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v11 36/43] sched/deadline: Check the runtime of a task that comes back runnable
Date: Wed, 25 Nov 2026 20:08:35 -0500
Message-ID: <a92352cad3728d1a613b37d26ef275b9387ebf0e.1795646914.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
References: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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
this case. On v7.4-rc2, a task of 50ms every 100ms came back through
SCHED_OTHER with 10ms every 100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule to a task that enters the class
runnable, with update_dl_entity(). It starts a new period, or reduces
the runtime of a constrained task, if the runtime left does not fit the
new parameters. The task gets no more than a wakeup would give it.

The return_running_new_params case, added to deadline_bw_test later in
this series, tests this. It fails on v7.4-rc2 and passes with this
patch. The return_asleep_new_params case tests the wakeup, and passes on
both.

Fixes: a649f237db18 ("sched,dl: Fix sched class hopping CBS hole")
Reported-by: Juri Lelli <juri.lelli@redhat.com>
Closes: https://lore.kernel.org/all/avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6e4edadddf24..23186eb9968e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3159,6 +3159,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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

