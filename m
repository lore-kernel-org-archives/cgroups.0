Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBFD49BD70
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946664; cv=none; b=k2Y4aKe8m62dy97XBkChawQtjohPiovNXbzr6M1f7BACd8pnUvwkVU83nUIZxJzadGmM5qEtAlor1drKRqMQxRXAEyHAI8b+/C9m4pLGd9327KSleK4s0gKdP61OG5tDxi3NaqVSqchmoougvjJp9J3aj2n3GgxF7B0Q3Cth4yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946664; c=relaxed/simple;
	bh=clR/j/gx+EHBkyQ299oIlVPOZs77SBoTB56WjA9u11I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Mw9kK//gB1XFY7lPTZk46tog+jLc/7g5Ewye7/yzDek5klgCsEsUlwPyIqI+IALzmrl1N+QjZIJ1CZwtQO0IfLEPEBtrlM93GZoQ3542c6Sd0LAIqc7ggYwGJHA2dXRGFGyvofye0N3jXTXzivJ7aw7OYV9OQjkR+geG+zKZp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVQfXBg5; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVQfXBg5"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b3e517e6dso2097780eec.1
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946656; x=1791551456; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XxgawKGq20gNiulyrB+XrV1BhnrbbMX8yIc8XwsBgN4=;
        b=HVQfXBg5QOayVUEhG+UnTmC6W4R/wwzTQa7psrmxQuoeyV4ILHMRGPHpKfTfZk5OXZ
         NJvFS+1TFUe5JwS3aYJOcG1fLCoYKoIQS/rAVS1RNYs+0b9hbxWPaE/j9rjzrHgXUMaL
         NYUn75J2OiKYDFZ2Mvp1C5pRUPdWwBZHBiFQwswIiHosyiGF2HgtsFQC+6Ca/BQ1k1ER
         qgquqY9P8TDaQ/7tkUatENbDndB/ss5lkfi5749c8YVFx1WJ3/MNecKJVeFJR2xfqG0o
         X+SLzWWPxljotJib37vwF3KjBhvLptNzoVRFiC8ko40siK9ofuwMNSVxsvAZRhM64f3v
         n9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946656; x=1791551456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxgawKGq20gNiulyrB+XrV1BhnrbbMX8yIc8XwsBgN4=;
        b=DrYCb1y0JBrzRT/SftCiFcCN1VF25hMeRXKnd6HluZGZzF7EnDKl9F8gavX4eaToHJ
         GbEgkLPBm7D2ofFmVl+FmO8T6aS7xUCJSpmBG9kd3VQxMylVT6vsbpiJbqm1kZ27SbZC
         hR04CMdgNnh1VUpuPmHkl7iMIa2PRY0qMDOKI5dNEwux7SbPiOJh5AZVUr0IxD3J7fec
         i5b5E0GZuhypFb+bCvV/akn2UxbTA5tZFALeyE7AXWPlXQ3+maV10oUkjcf5QM55fgu8
         6ftPA9vbpjpOw/oAok+2UzEok3zXzyl6DrvN+ESWqo0aeIRkR5B0zIs6wV+11rKONIwb
         Wl8A==
X-Forwarded-Encrypted: i=1; AKwUvBxBCXsGkbuYEnXfRf33nQUKReoFXqwfi54XtVWS7uCn1jmVWx4l996xIolDkvktP103C9GGfQQT@vger.kernel.org
X-Gm-Message-State: AFuF++kS5mG02SKfV/jsFpI1Y1szORJJbBoMGMrV0mNlVTBYVT76jZVN
	jKVGLr2azAjhrcgvB3P5Z5Y7745ux5DugzdZ4A8gdbKl/n+bFJw9t6bjXuTqrnSf
