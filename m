Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242203;
	b=3ICiDW4UvF0k20ugMm4bIhWGziR9uPf8LpGngHX+BgBb+f6Ay/2IoQ/YsRmyHE5umtMm
	 4pDPhVTVfaBA7WvoIh97nK0BJ//XhCbI+SXWpqx5THOwF36GNXqRNsYdSPjvcE2kGJZiM
	 tcNEnY9tyAVkWjyE0MB0iGypS2zI6JGQ2+W8q8QU/SV9LJ60yo+2TmO+4gSvBqz6hFvz8
	 wAEYhxcd+EzMtyN+r7c4af/bcYZSdEGaHmqnoISmRiz3w7IdxFm60A8JkziNLQuEnfo9X
	 UENoqS+OH9SrytsNo9pyKlo5HeQebpwwkS/qp7+QtHgem2kriFi6vq8c2vfZR7HqYQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242203;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lJL2CrY7iNSJF7GqoCeb5yNm8erUqwgVxUedaZdDoNM=;
	b=d2DleKD+VrkjmC63qnR3I3C2p0OY3mwR0QRcNfHGyqUv4ReIWEHoPP27qrDDY9lB3PZe
	 jKFhizz4LbXq9psxK+WxiYSmzwfQE429tFVf8gnyCLPUtYEhluHmSBlv6bs/LEY31TSCM
	 d+iNHyR/ua8uRtFJtbd0jITApjqPaRWMOFjTmLFz2o4/NufNvEcwhPJlmOwMcwyJqqF8R
	 sb0bLXDLaD/XfP7dLOASmLNPqo/srz4GumCzya0Kr/A/+ZjkK1SZwrzX3VNfgJHjBn+tz
	 0qdACc8Zmfy4cVLra40fTeQ0lJLaZ18P5w75eOrmlpwVXhBl71lbZqeMJhkDULshuRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GZoMGYc2;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4A60A3835
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44F4A60A3835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GZoMGYc2
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10723305e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242202; x=1794847002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJL2CrY7iNSJF7GqoCeb5yNm8erUqwgVxUedaZdDoNM=;
        b=GZoMGYc2cjOO+sCdIIq+4Gcwy3UfY+ElfbmHXvrpgurE+wik7MBgTMRrWIcQk1aNh9
         Ve5QisdSLBZyScqtcnsBSRoYnw5dwyTX5Kh6gybmXsNESlpOAdzR2yX4HLR3xWbHGtUu
         fvVT+B9K63HQJjwPk+WMPKp05a/xS41XyIJh/BD9SoAoDDN7oEuwC/sMIjABo6xzVAcu
         o06ov0OQXj5t2eSXDxUeufQtkMviT5q6cP3lMHOuBJ08qJMFktz40xL5TrqI3hucX+Mo
         yYTlSM62smaxLYLkrpXFJpji0/xeD4DWfZxelEQSxISKAi1cmew5UP+qIoZsbEstv8Wp
         brjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242202; x=1794847002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJL2CrY7iNSJF7GqoCeb5yNm8erUqwgVxUedaZdDoNM=;
        b=Wb7USL4Epnj9NtsC3wU1CTkzwLJ+sEyCOCINBr5DwoNJLao6LO27vqE9P/T7usZFuM
         AxTZSeP1Rh2GtJ3yeTX/U+Xr8bh5RDXVeaC0NrgeJgQa+20uwgd8Za2Lw9x+Spp0mXlY
         6NOzRYyQ53e35FTqxXzHAzHaxt7CudhGY2Lpno1U525uSdvk1zVNJjlsXim4Ms3v+Qrd
         QS0YpmSU0PbZHvoh8Nqht/VlFVlWStFcvHPkcROT8n1SETSAG4AIRy+2T6OKXVr8I5pm
         wQliWt/qQk0ai8I58suqafXRGz8suX96JuUS1rASBrBqRYAMmU+z73nUBvP22UVoTaLz
         42YA==
X-Gm-Message-State: APuU4Z/PXgIqjfT3SOdj07HDHrbL4OeQNRHwwPCuhKZYpjD4caTxFWa+
	3M0PuvhXbe08iobcNqb+V9HPv7GkV61TG1he5vGDJRKHcAvdi5RkdAkl
