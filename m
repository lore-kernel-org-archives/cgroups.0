From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: RFC: cgroups aware proc
Date: Sat, 04 Jan 2014 06:28:57 +0200
Message-ID: <52C78E09.60904@yuhu.biz>
References: <529350DB.3010906@yuhu.biz> <20131125150940.GB7120@sergelap>	<20131125151232.GR6766@redhat.com> <52937B0C.3070005@yuhu.biz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050509040909050904080107"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
	t=1388809735; bh=TLIO8V8xiE2kKT0V7l+6BUgnfmwqOE6fOuDwBnWH6BI=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=xovnou+NmhZ4ZkhzzHdymaHgJ2QBlk58fxyiTOd1pt6ZiE9yNDAVU7jz9NnzLundw
	 W8k5RypVjBdr/j0LUX+s1Z3gYc0dVJUhjfLeXlT7VoMHGHh30VwPCA8HPsBhnhtOPj
	 hNggewDouh1miNs019RF2CgqEzp1/54sKoDrXTnk=
In-Reply-To: <52937B0C.3070005-NV7Lj0SOnH0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------050509040909050904080107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Happy new year guys.

I need to have /proc cgroups aware, as I want to have LXC containers that see only the resources that are given to them.

In order to do that I had to patch the kernel. I decided to start with cpuinfo, stat and interrupts and then continue 
with meminfo and loadavg.

I managed to patch the Kernel (linux 3.12.0) and make /proc/cpuinfo, /proc/stat and /proc/interrupts be cgroups aware.

Attached are the patches that make the necessary changes.

The change for /proc/cpuinfo and /proc/interrupts is currently done only for x86 arch, but I will patch the rest of the 
architectures if the style of the patches is acceptable.

Tomorrow I will check if the patches apply and build with the latest kernel.

Best regards,
Marian



--------------050509040909050904080107
Content-Type: text/x-patch;
 name="0001-arch-x86-kernel-cpu-proc.c-Make-proc-cpuinfo-display.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-arch-x86-kernel-cpu-proc.c-Make-proc-cpuinfo-display.pa";
 filename*1="tch"

From 94891538f4a6a6b57aab0a2b917589ba73adfad9 Mon Sep 17 00:00:00 2001
From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Date: Sat, 4 Jan 2014 05:45:42 +0200
Subject: [PATCH 1/2] arch/x86/kernel/cpu/proc.c: Make /proc/cpuinfo display
 cpu information relative only to the current cgroup - added linux/cgroup.h
 include because it is needed for the cpumask_test_cpu() - addded a
 task_struct to c_start() - and added a loop that will skip all CPUs that are
 not part of the current cgroup by using the cpus_allowed mask from the
 task_struct

Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
---
 arch/x86/kernel/cpu/proc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index aee6317..d9e9fb6 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -3,6 +3,7 @@
 #include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/cpufreq.h>
