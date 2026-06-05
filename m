Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576CB3DEFE2;
	Fri,  5 Jun 2026 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780663421; cv=none; b=hVleOokTnR3yVFAIALxE8qFf/5f7zAIrvQrraXbfOCxBSEpH4dbqzFxqPY5433xvsqwWeCgiXx9VftEdc1qMNW2F4FAZJzEdN53yOHiU3dmBjt/GgGiBltm63396amh8YbgYs3b57obcPNiVPgUWJUH7Qw7ezp2FomqDmnGlRZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780663421; c=relaxed/simple;
	bh=bK9TxAbVAPg5ND7kKzBB2mFvH0tsbKgba0QPSCsn2ko=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=EoydFpkDlmVMAqZkQWUcFRVY3gVgjnibCXSGVFXqUoJDdA/EfVBxS9n5fgQH0RwoMWpkPdnCdhUfID0YJVePrdXC8mG0FaLsipxYkw5lrGtK3S1nYei05Qb+eCtT72UkGVL1eOwdaI4X7vz2Dsw2yy09j+VoullbQOe5Z5BjFVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fLyyAt+9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fLyyAt+9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=hjfLK/hrZVZ1NOOmYGZm3Pn+gttYY82Cdw6XleRZwT8=; b=fLyyAt+91eXxjLz7ZQw8SZ7r5d
	DIOJAVKGQtHt8uDYe9EbrRFsXjaSBG5iEDh6Rji2lQZXTEwnboRUfq3woUrDgrkZC0u8X3QRvDDB8
	27Sk9Guz8iI9u5o89EvApSAO7/PhBbFRq93oP4I5l64BQH9bcCIeJFlkD0Rb3zsS7bxI3bH0GWcaL
	jq15XRqyIzTK6npwAMlpXP/+8xVgeCHuNYdUnBQmPdY+bnb5vMGMd6BsrZHRCjgVXir9aB8KUfsZI
	ucl0UUMvRlEYTCY4lCi4O/AVluadNHzdX9M6+WwBCgpg4RvvpQTiTA4Tc60vJatBCGtGgEGun+hLT
	HqrHtCxA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVTtH-00000007vam-3n3X;
	Fri, 05 Jun 2026 12:43:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id 3229D30300D; Fri, 05 Jun 2026 14:43:11 +0200 (CEST)
Message-ID: <20260605124051.740585993@infradead.org>
User-Agent: quilt/0.68
Date: Fri, 05 Jun 2026 14:40:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: longman@redhat.com,
 chenridong@huaweicloud.com,
 peterz@infradead.org,
 juri.lelli@redhat.com,
 vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com,
 rostedt@goodmis.org,
 bsegall@google.com,
 mgorman@suse.de,
 vschneid@redhat.com,
 tj@kernel.org,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 jstultz@google.com,
 kprateek.nayak@amd.com,
 qyousef@layalina.io
Subject: [PATCH v3 4/7] sched/fair: Add cgroup_mode: concur
References: <20260605105513.354837583@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Improve upon the previous scheme ("max") by no longer assuming maximal
concurrency. Instead scale by: 'min(nr_tasks, nr_cpus)'. This handles
the low concurrency cases more gracefully:

	F_g_n' = min(M, N) * F_g_n

Notably this is the first mode where:

	avg(F_g_n) = 1

In the single task case it reduces to ("smp") and then it nicely scales up
until it hits N, where it behaves like ("max").

This is no longer clipped at nice -20. Strictly speaking it isn't different
from the normal SMP scenario where all tasks are extremely unbalanced. There
are no unnatural inflations in this scheme.

The meaning of "cpu.weight" would be: weight per active CPU.

