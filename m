From: "Pratik R. Sampat" <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [RFC 5/5] proc/cpuns: Make procfs load stats CPU namespace aware
Date: Sat,  9 Oct 2021 20:42:43 +0530
Message-ID: <20211009151243.8825-6-psampat@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OsjRPBuVAZJUiH/1Tx72owDpcys2APioOZ0ZDm+Jjuw=;
 b=I83NbEN3nMcRnBJCS8ba6wlY7yuDfgQBwW4Al5U8+uXQXosXBSh7xS0LpD3EQU4NKvTm
 7ybvsGnlKwUmntopz6lmhCEebpA7Xija9E3eUCf87fBHRNIpGdLzW46eOULCHQLlXfnq
 UB2fr/SP5vvD0aK/LtWUkolnK+SBxm6Qrg+HRqrWmKQaEMOQlURH+yLYsu3b9l6qMEMi
 KFASBCXwuJ59QlEePc6OQkQXxWe7kVYrbA+aEm2G/EeQfc9qOtBmOTXHoI0X4LUmcQk1
 sJcDApLmnBfrfkYsPttMr3tmzxd5Wlaj3Nru+2CFxpQMVonRQKhGelz3lO4vNeb7wGp9 4g== 
In-Reply-To: <20211009151243.8825-1-psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This commit adds support provide a virtualized view to the /proc/stat
load statistics. The load, idle, irq and the rest of the information of
a physical CPU is now displayed for its corresponding virtual CPU
counterpart.
The procfs file only populates the virtualized view for the CPUs based
on the restrictions from cgroupfs set upon it.

Signed-off-by: Pratik R. Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 fs/proc/stat.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 6561a06ef905..3ff39e7362bb 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -14,6 +14,7 @@
 #include <linux/irqnr.h>
 #include <linux/sched/cputime.h>
 #include <linux/tick.h>
+#include <linux/cpu_namespace.h>
 
 #ifndef arch_irq_stat_cpu
 #define arch_irq_stat_cpu(cpu) 0
@@ -107,13 +108,14 @@ static void show_all_irqs(struct seq_file *p)
 
 static int show_stat(struct seq_file *p, void *v)
 {
-	int i, j;
+	int i, j, pcpu;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 guest, guest_nice;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
 	struct timespec64 boottime;
+	cpumask_var_t cpu_mask;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
@@ -122,27 +124,39 @@ static int show_stat(struct seq_file *p, void *v)
 	/* shift boot timestamp according to the timens offset */
 	timens_sub_boottime(&boottime);
 
-	for_each_possible_cpu(i) {
+#ifdef CONFIG_CPU_NS
+	if (current->nsproxy->cpu_ns == &init_cpu_ns) {
+		cpumask_copy(cpu_mask, cpu_possible_mask);
+	} else {
+		cpumask_copy(cpu_mask,
+			     &current->nsproxy->cpu_ns->v_cpuset_cpus);
+	}
+#else
+	cpumask_copy(cpu_mask, cpu_possible_mask);
+#endif
+
+	for_each_cpu(i, cpu_mask) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;
 
-		kcpustat_cpu_fetch(&kcpustat, i);
+		pcpu = get_pcpu_cpuns(current->nsproxy->cpu_ns, i);
+		kcpustat_cpu_fetch(&kcpustat, pcpu);
 
 		user		+= cpustat[CPUTIME_USER];
 		nice		+= cpustat[CPUTIME_NICE];
 		system		+= cpustat[CPUTIME_SYSTEM];
-		idle		+= get_idle_time(&kcpustat, i);
-		iowait		+= get_iowait_time(&kcpustat, i);
+		idle		+= get_idle_time(&kcpustat, pcpu);
+		iowait		+= get_iowait_time(&kcpustat, pcpu);
 		irq		+= cpustat[CPUTIME_IRQ];
 		softirq		+= cpustat[CPUTIME_SOFTIRQ];
 		steal		+= cpustat[CPUTIME_STEAL];
 		guest		+= cpustat[CPUTIME_GUEST];
 		guest_nice	+= cpustat[CPUTIME_GUEST_NICE];
-		sum		+= kstat_cpu_irqs_sum(i);
-		sum		+= arch_irq_stat_cpu(i);
+		sum		+= kstat_cpu_irqs_sum(pcpu);
+		sum		+= arch_irq_stat_cpu(pcpu);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
-			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
+			unsigned int softirq_stat = kstat_softirqs_cpu(j, pcpu);
 
 			per_softirq_sums[j] += softirq_stat;
 			sum_softirq += softirq_stat;
@@ -162,18 +176,30 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_put_decimal_ull(p, " ", nsec_to_clock_t(guest_nice));
 	seq_putc(p, '\n');
 
-	for_each_online_cpu(i) {
+#ifdef CONFIG_CPU_NS
+	if (current->nsproxy->cpu_ns == &init_cpu_ns) {
+		cpumask_copy(cpu_mask, cpu_online_mask);
+	} else {
+		cpumask_copy(cpu_mask,
+			     &current->nsproxy->cpu_ns->v_cpuset_cpus);
+	}
+#else
+	cpumask_copy(cpu_mask, cpu_online_mask);
+#endif
+	for_each_cpu(i, cpu_mask) {
 		struct kernel_cpustat kcpustat;
 		u64 *cpustat = kcpustat.cpustat;
 
-		kcpustat_cpu_fetch(&kcpustat, i);
+		pcpu = get_pcpu_cpuns(current->nsproxy->cpu_ns, i);
+
+		kcpustat_cpu_fetch(&kcpustat, pcpu);
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
 		user		= cpustat[CPUTIME_USER];
 		nice		= cpustat[CPUTIME_NICE];
 		system		= cpustat[CPUTIME_SYSTEM];
-		idle		= get_idle_time(&kcpustat, i);
-		iowait		= get_iowait_time(&kcpustat, i);
+		idle		= get_idle_time(&kcpustat, pcpu);
+		iowait		= get_iowait_time(&kcpustat, pcpu);
 		irq		= cpustat[CPUTIME_IRQ];
 		softirq		= cpustat[CPUTIME_SOFTIRQ];
 		steal		= cpustat[CPUTIME_STEAL];
-- 
2.31.1

