Received: from mail-dy2-f29.google.com (mail-dy2-f29.google.com [74.125.229.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706264A8FED
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946705; cv=none; b=ujNMiD8NBSnKD5OrzjupGPzuEPSZnrXFgRRNn/BC+QwnAqNgGJ4knPtSmMEN8dbGwqzJn2YyAyGQGGeQzSLh9d5C0m+ZSWmyO/2h0zDbrsfBROrHV8SdFThAUXywkJ95FsNIN10UBXfYg4WnCp5Hbu0yA/R5T2kOszbp7fTqh04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946705; c=relaxed/simple;
	bh=gNmhSJuBDN2Sxt1IrXVcdR1W57Pfc0M3OVZkdmXLSJQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o1rQc6D3JhYZi4AB9DPblwuW8zenECkl1VZWPRQCjAEBxpQz+Wq7Msk8opa5tZxkLIs1GGhMsxQjBqMtnFS0BGlCjOFwchiT8CsOJQXRaRqlYMap5pfERpZrEDD4Nt81jnmkMdawN0i66hu8G9zU9NAc2blOMcpxYrv1bTJ+Aek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nwpqhWpW; arc=none smtp.client-ip=74.125.229.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nwpqhWpW"
Received: by mail-dy2-f29.google.com with SMTP id 5a478bee46e88-34b48100af4so3269881eec.3
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946699; x=1791551499; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7sRaOD0hIQro8Un60DX9U6fQtmyPXGY1+Q4MElWok/g=;
        b=nwpqhWpWUfn8DSGDKfj4DwBwqAj8alGFopnT8tQYyK+R6VEMJaRy8pMqFxnlQzyimz
         0iBnyvhGUyD0rxCan8ZbMeT84N6O8oFCR2lC9FyaNrXUS6MjVtbcjhBwEjYz92HZYWHq
         Uf0DUKUKkQTMIoGKINXkw+6XhyR2oEPuvPRF/1PLfjRnzupVEShYwQD09h3K8yO96+Ln
         6iM/xqwJVnf9POJXOSifRZJjceMSLb4pFPQJuu/ZyJT5aM0M0jaUuhsiieihAPCcS5Hk
         p1lOOAF9BHwajv9XcqRHWXxSzF+yWWB1YlBJCwv4va9By9c/eztgyX26dlhc3vW+cM8n
         aTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946699; x=1791551499;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7sRaOD0hIQro8Un60DX9U6fQtmyPXGY1+Q4MElWok/g=;
        b=aP5Rc9/gO48nau5/knqGLlo7UFZrlwkoucVSI4A+jHul0DYMSWX4kwLQS0KrU+GYEy
         5dXVB5fJTAt1evGMQtMGZcCgCUQa9uSDvEIuqtNdmGP7z1C7AlxU8IoMfydzuwZeHyX0
         VkjlJaQs10136kbO03gMKRCEZc3y9bSXRjNLPH8/pMS8JpQE769hkL47hB9Vn+0rW+yi
         dngKam18tlel6Y9mj0IUf8+ast6/SpyeV8Ejt9geT/9tZn3zari1s93Ht0vzvZ/+/U/J
         ggVyKFRxrVvyzVx8TPWmrD1sZ5UwYjHjeHO8Iqx66N3MMGtXfduiEJJTlMzIAPDOmvIk
         6MUA==
X-Forwarded-Encrypted: i=1; AKwUvBwZE5h3RrIHDrevdtkvohEUCOJCHAwlH3jC3ri+Y8yDUgYX9IpAVSGbInAxuplnX5rifTIWTurv@vger.kernel.org
X-Gm-Message-State: AFq9FYLDxlfl0e0GxPanjQ2ubUBftEDDJGa91dY43kN3bKwPkie3wP89
	YO7ireFvy8esDeY+yIIYR5Rwk8C7iQ3fiA4puArnVS5sOoZ1pAkeYCRt
X-Gm-Gg: AYBFou2u0u22cyGQNHciYkpuP4BgcXV24U5Wbt3IShl5w/hTNWphp7sEESCyQ/WrBjh
	gbYIv97UCUjaFlMc0v4TMHGtuakoKZFy7Srma5edHEtWcSNPeuBBFSPcZLEerdbPfOp1mWyH8G+
	+NPlPP6s9ls0jl4OxVnafNazsAxwaSM82tDaBO9RTCGPjDT7QFMw9kPAYEArnf6TFJH5WizPJBr
	IHf3a3zZEsaYUPwWToRND1EmN/dGw/ikRlHNBEx1ZACWrZ7FetImQmE0Syfz94duxJErjA9TwS9
	NG31p/kBIcOkhX2htzqhMbVwAKijSeED1934D37CIawG+6m3jtEePt3rzmvwt4y4IpCDR95/NdQ
	OkhuEwPGr+Kaq8lCj1PtJ1BnZZdP2iJo5xWuoPwV4QGZoibYUM+ZEd+VHyDnom4hl1T4YufGeI2
	HHClHdhd96tTpNKcFutco1DJR61YUvpzEE3ycJT7+IeDnma81bOYZR3WOEXFLvqm650Mw=
X-Received: by 2002:a05:7300:6a90:b0:339:8131:424e with SMTP id 5a478bee46e88-34f2185ad93mr3079119eec.34.1790946698505;
        Fri, 02 Oct 2026 06:11:38 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:11:38 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:28 +0800
Subject: [PATCH v5 08/12] tick/nohz: Derive full-dynticks state from
 HK_TYPE_KERNEL_NOISE
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-8-78a6996d87ad@gmail.com>
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

tick_nohz_full_mask and tick_nohz_full_running duplicate state already
tracked by housekeeping: HK_TYPE_KERNEL_NOISE's cpumask is the
complement of the former, and housekeeping_enabled(HK_TYPE_KERNEL_NOISE)
the same as the latter.  Keeping both in sync is itself a source of
bugs now that DHM makes HK_TYPE_KERNEL_NOISE runtime-mutable.

Turn tick_nohz_full_enabled()/tick_nohz_full_cpu() from header inlines
into real functions in tick-sched.c that query housekeeping directly,
avoiding a tick.h <-> sched/isolation.h include cycle.  Remove
tick_nohz_full_mask, tick_nohz_full_running and tick_nohz_full_setup():
boot setup already records the same information in
housekeeping.cpumasks[HK_TYPE_KERNEL_NOISE].  Add
housekeeping_disable_type() for the one caller (tick_nohz_init()'s
arch-capability fallback) that needs to fully turn a type back off
after boot parsing already enabled it.

tick_nohz_cpu_isolate()/tick_nohz_cpu_deisolate() no longer need their
own mutex or mask bookkeeping: housekeeping_update_types() has already
updated the mask by the time they run, so they reduce to the
ct_cpu_track_user()/ct_cpu_untrack_user() context-tracking toggle.

Update the other direct readers (RCU's rcu_init_nohz(), the
nohz_full/housekeeping sysfs files in drivers/base/cpu.c, and
resctrl's cpumask_any_housekeeping()) to compute the full-dynticks set
as the complement of housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE)
instead of reading the removed mask.

tick_do_timer_cpu's hotplug protection and the "duty never relinquishes"
assertion need the same housekeeping-derived treatment, but not the
same predicate: the assertion in tick_sched_do_timer() should only
fire while a full-dynticks CPU genuinely exists right now, whereas
the hotplug protection in tick_nohz_cpu_hotpluggable() must stay
active across DHM's single-CPU isolate/de-isolate cycle even though
the published mask briefly looks empty.

Add tick_nohz_full_live(), checking HK_TYPE_KERNEL_NOISE is both
enabled and currently isolating at least one CPU, and use it for the
tick_sched_do_timer() assertion: HK_TYPE_KERNEL_NOISE can stay
permanently enabled after DHM's first runtime isolation even once
every CPU has been de-isolated again, and an enabled type with an
empty mask is an ordinary NO_HZ_IDLE duty handover, not a violation.

Keep tick_nohz_cpu_hotpluggable() on the plain housekeeping_enabled()
check instead: DHM's cpuset_update_sd_hk_unlock() only calls
housekeeping_update_types() to publish a new CPU's isolation after
remove_cpu() on it has already succeeded, so at the exact moment that
remove_cpu() call reaches this hotplug check, the live mask still
reflects the state from before this isolation and tick_nohz_full_live()
would see it as empty for every single-CPU isolation, not just the
very first one, leaving the actual tick_do_timer_cpu holder
unprotected each time.

Boot-time nohz_full=/isolcpus=nohz reaches the hotplug protection via
tick_nohz_init(), which is never called for DHM's zero-boot-param
runtime path since nohz_full= was never set at boot.  Factor the
cpuhp_setup_state_nocalls() call out of tick_nohz_init() into a new
tick_nohz_full_hotplug_init(), and call it from
housekeeping_update_types()'s HK_TYPE_KERNEL_NOISE first-enable path
as well, alongside the existing sched_tick_offload_init() call there.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 drivers/base/cpu.c              |  22 ++++--
 fs/resctrl/internal.h           |   6 +-
 include/linux/sched/isolation.h |   2 +
 include/linux/tick.h            |  40 +++--------
 kernel/rcu/tree_nocb.h          |  24 +++++--
 kernel/sched/isolation.c        |  26 +++++--
 kernel/time/tick-sched.c        | 156 +++++++++++++++++++++++++++++++++-------
 7 files changed, 205 insertions(+), 71 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 1f85fcbba867d..c492abd69fa1b 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -328,10 +328,24 @@ static ssize_t nohz_full_show(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
-	if (cpumask_available(tick_nohz_full_mask))
-		return sysfs_emit(buf, "%*pbl\n",
-				  cpumask_pr_args(tick_nohz_full_mask));
-	return sysfs_emit(buf, "\n");
+	cpumask_var_t full_mask;
+	ssize_t len;
+
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return sysfs_emit(buf, "\n");
+
+	if (!alloc_cpumask_var(&full_mask, GFP_KERNEL))
+		return sysfs_emit(buf, "\n");
+
+	/* Full-dynticks CPUs are the complement of the housekeeping set. */
+	rcu_read_lock();
+	cpumask_andnot(full_mask, cpu_possible_mask,
+		       housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE));
+	rcu_read_unlock();
+
+	len = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(full_mask));
+	free_cpumask_var(full_mask);
+	return len;
 }
 static DEVICE_ATTR_RO(nohz_full);
 #endif
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index e62a277dee850..99c28507c1366 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -6,6 +6,7 @@
 #include <linux/kernfs.h>
 #include <linux/fs_context.h>
 #include <linux/tick.h>
