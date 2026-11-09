Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242211;
	b=EXereUNPiHFYpR03GyFMTmqTq8La4Vf7ijnH9TR96qzxjiJGr9UHHFc86RQAzgaSFUdz
	 V1jrZFFkgHCzFDxdiG/GuFT0bHLPkPCXvlHn6KJS1MqBWqJVMaBy6Z/LgC1eoe/fcaP5t
	 mFVGy+ZFSraXTXNpj6ATGkIQxoX+77rbLCKqCBap+IH12bilgH5LsYiraBkTtTwCyBzUr
	 NiduWdiLoYotORyclzwIiq7SczEb/iq5NznOb4YUqbrpKDX2RR5KX3sQaYRGYMawwFwWR
	 F1uY0T1G1HLM4cHYkiV67cbRTlC/CiYk5K6exrPmozCO6Ulrqimz7tn7uSAA4N2jhyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w1ajCXAV+nw5LVtcZbwPKg/uH1J37y1Kwpm4nIUcxqA=;
	b=3JqkRbBl4n2mwy9bDAQr074155WripYlqB4bMn+QBkIG4r5Qqpdi0slzGOg8Cib8YES7
	 ykR8c3PwOzSvYuOTg9PMC6ulD/xNoGwhjfOywT4GWoJE+SL5v3XKLoLqUAYNP1wERmlqn
	 6O2EAS7jogFgTmR7bwRJTCyBd5zhWNtgvb2UjBk4mADJQCXJOF9IUK9ZCSxT0s6ATQBvs
	 szCJPy9XOjWmki8LY9yyHlauy78H3iHqCpNca4DNh7umpQREaRpziaaxmrTN5rrsgzKcn
	 tt4XW1rZZNYKMVUJRgzSwYxl52XUoqasGSRHPB1JDCnvccBRej4VwmOSgUrfQYOhPLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qotorTft;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C5D606EE83
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C5D606EE83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qotorTft
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a208d93758so11593085e9.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242209; x=1794847009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w1ajCXAV+nw5LVtcZbwPKg/uH1J37y1Kwpm4nIUcxqA=;
        b=qotorTft88p68ryjHl25n/YJ9L0D7z24P6S+2L5JIXZeZmdf2l4U+oWeeHiOx9kgRC
         8W/7xYMvqzXB0lc/ESPdTud7s7oKrDLVNqOC3G3z/NoO8cIeFuenRpNtnwJd8bSe/Gjv
         38sG7Yi+WX6O60TQ6pBseZpDUIzAqhUbOYpyFnVXBeFuwKRWMdPDOGySc382py5lM/Qa
         5A/TFNDeikw2kTHauujG9ISCyipRrGSYbEVX5rb+NTa+zUsEm5QcfknQeL+xKShIb4Y0
         PQ7CSq98tll7pUjJIhR+Me5VPJRPBpJCOzK/I+U9sQ7647CwmJ/EH4fagPgrar+vGzJi
         0NzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242209; x=1794847009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w1ajCXAV+nw5LVtcZbwPKg/uH1J37y1Kwpm4nIUcxqA=;
        b=ayPlv3RbIoCCgiTKSGP4HTyLUuR5Di/aNrbHAXg55vT/yKwj2K1i4D3dkaYnedt5zs
         sgzFbMl0O9+KCbNrl1TmDwayJtN4C+swc0hmFYfgx2nIRuRdsfryHsgCyOO+xgzzRqit
         yDVAbW7yW+yyCHe8uXOh75HHLXYsJAZvPqwy9Om6hvOArbpDJnyBXiO1s/8ctLKGzyyh
         pVe0fHF9FGkqXAUfh+qAjAtx770uvFekS748Kvdr2UzwWBcWHa5erjJeAr5EGWmk1sFW
         0DHfMqbe6ntTMgZjNJXTo+6IarwI2QNetZxpIx7M7A1KmgYIoi+PZIiULkIO6ynTe1iv
         CYkQ==
X-Gm-Message-State: APuU4Z+dNYJ25H4EyQ8kVzzn7ADh9Ei0hG+w565l1yoULWzBh9eVUxlv
	B1DUMBUHSJTZtuhHyztWD//IqQe99fXndBs7y6eLeiQQyATncak3gwxCBFvriA==
