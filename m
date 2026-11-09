Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242205;
	b=RI1qTt9Tan8f+o/r70T/OrbWHpxEhUe3csfCz2DqxA6mvwItY327EVoSlLVGWH31Njp4
	 BNtcVOnP90LA8qXcClTgODCfdWl6JWIqDWJZlxszCV/q94r7YdlsGJ6DWQKU9IePg50rX
	 arcoRwRRD0yzNNv2/srIjRNseHAlx3T+e0pvvcAu6c7WIMQMeO55OzZ6Pq5xcJSEcYEnr
	 Q9wVl0qovI1j2hviroFgjdo4Mdfi8oHvXDYa36Atp76EZ6UwzPs2cHkKDEJbql1nfPwrZ
	 5RHpo4xDAcHhjDTodigBKSriS/cPQX5uFdF8Y8ZEiUTr5Ci0B842C/ICPNz1n4gDXSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6ldczjvem2i6q2WhSmnnja5U3I99zaiiMJyYqWlHhT8=;
	b=3VijY+RHO7a0lrGN/pyOY+X0KcPSRKLxueUHpTGuzxTx5otObMNvjhAM36tdEYaLLlup
	 OJgDERrzYMSavAJOUzVRbXzDz8z/BzHXGmGl1luj065Ma7caXTpYL+krlboQCyKEeE4Iu
	 ICUnFTb+t1QK9ML96wMroNhrxaDmA2fg0XyC7Vq9PtI3kW0p6B9bU4cJnL1djv4SqoUsV
	 dtG8WYEbfgutvf6thobSr/JcbJMZhvag1xkaj/Q60PczYa2LP19dXCCec7xjKmRG/svwa
	 Eb/uR+/l2MEBIEs1WCOjlj6BMJU6b7J+Fg/TZkLPobG+TDtnje1kAEuqKEuouQYmbHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="PXDkFzd/";
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C0606EEAF
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA3C0606EEAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PXDkFzd/
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49d05d51553so8137145e9.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242203; x=1794847003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ldczjvem2i6q2WhSmnnja5U3I99zaiiMJyYqWlHhT8=;
        b=PXDkFzd/EtNL4zYJdGY/PMQTPtmsPyr32e/ALGMe0yUdW6mMBS+eowfujuKy1qF1hl
         vrhPxhR+ff5pP97EXS3Vjwld0cE82PVq1LCY3qDpWqMNv6wMOv8cP/D49YBZKufg07Ma
         fRsn9fyZv8z4bK4+aab9/mTM78lQiEJPH0EtGQ3i1i0zMI7J4S/p5wrATGUdJr9Q+iXZ
         NbJ4LKJKeQGUn/Qc+6cqjiTYTnYmqPEeUdooqeitHxVDmBZUwnm8CJCY2WsZcxdENy9F
         KBHjZ4ZTmJ1lCjYPf7uINlSUxCmr2raOLK4Gq8VJjkUX5+H/uWn+0WM3IwJqE0QoY2WZ
         C14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242203; x=1794847003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ldczjvem2i6q2WhSmnnja5U3I99zaiiMJyYqWlHhT8=;
        b=JmsVvI2izTUkWfI/ZaM1pKlkrDRfqMWxZhpj6FOV21i7Pav/HwS8Sy5Nzkud0VSVNW
         PsP92sXPKxEAyydzGnAVxZ7Jn957FnJsnAnZnT0Eydu3pWj47ooWl6hFuMEfgZO8KA5/
         KYCwoIC+5pUghqbtTeub4osiyPEe3TfU5RPHUhPtFnh0H/tMSgqVT+x2nKL2SY5Eo9Ct
         kNNm/5TDYECHgFNur/RAxB1yGAwOOeEIhcUE2g4Qs+qouBVoxeEpC1cJZgFNC2VW1vuB
         MzSr97RV4HVddNYa6MRYYniCJE6ybsNI8wL38RPKT7TMiaeZ45u6Row9IG9G/LDODwH1
         wFXQ==
