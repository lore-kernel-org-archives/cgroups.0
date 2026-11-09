Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242196;
	b=oPK7f7KIptCd/6qR8l2hpRFL3uYiNhZL/n+fA4dpJxBggkl54GUeU9JDGcmdZVU0tz+Y
	 4Onf1khvib/wiVg8MEZtxksOUUOg1J8yhUlB972S2Xh0qGg2COde/OumrO3p1TMG/qdbZ
	 UaqJAemYvv4gCV8aJVGo+ilj1H9R6Eux3JotAJtqtBegvph+Qut7a4a4PP/tL9o3k9ofK
	 GTqHTBb8I8GrtEyN+SQ2IyOy2Yh4sxC6EnwmWnQsmTzFFg114F/qm3e/XfmQ6h7b4TH7A
	 A4k68v+6V65aTUXjwSP1yviicYGkVa1+HEsmbAQYKkMDZ084DnzJ3pwUcyZdEnbHwVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242196;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IF9cXrQnpCZaMLl6tbZ/qIT+Y3H9j+DMc+Ad29JxSyU=;
	b=Dnw5l43db+1WgPkhL2c6NRPZUqTskXolvR+V/8lTbBylRfL/gWVAe45ILKOuPPD0aGOF
	 pKeOhgiiusWMF1IVaYU8OCkKrRc9rLkh+ezlGgzT0HEaH1M3YqaNVfrlB1ga33LMgmku5
	 1h2XD2FtDD/+x+S82ILLmQYgvk3x1uJh/Wo2EFh7d/m49PiL7yi0vKbx9HWgCDOCuC7zD
	 DCRt0tdy8aUc/3ZLpj8ZT7X/QJgRQ3JM0/ztxNbgDHnWMf6kkiVV3HNh+DKeQ1b+eAieH
	 PlO3jZEmwq3hkeZkpCSbWlUgvTFKBq2xSJoo9vzWNo75h8hFKK+pmbhjsu0JmYGcb0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RtuD168J;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FD160A260B
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54FD160A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RtuD168J
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso7573325e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242194; x=1794846994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IF9cXrQnpCZaMLl6tbZ/qIT+Y3H9j+DMc+Ad29JxSyU=;
        b=RtuD168Jkqr9RnhP3VMpSCTS57mW0ngLJEssT/lggiAeqhJ1TGtnCYEy98hldAzYg1
         +HIQKkkGGlz1rmBIMRVy4eRHzwJBC1uDy0Kecaqd5VtjjexTUe3TMA9mpLsRbMfJGm2g
         dXmUgEBKOQWFuqB0O3CZkjf8zYBYIUqgcKdMvseGuUGPpSe+xZPgb5JYfcTOUiOi6ZK9
         PF15UToNpsB7tLnNMRAer876U08Po1RtHBWhuv0NRjHC/onAiN8JR8DM382W3evZ+atb
         nMByC4W/LckRhCYxZjhjwyes0ZjZZyzC4YpqbsHTFye+awZwS8suUJzhGpJpAZsWilyo
         lGgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242194; x=1794846994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IF9cXrQnpCZaMLl6tbZ/qIT+Y3H9j+DMc+Ad29JxSyU=;
        b=iYVjNCs49Hn3a59JIATbPjUbaUBpGmgjP0htrAOUVBLrGfknJxl7T9vM7eUXDPUidb
         OV+Sb0g5GDfCLeF19SvuS9yKucYPZAsg79FJ1/QBrkV9puJI66U8qgSc8x9FemeiqyEI
         eiDJSOvSf7p+cXYIkABgeZulIQZISfwFfRu0rSXrnGI4XdVc7XHHtWyh6GGckU7MHSGW
         hg2IdajHpIWOGwAOy5fkALN8dgzxF9WmLNKBvLcXf2FRbugEtbiav8zTj/VY0PMetyRT
         AYcIZZfvHu2k9+J4pivwfPubXdVeoe6/1wZ+RlNA4dNgdMhneb01qGyimnuGPhBBSJ7R
         MVSg==
