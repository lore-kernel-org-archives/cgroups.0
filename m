From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 4/6] sched/isolation: Split domain housekeeping mask from the rest
Date: Wed, 14 Jul 2021 15:54:18 +0200
Message-ID: <20210714135420.69624-5-frederic@kernel.org>
References: <20210714135420.69624-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626270880;
        bh=CR7ZCJ2MCtQ/AkMPzJGPaJM3pFUk31mYc16dvoRJiAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WD0/+ICSzE5NIOrIG3LjIIgCE6LrPX3Fzkl+8nVpGdsy8KGxMbSqk7zL5T8AvuG5v
         Gdik/IpLItXSl1IyH0qvJ1JtBN7Vf4oI+0Xt5zrwFxx3Ktfy0nw2eI5k1gdoOSVA3J
         c/tvNoJm71k9ceSW7w99H61ZTwdxlIVbMoZy+y+bBuR/QsZuzdoYdYQvTWFcbSaLdZ
         xtBVPCPEZ9aLov/9JBi+OR3wcOxnM8O8kfB6Bl8T8+1wsAjqtddX2ClyRkoyhacGLR
         05zedSjxA8DzhJCtcSA3PoFHp/mBymQElOOW33n6BfkvBY3o+6PKUFTIgis1sEVX7n
         fxEBm7Z2IvCAg==
In-Reply-To: <20210714135420.69624-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

To prepare for supporting each feature of the housekeeping cpumask
toward cpuset, move HK_FLAG_DOMAIN to its own cpumask. This will allow
to modify the set passed through "isolcpus=" kernel boot parameter on
runtime.

Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
---
 kernel/sched/isolation.c | 54 +++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 7f06eaf12818..c2bdf7e6dc39 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -12,6 +12,7 @@
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 static cpumask_var_t housekeeping_mask;
+static cpumask_var_t hk_domain_mask;
 static unsigned int housekeeping_flags;
 
 bool housekeeping_enabled(enum hk_flags flags)
@@ -26,7 +27,7 @@ int housekeeping_any_cpu(enum hk_flags flags)
 
 	if (static_branch_unlikely(&housekeeping_overridden)) {
 		if (housekeeping_flags & flags) {
-			cpu = sched_numa_find_closest(housekeeping_mask, smp_processor_id());
+			cpu = sched_numa_find_closest(housekeeping_cpumask(flags), smp_processor_id());
 			if (cpu < nr_cpu_ids)
 				return cpu;
 
@@ -39,9 +40,13 @@ EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
 
 const struct cpumask *housekeeping_cpumask(enum hk_flags flags)
 {
-	if (static_branch_unlikely(&housekeeping_overridden))
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		WARN_ON_ONCE((flags & HK_FLAG_DOMAIN) && (flags & ~HK_FLAG_DOMAIN));
+		if (housekeeping_flags & HK_FLAG_DOMAIN)
+			return hk_domain_mask;
 		if (housekeeping_flags & flags)
 			return housekeeping_mask;
+	}
 	return cpu_possible_mask;
 }
 EXPORT_SYMBOL_GPL(housekeeping_cpumask);
@@ -50,7 +55,7 @@ void housekeeping_affine(struct task_struct *t, enum hk_flags flags)
 {
 	if (static_branch_unlikely(&housekeeping_overridden))
 		if (housekeeping_flags & flags)
-			set_cpus_allowed_ptr(t, housekeeping_mask);
+			set_cpus_allowed_ptr(t, housekeeping_cpumask(flags));
 }
 EXPORT_SYMBOL_GPL(housekeeping_affine);
 
@@ -58,11 +63,13 @@ bool housekeeping_test_cpu(int cpu, enum hk_flags flags)
 {
 	if (static_branch_unlikely(&housekeeping_overridden))
 		if (housekeeping_flags & flags)
-			return cpumask_test_cpu(cpu, housekeeping_mask);
+			return cpumask_test_cpu(cpu, housekeeping_cpumask(flags));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+
+
 void __init housekeeping_init(void)
 {
 	if (!housekeeping_flags)
@@ -91,28 +98,57 @@ static int __init housekeeping_setup(char *str, enum hk_flags flags)
 
 	alloc_bootmem_cpumask_var(&tmp);
 	if (!housekeeping_flags) {
-		alloc_bootmem_cpumask_var(&housekeeping_mask);
-		cpumask_andnot(housekeeping_mask,
-			       cpu_possible_mask, non_housekeeping_mask);
+		if (flags & ~HK_FLAG_DOMAIN) {
+			alloc_bootmem_cpumask_var(&housekeeping_mask);
+			cpumask_andnot(housekeeping_mask,
+				       cpu_possible_mask, non_housekeeping_mask);
+		}
+
+		if (flags & HK_FLAG_DOMAIN) {
+			alloc_bootmem_cpumask_var(&hk_domain_mask);
+			cpumask_andnot(hk_domain_mask,
+				       cpu_possible_mask, non_housekeeping_mask);
+		}
 
 		cpumask_andnot(tmp, cpu_present_mask, non_housekeeping_mask);
 		if (cpumask_empty(tmp)) {
 			pr_warn("Housekeeping: must include one present CPU, "
 				"using boot CPU:%d\n", smp_processor_id());
-			__cpumask_set_cpu(smp_processor_id(), housekeeping_mask);
+			if (flags & ~HK_FLAG_DOMAIN)
+				__cpumask_set_cpu(smp_processor_id(), housekeeping_mask);
+			if (flags & HK_FLAG_DOMAIN)
+				__cpumask_set_cpu(smp_processor_id(), hk_domain_mask);
 			__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
 		}
 	} else {
+		struct cpumask *prev;
+
 		cpumask_andnot(tmp, cpu_present_mask, non_housekeeping_mask);
 		if (cpumask_empty(tmp))
 			__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
 		cpumask_andnot(tmp, cpu_possible_mask, non_housekeeping_mask);
-		if (!cpumask_equal(tmp, housekeeping_mask)) {
+
+		if (housekeeping_flags == HK_FLAG_DOMAIN)
+			prev = hk_domain_mask;
+		else
+			prev = housekeeping_mask;
+
+		if (!cpumask_equal(tmp, prev)) {
 			pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
 			free_bootmem_cpumask_var(tmp);
 			free_bootmem_cpumask_var(non_housekeeping_mask);
 			return 0;
 		}
+
+		if ((housekeeping_flags & HK_FLAG_DOMAIN) && (flags & ~HK_FLAG_DOMAIN)) {
+			alloc_bootmem_cpumask_var(&housekeeping_mask);
+			cpumask_copy(housekeeping_mask, hk_domain_mask);
+		}
+
+		if ((housekeeping_flags & ~HK_FLAG_DOMAIN) && (flags & HK_FLAG_DOMAIN)) {
+			alloc_bootmem_cpumask_var(&hk_domain_mask);
+			cpumask_copy(hk_domain_mask, housekeeping_mask);
+		}
 	}
 	free_bootmem_cpumask_var(tmp);
 
-- 
2.25.1

