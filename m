Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795119389;
	b=cd6kHe9WNb3N8ZJW4s3XvAFPRUT2JqRqoRT58F8Alb+H3HxlpCVzPAjFDUl7g0hU7vvK
	 qG4vmAJnyDe1TvOcgHLzM0aWV9bIl2uAsNfA4qZlSU1q6Asy11qbOBGvSKX88udi2NTLt
	 WCscpPvKae5mnc4g9W9vcA6EaJcPS4x5Z6U1PdvEsasqnlQ0HQU8AGoymaqbS19FV3dwF
	 uMVsayiKgbVmv/xvmQEZSxm24H/htl89eVGgYp9icVzFSsyyXyqaMQ0bmhOqHjFpgZnBM
	 mwRDutSS4Fd/mS5/lQahNAsx5Fqxv/5g/FFLjjipPvGzfTGQNYvej9Tzc4ovTeklwlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795119389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DhkuUTuyfzOj2x0P7nrmTtXGd320s6zg2wIpubGEfbQ=;
	b=iv/xVlXbbOJ+oI44Q8wLxNPoXqSS/tnbyKtQJ+qe2QU3m1NMhBsvEbgcjD6BkkDUogVy
	 NPE7jZpcg3UQ3DoZq4J1ZBtdVEuHg/jC/p9gO8jKiuNTkOFnlbs1bE8EvcZsHbgnDSr9H
	 r+aJNwJEqzI9ddMWM1QIj2WkEuFdPsgUTPA871jPoCo36Xh1Gm+GYO/9+ClHpq+MmP6ax
	 UztEzjDRmCemtJxF6Nnu7xiUrmqLEj80kZWg+ipb6LhfEgT7LJved1y3Pc1okHtTK1N1o
	 4nTh1+OVmNqQ6tu757Tk0UXlDVlEWkc/79gov9bNLMr7y+C6QzlG18v6h8zlUYp3drg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PIZNuxc4;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AA3606A9C1;
	Thu, 19 Nov 2026 20:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66AA3606A9C1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PIZNuxc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795119383;
	bh=DhkuUTuyfzOj2x0P7nrmTtXGd320s6zg2wIpubGEfbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIZNuxc44XNJBWJ3YlagS20T+rXyDbcf7qJ3wiX3H+q2F3hKTLGwaikVAc+ZDxIzp
	 W3H7vKu5asGl8Lr9AUbUuwJtqPpUbxBQetzWySm4lcVnJPuRF6HCx6Fh0+NOIjhmKP
	 TLmWNAik/rMeRXgkRlaT96tp0E3ZelkSmPkt6n6l2tEON/Xm5OGf8j8ccfl+SQf5Bv
	 tXr58jzrsOh8QoOSiB2I0z9LGg68P/sRB48wyeQX/Iomxudb6jx+136u35c/nOr4up
	 veWS3bJDvnDWjE8xeJ26dhwed86SCbXJCI4kPj7xe94zdWMoVALfj7S3YXnKrO/ZEk
	 1yI6zOL7Jt/pg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVqVb0r88zT9j;
	Thu, 19 Nov 2026 15:16:23 -0500 (EST)
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
Subject: [PATCH v8 31/33] sched/deadline: Check the runtime of a task that comes back runnable
Date: Thu, 19 Nov 2026 15:16:10 -0500
Message-Id: <10995512d1675323c869dd3c9093886b3066077c.1795116791.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
References: <cover.1795116790.git.mathieu.desnoyers@efficios.com>
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
index 01497171919d..7ed2f525b883 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2913,6 +2913,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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

