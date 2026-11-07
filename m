Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794015903;
	b=LWbSkL27uZAHrDNXpbNcKcC9tfAI0u1iL/rvTGoC+INh9d/N+KdvTndHO+2OSe8DHwn9
	 AlpxEAl7Ejp3unXqPmNYqWHgXj3JvW65GUH3+W/tvOrEcQydKqAz+PNV3GCGzVwQy7dZI
	 A/z2hX5LZfnupnQhHnNUfXnu5gWLxLqjAOtE1eLQWiJl8pEosfMo2Emw30vf1NjbBLxwd
	 wEzQr83UeSO5H/ZjI3oD61h6m0qlnELWkzyLvNWEUJtc5vWShw4z6GrQtCzbC39vCo+rh
	 kHQzFykI/F5xvAZ/lsV9T231p7txKFEA65uzlrwJcqhuy+OAch4W0gfaDCvLv4GO9hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794015903;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9UfasZ7LxCeLM/5aEYqfPVDvttgSwsK0ETfh7zbXLNU=;
	b=ZgAD0I3OqFdB8AFcPdSqEudO0jbD0s4rKiPpob60jD1sOko82E2T/qQLMqqCdzM47faE
	 uA4wczfCrLWlErLvbOo5ahPMRTX/4L+MT30dKIatxOrJmqGTzRlKmbR/na+NbsghyIMvm
	 XCJo5gXMJ32jZkbB+47JWRvAYVShC6rZSlHxYnyOMs7lZQEqtzgAzlS0A91CIDviOLf7i
	 0uArVgONoaMz2HVgQcUIFPNMoC0AL2c7EleiVcYa7q7YEPhrKGGGM0TyJCW/RTnoIT3BC
	 OT+Bxn1m0sqvV6ifjsPR4Xpm9N0XO5DhCJBEoScrTQzr8E7Fa0IpgYZfvnn7mGNl6Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=juRV8efP;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48104606D83E;
	Sat,  7 Nov 2026 01:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48104606D83E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=juRV8efP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794015902;
	bh=9UfasZ7LxCeLM/5aEYqfPVDvttgSwsK0ETfh7zbXLNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juRV8efPZn1LeUGoasGpchXzRjRpgoKgyJYPVzvE50FODSJ3msDPFMbbpsETQly89
	 GtIEcoNx7G96zZtAKSiiKOVspDovMMMXGuod4X+4xGP1aj8uqtyfYzDq7FqXvhstwX
	 w4pTKlO/lupMmLP/au2JI/v+mGwQ4jtAeGAb2P14xNNTnxii4tU4vVau2QXXke5trF
	 5m5z8CO81aYHQfL2B/qW2RqNDh46k9chw1mZgfF+WW9Rbv5TqC+4uQqaHQGzzpaqmA
	 KmB3kYasqqfvKNG8Q7yCOXzFnx1QTvbvPDqb52CGCkBdtss5dSsfZDHszt1b6XFl+g
	 05NM8lrv7u8FQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLzPp286fzMR6;
	Fri, 06 Nov 2026 20:45:02 -0500 (EST)
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
Subject: [PATCH v4 10/26] sched/deadline: Release the bandwidth of a task that leaves the class asleep
Date: Fri,  6 Nov 2026 20:44:35 -0500
Message-Id: <20261107014451.1487825-11-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE while it is not queued, asleep or
stopped, keeps its bandwidth in the root domain's total_bw for good.
Repeated, it fills total_bw up to the admission cap, after which
sched_setattr(SCHED_DEADLINE) and the offlining of a CPU fail with
EBUSY. switched_from_dl() releases the bandwidth of a queued task alone,
through task_non_contending(), and the inactive timer, the one other
path, is not armed: the task never ran in the class, or the timer fired
while it still was, taking running_bw alone.

If the 0-lag time is still ahead, arm the inactive timer, to release the
bandwidth then: a task migrating to the CPU it wakes on, whose timer
migrate_task_rq_dl() cancels, and one that came back to the class asleep
can have it ahead with no timer armed. Past it, release the bandwidth in
switched_from_dl(), for a task with parameters of its own that is not
special, and clear its dl_bw, so that no later path, a deboost or a late
inactive timer, releases it again. Clear its parameters and its period
with it, as inactive_task_timer() does; a boost the task still gives
reads none of them since "sched/deadline: Take a deadline boost from the
waiter's rt_mutex node".

Reported by Tejun Heo. Juri Lelli's "sched/deadline: Fix total_bw leak
when switching away from SCHED_DEADLINE while !queued", since dropped
from tip, released on this path for every task without clearing dl_bw,
and released the bandwidth of a boosted task twice. The deadline_bw_test
selftest added later in this series has the cases,
pi_former_owner_asleep and deboost_released_resets_period; the Sashiko
AI review of the third posting of this series found the two states with
the 0-lag time ahead.

Link: https://lore.kernel.org/all/20261103-b4-sched-dl-bw-fixes-v1-2-dd761fe005b4@redhat.com/
Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Reported-by: Tejun Heo <tj@kernel.org>
Closes: https://lore.kernel.org/all/2b5fb3f22bca6aa383be8f4781923392@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 97 +++++++++++++++++++++++++++++++++--------
 1 file changed, 80 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f389620e6fc9..cb0cf9c15108 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -390,6 +390,22 @@ static void dl_change_utilization(struct task_struct *p, u64 new_bw)
 
 static void __dl_clear_params(struct sched_dl_entity *dl_se);
 