X-Gm-Gg: AYBFou1RRE+ebw9OGDD8LrHJb7tFceD1NlDvCyTJf94yywOIvY92VI0m0SRDOuFrkUJ
	s2N0ucaD7cbbQkiTw9UMhtL1skkQCkURoyVHD0gAxg7EKrQy6go7rjBxaOn4Ps7oH6m0FbGXQ+S
	gdDxReGQFWkw5fx2PfJVlEiIZNvv+iKKkFlGQAMbNuKPkI6ByiTpZcV32gzEE6P265IRwS82Zl5
	WL6ApgF/qobJfT8EyroNTs6dy60zM5wpJcty6K4KMYHJOsiMnJeoai5L7qILDptvB7j0VHvB3zS
	0G3GSCq4PKjPHF03QRPIIqYtqZ2dmOnV3sgd0VuzRENaDEf5IAKUsd8wHwTqO5CHXie7xp37mlK
	e62Seoql69r5TDwjDXKd6olyKYhjrqyFgIlcIIE3mOv1pMWOYfSmaE/6xf/XBeDnAFq46tMEJIT
	2c5Jlm/9DrEfpThGCSO0LSEZNJ9wbZu7iigxLfp87amxaczgnhfknap/BQy1syHK0MPBpw4UgBv
	fXCRjhCS2upeT6d47ZXcZcOt9drLnzbgyZjD5aTqtvpTIkGWUxYwM1/Kz+lwPNoQ2eAF65ZM3nk
	O6QyhzBm5PN8rFoJaRjfGKFV2w==
X-Received: by 2002:a05:600c:3e85:b0:4a8:cb23:f71b with SMTP id 5b1f17b1804b1-4b963c87dfdmr80201845e9.18.1794242209475;
        Mon, 09 Nov 2026 08:36:49 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:47 -0800 (PST)
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
Subject: [RFC PATCH v7 16/29] sched/rt: Update rt-cgroup schedulability checks
Date: Mon,  9 Nov 2026 17:36:02 +0100
Message-ID: <20261109163616.195264-17-yurand2000@gmail.com>
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

Introduce cgroup-v2 control files:
- cpu.rt.max:
  Get/set the bandwidth of the given cgroup, or inherith from parent.
- cpu.rt.effective.local:
  Get the actual remaning bandwidth for the group, removing the bw of the
  group's children.

Introduce a number of functions to update the cgroup settings across the
whole hierarchy:
- tg_subtree_has_rt_tasks()
  Checks if the active context rooted at tg is running rt workload.
    Child groups which do not share the same active context are ignored.
- tg_compute_children_bw()
  Computes the total bandwidth of the active context rooted at tg minus
  the root of the context itself.
- tg_rt_schedulable()
  Runs admission tests for the current cgroup tree and the given
  bandwidth update.
- tg_update_active_context()
  Updates the active context of a given subtree with a new one.
- tg_rt_bandwidth() / tg_rt_internal_bandwidth()
  Read the max (internal) bandwidth set to the cgroup.
- tg_set_rt_bandwidth()
  Set the bandwidth of the group.

Update sched_rt_can_attach to run only tasks in the root cgroup or HCBS
cgroups which have non-zero runtime.

Update and reuse __checkparam_dl to check for numerical issues regarding
the dl_server's parameters.

Add from_ratio function to convert from period and bw to runtime, inverse
of the to_ratio function.

Add dl_check_tg(), which performs an admission control test similar to
__dl_overflow, but this time we are updating the cgroup's total bandwidth
rather than scheduling a new DEADLINE task or updating a non-cgroup
deadline server.

Add rcu_sched lock guard for rcu_read_{lock/unlock}_sched.
Add sched_domains lock guard for sched_domains_mutex_{lock/unlock}.
Add lock/unlock methods for sched_rt_handler_mutex and its lock guard.

Add asserts for held sched_domains_mutex and sched_rt_handler_mutex.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 include/linux/rcupdate.h |   1 +
 include/linux/sched.h    |   2 +
 kernel/sched/core.c      |  47 +++++
 kernel/sched/deadline.c  |  61 ++++--
 kernel/sched/rt.c        | 403 ++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h     |  17 +-
 kernel/sched/syscalls.c  |   2 +-
 7 files changed, 447 insertions(+), 86 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3f74ae6d6e1f..196fb3b85c81 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1214,6 +1214,7 @@ extern int rcu_expedited;
 extern int rcu_normal;
 
 DEFINE_LOCK_GUARD_0(rcu, rcu_read_lock(), rcu_read_unlock())
+DEFINE_LOCK_GUARD_0(rcu_sched, rcu_read_lock_sched(), rcu_read_unlock_sched())
 DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8780ef5def7e..4816e408b332 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2531,4 +2531,6 @@ extern void migrate_enable(void);
 
 DEFINE_LOCK_GUARD_0(migrate, migrate_disable(), migrate_enable())
 
