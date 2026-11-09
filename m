Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242215;
	b=o+TLg7PunELsg65AW6SELzSXlMXxvv7CV5S8ST+iFk517K3mN0vWa+fvnhSgKeMVvMlR
	 Cz7e6B5no206TQehX5rqsVI1EnUnP6+WA+gHHygyfBbijf3yhG12UueLDWhCaKLSoItC/
	 /FbVM5ak92ieha61a55n8Cd9QWRx8WIBGNzfc7FUfsBdzrikWE6jvcEswnGi2nDleQz5U
	 2S712y8KPJ15zeFH0FSqI8SVx34tERv+6Z1E7TMRp7Eus78JtMIpTCRRRsJx8Wc6NfuCU
	 GpZv+hcJsQh79obWEDiU3H3kR+2tG6IKP/u4R3lYQJ6x7G4xF46mC83c0Y4lC+5r0fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SQakOIJ3odtJILa82eMvlmErnXwHne52IiOtyLJnsRs=;
	b=edk1UeDYh9XwsSgfq5qgXfreLLtxeWe+jpMSJyWvpgZCBffbyrmg4kpKu0JOWcUnfZhA
	 AgjTZhgW8crhlpwIReX+3xLPKIotYkCTFfEm11rscZ39RFvdY75rFoEMwsJRUwh+XD65d
	 ipY2l2lEblASYGUIlQzSrJCh40kBtMqeQ3WbEcb8mPAh4jigN7yRo2l9xwpjtHAHNhrvb
	 b/wmBPsdzfndHvNmO7i0PkyVsoTbXrYtmIzwJcqtixo7fGwucxMBR7Ymow79olDfG8RY6
	 IwC9Zh9teAp6UO4hD+PKTyZzy7HCkn/ztGUkagnAk89J88V4MjnSB7xUNEtWZ/lgmSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mXnkXHdU;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E66A60A6F6D
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E66A60A6F6D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mXnkXHdU
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so11605465e9.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242214; x=1794847014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SQakOIJ3odtJILa82eMvlmErnXwHne52IiOtyLJnsRs=;
        b=mXnkXHdU6KkL0B0nTKerWKVBtoZhM/eZ21/+gklRv6zFwEKUV+pr2qBWsGBcy8W7/4
         2lub6WhRj8PCVzAsiDOzkHPuyHmFYTXi4NCAzYQnsL3/CStNdsSEmZVK0+VVGa53BOun
         7tqpKC1XoSfTwV9i4lxqD0uAvfqbKsEj4aph72ylfZotq8Y4niM4iqPFuckPKqmxt5mG
         zwAUAMgPxHcNppa4feXPkgylLIRTgXdfpRYTxkwTZtSfV+wrNWTOKmlNaGC5+M8Dgp0H
         NU7MehkXMvo5CursI1CydKl7qkqv0qSyz6Q/ZmiSgjJze4+ADHnO1wvCMtecLyDL6aIP
         Yn/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242214; x=1794847014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SQakOIJ3odtJILa82eMvlmErnXwHne52IiOtyLJnsRs=;
        b=awmgNbZxMltJgXKXSpviUpfAz2KWKvK7AmeizJ738UBogd7XuiwZyXMGQ4MU8zWUnC
         S+NbhYXNfNjm0K/UIKgx92BbvZtYNrCb61DiZE2DkZnhNHdMtWlhIBAxBBRmLpNdmKFm
         0K7CLSZkr1kLeNMToXtEtvc/JKdXW9NRrbBOFNntHz4a4NpLrGy48LBHKoVv8jvMMgyT
         5DGJBut9bIZi6f+joI1tcYBBerKQKtYTQxXc9srfXtYH9532rf+1a2XMRbk66AXXvqVM
         Chm3bZs9SRSbbpQnpuVARoBrK+cvruUeS4MGPybJkfm7ZJQdcgQPeegUJlG/KbbBHE5a
         WThA==
X-Gm-Message-State: APuU4Z9i455CU940AfLVbLbSCD+zqq/Z9zVygTbttOffSskKeDYe9xaf
	jaR1hIv2whMiaTdYvhMNxa3y7FgD25WSrD5TpO7p7euqRr+W8VCAh58Y
