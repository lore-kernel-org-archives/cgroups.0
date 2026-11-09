Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242189;
	b=MqqhKRCqFQ2sUrOaLGqUNB1G8pLeFzbHvbrSkiAkoCMoVkazDMmAkQQQ6w6PmeLI64uU
	 IfDsdaC9lmCsUDQYhORKKWZZdSaUZxelymi3PAnlSP5gDvnUleGhv/7os24ZxF9eEu+jF
	 WPnLGhigp1VQ34lheyxJ8IRnMqAOs5SN3/0mtnSaGfaYQwVgXl8/r7cqjZb1tPETkvL0z
	 TtuB72fdr8JM4KVAN4dr2Oa/rbs/7BhYZMla3RRnptpLqEsdObeM2YqxYnPhyimzyDegh
	 SOFuEJvNC/B1funObQoPEHNP1QcxW9ByW8WECjAtylOIo/DYStlsILflUg4WN6rjp3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KO/0r+lIhJktKWfl2CvuTHQI6kveJU7dk3j+beHee14=;
	b=KZzyFucU/wXLVX/XKmjAjdV6KABh+XgUREldTqo2kxdPGKOTHak/4LJpXllMwFn4gm6e
	 2gX9Bce+XGXReYtUXc2lTg8RzzicWb8HCegVSLQEOcvFH76+aoQ9VlZdJMQ8Ue69WrUW9
	 HOKggoKG0ME0TetcV8kVdu1d7pvupWJ6QwNFEcv7d2gEjFcs9JjuesCCI09ZMld5EI6KS
	 tus0eH/00nWjSQXEj2o1HGHjh22T9BzRdPRSEEE0uVgn1aCfFlevdAjQBRrMfEY67kx9A
	 fPB5CPurWezKEkdPxJTj9c+cYtZLvoYJh8GWW/yBCZay6C6yAKzRPy1JlY/4xYE6O/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="gPT/ezDO";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4114606EE9A
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F4114606EE9A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gPT/ezDO
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso8467175e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242187; x=1794846987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KO/0r+lIhJktKWfl2CvuTHQI6kveJU7dk3j+beHee14=;
        b=gPT/ezDO5iWX8HLOauCyrEseGKTLRkHJ3eFOa7CEKz3nlf0fWI+9Ksa6gptP3WWXLu
         qkA/PL+xQpOBcJJ2XIQ9LRfbGoIa2Ld+2OZNvJLZrEgutYk14rqSlO2b2lUZGJUHxuul
         iaJ1BcuWXELkPN6pDC6olYULyHtqUqXaKl1aEZivP0/RaW2MaNRTs8RPgYUvYG44jMpZ
         1OEUBwrLwqanyB9g9ssseOQWBLBhhk+LfcoEd87S5ahBEhimlyjyQavahbukxnHvvsDW
         X2R6uhDzYVN/J/bcgaF+wb8pwpqkOcyjfDoQe79Sy0uVhKs0Fq9uL261W7uizsLkDGG2
         wP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242187; x=1794846987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KO/0r+lIhJktKWfl2CvuTHQI6kveJU7dk3j+beHee14=;
        b=F1JnOLFpB+5HrOoYYtDupVSqGeJgQ82OjXL4kkYkHSbqi3OI/LT6151FHvUwqh4586
         Rr7NDbrab39WV8FXJtfhioOttYmr9U7w2GgOf9ID2mOMUX6CkkxGf6z0AaEsglTurA5a
         tgZD1/C7zQ55H0qFkq4O2MmSJCo2nbdpNlP3+8jKvdUAkSEE+v7bnnBoJjugx9Nz2M+N
         s71TYgxkwy5DeI2iI57VmBkfmZJZtVPDLRva2yVEyHHQYOQ0gpTmXgmwV74byn0L+dPT
         0JvJIH3OQFUqxo/X5keA+6Y9LUDnI3OD5q8yXdnM7mjIj5Y2mFqNAO8VdsuTXakMzDxH
         AOpQ==
