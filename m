Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655AD49E5DC
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946654; cv=none; b=cmww9evQV83+hpxyBiNREva0PtsmqKOKB4fbnY0DOCnRzp9i+ZB/S+vk/Zs3HDT2xJcQivJNbbDEkKilEdCXVz5oNbH3LSJOoWBtumQpUmBctXprczpaovtdBv7CZ5su9UAD9Nx6iNYFl/JYKUDtNyCACKH4ZYYkcwhpFgJoBBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946654; c=relaxed/simple;
	bh=B/PGz6LNoxyMJXSvm2Y7rvBul0DR1BHjLOBRublbAmI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l2x/T+fC9z5l20KFJQS5lZYd2mHV5SUy0ndVotBSjpQltobVSDSG70rHNIQ0du3hENwteMfSPGYGWqWmGAuqgkZPMsHQl/s0gtB3m0EOEk+/GohrlIzv9WQyTD/S5YCK7IxArNbLRLkQa/QRtGYl4X1v0D1yjpFzcmO/eo1Y7dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VDUDtk3X; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VDUDtk3X"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e46a15703so7053760eec.0
        for <cgroups@vger.kernel.org>; Fri, 02 Oct 2026 06:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790946648; x=1791551448; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vc4iYyv6tWLj8r1nvSvlZLe5EJOT0uZgiQee0jN66cY=;
        b=VDUDtk3XMCb34cMkzkKzrnkcLzMa5AZ19+ANoPmYaB7ZCeG6TBswVs1VpcCqkRGGv8
         5P5uWksh7GLhLAUNdurPwu0xkMByCtbkL0qflLDAjbRGCceo+F4KYWz8Rt9l7UVVRXgE
         JQ5JqJ7Nyi+XMm1byzrmATEhO+gSz4E5CfyXWikWNmvctHj2Fba+GdMx5OTZ17hlUZJB
         K395sCYxXteotAzIEmC9qM/qFCK+YWf3G8EdA48NKGNvLTZl9FOmmRD/+9eF1mTtQyLg
         siOM75Om7CI5OqwfLW20SF7wDgFy2dhnjtOhH7Q3KcXXB5XGCoZZOiyl6OzSZCHXKGXx
         GQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790946648; x=1791551448;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vc4iYyv6tWLj8r1nvSvlZLe5EJOT0uZgiQee0jN66cY=;
        b=fje0AB4UK4IlfjqxirbHJ7VXUoY7Sgts/FR1cR2xjB1jj68rRS7dRuLd0w66n7BYyv
         EsHrobTAQH3+/BJIOVFTpKbKDKLP41t7FzPjegGwns95V1U9WfkOrHlI8OXSiCO8T9Ev
         N2o67G1XdaB4LJDKXcbsOXgYC6XzidtnMyHhmMfdConvhpZbE2LO1mgZZZtM800D432J
         fEd5tuWCNoEFFMHKMW3q0Huujesq/kmiDzXTiegGCvQk2ZK8ESmSyQ2alw0Mudr2Kv3q
         VeR95YQrCEZJUqOCjpSH3P8AdVNq9PjunMUKbgeZxuAaLIvAdgazUiLM4OELx0yXbBSN
         hCXQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHB0cBzj/ct2nHmc2SdcaH0qiorA2rKRJiSIjO6Ipb+PVyaByof9/5pQyEJxBlE4IoQQkB8eYt@vger.kernel.org
X-Gm-Message-State: AFuF++nYcnr1L8zk7JCPuvs9Q5Tv62ZR8Qc0rX21nQyYxvaPxLaSI1KP
	KBCYWUy8fYEKZXqEVgQ+ndS0OBmjAYdkrxIXqQKB6CCF3xeuuZzIsIXn
X-Gm-Gg: AYBFou2Z/Mhs+L7nqhyUEDHm32Ce6Xj09kHpO+MAcnhjRbijRKjkIbNuuU6lEOywtgm
	Qent6fUWxVRCIOb7MFXpY3PI/BCKHAK1zHIg/ryRKTP4zPOP6MrZpqsQ4kgqRx9dvrQ/yilsLCQ
	8/ZEsKTAkgLV5Bbh603vneJ3QReSwg3nNT9DgNpAL0jA2qaXxJg4hRJJO4emIhIdgysUtHqJIkV
	dW8Zmr67/WiCJ0b37iak4S/+AV8yxBvXyRGR1FxDgnsuPO8PUU+lSd7Phssfk5x1RskypmH7YKr
	hES3+R3dMKdF2/TEMA7aB0egoIXDrIu/CErQlFenunhct+Jqsi5NQkhORw2ruke6s/B4I0WvDef
	uwnLUDZwnshHXVy2mtDenlmQEAUNQGg+zivZuAssMgcrpda93UQzy2sJbkeU3ReJI8SU6eLavvb
	fJUT25Ows6Qa1JtSKLDdjix3mQq4RlOgOfwPBqE+nv0l5kIGuAAgMKuLXuSZR8CE07SA==