X-Gm-Message-State: APuU4Z+aZNgMCSRok8f+dMS4qmyUO3fMcLwp7NvTsxEP8QiVkRBDu+nv
	JrPgAvo/PgoRV3MI3uG64nKX0j6Zj9btzVlGSxghV49UTsSQ82jI63ik
X-Gm-Gg: AYBFou1y3eGR3loMG+G5WRUum78hlXGPkoFYo93iJq76bL3/WhmyU81Ef5iHqA9ZI3w
	lRykviRlOcd07FWXun1uZc5Ex7is/fZA0w2cgf4fueF+vbxZULXIAKE7RAwBII9uf448zaZn2I9
	Rl69LY6GgkS4AlUpvGMapeIt6bo630jbyLF/tbUg3r9K54khJ08x11H+/3hlQ00iGu+jfS5cKUA
	sldxb5daPgfwoI3DBxCtNef89SIU8JFzLZDCl00G50I4DFLVAHjtIM6MOZNNGECLW367vCPzSyB
	DD9EvELRJMVx5qaWUmwW6NBDh2lkx7MLXvWVppThxIXltQhMfKerluAz7Wegh+KtPCKBAk77xIK
	UQQLaXZzOP+RHpx7m3mlqo8MDSyhCj5e3/MzuO9SXzX/mef6ixYWB9OU7WW72hAatr8eUc5aiZF
	djSuIIjkEYfYzjOC2+D0b3FkvOL8KR5aliH4UfNbWTRyuKHC1gjC5tGBoJWRetLcJ3Vn7xHiuJZ
	R7qwI0bYPtcBIKPgRb6ta6lR3hs+q62D+ibqBTHPEWW0pekId+1MX3Hv1CM+izkDBElql8cVSfN
	j0GWm4tmwiTAlsG2l5KTTY3M0w==
X-Received: by 2002:a05:600c:524d:b0:4a2:397:73f6 with SMTP id 5b1f17b1804b1-4b960d9c550mr90005315e9.8.1794242193648;
        Mon, 09 Nov 2026 08:36:33 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:32 -0800 (PST)
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
Subject: [RFC PATCH v7 07/29] sched/rt: Remove unnecessary runqueue pointer in struct rt_rq
Date: Mon,  9 Nov 2026 17:35:53 +0100
Message-ID: <20261109163616.195264-8-yurand2000@gmail.com>
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

Remove the rq field in struct rt_rq.
  The rq field now is just caching the pointer to the global runqueue of the
  given rt_rq, so it is unnecessary as the global runqueue can be retrieved
  in other ways.