X-Gm-Message-State: APuU4Z9LwnsMDbDFFxgwNlV1UbxEuLl2StKn/wJibajMM4CJcT7Ylmej
	l6EC+meOU+hy5Rho0NCsPsNE3xsFDcYPPUFebhei92l1/p1Jlib28hFV
X-Gm-Gg: AYBFou2wKQiEooaZkww5ZVTUAtLe+CJ9n9EnCfdgu1Kq8J3RWTD1vS1fnmYQ5IBBUYb
	fkqB/lHejHYlX6e4gap5TWKuNL6T3LbTKdEa5aUrBZTtH9KYjs1Khneo1iREDC4yvlsRP7eOtZC
	fUCbWtpYl+1MUOWS6KmH7gr9lx9Tr/EALUbdr8ADmHekclPGhKPBDJeTJoQKCfLXXf2BtSDQ/QV
	PFdkw00NgQp5txnY4uGlUlmGX8QSUqGto38NWbob9lZBkxB3MfqcAGICCczibYerEyY8jpA3qga
	N35bVJWfJrF6vqUxiEgNbu6t2iH2azB7mZ7sDkHp4D4ipdW2zbFGCwr45pMD9lFfE7PgIsQVT1q
	+4jqQsjGru40UVnn4M39JFZ2BkHKnxvgvKcgk/SPM/EdYMY4CtE2ZxCN5t+wo1l55mQImPOisxX
	4M3pX9dOADiV5JzA6GCTYWodxnYNKEt4CJ+dBxUcnGg1OLLF8LR/oCx7BTjynL/PZkEPfsHn3N5
	kfFeyr0XXHdoMOva7zv0xfY/c7fHneJFKqpOStnRDWUiOVWVYTomRO/wjKJ8kfBlqwV+V4jsQg1
	euo9Naf/+OP44SF11etzfwDG/A==
X-Received: by 2002:a05:600c:34c4:b0:4a5:dc5d:20f7 with SMTP id 5b1f17b1804b1-4b962a42ca0mr82854325e9.14.1794242187267;
        Mon, 09 Nov 2026 08:36:27 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:25 -0800 (PST)
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
Subject: [RFC PATCH v7 04/29] sched/rt: Pass an rt_rq instead of an rq where needed
Date: Mon,  9 Nov 2026 17:35:50 +0100
Message-ID: <20261109163616.195264-5-yurand2000@gmail.com>
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

From: luca abeni <luca.abeni@santannapisa.it>

Make rt.c code access the runqueue through the rt_rq data structure rather
than passing an rq pointer directly. This allows future patches to define
rt_rq data structures which do not refer only to the global runqueue, but
also to local cgroup runqueues (as rt_rq will not be always equal to
&rq->rt).

Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/rt.c | 174 +++++++++++++++++++++++++++-------------------
 1 file changed, 104 insertions(+), 70 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1535046a23ff..2b1c3ab5d6a4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -370,9 +370,9 @@ static inline void rt_clear_overload(struct rq *rq)
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }

-static inline int has_pushable_tasks(struct rq *rq)
+static inline int has_pushable_tasks(struct rt_rq *rt_rq)
 {
-	return !plist_head_empty(&rq->rt.pushable_tasks);
+	return !plist_head_empty(&rt_rq->pushable_tasks);
 }

 static DEFINE_PER_CPU(struct balance_callback, rt_push_head);
@@ -381,50 +381,66 @@ static DEFINE_PER_CPU(struct balance_callback, rt_pull_head);
 static void push_rt_tasks(struct rq *);
 static void pull_rt_task(struct rq *);

-static inline void rt_queue_push_tasks(struct rq *rq)
+static inline void rt_queue_push_tasks(struct rt_rq *rt_rq)
 {
-	if (!has_pushable_tasks(rq))
+	struct rq *rq = container_of_const(rt_rq, struct rq, rt);
+
+	if (!has_pushable_tasks(rt_rq))
 		return;

 	queue_balance_callback(rq, &per_cpu(rt_push_head, rq->cpu), push_rt_tasks);
 }

