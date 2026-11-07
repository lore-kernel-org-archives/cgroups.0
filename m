Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015901;
	b=XsAP71FeBgAT7hx8Eq+yADvnFVBg/SW/ArDGCSIdpreJANpMJIPf/MYbDKGWwOuDS8nk
	 2yDoqdcnwxCCgBXYK5ZV9JGioOeedYSy4l6EV3b89BtnkH7/s68pMStp167wL7u6WN0co
	 xAwdNFOpkmNbvKLVL3qkV0yA9dSHMqfRAAXci8mzu8hT2KXgzPwKeShXF98tus9qq2LA7
	 Ch8lQj+ef0Pc7bqCCL/s2RbVy7kGg5/V2Hl225v405b1eUzvEUMPryPB+mGWOim33OCMm
	 zkSqTJZVk/gDFiBzqmPdaAUv3S0ZbMLfFl9WuxO+yIq6zZ2NtD+ZWlh9G9U6IkG9V5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015901;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pkcaOt9JTrkd/ls1TmhF11JH1kwsiCgw1HnWnPcgjuY=;
	b=qCj1k1P6oYoSHrDjZI+2X/4F/1OmyW4hOJTKxWFYyDvb9CNQN4hwq34NDcWyy+srW260
	 s2zx66vtZU3TXK1wHrZ7h3/nJiE3oBmYQMZSJ7R1xyiWl/KLJ0kZsZKh/fw4LUMSoWidL
	 kCcR2frQC+6rMMoDiAYPXYiwtYxRbuO9p6JZqwVuGrnIjzirz9ncJugmIZXDC2Qt1/TUT
	 81r3nfUQQwHkFO+UlSQpCroENojayIKIp4diG8yT71EhiG+oUuW8nYCd6h/k4NkYsJEj4
	 pqCANupFz08VXJImUcFhdUQ1tyEV1zPY8oAHLVrNT4IxbIGM/03RYFPoay/3dl8CjTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AMoocheS;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E22606A333;
	Sat,  7 Nov 2026 01:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1E22606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=AMoocheS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015900;
	bh=pkcaOt9JTrkd/ls1TmhF11JH1kwsiCgw1HnWnPcgjuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMoocheSDIp/MlcapZkfOp3oABfPFIH3IE6HSJPaWHxCiHqpEeVRifDI4w57kO40t
	 pgsjEzGThQbv0+87Bap6M6QbiC875s4/6ZmHr6xJNme/JbWMAi074zcdMvCeWscC2J
	 hoL5RresePayAQo+r0erPR9tjd9CWgFSV9pYW9x+RMwsElH3Vvf7xTSc/wQh6tWY8w
	 hIsNoQ5/ZLZfgGxk8PmGI597knJ5WUdhsNgMVTrPt5X+PavJEu9DhtvHy4ujGen6ti
	 DLQMzS0ibfE85Vrx5aIZTEwn4r7AWhwQT+zL9+ng0DHmA46UsVhycgWWGDSpIQ/AiZ
	 VA5yk+xaY9Ang==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPl4smlzLgR;
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
Subject: [PATCH v4 04/26] sched: Let a task boosted by a deadline waiter change its policy
Date: Fri,  6 Nov 2026 20:44:29 -0500
Message-Id: <20261107014451.1487825-5-mathieu.desnoyers@efficios.com>
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

__sched_setscheduler() admits bandwidth for a change of or into
SCHED_DEADLINE: it calls sched_dl_overflow() where the new policy is
SCHED_DEADLINE or dl_task(p). dl_task() tests the priority, not the
policy: it holds for a task of another class boosted by a deadline waiter
blocked on an rt_mutex it holds. sched_dl_overflow() has no branch for a
change of such a task to another policy, which does not have the policy
to leave, and admits nothing: it returns -1, and the change fails with
EBUSY. sched_setscheduler() to SCHED_OTHER or SCHED_FIFO on the owner of
a priority-inheriting mutex fails while a deadline task waits on it, and
sysrq-n leaves the owner as it is.

Test the policy: a task of the class has it, and a boosted one has
nothing to admit or to leave. The deadline_bw_test selftest added later
in this series has the case, boosted_owner_policy.

Fixes: 332ac17ef5bf ("sched/deadline: Add bandwidth management for SCHED_DEADLINE tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index b8c036d03d6f..bdffe5452dc8 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -689,7 +689,9 @@ int __sched_setscheduler(struct task_struct *p,
 	 * If setscheduling to SCHED_DEADLINE (or changing the parameters
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Last of the checks: nothing gives back the
-	 * bandwidth it reserves.
+	 * bandwidth it reserves. A task boosted into the class by priority
+	 * inheritance has nothing to admit nor to leave: the policy
+	 * decides, not the priority.
 	 *
 	 * Nothing to admit for parameters that are kept
 	 * (SCHED_FLAG_KEEP_PARAMS): they are the ones the task has, and
@@ -697,7 +699,8 @@ int __sched_setscheduler(struct task_struct *p,
 	 * change of its own that landed in between would leave them stale.
 	 */
 	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
-	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	    (dl_policy(policy) || task_has_dl_policy(p)) &&
+	    sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