Introduce global_rq_of_rt_rq to retrieve the global runqueue which serves a
rt_rq's dl_server.
Rework rq_of_rt_rq to retrieve the runqueue a rt_rq is serving.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c    | 21 +++++++++------------
 kernel/sched/sched.h | 16 ++++++++++++----
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 6b819adcab4a..16eb027d4bdd 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -101,10 +101,7 @@ void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent)
 {
-	struct rq *rq = cpu_rq(cpu);
-
 	rt_rq->highest_prio.curr = MAX_RT_PRIO-1;
-	rt_rq->rq = rq;
 	rt_rq->tg = tg;

 	tg->rt_rq[cpu] = rt_rq;
@@ -184,7 +181,7 @@ static void pull_rt_task(struct rq *);

 static inline void rt_queue_push_tasks(struct rt_rq *rt_rq)
 {
-	struct rq *rq = container_of_const(rt_rq, struct rq, rt);
+	struct rq *rq = global_rq_of_rt_rq(rt_rq);

 	if (!has_pushable_tasks(rt_rq))
 		return;
@@ -194,7 +191,7 @@ static inline void rt_queue_push_tasks(struct rt_rq *rt_rq)

 static inline void rt_queue_pull_task(struct rt_rq *rt_rq)
 {
-	struct rq *rq = container_of_const(rt_rq, struct rq, rt);
+	struct rq *rq = global_rq_of_rt_rq(rt_rq);

 	queue_balance_callback(rq, &per_cpu(rt_pull_head, rq->cpu), pull_rt_task);
 }
@@ -222,7 +219,7 @@ static void enqueue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 		rt_rq->highest_prio.next = p->prio;

 	if (!rt_rq->overloaded) {
-		rt_set_overload(rq_of_rt_rq(rt_rq));
+		rt_set_overload(global_rq_of_rt_rq(rt_rq));
 		rt_rq->overloaded = 1;
 	}
 }
@@ -240,7 +237,7 @@ static void dequeue_pushable_task(struct rt_rq *rt_rq, struct task_struct *p)
 		rt_rq->highest_prio.next = MAX_RT_PRIO-1;

 		if (rt_rq->overloaded) {
-			rt_clear_overload(rq_of_rt_rq(rt_rq));
+			rt_clear_overload(global_rq_of_rt_rq(rt_rq));
 			rt_rq->overloaded = 0;
 		}
 	}
@@ -495,7 +492,7 @@ update_stats_wait_start_rt(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 	if (!stats)
 		return;

-	__update_stats_wait_start(rq_of_rt_rq(rt_rq), p, stats);
+	__update_stats_wait_start(global_rq_of_rt_rq(rt_rq), p, stats);
 }

 static inline void
@@ -512,7 +509,7 @@ update_stats_enqueue_sleeper_rt(struct rt_rq *rt_rq, struct sched_rt_entity *rt_
 	if (!stats)
 		return;

-	__update_stats_enqueue_sleeper(rq_of_rt_rq(rt_rq), p, stats);
+	__update_stats_enqueue_sleeper(global_rq_of_rt_rq(rt_rq), p, stats);
 }

 static inline void
@@ -540,7 +537,7 @@ update_stats_wait_end_rt(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 	if (!stats)
 		return;

-	__update_stats_wait_end(rq_of_rt_rq(rt_rq), p, stats);
+	__update_stats_wait_end(global_rq_of_rt_rq(rt_rq), p, stats);
 }

 static inline void
@@ -564,11 +561,11 @@ update_stats_dequeue_rt(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
 		state = READ_ONCE(p->__state);
 		if (state & TASK_INTERRUPTIBLE)
 			__schedstat_set(p->stats.sleep_start,
-					rq_clock(rq_of_rt_rq(rt_rq)));
+					rq_clock(global_rq_of_rt_rq(rt_rq)));

 		if (state & TASK_UNINTERRUPTIBLE)
 			__schedstat_set(p->stats.block_start,
-					rq_clock(rq_of_rt_rq(rt_rq)));
+					rq_clock(global_rq_of_rt_rq(rt_rq)));
 	}
 }

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 13eebde95ec0..27cb594cdfe9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -902,8 +902,6 @@ struct rt_rq {
 	raw_spinlock_t		rt_runtime_lock;

 	unsigned int		rt_nr_boosted;
-
-	struct rq		*rq; /* this is always top-level rq, cache? */
 #endif
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group	*tg; /* this tg has "this" rt_rq on given CPU for runnable entities */
@@ -3500,9 +3498,14 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)

 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
-	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
 	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
+	return container_of_const(rt_rq, struct rq, rt);
+}
+
+static inline struct rq *global_rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
+	return cpu_rq(rq_of_rt_rq(rt_rq)->cpu);
 }

 static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
@@ -3521,6 +3524,11 @@ static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 	return container_of(rt_rq, struct rq, rt);
 }

+static inline struct rq *global_rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of_const(rt_rq, struct rq, rt);
+}
+
 static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 {
 	struct rq *rq = task_rq(rt_task_of(rt_se));
--
2.56.0

