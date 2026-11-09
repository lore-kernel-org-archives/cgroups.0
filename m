Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242192;
	b=yqQ224zKowDEtb+wnQY6/XZ8JKTajIn8d9Z/N4FZfd4RdIx5d86FNivVYwLLG2pjmq1L
	 uoQ/YkaytTZk2HeAtnRaVyHL8hkQ0j/DVmYXB4imgOgKzvqIG6lMr/sTxx6IDMFgLX9Zw
	 kL9QugDuxLinM4aMKuyFCnEDfwt8xLcyuFdsDJWzzZ1f6/nGBo9PljBbkTznPSc8pMkth
	 7jT28Y0zhCYen70lEppQTKGIoYlWs/IN1I7YOrn5QPyH7PNEzUbsiC1wm8z1luxbQf2Ep
	 UT2qqGeMYC9YBKThUJZIxRqnQqTCI2raHxl7aavujawHcL5vYKbvan7H5qfrYl8swKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HEJ+QQBd0iC35enWpK8vBgPoOeYQfDGSCF+rovxxelY=;
	b=F/DEAPcXNx0zWpAv2JyzaMp3lsevaDHJqW+C/xF3Num/XT41oFspEVnHD5DDe2uPnx3L
	 LoebMs8UdFqdi+WtfpvLx4XZjdPvVi/iPqwskiPu/Q6sItvJ88fM7liDLKOvDv8BDzJVy
	 7+WH+G0BFrsVWUN57L5lyesp9hH7ux7awQX85Z/z+Fh1E6lIEKo63sbqy1tnFM5ANMeyC
	 UacuoVcOScbnE88TumL/4kBinJlLso+Lez6rmAIskICRHJX9x67v3nywCkbjwNuaQJomr
	 ErRBZ/ufw6dhq6J5U6LXQsw+D+fPJ0L0Wf/ODFNSFotpJG4g8LDgkKEbXeJn1RvS+LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ce4dzgt4;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA65606EEB8
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FA65606EEB8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ce4dzgt4
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso6541885e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242191; x=1794846991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HEJ+QQBd0iC35enWpK8vBgPoOeYQfDGSCF+rovxxelY=;
        b=ce4dzgt47bGoaG62rHmRirIRztmdq3J5c2phQMU8RqoYCy5Dxwn/y+0E0aaHCZXJDe
         B4szupjUZK+qd1H8dwkHk1CiGAUgmnwiLkgNeIQwtENslHs3gTKzOFGdY4puqJmu7k4U
         fQqJhvnx+r6lr+gNNCVL3yVL+xudCZDxmsNqHRMQUfT2yOEYd6v9vB0qWDA2M6sRAKcJ
         VYCwaLA4KMlTC8UQlQ8wWxx0v2tMVIRC8BTIo45gLvJcvszelyhUybRwxiO5nzFhFOyv
         MYbtlh8vEpluKfiX0hHVssS7h8fF0NS5diwe65fZgoUqSfqyANNZc6wdnLT0d58j55OA
         JWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242191; x=1794846991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HEJ+QQBd0iC35enWpK8vBgPoOeYQfDGSCF+rovxxelY=;
        b=NqMlALdtHfbL3prfpODF29AQMHMeIRoHf1pz8NWg1PWc4pIBqYybSR/TN/zmBj/FWW
         WtamSGKyHX+gtF8CmlndlLBzsxAC+mWnLX9PfCZbAKbYg/Q0UYfHArUDZt5qeDkmRCoR
         V3mCbUGl/p9iJOcUmASTygdXoY6n1fGZLIse/ouygGybhymHlshcoVR5MG9GGNJO3mJK
         BmMrmincG/5YtFyIvuMaXgjza0rZ377RZkMtczHyyymsz1ZxAPwimfTie5YsZXMq/cRP
         6n5AFCDjU01O2YR4Bs3ExBWh1sgO0RCJMmVM8Hm7dza6j61mhuWtd5c9JAYuia0oRcTm
         ynqg==
X-Gm-Message-State: APuU4Z8vEjP52ADVNlBH17Oateqc9gEdhhEqGPYOKcveVEtTPChKoEM/
	w/+aWcavD64jX1YDjgavODrWYGcvxOfIMRC5U1/bXNbgVVRn2oVAUX29