+DEFINE_LOCK_GUARD_0(sched_domains, sched_domains_mutex_lock(), sched_domains_mutex_unlock())
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 20297c2123d2..62039972ded6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10450,6 +10450,41 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 }
 #endif /* CONFIG_CFS_BANDWIDTH */
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static int cpu_rt_max_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+	u64 period_us, runtime_us;
+
+	tg_rt_bandwidth(tg, &period_us, &runtime_us);
+	cpu_period_quota_print(sf, period_us, runtime_us);
+	return 0;
+}
+
+static int cpu_rt_internal_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+	u64 period_us, runtime_us;
+
+	tg_rt_internal_bandwidth(tg, &period_us, &runtime_us);
+	cpu_period_quota_print(sf, period_us, runtime_us);
+	return 0;
+}
+
+static ssize_t cpu_rt_max_write(struct kernfs_open_file *of,
+			        char *buf, size_t nbytes, loff_t off)
+{
+	struct task_group *tg = css_tg(of_css(of));
+	u64 period_us = 0, runtime_us;
+	int ret;
+
+	ret = cpu_period_quota_parse(buf, &period_us, &runtime_us);
+	if (!ret)
+		ret = tg_set_rt_bandwidth(tg, period_us, runtime_us);
+	return ret ?: nbytes;
+}
+#endif /* CONFIG_RT_GROUP_SCHED */
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_GROUP_SCHED_WEIGHT
 	{
@@ -10485,6 +10520,18 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_burst_write_u64,
 	},
 #endif /* CONFIG_CFS_BANDWIDTH */
+#ifdef CONFIG_RT_GROUP_SCHED
+	{
+		.name = "rt.max",
+		.seq_show = cpu_rt_max_show,
+		.write = cpu_rt_max_write,
+	},
+	{
+		.name = "rt.effective.local",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cpu_rt_internal_show,
+	},
+#endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	{
 		.name = "uclamp.min",
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 17f303294d6c..64df71ab370d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -352,10 +352,46 @@ void cancel_inactive_timer(struct sched_dl_entity *dl_se)
 	cancel_dl_timer(dl_se, &dl_se->inactive_timer);
 }
 
+/*
+ * Used for dl_bw check and update, used under sched_rt_handler()::mutex and
+ * sched_domains_mutex.
+ */
+u64 dl_cookie;
+
 #ifdef CONFIG_RT_GROUP_SCHED