X-Received: by 2002:a05:693c:4094:b0:350:869:d106 with SMTP id 5a478bee46e88-350086a0117mr2867906eec.34.1790946647593;
        Fri, 02 Oct 2026 06:10:47 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f0672c739sm7309347eec.3.2026.10.02.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 06:10:47 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 02 Oct 2026 21:10:22 +0800
Subject: [PATCH v5 02/12] sched/isolation: Add runtime housekeeping mask
 updates with boot snapshots
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wujing-dhm-v5-2-78a6996d87ad@gmail.com>
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

The housekeeping cpumasks for kernel noise (HK_TYPE_KERNEL_NOISE) and
managed interrupts (HK_TYPE_MANAGED_IRQ) are computed once at boot from
the nohz_full= and isolcpus=managed_irq arguments.  Dynamic CPU
isolation driven by cpuset isolated partitions needs to update these
masks after boot.

Add housekeeping_update_types() to recompute one or more housekeeping
masks as (boot snapshot & ~isolated), publish them via RCU and free the
old masks after a grace period.

Introduce HK_TYPE_KERNEL_NOISE_BOOT and HK_TYPE_MANAGED_IRQ_BOOT to
record the immutable boot configuration.  Anchoring every update on the
boot snapshot keeps the runtime mask a subset of the boot set and lets
de-isolation restore the boot configuration exactly.

When neither nohz_full=/isolcpus=nohz nor isolcpus=managed_irq was
given at boot, no boot snapshot exists for the corresponding type, so
cpu_possible_mask is the implicit boot set and the type is enabled on
the first runtime call.  housekeeping_cpumask() already falls back to
cpu_possible_mask for a type with no flag bit set, so this needs no
special-casing in the trial-mask computation; it only needs the
type's housekeeping_enabled() check not to gate out the first call,
which the HK_TYPE_KERNEL_NOISE check already did but the
HK_TYPE_MANAGED_IRQ one did not, silently skipping managed-IRQ
isolation whenever no boot parameter was present.  HK_TYPE_KERNEL_NOISE
additionally calls sched_tick_offload_init() on first enable to
allocate the tick offload percpu data that would otherwise only be
allocated by housekeeping_init() when nohz_full= is present at boot.
Remove __init from sched_tick_offload_init() and guard it with a
tick_work_cpu check so it is safe to call at runtime.

