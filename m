Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242206;
	b=q7RBAVYXIdL9fnShW4+1E0UKxXXPXAuZt06z0mXnuxeMywJm5iUBZj8CtqxJvNC4/Pwq
	 lp4zic6J6/BWqIIb18dGuYGdYrYTfosa8VfljaWAWJ7XcWpxH0YmnNa++P1WgayVDW3hi
	 Suf1nhyUPGXhg6CcGzSavL7M3zMZcqI9Du33tLnprniTIrr79y7RkxatD0ahTl0zeuM1l
	 6/uU+O2FMxIpaMrq5oaS6bErsHuL0Z7BKh2UHBVSrGNA+dVvKoM+GWxwkLpYNAiaArC5X
	 7mfy0aOC8cW187yW1vDdh7w4geGPwHm9cZb9/+x6ksUr7RLws2t/Y9s4k2HklkBTTNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242206;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WjFXg6OvuRqQLh+vbRQ1oRonDN5U6tuBnKu/6O8lfTk=;
	b=nsv440rnqTXeiQHWdHykvfx9PNWxfigL+9EY5uDMVxxEbKNA4CvU/5wfic7YyiIZP7Lz
	 Jo6GHdeuAuVXepFHQYLkpwZ15B5ioru8a27beoFszd5CM8lOLMEDvIaXPW7SH11XR8Ilq
	 hYeRfuQC8gcCOn6eP3pVqx/g/PfPIzhd6Ed4m3m4hCOAqwFRVsIEva3NCX9MqfAlC/K+L
	 KowDC5xy9G3Kdjo/2Bv+KA2yjcSDNrkjyuRJ/3cT+BN+dueG/F44gbfibqNWufjcrqCr4
	 MRzw9wsGzHY1DS/2JxyjAA+D14Yr3Q9u319E98cFh7q2vMm06ftXXF7IuyIcyoAdkSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wNjvCzhc;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B5660A5BC7
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43B5660A5BC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wNjvCzhc
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso7576625e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242205; x=1794847005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WjFXg6OvuRqQLh+vbRQ1oRonDN5U6tuBnKu/6O8lfTk=;
        b=wNjvCzhcAPRuTaY2w3J1g7ewdTXM80BYAKJcpxJCuywhazicfvw0+J9sLBDuXcyeZG
         7ssd8KfEK/TGDvUJx65zmk46r+qLh5UkOIc0kJ13/zzKBgUC7sVzm9qA7XxwjVFYHLKS
         cRtD4zrp0XXUWCLHh9yV7TK43hnvbxHENm6OshxAEVpvbHSs1BdBMBgIloDWRxhVOizr
         St8BFbN5XSv2TIq5NUtVYQ9u9Hhw5x5SZFmZRsHCtwRezUvOY4gzzQvRjsBZMV2k7cvQ
         zYm293TgZheClfGXCIUloz/stI8Vih7Yw4EA/yxbdUnwagBmyU5KPVkOL3NFBSJ/7cji
         xskQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242205; x=1794847005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WjFXg6OvuRqQLh+vbRQ1oRonDN5U6tuBnKu/6O8lfTk=;
        b=HCS6KMM+k0ouTNw+Vm0vJR0laaq8tHDOMk1NgtONl729YubvK9tkIRPS+eHh7G0mg0
         psOljm3Jn2WreRpxzu89tg6e9Bsajeafi1DL4GoJMWh0WU3+zC8OSpoCnWIsgGX5Nj0r
         d7eb2/2gQBZWVBAiLWDEpTBt5c4NW5eyq1TP8eRSr+hI/dYYrA0LUef6Woj3UzgdpkVc
         //bfJqXIi9PwIBfMYIcR4M7/JOCRRoU7d3H3ObysSOcZJDXqxJecdwAcE7Uq1LjYFiD5
         eWpXMkkQnYQ2NbQiCvqBJKEmIKu0u64yPjUjxDwU5XXyAKfqmJSOz2a+W8CgrWgq2g6O
         qQMA==
X-Gm-Message-State: APuU4Z/CGV3SWEcWdBlLPLxeT63CYHpGbBRGZOffprmmoYcpIjLdkU5s
	fXBjkMnCCZZLFEbcbyg3HiOgPYl3Zk+0MiDH7jiH7RVhjE24AkbepkcJ