+/*
+ * The 0-lag time of @dl_se, relative to the clock of its runqueue: its
+ * utilization counts until then once it blocks or leaves the class.
+ */
+static s64 dl_zero_lag(struct sched_dl_entity *dl_se)
+{
+	struct rq *rq = rq_of_dl_se(dl_se);
+
+	/*
+	 * Using relative times instead of the absolute "0-lag time"
+	 * allows to simplify the code
+	 */
+	return dl_se->deadline - rq_clock(rq) -
+	       div64_long((dl_se->runtime * dl_se->dl_period), dl_se->dl_runtime);
+}
+
 /*
  * The utilization of a task cannot be immediately removed from
  * the rq active utilization (running_bw) when the task blocks.
@@ -463,15 +479,7 @@ static void task_non_contending(struct sched_dl_entity *dl_se, bool dl_task)
 
 	WARN_ON(dl_se->dl_non_contending);
 
-	zerolag_time = dl_se->deadline -
-		 div64_long((dl_se->runtime * dl_se->dl_period),
-			dl_se->dl_runtime);
-
-	/*
-	 * Using relative times instead of the absolute "0-lag time"
-	 * allows to simplify the code
-	 */
-	zerolag_time -= rq_clock(rq);
+	zerolag_time = dl_zero_lag(dl_se);
 
 	/*
 	 * If the "0-lag time" already passed, decrease the active
@@ -3597,15 +3605,69 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	dec_dl_tasks_cs(p);
 
 	if (!task_on_rq_queued(p)) {
-		/*
-		 * Inactive timer is armed. However, p is leaving DEADLINE and
-		 * might migrate away from this rq while continuing to run on
-		 * some other class. We need to remove its contribution from
-		 * this rq running_bw now, or sub_rq_bw (below) will complain.
-		 */
-		if (p->dl.dl_non_contending)
+		bool released = false;
+
+		if (p->dl.dl_non_contending) {
+			/*
+			 * Inactive timer is armed. However, p is leaving
+			 * DEADLINE and might migrate away from this rq while
+			 * continuing to run on some other class. We need to
+			 * remove its contribution from this rq running_bw now,
+			 * or sub_rq_bw (below) will complain.
+			 *
+			 * inactive_task_timer() will find !dl_task(p) and
+			 * release total_bw via __dl_sub().
+			 */
 			sub_running_bw(&p->dl, &rq->dl);
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl) &&
+			   dl_zero_lag(&p->dl) >= 0 &&
+			   !hrtimer_active(&p->dl.inactive_timer)) {
+			/*
+			 * No inactive timer armed, the 0-lag time ahead: the
+			 * task is in flight to the CPU it wakes on, which
+			 * cancelled the timer (migrate_task_rq_dl()), or it
+			 * came back to the class asleep, which cancelled it,
+			 * and leaves again. Arm the timer, as for a queued
+			 * task: its handler releases total_bw at the 0-lag
+			 * time, finding the task out of the class. running_bw
+			 * is off this runqueue already, or never was on it.
+			 */
+			task_non_contending(&p->dl, false);
+		} else if (p->dl.dl_runtime && !dl_entity_is_special(&p->dl)) {
+			/*
+			 * No inactive timer armed, the 0-lag time past: the
+			 * task never ran as DEADLINE, or the timer fired while
+			 * it still was (only dropping running_bw then). Or the
+			 * handler of a timer that fired runs late: it finds
+			 * nothing left to release.
+			 * Nobody else will release total_bw, do it now.
+			 *
+			 * Not for a task without parameters of its own, one
+			 * deboosted from priority inheritance, nor for a
+			 * special one: neither has bandwidth in total_bw.
+			 */
+			struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
+
+			raw_spin_lock(&dl_b->lock);
+			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
+			raw_spin_unlock(&dl_b->lock);
+			released = true;
+		}
 		sub_rq_bw(&p->dl, &rq->dl);
+		/*
+		 * Released: its 0-lag time is past, and its parameters go with
+		 * the bandwidth, as where inactive_task_timer() resets them.
+		 * Its bandwidth is no one's to release again, and a dl_bw of 0
+		 * is what every path that would takes. Kept, it would make the
+		 * task one with bandwidth to task_contending() and
+		 * task_non_contending() once priority inheritance boosts it,
+		 * and a deboost while it sleeps would release it a second time.
+		 * So would the inactive timer's handler when it runs late,
+		 * dl_non_contending cleared under it by migrate_task_rq_dl():
+		 * it finds !dl_task(p).
+		 */
+		if (released)
+			__dl_clear_params(&p->dl);
 	}
 
 	/*
@@ -4005,7 +4067,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 }
 
 /*
- * This function clears the sched_dl_entity static params.
+ * This function clears the sched_dl_entity static params, and the state
+ * of the period the entity is in.
  */
 static void __dl_clear_params(struct sched_dl_entity *dl_se)
 {
-- 
2.47.3

