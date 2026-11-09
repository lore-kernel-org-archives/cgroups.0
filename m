Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242198;
	b=DiU1XL0t0Vk9VB3zkJ7CqRwgKOIMRWhQzzMclVugXVBjZfkWOESH9ygKecMi9Uu/qGNa
	 cnuN/JJITNOKUtL02F62c1AMyTsy7S/ENf8PAaWUT9x3zRZzoO9ZUEdpPyHkwx/XvxPKd
	 HWarbxWWadHLuiZlJ9PcH4ZYRyJIE6EuBiSZpAbV2+im3xsEQqqXvI1rQqqu+gQH9NSJx
	 EcQJUMIRobBHd/LQg7yQ0xwyg5o9kL6CH8zDLaFp23tfYwzRnpi2MkGDmYjGWf+sCHeVz
	 xAbZzYZQVjyJkEhusRijHStnbUzg8u+oIi7ShnXtH4Dip8JN/eyJKh8xqZ1WZmB4dmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Eotm5Y5Sm5/8aL0qV1RUwd6YZfVqk0Yoc5Ib7P6NaUM=;
	b=3MVNk1rEbhPklwX/jmCKwUWiD4GODDIRbEqVpqpmz12lNXt3DjqS6OPRsT7Ql5gcqoWY
	 p4SpT7+jF8pRYoTX4CRH0cmjtHElB/I8NNWefBWfygMLtjVLVvjprCVzVykz7EkZn22Wt
	 ws7UXwZJQ1aP2cqy5DWIPt0rAvSmOE1+kA0RGYbxYY5ytWMA5QBEwtFDAxokD8veO9rJp
	 R3Cs+s3ruhHwnYS3bh87Oc6onwQ61htYsI1g8jCcjtp0HDDn/L6nZwx4IBrs3YRz6YyOf
	 4+lFVEgRvaTn+jFD4DxFkCke5jDSAHiFuf152bUtY1XKqqpk90rCv5psk0TQMOVPm4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OkLPd+3d;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D080606EE9C
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D080606EE9C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OkLPd+3d
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so13398185e9.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242197; x=1794846997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Eotm5Y5Sm5/8aL0qV1RUwd6YZfVqk0Yoc5Ib7P6NaUM=;
        b=OkLPd+3dUtD+zr/HJSo+TkldwTUF2d/8JjvxvSxiFVei+/aUNtLGjT6HgHrUJeV8k7
         K8lEE4B7N6Fi5TKIrMbvbvq9QOiH4B6YgvXJsyxQiyOC3Hqpt54s+715owN6nbNpTxts
         5NeXoDXHNabetLK8LMTrHAa+6zXatPIu+Ni7nTZ10h8t08OEJa0MDDil64p5eXXFkTDh
         jLn9x10nWvxYMIQGkq2usvxVTvZm89BWhVtdI4+/xWTuORvmYtSwula0UTx6nOkIuKr3
         ZXiXUbo3qFMDqVMilaPu/A9NmTEYglDu/JpTwcNz6BjJqlouIB1mZkaW6N6HY4DbNjqi
         +8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242197; x=1794846997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Eotm5Y5Sm5/8aL0qV1RUwd6YZfVqk0Yoc5Ib7P6NaUM=;
        b=rPwrD5xRbSjc6kvRgTalrcL9HsuvPlko3KE8QjwFyqVFXo4uv8Tc6QwYrwnx/rYV4q
         qiHUyF8tACZPwnZJ2aQzFHN+k9FF2S7vBUxq1r8+4dlHWSpBZCOKGuuLH4sckErr6sx7
         vTuTZhuh4MobBpL0CFohvCxxPopC98UZOXWOocEFrjD0vDX1EsO7l2H5cYYGuyBKKAhO
         8qX7OvLy6j3Zu5IArjxeDv4oxJv6dvXCAJmKO7J+ahM4vYf4/pJM+A9fdOFuLKwRpgZo
         ClsAE4Z8kYC4j73hhUU8ixoZ9sTV9QAO2bbThRUSFkToTRCHtunCsq6k6YOYQFO9US66
         KY5w==
X-Gm-Message-State: APuU4Z8i36JIfE/cpOxDPE4WbYXLXEYDp3cxfsMPI4PDP1+4aBHUPqmA
	MdQYzq04avIiqXBFpn6tCrOxrqvG0reCntOwbC7WCdbwcT+iXym92yZS