housekeeping_init() may now reject nohz_full=/isolcpus=nohz and clear
HK_FLAG_KERNEL_NOISE for violating the isolcpus=domain subset
invariant.  Clear HK_FLAG_KERNEL_NOISE_BOOT in that same path: DHM's
runtime first-enable anchors on the boot snapshot whenever that flag
is set, and the rejected configuration must not become the anchor.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 include/linux/sched/isolation.h |  32 +++++-
 kernel/sched/core.c             |   4 +-
 kernel/sched/isolation.c        | 209 +++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h            |   2 +-
 4 files changed, 220 insertions(+), 27 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a24..70602a74c1410 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -14,10 +14,26 @@ enum hk_type {
 	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
 	 */
 	HK_TYPE_DOMAIN,
-	/* Inverse of boot-time isolcpus=managed_irq argument */
-	HK_TYPE_MANAGED_IRQ,
-	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
+
+	/*
+	 * Inverse of the boot-time nohz_full= or isolcpus=nohz arguments.
+	 * When neither is given, DHM still records cpu_possible_mask here so
+	 * that kernel-noise isolation can be enabled purely at runtime.
+	 */
+	HK_TYPE_KERNEL_NOISE_BOOT,
+	/*
+	 * A subset of HK_TYPE_KERNEL_NOISE_BOOT: it may exclude additional
+	 * CPUs isolated at runtime via cpuset isolated partitions.
+	 */
 	HK_TYPE_KERNEL_NOISE,
+
+	/* Inverse of the boot-time isolcpus=managed_irq argument */
+	HK_TYPE_MANAGED_IRQ_BOOT,
+	/*
+	 * A subset of HK_TYPE_MANAGED_IRQ_BOOT: it may exclude additional
+	 * CPUs isolated at runtime via cpuset isolated partitions.
+	 */
+	HK_TYPE_MANAGED_IRQ,
 	HK_TYPE_MAX,
 
 	/*
@@ -40,10 +56,13 @@ enum hk_type {
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 extern int housekeeping_any_cpu(enum hk_type type);
 extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
+extern const struct cpumask *housekeeping_cpumask_rcu(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
 extern int housekeeping_update(struct cpumask *isol_mask);
+extern int housekeeping_update_types(unsigned long type_mask,
+				     struct cpumask *isol_mask);
 extern void __init housekeeping_init(void);
 
 #else
@@ -58,6 +77,11 @@ static inline const struct cpumask *housekeeping_cpumask(enum hk_type type)
 	return cpu_possible_mask;
 }
 
+static inline const struct cpumask *housekeeping_cpumask_rcu(enum hk_type type)
+{
+	return cpu_possible_mask;
+}
+
 static inline bool housekeeping_enabled(enum hk_type type)
 {
 	return false;
@@ -72,6 +96,8 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 
 static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
+static inline int housekeeping_update_types(unsigned long type_mask,
+					    struct cpumask *isol_mask) { return 0; }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1fe40de6ebe3c..6c67874e639a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5960,8 +5960,10 @@ static void sched_tick_stop(int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-int __init sched_tick_offload_init(void)
+int sched_tick_offload_init(void)
 {
+	if (tick_work_cpu)
+		return 0;
 	tick_work_cpu = alloc_percpu(struct tick_work);
 	BUG_ON(!tick_work_cpu);
 	return 0;
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index c6a41095a9002..7725514ac290e 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -13,10 +13,12 @@
 #include "sched.h"
 
 enum hk_flags {
-	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
-	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
-	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
-	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
+	HK_FLAG_DOMAIN_BOOT	  = BIT(HK_TYPE_DOMAIN_BOOT),
+	HK_FLAG_DOMAIN		  = BIT(HK_TYPE_DOMAIN),
+	HK_FLAG_KERNEL_NOISE_BOOT = BIT(HK_TYPE_KERNEL_NOISE_BOOT),
+	HK_FLAG_KERNEL_NOISE	  = BIT(HK_TYPE_KERNEL_NOISE),
+	HK_FLAG_MANAGED_IRQ_BOOT  = BIT(HK_TYPE_MANAGED_IRQ_BOOT),
+	HK_FLAG_MANAGED_IRQ	  = BIT(HK_TYPE_MANAGED_IRQ),
 };
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -36,25 +38,40 @@ bool housekeeping_enabled(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+/*
+ * Types that can change at runtime via cpuset isolated partitions.
+ * Boot-only types (DOMAIN_BOOT) are always safe to read without lockdep.
+ */
+static bool housekeeping_type_can_change(enum hk_type type)
+{
+	switch (type) {
+	case HK_TYPE_DOMAIN:
+	case HK_TYPE_KERNEL_NOISE:
+	case HK_TYPE_MANAGED_IRQ:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static bool housekeeping_dereference_check(enum hk_type type)
 {
-	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
-		/* Cpuset isn't even writable yet? */
-		if (system_state <= SYSTEM_SCHEDULING)
-			return true;
+	if (!IS_ENABLED(CONFIG_LOCKDEP) || !housekeeping_type_can_change(type))
+		return true;
 
-		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
-		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
-			return true;
+	/* Cpuset isn't even writable yet? */
+	if (system_state <= SYSTEM_SCHEDULING)
+		return true;
 
-		/* Cpuset lock held, partitions not writable */
-		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
-			return true;
+	/* CPU hotplug write locked, so cpuset partition can't be overwritten */
+	if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
+		return true;
 
-		return false;
-	}
+	/* Cpuset lock held, partitions not writable */
+	if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
+		return true;
 
-	return true;
+	return false;
 }
 
 static inline struct cpumask *housekeeping_cpumask_dereference(enum hk_type type)
@@ -77,12 +94,26 @@ const struct cpumask *housekeeping_cpumask(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_cpumask);
 
+const struct cpumask *housekeeping_cpumask_rcu(enum hk_type type)
+{
+	const struct cpumask *mask = NULL;
+
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		if (READ_ONCE(housekeeping.flags) & BIT(type))
+			mask = rcu_dereference(housekeeping.cpumasks[type]);
+	}
+	if (!mask)
+		mask = cpu_possible_mask;
+	return mask;
+}
+EXPORT_SYMBOL_GPL(housekeeping_cpumask_rcu);
+
 int housekeeping_any_cpu(enum hk_type type)
 {
 	int cpu;
 
 	if (static_branch_unlikely(&housekeeping_overridden)) {
-		if (housekeeping.flags & BIT(type)) {
+		if (READ_ONCE(housekeeping.flags) & BIT(type)) {
 			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
 			if (cpu < nr_cpu_ids)
 				return cpu;
@@ -164,6 +195,132 @@ int housekeeping_update(struct cpumask *isol_mask)
 	return 0;
 }
 
+/**
+ * housekeeping_update_types - Update housekeeping masks for specified types
+ * @type_mask: Bitmask of housekeeping types to update
+ * @isol_mask: CPUs being added to the isolation set
+ *
+ * For each type in @type_mask, compute the trial mask as
+ * (boot snapshot & ~@isol_mask), validate it against @cpu_online_mask,
+ * then swap the RCU mask pointer and free the old mask after
+ * synchronize_rcu().  Anchoring on the immutable boot snapshot
+ * (HK_TYPE_*_BOOT) keeps the runtime mask a subset of the boot set and
+ * lets de-isolation restore the boot configuration exactly.
+ *
+ * The updated mask only takes effect for subsystems as CPUs cycle
+ * through hotplug; callers isolate CPUs via the CPU hotplug machinery so
+ * that tick, RCU and interrupt state is reconfigured by the existing
+ * online/offline callbacks rather than reconfigured in place.
+ *
+ * HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ also support runtime
+ * first-enable: when neither nohz_full=/isolcpus=nohz nor
+ * isolcpus=managed_irq was given at boot, no boot snapshot exists for
+ * the type, so cpu_possible_mask is the implicit boot set and the type
+ * flag is set in housekeeping.flags on the first call.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure, -EINVAL if
+ * a trial mask has no online CPUs.
+ */
+int housekeeping_update_types(unsigned long type_mask,
+			      struct cpumask *isol_mask)
+{
+	struct cpumask *trials[HK_TYPE_MAX] = {};
+	struct cpumask *old_masks[HK_TYPE_MAX] = {};
+	enum hk_type type;
+	int ret = 0;
+
+	for_each_set_bit(type, &type_mask, HK_TYPE_MAX) {
+		const struct cpumask *base;
+
+		if (type == HK_TYPE_DOMAIN_BOOT)
+			continue;
+		if (!housekeeping_enabled(type)) {
+			/*
+			 * HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ support
+			 * runtime first-enable for DHM isolated partitions
+			 * created without nohz_full=/isolcpus=managed_irq at
+			 * boot.  All other types must be boot-enabled.
+			 */
+			if (type != HK_TYPE_KERNEL_NOISE && type != HK_TYPE_MANAGED_IRQ)
+				continue;
+		}
+
+		/*
+		 * Compute the trial mask relative to the immutable boot
+		 * snapshot, never relative to the current (already shrunk)
+		 * mask.  Using the current mask would let it shrink
+		 * monotonically across isolation/de-isolation cycles and would
+		 * never recover CPUs once de-isolated.  Anchoring on the boot
+		 * snapshot keeps the runtime mask a subset of the boot set and
+		 * lets de-isolation restore exactly the boot configuration.
+		 *
+		 * HK_TYPE_KERNEL_NOISE additionally supports runtime
+		 * first-enable: when no nohz_full=/isolcpus=nohz was given at
+		 * boot, no boot snapshot exists, so cpu_possible_mask is the
+		 * implicit boot set.
+		 */
+		if (type == HK_TYPE_KERNEL_NOISE &&
+		    !(housekeeping.flags & HK_FLAG_KERNEL_NOISE_BOOT))
+			base = cpu_possible_mask;
+		else if (type == HK_TYPE_KERNEL_NOISE)
+			base = housekeeping_cpumask(HK_TYPE_KERNEL_NOISE_BOOT);
+		else if (type == HK_TYPE_MANAGED_IRQ)
+			base = housekeeping_cpumask(HK_TYPE_MANAGED_IRQ_BOOT);
+		else
+			base = housekeeping_cpumask(type);
+		trials[type] = kmalloc(cpumask_size(), GFP_KERNEL);
+		if (!trials[type]) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
+		cpumask_andnot(trials[type], base, isol_mask);
+		if (!cpumask_intersects(trials[type], cpu_online_mask)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
+	}
+
+	if (!housekeeping.flags) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	for_each_set_bit(type, &type_mask, HK_TYPE_MAX) {
+		if (!trials[type])
+			continue;
+		old_masks[type] = housekeeping_cpumask_dereference(type);
+		/* First-time runtime enable: register the type now. */
+		if (!housekeeping_enabled(type)) {
+			WRITE_ONCE(housekeeping.flags,
+				   housekeeping.flags | BIT(type));
+			/*
+			 * HK_TYPE_KERNEL_NOISE first-enable at runtime
+			 * (zero-boot-param path): tick offload percpu data
+			 * was never allocated at boot since nohz_full= was
+			 * absent.  Allocate it now before CPUs cycle through
+			 * hotplug and sched_tick_stop() dereferences
+			 * tick_work_cpu.
+			 */
+			if (type == HK_TYPE_KERNEL_NOISE)
+				WARN_ON_ONCE(sched_tick_offload_init());
+		}
+		rcu_assign_pointer(housekeeping.cpumasks[type], trials[type]);
+		trials[type] = NULL;
+	}
+
+	synchronize_rcu();
+
+	for_each_set_bit(type, &type_mask, HK_TYPE_MAX)
+		kfree(old_masks[type]);
+
+	return 0;
+
+err_free:
+	for_each_set_bit(type, &type_mask, HK_TYPE_MAX)
+		kfree(trials[type]);
+	return ret;
+}
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;
@@ -192,7 +349,15 @@ void __init housekeeping_init(void)
 			    housekeeping_cpumask(HK_TYPE_KERNEL_NOISE))) {
 		pr_warn("Housekeeping: nohz_full=/isolcpus=nohz must be a subset "
 			"of isolcpus=domain, disabling nohz_full\n");
-		housekeeping.flags &= ~HK_FLAG_KERNEL_NOISE;
+		/*
+		 * Clear HK_TYPE_KERNEL_NOISE_BOOT too, not just the live
+		 * type: DHM's housekeeping_update_types() anchors runtime
+		 * isolation on this boot snapshot when it is set, and the
+		 * rejected boot configuration must not become that anchor.
+		 * Clearing both leaves the system in the same state as if
+		 * nohz_full=/isolcpus=nohz had never been passed.
+		 */
+		housekeeping.flags &= ~(HK_FLAG_KERNEL_NOISE | HK_FLAG_KERNEL_NOISE_BOOT);
 		if (!housekeeping.flags)
 			return;
 	}
@@ -343,7 +508,7 @@ static int __init housekeeping_nohz_full_setup(char *str)
 {
 	unsigned long flags;
 
-	flags = HK_FLAG_KERNEL_NOISE;
+	flags = HK_FLAG_KERNEL_NOISE | HK_FLAG_KERNEL_NOISE_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
@@ -362,7 +527,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 		 */
 		if (!strncmp(str, "nohz,", 5)) {
 			str += 5;
-			flags |= HK_FLAG_KERNEL_NOISE;
+			flags |= HK_FLAG_KERNEL_NOISE | HK_FLAG_KERNEL_NOISE_BOOT;
 			continue;
 		}
 
@@ -374,7 +539,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "managed_irq,", 12)) {
 			str += 12;
-			flags |= HK_FLAG_MANAGED_IRQ;
+			flags |= HK_FLAG_MANAGED_IRQ | HK_FLAG_MANAGED_IRQ_BOOT;
 			continue;
 		}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e656c7059bf86..a640accf1d890 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3018,7 +3018,7 @@ extern void post_init_entity_util_avg(struct task_struct *p);
 
 #ifdef CONFIG_NO_HZ_FULL
 extern bool sched_can_stop_tick(struct rq *rq);
-extern int __init sched_tick_offload_init(void);
+extern int sched_tick_offload_init(void);
 
 /*
  * Tick may be needed by tasks in the runqueue depending on their policy and

-- 
2.43.0