+#include <linux/sched/isolation.h>
 
 #define CQM_LIMBOCHECK_INTERVAL	1000
 
@@ -28,7 +29,10 @@ cpumask_any_housekeeping(const struct cpumask *mask, int exclude_cpu)
 
 	/* Try to find a CPU that isn't nohz_full to use in preference */
 	if (tick_nohz_full_enabled()) {
-		cpu = cpumask_any_andnot_but(mask, tick_nohz_full_mask, exclude_cpu);
+		rcu_read_lock();
+		cpu = cpumask_any_and_but(mask, housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE),
+					  exclude_cpu);
+		rcu_read_unlock();
 		if (cpu < nr_cpu_ids)
 			return cpu;
 	}
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 70602a74c1410..327c7b71bafe1 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -64,6 +64,7 @@ extern int housekeeping_update(struct cpumask *isol_mask);
 extern int housekeeping_update_types(unsigned long type_mask,
 				     struct cpumask *isol_mask);
 extern void __init housekeeping_init(void);
+extern void __init housekeeping_disable_type(enum hk_type type);
 
 #else
 
@@ -99,6 +100,7 @@ static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
 static inline int housekeeping_update_types(unsigned long type_mask,
 					    struct cpumask *isol_mask) { return 0; }
 static inline void housekeeping_init(void) { }