X-Gm-Gg: AYBFou01g6DR37BGR7F2/TeDW9tjcjWKbiEso+qPcko3sIz1RHMaB1AqMkpKvPmzCaI
	oOs5fNIkrkORw6eMbiIToCJpAkBdDF1ZWqmhPaMove5hYayg2O1gN4xZAeBztOhunWA9zHK/HW6
	MuEa+p557XjPp/I4+WQOoP01XMSGRsZ5TbD+95WmcOUWnSZ6mZJeE6Fx9yxXSnmNDZUgBmSXIW0
	EtPix2Qse31yVSX9kcfIcrVygKHWOXX88D3E0GuI0f5JLKlFs0IpHbjv4u+xajfX16eIt+EOwkb
	KSem6PhsoH4XRfbJXolYN6wCuXvxHGEldSI7lKrSuwg11+WHAfj5FgQAqvX5WnXu1E6pnBPRkeL
	4PWatZiBJOaz9AiNEorYIygHL10E2D0ZS93EMmYwxmENULMmi07OWcuFh5E+WNXvPONKBDAaMp1
	8nNysE8otpe9eNnyBtRCMjubQEiL8pOR7OqBIDffwdvNt5k98rHjEt4bEsbEVvhTIwe9iqcQYRv
	T4ytFhI91Zateg8GomEfIzlDfW6AciMVqy4fZ5tevalm3W1bSq5Oyn33vfLvIy20Uv4zHdNJOVu
	u4cBzDtL2QCTxI11BjEx/lD2KA==
X-Received: by 2002:a05:600c:1d0a:b0:4b1:4017:c4f4 with SMTP id 5b1f17b1804b1-4b963c741f8mr79445725e9.20.1794242201591;
        Mon, 09 Nov 2026 08:36:41 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:40 -0800 (PST)
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
Subject: [RFC PATCH v7 12/29] sched/deadline: Account rt-cgroups bandwidth in deadline tasks schedulability tests.
Date: Mon,  9 Nov 2026 17:35:58 +0100
Message-ID: <20261109163616.195264-13-yurand2000@gmail.com>
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

Account the rt-cgroups hierarchy's reserved bandwidth in the
schedulability test of deadline entities. This mechanism allows to
completely reserve portion of the rt-bandwidth to rt-cgroups even if
they do not use all of it.

Account for the rt-cgroups' reserved bandwidth also when changing the
total dedicated bandwidth for real time tasks.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/deadline.c | 58 +++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b6b5fcb15f43..7c2f4d2c9301 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -127,14 +127,17 @@ static inline struct dl_bw *dl_bw_of(int i)
 	return &cpu_rq(i)->rd->dl_bw;
 }

-static inline int dl_bw_cpus(int i)
+static inline int __dl_bw_cpus(const struct cpumask *mask)
 {
-	struct root_domain *rd = cpu_rq(i)->rd;
+	return cpumask_weight_and(mask, cpu_active_mask);
+}

+static inline int dl_bw_cpus(int i)
+{
 	RCU_LOCKDEP_WARN(!rcu_read_lock_sched_held(),
 			 "sched RCU must be held");

-	return cpumask_weight_and(rd->span, cpu_active_mask);
+	return __dl_bw_cpus(cpu_rq(i)->rd->span);
 }

 static inline unsigned long __dl_bw_capacity(const struct cpumask *mask)
@@ -205,11 +208,25 @@ void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 	__dl_update(dl_b, -((s32)tsk_bw / cpus));
 }

+static inline u64 get_dl_groups_bw(void)
+{
+#ifdef CONFIG_RT_GROUP_SCHED
+	const struct dl_bandwidth *dl_b;
+
+	guard(raw_spinlock_irqsave)(dl_bw_lock_of_tg(&root_task_group));
+	dl_b = dl_bandwidth_read(&root_task_group);
+	return to_ratio(dl_b->dl_period, dl_b->dl_runtime);
+#else
+	return 0;
+#endif
+}
+
 static inline bool
-__dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
+__dl_overflow(struct dl_bw *dl_b, unsigned long cap, int cpus, u64 old_bw, u64 new_bw)
 {
 	return dl_b->bw != -1 &&
-	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw;
+	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw
+					+ get_dl_groups_bw() * cpus;
 }

 static inline