X-Gm-Message-State: APuU4Z882OlWILJmUyO7aPxXy/3PC9IEswcL6dSZVIAoCKA620Zl8pdN
	3gPS8CVtL7KbKjX9v7+5B1UWGfbuC0AnCU2cOpPXrrdE2A3woYnffms4
X-Gm-Gg: AYBFou1PvXPI1uR6k1rfSIhGYyR/n3wYP8u0Vh5PjjQiri3bJNKXPSeThm5Iaay77DT
	CVjGsNuCeVR2fvnWZPIN1OcJTcGwEtbBGegokVenSLQP3de3oRaCwh7stItTRv5ng2mKTdg8nQK
	H3fT5lRaO1MxVEVQbzzNUhzsTdxSJQNAyKPDbWp3w+QK0geLUr7yGKowOa30vViwGKLhngMroUz
	0kSSIMjDjrz1MA1VV1HYDzKQcNsJUW+7zbqZ6kT8aNE6Q+U8SKca8/M86IBYYYl/f7ROuM2sqJf
	RCzBpXxSxnDNm8HA6r1I0o1g5GDg8guif7fPMEB+HV7JLZrJ7jxbneQkeNx44CcEx1RJitTRYFo
	KPwstS0YnpuqAPQ4OrECf7YekoDxtq1PJFN9cUNniKTGckBBHF+zblcYhvcqBsnGLauZBNYBJ/Z
	+LhSS92SpYLZPot5w/Fv80ivJsMOZYHPw8Ion3cU2XPVx301siWuVXtjq4uXNG2+fFAJDy503nR
	BWFIw+2FjbxhT6REwVRVFNuEp7dwhacM4+dqiM7H1Bb+ORVxqPOktamLjHOjOUdP0zCBVOImR1L
	Tsyr+YPVwo3GqIEjpc1VvToxig==
X-Received: by 2002:a05:600c:3e0a:b0:4a7:d9b1:b684 with SMTP id 5b1f17b1804b1-4b94d762e54mr87236505e9.2.1794242203274;
        Mon, 09 Nov 2026 08:36:43 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:42 -0800 (PST)
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
Subject: [RFC PATCH v7 13/29] sched/rt: Implement dl-server operations for rt-cgroups.
Date: Mon,  9 Nov 2026 17:35:59 +0100
Message-ID: <20261109163616.195264-14-yurand2000@gmail.com>
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

Implement rt_server_pick, the callback that deadline servers use to
pick a task to schedule.
  rt_server_pick(): pick the next runnable rt task and tell the
  scheduler that it is going to be scheduled next.

Let enqueue_task_rt function start the attached deadline server when the
first task is enqueued on a specific rq/server.
  The server is not symmetrically stopped in dequeue_task_rt as it is
  stopped when server_pick_task returns NULL (see deadline.c).

Change update_curr_rt to perform a deadline server update if the
updated task is served by non-root group.

Update {enqueue/dequeue}_pushable_task and rt_{set/clear}_overload to
only set the CPU-wise overload flag only if the root runqueues are
overloaded, but not for HCBS runqueues.

Update inc/dec_dl_tasks to account the number of active tasks in the
local runqueue for rt-cgroups servers, as their local runqueue is
different from the global runqueue, and thus when a rt-group server is
activated/deactivated, the number of served tasks' must be
added/removed. This uses nr_running to be compatible with future
dl-server interfaces. Account also the deadline server so that it is
picked for shutdown when its runqueue is empty (future patches will
try to pull tasks before stopping).

Update inc/dec_rt_prio_smp to change a rq's cpupri only if the rt_rq
is the global runqueue, since cgroups are scheduled via their
dl-server priority.

Update inc/dec_rt_tasks to account for waking/sleeping tasks on the
global runqueue, when the task runs on the root cgroup, or its local
dl server is active. The accounting is not done when servers are
throttled, as they will add/sub the number of tasks running when they
get enqueued/dequeued. For rt cgroups, account for the number of active
tasks in the nr_running field of the local runqueue (add/sub_nr_running),
as this number is used when a dl server is enqueued/dequeued.

Update set_task_rq to record the rt_rq of the cgroup's active_context,
tracking where to schedule the given task.

Update set_task_rq to record the dl_rq, tracking which deadline
server manages a task.

