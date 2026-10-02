Received: from mail-dl2-f40.google.com (mail-dl2-f40.google.com [74.125.229.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC8549BD9F
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946687; cv=none; b=Q/A0WEt5eIQCXl9QAjQz+sNpYfIpvKFfu2/Bs2obJgBDmy9yYo767RMSwwqk4ZAZ5o7rg9dNTJH1H+aVJBXE2wMBlbSLpJDUU/JH3YyYmXe6hdUTP/UWVxrlFYxBP9W7mLEvsOr1T0/tYQ1vygEDoraKRYvoxK0ZaqPwyH6Lcjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946687; c=relaxed/simple;
	bh=+SqvbLaUu9l7Y+KxTii2lnGODDCoc7bkuP468WrdWtw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=midIaJfO4aEQD0WU8AEnQyicmZQVCKx/bQ7RQtWYbK9uAv1JDQ7oDKpnjXACXGn5RQ3TsPQK5sFHjybGYND1tM1IabODavmYmOtdzHFEwsZUBPbqgAOFDDXy3Rsx4nlpwd+RMQAfBI+tROKTdqPH2Dz4tBtf1+ejQZV+Aehc010=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3jttJA+; arc=none smtp.client-ip=74.125.229.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3jttJA+"
Received: by mail-dl2-f40.google.com with SMTP id a92af1059eb24-14fe2605d85so118587c88.3
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946682; x=1791551482; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ve2PMleKVRfVJjBVnkNE6jeqRclzRFzcrDXbN4vG6Q8=;
        b=L3jttJA+cHCsnglHef5Bm2QtwpHPwD95DXbSZJegqD+6NUm89HEpBR5TaGxfcnNN+b
         IEpGufVq1c/RVbfWeyG0UHVViid6Nu7NpEV9Kcvo868vUDaKUrnVurcLEdIJGcSwVBfs
         le3Oc0C4qZ5uNuNBJVF2GA95GUl69+puOmdThPNGXDeTif4nkSjgiwQLCMxUfsSyeDq+
         Nhs+E4CVCvOBDOQucGnaf0mqqXpZX68rmdRVxj7KVvtMT8snnGswPp65QL93A4lnk7W+
         kXiglkM/SMsO4LMW/fJPSHYE99o/rUWB9gxNtQ/L/hp64rExWKktIy2p3UKvg6bXb9qt
         qhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946682; x=1791551482;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ve2PMleKVRfVJjBVnkNE6jeqRclzRFzcrDXbN4vG6Q8=;
        b=wpLhJ0ZqPYZQ4RNXyhtFE38BCyJViC7RnsLN1R69G7j13Y5yX6rYCP0mfFmXDGT43B
         H/HCXzP5XrjnTcXUunnvOtAWkyfXGOPJxJr+JW2ibHHWiMmuaCE9Kevq+KOnLBwY3xRK
         kNQb4SYNxM9UwJUkH5s+vSex8l44+vvHtlmDc27pwH/uBIJP42lx3aAJ79rto6PpyOwT
         o4Tre+sdpunZcDdgUM8+ViCR9xymp6a3C5Ldf+VPUaMVtLogxYIBrl68IFKJS2LgDM23
         PiGUnxHpvobsdWivCD2wSkR0azoYgoGqPRBL5qbQxLgUvm32h2H0EsXL2c3mcNvu8jlE
         IKAA==
X-Forwarded-Encrypted: i=1; AKwUvBxtA/gznmdeFnam+yYnKT0/VwXz8GI2Vf/gjNKR/JFGkVuMC937a6QjdMGmCjn7w+mn224gGXzQ@vger.kernel.org
X-Gm-Message-State: AFuF++lr5+/6vMRaNe5iqrTXL7hfip1244BwRjH4aZCZ2rgYkTtsKwvF
	XV+HENSFJjtKDy5hxBgcPmZY0k44EUZ/Lvd1f4HcCX/ZCFBOZ6lpAx7C
X-Gm-Gg: AYBFou34/LyOXyntwf3IsgFu3HRWHvIpwplXoGQLIJ02oeG1kCqe0wZB6Jf94qhoeOr
	1fFh3YtrDpFmEVwx5NYEFlZlvBpsbP2DyXq0R0t6YfZHsBdAzhFjLdzskk9T/mzBhb8rpxj9MSe
	Ju+L3zXY2x51D7IiUV1duFR0nENubsbYPw1/kNYBoOQgp4tRMXM+Rg24KnqEJ2Y10rDsnBgtlAI
	Nfe7xI90IGvG4NVAIIBfjw4hUyInhigUU57yaqzbrBjax9F3sS40CVbRBSbxNQEgZlk4BCTDhWJ
	sbZVozvOThRkM2snKNwd1FDNTtI9QHqPBjtMHq167O7p9ttPPvO4Lw3G4ooZ7v/EYHah4NqlFm7
	1g/Q8rFKoZmCr2XDiDGwgg9Gh68QeBZtQ6NY3l1wvhsIhkf3wnsbfIoTSBSvIIgHkTDtI5mm5vS
	SIdXiMgzGrbJb7jAlYB7fCXtKLLo7BjyAe+pEu7lnEfgrbElWwljiMgaR+bwsGBS4OjQ==
X-Received: by 2002:a05:7022:f90a:b0:143:33de:978f with SMTP id a92af1059eb24-14f5d5b569emr2488888c88.43.1790946681636;
        Fri, 02 Oct 2026 06:11:21 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:11:21 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:26 +0800
Subject: [PATCH v5 06/12] rcu/nocb: Support lazy init for runtime CPU
 isolation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-6-78a6996d87ad@gmail.com>
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

When a cpuset isolated partition first requests kernel-noise isolation,
it needs to offload RCU callbacks from the affected CPUs. The existing
rcu_nocb_cpu_offload() requires rcu_nocbs= or nohz_full= at boot so
that rcu_organize_nocb_kthreads() has already set rdp->nocb_gp_rdp for
each CPU. Without a boot parameter, nocb_gp_rdp is NULL and offload
fails immediately.

Introduce lazy nocb initialization so that the first call into the
isolation path triggers the one-time setup automatically:

  rcu_nocb_lazy_init() - allocates rcu_nocb_mask and calls
    rcu_organize_nocb_kthreads() (now without __init) to set
    nocb_gp_rdp for every possible CPU. Uses a dedicated mutex
    for serialization with a fast-path read of nocb_is_setup.
    Registers the CONFIG_RCU_LAZY shrinker on this first-ever
    setup too: rcu_init_nohz() only does so when nocb_is_setup was
    already true at boot, so the lazy-callback reclaim path would
    otherwise never exist on a system with no rcu_nocbs=/nohz_full=
    boot parameter.  Factor the registration into
    rcu_nocb_register_lazy_shrinker(), shared with rcu_init_nohz().

  rcu_nocb_cpu_isolate() - exported entry point called per-CPU
    while the CPU is offline. Calls rcu_nocb_lazy_init() for the
    one-time setup, spawns the GP and CB kthreads via the existing
    rcu_spawn_cpu_nocb_kthread(), then finalizes offload through
    rcu_nocb_cpu_offload(). Adding the CPU to the GP kthread's
    nocb_head_rdp list is handled by nocb_gp_toggle_rdp() in the
    GP kthread, so rcu_organize_nocb_kthreads() can run with an
    empty mask.

Remove __init from rcu_organize_nocb_kthreads() to allow this
runtime call path; the function itself has no __initdata dependencies.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 include/linux/rcupdate.h |  2 ++
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_nocb.h   | 81 ++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 44c07a66edfff..1425f04ceb4e9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -158,6 +158,7 @@ static __always_inline void rcu_irq_work_resched(void) { }
 void rcu_init_nohz(void);
 int rcu_nocb_cpu_offload(int cpu);
 int rcu_nocb_cpu_deoffload(int cpu);
+int rcu_nocb_cpu_isolate(int cpu);
 void rcu_nocb_flush_deferred_wakeup(void);
 
 #define RCU_NOCB_LOCKDEP_WARN(c, s) RCU_LOCKDEP_WARN(c, s)
@@ -167,6 +168,7 @@ void rcu_nocb_flush_deferred_wakeup(void);
 static inline void rcu_init_nohz(void) { }
 static inline int rcu_nocb_cpu_offload(int cpu) { return -EINVAL; }
 static inline int rcu_nocb_cpu_deoffload(int cpu) { return 0; }
+static inline int rcu_nocb_cpu_isolate(int cpu) { return -EINVAL; }
 static inline void rcu_nocb_flush_deferred_wakeup(void) { }
 
 #define RCU_NOCB_LOCKDEP_WARN(c, s)
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index eedfa43059e80..60bcf52817f3e 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -522,7 +522,7 @@ static void rcu_nocb_unlock_irqrestore(struct rcu_data *rdp,
 				       unsigned long flags);
 static void rcu_lockdep_assert_cblist_protected(struct rcu_data *rdp);
 #ifdef CONFIG_RCU_NOCB_CPU
-static void __init rcu_organize_nocb_kthreads(void);
+static void rcu_organize_nocb_kthreads(void);
 
 /*
  * Disable IRQs before checking offloaded state so that local
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 19bb42672baf8..99f3e4cec34e3 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1344,12 +1344,30 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 }
 #endif // #ifdef CONFIG_RCU_LAZY
 
+#ifdef CONFIG_RCU_LAZY
+static void rcu_nocb_register_lazy_shrinker(void)
+{
+	struct shrinker *lazy_rcu_shrinker = shrinker_alloc(0, "rcu-lazy");
+
+	if (!lazy_rcu_shrinker) {
+		pr_err("Failed to allocate lazy_rcu shrinker!\n");
+		return;
+	}
+
+	lazy_rcu_shrinker->count_objects = lazy_rcu_shrink_count;
+	lazy_rcu_shrinker->scan_objects = lazy_rcu_shrink_scan;
+
+	shrinker_register(lazy_rcu_shrinker);
+}
+#else
+static void rcu_nocb_register_lazy_shrinker(void) { }
+#endif // #ifdef CONFIG_RCU_LAZY
+
 void __init rcu_init_nohz(void)
 {
 	int cpu;
 	struct rcu_data *rdp;
 	const struct cpumask *cpumask = NULL;
-	struct shrinker * __maybe_unused lazy_rcu_shrinker;
 
 #if defined(CONFIG_NO_HZ_FULL)
 	if (tick_nohz_full_running && !cpumask_empty(tick_nohz_full_mask))
@@ -1375,17 +1393,7 @@ void __init rcu_init_nohz(void)
 	if (!rcu_state.nocb_is_setup)
 		return;
 
-#ifdef CONFIG_RCU_LAZY
-	lazy_rcu_shrinker = shrinker_alloc(0, "rcu-lazy");
-	if (!lazy_rcu_shrinker) {
-		pr_err("Failed to allocate lazy_rcu shrinker!\n");
-	} else {
-		lazy_rcu_shrinker->count_objects = lazy_rcu_shrink_count;
-		lazy_rcu_shrinker->scan_objects = lazy_rcu_shrink_scan;
-
-		shrinker_register(lazy_rcu_shrinker);
-	}
-#endif // #ifdef CONFIG_RCU_LAZY
+	rcu_nocb_register_lazy_shrinker();
 
 	if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
 		pr_info("\tNote: kernel parameter 'rcu_nocbs=', 'nohz_full', or 'isolcpus=' contains nonexistent CPUs.\n");
@@ -1409,6 +1417,53 @@ void __init rcu_init_nohz(void)
 	rcu_organize_nocb_kthreads();
 }
 
+static DEFINE_MUTEX(rcu_nocb_lazy_mutex);
+
+/*
+ * Lazily initialize nocb infrastructure on the first call. Allocates
+ * rcu_nocb_mask and sets nocb_gp_rdp for every possible CPU so that
+ * rcu_nocb_cpu_isolate() can offload callbacks without rcu_nocbs= at boot.
+ */
+static noinline int rcu_nocb_lazy_init(void)
+{
+	if (rcu_state.nocb_is_setup)
+		return 0;
+
+	mutex_lock(&rcu_nocb_lazy_mutex);
+	if (!rcu_state.nocb_is_setup) {
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			mutex_unlock(&rcu_nocb_lazy_mutex);
+			return -ENOMEM;
+		}
+		rcu_organize_nocb_kthreads();
+		/*
+		 * Boot-time rcu_init_nohz() only registers the lazy-callback
+		 * shrinker when nocb_is_setup was already true at boot; this
+		 * is the first time it is set, so register it here instead.
+		 */
+		rcu_nocb_register_lazy_shrinker();
+		rcu_state.nocb_is_setup = true;
+	}
+	mutex_unlock(&rcu_nocb_lazy_mutex);
+	return 0;
+}
+
+/*
+ * Offload RCU callbacks for a CPU entering a kernel-noise isolated partition.
+ * @cpu must be offline. Lazily initializes nocb infrastructure on first use.
+ */
+int rcu_nocb_cpu_isolate(int cpu)
+{
+	int ret;
+
+	ret = rcu_nocb_lazy_init();
+	if (ret)
+		return ret;
+	rcu_spawn_cpu_nocb_kthread(cpu);
+	return rcu_nocb_cpu_offload(cpu);
+}
+EXPORT_SYMBOL_GPL(rcu_nocb_cpu_isolate);
+
 /* Initialize per-rcu_data variables for no-CBs CPUs. */
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
@@ -1501,7 +1556,7 @@ module_param(rcu_nocb_gp_stride, int, 0444);
 /*
  * Initialize GP-CB relationships for all no-CBs CPU.
  */
-static void __init rcu_organize_nocb_kthreads(void)
+static void rcu_organize_nocb_kthreads(void)
 {
 	int cpu;
 	bool firsttime = true;

-- 
2.43.0

