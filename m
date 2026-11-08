Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164067;
	b=n3hFu+4lRq66DdP6l+gnsTcxvdnChqKcs4zWjaSW3uSC5WH57sXw34McKCKUZqlwsoKH
	 p9jhZj49V51NDEh/TXlZToRj+7jMSgyRbhoCU+tmsj9Rly6zGOQYqG50ljtzZk5jEGRN+
	 K4cxsGD8sefqz13UFfB31nDQ0JvaHJEIKZD4DaTRz4o3WLnZtvPQB/LGBhyk/Im7Wn1+O
	 yBg5qU381PKPAxzaYtgB840ihA9aFjxL7iEYN/nH5UZ0bxW0qzM0pvUULVln5WhCs9fct
	 viTwF/7Y2lrBNcMd6bBd3Go8bRv7CYoq5oY1nEmRyRtTKGqLgJuqHnfh/GTxcArltxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164067;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WJEcr+GzlecUxaakuOCAmJ/FtLMstxZ4/HhNucsJKwc=;
	b=UZyxj+N8dJYGQ0Ajw9QrE2iW9goZcq2zyw1FYVG1zoWRvNQpTGoQaWLKz8f6IyS9C+Sm
	 BnF9UPMJNQzhlPhzy4RqrWEKLH47ND3AlqVk9nDCAqOFz4V4wCuLuRXbxCf9HCwVZq1sJ
	 26fSmIwi1jxQQKLSwVgkzhT8SVqfYtne99XStpA8cuBU2q43mZLZaQGr+TLrHXTEdJH50
	 F9r4HSjc3X4Uwg41oAwsDadmPnnyqLCzTETQnlvLpT7ayuNkmDB/xXxRzZUy7hXthfewo
	 4ROlY6zOqPWUjesVmrN4ZzyiqvEUBxJxx7VFXMwo/+6WQOlFt/bVNgsqjwXEbceE+Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ICV7YPh3;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD5D6083627;
	Sun,  8 Nov 2026 18:54:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD5D6083627
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ICV7YPh3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164066;
	bh=WJEcr+GzlecUxaakuOCAmJ/FtLMstxZ4/HhNucsJKwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICV7YPh3imu4QmyTcstNyK2XJoz++evfP+yC80UD3yLTfTgsZNSfg61gLN33Fo9df
	 HYvgIbtoyRAS6pYbrunNFp+OEO6GNRqyADfxK00T8d35Oa7OsvFOdE1WLlLOQ3d0wA
	 avOVf9HQMAsKml9+zrvl53/OXdKx/NSUE3ggimG09JqxWBiAVT9Mad7fyRJm+n8OJW
	 hTlBaLxjA6r3p1SrT584L3/ppRVfpwgF6xnFRLWjYrvscE6Jt7baFRYHsGRW0LLEKG
	 lx9vZa4BhMrWuO7uZDTiLiMpHQtSHOASu+s9Zys7bl4oUTGdPoulO+z+Z2LFroPCq4
	 3cRmtVSHvKjBA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C61bXJzM60;
	Sun, 08 Nov 2026 13:54:26 -0500 (EST)
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
Subject: [PATCH v5 24/29] sched/deadline: Cancel the replenishment timer with the parameters
Date: Sun,  8 Nov 2026 13:54:01 -0500
Message-Id: <20261108185406.1549770-25-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE has its parameters cleared at its
0-lag time. Its replenishment timer can still be armed then. If the
task comes back and throttles before that timer fires, start_dl_timer()
does not restart it, since it is queued. The replenishment would then
come at the period of the reservation the task left. Too early, it would
give the task runtime it has not earned. Too late, it would delay the
task by up to a period.

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole") armed
the replenishment timer when a task leaves the class. The timer then
reset the task if it was still out. Commit 209a0cbda7a0
("sched/deadline: Improve the tracking of active utilization") moved
that reset to the inactive timer, at the 0-lag time. Nothing cancels
the replenishment timer there.

The timer of a throttled task fires at its next period, which can come
after the 0-lag time:
- A task that yielded is throttled with runtime left. Its 0-lag time
  comes before its deadline.
- A constrained-deadline task that overran by little reaches its 0-lag
  time before the end of its period.

Fix this by cancelling the timer where the parameters are cleared. This
includes switched_from_dl(), when it releases the bandwidth of a task
that leaves asleep past its 0-lag time. A constrained task that overran
as it blocked has the timer armed there too.

The Sashiko AI review of the first posting of this series found this.
It has no reproducer.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a35609a10ec5..47adff100392 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -637,6 +637,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 				if (dl_task && READ_ONCE(p->__state) == TASK_DEAD)
 					sub_rq_bw(dl_se, &rq->dl);
 				dl_task_release_bw(p);
+				cancel_replenish_timer(dl_se);
 				__dl_clear_params(dl_se);
 			}
 		}
@@ -2403,6 +2404,7 @@ static enum hrtimer_restart inactive_task_timer(struct hrtimer *timer)
 		}
 
 		dl_task_release_bw(p);
+		cancel_replenish_timer(dl_se);
 		__dl_clear_params(dl_se);
 
 		goto unlock;
@@ -4135,8 +4137,10 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 		 * task_non_contending() skip it, and its deboost releases
 		 * nothing.
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

