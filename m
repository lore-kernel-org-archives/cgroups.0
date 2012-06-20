From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 2/2] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 20 Jun 2012 15:38:16 +0400
Message-ID: <1340192296-15939-3-git-send-email-glommer@parallels.com>
References: <1340192296-15939-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340192296-15939-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

The cpuacct cgroup already exposes user and system numbers in a per-cgroup
fashion. But they are a summation along the whole group, not a per-cpu figure.
Also, they are coarse-grained version of the stats usually shown at places
like /proc/stat.

I want to have enough cgroup data to emulate the /proc/stat interface. To
achieve that, I am creating a new file "stat_percpu" that displays the
fine-grained per-cpu data. The original data is left alone.

The format of this file is as follows:

1line header
cpux val1 val2 ... valn.

It is the same format used for the cpu part /proc/stat, except for the header,
that may allow us to add fields in the future if they prove themselves needed.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ce68f6..5c19754 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8155,6 +8155,39 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static inline void do_fill_seq(struct seq_file *m, struct cpuacct *ca,
+			       int cpu, int index)
+{
+	struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+	u64 val;
+
+	val = cputime64_to_clock_t(kcpustat->cpustat[index]);
+	seq_put_decimal_ull(m, ' ', val);
+}
+
+static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
+				     struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int cpu;
+
+	seq_printf(m, "user nice system irq softirq guest guest_nice\n");
+
+	for_each_online_cpu(cpu) {
+		seq_printf(m, "cpu%d", cpu);
+		do_fill_seq(m, ca, cpu, CPUTIME_USER);
+		do_fill_seq(m, ca, cpu, CPUTIME_NICE);
+		do_fill_seq(m, ca, cpu, CPUTIME_SYSTEM);
+		do_fill_seq(m, ca, cpu, CPUTIME_IRQ);
+		do_fill_seq(m, ca, cpu, CPUTIME_SOFTIRQ);
+		do_fill_seq(m, ca, cpu, CPUTIME_GUEST);
+		do_fill_seq(m, ca, cpu, CPUTIME_GUEST_NICE);
+		seq_putc(m, '\n');
+	}
+
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -8169,6 +8202,10 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{
+		.name = "stat_percpu",
+		.read_seq_string = cpuacct_stats_percpu_show,
+	},
 	{ }	/* terminate */
 };
 
-- 
1.7.10.2
