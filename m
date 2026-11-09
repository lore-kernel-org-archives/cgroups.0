Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242216;
	b=ma5EgaBleAgdteshLvtpEhARaf3JrUmLPIYBZRIwkaSrBUc4xsc7pE48vwf52nFIlEZ4
	 XUBHHl/M+2TmjH6CMeIkLZARJ2C23gqn1QtN8bb87TTA2/mtUDWodaxbEMRmiemjfDCi3
	 VcOV6VJVA5J9zldC+7uvQjkOhvhfpdeUCqmIFHT9rJtAAhd6z0XzMo5jWoZBCnHQ1wIG2
	 yIDRVLprHyHRKLM6vOBPrBcFB7aHRo8vp7HlSz7kiQPVSMc1LCY8lyj8O0jWB4cF1R2kV
	 cZ0SRiWvzDX8QYjDKzYkisx3cKK6EtuYmWNLiVnwtJq7ywMhA8EIxsYmt2UdNIHlf6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242216;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KcIjo2huR4gFwGnFpf64WoFNBDsnsdPcDg9Gewk+Kmg=;
	b=2aheaPVG08kgEgnLaHQVjQDH4bcu8EFxspan5Woe/8M3c1CYyuwvOuA3roAzIMoxIp7Q
	 +CpLXWdJsWHXnwixJcnH8zNuhN8Yjt4LwIaJMf7XID/1NX173gJAsHlQYzCHUVdRXhLe4
	 0O/kfF70tMdf3G9vVYiOPwpI2sS5IgPCsxWg8Lqv6kGkwpZI7W2ynvNR2dkykd7gvWhBe
	 za45t+hquUf/TVST790LwZFBU6z3+/5h7mYARekYOXTtBFNbXX3G8wdScAFJLUIawUvgz
	 ePGxmW1ERlToiHf5T1eFZcvu4rJ4L2eqJEzsqUIGxkuiaAknuLkl9ZKItdAg07yY/tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mNidKtF4;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5953F6073644
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5953F6073644
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mNidKtF4
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso11542535e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242215; x=1794847015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KcIjo2huR4gFwGnFpf64WoFNBDsnsdPcDg9Gewk+Kmg=;
        b=mNidKtF48zgO+YCbrgnhMwgek8M9YQFCr43AGDT7GmGLvxNAV+sAap7bvqx9qZRpyc
         qfq5X2h4swn8zwYZIBppu50VkduStIaexbjdTko+RytF6O4Ot6jo/tWVD0YdfVdsSVc3
         XAX8a/LbhJn5ctZYeXNL2XpW5BC2KOmCl0uqfu1nFsgDlNFGqYy+ZqPJE/pfIfDb348E
         Ss4k6vflYyykqTbNHvrjjY9xvkfK5NRaRli0ft012bAqwea31JhewInlFR+nes7r2twZ
         ftvXoCB4ZP4JGNDc1hH3wj/0C1AFq4u+Lvjrt+JW3HvoOFlhMSeqgJqxAb4zB085crHV
         c39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242215; x=1794847015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KcIjo2huR4gFwGnFpf64WoFNBDsnsdPcDg9Gewk+Kmg=;
        b=xcdR+IfloxaKBQIrdEzh6VixBrD4mf/aRd2qibFe5K9O8i9eUhgPxS+Va8ONyZ1Cqf
         LBna2aw+0Pk7vwrBoJ+DgrHeFNseB2XzY6XjChSwonLG4Ft5h275vCTJI+UuJYgO0n1R
         cCjxHtTeldisoPpn6jHq2kNM22A0Gjwmj/PqxhZKbeK/U6nKZmdUhRPnoJd8xaYJMtiT
         ihJVFb1jMKxuv6GbgTM/eGOWTCWlyRUFFapvYsq8Uffw9Xrf4qKklxDpGhVB087mmm5F
         EFhCUVrh0Q3LAqZzMLBAkgBOdciBpq/k7ergkRcPxQmfTygxTdu00mGwePimB8iow2hP
         UNew==
X-Gm-Message-State: APuU4Z8dkj+vjSlCnlGSAyhIeIrVYp4wrzTSMEttWrHmeRZk0YMCEQsc
	bEzynW5m65oLd9ZbFSDbrvPZa07aFNqgFQ89tb39lvre64Fv953CV/1w
X-Gm-Gg: AYBFou0lgUiU+G/8aUR7SUjCKHvaWR62qAkedP9PHWr8qyFQ5eN3dsuEQk6EWLCLFz1
	RL1YMn11eB/EQxpaiCumQjmdAiNxtMm6EQaJq3FdoAF8s8fu7BfoQumEblLqO6zsJ3h8JCGLVEt
	p0ix/oFfhaHn4OG7NTVDahi3cv9N60c+XipZAcqzNJAbF62R53l7P4Dj3BwE8a91NGdh+g+/6+L
	gowxbNrFX8gEvRB2m7RJL2ijp6HZDcTtmy6dzYPrFPjPndkrSGUGBB04hI6qug4C0r4S+K2ALq9
	hM2EqMYrqv15e0cILK7N2q18whI/EzszyT0FtJ1KCGx86AODA6XjvW42hEEFyf2sZ7AkXUMZfaH
	KTgqzg20+1uDJgrD1MVLTv3pxZ+rYdIGR+5EXj0sTRmAG73Z/BpyL/gp7LkSi+5oH+S01FKjReG
	GaKNOPyqShfkivuZEZUf8AVe0Ay6qS/rvqdiJypkN7OrECMq7MCGL2UkVWM9A9kufKTJf5fUZ2Z
	D3E/HgWRS3nefPuXIAuReuZO3CY8sgcAihIYwoFQLZ6mFKvf9/2Hllm6UKiI7RR3FsrA5A2/4tZ
	UcTan8F8YpVeRYNbYxXHWWLyOtjFCvTU8KBuOznj8h7wVkk=