X-Gm-Gg: AYBFou1TAekqzUBpagH3JrMCpXeYUdXmMA0rS5G9wH0XvIRr9cphpwx2EwbRssHccZe
	z0/ahYk7VEi5wAMtfxGMlGJE1L4Nhag5fqUeaKmKJZ8uJOl9evqZNNvzuj1OTR5qwwzGyOgUFMJ
	varifB7OcCO3kNE+4MD7yB7iB+TYQXAhcqEITzugrReE110zgWiIe8rw+/bWsRsDH45mBqBU1GV
	4dtqr29tC7wRG26AkYunoqQhhp8k4Gbalci/xxIFqLX654jS9649jAuGLOOwVLc+aEbm0lzqR6q
	3oXF8LRc6cibV5YoHXDXLLonq4B9IWEiK2Whiu+XOlvJQe1UhRJKhUAziho1Fu8D4ypmgjLSeHq
	MZ5WMdggFpjEh7LdHoGxs6dTF8nfFaCS1NNBJMG0J21+9Bgs7eOaPB1SmoWIyiBhaMRvkWRX/Vu
	NxkC6J+2VrpJ7mYCTxs9IuS9k1O474CKDtTAds2SDmiQUa0P/AQLTgNiSaGt7PVadZYfISA3HfL
	AaJFVgXrh/5NhIlK/pZ8xlkGATlaGWEZpRUM9iwBTX1etpzEi32ge2VgcczmQmyhA9SfdjLvuSB
	8Gb6bHCh9rWnoQ2fCZ9+mTh5AQ==
X-Received: by 2002:a05:600c:19cf:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4ba01d9b5c7mr567965e9.17.1794242196829;
        Mon, 09 Nov 2026 08:36:36 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:35 -0800 (PST)
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
Subject: [RFC PATCH v7 09/29] sched/core: Initialize HCBS specific structures.
Date: Mon,  9 Nov 2026 17:35:55 +0100
Message-ID: <20261109163616.195264-10-yurand2000@gmail.com>
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

Update autogroups' creation/destruction to use the new data structures.

Initialize the default bandwidth for rt-cgroups (sched_init).

Initialize rt-scheduler's specific data structures for the root control
group (sched_init).

Remove init_tg_rt_entry in favour of manual setup of the necessary data
structures in sched_init.

Add utility functions to check (and get) if a rt_rq entity is connected
to a rt-cgroup.

Add read/write accessors for dl_bandwidth.

Add dl_bw_lock_of_tg macro to reference the a task group dl_bandwidth's
spinlock.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/autogroup.c |  4 ++--
 kernel/sched/core.c      | 11 ++++++++--
 kernel/sched/deadline.c  | 11 ++++++++++
 kernel/sched/rt.c        | 45 ++++++++++++++++++++++++++++------------
 kernel/sched/sched.h     | 38 ++++++++++++++++++++++++++++++---
 5 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
index e380cf9372bb..2122a0740a19 100644
--- a/kernel/sched/autogroup.c
+++ b/kernel/sched/autogroup.c
@@ -52,7 +52,7 @@ static inline void autogroup_destroy(struct kref *kref)
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	/* We've redirected RT tasks to the root task group... */
-	ag->tg->rt_se = NULL;
+	ag->tg->dl_se = NULL;
 	ag->tg->rt_rq = NULL;
 #endif
 	sched_release_group(ag->tg);
@@ -109,7 +109,7 @@ static inline struct autogroup *autogroup_create(void)
 	 * the policy change to proceed.
 	 */
 	free_rt_sched_group(tg);
-	tg->rt_se = root_task_group.rt_se;
+	tg->dl_se = root_task_group.dl_se;
 	tg->rt_rq = root_task_group.rt_rq;
 #endif /* CONFIG_RT_GROUP_SCHED */
 	tg->autogroup = ag;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5817136c8dd..f1d43e77c711 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8938,7 +8938,7 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 	ptr += 2 * nr_cpu_ids * sizeof(void **);
 	ptr = (unsigned long)kzalloc(ptr, GFP_NOWAIT);
-	root_task_group.rt_se = (struct sched_rt_entity **)ptr;
+	root_task_group.dl_se = (struct sched_dl_entity **)ptr;
 	ptr += nr_cpu_ids * sizeof(void **);
 
 	root_task_group.rt_rq = (struct rt_rq **)ptr;
@@ -8948,6 +8948,11 @@ void __init sched_init(void)
 
 	init_defrootdomain();
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	init_dl_bandwidth(&root_task_group.dl_bandwidth,
+			  global_rt_period(), 0, &root_task_group);
+#endif /* CONFIG_RT_GROUP_SCHED */
+
 #ifdef CONFIG_CGROUP_SCHED
 	task_group_cache = KMEM_CACHE(task_group, 0);
 
@@ -8999,7 +9004,9 @@ void __init sched_init(void)
 		 * starts working after scheduler_running, which is not the case
 		 * yet.
 		 */
