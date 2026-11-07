Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015901;
	b=pWPKFaxcqTlHAt9l6qTL14+NdkEsRW+jmO23ytuE1kUiD+UuWBI4NsmwBzijn9FOCJDI
	 iczIGIF8wR8UVesyU8XkQcfPDTwf9Xrofbcja5ZFm+jC3TKQYanL7Am/+zKF9RUl6fbLY
	 TRFT1/Q5p453/duNOJM0jQ76OZAZCol9CON/qFXxMiAPxrLJCa86eZdjnDLD1VWH0zsWJ
	 DHdS1a2M8pjGn3oJJe8e5OwoLyN2kW6/0c/CaN4Aj5pGxYHwTUa5I8/sXMniMY21C14Tj
	 vQ20hvMM2pqprDh7ve6ht6izuOh+HSS2k5kdT5M2I2ZCPd8rOQ0phpkoxzJQGRIrcXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015901;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0Yq28bzTUJ3iNY//5LElOyTADXlqa2Uq2chixrgk5yE=;
	b=P7FicBK/GA00bh1W4adaDgEO2mrEUtrmx2H31ncfrPQsd7hD/HNdBFG4gaeIP4VeTw3U
	 kzKyf8G/lAqqqCueh1Ut2jghRj06mJM0qOEKo5EqRPZ6l+tXbhM1ZiKVwVFoV/fbGb3zE
	 AN2KFKDy04eQ9pk6s3kRHXpQrJJVZ0v0eWpkvIVbXjF2Bdc1EdSE6ZBj2kZIPQ5fVdp+a
	 +gyJ9ZLlh6Io/FNgYXX1oZdQTcqGgteKy5mz6QLAUV44TLEqKi/ji1bHvJSvZCAi8NL2J
	 9wcZx6T1mm6xZOGqLBhs4WcDUDUYPM+up81/Jgb5j0jHcKwUVHNV7CRFady0HYagNwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pj5sZNjD;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCD6606A337;
	Sat,  7 Nov 2026 01:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CCD6606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pj5sZNjD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015899;
	bh=0Yq28bzTUJ3iNY//5LElOyTADXlqa2Uq2chixrgk5yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj5sZNjDtzxtAWxsKn/kHkbbL0Qz7QUJmjfmcKeUdq3xbfwZWjg+jOaQdFNhl3Im+
	 4y09TAQGA1gutp/eUFIgnJugC4F93iL0fmpqPpw7IoNbifRnuXcXcG6d6uz40Jf8Ri
	 b5gK1QBRCicVg5r67+SzL0T6EeCWtB2EP89F7Tk2cNviIqOOqfE7bprRNcFd1poTRw
	 Q19hCUkZPhfCfXfIJaaIdAeTBu3iafNlfAGsH62lHpGuqlgYwVLFTvoEj8nVjNFLyQ
	 h855/x3F5RGH+1HOAGD6HJ/7GsV1ZNwSe3YjOEVKy3haGGxNKaoyEsPIwPHh/7AP6D
	 gmKi7rmHZQqdw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPl1tpLzLZ5;
	Fri, 06 Nov 2026 20:44:59 -0500 (EST)
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
Subject: [PATCH v4 03/26] sched/deadline: Do not admit bandwidth for parameters that are kept
Date: Fri,  6 Nov 2026 20:44:28 -0500
Message-Id: <20261107014451.1487825-4-mathieu.desnoyers@efficios.com>
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

sys_sched_setattr() fills a SCHED_FLAG_KEEP_PARAMS request in from the
task itself (get_params()), with no lock held, and
__sched_setscheduler() then skips __setscheduler_params(): the task
keeps the parameters it has, and its dl_bw with them.
sched_dl_overflow() runs all the same.

A parameter change of the task's own that lands in between leaves the
request stale, and dl_param_changed() takes it for a change: total_bw of
the root domain, and this_bw and running_bw of its runqueue through
dl_change_utilization(), then hold a bandwidth the task does not have,
and the release at its 0-lag time, which takes the task's own dl_bw,
leaves the difference behind.

There is nothing to admit for parameters that are kept: skip the check.

Found by reading, after the Sashiko AI review of the first posting of
this series raised the case the previous patch refuses. Not reproduced:
it needs a parameter change of a deadline task to land inside the window
of a SCHED_FLAG_KEEP_PARAMS request on the same task.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 6819f0fea3c5..b8c036d03d6f 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -690,8 +690,14 @@ int __sched_setscheduler(struct task_struct *p,
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Last of the checks: nothing gives back the
 	 * bandwidth it reserves.
+	 *
+	 * Nothing to admit for parameters that are kept
+	 * (SCHED_FLAG_KEEP_PARAMS): they are the ones the task has, and
+	 * sys_sched_setattr() read them from it with no lock held, so a
+	 * change of its own that landed in between would leave them stale.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