+#include <linux/cgroup.h>
 
 /*
  *	Get CPU information for use by the procfs.
@@ -133,9 +134,19 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
+	struct task_struct *tsk;
 	*pos = cpumask_next(*pos - 1, cpu_online_mask);
-	if ((*pos) < nr_cpu_ids)
+	tsk = current_thread_info()->task;
+	if ((*pos) < nr_cpu_ids) {
+		if (tsk != NULL) {
+			while (cpumask_test_cpu((*pos), &tsk->cpus_allowed) == 0) {
+				(*pos)++;
+				if ((*pos) >= nr_cpu_ids)
+					return NULL;
+			}
+		}
 		return &cpu_data(*pos);
+	}
 	return NULL;
 }
 
-- 
1.8.4


--------------050509040909050904080107
Content-Type: text/x-patch;
 name="0001-arch-x86-kernel-irq.c-Made-proc-interrupts-to-be-cgr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-arch-x86-kernel-irq.c-Made-proc-interrupts-to-be-cgr.pa";
 filename*1="tch"

From ff68f073cb90316baa78936ff219a155788e29c2 Mon Sep 17 00:00:00 2001
From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Date: Sat, 4 Jan 2014 06:10:24 +0200
Subject: [PATCH 1/1] arch/x86/kernel/irq.c: Made /proc/interrupts to be
 cgroups aware - print only the CPUs that are part of the current cgroup -
 Added code to handle Kconfig options - Added code to skip all CPUs that are
 not part of the current cgroup using the task_struct's allowed_cpus mask

Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
---
 arch/x86/kernel/irq.c | 73 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 22d0687..b0a17c0 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -54,75 +54,120 @@ void ack_bad_irq(unsigned int irq)
 int arch_show_interrupts(struct seq_file *p, int prec)
 {
 	int j;
+#ifdef CONFIG_CPUSETS
+	struct task_struct *tsk;
+	tsk = current_thread_info()->task;
+#endif
 
 	seq_printf(p, "%*s: ", prec, "NMI");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
 	seq_printf(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
 	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
 
 	seq_printf(p, "%*s: ", prec, "SPU");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "IWI");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
 	seq_printf(p, "  IRQ work interrupts\n");
 	seq_printf(p, "%*s: ", prec, "RTR");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
 	seq_printf(p, "  APIC ICR read retries\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
+#ifdef CONFIG_CPUSETS
+			if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+				seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
 		seq_printf(p, "  Platform interrupts\n");
 	}
 #ifdef CONFIG_SMP
 	seq_printf(p, "%*s: ", prec, "RES");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
 	seq_printf(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
 					irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  TLB shootdowns\n");
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	seq_printf(p, "%*s: ", prec, "TRM");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
 	seq_printf(p, "  Thermal event interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
 	seq_printf(p, "  Threshold APIC interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE
 	seq_printf(p, "%*s: ", prec, "MCE");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
 	seq_printf(p, "  Machine check exceptions\n");
 	seq_printf(p, "%*s: ", prec, "MCP");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(j, &tsk->cpus_allowed))
+#endif
+			seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
-- 
1.8.4


--------------050509040909050904080107
Content-Type: text/x-patch;
 name="0001-fs-proc-stat.c-kernel-sched-stats.c-List-only-the-CP.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-fs-proc-stat.c-kernel-sched-stats.c-List-only-the-CP.pa";
 filename*1="tch"

From 00af9f7b5eeef770d0da240a6bf2064a2ba11e47 Mon Sep 17 00:00:00 2001
From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Date: Sat, 4 Jan 2014 06:03:11 +0200
Subject: [PATCH 1/1] fs/proc/stat.c & kernel/sched/stats.c: List only the CPUs
 that are in the current cpuset

- Added a check to allow the display of cpu information only if the cpu is part of the current cpu set using the task_struct allowed_cpus

Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
---
 fs/proc/stat.c       | 14 ++++++++++++++
 kernel/sched/stats.c |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 1cf86c0..e5ca3ef 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -87,6 +87,11 @@ static int show_stat(struct seq_file *p, void *v)
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec boottime;
+#ifdef CONFIG_CPUSETS
+	struct task_struct *tsk;
+
+	tsk = current_thread_info()->task;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
@@ -94,7 +99,12 @@ static int show_stat(struct seq_file *p, void *v)
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
+
 	for_each_possible_cpu(i) {
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(i, &tsk->cpus_allowed) == 0)
+			continue;
+#endif
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
 		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
 		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
@@ -142,6 +152,10 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(i, &tsk->cpus_allowed) == 0)
+			continue;
+#endif
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index da98af3..5897358 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -17,6 +17,10 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	int cpu;
 	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
 	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
+#ifdef CONFIG_CPUSETS
+	struct task_struct *tsk;
+	tsk = current_thread_info()->task;
+#endif
 
 	if (mask_str == NULL)
 		return -ENOMEM;
@@ -33,6 +37,11 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		cpu = (unsigned long)(v - 2);
 		rq = cpu_rq(cpu);
 
+#ifdef CONFIG_CPUSETS
+		if (tsk != NULL && cpumask_test_cpu(cpu, &tsk->cpus_allowed) == 0)
+			return 0;
+#endif
+
 		/* runqueue-specific stats */
 		seq_printf(seq,
 		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
-- 
1.8.4


--------------050509040909050904080107
Content-Type: text/x-patch;
 name="0002-arch-x86-kernel-cpu-proc.c-Added-Kconfig-option-hand.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-arch-x86-kernel-cpu-proc.c-Added-Kconfig-option-hand.pa";
 filename*1="tch"

From dec97e6141f92109c0cd02883cff20e3f1429564 Mon Sep 17 00:00:00 2001
From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Date: Sat, 4 Jan 2014 05:50:03 +0200
Subject: [PATCH 2/2] arch/x86/kernel/cpu/proc.c: Added Kconfig option handling

Signed-off-by: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
---
 arch/x86/kernel/cpu/proc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d9e9fb6..114fd95 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -3,7 +3,10 @@
 #include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/cpufreq.h>
+
+#ifdef CONFIG_CPUSETS
 #include <linux/cgroup.h>
+#endif
 
 /*
  *	Get CPU information for use by the procfs.
@@ -134,10 +137,13 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
+#ifdef CONFIG_CPUSETS
 	struct task_struct *tsk;
+#endif
 	*pos = cpumask_next(*pos - 1, cpu_online_mask);
-	tsk = current_thread_info()->task;
 	if ((*pos) < nr_cpu_ids) {
+#ifdef CONFIG_CPUSETS
+		tsk = current_thread_info()->task;
 		if (tsk != NULL) {
 			while (cpumask_test_cpu((*pos), &tsk->cpus_allowed) == 0) {
 				(*pos)++;
@@ -145,6 +151,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 					return NULL;
 			}
 		}
+#endif
 		return &cpu_data(*pos);
 	}
 	return NULL;
-- 
1.8.4


--------------050509040909050904080107--