-static inline void rt_queue_pull_task(struct rq *rq)
+static inline void rt_queue_pull_task(struct rt_rq *rt_rq)
 {
+	struct rq *rq = container_of_const(rt_rq, struct rq, rt);
+
 	queue_balance_callback(rq, &per_cpu(rt_pull_head, rq->cpu), pull_rt_task);
 }

-static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
+static void push_rt_rq_tasks(struct rt_rq *rt_rq);
+
+static void push_rt_tasks(struct rq *global_rq) {
+	push_rt_rq_tasks(&global_rq->rt);
+}
+
+static void pull_rt_rq_task(struct rt_rq *this_rt_rq);
+
+static void pull_rt_task(struct rq *global_rq) {
+	pull_rt_rq_task(&global_rq->rt);
+}
+
+static void enqueue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 {
-	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_del(&p->pushable_tasks, &rt_rq->pushable_tasks);
 	plist_node_init(&p->pushable_tasks, p->prio);
-	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_add(&p->pushable_tasks, &rt_rq->pushable_tasks);

 	/* Update the highest prio pushable task */
-	if (p->prio < rq->rt.highest_prio.next)
-		rq->rt.highest_prio.next = p->prio;
+	if (p->prio < rt_rq->highest_prio.next)
+		rt_rq->highest_prio.next = p->prio;

-	if (!rq->rt.overloaded) {
-		rt_set_overload(rq);
-		rq->rt.overloaded = 1;
+	if (!rt_rq->overloaded) {
+		rt_set_overload(rq_of_rt_rq(rt_rq));
+		rt_rq->overloaded = 1;
 	}
 }

-static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
+static void dequeue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 {
-	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_del(&p->pushable_tasks, &rt_rq->pushable_tasks);

 	/* Update the new highest prio pushable task */
-	if (has_pushable_tasks(rq)) {
-		p = plist_first_entry(&rq->rt.pushable_tasks,
+	if (has_pushable_tasks(rt_rq)) {
+		p = plist_first_entry(&rt_rq->pushable_tasks,
 				      struct task_struct, pushable_tasks);
-		rq->rt.highest_prio.next = p->prio;
+		rt_rq->highest_prio.next = p->prio;
 	} else {
-		rq->rt.highest_prio.next = MAX_RT_PRIO-1;
+		rt_rq->highest_prio.next = MAX_RT_PRIO-1;

-		if (rq->rt.overloaded) {
-			rt_clear_overload(rq);
-			rq->rt.overloaded = 0;
+		if (rt_rq->overloaded) {
+			rt_clear_overload(rq_of_rt_rq(rt_rq));
+			rt_rq->overloaded = 0;
 		}
 	}
 }
@@ -1436,6 +1452,7 @@ static void
 enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);

 	if (flags & ENQUEUE_WAKEUP)
 		rt_se->timeout = 0;
@@ -1449,17 +1466,18 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 		return;

 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
-		enqueue_pushable_task(rq, p);
+		enqueue_pushable_task(rt_rq, p);
 }

 static bool dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);

 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se, flags);

-	dequeue_pushable_task(rq, p);
+	dequeue_pushable_task(rt_rq, p);

 	return true;
 }
@@ -1498,7 +1516,7 @@ static void yield_task_rt(struct rq *rq)
 	requeue_task_rt(rq, rq->donor, 0);
 }

-static int find_lowest_rq(struct task_struct *task);
+static int find_lowest_rt_rq(struct task_struct *task);

 static int
 select_task_rq_rt(struct task_struct *p, int cpu, int flags)
@@ -1548,7 +1566,7 @@ select_task_rq_rt(struct task_struct *p, int cpu, int flags)
 	       (curr->nr_cpus_allowed < 2 || donor->prio <= p->prio);

 	if (test || !rt_task_fits_capacity(p, cpu)) {
-		int target = find_lowest_rq(p);
+		int target = find_lowest_rt_rq(p);

 		/*
 		 * Bail out if we were forcing a migration to find a better
@@ -1612,7 +1630,7 @@ static int balance_rt(struct rq *rq, struct rq_flags *rf)
 		 * not yet started the picking loop.
 		 */
 		rq_unpin_lock(rq, rf);
-		pull_rt_task(rq);
+		pull_rt_rq_task(&rq->rt);
 		rq_repin_lock(rq, rf);
 	}