+static inline void housekeeping_disable_type(enum hk_type type) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_type type)
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b121c5d53e308..58752fac3ce39 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -161,36 +161,14 @@ static inline ktime_t tick_nohz_get_sleep_length(ktime_t *delta_next)
 }
 #endif /* !CONFIG_NO_HZ_COMMON */
 
-/*
- * Mask of CPUs that are nohz_full.
- *
- * Users should be guarded by CONFIG_NO_HZ_FULL or a tick_nohz_full_cpu()
- * check.
- */
-extern cpumask_var_t tick_nohz_full_mask;
-
 #ifdef CONFIG_NO_HZ_FULL
-extern bool tick_nohz_full_running;
-
-static inline bool tick_nohz_full_enabled(void)
-{
-	if (!context_tracking_enabled())
-		return false;
-
-	return tick_nohz_full_running;
-}
-
 /*
- * Check if a CPU is part of the nohz_full subset. Arrange for evaluating
- * the cpu expression (typically smp_processor_id()) _after_ the static
- * key.
+ * tick_nohz_full_enabled() / tick_nohz_full_cpu() report the
+ * HK_TYPE_KERNEL_NOISE housekeeping state; they are implemented in
+ * tick-sched.c to avoid a tick.h <-> sched/isolation.h include cycle.
  */
