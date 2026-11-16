Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855963;
	b=xKNUt2aspUo0g2pP+tg7W2qgd6R0lKXVS73/cntzasgrB+FEcYXo6H7q9Mwp280j2RD0
	 m56VBz7JZ6IARG9YT691t/nZkx8maN/sP6xq0aAO0NA+7o/TcJpyGHD51CvrGjcUMk2LV
	 NcIMy76+39krf7ZeOndK8VMPvex1HHpe0aHNbXf0qFmwaQRfTn0eeM+nqpYd7gaw6zRmK
	 4oGeKeJszZjmvfkhcZxobzXuLH1nUUKxw+wKCDTXSnGZN50ZBWo7u9kgkjyNqDwwlctYd
	 VIb8dUy0CJnZXkS2ui2R0LZ9OzXicdiWc32gFjcKn2HkO5O1MU88yJn5ft5GeswkVPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855963;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=92AEzLw+pRmxtZyE4Naone75crazyPQ2ay8g0auSHNQ=;
	b=TdPHXI0WXTb3RLCDmYAXKQYHyPcvTrWiXRZ4z5a7MLzN57tp+gY7VsFdKGiuVPmQiXF9
	 Ue1H6lUuLghxxaC8cxLktPmdsENqIknSuB5Pdk6IgbNQu+FWxo+QcVaFLf9hGv447ZIpy
	 0LZ14kPUEVDP01Q7jM7yQ+0nuSThgJOv9q5cBQsLhgcKch7PBzhAyKyoXfzphK7vyNc+B
	 +7AR0xOEvM62/DU/OHqnVXw7/m1PIXTmL2Ir2gGUgq9qt4zNHwV0iM3X36WAGoMjEfp85
	 pySiGoqahV6wq4xe+w3sOK7aPHgWoW6oSZ1f0ist43hTiHRVYnaTGCdf/rqksHdXtKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UtqacUCQ;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415E606A882;
	Mon, 16 Nov 2026 19:06:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F415E606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=UtqacUCQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794855954;
	bh=92AEzLw+pRmxtZyE4Naone75crazyPQ2ay8g0auSHNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtqacUCQFY+Wo+PD9J//BTf3ncivKoBkshGqRnFxR+LT+RstzIbBsc8aHsze8OsdI
	 V2iPjK/y28GjEHz59se3LWHf24LYsD/PePSoMwcc+ZbOUqPDkGset7silk78Tr0GHj
	 lqR5TDiwxnCVXJL0oKg3pVpkHh9jQAl+tc9KHFdaCCVJ6o0eqs94py82m4sf5ZXEyO
	 P6KC48ZT/lVZB00+VHreI7c+uukBq0ADKUam0o7lqRZogbuTczAlz1MDQdA4Q5XrjB
	 Zupoj7b6QXQfLDBK8jyZDHWe1I1XHzmXJ53pEQHIFz60IGPvEC9GLMOFR6BWc/Uvcg
	 H/j/WAMesYVpQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jSy4d6YXWzQD3;
	Mon, 16 Nov 2026 14:05:53 -0500 (EST)
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
Subject: [PATCH v6 02/37] sched/deadline: Do not admit bandwidth for parameters that are kept
Date: Mon, 16 Nov 2026 14:05:14 -0500
Message-Id: <20261116190549.230119-3-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() runs the deadline admission test on a request
with SCHED_FLAG_KEEP_PARAMS. But the task keeps its parameters: the
call skips __setscheduler_params().

Commit f4dddf90d58d ("sched: Skip priority checks with
SCHED_FLAG_KEEP_PARAMS") made sys_sched_setattr() copy the task's own
parameters into such a request. Then the priority checks pass.
get_params() copies them without a lock.

Another call can change the task's parameters before
__sched_setscheduler() takes the runqueue lock. The request is then
stale, and dl_param_changed() takes it for a change. sched_dl_overflow()
would put the stale bandwidth in place of the task's own in total_bw,
and in this_bw for a sleeping task. But the task keeps its own dl_bw.
Its release at the 0-lag time takes that dl_bw, and the difference
stays behind.

Fix this by skipping sched_dl_overflow() for SCHED_FLAG_KEEP_PARAMS.
There is nothing to admit for parameters that are kept.

Found by reading, after the Sashiko AI review of the first posting of
this series raised the boosted case of the previous patch. Not
reproduced: the parameter change must land inside that window.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/syscalls.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 89b0d5787f45..6f8ce5fd94a1 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -690,8 +690,16 @@ int __sched_setscheduler(struct task_struct *p,
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Keep this check last. If a later check failed,
 	 * nothing would give back the bandwidth it reserves.
+	 *
+	 * With SCHED_FLAG_KEEP_PARAMS, the task keeps its parameters, so
+	 * there is nothing to admit. Such a call changes other attributes,
+	 * such as the utilization clamps. A deadline task does not use its
+	 * clamps, but keeps them for when it leaves the class. The
+	 * parameters in attr may also be stale: sys_sched_setattr() read
+	 * them from the task without a lock.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