X-Received: by 2002:a05:600c:811b:b0:4a7:b304:253e with SMTP id 5b1f17b1804b1-4b963c6d1c8mr76438335e9.22.1794242214867;
        Mon, 09 Nov 2026 08:36:54 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:54 -0800 (PST)
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
Subject: [RFC PATCH v7 20/29] sched/rt: Hook HCBS migration functions
Date: Mon,  9 Nov 2026 17:36:06 +0100
Message-ID: <20261109163616.195264-21-yurand2000@gmail.com>
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

Hook rt-cgroup migration functions:

- select_task_rt_rq
  Always return the cpu where the task is scheduled.
- balance_rt
- put_prev_task_rt
  If a server is throttled, put_prev_task_rt is invoked and a push is
  necessary so that the task can keep running on another server if possible.
- switched_to_rt
  Keep track of the deadline server that is assigned to the task switching
  to FIFO/RR priority.

Set rt-cgroups runqueues to online to allow balancing in balance_rt.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 0b7c36f8acdc..9d95cf5fd520 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -266,6 +266,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 		init_rt_rq(&s_rq->rt);
 		s_rq->cpu = i;
+		s_rq->online = 1;
 		s_rq->rt.tg = tg;
 
 		init_dl_entity(dl_se);
@@ -1017,6 +1018,10 @@ select_task_rq_rt(struct task_struct *p, int cpu, int flags)
 	struct rq *rq;
 	bool test;
 
+	/* Just return the task_cpu for processes inside task groups */
+	if (is_dl_group(rt_rq_of_se(&p->rt)))
+		goto out;
+
 	/* For anything but wake ups, just return the task_cpu */
 	if (!(flags & (WF_TTWU | WF_FORK)))
 		goto out;
@@ -1106,27 +1111,30 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	resched_curr(rq);
 }
 
-static int balance_rt(struct rq *rq, struct rq_flags *rf)
+static int balance_rt(struct rq *global_rq, struct rq_flags *rf)
 {
 	/*
 	 * Note, rq->donor may change during rq lock drops,
 	 * so don't re-use p across lock drops
 	 */
-	struct task_struct *p = rq->donor;
+	struct task_struct *p = global_rq->donor;
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
 
-	if (!on_rt_rq(&p->rt) && need_pull_rt_task(rq, p)) {
+	if (!on_rt_rq(&p->rt) && need_pull_rt_task(rq_of_rt_rq(rt_rq), p)) {
 		/*
 		 * This is OK, because current is on_cpu, which avoids it being
 		 * picked for load-balance and preemption/IRQs are still
 		 * disabled avoiding further scheduler activity on it and we've
 		 * not yet started the picking loop.
 		 */
-		rq_unpin_lock(rq, rf);
-		pull_rt_rq_task(&rq->rt);
-		rq_repin_lock(rq, rf);
+		rq_unpin_lock(global_rq, rf);
+		pull_rt_rq_task(rt_rq);
+		rq_repin_lock(global_rq, rf);
 	}
 
-	return sched_stop_runnable(rq) || sched_dl_runnable(rq) || sched_rt_runnable(rq);
+	return sched_stop_runnable(global_rq) ||
+	       sched_dl_runnable(global_rq) ||
+	       sched_rt_runnable(global_rq);
 }
 
 /*
@@ -1293,6 +1301,13 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p, struct task_s
 	 */
 	if (on_rt_rq(&p->rt) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rt_rq, p);
+
+	if (is_dl_group(rt_rq)) {
+		struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+		if (dl_se->dl_throttled)
+			rt_queue_push_tasks(rt_rq);
+	}
 }
 
 /* Only try algorithms three times */
@@ -2110,12 +2125,21 @@ static void switching_to_rt(struct rq *rq, struct task_struct *p) {}
  */
 static void switched_to_rt(struct rq *rq, struct task_struct *p)
 {
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
+
 	/*
 	 * If we are running, update the avg_rt tracking, as the running time
 	 * will now on be accounted into the latter.
 	 */
 	if (task_current(rq, p)) {
 		update_rt_rq_load_avg(rq_clock_pelt(rq), rq, 0);
+
+		if (is_dl_group(rt_rq)) {
+			struct sched_dl_entity *dl_se = dl_group_of(rt_rq);
+
+			p->dl_server = dl_se;
+		}
+
 		return;
 	}
 
@@ -2125,8 +2149,8 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * then see if we can move to another run queue.
 	 */
 	if (task_on_rq_queued(p)) {
-		if (p->nr_cpus_allowed > 1 && rt_rq_of_se(&p->rt)->overloaded)
-			rt_queue_push_tasks(rt_rq_of_se(&p->rt));
+		if (p->nr_cpus_allowed > 1 && rt_rq->overloaded)
+			rt_queue_push_tasks(rt_rq);
 
 		if (p->prio < rq->donor->prio && cpu_online(cpu_of(rq)))
 			resched_curr(rq);
-- 
2.56.0