@@ -1937,7 +1954,7 @@ int dl_server_apply_params(struct sched_dl_entity *dl_se, u64 runtime, u64 perio
 	cpus = dl_bw_cpus(cpu);
 	cap = dl_bw_capacity(cpu);

-	if (__dl_overflow(dl_b, cap, old_bw, new_bw))
+	if (__dl_overflow(dl_b, cap, cpus, old_bw, new_bw))
 		return -EBUSY;

 	if (init) {
@@ -1984,7 +2001,7 @@ static int __dl_server_attach_bw_locked(struct sched_dl_entity *dl_se,
 	 */
 	if (cpu_active(cpu_of(rq))) {
 		cap = dl_bw_capacity(cpu_of(rq));
-		if (__dl_overflow(dl_b, cap, 0, dl_se->dl_bw))
+		if (__dl_overflow(dl_b, cap, cpus, 0, dl_se->dl_bw))
 			return -EBUSY;
 		__dl_add(dl_b, dl_se->dl_bw, cpus);
 	}
@@ -3710,8 +3727,9 @@ int sched_dl_global_validate(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	u64 cookie = ++dl_cookie;
+	u64 dl_groups_root = get_dl_groups_bw();
 	struct dl_bw *dl_b;
-	int cpu, cpus, ret = 0;
+	int cpu, cap, cpus, ret = 0;
 	unsigned long flags;

 	/*
@@ -3726,10 +3744,12 @@ int sched_dl_global_validate(void)
 			goto next;

 		dl_b = dl_bw_of(cpu);
+		cap = dl_bw_capacity(cpu);
 		cpus = dl_bw_cpus(cpu);

 		raw_spin_lock_irqsave(&dl_b->lock, flags);
-		if (new_bw * cpus < dl_b->total_bw)
+		if (cap_scale(new_bw, cap) < dl_b->total_bw +
+					     dl_groups_root * cpus)
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);

@@ -3823,13 +3843,13 @@ int sched_dl_overflow(struct task_struct *p, int policy,
 	cap = dl_bw_capacity(cpu);

 	if (dl_policy(policy) && !task_has_dl_policy(p) &&
-	    !__dl_overflow(dl_b, cap, 0, new_bw)) {
+	    !__dl_overflow(dl_b, cap, cpus, 0, new_bw)) {
 		if (hrtimer_active(&p->dl.inactive_timer))
 			__dl_sub(dl_b, p->dl.dl_bw, cpus);
 		__dl_add(dl_b, new_bw, cpus);
 		err = 0;
 	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
-		   !__dl_overflow(dl_b, cap, p->dl.dl_bw, new_bw)) {
+		   !__dl_overflow(dl_b, cap, cpus, p->dl.dl_bw, new_bw)) {
 		/*
 		 * XXX this is slightly incorrect: when the task
 		 * utilization decreases, we should delay the total
@@ -4007,13 +4027,14 @@ int dl_cpuset_cpumask_can_shrink(const struct cpumask *cur,
 {
 	unsigned long flags, cap;
 	struct dl_bw *cur_dl_b;
-	int ret = 1;
+	int cpus, ret = 1;

 	rcu_read_lock_sched();
 	cur_dl_b = dl_bw_of(cpumask_any(cur));
 	cap = __dl_bw_capacity(trial);
+	cpus = __dl_bw_cpus(trial);
 	raw_spin_lock_irqsave(&cur_dl_b->lock, flags);
-	if (__dl_overflow(cur_dl_b, cap, 0, 0))
+	if (__dl_overflow(cur_dl_b, cap, cpus, 0, 0))
 		ret = 0;
 	raw_spin_unlock_irqrestore(&cur_dl_b->lock, flags);
 	rcu_read_unlock_sched();
@@ -4030,6 +4051,7 @@ enum dl_bw_request {
 static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 {
 	unsigned long flags, cap;
+	int cpus;
 	struct dl_bw *dl_b;
 	bool overflow = 0;
 	u64 dl_server_bw = 0;
@@ -4039,12 +4061,13 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 	raw_spin_lock_irqsave(&dl_b->lock, flags);

 	cap = dl_bw_capacity(cpu);
+	cpus = dl_bw_cpus(cpu);
 	switch (req) {
 	case dl_bw_req_free:
 		__dl_sub(dl_b, dl_bw, dl_bw_cpus(cpu));
 		break;
 	case dl_bw_req_alloc:
-		overflow = __dl_overflow(dl_b, cap, 0, dl_bw);
+		overflow = __dl_overflow(dl_b, cap, cpus, 0, dl_bw);

 		if (!overflow) {
 			/*
@@ -4053,7 +4076,7 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 			 * We will free resources in the source root_domain
 			 * later on (see set_cpus_allowed_dl()).
 			 */
-			__dl_add(dl_b, dl_bw, dl_bw_cpus(cpu));
+			__dl_add(dl_b, dl_bw, cpus);
 		}
 		break;
 	case dl_bw_req_deactivate:
@@ -4063,6 +4086,7 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 		 * turn cpu off?).
 		 */
 		cap -= arch_scale_cpu_capacity(cpu);
+		cpus -= 1;

 		/*
 		 * cpu is going offline and NORMAL and EXT tasks will be
@@ -4083,8 +4107,8 @@ static int dl_bw_manage(enum dl_bw_request req, int cpu, u64 dl_bw)
 			 * wise thing to do. As said above, cpu is not offline
 			 * yet, so account for that.
 			 */
-			if (dl_bw_cpus(cpu) - 1)
-				overflow = __dl_overflow(dl_b, cap, dl_server_bw, 0);
+			if (cpus)
+				overflow = __dl_overflow(dl_b, cap, cpus, dl_server_bw, 0);
 			else
 				overflow = 1;
 		}
--
2.56.0

