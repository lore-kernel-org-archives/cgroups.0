Received: from mail-dy2-f34.google.com (mail-dy2-f34.google.com [74.125.229.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41649EC73
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946722; cv=none; b=HQ9YkmlB9pHLuwVgXPVUHjsTfu1s1Da2ATTGk/NKPedlEdGOUDpKCwjq+Pj/swER5zNs3YO+Jn9DvLtq6dTnSCL72eYFpF+QuRm25VxyR+EihSZffCG7NTnsY7GOCsXmSSP5J2SmZZpi9XPezNTOFNEkhqoO/CGH27EH1hd44Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946722; c=relaxed/simple;
	bh=P8hOLVgYT1vTGjAMVzP7tq0tW/ZQ6FtA2oL3DCXMkYU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thdAO5nLz8i4oEGThUUNplNcTXSJ8qg4xLuLKbpDVnjhE6z7mKQHfyo3aEXhcNceePnmIEfCAKMWnkJszYSoUQ3s32MDxuYLMifkwZjlztsnynUBNW64BUANbf/wnwFC3ZUIH2rYOk3jUXAOeIKLJ4GWf7mGf0cu5fUtGh3mh4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCXrtZkV; arc=none smtp.client-ip=74.125.229.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCXrtZkV"
Received: by mail-dy2-f34.google.com with SMTP id 5a478bee46e88-33be7dfcfc1so9675687eec.1
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946714; x=1791551514; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cZDlD94Xz5zPBusV8gdvsq8MTzc1vvAp1arKCQ1xjc0=;
        b=RCXrtZkVnkKDngei/EnU0Cn/w9+6BLbiDE2hA9ORQ0pGJOyAF27brHMdtZdeuvMec4
         2J4+l7qJU2LFODrBUyPDR/pp2k9ifBUDCr7U4BEVXjvjjGemETqZp+X6kbNnjJ2M/eXd
         wvGESJIa4+G8ckO/9qrPg8Mj2FSyF6iE6KzQuRgG+Lz+xNr9CL0Lf6wayVD+lhI9vYEn
         P4fdU/owzaqGsQeyNYRp2X8eh5f4ejPZz9O6zUxg2UVI/SRHx5B/OxRFKyzq2eUCLSnk
         EsjSTflQADOTpcPpunCAO7QSCR/ZLZAYjkZRbQmy3SNTVSn1WLEdxN122TGjmaPC3DiE
         O82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946714; x=1791551514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cZDlD94Xz5zPBusV8gdvsq8MTzc1vvAp1arKCQ1xjc0=;
        b=2HDCPXxjYnJeUA9lE5eS7OZYOq9GUPerb3xrj+2g3T0V/5pfNYwdFgE3/Ie9qBRODS
         mMK7o6a70DX9qW4iwBnUeLxkEWTZVZsSlZoneJo38mnCOC9vPp4zVC5Q7i5hPbT5x5O1
         o/NS7N2hsCPoTO9gunQiGmT8NYOELkvfu0s5t55kY7Wt9onOlXzIqXJKSk0bBh0rWp5D
         QGW4/ybOJWN1A6qO9W0YgK9uhH0L0NjRS+HRTFAqw6vZV1kEDpVBW1sgMRNQNOqKyuGc
         OGQE/J8qqSX7PIDIqknRDqtgf5kmW35C0ULQgBfpIBvMlEGbk6+azAT6DamF0NbUFLET
         tEoA==
X-Forwarded-Encrypted: i=1; AKwUvBxL5aJQTELtUAkaN0DBCIm0TGcmpj8jqxmAJXlyd8rQFxC4gCDi6BKuFXr8ZOf36oOM7cGy9Gz9@vger.kernel.org
X-Gm-Message-State: AFq9FYLwwNyxDwb4I4f+EW6yNi3riQ2pNfHSnuSp/d6urIQ7Oz7MSOHq
	/QtWchBDYB+Lebf+rhKuCpo5wmhfownCQyjJV+GXkme62K/ATrGnqg1z
X-Gm-Gg: AYBFou0u6kHlQDCW9rJDvfWIXZJr7TPcfl4rxIByM+jQwtiT+HEOfUUnYUYf7rxuUzc
	nVf3Q2S8IFQpzPOfE1flGKbufbKBsJsWFC2vUgCF6mUCc0pyDdQgXFFfde7g4XDARXvqAzUkVK5
	yDu7yZGFjNr9Y6WZpAM2lSRqS2s113pNrfI5VdNGfSVdXiQhD0tAr9XiUTmP9E6vrqavhfxHfTs
	+PhUR7nX4NhxHeD04hFNy1Xm01gv/LVFjYnyP1h5xWXVxQ/y+Fmbfj5rIeZDGBc+WDI2gk+Klyh
	LlDvfbGfvQINBFuMXdxOyebs3+siIcmIRTOOJKsHhIP1Acfr+5g7a0yTI+/69EMnqzQMZ5ApmiC
	yknspcaW12vQgXK1l3xmA2m5jlJfwDLY4pMIzLLfDclgfgSy+Vc2kFvP0HzOSuz2sVs8oBe0cuy
	Q3nMN6K2MtaPYON4jImxLybtzK/rCJtuUhCBGkEqKCvH/F5H7/G34h/XbMN+4e03QJZQ==
X-Received: by 2002:a05:693c:69c3:b0:344:c0fe:19ee with SMTP id 5a478bee46e88-34f150cecbamr2650709eec.14.1790946713953;
        Fri, 02 Oct 2026 06:11:53 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:11:53 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:30 +0800
Subject: [PATCH v5 10/12] cpuset: Drive kernel-noise isolation via per-CPU
 hotplug cycling
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-10-78a6996d87ad@gmail.com>
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

Track A (cpuset_update_sd_hk_unlock) updates the HK_TYPE_KERNEL_NOISE
and HK_TYPE_MANAGED_IRQ cpumasks but performs no per-CPU reconfiguration.
Tick suppression, RCU callback offloading and managed-IRQ remapping only
take effect when the affected CPUs pass through the CPU hotplug machinery.

Implement dhm_cycle_isolated_cpus() and call it from
cpuset_update_sd_hk_unlock() with cpuset_top_mutex still held: per the
locking convention at the top of this file, cpuset_top_mutex is the
outermost lock, so remove_cpu()/add_cpu() may freely acquire
cpus_write_lock() underneath it.  Keeping the mutex held across the
whole cycle also matches dhm_prev_isolated's existing "protected by
cpuset_top_mutex" comment and prevents a second isolated-partition
update from entering cpuset_update_sd_hk_unlock() while a cycle for
the previous one is still in flight.

On isolation, for each newly-isolated CPU:
  1. remove_cpu()              - offline; dying callbacks migrate IRQs
  2. housekeeping_update_types() - publish this CPU as kernel-noise
                                 isolated now that it is actually offline
  3. tick_nohz_cpu_isolate()  - enable context tracking so the tick
                                 is suppressed for this CPU (B0/B3)
  4. rcu_nocb_cpu_isolate()   - lazy nocb init, spawn kthreads, offload
                                 callbacks (B1)
  5. add_cpu()                 - online; tick and IRQ online callbacks
                                 reconfigure against the now-published
                                 HK masks

On de-isolation, the reverse order is applied, publishing the CPU as
no longer kernel-noise isolated right after its own remove_cpu()
succeeds instead of before any CPU in the batch is touched.

The managed-IRQ remapping requires no explicit call:
irq_migrate_all_off_this_cpu() (dying callback) and
irq_affinity_online_cpu() (online callback) already consult the
updated HK_TYPE_MANAGED_IRQ mask.

dhm_prev_isolated tracks the previous isolation set so that only CPUs
whose state changed are cycled rather than the full isolation set.
lockup_detector_hk_update() (B2) is called once after all CPUs are
cycled to update the watchdog mask.

Some CPUs cannot be taken offline: cpu_is_hotpluggable() rejects a
CPU with hotplug disabled in the architecture (e.g. the x86-64 boot
CPU), and remove_cpu() itself can still fail for a CPU that passed
that filter (e.g. it turns out to be the last CPU in its sched
domain, or it is the current tick_do_timer_cpu holder and
tick_nohz_cpu_hotpluggable() rejects it).  Publishing
housekeeping_update_types() per CPU, strictly after that CPU's own
remove_cpu() has already succeeded, makes both cases handle
themselves: a CPU this function ends up skipping is simply never
added to the published mask, so HK_TYPE_KERNEL_NOISE never claims a
CPU is isolated while it keeps ticking and running RCU callbacks
normally, without needing a separate pre-filter pass or a
republish-on-failure step afterwards.  Also free
newly_isolated/newly_deisolated/cur_isolated on the early return for
a no-op update, which previously leaked the allocations.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 kernel/cgroup/cpuset.c | 155 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 140 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6213e63cf348d..9fa4bf504c3d9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -20,6 +20,8 @@
  */
 #include "cpuset-internal.h"
 
+#include <linux/cpu.h>
+#include <linux/cpuhplock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -33,7 +35,9 @@
 #include <linux/sched/task.h>
 #include <linux/security.h>
 #include <linux/oom.h>
+#include <linux/nmi.h>
 #include <linux/sched/isolation.h>
+#include <linux/tick.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/task_work.h>
@@ -165,6 +169,14 @@ static cpumask_var_t	isolated_hk_cpus;	/* T */
 static DEFINE_SPINLOCK(dhm_cycling_lock);
 static cpumask_var_t	dhm_cycling_cpus;
 
+/*
+ * Snapshot of the isolated CPUs from the previous housekeeping update.
+ * Used to compute the delta (newly isolated / newly de-isolated) so that
+ * only the changed CPUs are cycled rather than the full isolation set.
+ * Protected by cpuset_top_mutex.
+ */
+static cpumask_var_t	dhm_prev_isolated;
+
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -1423,6 +1435,108 @@ static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
 	return false;
 }
 
+/*
+ * dhm_cycle_isolated_cpus - Apply kernel-noise isolation via hotplug cycling
+ *
+ * For each CPU newly entering isolation: cycle it offline, configure tick
+ * suppression and RCU callback offloading while it is offline, then bring
+ * it back online.  The managed-IRQ state is handled automatically by the
+ * existing irq_migrate_all_off_this_cpu() dying callback and the
+ * irq_affinity_online_cpu() online callback which both consult the
+ * already-updated HK_TYPE_MANAGED_IRQ mask.
+ *
+ * For each CPU leaving isolation: cycle it offline, de-offload RCU and
+ * restore the tick, then bring it back online.
+ *
+ * Called with cpuset_top_mutex held and no other cpuset or hotplug locks
+ * held: cpuset_top_mutex is the outermost lock, so remove_cpu()/add_cpu()
+ * may freely take cpus_write_lock() underneath it.
+ */
+static void dhm_cycle_isolated_cpus(const struct cpumask *new_isolated)
+{
+	static const unsigned long noise_types =
+		BIT(HK_TYPE_KERNEL_NOISE) | BIT(HK_TYPE_MANAGED_IRQ);
+	cpumask_var_t newly_isolated, newly_deisolated, cur_isolated;
+	int cpu;
+
+	if (!alloc_cpumask_var(&newly_isolated, GFP_KERNEL) ||
+	    !alloc_cpumask_var(&newly_deisolated, GFP_KERNEL) ||
+	    !alloc_cpumask_var(&cur_isolated, GFP_KERNEL)) {
+		free_cpumask_var(newly_isolated);
+		free_cpumask_var(newly_deisolated);
+		return;
+	}
+
+	cpumask_andnot(newly_isolated, new_isolated, dhm_prev_isolated);
+	cpumask_andnot(newly_deisolated, dhm_prev_isolated, new_isolated);
+	/* cur_isolated tracks the mask actually published so far. */
+	cpumask_copy(cur_isolated, dhm_prev_isolated);
+	cpumask_copy(dhm_prev_isolated, new_isolated);
+
+	if (cpumask_empty(newly_isolated) && cpumask_empty(newly_deisolated))
+		goto out_free;
+
+	/* Mark cycling CPUs so cpuset_hotplug_update_tasks skips invalidation */
+	spin_lock(&dhm_cycling_lock);
+	cpumask_or(dhm_cycling_cpus, newly_isolated, newly_deisolated);
+	spin_unlock(&dhm_cycling_lock);
+
+	/*
+	 * Publish each CPU's kernel-noise/managed-IRQ housekeeping state
+	 * strictly between its own remove_cpu() succeeding and add_cpu()
+	 * bringing it back, never as a batch before the whole cycle.
+	 * housekeeping_update_types() then always describes exactly which
+	 * CPUs are actually ticking and running RCU callbacks normally at
+	 * that instant, including the current tick_do_timer_cpu holder,
+	 * which tick_nohz_cpu_hotpluggable() must see as still a
+	 * housekeeping CPU for as long as it is still online and un-cycled.
+	 */
+	for_each_cpu(cpu, newly_isolated) {
+		if (!cpu_is_hotpluggable(cpu)) {
+			pr_warn_once("cpuset: CPU%d cannot be isolated (hotplug disabled)\n",
+				     cpu);
+			cpumask_clear_cpu(cpu, dhm_prev_isolated);
+			continue;
+		}
+		if (remove_cpu(cpu)) {
+			pr_warn_once("cpuset: failed to offline CPU%d for isolation\n",
+				     cpu);
+			cpumask_clear_cpu(cpu, dhm_prev_isolated);
+			continue;
+		}
+		cpumask_set_cpu(cpu, cur_isolated);
+		WARN_ON_ONCE(housekeeping_update_types(noise_types, cur_isolated));
+		WARN_ON_ONCE(tick_nohz_cpu_isolate(cpu));
+		WARN_ON_ONCE(rcu_nocb_cpu_isolate(cpu));
+		WARN_ON_ONCE(add_cpu(cpu));
+	}
+
+	for_each_cpu(cpu, newly_deisolated) {
+		if (remove_cpu(cpu)) {
+			pr_warn_once("cpuset: failed to offline CPU%d for de-isolation\n",
+				     cpu);
+			cpumask_set_cpu(cpu, dhm_prev_isolated);
+			continue;
+		}
+		cpumask_clear_cpu(cpu, cur_isolated);
+		WARN_ON_ONCE(housekeeping_update_types(noise_types, cur_isolated));
+		WARN_ON_ONCE(rcu_nocb_cpu_deoffload(cpu));
+		tick_nohz_cpu_deisolate(cpu);
+		WARN_ON_ONCE(add_cpu(cpu));
+	}
+
+	spin_lock(&dhm_cycling_lock);
+	cpumask_clear(dhm_cycling_cpus);
+	spin_unlock(&dhm_cycling_lock);
+
+	lockup_detector_hk_update();
+
+out_free:
+	free_cpumask_var(newly_isolated);
+	free_cpumask_var(newly_deisolated);
+	free_cpumask_var(cur_isolated);
+}
+
 /*
  * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
  *
@@ -1439,8 +1553,6 @@ static void cpuset_update_sd_hk_unlock(void)
 		rebuild_sched_domains_locked();
 
 	if (update_housekeeping) {
-		static const unsigned long noise_types =
-			BIT(HK_TYPE_KERNEL_NOISE) | BIT(HK_TYPE_MANAGED_IRQ);
 		int ret;
 
 		update_housekeeping = false;
@@ -1450,9 +1562,16 @@ static void cpuset_update_sd_hk_unlock(void)
 		cpus_read_unlock();
 
 		/*
-		 * housekeeping_update() is now called without holding
-		 * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
-		 * is still being held for mutual exclusion.
+		 * housekeeping_update() and housekeeping_update_types() are
+		 * now called without holding cpus_read_lock and cpuset_mutex.
+		 * cpuset_top_mutex stays held all the way through
+		 * dhm_cycle_isolated_cpus() below: per the locking convention
+		 * at the top of this file it is the outermost lock, so it may
+		 * legally nest around the cpus_write_lock() that remove_cpu()/
+		 * add_cpu() take. Holding it here is also what makes
+		 * dhm_prev_isolated's "protected by cpuset_top_mutex" comment
+		 * true, and keeps a second isolated-partition update from
+		 * entering this function while a cycle is still in flight.
 		 */
 
 		/*
@@ -1464,18 +1583,23 @@ static void cpuset_update_sd_hk_unlock(void)
 		WARN_ON_ONCE(ret);
 
 		/*
-		 * Only touch the kernel-noise housekeeping masks
-		 * (HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ) once the
-		 * sched domain update above actually succeeded: HK_TYPE_
-		 * KERNEL_NOISE must stay a subset of HK_TYPE_DOMAIN, so a CPU
-		 * can never end up tick-suppressed while still scheduled as
-		 * part of the normal (non-isolated) sched domain.  The tick,
-		 * RCU and managed-interrupt state is reconfigured as the
-		 * affected CPUs are cycled through the CPU hotplug machinery.
+		 * Only cycle CPUs through hotplug, applying the kernel-noise
+		 * types along the way, when the sched domain update above
+		 * actually succeeded.  HK_TYPE_KERNEL_NOISE must stay a
+		 * subset of HK_TYPE_DOMAIN, so a CPU can never end up
+		 * tick-suppressed while still scheduled as part of the
+		 * normal (non-isolated) sched domain.  The tick, RCU and
+		 * managed-interrupt state is reconfigured as the affected
+		 * CPUs are cycled through the CPU hotplug machinery;
+		 * dhm_cycle_isolated_cpus() publishes HK_TYPE_KERNEL_NOISE
+		 * and HK_TYPE_MANAGED_IRQ itself, one CPU at a time, strictly
+		 * between that CPU's own remove_cpu() and add_cpu(), so a
+		 * CPU that cpu_is_hotpluggable() rejects (e.g. the current
+		 * tick_do_timer_cpu) is simply never published as isolated.
 		 */
 		if (!ret)
-			WARN_ON_ONCE(housekeeping_update_types(noise_types,
-							       isolated_hk_cpus));
+			dhm_cycle_isolated_cpus(isolated_hk_cpus);
+
 		mutex_unlock(&cpuset_top_mutex);
 	} else {
 		cpuset_full_unlock();
@@ -3915,6 +4039,7 @@ int __init cpuset_init(void)
 	BUG_ON(!zalloc_cpumask_var(&isolated_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&isolated_hk_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&dhm_cycling_cpus, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&dhm_prev_isolated, GFP_KERNEL));
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);

-- 
2.43.0