-#define tick_nohz_full_cpu(_cpu) ({					\
-	bool __ret = false;						\
-	if (tick_nohz_full_enabled())					\
-		__ret = cpumask_test_cpu((_cpu), tick_nohz_full_mask);	\
-	__ret;								\
-})
+extern bool tick_nohz_full_enabled(void);
+extern bool tick_nohz_full_cpu(int cpu);
 
 extern void tick_nohz_dep_set(enum tick_dep_bits bit);
 extern void tick_nohz_dep_clear(enum tick_dep_bits bit);
@@ -205,6 +183,9 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
 extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
 				       enum tick_dep_bits bit);
 extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
+extern int tick_nohz_cpu_isolate(int cpu);
+extern void tick_nohz_cpu_deisolate(int cpu);
+extern int tick_nohz_full_hotplug_init(void);
 
 /*
  * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
@@ -268,7 +249,6 @@ static inline void tick_dep_clear_signal(struct signal_struct *signal,
 
 extern void tick_nohz_full_kick_cpu(int cpu);
 extern void __tick_nohz_task_switch(void);
-extern void __init tick_nohz_full_setup(cpumask_var_t cpumask);
 #else
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
@@ -276,6 +256,9 @@ static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
 static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
 static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
+static inline int tick_nohz_cpu_isolate(int cpu) { return -EINVAL; }
+static inline void tick_nohz_cpu_deisolate(int cpu) { }
+static inline int tick_nohz_full_hotplug_init(void) { return -EINVAL; }
 
 static inline void tick_dep_set(enum tick_dep_bits bit) { }
 static inline void tick_dep_clear(enum tick_dep_bits bit) { }
@@ -293,7 +276,6 @@ static inline void tick_dep_clear_signal(struct signal_struct *signal,
 
 static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void __tick_nohz_task_switch(void) { }
-static inline void tick_nohz_full_setup(cpumask_var_t cpumask) { }
 #endif
 
 static inline void tick_nohz_task_switch(void)
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 99f3e4cec34e3..8a95aaa42ff01 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1368,11 +1368,17 @@ void __init rcu_init_nohz(void)
 	int cpu;
 	struct rcu_data *rdp;
 	const struct cpumask *cpumask = NULL;
-
-#if defined(CONFIG_NO_HZ_FULL)
-	if (tick_nohz_full_running && !cpumask_empty(tick_nohz_full_mask))
-		cpumask = tick_nohz_full_mask;
-#endif
+	cpumask_var_t nohz_full_mask;
+	bool have_nohz_full_mask = false;
+
+	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE) &&
+	    alloc_cpumask_var(&nohz_full_mask, GFP_KERNEL)) {
+		have_nohz_full_mask = true;
+		cpumask_andnot(nohz_full_mask, cpu_possible_mask,
+			       housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+		if (!cpumask_empty(nohz_full_mask))
+			cpumask = nohz_full_mask;
+	}
 
 	if (IS_ENABLED(CONFIG_RCU_NOCB_CPU_DEFAULT_ALL) &&
 	    !rcu_state.nocb_is_setup && !cpumask)
@@ -1382,7 +1388,7 @@ void __init rcu_init_nohz(void)
 		if (!cpumask_available(rcu_nocb_mask)) {
 			if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
 				pr_info("rcu_nocb_mask allocation failed, callback offloading disabled.\n");
-				return;
+				goto out_free;
 			}
 		}
 
@@ -1391,7 +1397,7 @@ void __init rcu_init_nohz(void)
 	}
 
 	if (!rcu_state.nocb_is_setup)
-		return;
+		goto out_free;
 
 	rcu_nocb_register_lazy_shrinker();
 
@@ -1415,6 +1421,10 @@ void __init rcu_init_nohz(void)
 		rcu_segcblist_set_flags(&rdp->cblist, SEGCBLIST_OFFLOADED);
 	}
 	rcu_organize_nocb_kthreads();
+
+out_free:
+	if (have_nohz_full_mask)
+		free_cpumask_var(nohz_full_mask);
 }
 
 static DEFINE_MUTEX(rcu_nocb_lazy_mutex);
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 7725514ac290e..35c8d5302c991 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -38,6 +38,20 @@ bool housekeeping_enabled(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+/*
+ * housekeeping_disable_type - Fully disable a housekeeping type at boot
+ * @type: Housekeeping type to disable
+ *
+ * Used by the rare boot fallback where a type's setup must be undone
+ * because a required arch capability turned out to be missing.  Clears
+ * the type's flag bit so housekeeping_enabled() and housekeeping_cpumask()
+ * fall back to "not configured" for it.
+ */
+void __init housekeeping_disable_type(enum hk_type type)
+{
+	WRITE_ONCE(housekeeping.flags, housekeeping.flags & ~BIT(type));
+}
+
 /*
  * Types that can change at runtime via cpuset isolated partitions.
  * Boot-only types (DOMAIN_BOOT) are always safe to read without lockdep.
@@ -299,10 +313,15 @@ int housekeeping_update_types(unsigned long type_mask,
 			 * was never allocated at boot since nohz_full= was
 			 * absent.  Allocate it now before CPUs cycle through
 			 * hotplug and sched_tick_stop() dereferences
-			 * tick_work_cpu.
+			 * tick_work_cpu.  Likewise, tick_nohz_init() never
+			 * ran this path's cpuhp registration, so the CPU
+			 * currently holding tick_do_timer_cpu duty has no
+			 * hotplug protection yet; install it now.
 			 */