X-Gm-Gg: AYBFou2ONVdSratQg6rInj3SPsi4QknLlQsYFi8fRN0sfFrNfj05zVSHSMr0cdwEZOh
	60poUhXzgg4IXOSin0yPXlN8vE1ECu5Fs5EOHnr4X8DaBQKlYfbgxrLrQFS2xIIhYlJcdlrMlhy
	F6QwwLlXYzfML80C0vLHuXRfBXtv3FB1rIdot2xCpRfBHD9u5mH7qmh/xmOmwK+A+mauIVSQATM
	pZGx3vZz/UDMnxKxOajSuv1ro3xWbYEvL54jPluLo+tGyw+s9S5z763FDWFG/mhz7PPG6cf2TVa
	3b+Z/GRst5bcu6eR2HtQV0/Hdz0sqdhFL/0J0FYqV5MrquyNhEh0ThZ+DEYn9BFdUTFrj6wlCD3
	4JDXEefQhPqQ+Fy8bdxMmuEBlnuBLAIJXjJHU5Yug3SsCmKERpjUBSrd+r5ISm69KbrZhrHfQKI
	6Urd9iJg6IDRGodyExCRlNg2S0uWaReUQfNbqBlEX9CAMii3npS0aN1PRcClOlc6lS93b/5JqN6
	vt83rEkAM7sQSiH7hc9Lnzfz8h6tmtUt7231JD1uXtHeXwsRXM7v7cXTYLx+ACveHbN5wPU5gtE
	bXgwOlz84mUNv7G30CI5zHW/AA0=
X-Received: by 2002:a05:600c:46cf:b0:4ac:aae6:6401 with SMTP id 5b1f17b1804b1-4b963c6a9d4mr87006605e9.12.1794242190658;
        Mon, 09 Nov 2026 08:36:30 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:28 -0800 (PST)
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
Subject: [RFC PATCH v7 05/29] sched/rt: Move functions from rt.c to sched.h
Date: Mon,  9 Nov 2026 17:35:51 +0100
Message-ID: <20261109163616.195264-6-yurand2000@gmail.com>
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

Make the following functions/macros be non-static and move them in
sched.h, so that they can be also used in other source files:

- rt_entity_is_task()
- rt_task_of()
- rq_of_rt_rq()
- rt_rq_of_se()
- rq_of_rt_se()

There are no functional changes, apart from the use of container_of_const()
instead of container_of() where applicable. This is needed by future patches.

Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/rt.c    | 56 ------------------------------------------
 kernel/sched/sched.h | 58 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2b1c3ab5d6a4..0862ee8b088d 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -166,36 +166,6 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 	hrtimer_cancel(&rt_b->rt_period_timer);
 }
 
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
-
-	return container_of(rt_se, struct task_struct, rt);
-}
-
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
-	return rt_se->rt_rq;
-}
-
-static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
-{
-	struct rt_rq *rt_rq = rt_se->rt_rq;
-
-	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
-	return rt_rq->rq;
-}
-
 void unregister_rt_sched_group(struct task_group *tg)
 {
 	if (!rt_group_sched_enabled())
@@ -294,32 +264,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 #else /* !CONFIG_RT_GROUP_SCHED: */
 
-#define rt_entity_is_task(rt_se) (1)
-
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	return container_of(rt_se, struct task_struct, rt);
-}
-
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return container_of(rt_rq, struct rq, rt);
-}
-
-static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
-{
-	struct task_struct *p = rt_task_of(rt_se);
-
-	return task_rq(p);
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	struct rq *rq = rq_of_rt_se(rt_se);
-
-	return &rq->rt;
-}
-
 void unregister_rt_sched_group(struct task_group *tg) { }
 
 void free_rt_sched_group(struct task_group *tg) { }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1b04b4c40ae9..e7e4da78340c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3495,6 +3495,64 @@ extern void set_rq_offline(struct rq *rq);
 
 extern bool sched_smp_initialized;
 
+#ifdef CONFIG_RT_GROUP_SCHED
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
+
+	return container_of(rt_se, struct task_struct, rt);
+}
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	/* Cannot fold with non-CONFIG_RT_GROUP_SCHED version, layout */
+	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
+	return rt_rq->rq;
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
+	return rt_se->rt_rq;
+}
+
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_se->rt_rq;
+
+	WARN_ON(!rt_group_sched_enabled() && rt_rq->tg != &root_task_group);
+	return rt_rq->rq;
+}
+#else
+#define rt_entity_is_task(rt_se) (1)
+
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of(rt_se, struct task_struct, rt);
+}
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of(rt_rq, struct rq, rt);
+}
+
+static inline struct rq *rq_of_rt_se(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p = rt_task_of(rt_se);
+
+	return task_rq(p);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct rq *rq = rq_of_rt_se(rt_se);
+
+	return &rq->rt;
+}
+#endif
+
 DEFINE_LOCK_GUARD_2(double_rq_lock, struct rq,
 		    double_rq_lock(_T->lock, _T->lock2),
 		    double_rq_unlock(_T->lock, _T->lock2))
-- 
2.56.0