X-Gm-Gg: AYBFou3vbbbZMuPt8tw51gSYDRbyuuNW020V+IYexxYiLBXNx8pfMM2kA5jRHyMYVCf
	CdVleZSC/+YEDhQOO0GI13QXre/GpoXOtUGumzkE9xSKtTtUi4/tCp91XzwSyKTfgJVm5t1iG6h
	ResRGa0nMk15KTJovdCfSJ/r6LPjGQVwKsf2cVKvUAo9ollDQaCXazy8b/GHRGBMgcrit1Tyh1h
	avz+kjbhhk+HhtxqFtxHiYLtXzn0iPWO8pD+1N9BOWLC1Kh+zFGYTnkTaGrNr/Mnfqhho2+wvN+
	U3V6PeFN8fZuJz5M15C4XSDYDwf8e+rXaq3ntGKAvSdFjrhQziSaGmXTVv94vWmXdlXOXV+dNV0
	IGZKaRGSjBvvB4ChXw+3l9K5HYYQQ5DvRrLjYU5UEMg+CY85I6ZuIvrRhzlcJzKc8oZ7OzGcvIH
	oYSlt1nr4gAPFOABEL7s+qEavpVFyHDpnK5yOVy7hgyhTafnhpvAPkcrDZ9NVM5UtSkgo7b6Phb
	qbiQRky9u3e2w6KKitMqaxqkFSq5TS6I2pt2/qiwrwnvcLKjI/0wXL8wT2IYMoYp37DQuWTJdhl
	6YyIWVE8dIhj6IzjuK00Ab22sA==
X-Received: by 2002:a05:600c:34c9:b0:4a1:fa33:441a with SMTP id 5b1f17b1804b1-4b94d7631ccmr86729705e9.2.1794242213578;
        Mon, 09 Nov 2026 08:36:53 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:53 -0800 (PST)
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
Subject: [RFC PATCH v7 19/29] sched/rt: Add HCBS migration code to related functions
Date: Mon,  9 Nov 2026 17:36:05 +0100
Message-ID: <20261109163616.195264-20-yurand2000@gmail.com>
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

Update rt_queue_{push/pull}_task{s} to differentiate between cgroup and
global runqueue balancing.

Introduce new balance callbacks for cgroup migration.

Add rq_to_push_from and rq_to_push_to fields for cgroup related migration.
  Balance callbacks are only called on the root runqueues, thus it is
  necessary to store which non-root runqueues need to be balanced. The rqs to
  balance are stored as a forward-linked list/stack, with the top pointers
  accessible on root runqueues.

Update migration functions to specialize for cgroup migration:
- find_lowest_rt_rq():
  Scan all the cpus to get the cgroup specific lowest_mask.
- find_lock_lowest_rt_rq():
  Use appropriate rt_rqs to differentiate the cgroup being checked.
  Prevent migration for throttled cgroups.
- push_rt_rq_task():
  Allow pushing away for migration disabled tasks only if the tasks
  belong to the same cgroup.
- pull_rt_rq_task():
  Use appropriate rt_rqs and push away for migration disabled only
  if the task to pull and curr are in the same runqueue.

Add tg_of_se to get the task group a scheduling entity is assigned to.
  This is different from the active context of the group.

Add new macros for field access and non-CONFIG_RT_GROUP_SCHED code.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c    | 292 +++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h |  24 ++++
 2 files changed, 248 insertions(+), 68 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b16cc77d7015..0b7c36f8acdc 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -364,31 +364,83 @@ static inline int has_pushable_tasks(struct rt_rq *rt_rq)

 static DEFINE_PER_CPU(struct balance_callback, rt_push_head);
 static DEFINE_PER_CPU(struct balance_callback, rt_pull_head);
+static DEFINE_PER_CPU(struct balance_callback, rt_group_push_head);
+static DEFINE_PER_CPU(struct balance_callback, rt_group_pull_head);

 static void push_rt_tasks(struct rq *);
 static void pull_rt_task(struct rq *);