@@ -1657,7 +1675,7 @@ static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, enum snt_e type)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq = &rq->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);

 	if (type == SNT_REPICK)
 		return;
@@ -1667,7 +1685,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, enum s
 		update_stats_wait_end_rt(rt_rq, rt_se);

 	/* The running task is never eligible for pushing */
-	dequeue_pushable_task(rq, p);
+	dequeue_pushable_task(rt_rq, p);

 	if (type != SNT_PICK)
 		return;
@@ -1680,7 +1698,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, enum s
 	if (rq->donor->sched_class != &rt_sched_class)
 		update_rt_rq_load_avg(rq_clock_pelt(rq), rq, 0);

-	rt_queue_push_tasks(rq);
+	rt_queue_push_tasks(rt_rq);
 }

 static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
@@ -1731,7 +1749,7 @@ static struct task_struct *pick_task_rt(struct rq *rq, struct rq_flags *rf)
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p, struct task_struct *next)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq = &rq->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);

 	if (on_rt_rq(&p->rt))
 		update_stats_wait_start_rt(rt_rq, rt_se);
@@ -1747,7 +1765,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p, struct task_s
 	 * if it is still active
 	 */
 	if (on_rt_rq(&p->rt) && p->nr_cpus_allowed > 1)
-		enqueue_pushable_task(rq, p);
+		enqueue_pushable_task(rt_rq, p);
 }

 /* Only try algorithms three times */
@@ -1757,16 +1775,16 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p, struct task_s
  * Return the highest pushable rq's task, which is suitable to be executed
  * on the CPU, NULL otherwise
  */
-static struct task_struct *pick_highest_pushable_task(struct rq *rq, int cpu)
+static struct task_struct *pick_highest_pushable_task(struct rt_rq *rt_rq, int cpu)
 {
-	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct plist_head *head = &rt_rq->pushable_tasks;
 	struct task_struct *p;

-	if (!has_pushable_tasks(rq))
+	if (!has_pushable_tasks(rt_rq))
 		return NULL;

 	plist_for_each_entry(p, head, pushable_tasks) {
-		if (task_is_pushable(rq, p, cpu))
+		if (task_is_pushable(rq_of_rt_rq(rt_rq), p, cpu))
 			return p;
 	}

@@ -1775,7 +1793,7 @@ static struct task_struct *pick_highest_pushable_task(struct rq *rq, int cpu)

 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);

-static int find_lowest_rq(struct task_struct *task)
+static int find_lowest_rt_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
 	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
@@ -1866,12 +1884,13 @@ static int find_lowest_rq(struct task_struct *task)
 	return -1;
 }

-static struct task_struct *pick_next_pushable_task(struct rq *rq)
+static struct task_struct *pick_next_pushable_task(struct rt_rq *rt_rq)
 {
-	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct plist_head *head = &rt_rq->pushable_tasks;
 	struct task_struct *i, *p = NULL;

-	if (!has_pushable_tasks(rq))
+	if (!has_pushable_tasks(rt_rq))
 		return NULL;

 	plist_for_each_entry(i, head, pushable_tasks) {
@@ -1897,14 +1916,15 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 }

 /* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
+static struct rt_rq *find_lock_lowest_rt_rq(struct task_struct *task, struct rt_rq *rt_rq)
 {
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 	struct rq *lowest_rq = NULL;
 	int tries;
 	int cpu;

 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		cpu = find_lowest_rq(task);
+		cpu = find_lowest_rt_rq(task);

 		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
@@ -1935,7 +1955,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 			 */
 			if (unlikely(is_migration_disabled(task) ||
 				     !cpumask_test_cpu(lowest_rq->cpu, &task->cpus_mask) ||
-				     task != pick_next_pushable_task(rq))) {
+				     task != pick_next_pushable_task(rt_rq))) {

 				double_unlock_balance(rq, lowest_rq);
 				lowest_rq = NULL;
@@ -1952,7 +1972,16 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 		lowest_rq = NULL;
 	}

