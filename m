Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015908;
	b=BYqydkgWbQcyapPLFrDhtcyRB0EfybBGcr554syNn9XdUPZgj+zI2XXWAWxAtCsIuAcn
	 2yxdlQYOqz4K5xL8gqAyCWZPCHjQQI2uR6VVYLfaNZ+UQKEpc/U5LuZC61jKP+kMoEMF6
	 yHu6UdKr+t2L2Ukop7ia6OTdI/GQIjnXEeiREAarQMKEPHsdIZEo4bo++Wcv3iArpo0RV
	 mEiV68FyuPgr857IiMFlpLmJg7T2L2GDRZiT60AC8t9ieRadRciv7nxiPXc/hMyjgVRZs
	 osbkvGrQvOpMI0E1YLgr4Efwa+61HxYOG8NPadwAzTGeJDGlZarGcYq61rcDXo61lwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015908;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HpDcG3Am8kwsk/tY8hxTPsdCTtQhfJ4hh5SBJNUS2/c=;
	b=rZqOtarcs7gRvZe1ZpM927QIUutxSfhnLJW9fjQm/fjJDTjIRSIuejTPeSQZDcccml6z
	 lLdcRdESg5N5YCpnat7E8DYdQ8iYzmvwzMo6WcGRWLZ0zJ9ONJsEiEqjL38OrcNhMM3fN
	 Vwyi0vnOqSsm/3OIvXWdK4Fo48Vug4TgJ8aW+ECieH8liCcvlpuYuWr0YCvzbYx5a1QDm
	 J8qXKvKE+Km8G1N5L7fTfrmeZAlMVZhovRY1llh3SAEjr92Cq93iVy3i/aUoa7Bzqs+DZ
	 T7PmVcFuuIj2ysAIyUr1gL+xumx0Co2K7lwskSwhYf8cn2x/IqLV9bPlCKd1ieCvKQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eKkcQ11K;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D166082BD9;
	Sat,  7 Nov 2026 01:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6D166082BD9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eKkcQ11K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015907;
	bh=HpDcG3Am8kwsk/tY8hxTPsdCTtQhfJ4hh5SBJNUS2/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKkcQ11KsO5GQ9oTQVMJlPsFfJyPepSkcJwf5uG9c/JjRXlSCEWtW961XF7jWFbAK
	 dH/PAQgEiONQYIivqOHsgBAwOi737RoL3EEFExWsef6BYmNtmF3m34l5RGJnvVh5VP
	 0Qkvy3r9RepY4BRmg8M+sPJJhIvftHBo5QnZE6OmOkMmHOCElNoREaqv33j8vjfQhY
	 R4hW3E7lHVKUSajcBEwy+PzXKvNbKOqL7AI77q8hAV06mzDV9eeb2CeaOtQ07CO76c
	 x4P6wRFnHd4XDPtLf8uxS6d0l2buqqJvpNvqp3tk6Gyo5YuhQYB7sonf80sH6QF7T/
	 FPR8WYA+28MPQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPt5yMHzMR8;
	Fri, 06 Nov 2026 20:45:06 -0500 (EST)
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
Subject: [PATCH v4 21/26] sched/deadline: Cancel the replenishment timer with the parameters
Date: Fri,  6 Nov 2026 20:44:46 -0500
Message-Id: <20261107014451.1487825-22-mathieu.desnoyers@efficios.com>
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

The replenishment timer of a throttled task is armed for its next
period, which can come after its 0-lag time: a task that yielded keeps
runtime, and a constrained-deadline task that overruns by little
reaches its 0-lag time within the same period. Leaving SCHED_DEADLINE,
such a task has its parameters cleared at the 0-lag time with that
timer still armed.

Back in the class before it fires, the task throttles again, and
start_dl_timer() leaves the armed timer where it is:

	if (!hrtimer_is_queued(timer)) {
		if (!dl_server(dl_se))
			get_task_struct(dl_task_of(dl_se));
		hrtimer_start(timer, act, HRTIMER_MODE_ABS_HARD);
	}

so the replenishment comes at the period of the reservation the task
left: too early, which hands it runtime it has not earned, or up to a
period too late.

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") left
that timer armed on purpose, as what reset a task that stayed out of
the class. The 0-lag time took that over and left the timer behind:
cancel it where the parameters go, and where switched_from_dl()
releases the bandwidth of a task that leaves asleep past its 0-lag
time, a constrained task that overran as it blocked having the timer
armed there too.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ed951246e3d2..a0b05ff8c6da 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -607,6 +607,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2375,6 +2376,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -4009,8 +4011,10 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		 * dl_non_contending cleared under it by migrate_task_rq_dl():
 		 * it finds !dl_task(p).
 		 */
-		if (released)
+		if (released) {
+			cancel_replenish_timer(&p->dl);
 			__dl_clear_params(&p->dl);
+		}
 	}
 
 	/*
-- 
2.47.3

