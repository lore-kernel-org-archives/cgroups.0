From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: [PATCH v3 4/4] sched/cpuacct: Make user/system times in cpuacct.stat more precise
Date: Mon, 15 Nov 2021 19:46:07 +0300
Message-ID: <20211115164607.23784-4-arbn@yandex-team.com>
References: <20211115164607.23784-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994685; bh=3fDLTLlIcmJsu5OEDawaWPJKtf8DsF1HzRZKQpuRSpU=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=Bq7Ab0pYQmIc3qQFAdOqvEZ7MpKKu/jlcdf5dTSxxpve9DliKmw1g/PML8yJeWbji
         rPsqF+4rUqkSejfFeWIA7tQLL0iCvr4ek3ET5vl/qQ7d0XhSJcIaKlmXH6h1rJeCfa
         zJt7bS+ADbejpJnRsTDsv6tb97ZRkM6E/4I4R9rw=
In-Reply-To: <20211115164607.23784-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

cpuacct.stat shows user time based on raw random precision tick
based counters. Use cputime_addjust() to scale these values against the
total runtime accounted by the scheduler, like we already do
for user/system times in /proc/<pid>/stat.

Signed-off-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/sched/cpuacct.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9de7dd51beb0..3d06c5e4220d 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -261,25 +261,30 @@ static int cpuacct_all_seq_show(struct seq_file *m, void *V)
 static int cpuacct_stats_show(struct seq_file *sf, void *v)
 {
 	struct cpuacct *ca = css_ca(seq_css(sf));
-	s64 val[CPUACCT_STAT_NSTATS];
+	struct task_cputime cputime;
+	u64 val[CPUACCT_STAT_NSTATS];
 	int cpu;
 	int stat;
 
-	memset(val, 0, sizeof(val));
+	memset(&cputime, 0, sizeof(cputime));
 	for_each_possible_cpu(cpu) {
 		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SYSTEM];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_IRQ];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SOFTIRQ];
+		cputime.utime += cpustat[CPUTIME_USER];
+		cputime.utime += cpustat[CPUTIME_NICE];
+		cputime.stime += cpustat[CPUTIME_SYSTEM];
+		cputime.stime += cpustat[CPUTIME_IRQ];
+		cputime.stime += cpustat[CPUTIME_SOFTIRQ];
+
+		cputime.sum_exec_runtime += *per_cpu_ptr(ca->cpuusage, cpu);
 	}
 
+	cputime_adjust(&cputime, &seq_css(sf)->cgroup->prev_cputime,
+		&val[CPUACCT_STAT_USER], &val[CPUACCT_STAT_SYSTEM]);
+
 	for (stat = 0; stat < CPUACCT_STAT_NSTATS; stat++) {
-		seq_printf(sf, "%s %lld\n",
-			   cpuacct_stat_desc[stat],
-			   (long long)nsec_to_clock_t(val[stat]));
+		seq_printf(sf, "%s %llu\n", cpuacct_stat_desc[stat],
+			nsec_to_clock_t(val[stat]));
 	}
 
 	return 0;
-- 
2.32.0