-		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, NULL);
+		rq->rt.tg = &root_task_group;
+		root_task_group.rt_rq[i] = &rq->rt;
+		root_task_group.dl_se[i] = NULL;
 #endif
 		rq->next_class = &idle_sched_class;
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index bc3ac4be8382..aceeb28d4b2b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -508,6 +508,17 @@ static inline int is_leftmost(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq
 
 static void init_dl_rq_bw_ratio(struct dl_rq *dl_rq);
 
+void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime,
+		       struct task_group *active_context)
+{
+	raw_spin_lock_init(&dl_b->dl_runtime_lock);
+	dl_b->dl_period = period;
+	dl_b->dl_runtime = runtime;
+	dl_b->dl_internal_runtime = 0;
+	dl_b->active_context = active_context;
+}
+
+
 void init_dl_bw(struct dl_bw *dl_b)
 {
 	raw_spin_lock_init(&dl_b->lock);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 16eb027d4bdd..3ca932ddcf75 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -86,26 +86,47 @@ void init_rt_rq(struct rt_rq *rt_rq)
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
-void unregister_rt_sched_group(struct task_group *tg)
+DEFINE_MUTEX(rt_constraints_mutex);
+
+const struct dl_bandwidth *dl_bandwidth_read(struct task_group *tg)
 {
+	int held;
+
+	if (IS_ENABLED(CONFIG_LOCKDEP) && debug_locks) {
+		held = 0;
+		if (lockdep_is_held(&rt_constraints_mutex)) {
+			__assume_ctx_lock(&rt_constraints_mutex);
+			held = 1;
+		}
+
+		if (lockdep_is_held(dl_bw_lock_of_tg(tg))) {
+			__assume_ctx_lock(dl_bw_lock_of_tg(tg));
+			held = 1;
+		}
 
+		lockdep_assert(held);
+	}
+
+	return (const struct dl_bandwidth *)&tg->dl_bandwidth;
 }
 
-void free_rt_sched_group(struct task_group *tg)
+struct dl_bandwidth *dl_bandwidth_write(struct task_group *tg)
 {
-	if (!rt_group_sched_enabled())
-		return;
+	lockdep_assert_held(&rt_constraints_mutex);
+	lockdep_assert_held(dl_bw_lock_of_tg(tg));
+
+	return &tg->dl_bandwidth;
 }
 
-void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent)
+void unregister_rt_sched_group(struct task_group *tg)
 {
-	rt_rq->highest_prio.curr = MAX_RT_PRIO-1;
-	rt_rq->tg = tg;
 
-	tg->rt_rq[cpu] = rt_rq;
-	tg->rt_se[cpu] = rt_se;
+}
+
+void free_rt_sched_group(struct task_group *tg)
+{
+	if (!rt_group_sched_enabled())
+		return;
 }
 
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
@@ -1824,8 +1845,6 @@ DEFINE_SCHED_CLASS(rt) = {
 /*
  * Ensure that the real time constraints are schedulable.
  */
-static DEFINE_MUTEX(rt_constraints_mutex);
-
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *task;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 94c530d1ce0c..e8a62b37a72d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -598,9 +598,6 @@ extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
-extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu,
-		struct sched_rt_entity *parent);
 extern int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us);
 extern int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us);
 extern long sched_group_rt_runtime(struct task_group *tg);
@@ -3070,6 +3067,8 @@ extern void resched_curr(struct rq *rq);
 extern void resched_curr_lazy(struct rq *rq);
 extern void resched_cpu(int cpu);
 
+extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime,
+			      struct task_group *active_context);
 extern void init_dl_entity(struct sched_dl_entity *dl_se);
 
 extern void init_cfs_throttle_work(struct task_struct *p);
@@ -3512,6 +3511,9 @@ extern void set_rq_offline(struct rq *rq);
 
 extern bool sched_smp_initialized;
 
+extern const struct dl_bandwidth *dl_bandwidth_read(struct task_group *tg);
+extern struct dl_bandwidth *dl_bandwidth_write(struct task_group *tg);
+
 #ifdef CONFIG_RT_GROUP_SCHED
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
@@ -3535,6 +3537,24 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 	WARN_ON(!rt_group_sched_enabled() && rt_se->rt_rq->tg != &root_task_group);
 	return rt_se->rt_rq;
 }
+
+static inline int is_dl_group(struct rt_rq *rt_rq)
+{
+	return rt_rq->tg != &root_task_group;
+}
+
+/*
+ * Return the scheduling entity of this group of tasks.
+ */
+static inline struct sched_dl_entity *dl_group_of(struct rt_rq *rt_rq)
+{
+	if (WARN_ON_ONCE(!is_dl_group(rt_rq)))
+		return NULL;
+
+	return rt_rq->tg->dl_se[rq_of_rt_rq(rt_rq)->cpu];
+}
+
+#define dl_bw_lock_of_tg(tg) (&(tg)->dl_bandwidth.dl_runtime_lock)
 #else
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
@@ -3557,6 +3577,18 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 	return &rq->rt;
 }
+
+static inline int is_dl_group(struct rt_rq *rt_rq)
+{
+	return 0;
+}
+
+static inline struct sched_dl_entity *dl_group_of(struct rt_rq *rt_rq)
+{
+	return NULL;
+}
+
+#define dl_bw_lock_of_tg(tg) ((raw_spinlock_t*)NULL)
 #endif
 
 DEFINE_LOCK_GUARD_2(double_rq_lock, struct rq,
-- 
2.56.0