-	return lowest_rq;
+	return &lowest_rq->rt;
+}
+
+static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq) {
+	struct rt_rq *rt_rq = find_lock_lowest_rt_rq(task, &rq->rt);
+
+	if (!rt_rq)
+		return NULL;
+
+	return rq_of_rt_rq(rt_rq);
 }

 /*
@@ -1960,16 +1989,17 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
  * running task can migrate over to a CPU that is running a task
  * of lesser priority.
  */
-static int push_rt_task(struct rq *rq, bool pull)
+static int push_rt_rq_task(struct rt_rq *rt_rq, bool pull)
 {
 	struct task_struct *next_task;
-	struct rq *lowest_rq;
+	struct rq *lowest_rq, *rq = rq_of_rt_rq(rt_rq);
+	struct rt_rq *lowest_rt_rq;
 	int ret = 0;

-	if (!rq->rt.overloaded)
+	if (!rt_rq->overloaded)
 		return 0;

-	next_task = pick_next_pushable_task(rq);
+	next_task = pick_next_pushable_task(rt_rq);
 	if (!next_task)
 		return 0;

@@ -1992,7 +2022,7 @@ static int push_rt_task(struct rq *rq, bool pull)
 			return 0;

 		/*
-		 * Invoking find_lowest_rq() on anything but an RT task doesn't
+		 * Invoking find_lowest_rt_rq() on anything but an RT task doesn't
 		 * make sense. Per the above priority check, curr has to
 		 * be of higher priority than next_task, so no need to
 		 * reschedule when bailing out.
@@ -2003,7 +2033,7 @@ static int push_rt_task(struct rq *rq, bool pull)
 		if (rq->donor->sched_class != &rt_sched_class)
 			return 0;

-		cpu = find_lowest_rq(rq->curr);
+		cpu = find_lowest_rt_rq(rq->curr);
 		if (cpu == -1 || cpu == rq->cpu)
 			return 0;

@@ -2032,19 +2062,19 @@ static int push_rt_task(struct rq *rq, bool pull)
 	/* We might release rq lock */
 	get_task_struct(next_task);

-	/* find_lock_lowest_rq locks the rq if found */
-	lowest_rq = find_lock_lowest_rq(next_task, rq);
-	if (!lowest_rq) {
+	/* find_lock_lowest_rt_rq locks the rq if found */
+	lowest_rt_rq = find_lock_lowest_rt_rq(next_task, rt_rq);
+	if (!lowest_rt_rq) {
 		struct task_struct *task;
 		/*
-		 * find_lock_lowest_rq releases rq->lock
+		 * find_lock_lowest_rt_rq releases rq->lock
 		 * so it is possible that next_task has migrated.
 		 *
 		 * We need to make sure that the task is still on the same
 		 * run-queue and is also still the next task eligible for
 		 * pushing.
 		 */
-		task = pick_next_pushable_task(rq);
+		task = pick_next_pushable_task(rt_rq);
 		if (task == next_task) {
 			/*
 			 * The task hasn't migrated, and is still the next
@@ -2067,6 +2097,7 @@ static int push_rt_task(struct rq *rq, bool pull)
 		goto retry;
 	}

+	lowest_rq = rq_of_rt_rq(lowest_rt_rq);
 	move_queued_task_locked(rq, lowest_rq, next_task);
 	resched_curr(lowest_rq);
 	ret = 1;
@@ -2078,10 +2109,10 @@ static int push_rt_task(struct rq *rq, bool pull)
 	return ret;
 }

-static void push_rt_tasks(struct rq *rq)
+static void push_rt_rq_tasks(struct rt_rq *rt_rq)
 {
-	/* push_rt_task will return true if it moved an RT */
-	while (push_rt_task(rq, false))
+	/* push_rt_rq_task will return true if it moved an RT */
+	while (push_rt_rq_task(rt_rq, false))
 		;
 }

@@ -2237,9 +2268,9 @@ void rto_push_irq_work_func(struct irq_work *work)
 	 * We do not need to grab the lock to check for has_pushable_tasks.
 	 * When it gets updated, a check is made if a push is possible.
 	 */
-	if (has_pushable_tasks(rq)) {
+	if (has_pushable_tasks(&rq->rt)) {
 		raw_spin_rq_lock(rq);
-		while (push_rt_task(rq, true))
+		while (push_rt_rq_task(&rq->rt, true))
 			;
 		raw_spin_rq_unlock(rq);
 	}
@@ -2261,11 +2292,13 @@ void rto_push_irq_work_func(struct irq_work *work)
 }
 #endif /* HAVE_RT_PUSH_IPI */

-static void pull_rt_task(struct rq *this_rq)
+static void pull_rt_rq_task(struct rt_rq *this_rt_rq)
 {
+	struct rq *this_rq = rq_of_rt_rq(this_rt_rq);
 	int this_cpu = this_rq->cpu, cpu;
 	bool resched = false;
 	struct task_struct *p, *push_task;
+	struct rt_rq *src_rt_rq;
 	struct rq *src_rq;
 	int rt_overload_count = rt_overloaded(this_rq);

@@ -2295,6 +2328,7 @@ static void pull_rt_task(struct rq *this_rq)
 			continue;

 		src_rq = cpu_rq(cpu);
+		src_rt_rq = &src_rq->rt;

 		/*
 		 * Don't bother taking the src_rq->lock if the next highest
@@ -2303,8 +2337,8 @@ static void pull_rt_task(struct rq *this_rq)
 		 * logically higher, the src_rq will push this task away.
 		 * And if its going logically lower, we do not care
 		 */
-		if (src_rq->rt.highest_prio.next >=
-		    this_rq->rt.highest_prio.curr)
+		if (src_rt_rq->highest_prio.next >=
+		    this_rt_rq->highest_prio.curr)
 			continue;

 		/*
@@ -2319,13 +2353,13 @@ static void pull_rt_task(struct rq *this_rq)
 		 * We can pull only a task, which is pushable
 		 * on its rq, and no others.
 		 */
-		p = pick_highest_pushable_task(src_rq, this_cpu);
+		p = pick_highest_pushable_task(src_rt_rq, this_cpu);

 		/*
 		 * Do we have an RT task that preempts
 		 * the to-be-scheduled task?
 		 */
-		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
+		if (p && (p->prio < this_rt_rq->highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
 			WARN_ON(!task_on_rq_queued(p));

@@ -2384,7 +2418,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 			     rq->donor->prio <= p->prio);

 	if (need_to_push)
-		push_rt_tasks(rq);
+		push_rt_rq_tasks(rt_rq_of_se(&p->rt));
 }

 /* Assumes rq->lock is held */
@@ -2425,7 +2459,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	if (!task_on_rq_queued(p) || rq->rt.rt_nr_running)
 		return;

-	rt_queue_pull_task(rq);
+	rt_queue_pull_task(rt_rq_of_se(&p->rt));
 }

 void __init init_sched_rt_class(void)
@@ -2460,8 +2494,8 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * then see if we can move to another run queue.
 	 */
 	if (task_on_rq_queued(p)) {
-		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded)
-			rt_queue_push_tasks(rq);
+		if (p->nr_cpus_allowed > 1 && rt_rq_of_se(&p->rt)->overloaded)
+			rt_queue_push_tasks(rt_rq_of_se(&p->rt));
 		if (p->prio < rq->donor->prio && cpu_online(cpu_of(rq)))
 			resched_curr(rq);
 	}
@@ -2486,7 +2520,7 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, u64 oldprio)
 		 * may need to pull tasks to this runqueue.
 		 */
 		if (oldprio < p->prio)
-			rt_queue_pull_task(rq);
+			rt_queue_pull_task(rt_rq_of_se(&p->rt));

 		/*
 		 * If there's a higher priority task waiting to run
--
2.56.0