+static void push_group_rt_tasks(struct rq *);
+static void pull_group_rt_task(struct rq *);
+
+#define rq_queue_field_push(global_rq, new_rq, field)		\
+	do {							\
+		struct rq *__rq = (global_rq);			\
+		struct rq *__new_rq = (new_rq);			\
+		__new_rq->field = __rq->field;			\
+		__rq->field = __new_rq;				\
+	} while (0)
+
+#define rq_queue_field_pop(global_rq, field)			\
+	({							\
+		struct rq *__rq = (global_rq);			\
+		struct rq *__head = __rq->field;		\
+		if (__head) {					\
+			__rq->field = __head->field;	\
+			__head->field = NULL;			\
+		}						\
+		__head;						\
+	})
+
+#define push_rq_to_push_from(global_rq, new_rq) rq_queue_field_push((global_rq), (new_rq), rq_to_push_from)
+#define pop_rq_to_push_from(global_rq) rq_queue_field_pop((global_rq), rq_to_push_from)
+
+#define push_rq_to_pull_to(global_rq, new_rq) rq_queue_field_push((global_rq), (new_rq), rq_to_pull_to)
+#define pop_rq_to_pull_to(global_rq) rq_queue_field_pop((global_rq), rq_to_pull_to)

 static inline void rt_queue_push_tasks(struct rt_rq *rt_rq)
 {
-	struct rq *rq = global_rq_of_rt_rq(rt_rq);
-
-	if (is_dl_group(rt_rq))
-		return;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rq *global_rq = global_rq_of_rt_rq(rt_rq);

 	if (!has_pushable_tasks(rt_rq))
 		return;

-	queue_balance_callback(rq, &per_cpu(rt_push_head, rq->cpu), push_rt_tasks);
+	if (!rt_group_sched_enabled() || !is_dl_group(rt_rq)) {
+
+		queue_balance_callback(global_rq,
+				       &per_cpu(rt_push_head, rq->cpu),
+				       push_rt_tasks);
+	} else {
+
+		push_rq_to_push_from(global_rq, rq);
+		queue_balance_callback(global_rq,
+				       &per_cpu(rt_group_push_head, global_rq->cpu),
+				       push_group_rt_tasks);
+	}
 }

 static inline void rt_queue_pull_task(struct rt_rq *rt_rq)
 {
-	struct rq *rq = global_rq_of_rt_rq(rt_rq);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rq *global_rq = global_rq_of_rt_rq(rt_rq);
+	struct sched_dl_entity *dl_se;

-	if (is_dl_group(rt_rq))
-		return;
+	if (!rt_group_sched_enabled() || !is_dl_group(rt_rq)) {
+
+		queue_balance_callback(global_rq,
+				       &per_cpu(rt_pull_head, rq->cpu),
+				       pull_rt_task);
+	} else {
+
+		dl_se = dl_group_of(rt_rq);
+		if (dl_se->dl_throttled)
+			return;

-	queue_balance_callback(rq, &per_cpu(rt_pull_head, rq->cpu), pull_rt_task);
+		push_rq_to_pull_to(global_rq, rq);
+		queue_balance_callback(global_rq,
+				       &per_cpu(rt_group_pull_head, global_rq->cpu),
+				       pull_group_rt_task);
+	}
 }

 static void push_rt_rq_tasks(struct rt_rq *rt_rq);
@@ -403,6 +455,31 @@ static void pull_rt_task(struct rq *global_rq) {
 	pull_rt_rq_task(&global_rq->rt);
 }

+static void push_group_rt_tasks(struct rq *global_rq)
+{
+	struct rq *rq;
+
+	while ((rq = pop_rq_to_push_from(global_rq))) {
+		struct rt_rq *rt_rq = &rq->rt;
+
+		if (rt_rq->rt_nr_running <= 1 && !dl_group_of(rt_rq)->dl_throttled)
+			continue;
+
+		push_rt_rq_tasks(rt_rq);
+	}
+}
+
+static void pull_group_rt_task(struct rq *global_rq)
+{
+	struct rq *rq;
+
+	while ((rq = pop_rq_to_pull_to(global_rq))) {
+		struct rt_rq *rt_rq = &rq->rt;
+
+		pull_rt_rq_task(rt_rq);
+	}
+}
+
 static void enqueue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rt_rq->pushable_tasks);