X-Gm-Gg: AYBFou06gVYtkTyPODu/psEDH+DbOSBhPAowbGpxH+Io4GP00kqoxT6KTDoeMNjlFHd
	AeXUVe3pcVVayVqgV+SToLUoYM4Vtgq/vJcZZynZdM0cceF+FsHo97tPcsDW16LyjtexQvqIYk4
	IPIoPGCdRuxHGY/d9qLQf0JS1sn2fTJDpAXWaj+h4HYJZxFM0/L9TmYYShlz1fhI52zzsxVZtk2
	brqjVh3SnqxSSQQUr0wSFoaRaRAK7VsGv7qDtggW964mKIbdwCplF8z0Fz+oYaT9nQVS3txMktJ
	n/3Rf6vemQGZKIsLS1weM+nEgDtoCuYaeaULJC04JGfc+ZmE6CGuHp/sESvbIIhZpZWW2UXuXiI
	m0i8yS6+LzSM94Qr2C6QGaC9xoZ/ELwzzMFYfwXstfXgU+wD2owo9i7uNboFpOpzuYHCq5VL3kf
	+KOLliqxBe8hfguCIfdFA5lhNbSHg54dz12+RDRvvB8hnIBYOY7jq0bHVYwK6fXK27N6S6Q+0SA
	Zgv7N+WeXaVMRWPGFyMgkCyyMzKrf5FiCsSaZzYNq5oxPl2mC8B1GPVM+uUR+61D0ZDDYzo74Zi
	mYk8h5jXF7F37E0wV9GyCF3UfA==
X-Received: by 2002:a05:600c:1d05:b0:4a1:811c:8078 with SMTP id 5b1f17b1804b1-4b963c7585cmr87410965e9.26.1794242204690;
        Mon, 09 Nov 2026 08:36:44 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:44 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 14/29] sched/rt: Update task event callbacks for HCBS scheduling
Date: Mon,  9 Nov 2026 17:36:00 +0100
Message-ID: <20261109163616.195264-15-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com>
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

Update wakeup_preempt_rt, switched_{from/to}_rt and prio_changed_rt with
rt-cgroup's specific preemption rules:

- In wakeup_preempt_rt(), whenever a task wakes up, it must be checked if
  it is served by a deadline server or it lives on the global runqueue.
  Preemption rules (as documented in the function), change based on the
  current task's donor and woken task runqueue:
  - If both tasks are FIFO/RR tasks on the global runqueue, or the same
    cgroup, run as normal.
  - If woken is inside a cgroup, but donor is a FIFO task on the global
    runqueue, always preempt. If donor is a DEADLINE task, check if the dl
    server preempts donor.
  - If both tasks are FIFO/RR tasks in served but different groups, check
    whether the woken server preempts the donor server.
- In prio_changed_rt(), if the task is not running, only run preemption
  checks if the running task resides on the same task group of the task
  that changed priority.

Update sched_rt_can_attach() to check if a task can be attached to a given
cgroup. For now the check only consists in checking if the group has
non-zero bandwidth. Remove the tsk argument from sched_rt_can_attach, as
it is unused.

Change cpu_cgroup_can_attach() to check if the attachee is a FIFO/RR
task before attaching it to a cgroup.

Update __sched_setscheduler() to perform checks when trying to switch
to FIFO/RR for a task inside a cgroup, as the group needs to have
runtime allocated.

Update task_is_throttled_rt() for SCHED_CORE, returning the is_throttled
value of the server if present, while global rt-tasks are never throttled.

Update migration functions to ignore cgroups migration, to be implemented
in later patches.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c     |   2 +-
 kernel/sched/rt.c       | 108 +++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h    |   2 +-
 kernel/sched/syscalls.c |  12 +++++
 4 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f1d43e77c711..0425d2c98240 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9577,7 +9577,7 @@ static int cpu_cgroup_can_attach(struct cgroup_taskset *tset)
 		goto scx_check;

 	cgroup_taskset_for_each(task, css, tset) {
-		if (!sched_rt_can_attach(css_tg(css), task))
+		if (rt_task(task) && !sched_rt_can_attach(css_tg(css)))
 			return -EINVAL;
 	}
 scx_check:
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ec0198902b70..b7ea6b5da9e4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -372,6 +372,9 @@ static inline void rt_queue_push_tasks(struct rt_rq *rt_rq)
 {
 	struct rq *rq = global_rq_of_rt_rq(rt_rq);

+	if (is_dl_group(rt_rq))
+		return;
+
 	if (!has_pushable_tasks(rt_rq))
 		return;

@@ -382,6 +385,9 @@ static inline void rt_queue_pull_task(struct rt_rq *rt_rq)
 {
 	struct rq *rq = global_rq_of_rt_rq(rt_rq);

+	if (is_dl_group(rt_rq))
+		return;
+
 	queue_balance_callback(rq, &per_cpu(rt_pull_head, rq->cpu), pull_rt_task);
 }

@@ -832,6 +838,9 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flags)

 	__enqueue_rt_entity(rt_se, flags);