-			if (type == HK_TYPE_KERNEL_NOISE)
+			if (type == HK_TYPE_KERNEL_NOISE) {
 				WARN_ON_ONCE(sched_tick_offload_init());
+				WARN_ON_ONCE(tick_nohz_full_hotplug_init());
+			}
 		}
 		rcu_assign_pointer(housekeeping.cpumasks[type], trials[type]);
 		trials[type] = NULL;
@@ -490,9 +509,6 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 			housekeeping_setup_type(type, housekeeping_staging);
 	}
 
-	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE))
-		tick_nohz_full_setup(non_housekeeping_mask);
-
 	housekeeping.flags |= flags;
 	err = 1;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8c53754c4ac4a..2d86035994372 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -22,6 +22,7 @@
 #include <linux/sched/stat.h>
 #include <linux/sched/nohz.h>
 #include <linux/sched/loadavg.h>
+#include <linux/sched/isolation.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
@@ -224,6 +225,20 @@ static bool tick_limited_update_jiffies64(struct tick_sched *ts, ktime_t now)
 
 #define MAX_STALLED_JIFFIES 5
 
+#ifdef CONFIG_NO_HZ_FULL
+/*
+ * True when HK_TYPE_KERNEL_NOISE is enabled and currently isolates at
+ * least one CPU. DHM can leave the type permanently enabled with an
+ * empty mask after a full runtime de-isolation; treat that state like
+ * ordinary NO_HZ_IDLE rather than full dynticks.
+ */
+static bool tick_nohz_full_live(void)
+{
+	return housekeeping_enabled(HK_TYPE_KERNEL_NOISE) &&
+	       !cpumask_full(housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+}
+#endif
+
 static void tick_sched_do_timer(struct tick_sched *ts, ktime_t now)
 {
 	int tick_cpu, cpu = smp_processor_id();
@@ -235,14 +250,14 @@ static void tick_sched_do_timer(struct tick_sched *ts, ktime_t now)
 	 * this duty, then the jiffies update is still serialized by
 	 * 'jiffies_lock'.
 	 *
-	 * If nohz_full is enabled, this should not happen because the
-	 * 'tick_do_timer_cpu' CPU never relinquishes.
+	 * If a full-dynticks CPU is currently isolated, this should not
+	 * happen because the 'tick_do_timer_cpu' CPU never relinquishes.
 	 */
 	tick_cpu = READ_ONCE(tick_do_timer_cpu);
 
 	if (IS_ENABLED(CONFIG_NO_HZ_COMMON) && unlikely(tick_cpu == TICK_DO_TIMER_NONE)) {
 #ifdef CONFIG_NO_HZ_FULL
-		WARN_ON_ONCE(tick_nohz_full_running);
+		WARN_ON_ONCE(tick_nohz_full_live());
 #endif
 		WRITE_ONCE(tick_do_timer_cpu, cpu);
 		tick_cpu = cpu;
@@ -332,10 +347,35 @@ static enum hrtimer_restart tick_nohz_handler(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_NO_HZ_FULL
-cpumask_var_t tick_nohz_full_mask;
-EXPORT_SYMBOL_GPL(tick_nohz_full_mask);
-bool tick_nohz_full_running;
-EXPORT_SYMBOL_GPL(tick_nohz_full_running);
+bool tick_nohz_full_enabled(void)
+{
+	if (!context_tracking_enabled())
+		return false;
+
+	return housekeeping_enabled(HK_TYPE_KERNEL_NOISE);
+}
+EXPORT_SYMBOL_GPL(tick_nohz_full_enabled);
+
+/*
+ * Check if a CPU is part of the nohz_full subset. Arrange for evaluating
+ * the cpu expression (typically smp_processor_id()) _after_ the static
+ * key.
+ */
+bool tick_nohz_full_cpu(int cpu)
+{
+	bool ret;
+
+	if (!tick_nohz_full_enabled())
+		return false;
+
+	rcu_read_lock();
+	ret = !cpumask_test_cpu(cpu, housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE));
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tick_nohz_full_cpu);
+
 static atomic_t tick_dep_mask;
 
 static bool check_tick_dependency(atomic_t *dep)
@@ -488,12 +528,15 @@ static void tick_nohz_full_kick_all(void)
 {
 	int cpu;
 
-	if (!tick_nohz_full_running)
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
 		return;
 
 	preempt_disable();
-	for_each_cpu_and(cpu, tick_nohz_full_mask, cpu_online_mask)
+	rcu_read_lock();
+	for_each_cpu_andnot(cpu, cpu_online_mask,
+			    housekeeping_cpumask_rcu(HK_TYPE_KERNEL_NOISE))
 		tick_nohz_full_kick_cpu(cpu);
+	rcu_read_unlock();
 	preempt_enable();
 }
 
@@ -619,13 +662,31 @@ void __tick_nohz_task_switch(void)
 	}
 }
 
-/* Get the boot-time nohz CPU list from the kernel parameters. */
-void __init tick_nohz_full_setup(cpumask_var_t cpumask)
+/*
+ * tick_nohz_cpu_isolate - Add a CPU to the full-dynticks set at runtime.
+ * @cpu: the CPU to isolate; must be offline.
+ *
+ * The caller has already excluded @cpu from the HK_TYPE_KERNEL_NOISE
+ * housekeeping mask via housekeeping_update_types(), which is what
+ * tick_nohz_full_cpu() consults.  Activate per-CPU context tracking so
+ * that kernel/user transitions suppress the scheduler tick.
+ */
+int tick_nohz_cpu_isolate(int cpu)
+{
+	ct_cpu_track_user(cpu);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tick_nohz_cpu_isolate);
+
+/*
+ * tick_nohz_cpu_deisolate - Remove a CPU from the full-dynticks set.
+ * @cpu: the CPU to de-isolate; must be offline.
+ */
+void tick_nohz_cpu_deisolate(int cpu)
 {
-	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
-	cpumask_copy(tick_nohz_full_mask, cpumask);
-	tick_nohz_full_running = true;
+	ct_cpu_untrack_user(cpu);
 }
+EXPORT_SYMBOL_GPL(tick_nohz_cpu_deisolate);
 
 bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
 {
@@ -633,8 +694,18 @@ bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
 	 * The 'tick_do_timer_cpu' CPU handles housekeeping duty (unbound
 	 * timers, workqueues, timekeeping, ...) on behalf of full dynticks
 	 * CPUs. It must remain online when nohz full is enabled.
+	 *
+	 * Deliberately check the permanently-sticky HK_TYPE_KERNEL_NOISE
+	 * flag here, not tick_nohz_full_live()'s mask-aware variant: DHM
+	 * isolates one CPU at a time and only publishes the updated mask
+	 * (housekeeping_update_types()) after remove_cpu() succeeds, so
+	 * the live mask still looks empty at the exact moment a brand
+	 * new isolation's remove_cpu() call reaches this check. Gating
+	 * on the mask here would leave the duty holder unprotected for
+	 * every single-CPU isolation, not just the very first one.
 	 */
-	if (tick_nohz_full_running && READ_ONCE(tick_do_timer_cpu) == cpu)
+	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE) &&
+	    READ_ONCE(tick_do_timer_cpu) == cpu)
 		return false;
 	return true;
 }
