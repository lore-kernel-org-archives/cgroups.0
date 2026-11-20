Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182970;
	b=VdCVcQDgiA5ejsoslXJ6TnTbWrfTmnJoa/dNm4ZsamRLgvEezGPJIqOOiVb5MUUPFrM5
	 EVh7T6qDYi96r3L4OoXGRgN6DBkBtkmGtAcHZT941iv636tBmUqsWH9BX4N53WucflwdO
	 Zgl2CGyynQuO+fN5yiNsyqMxTMXmr5NxhXp/GufvijIo24ESJH7Dbw4G7Oyt0AjoOjqXQ
	 kzz6L0VPrRslA7qhV5eRy1u+n9HiHHaHdsJ7Wv5QbZeHivv6fl6ftYn3MW7qciSOq5HQ0
	 O4hxQTfhaV4xPeupr4VwGSZmkJmZ0NX4Uw4xZNGQpIYzWNuBkvZtoMrwWDYO/r4H8Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4oOZucHkxRNQB/JWsDJ8WiJS0N5307gEDPlX3g4A2Ag=;
	b=cwOqnSxMgDw3Udoezivc4UpMqcqN5rNUWTn62QJn5pG5hQRE6psHQnCgNNNtJCC9tZPj
	 3XjRWAF8Aks3assBjjTqAaZRZwCaHsm3C50B/aTs8TxVzqCHva/8HGTJ/XfIE8nSlebLq
	 KVom2Gh9pPhtghgjsZU78882G2COhn4dFYbJHq0eN0ONOp6AZahLag8p7Rkvmqo/nVu+Q
	 kvhE/JTGQlyP3u68DIuC0dv2FcJYMaSgImuaweqU6j7HShJUzcVJQ7OWZ9rnMvxFD9zyY
	 ONqA5/PXsLcmkkwQyl68P2FKfi/lK60URCKDFukhI7dArbwNyPR8B5CzZjYbZYnTnqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LHb8VUpe;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E27606DF7B;
	Fri, 20 Nov 2026 13:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42E27606DF7B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=LHb8VUpe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795182964;
	bh=4oOZucHkxRNQB/JWsDJ8WiJS0N5307gEDPlX3g4A2Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHb8VUpeC9l+zpkxrtWvIaOygpAJvPZJBzK+FPhPJCCtvEnAg6mgLwFnJGcl9orE3
	 t4cDnd5mDbTO5GzfBoJTV24ZA7Hesnmp2uSa8EqZiS9BE1MuiysUSvEUTQqGKZjFXs
	 eE64JoPPEeRDdRIfZmxilulHFhx/+J7SDnSbsbJ6HbGND5jO1Non3JSddTe/rf3/y1
	 qRJzVSpTdGk0kXbU2RgvvcLjtcuwC20NXHu4O7pznaSul3THPxYuBm03cNnZbjEEWS
	 MKjR5IhqZUS53Dg5x+io/MZYDkvvqjv2sB3hhb+lOPHhFkHy9PZLGB7M78/OJlh6xg
	 dm57LUB4+AAyg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWH1J5QGkzSQ8;
	Fri, 20 Nov 2026 08:56:04 -0500 (EST)
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
Subject: [PATCH v9 31/33] sched/deadline: Check the runtime of a task that comes back runnable
Date: Fri, 20 Nov 2026 08:55:54 -0500
Message-Id: <9a94ebfe975ac1b354f63f2e681cab6dba5d0310.1795181240.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
References: <cover.1795181240.git.mathieu.desnoyers@efficios.com>
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
index 27a746c2f81a..b319173178f3 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2961,6 +2961,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
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