+	if (is_dl_group((rt_rq)))
+		return;
+
 	cpufreq_update_util(rq_of_rt_rq(rt_rq), 0);

 }
@@ -844,6 +853,9 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se, unsigned int flags)

 	__dequeue_rt_entity(rt_se, flags);

+	if (is_dl_group((rt_rq)))
+		return;
+
 	cpufreq_update_util(rq_of_rt_rq(rt_rq), 0);
 }

@@ -1046,7 +1058,56 @@ static int balance_rt(struct rq *rq, struct rq_flags *rf)
 static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct task_struct *donor = rq->donor;
+	struct sched_dl_entity *woken_dl_se = NULL;
+	struct sched_dl_entity *donor_dl_se = NULL;
+
+	if (!rt_group_sched_enabled())
+		goto same_group_sched;

+	/*
+	 * Preemption checks are different if the waking task and the current donor
+	 * are running on the global runqueue or in a cgroup. The following rules
+	 * apply:
+	 *   - dl-tasks (and equally dl_servers) always preempt FIFO/RR tasks.
+	 *     - if donor is a FIFO/RR task inside a cgroup (i.e. run by a
+	 *       dl_server), or donor is a DEADLINE task and waking is a FIFO/RR
+	 *       task on the root cgroup, do nothing.
+	 *     - if waking is inside a cgroup but donor is a FIFO/RR task in the
+	 *       root cgroup, always reschedule.
+	 *   - if they are both on the global runqueue or in the same cgroup, run
+	 *     the standard code.
+	 *   - if they are both in a cgroup, but not the same one, check whether the
+	 *     woken task's dl_server preempts the donor's dl_server.
+	 *   - if donor is a DEADLINE task and waking is in a cgroup, check whether
+	 *     the woken task's server preempts donor.
+	 */
+	if (is_dl_group(rt_rq_of_se(&p->rt)))
+		woken_dl_se = dl_group_of(rt_rq_of_se(&p->rt));
+
+	if (task_has_dl_policy(donor))
+		donor_dl_se = &donor->dl;
+	else if (is_dl_group(rt_rq_of_se(&donor->rt)))
+		donor_dl_se = dl_group_of(rt_rq_of_se(&donor->rt));
+
+	if (woken_dl_se != NULL && donor_dl_se != NULL) {
+		if (woken_dl_se == donor_dl_se) {
+			goto same_group_sched;
+		}
+
+		if (dl_entity_preempt(woken_dl_se, donor_dl_se))
+			resched_curr(rq);
+
+		return;
+
+	} else if (woken_dl_se != NULL) {
+		resched_curr(rq);
+		return;
+
+	} else if (donor_dl_se != NULL) {
+		return;
+	}
+
+same_group_sched:
 	/*
 	 * XXX If we're preempted by DL, queue a push?
 	 */
@@ -1071,7 +1132,8 @@ static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if (p->prio == donor->prio && !test_tsk_need_resched(rq->curr))
+	if (!is_dl_group(rt_rq_of_se(&p->rt)) &&
+	    p->prio == donor->prio && !test_tsk_need_resched(rq->curr))
 		check_preempt_equal_prio(rq, p);
 }

@@ -1384,6 +1446,9 @@ static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 	struct rt_rq *lowest_rt_rq;
 	int ret = 0;

+	if (is_dl_group(rt_rq))
+		return 0;
+
 	if (!rt_rq->overloaded)
 		return 0;

@@ -1690,6 +1755,9 @@ static void pull_rt_rq_task(struct rt_rq *this_rt_rq)
 	struct rq *src_rq;
 	int rt_overload_count = rt_overloaded(this_rq);

+	if (is_dl_group(&this_rq->rt))
+		return;
+
 	if (likely(!rt_overload_count))
 		return;

