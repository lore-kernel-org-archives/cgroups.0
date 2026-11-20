Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207369;
	b=33GzV6vQ+XT3URHjxnHKjm21dDk6avesF0ajAwQdZQqwToNrAkvd6aR1Km40Mc2ibkuT
	 PQ9K1xRwumsVQgAd2g3rFNq3r5RHxRNIzaCKCZqPU2wu0EZM8dDPslyclg2vQT8fuRlIR
	 CJH4eF31MISBCRC+fOgz34TDZtJcuu+yajlSWWBeNi4FGwfZGS41ZpjqzaWjZRpXjumTW
	 //fGFGWAQly0GDZCIWj1krezG4owi6Vmj1zy/C+HZUKtf5FpMr0HNhhA1W5ZQOTONaJqX
	 fcInrTpFxz8YPygJzXDQwVzx1VqtGS+sBWH9Vf3XoDE95o45GQ+wSyBkPn7BeyIKv/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207369;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1kcpZtMV4uNho8xiGFl/y1ftRizYB1fPaIOufs+qjxQ=;
	b=neoSlbKVMnUCxCUrT9/gTZtBaYylzPXw60iCNNp507SjGD+GJ1KPZhdTNXt1UMmKja4G
	 JrFWbJPQqlqySu3ZypAegE/qW5fl/any+UGuGDJx13PByEYA4u662ZaB7UFXw3k/4Vpr7
	 TJIiYq9OoJvH0BieZCBR8jwl+D1ZQVM92hp0PvDPiFT/RZTH9+5D8Ya16Z7CHF+4+N7Nf
	 mYec6K/dW+B7e0A+k+2shKyF1SvPS/iltGzpfKbSJyqtVOxUps+FDwMzIS7fNCLxRYL2t
	 EMHqUbZUP2Fq7F5oMcjDOdbWjR0BBTClMielaTkb2D7PiswF52SramtUctPb19pQgnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tAoGqfJ9;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA8660A5BD0;
	Fri, 20 Nov 2026 20:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AA8660A5BD0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=tAoGqfJ9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207359;
	bh=1kcpZtMV4uNho8xiGFl/y1ftRizYB1fPaIOufs+qjxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAoGqfJ9bHlCemSqlUsI8M5qlpOWGmh8lm3yl+lWyY5HoroYP6HFWBTbghaptZSg+
	 Z+Rdgo6YHZDWbKrxNAYw1PCdRpzi47eOHY+j228QgRnggx5Ic1USDZl5sQP/PtYJ8C
	 cn5TMY7dBfcd2ZahsI1QCnfTF27iBDeEk0iBjci3SQrNqea6eNuoPWvFMWvKCP+Ojk
	 AP6MkE70dTe5y2c3E0ihNdbpACuOAicrIuhGbqVMYv5bS69mIhdOU8m1nLOEhhr89C
	 JdYIxLoXMn4o/VxA3A/PUIahD96Sc0VqoOaawtxH3PTQzmqRLjROLF5LmgZWa2ntsx
	 52nn+Oh8zqrVA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2R1l4JzTqm;
	Fri, 20 Nov 2026 15:42:39 -0500 (EST)
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
Subject: [PATCH v10 34/40] sched/deadline: Check the runtime of a task that comes back runnable
Date: Fri, 20 Nov 2026 15:42:11 -0500
Message-Id: <72607fb041602360f97a6334c4b75bda95d5f771.1795207233.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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
index b6fecf4c0324..83aefe5ab671 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3014,6 +3014,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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