+int dl_check_tg(unsigned long total)
+{
+	int cpu, cpus, cap;
+	struct dl_bw *dl_b;
+	u64 gen = ++dl_cookie;
+
+	lockdep_assert_held(&sched_domains_mutex);
+	lockdep_assert_held(&sched_rt_handler_mutex);
+
+	for_each_possible_cpu(cpu) {
+		guard(rcu_sched)();
+
+		if (!dl_bw_visited(cpu, gen)) {
+			cap = dl_bw_capacity(cpu);
+			cpus = dl_bw_cpus(cpu);
+			dl_b = dl_bw_of(cpu);
+
+			guard(raw_spinlock_irqsave)(&dl_b->lock);
+
+			if (dl_b->bw != -1 &&
+			    cap_scale(dl_b->bw, cap) < dl_b->total_bw +
+						       total * cpus)
+				return 0;
+		}
+
+	}
+
+	return 1;
+}
+
 void dl_init_tg(struct sched_dl_entity *dl_se, u64 rt_runtime, u64 rt_period)
 {
-	struct rq *rq = container_of_const(dl_se->dl_rq, struct rq, dl);
+	struct rq *rq = rq_of_dl_se(dl_se);
 	int is_active;
 	u64 new_bw;
 
@@ -3723,12 +3759,6 @@ DEFINE_SCHED_CLASS(dl) = {
 #endif
 };
 
-/*
- * Used for dl_bw check and update, used under sched_rt_handler()::mutex and
- * sched_domains_mutex.
- */
-u64 dl_cookie;
-
 int sched_dl_global_validate(void)
 {
 	u64 runtime = global_rt_runtime();
@@ -3740,6 +3770,9 @@ int sched_dl_global_validate(void)
 	int cpu, cap, cpus, ret = 0;
 	unsigned long flags;
 
+	lockdep_assert_held(&sched_domains_mutex);
+	lockdep_assert_held(&sched_rt_handler_mutex);
+
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -3792,6 +3825,9 @@ void sched_dl_do_global(void)
 	int cpu;
 	unsigned long flags;
 
+	lockdep_assert_held(&sched_domains_mutex);
+	lockdep_assert_held(&sched_rt_handler_mutex);
+
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
@@ -3937,7 +3973,7 @@ void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int
  * below 2^63 ns (we have to check both sched_deadline and
  * sched_period, as the latter can be zero).
  */
-bool __checkparam_dl(const struct sched_attr *attr)
+bool __checkparam_dl(const struct sched_attr *attr, bool allow_zero_runtime)
 {
 	u64 period, max, min;
 
@@ -3946,14 +3982,16 @@ bool __checkparam_dl(const struct sched_attr *attr)
 		return true;
 
 	/* deadline != 0 */
-	if (attr->sched_deadline == 0)
+	if ((!allow_zero_runtime || attr->sched_runtime != 0) &&
+	    attr->sched_deadline == 0)
 		return false;
 
 	/*
 	 * Since we truncate DL_SCALE bits, make sure we're at least
 	 * that big.
 	 */
-	if (attr->sched_runtime < (1ULL << DL_SCALE))
+	if ((!allow_zero_runtime || attr->sched_runtime != 0) &&
+	    attr->sched_runtime < (1ULL << DL_SCALE))
 		return false;
 
 	/*
@@ -3976,7 +4014,8 @@ bool __checkparam_dl(const struct sched_attr *attr)
 	max = (u64)READ_ONCE(sysctl_sched_dl_period_max) * NSEC_PER_USEC;
 	min = (u64)READ_ONCE(sysctl_sched_dl_period_min) * NSEC_PER_USEC;
 
-	if (period < min || period > max)
+	if ((!allow_zero_runtime || period != 0) &&
+	    (period < min || period > max))
 		return false;
 
 	return true;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1df87d25fda2..cf756639d9e8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1,4 +1,3 @@
-#pragma GCC diagnostic ignored "-Wunused-function"
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Real-Time Scheduling Class (mapped to the SCHED_FIFO and SCHED_RR
@@ -2143,9 +2142,6 @@ DEFINE_SCHED_CLASS(rt) = {
 };
 
 #ifdef CONFIG_RT_GROUP_SCHED
-/*
- * Ensure that the real time constraints are schedulable.
- */
 static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *task;
@@ -2166,38 +2162,126 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 	return ret;
 }
 
-struct rt_schedulable_data {
+static int __tg_subtree_has_rt_tasks(struct task_group *tg, void *data) {
+	struct task_group *ctx = data;
+
+	if (dl_bandwidth_read(tg)->active_context == ctx && tg_has_rt_tasks(tg))
+		return 1;
+	else
+		return 0;
+}
+
+static int tg_subtree_has_rt_tasks(struct task_group *tg) {
+	lockdep_assert(rcu_read_lock_held());
+	return walk_tg_tree_from(tg, __tg_subtree_has_rt_tasks, tg_nop,
+			         dl_bandwidth_read(tg)->active_context);
+}
+
+struct tg_update_data {
 	struct task_group *tg;
 	u64 rt_period;
 	u64 rt_runtime;
 };
 
-static int tg_rt_schedulable(struct task_group *tg, void *data)
+struct tg_compute_children_bw_data {
+	struct tg_update_data update;
+	struct task_group *active_context;
+	u64 period;
+	u64 runtime_sum;
+};
+
+static int __tg_compute_children_runtime(struct task_group *tg, void *data) {
+	struct tg_compute_children_bw_data *d = data;
+	const struct task_group *parent_active_context;
+	const struct dl_bandwidth *dl_b_parent, *dl_b = dl_bandwidth_read(tg);
+	u64 period, runtime;
+
+	/* Skip the current task group from the sum. */
+	if (tg == d->active_context)
+		return 0;
+
+	period = dl_b->dl_period;
+	runtime = dl_b->dl_runtime;
+	if (tg == d->update.tg) {
+		period = d->update.rt_period;
+		runtime = d->update.rt_runtime;
+	}
+	if (runtime == RUNTIME_INF || period == 0)
+		return 0;
+
+	dl_b_parent = dl_bandwidth_read(tg->parent);
+	parent_active_context = dl_b_parent->active_context;
+	if (tg->parent == d->update.tg) {
+		if (dl_b_parent->dl_runtime != RUNTIME_INF &&
+		    d->update.rt_runtime == RUNTIME_INF)
+			parent_active_context = dl_bandwidth_read(tg->parent->parent)->active_context;
+		else if (d->update.rt_runtime != RUNTIME_INF)
+			parent_active_context = tg->parent;
+	}
+
+	if (parent_active_context != d->active_context)
+		return 0;
+
+	d->runtime_sum += mul_u64_u64_div_u64(runtime, d->period, period);
+	return 0;
+}
+
+static u64
+tg_compute_children_runtime(struct task_group *tg,
+			    u64 normalization_period,
+			    struct tg_update_data *data)
+{
+	struct tg_compute_children_bw_data sum_data = {
+		.active_context = tg,
+		.period = normalization_period,
+		.runtime_sum = 0,
+		.update = *data,
+	};
+
+	lockdep_assert(rcu_read_lock_held());
+	walk_tg_tree_from(tg, __tg_compute_children_runtime, tg_nop, &sum_data);
+	return sum_data.runtime_sum;
+}
+
+struct rt_schedulable_data {
+	struct tg_update_data update;
+	u64 rt_runtime_remainder;
+};
+
+static int __tg_rt_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
-	struct task_group *child;
+	const struct dl_bandwidth *dl_b;
 	u64 total, sum = 0;
 	u64 period, runtime;
 
-	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	runtime = tg->rt_bandwidth.rt_runtime;
+	dl_b = dl_bandwidth_read(tg);
+	period = dl_b->dl_period;
+	runtime = dl_b->dl_runtime;
 
-	if (tg == d->tg) {
-		period = d->rt_period;
-		runtime = d->rt_runtime;
+	if (tg == d->update.tg) {
+		period = d->update.rt_period;
+		runtime = d->update.rt_runtime;
 	}
 
+	/*
+	 * "max" groups are always schedulable, as they defer their access
+	 * control to their first non-max parent.
+	 */
+	if (runtime == RUNTIME_INF)
+		return 0;
+
 	/*
 	 * Cannot have more runtime than the period.
 	 */
-	if (runtime > period && runtime != RUNTIME_INF)
+	if (runtime > period)
 		return -EINVAL;
 
 	/*
 	 * Ensure we don't starve existing RT tasks if runtime turns zero.
 	 */
-	if (rt_bandwidth_enabled() && !runtime &&
-	    tg->rt_bandwidth.rt_runtime && tg_has_rt_tasks(tg))
+	if (dl_bandwidth_enabled() && !runtime && tg != &root_task_group &&
+	    tg_subtree_has_rt_tasks(tg))
 		return -EBUSY;
 
 	total = to_ratio(period, runtime);
@@ -2208,58 +2292,144 @@ static int tg_rt_schedulable(struct task_group *tg, void *data)
 	if (total > to_ratio(global_rt_period(), global_rt_runtime()))
 		return -EINVAL;
 
+	if (tg == &root_task_group) {
+		if (!dl_check_tg(total))
+			return -EBUSY;
+	}
+
 	/*
-	 * The sum of our children's runtime should not exceed our own.
+	 * The sum of our children's runtime, plus our own bw, should not
+	 * exceed our own max.
 	 */
-	list_for_each_entry_rcu(child, &tg->children, siblings) {
-		period = ktime_to_ns(child->rt_bandwidth.rt_period);
-		runtime = child->rt_bandwidth.rt_runtime;
+	total = runtime;
+	sum = tg_compute_children_runtime(tg, period, &d->update);
+	if (sum > total)
+		return -EINVAL;
 
-		if (child == d->tg) {
-			period = d->rt_period;
-			runtime = d->rt_runtime;
-		}
+	/*
+	 * Compute remaining runtime
+	 */
+	if (tg == d->update.tg)
+		d->rt_runtime_remainder = total - sum;
 
-		sum += to_ratio(period, runtime);
+	return 0;
+}
+
+static int tg_rt_schedulable(struct tg_update_data *data, u64 *remainder_runtime)
+{
+	int err;
+	struct rt_schedulable_data d = {
+		.update = (struct tg_update_data) {
+			.tg = data->tg,
+			.rt_period = data->rt_period,
+			.rt_runtime = data->rt_runtime,
+		},
+		.rt_runtime_remainder = 0,
+	};
+
+	/*
+	 * Walk the cgroup tree and check schedulability constraints.
+	 */
+	lockdep_assert(rcu_read_lock_held());
+	err = walk_tg_tree(__tg_rt_schedulable, tg_nop, &d);
+	if (err)
+		return err;
+
+	*remainder_runtime = d.rt_runtime_remainder;
+	return 0;
+}
+
+struct tg_update_active_context_data {
+	struct task_group *new_active_context;
+	struct task_group *old_active_context;
+};
+
+static int __tg_update_active_context(struct task_group *tg, void *data) {
+	struct tg_update_active_context_data *d = data;
+
+	if (dl_bandwidth_read(tg)->active_context == d->old_active_context) {
+		guard(raw_spinlock_irq)(dl_bw_lock_of_tg(tg));
+		dl_bandwidth_write(tg)->active_context = d->new_active_context;
 	}
 
-	if (sum > total)
-		return -EINVAL;
+	return 0;
+}
+
+static void tg_update_active_context(struct task_group *tg,
+				     struct task_group *old_context,
+				     struct task_group *new_context)
+{
+	struct tg_update_active_context_data data = {
+		.new_active_context = new_context,
+		.old_active_context = old_context,
+	};
+	lockdep_assert(rcu_read_lock_held());
+	walk_tg_tree_from(tg, __tg_update_active_context, tg_nop, &data);
+}
+
+int tg_rt_bandwidth(struct task_group *tg,
+		    u64 *rt_period_us, u64 *rt_runtime_us)
+{
+	const struct dl_bandwidth *dl_b;
+
+	guard(raw_spinlock_irq)(dl_bw_lock_of_tg(tg));
+	dl_b = dl_bandwidth_read(tg);
+
+	*rt_runtime_us = -1;
+	if (dl_b->dl_runtime != RUNTIME_INF) {
+		*rt_runtime_us = div64_u64(dl_b->dl_runtime, NSEC_PER_USEC);
+	}
+
+	*rt_period_us = div64_u64(dl_b->dl_period, NSEC_PER_USEC);
 
 	return 0;
 }
 
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
+int tg_rt_internal_bandwidth(struct task_group *tg,
+			     u64 *rt_period_us, u64 *rt_runtime_us)
 {
-	int ret;
+	const struct dl_bandwidth *dl_b;
 
-	struct rt_schedulable_data data = {
-		.tg = tg,
-		.rt_period = period,
-		.rt_runtime = runtime,
-	};
+	guard(raw_spinlock_irq)(dl_bw_lock_of_tg(tg));
+	dl_b = dl_bandwidth_read(tg);
 
-	rcu_read_lock();
-	ret = walk_tg_tree(tg_rt_schedulable, tg_nop, &data);
-	rcu_read_unlock();
+	*rt_runtime_us = dl_b->dl_internal_runtime;
+	*rt_runtime_us = DIV64_U64_ROUND_CLOSEST(*rt_runtime_us, NSEC_PER_USEC);
 
-	return ret;
+	*rt_period_us = div64_u64(dl_b->dl_period, NSEC_PER_USEC);
+
+	return 0;
 }
 
-static int tg_set_rt_bandwidth(struct task_group *tg,
-		u64 rt_period, u64 rt_runtime)
+int tg_set_rt_bandwidth(struct task_group *tg,
+			u64 rt_period_us, u64 rt_runtime_us)
 {
-	int i, err = 0;
+	struct tg_update_data update;
+	struct task_group *parent_ctx;
+	struct dl_bandwidth *dl_b;
+	u64 rt_period, rt_runtime, old_rt_runtime;
+	u64 rt_actual_runtime = 0;
+	u64 runtime, children_runtime;
+	struct sched_attr attr;
+	int err, i;
 
-	/*
-	 * Disallowing the root group RT runtime is BAD, it would disallow the
-	 * kernel creating (and or operating) RT threads.
-	 */
-	if (tg == &root_task_group && rt_runtime == 0)
+	if (rt_runtime_us == RUNTIME_INF)
+		rt_runtime = RUNTIME_INF;
+	else if ((u64)rt_runtime_us > U64_MAX / NSEC_PER_USEC)
 		return -EINVAL;
+	else
+		rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 
-	/* No period doesn't make any sense. */
-	if (rt_period == 0)
+	if ((u64)rt_period_us > U64_MAX / NSEC_PER_USEC)
+		return -EINVAL;
+	else
+		rt_period = (u64)rt_period_us * NSEC_PER_USEC;
+
+	/*
+	 * The root_task_group bandwidth settings are only used to reserve bw
+	 * for HCBS cgroups; runtime == "max" has no meaning there.
+	 */
+	if (rt_runtime == RUNTIME_INF && tg == &root_task_group)
 		return -EINVAL;
 
 	/*
@@ -2268,34 +2438,119 @@ static int tg_set_rt_bandwidth(struct task_group *tg,
 	if (rt_runtime != RUNTIME_INF && rt_runtime > max_rt_runtime)
 		return -EINVAL;
 
-	mutex_lock(&rt_constraints_mutex);
-	err = __rt_schedulable(tg, rt_period, rt_runtime);
+	/*
+	 * Check if the runtime and period min and max values are admissible.
+	 */
+	attr = (struct sched_attr){
+		.sched_flags = 0,
+		.sched_runtime = rt_runtime,
+		.sched_deadline = rt_period,
+		.sched_period = rt_period,
+	};
+
+	if (rt_runtime != RUNTIME_INF && !__checkparam_dl(&attr, true))
+		return -EINVAL;
+
+	update = (struct tg_update_data) {
+		.tg = tg,
+		.rt_period  = rt_period,
+		.rt_runtime = rt_runtime,
+	};
+
+	guard(mutex)(&rt_constraints_mutex);
+	old_rt_runtime = dl_bandwidth_read(tg)->dl_runtime;
+
+	/*
+	 * Disallow changing from/to "max" and a HCBS reservation if the group
+	 * and all of its "max" children have active tasks.
+	 */
+	guard(sched_rt_handler)();
+	guard(sched_domains)();
+	guard(rcu)();
+	if (((rt_runtime == RUNTIME_INF && old_rt_runtime != RUNTIME_INF) ||
+	     (rt_runtime != RUNTIME_INF && old_rt_runtime == RUNTIME_INF)) &&
+	     tg_subtree_has_rt_tasks(tg))
+		return -EINVAL;
+
+	err = tg_rt_schedulable(&update, &rt_actual_runtime);
 	if (err)
-		goto unlock;
+		return err;
+
+	scoped_guard(raw_spinlock_irq, dl_bw_lock_of_tg(tg)) {
+		dl_b = dl_bandwidth_write(tg);
+		dl_b->dl_period  = rt_period;
+		dl_b->dl_runtime = rt_runtime;
+		dl_b->dl_internal_runtime = rt_actual_runtime;
+	}
+
+	if (tg == &root_task_group)
+		return 0;
+
+	parent_ctx = dl_bandwidth_read(tg->parent)->active_context;
+
+	/*
+	* If changing from/to "max" and a HCBS reservation, must update the
+	* active_context of self and all of its subtree.
+	*/
+	if ((rt_runtime == RUNTIME_INF && old_rt_runtime != RUNTIME_INF) ||
+	    (rt_runtime != RUNTIME_INF && old_rt_runtime == RUNTIME_INF))
+	{
+		if (rt_runtime == RUNTIME_INF)
+			tg_update_active_context(tg, dl_b->active_context, parent_ctx);
+		else
+			tg_update_active_context(tg, dl_b->active_context, tg);
 
-	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
-	tg->rt_bandwidth.rt_runtime = rt_runtime;
+	}
 
+	WARN_ON(rt_runtime == RUNTIME_INF && rt_actual_runtime != 0);
 	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = tg->rt_rq[i];
+		dl_init_tg(tg->dl_se[i], rt_actual_runtime, rt_period);
+	}
+
+	/*
+	 * Update the dl_servers of the parent's active context
+	 */
+	if (parent_ctx == &root_task_group)
+		return 0;
+
+	scoped_guard(raw_spinlock_irq, dl_bw_lock_of_tg(parent_ctx)) {
+		dl_b = dl_bandwidth_write(parent_ctx);
 
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_runtime;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		runtime = dl_b->dl_runtime;
+		children_runtime = tg_compute_children_runtime(parent_ctx, dl_b->dl_period, &update);
+
+		rt_period = dl_b->dl_period;
+		rt_actual_runtime = runtime - children_runtime;
+		dl_b->dl_internal_runtime = rt_actual_runtime;
 	}
-	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-unlock:
-	mutex_unlock(&rt_constraints_mutex);
 
-	return err;
+	for_each_possible_cpu(i) {
+		dl_init_tg(parent_ctx->dl_se[i], rt_actual_runtime, rt_period);
+	}
+
+	return 0;
 }
 
 int sched_rt_can_attach(struct task_group *tg)
 {
+	struct task_group *ctx;
+
+	/* If rt group sched is disabled, tasks are always run in the root rq */
+	if (!rt_group_sched_enabled())
+		return 1;
+
+	/* Can always run on the root task group */
+	scoped_guard(raw_spinlock_irqsave, dl_bw_lock_of_tg(tg)) {
+		ctx = dl_bandwidth_read(tg)->active_context;
+		if (ctx == &root_task_group)
+			return 1;
+	}
+
 	/* Don't accept real-time tasks when there is no way for them to run */
-	if (rt_group_sched_enabled() && tg->dl_bandwidth.dl_runtime == 0)
-		return 0;
+	scoped_guard(raw_spinlock_irqsave, dl_bw_lock_of_tg(ctx)) {
+		if (dl_bandwidth_read(ctx)->dl_runtime == 0)
+			return 0;
+	}
 
 	return 1;
 }
@@ -2311,24 +2566,26 @@ static int sched_rt_global_validate(void)
 			NSEC_PER_USEC > max_rt_runtime)))
 		return -EINVAL;
 