X-Gm-Gg: AYBFou0ibbJ6UPVti0QgNf2jupC8d3Rhy2HR2Zc0m3wSKWuH1KbHyirjq+oeuVlHSUq
	eEkdhoWQOmph+aJs1lqoX38cfQYr2Gpdbk6vmzvhBT7ZFco3JDBcsUA8LRjQW0si0y6Zy0hAGc/
	o8lRXgqTGi5rbDfhxLBAeH5NgBHNw0HW56l3YNksHJUbeX/isENsXFoFc0KSiVs/ZENtkNJ6bQJ
	rEWHxBH9UqkNJx1Sl2ImYOSRNMe/+Iu4PjDVZIvzImg9wZnKofcfhVHNo+zlAIWbvksDmDvR7Wv
	Qt8uzpL93H9HiB335a+/JUe+BoeJggHZOCzqQPbq2c95JRRp0MaTEHgguRLDFXXXZfWsAY2mHjq
	3DonjrW5yo3203U3eqL0/emZrug4fk06IJD4FH4o0x7Ci2xdKYqZJyNM2ZbBbwKBryqrYGrp6q5
	WArupGIR8vnad7125zBXnrSKwzJpPtOASUkRpHdZdscVkCmCKMOszg9pqBbxj5Kubvag==
X-Received: by 2002:a05:701b:260c:b0:143:490b:93da with SMTP id a92af1059eb24-14f5c7e9362mr2584395c88.39.1790946655692;
        Fri, 02 Oct 2026 06:10:55 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:10:55 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:23 +0800
Subject: [PATCH v5 03/12] sched/isolation: RCU-protect runtime-mutable
 housekeeping cpumask readers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-3-78a6996d87ad@gmail.com>
References: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
In-Reply-To: <20261002-wujing-dhm-v5-0-78a6996d87ad@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Tejun Heo <tj@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
 rcu@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

Now that HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ can be updated at
runtime, their cpumask pointers are swapped and the old masks freed after
an RCU grace period.  Readers that dereference these masks must do so
inside an RCU read-side critical section, otherwise the mask can be freed
while it is still in use.

Convert the runtime-mutable readers to housekeeping_cpumask_rcu() under
rcu_read_lock():

  - get_nohz_timer_target() (HK_TYPE_KERNEL_NOISE)
  - hrtimer target selection (HK_TYPE_TIMER)
  - arm64 topology (HK_TYPE_TICK)
  - Hyper-V channel management, both channel_mgmt.c and
    vmbus_channel_set_cpu() in vmbus_drv.c (HK_TYPE_MANAGED_IRQ)
  - the housekeeping sysfs attribute (HK_TYPE_KERNEL_NOISE)
  - rps_cpumask_housekeeping() (HK_TYPE_WQ, an alias of
    HK_TYPE_KERNEL_NOISE)
  - tmigr_isolated_exclude_cpumask() (HK_TYPE_KERNEL_NOISE)

The watchdog boot-time cpumask initialisation is switched from the
HK_TYPE_TIMER alias to HK_TYPE_KERNEL_NOISE for consistency; both alias
the same value.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 arch/arm64/kernel/topology.c  |  9 ++++++--
 drivers/base/cpu.c            | 20 ++++++++++++-----
 drivers/hv/channel_mgmt.c     | 50 +++++++++++++++++++++++++++++--------------
 drivers/hv/vmbus_drv.c        | 13 ++++++++++-
 kernel/sched/core.c           |  3 +--
 kernel/time/hrtimer.c         |  5 ++++-
 kernel/time/timer_migration.c |  9 +++++++-
 kernel/watchdog.c             |  2 +-
 net/core/net-sysfs.c          | 10 ++++++++-
 9 files changed, 91 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index d28438f8b83f1..1a7badffa45d4 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -212,8 +212,13 @@ int arch_freq_get_on_cpu(int cpu)
 			if (!policy)
 				return -EINVAL;
 