@@ -1833,6 +1901,8 @@ static void rq_offline_rt(struct rq *rq)
  */
 static void switched_from_rt(struct rq *rq, struct task_struct *p)
 {
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
+
 	/*
 	 * If there are other RT tasks then we will reschedule
 	 * and the scheduling of the other RT tasks will handle
@@ -1840,10 +1910,10 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (!task_on_rq_queued(p) || rq->rt.rt_nr_running)
+	if (!task_on_rq_queued(p) || rt_rq->rt_nr_running)
 		return;

-	rt_queue_pull_task(rt_rq_of_se(&p->rt));
+	rt_queue_pull_task(rt_rq);
 }

 void __init init_sched_rt_class(void)
@@ -1880,6 +1950,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	if (task_on_rq_queued(p)) {
 		if (p->nr_cpus_allowed > 1 && rt_rq_of_se(&p->rt)->overloaded)
 			rt_queue_push_tasks(rt_rq_of_se(&p->rt));
+
 		if (p->prio < rq->donor->prio && cpu_online(cpu_of(rq)))
 			resched_curr(rq);
 	}
@@ -1892,6 +1963,8 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, u64 oldprio)
 {
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
+
 	if (!task_on_rq_queued(p))
 		return;

@@ -1904,15 +1977,24 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, u64 oldprio)
 		 * may need to pull tasks to this runqueue.
 		 */
 		if (oldprio < p->prio)
-			rt_queue_pull_task(rt_rq_of_se(&p->rt));
+			rt_queue_pull_task(rt_rq);

 		/*
 		 * If there's a higher priority task waiting to run
 		 * then reschedule.
 		 */
-		if (p->prio > rq->rt.highest_prio.curr)
+		if (p->prio > rt_rq->highest_prio.curr)
 			resched_curr(rq);
 	} else {
+		/*
+		 * This task is not running, thus we check against the currently
+		 * running task for preemption. We can preempt only if both tasks are
+		 * in the same cgroup or on the global runqueue.
+		 */
+		if (rt_group_sched_enabled() &&
+		    rt_rq->tg != rt_rq_of_se(&rq->curr->rt)->tg)
+			return;
+
 		/*
 		 * This task is not running, but if it is
 		 * greater than the current running task
@@ -2005,7 +2087,19 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 #ifdef CONFIG_SCHED_CORE
 static int task_is_throttled_rt(struct task_struct *p, int cpu)
 {
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct rt_rq *rt_rq;
+
+	rt_rq = task_group(p)->rt_rq[cpu];
+	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
+
+	if (is_dl_group(rt_rq))
+		return dl_group_of(rt_rq)->dl_throttled;
+	else
+		return 0;
+#else
 	return 0;
+#endif
 }
 #endif /* CONFIG_SCHED_CORE */

@@ -2244,10 +2338,10 @@ long sched_group_rt_period(struct task_group *tg)
 	return rt_period_us;
 }

-int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+int sched_rt_can_attach(struct task_group *tg)
 {
 	/* Don't accept real-time tasks when there is no way for them to run */
-	if (rt_group_sched_enabled() && rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+	if (rt_group_sched_enabled() && tg->dl_bandwidth.dl_runtime == 0)
 		return 0;

 	return 1;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0166e75c7733..ef11619cfc30 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -603,7 +603,7 @@ extern int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 extern int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us);
 extern long sched_group_rt_runtime(struct task_group *tg);
 extern long sched_group_rt_period(struct task_group *tg);
-extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
+extern int sched_rt_can_attach(struct task_group *tg);

 extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_online_group(struct task_group *tg,
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 02688e75a8bd..8ed4a948b14d 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -606,6 +606,18 @@ int __sched_setscheduler(struct task_struct *p,
 change:

 	if (user) {
+		/*
+		 * Do not allow real-time tasks into groups that have no runtime
+		 * assigned.
+		 */
+		if (rt_group_sched_enabled() &&
+		    dl_bandwidth_enabled() && rt_policy(policy) &&
+		    !sched_rt_can_attach(task_group(p)) &&
+		    !task_group_is_autogroup(task_group(p))) {
+			retval = -EPERM;
+			goto unlock;
+		}
+
 		if (dl_bandwidth_enabled() && dl_policy(policy) &&
 				!(attr->sched_flags & SCHED_FLAG_SUGOV)) {
 			cpumask_t *span = rq->rd->span;
--
2.56.0