-#ifdef CONFIG_RT_GROUP_SCHED
-	if (!rt_group_sched_enabled())
-		return 0;
-
-	scoped_guard(mutex, &rt_constraints_mutex)
-		return __rt_schedulable(NULL, 0, 0);
-#endif
 	return 0;
 }
 
+DEFINE_MUTEX(sched_rt_handler_mutex);
+
+void sched_rt_handler_mutex_lock() {
+	mutex_lock(&sched_rt_handler_mutex);
+}
+
+void sched_rt_handler_mutex_unlock() {
+	mutex_unlock(&sched_rt_handler_mutex);
+}
+
 static int sched_rt_handler(const struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
 	int old_period, old_runtime;
-	static DEFINE_MUTEX(mutex);
 	int ret;
 
-	mutex_lock(&mutex);
+	sched_rt_handler_mutex_lock();
 	sched_domains_mutex_lock();
 	old_period = sysctl_sched_rt_period;
 	old_runtime = sysctl_sched_rt_runtime;
@@ -2352,7 +2609,7 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
 		sysctl_sched_rt_runtime = old_runtime;
 	}
 	sched_domains_mutex_unlock();
-	mutex_unlock(&mutex);
+	sched_rt_handler_mutex_unlock();
 
 	/*
 	 * After changing maximum available bandwidth for DEADLINE, we need to
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 047d564e8f71..10eb56aba3d4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -366,7 +366,7 @@ extern void sched_dl_do_global(void);
 extern int  sched_dl_overflow(struct task_struct *p, int policy, const struct sched_attr *attr);
 extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr, unsigned int flags);
-extern bool __checkparam_dl(const struct sched_attr *attr);
+extern bool __checkparam_dl(const struct sched_attr *attr, bool allow_zero_runtime);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
 extern int  dl_bw_deactivate(int cpu);
@@ -425,6 +425,7 @@ extern void dl_server_init(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq,
 		    struct rq *served_rq,
 		    dl_server_pick_f pick_task);
 extern void sched_init_dl_servers(void);
+extern int dl_check_tg(unsigned long total);
 extern void dl_init_tg(struct sched_dl_entity *dl_se, u64 rt_runtime, u64 rt_period);
 
 extern void fair_server_init(struct rq *rq);
@@ -599,6 +600,12 @@ extern void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 extern bool cfs_task_bw_constrained(struct task_struct *p);
 
+extern int tg_rt_bandwidth(struct task_group *tg,
+			   u64 *rt_period_us, u64 *rt_runtime_us);
+extern int tg_rt_internal_bandwidth(struct task_group *tg,
+				    u64 *rt_period_us, u64 *rt_runtime_us);
+extern int tg_set_rt_bandwidth(struct task_group *tg,
+			       u64 rt_period_us, u64 rt_runtime_us);
 extern int sched_rt_can_attach(struct task_group *tg);
 
 extern struct task_group *sched_create_group(struct task_group *parent);
@@ -2123,6 +2130,14 @@ static inline struct rq *_this_rq_lock_irq(struct rq_flags *rf) __acquires_ret
 	return rq;
 }
 
+extern struct mutex sched_rt_handler_mutex;
+extern void sched_rt_handler_mutex_lock(void);
+extern void sched_rt_handler_mutex_unlock(void);
+
+DEFINE_LOCK_GUARD_0(sched_rt_handler,
+		    sched_rt_handler_mutex_lock(),
+		    sched_rt_handler_mutex_unlock())
+
 #ifdef CONFIG_NUMA
 
 enum numa_topology_type {
diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 8ed4a948b14d..f1e9de478e1d 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -528,7 +528,7 @@ int __sched_setscheduler(struct task_struct *p,
 	 */
 	if (attr->sched_priority > MAX_RT_PRIO-1)
 		return -EINVAL;
-	if ((dl_policy(policy) && !__checkparam_dl(attr)) ||
+	if ((dl_policy(policy) && !__checkparam_dl(attr, false)) ||
 	    (rt_policy(policy) != (attr->sched_priority != 0)))
 		return -EINVAL;
 
-- 
2.56.0