@@ -644,11 +715,34 @@ static int tick_nohz_cpu_down(unsigned int cpu)
 	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
 }
 
+/*
+ * tick_nohz_full_hotplug_init - Install tick_do_timer_cpu hotplug protection.
+ *
+ * Boot-time nohz_full=/isolcpus=nohz reaches this via tick_nohz_init().
+ * DHM's runtime first-enable path (no nohz_full= at boot) calls this
+ * directly instead, since tick_nohz_init() has already run and returned
+ * early by the time housekeeping_update_types() first sets
+ * HK_TYPE_KERNEL_NOISE. Without it, the CPU holding tick_do_timer_cpu
+ * duty has no hotplug protection and can be pulled down by
+ * remove_cpu(), dropping timekeeping duty with no notice.
+ */
+int tick_nohz_full_hotplug_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					 "kernel/nohz:predown", NULL,
+					 tick_nohz_cpu_down);
+	return ret < 0 ? ret : 0;
+}
+EXPORT_SYMBOL_GPL(tick_nohz_full_hotplug_init);
+
 void __init tick_nohz_init(void)
 {
+	cpumask_var_t full_mask;
 	int cpu, ret;
 
-	if (!tick_nohz_full_running)
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
 		return;
 
 	/*
@@ -658,8 +752,7 @@ void __init tick_nohz_init(void)
 	 */
 	if (!arch_irq_work_has_interrupt()) {
 		pr_warn("NO_HZ: Can't run full dynticks because arch doesn't support IRQ work self-IPIs\n");
-		cpumask_clear(tick_nohz_full_mask);
-		tick_nohz_full_running = false;
+		housekeeping_disable_type(HK_TYPE_KERNEL_NOISE);
 		return;
 	}
 
@@ -667,22 +760,35 @@ void __init tick_nohz_init(void)
 			!IS_ENABLED(CONFIG_PM_SLEEP_SMP_NONZERO_CPU)) {
 		cpu = smp_processor_id();
 
-		if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
+		if (!cpumask_test_cpu(cpu, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE))) {
+			cpumask_var_t isolated;
+
 			pr_warn("NO_HZ: Clearing %d from nohz_full range "
 				"for timekeeping\n", cpu);
-			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+			if (alloc_cpumask_var(&isolated, GFP_KERNEL)) {
+				cpumask_andnot(isolated, cpu_possible_mask,
+					       housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+				cpumask_clear_cpu(cpu, isolated);
+				WARN_ON_ONCE(housekeeping_update_types(BIT(HK_TYPE_KERNEL_NOISE),
+								       isolated));
+				free_cpumask_var(isolated);
+			}
 		}
 	}
 
-	for_each_cpu(cpu, tick_nohz_full_mask)
+	if (!alloc_cpumask_var(&full_mask, GFP_KERNEL))
+		return;
+	cpumask_andnot(full_mask, cpu_possible_mask,
+		       housekeeping_cpumask(HK_TYPE_KERNEL_NOISE));
+
+	for_each_cpu(cpu, full_mask)
 		ct_cpu_track_user_init(cpu);
 
-	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-					"kernel/nohz:predown", NULL,
-					tick_nohz_cpu_down);
+	ret = tick_nohz_full_hotplug_init();
 	WARN_ON(ret < 0);
 	pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
-		cpumask_pr_args(tick_nohz_full_mask));
+		cpumask_pr_args(full_mask));
+	free_cpumask_var(full_mask);
 }
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 

-- 
2.43.0