Update set_task_rq to not use the parent field anymore, as it is
unused by this patchset's code. Remove the unused parent field from
sched_rt_entity.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 include/linux/sched.h   |  1 -
 kernel/sched/deadline.c |  8 +++++
 kernel/sched/rt.c       | 70 ++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h    | 17 +++++-----
 4 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index febc03b02fa4..8780ef5def7e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -629,7 +629,6 @@ struct sched_rt_entity {

 	struct sched_rt_entity		*back;
 #ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity		*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct rt_rq			*rt_rq;
 	/* rq "owned" by this entity/group: */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7c2f4d2c9301..17f303294d6c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2293,6 +2293,10 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)

 	if (!dl_server(dl_se))
 		add_nr_running(rq_of_dl_rq(dl_rq), 1);
+	else if (rq_of_dl_se(dl_se) != dl_se->my_q) {
+		WARN_ON(dl_se->my_q->rt.rt_nr_running != dl_se->my_q->nr_running);
+		add_nr_running(rq_of_dl_rq(dl_rq), dl_se->my_q->nr_running + 1);
+	}

 	inc_dl_deadline(dl_rq, deadline);
 }
@@ -2305,6 +2309,10 @@ void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)

 	if (!dl_server(dl_se))
 		sub_nr_running(rq_of_dl_rq(dl_rq), 1);
+	else if (rq_of_dl_se(dl_se) != dl_se->my_q) {
+		WARN_ON(dl_se->my_q->rt.rt_nr_running != dl_se->my_q->nr_running);
+		sub_nr_running(rq_of_dl_rq(dl_rq), dl_se->my_q->nr_running + 1);
+	}

 	dec_dl_deadline(dl_rq, dl_se->deadline);
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e6f018db7579..ec0198902b70 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -284,9 +284,19 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 	return 1;
 }

+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq);
+
 static struct task_struct *rt_server_pick(struct sched_dl_entity *dl_se, struct rq_flags *rf)
 {
-	return NULL;
+	struct rt_rq *rt_rq = &dl_se->my_q->rt;
+	struct task_struct *p;
+
+	if (!sched_rt_runnable(dl_se->my_q))
+		return NULL;
+
+	p = rt_task_of(pick_next_rt_entity(rt_rq));
+
+	return p;
 }

 #else /* !CONFIG_RT_GROUP_SCHED */
@@ -314,6 +324,9 @@ static inline int rt_overloaded(struct rq *rq)

 static inline void rt_set_overload(struct rq *rq)
 {
+	if (is_dl_group(&rq->rt))
+		return;
+
 	if (!rq->online)
 		return;

@@ -333,6 +346,9 @@ static inline void rt_set_overload(struct rq *rq)

 static inline void rt_clear_overload(struct rq *rq)
 {
+	if (is_dl_group(&rq->rt))
+		return;
+
 	if (!rq->online)
 		return;

@@ -392,7 +408,7 @@ static void enqueue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 		rt_rq->highest_prio.next = p->prio;

 	if (!rt_rq->overloaded) {
-		rt_set_overload(global_rq_of_rt_rq(rt_rq));
+		rt_set_overload(rq_of_rt_rq(rt_rq));
 		rt_rq->overloaded = 1;
 	}
 }
@@ -410,7 +426,7 @@ static void dequeue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 		rt_rq->highest_prio.next = MAX_RT_PRIO-1;

 		if (rt_rq->overloaded) {
-			rt_clear_overload(global_rq_of_rt_rq(rt_rq));
+			rt_clear_overload(rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 0;
 		}
 	}
@@ -511,6 +527,7 @@ static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 static void update_curr_rt(struct rq *rq)
 {
 	struct task_struct *donor = rq->donor;
+	struct rt_rq *rt_rq;
 	s64 delta_exec;

 	if (donor->sched_class != &rt_sched_class)
@@ -520,21 +537,32 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely(delta_exec <= 0))
 		return;

-	if (!rt_bandwidth_enabled())
+	if (!rt_group_sched_enabled())
+		return;
+
+	if (!dl_bandwidth_enabled())
 		return;
+
+	rt_rq = rt_rq_of_se(&donor->rt);
+	if (is_dl_group(rt_rq)) {
+		struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+		dl_server_update(dl_se, delta_exec);
+	}
 }

 static void
 inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