-			if (!cpumask_intersects(policy->related_cpus,
-						housekeeping_cpumask(HK_TYPE_TICK))) {
+			bool no_hk_in_policy;
+
+			rcu_read_lock();
+			no_hk_in_policy = !cpumask_intersects(policy->related_cpus,
+							      housekeeping_cpumask_rcu(HK_TYPE_TICK));
+			rcu_read_unlock();
+			if (no_hk_in_policy) {
 				cpufreq_cpu_put(policy);
 				return -EOPNOTSUPP;
 			}
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 69e52fed42415..1f85fcbba867d 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -303,13 +303,23 @@ static DEVICE_ATTR(isolated, 0444, print_cpus_isolated, NULL);
 static ssize_t housekeeping_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	const struct cpumask *hk_mask;
+	ssize_t len;
 
-	hk_mask = housekeeping_cpumask(HK_TYPE_KERNEL_NOISE);
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return sysfs_emit(buf, "\n");
 
-	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
-		return sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(hk_mask));
-	return sysfs_emit(buf, "\n");
+	/*
+	 * HK_TYPE_KERNEL_NOISE is runtime-mutable: the mask pointer can be
+	 * swapped and the old mask freed after an RCU grace period.  Hold the
+	 * RCU read lock across the dereference and the format so the mask
+	 * cannot be freed while it is being printed.
+	 */
+	rcu_read_lock();
+	len = sysfs_emit(buf, "%*pbl\n",
+			 cpumask_pr_args(housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE)));
+	rcu_read_unlock();
+
+	return len;
 }
 static DEVICE_ATTR_RO(housekeeping);
 
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index a044fd3b3c4e7..c2aa01205c2cc 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -750,26 +750,43 @@ static void init_vp_index(struct vmbus_channel *channel)
 {
 	bool perf_chn = hv_is_perf_channel(channel);
 	u32 i, ncpu = num_online_cpus();
-	cpumask_var_t available_mask;
+	cpumask_var_t available_mask, hk_snap;
 	struct cpumask *allocated_mask;
-	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ);
 	u32 target_cpu;
 	int numa_node;
 