@@ -1246,35 +1323,74 @@ static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 static int find_lowest_rt_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
-	int this_cpu = smp_processor_id();
-	int cpu      = task_cpu(task);
-	int ret;
-
-	/* Make sure the mask is initialized first */
-	if (unlikely(!lowest_mask))
-		return -1;
+	cpumask_var_t mask __free(free_cpumask_var) = CPUMASK_VAR_NULL;
+	struct cpumask *lowest_mask;
+	struct sched_dl_entity *dl_se;
+	struct rt_rq *rt_rq, *task_rt_rq = rt_rq_of_se(&task->rt);
+	int cpu, this_cpu = smp_processor_id();
+	int ret, prio, lowest_prio;

 	if (task->nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */

-	/*
-	 * If we're on asym system ensure we consider the different capacities
-	 * of the CPUs when searching for the lowest_mask.
-	 */
-	if (sched_asym_cpucap_active()) {
+	if (!rt_group_sched_enabled() || !is_dl_group(task_rt_rq)) {
+
+		lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
+
+		/* Make sure the mask is initialized first */
+		if (unlikely(!lowest_mask))
+			return -1;
+
+		/*
+		* If we're on asym system ensure we consider the different
+		* capacities of the CPUs when searching for the lowest_mask.
+		*/
+		if (sched_asym_cpucap_active()) {
+
+			ret = cpupri_find_fitness(&task_rq(task)->rd->cpupri,
+						  task, lowest_mask,
+						  rt_task_fits_capacity);
+		} else {
+
+			ret = cpupri_find(&task_rq(task)->rd->cpupri,
+					  task, lowest_mask);
+		}

-		ret = cpupri_find_fitness(&task_rq(task)->rd->cpupri,
-					  task, lowest_mask,
-					  rt_task_fits_capacity);
+		if (!ret)
+			return -1; /* No targets found */
 	} else {
+		if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+			return -ENOMEM;
+
+		lowest_prio = task->prio - 1;
+		lowest_mask = mask;
+		cpumask_clear(lowest_mask);
+		for_each_cpu_and(cpu, cpu_online_mask, task->cpus_ptr) {
+			dl_se = dl_se_of_tg(task_rt_rq->tg, cpu);
+			rt_rq = &dl_se->my_q->rt;
+			prio = rt_rq->highest_prio.curr;

-		ret = cpupri_find(&task_rq(task)->rd->cpupri,
-				  task, lowest_mask);
+			/*
+			* If we're on asym system ensure we consider the
+			* different capacities of the CPUs when searching for
+			* the lowest_mask.
+			*/
+			if (dl_se->dl_throttled || !rt_task_fits_capacity(task, cpu))
+				continue;
+
+			if (prio >= lowest_prio) {
+				if (prio > lowest_prio) {
+					cpumask_clear(lowest_mask);
+					lowest_prio = prio;
+				}
+
+				cpumask_set_cpu(cpu, lowest_mask);
+			}
+		}
 	}

-	if (!ret)
-		return -1; /* No targets found */
+	if (cpumask_empty(lowest_mask))
+		return -1;

 	/*
 	 * At this point we have built a mask of CPUs representing the
@@ -1284,6 +1400,7 @@ static int find_lowest_rt_rq(struct task_struct *task)
 	 * We prioritize the last CPU that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
+	cpu = task_cpu(task);
 	if (cpumask_test_cpu(cpu, lowest_mask))
 		return cpu;

@@ -1294,30 +1411,27 @@ static int find_lowest_rt_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */

-	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_AFFINE) {
+	scoped_guard(rcu) {
+		for_each_domain(cpu, sd) {
 			int best_cpu;

+			if (!(sd->flags & SD_WAKE_AFFINE))
+				continue;
+
 			/*
 			 * "this_cpu" is cheaper to preempt than a
 			 * remote processor.
 			 */
 			if (this_cpu != -1 &&
-			    cpumask_test_cpu(this_cpu, sched_domain_span(sd))) {
-				rcu_read_unlock();
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
 				return this_cpu;
-			}

 			best_cpu = cpumask_any_and_distribute(lowest_mask,
 							      sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids) {
-				rcu_read_unlock();
+			if (best_cpu < nr_cpu_ids)
 				return best_cpu;
-			}
 		}
 	}
-	rcu_read_unlock();

 	/*
 	 * And finally, if there were no matches within the domains
@@ -1368,27 +1482,35 @@ static struct task_struct *pick_next_pushable_task(struct rt_rq *rt_rq)
 /* Will lock the rq it finds */
 static struct rt_rq *find_lock_lowest_rt_rq(struct task_struct *task, struct rt_rq *rt_rq)
 {
-	struct rq *rq = rq_of_rt_rq(rt_rq);
-	struct rq *lowest_rq = NULL;
-	int tries;
-	int cpu;
+	struct rq *lowest_rq, *rq = global_rq_of_rt_rq(rt_rq);
+	struct rt_rq *lowest_rt_rq;
+	struct sched_dl_entity *lowest_dl_se;
+	int tries, cpu;
+	bool dl_group;
+
+	dl_group = rt_group_sched_enabled() && is_dl_group(rt_rq);

 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
 		cpu = find_lowest_rt_rq(task);

 		if ((cpu == -1) || (cpu == rq->cpu))
-			break;
+			return NULL;

 		lowest_rq = cpu_rq(cpu);
+		if (dl_group) {
+			lowest_dl_se = dl_se_of_tg(rt_rq->tg, cpu);
+			lowest_rt_rq = &lowest_dl_se->my_q->rt;
+		} else {
+			lowest_rt_rq = &lowest_rq->rt;
+		}

-		if (lowest_rq->rt.highest_prio.curr <= task->prio) {
+		if (lowest_rt_rq->highest_prio.curr <= task->prio) {
 			/*
 			 * Target rq has tasks of equal or higher priority,
 			 * retrying does not release any lock and is unlikely
 			 * to yield a different result.
 			 */
-			lowest_rq = NULL;
-			break;
+			return NULL;
 		}

 		/* if the prio of this runqueue changed, try again */
@@ -1404,25 +1526,24 @@ static struct rt_rq *find_lock_lowest_rt_rq(struct task_struct *task, struct rt_
 			 * check the task migration disable flag here too.
 			 */
 			if (unlikely(is_migration_disabled(task) ||
+				     (dl_group && lowest_dl_se->dl_throttled) ||
 				     !cpumask_test_cpu(lowest_rq->cpu, &task->cpus_mask) ||
 				     task != pick_next_pushable_task(rt_rq))) {

 				double_unlock_balance(rq, lowest_rq);
-				lowest_rq = NULL;
-				break;
+				return NULL;
 			}
 		}

 		/* If this rq is still suitable use it. */
-		if (lowest_rq->rt.highest_prio.curr > task->prio)
-			break;
+		if (lowest_rt_rq->highest_prio.curr > task->prio)
+			return lowest_rt_rq;

 		/* try again */
 		double_unlock_balance(rq, lowest_rq);
-		lowest_rq = NULL;
 	}

-	return &lowest_rq->rt;
+	return NULL;
 }

 static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq) {
@@ -1442,12 +1563,10 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq) {
 static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 {
 	struct task_struct *next_task;
-	struct rq *lowest_rq, *rq = rq_of_rt_rq(rt_rq);
+	struct rq *lowest_rq, *rq = global_rq_of_rt_rq(rt_rq);
 	struct rt_rq *lowest_rt_rq;
 	int ret = 0;
-
-	if (is_dl_group(rt_rq))
-		return 0;
+	bool dl_group;

 	if (!rt_rq->overloaded)
 		return 0;
@@ -1462,7 +1581,8 @@ static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 	 * higher priority than current. If that's the case
 	 * just reschedule current.
 	 */
-	if (unlikely(next_task->prio < rq->donor->prio)) {
+	dl_group = rt_group_sched_enabled() && is_dl_group(rt_rq);
+	if (!dl_group && unlikely(next_task->prio < rq->donor->prio)) {
 		resched_curr(rq);
 		return 0;
 	}
@@ -1474,6 +1594,13 @@ static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 		if (!pull || rq->push_busy)
 			return 0;

+		/*
+		 * If the current task does not belong to the same task group
+		 * we cannot push it away.
+		 */
+		if (dl_group && rq->donor->sched_task_group != rt_rq->tg)
+			return 0;
+
 		/*
 		 * Invoking find_lowest_rt_rq() on anything but an RT task doesn't
 		 * make sense. Per the above priority check, curr has to
@@ -1550,7 +1677,7 @@ static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 		goto retry;
 	}

-	lowest_rq = rq_of_rt_rq(lowest_rt_rq);
+	lowest_rq = global_rq_of_rt_rq(lowest_rt_rq);
 	move_queued_task_locked(rq, lowest_rq, next_task);
 	resched_curr(lowest_rq);
 	ret = 1;
@@ -1747,16 +1874,22 @@ void rto_push_irq_work_func(struct irq_work *work)

 static void pull_rt_rq_task(struct rt_rq *this_rt_rq)
 {
-	struct rq *this_rq = rq_of_rt_rq(this_rt_rq);
+	struct rq* this_rq = global_rq_of_rt_rq(this_rt_rq);
 	int this_cpu = this_rq->cpu, cpu;
 	bool resched = false;
-	struct task_struct *p, *push_task;
+	struct task_struct *p, *push_task = NULL;
+	struct sched_dl_entity *src_dl_se;
 	struct rt_rq *src_rt_rq;
 	struct rq *src_rq;
-	int rt_overload_count = rt_overloaded(this_rq);
+	int rt_overload_count;
+	const struct cpumask *cpu_mask;
+	bool dl_group;

-	if (is_dl_group(&this_rq->rt))
-		return;
+	dl_group = rt_group_sched_enabled() && is_dl_group(this_rt_rq);
+	if (dl_group)
+		goto group_sched;
+
+	rt_overload_count = rt_overloaded(this_rq);

 	if (likely(!rt_overload_count))
 		return;
@@ -1779,12 +1912,26 @@ static void pull_rt_rq_task(struct rt_rq *this_rt_rq)
 	}
 #endif

-	for_each_cpu(cpu, this_rq->rd->rto_mask) {
+group_sched:
+	if (!dl_group)
+		cpu_mask = this_rq->rd->rto_mask;
+	else
+		cpu_mask = cpu_online_mask;
+
+	for_each_cpu(cpu, cpu_mask) {
 		if (this_cpu == cpu)
 			continue;

 		src_rq = cpu_rq(cpu);
-		src_rt_rq = &src_rq->rt;
+		if (!dl_group) {
+			src_rt_rq = &src_rq->rt;
+		} else {
+			src_dl_se = dl_se_of_tg(this_rt_rq->tg, cpu);
+			src_rt_rq = &src_dl_se->my_q->rt;
+
+			if (src_rt_rq->rt_nr_running <= 1 && !src_dl_se->dl_throttled)
+				continue;
+		}

 		/*
 		 * Don't bother taking the src_rq->lock if the next highest
@@ -1825,12 +1972,21 @@ static void pull_rt_rq_task(struct rt_rq *this_rt_rq)
 			 * This is just that p is waking up and hasn't
 			 * had a chance to schedule. We only pull
 			 * p if it is lower in priority than the
-			 * current task on the run queue
+			 * current task on the run queue and p is
+			 * in the same runqueue as donor.
 			 */
-			if (p->prio < src_rq->donor->prio)
+			if (tg_of_se(&src_rq->donor->rt) == this_rt_rq->tg &&
+			    p->prio < src_rq->donor->prio)
 				goto skip;

 			if (is_migration_disabled(p)) {
+				/*
+				 * If the current task does not belong to the
+				 * same task group we cannot push it away.
+				 */
+				if (tg_of_se(&src_rq->donor->rt) != this_rt_rq->tg)
+					goto skip;
+
 				push_task = get_push_task(src_rq);
 			} else {
 				move_queued_task_locked(src_rq, this_rq, p);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1242d297532f..835af319b78d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1403,6 +1403,16 @@ struct rq {
 	struct list_head	cfsb_csd_list;
 #endif

+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Balance callbacks operate only on global runqueues.
+	 * These pointers allow referencing cgroup specific runqueues
+	 * for balancing operations.
+	 */
+	struct rq		*rq_to_push_from;
+	struct rq		*rq_to_pull_to;
+#endif
+
 	atomic_t		nr_iowait;
 } __no_randomize_layout;

@@ -3520,6 +3530,11 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return rt_se->rt_rq;
 }

+static inline struct task_group *tg_of_se(struct sched_rt_entity *rt_se)
+{
+	return rt_rq_of_se(rt_se)->tg;
+}
+
 static inline int is_dl_group(struct rt_rq *rt_rq)
 {
 	return rt_rq->tg != &root_task_group;
@@ -3536,6 +3551,7 @@ static inline struct sched_dl_entity *dl_group_of(struct rt_rq *rt_rq)
 	return rt_rq->tg->dl_se[rq_of_rt_rq(rt_rq)->cpu];
 }

+#define dl_se_of_tg(tg, cpu) ((tg)->dl_se[(cpu)])
 #define dl_bw_lock_of_tg(tg) (&(tg)->dl_bandwidth.dl_runtime_lock)
 #else
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
@@ -3560,6 +3576,11 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	return &rq->rt;
 }

+static inline struct task_group *tg_of_se(struct sched_rt_entity *rt_se)
+{
+	return &root_task_group;
+}
+
 static inline int is_dl_group(struct rt_rq *rt_rq)
 {
 	return 0;
@@ -3570,6 +3591,9 @@ static inline struct sched_dl_entity *dl_group_of(struct rt_rq *rt_rq)
 	return NULL;
 }

+#define rq_to_push_from(rq) (rq)
+#define rq_to_pull_to(rq) (rq)
+#define dl_se_of_tg(tg, cpu) ((struct sched_dl_entity*)NULL)
 #define dl_bw_lock_of_tg(tg) ((raw_spinlock_t*)NULL)
 #endif

--
2.56.0