-	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rq *rq;

 	/*
 	 * Change rq's cpupri only if rt_rq is the top queue.
 	 */
-	if (IS_ENABLED(CONFIG_RT_GROUP_SCHED) && &rq->rt != rt_rq)
+	if (is_dl_group(rt_rq))
 		return;

+	rq = rq_of_rt_rq(rt_rq);
 	if (rq->online && prio < prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
@@ -542,14 +570,15 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 static void
 dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
-	struct rq *rq = rq_of_rt_rq(rt_rq);
+	struct rq *rq;

 	/*
 	 * Change rq's cpupri only if rt_rq is the top queue.
 	 */
-	if (IS_ENABLED(CONFIG_RT_GROUP_SCHED) && &rq->rt != rt_rq)
+	if (is_dl_group(rt_rq))
 		return;

+	rq = rq_of_rt_rq(rt_rq);
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
@@ -610,6 +639,15 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rr_nr_running += is_rr_task(rt_se);

 	inc_rt_prio(rt_rq, rt_se_prio(rt_se));
+
+	if (is_dl_group(rt_rq)) {
+		struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+		if (!dl_se->dl_throttled)
+			add_nr_running(global_rq_of_rt_rq(rt_rq), 1);
+	}
+
+	add_nr_running(rq_of_rt_rq(rt_rq), 1);
 }

 static inline
@@ -620,6 +658,15 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rr_nr_running -= is_rr_task(rt_se);

 	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
+
+	if (is_dl_group(rt_rq)) {
+		struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+		if (!dl_se->dl_throttled)
+			sub_nr_running(global_rq_of_rt_rq(rt_rq), 1);
+	}
+
+	sub_nr_running(rq_of_rt_rq(rt_rq), 1);
 }

 /*
@@ -815,6 +862,13 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 	check_schedstat_required();
 	update_stats_wait_start_rt(rt_rq_of_se(rt_se), rt_se);

+	/* Task arriving in an idle group of tasks. */
+	if (is_dl_group(rt_rq) && rt_rq->rt_nr_running == 0) {
+		struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+		dl_server_start(dl_se);
+	}
+
 	enqueue_rt_entity(rt_se, flags);

 	if (task_is_blocked(p))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b55ce13412d6..0166e75c7733 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2427,15 +2427,12 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif

 #ifdef CONFIG_RT_GROUP_SCHED
-	/*
-	 * p->rt.rt_rq is NULL initially and it is easier to assign
-	 * root_task_group's rt_rq than switching in rt_rq_of_se()
-	 * Clobbers tg(!)
-	 */
 	if (!rt_group_sched_enabled())
 		tg = &root_task_group;
-	p->rt.rt_rq  = tg->rt_rq[cpu];
-	p->rt.parent = tg->rt_se[cpu];
+
+	guard(raw_spinlock_irqsave)(&tg->dl_bandwidth.dl_runtime_lock);
+	p->rt.rt_rq  = tg->dl_bandwidth.active_context->rt_rq[cpu];
+	p->dl.dl_rq  = &cpu_rq(cpu)->dl;
 #endif /* CONFIG_RT_GROUP_SCHED */
 }

@@ -3116,6 +3113,9 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 	unsigned prev_nr = rq->nr_running;

 	rq->nr_running = prev_nr + count;
+	if (rq != cpu_rq(rq->cpu))
+		return;
+
 	if (trace_sched_update_nr_running_tp_enabled()) {
 		call_trace_sched_update_nr_running(rq, count);
 	}
@@ -3129,6 +3129,9 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 static inline void sub_nr_running(struct rq *rq, unsigned count)
 {
 	rq->nr_running -= count;
+	if (rq != cpu_rq(rq->cpu))
+		return;
+
 	if (trace_sched_update_nr_running_tp_enabled()) {
 		call_trace_sched_update_nr_running(rq, -count);
 	}
--
2.56.0