-	if (!perf_chn ||
-	    !alloc_cpumask_var(&available_mask, GFP_KERNEL) ||
-	    cpumask_empty(hk_mask)) {
-		/*
-		 * If the channel is not a performance critical
-		 * channel, bind it to VMBUS_CONNECT_CPU.
-		 * In case alloc_cpumask_var() fails, bind it to
-		 * VMBUS_CONNECT_CPU.
-		 * If all the cpus are isolated, bind it to
-		 * VMBUS_CONNECT_CPU.
-		 */
+	if (!perf_chn) {
+		channel->target_cpu = VMBUS_CONNECT_CPU;
+		return;
+	}
+
+	if (!alloc_cpumask_var(&available_mask, GFP_KERNEL)) {
+		channel->target_cpu = VMBUS_CONNECT_CPU;
+		hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
+		return;
+	}
+
+	/*
+	 * Snapshot HK_TYPE_MANAGED_IRQ cpumask under RCU read lock.
+	 * housekeeping_update_types() frees the old cpumask after
+	 * synchronize_rcu(), so we must not hold the pointer beyond an
+	 * RCU read-side critical section.
+	 */
+	if (!alloc_cpumask_var(&hk_snap, GFP_KERNEL)) {
+		free_cpumask_var(available_mask);
+		channel->target_cpu = VMBUS_CONNECT_CPU;
+		hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
+		return;
+	}
+	rcu_read_lock();
+	cpumask_copy(hk_snap, housekeeping_cpumask_rcu(HK_TYPE_MANAGED_IRQ));
+	rcu_read_unlock();
+
+	if (cpumask_empty(hk_snap)) {
+		free_cpumask_var(hk_snap);
+		free_cpumask_var(available_mask);
 		channel->target_cpu = VMBUS_CONNECT_CPU;
-		if (perf_chn)
-			hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
+		hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
 		return;
 	}
 
@@ -788,7 +805,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 
 retry:
 		cpumask_xor(available_mask, allocated_mask, cpumask_of_node(numa_node));
-		cpumask_and(available_mask, available_mask, hk_mask);
+		cpumask_and(available_mask, available_mask, hk_snap);
 
 		if (cpumask_empty(available_mask)) {
 			/*
@@ -809,6 +826,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 
 	channel->target_cpu = target_cpu;
 
+	free_cpumask_var(hk_snap);
 	free_cpumask_var(available_mask);
 }
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 5ebdbe24b5a1e..ac9b4800ed9fd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1734,6 +1734,7 @@ int vmbus_channel_set_cpu(struct vmbus_channel *channel, u32 target_cpu)
 {
 	u32 origin_cpu;
 	int ret = 0;
+	bool on_housekeeping_cpu;
 
 	lockdep_assert_cpus_held();
 	lockdep_assert_held(&vmbus_connection.channel_mutex);
@@ -1745,7 +1746,17 @@ int vmbus_channel_set_cpu(struct vmbus_channel *channel, u32 target_cpu)
 	if (target_cpu >= nr_cpumask_bits)
 		return -EINVAL;
 
-	if (!cpumask_test_cpu(target_cpu, housekeeping_cpumask(HK_TYPE_MANAGED_IRQ)))
+	/*
+	 * Snapshot the HK_TYPE_MANAGED_IRQ test under RCU read lock:
+	 * housekeeping_update_types() frees the old cpumask after
+	 * synchronize_rcu(), so the pointer must not be dereferenced
+	 * outside an RCU read-side critical section.
+	 */
+	rcu_read_lock();
+	on_housekeeping_cpu = cpumask_test_cpu(target_cpu,
+						housekeeping_cpumask_rcu(HK_TYPE_MANAGED_IRQ));
+	rcu_read_unlock();
+	if (!on_housekeeping_cpu)
 		return -EINVAL;
 
 	if (!cpu_online(target_cpu))
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6c67874e639a5..03a791a1dde9a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1301,9 +1301,8 @@ int get_nohz_timer_target(void)
 		default_cpu = cpu;
 	}
 
-	hk_mask = housekeeping_cpumask(HK_TYPE_KERNEL_NOISE);
-
 	guard(rcu)();
+	hk_mask = housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE);
 
 	for_each_domain(cpu, sd) {
 		for_each_cpu_and(i, sched_domain_span(sd), hk_mask) {
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index cbf1693c86b38..ac9d4eba7380e 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -243,8 +243,11 @@ static bool hrtimer_suitable_target(struct hrtimer *timer, struct hrtimer_clock_
 static inline struct hrtimer_cpu_base *get_target_base(struct hrtimer_cpu_base *base, bool pinned)
 {
 	if (!hrtimer_base_is_online(base)) {
-		int cpu = cpumask_any_and(cpu_online_mask, housekeeping_cpumask(HK_TYPE_TIMER));
+		int cpu;
 
+		rcu_read_lock();
+		cpu = cpumask_any_and(cpu_online_mask, housekeeping_cpumask_rcu(HK_TYPE_TIMER));
+		rcu_read_unlock();
 		return &per_cpu(hrtimer_bases, cpu);
 	}
 
diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 059d43355e650..f56748e9981b0 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1631,7 +1631,14 @@ int tmigr_isolated_exclude_cpumask(struct cpumask *exclude_cpumask)
 	 * There cannot be overlap with the newly available ones.
 	 */
 	cpumask_and(cpumask, exclude_cpumask, tmigr_available_cpumask);
-	cpumask_and(cpumask, cpumask, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+	/*
+	 * HK_TYPE_KERNEL_NOISE is runtime-mutable: housekeeping_update_types()
+	 * frees the old cpumask after synchronize_rcu(), so dereference it
+	 * only under rcu_read_lock().
+	 */
+	rcu_read_lock();
+	cpumask_and(cpumask, cpumask, housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE));
+	rcu_read_unlock();
 	/*
 	 * Handle this here and not in the cpuset code because exclude_cpumask
 	 * might include also the tick CPU if included in isolcpus.
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index e5134ad7b6634..e567fbb0d4692 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -1389,7 +1389,7 @@ void __init lockup_detector_init(void)
 		pr_info("Disabling watchdog on nohz_full cores by default\n");
 
 	cpumask_copy(&watchdog_cpumask,
-		     housekeeping_cpumask(HK_TYPE_TIMER));
+		     housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
 
 	if (!watchdog_hardlockup_probe())
 		watchdog_hardlockup_available = true;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 352173df75785..15f19ac0f6df5 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1017,7 +1017,15 @@ int rps_cpumask_housekeeping(struct cpumask *mask)
 {
 	if (!cpumask_empty(mask)) {
 		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
+		/*
+		 * HK_TYPE_WQ aliases HK_TYPE_KERNEL_NOISE, which is
+		 * runtime-mutable: housekeeping_update_types() frees the old
+		 * cpumask after synchronize_rcu(), so dereference it only
+		 * under rcu_read_lock().
+		 */
+		rcu_read_lock();
+		cpumask_and(mask, mask, housekeeping_cpumask_rcu(HK_TYPE_WQ));
+		rcu_read_unlock();
 		if (cpumask_empty(mask))
 			return -EINVAL;
 	}

-- 
2.43.0