NOTE: Compute the group wide number of tasks by extending the tg->load_avg
computation with tg->runnable_avg, since cfs_rq->runnable_avg is based on
cfs_rq->h_nr_running.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/debug.c |    1 +
 kernel/sched/fair.c  |   43 ++++++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h |    3 +++
 3 files changed, 40 insertions(+), 7 deletions(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -641,6 +641,7 @@ static int cgroup_mode = 1;
 static const char *cgroup_mode_str[] = {
 	"up",
 	"smp",
+	"concur",
 	"max",
 };
 
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4846,6 +4846,11 @@ static int tg_cpus(struct task_group *tg
 	return nr;
 }
 
+static inline int tg_tasks(struct task_group *tg)
+{
+	return max(1, atomic_long_read(&tg->runnable_avg) >> SCHED_CAPACITY_SHIFT);
+}
+
 /*
  * Func: min(fraction(nr_cpus * tg->shares), nice -20)
  *
@@ -4863,6 +4868,20 @@ static long calc_max_shares(struct cfs_r
 }
 
 /*
+ * Func: fraction(nr * tg->shares); nr = min(nr_tasks, nr_cpus)
+ *
+ * Scales between "smp" and "max" in a natural way. No longer needs clipping
+ * since there are no unnatural inflations like with "max".
+ */
+static long calc_concur_shares(struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	int nr = min(tg_tasks(tg), tg_cpus(tg));
+	long tg_shares = READ_ONCE(tg->shares);
+	return __calc_smp_shares(cfs_rq, nr * tg_shares, nr * tg_shares);
+}
+
+/*
  * Func: fraction(tg->shares)
  *
  * This infamously results in tiny shares when you have many CPUs.
@@ -4897,6 +4916,9 @@ void __sched_cgroup_mode_update(int mode
 		func = &calc_smp_shares;
 		break;
 	case 2:
+		func = &calc_concur_shares;
+		break;
+	case 3:
 		func = &calc_max_shares;
 		break;
 	}
@@ -5043,7 +5065,7 @@ static inline bool cfs_rq_is_decayed(str
  */
 static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
 {
-	long delta;
+	long dl, dr;
 	u64 now;
 
 	/*
@@ -5064,17 +5086,21 @@ static inline void update_tg_load_avg(st
 	if (now - cfs_rq->last_update_tg_load_avg < NSEC_PER_MSEC)
 		return;
 
-	delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
-	if (abs(delta) > cfs_rq->tg_load_avg_contrib / 64) {
-		atomic_long_add(delta, &cfs_rq->tg->load_avg);
+	dl = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
+	dr = cfs_rq->avg.runnable_avg - cfs_rq->tg_runnable_avg_contrib;
+	if (abs(dl) > cfs_rq->tg_load_avg_contrib / 64 ||
+	    abs(dr) > cfs_rq->tg_runnable_avg_contrib / 64) {
+		atomic_long_add(dl, &cfs_rq->tg->load_avg);
+		atomic_long_add(dr, &cfs_rq->tg->runnable_avg);
 		cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
+		cfs_rq->tg_runnable_avg_contrib = cfs_rq->avg.runnable_avg;
 		cfs_rq->last_update_tg_load_avg = now;
 	}
 }
 
 static inline void clear_tg_load_avg(struct cfs_rq *cfs_rq)
 {
-	long delta;
+	long dl, dr;
 	u64 now;
 
 	/*
@@ -5084,9 +5110,12 @@ static inline void clear_tg_load_avg(str
 		return;
 
 	now = rq_clock(rq_of(cfs_rq));
-	delta = 0 - cfs_rq->tg_load_avg_contrib;
-	atomic_long_add(delta, &cfs_rq->tg->load_avg);
+	dl = 0 - cfs_rq->tg_load_avg_contrib;
+	dr = 0 - cfs_rq->tg_runnable_avg_contrib;
+	atomic_long_add(dl, &cfs_rq->tg->load_avg);
+	atomic_long_add(dr, &cfs_rq->tg->runnable_avg);
 	cfs_rq->tg_load_avg_contrib = 0;
+	cfs_rq->tg_runnable_avg_contrib = 0;
 	cfs_rq->last_update_tg_load_avg = now;
 }
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -493,6 +493,8 @@ struct task_group {
 	 * will also be accessed at each tick.
 	 */
 	atomic_long_t		load_avg ____cacheline_aligned;
+	atomic_long_t		runnable_avg;
+
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -722,6 +724,7 @@ struct cfs_rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u64			last_update_tg_load_avg;
 	unsigned long		tg_load_avg_contrib;
+	unsigned long		tg_runnable_avg_contrib;
 	long			propagate;
 	long			prop_runnable_sum;
 


