From: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Subject: [PATCH cgroup/for-5.8] cgroup: add cpu.stat file to root cgroup
Date: Tue, 26 May 2020 13:08:00 -0700
Message-ID: <20200526200800.3969430-1-boris@bur.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=LHN0JqCZjAhlY7hB0/Y3fto1Fs
        QcamBNWhl7bqCCYFQ=; b=Tf85u/C9df53lBvUWR+YDqK8pTkDrlYwLiHV44qbkS
        mnHeugttyrDec7o60NcUtnABRLdccSQKc7t59jSSHpVbVIAJrtb9dFc/tI/VCFik
        ZmenzZbrOUgnS/E5bPrTAnCfY2QUl2V5PbiPLZ6nLYZR3eKjZUKpp9FCkaJb30yO
        xHPJ/DJA2342C4+6ldrjdpka0rNkcWmswGMP/nbsL8819nj+hYgfqCBTdhVTldJq
        ZE556X5zBI1eSwczYvHj0naUQeMjaUmhbdB4D/ZL+psVh7Pz15JWuFIRB//rpR0r
        2AIZr2SY0irzoSvvg65uX40vdxoYuEbvGN3spSfXJEug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LHN0JqCZjAhlY7hB0
        /Y3fto1FsQcamBNWhl7bqCCYFQ=; b=wAS94y4Q5SKaY0h7NxjaHI5iBN210i57D
        RMFJcWHfxHh4bN4m9zPx+8tecS3ekBMEiCwemkO5TjYMCd7bknJVCfTtp2A6Wr6o
        TIAbO0h/HNHYhSlcdKB/c5NuXReBNeMfDL5B+uAz/G0R/84JOwTj4keSLoe7nT4n
        0QWEJS7F/+XmhW8SAZjxGkxgHr8TUORJZsw7QuJscdG8dSLaJAv1JoutVw9numCH
        WnY8Q6xN3xtlFgw3Dia2CU7YIiCCRAcZVfh5WoLmyyg0d3nExliI4pMUPGipDn5T
        eFk9/hflNNQBnrXsfAA1IWt+S/KtY7yCCB0VMBe1DR+aLxSumqazA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Currently, the root cgroup does not have a cpu.stat file. Add one which
is consistent with /proc/stat to capture global cpu statistics that
might not fall under cgroup accounting.

We haven't done this in the past because the data are already presented
in /proc/stat and we didn't want to add overhead from collecting root
cgroup stats when cgroups are configured, but no cgroups have been
created.

By keeping the data consistent with /proc/stat, I think we avoid the
first problem, while improving the usability of cgroups stats.
We avoid the second problem by computing the contents of cpu.stat from
existing data collected for /proc/stat anyway.

Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c |  1 -
 kernel/cgroup/rstat.c  | 60 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 557a9b9d2244..b8a75169c3e4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4881,7 +4881,6 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cpu.stat",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cpu_stat_show,
 	},
 #ifdef CONFIG_PSI
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 41ca996568df..b6397a186ce9 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -389,18 +389,62 @@ void __cgroup_account_cputime_field(struct cgroup *cgrp,
 	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
 }
 
+/*
+ * compute the cputime for the root cgroup by getting the per cpu data
+ * at a global level, then categorizing the fields in a manner consistent
+ * with how it is done by __cgroup_account_cputime_field for each bit of
+ * cpu time attributed to a cgroup.
+ */
+static void root_cgroup_cputime(struct task_cputime *cputime)
+{
+	int i;
+
+	cputime->stime = 0;
+	cputime->utime = 0;
+	cputime->sum_exec_runtime = 0;
+	for_each_possible_cpu(i) {
+		struct kernel_cpustat kcpustat;
+		u64 *cpustat = kcpustat.cpustat;
+		u64 user = 0;
+		u64 sys = 0;
+
+		kcpustat_cpu_fetch(&kcpustat, i);
+
+		user += cpustat[CPUTIME_USER];
+		user += cpustat[CPUTIME_NICE];
+		cputime->utime += user;
+
+		sys += cpustat[CPUTIME_SYSTEM];
+		sys += cpustat[CPUTIME_IRQ];
+		sys += cpustat[CPUTIME_SOFTIRQ];
+		cputime->stime += sys;
+
+		cputime->sum_exec_runtime += user;
+		cputime->sum_exec_runtime += sys;
+		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
+		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
+		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
+	}
+}
+
 void cgroup_base_stat_cputime_show(struct seq_file *seq)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 	u64 usage, utime, stime;
-
-	if (!cgroup_parent(cgrp))
-		return;
-
-	cgroup_rstat_flush_hold(cgrp);
-	usage = cgrp->bstat.cputime.sum_exec_runtime;
-	cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime, &utime, &stime);
-	cgroup_rstat_flush_release();
+	struct task_cputime cputime;
+
+	if (cgroup_parent(cgrp)) {
+		cgroup_rstat_flush_hold(cgrp);
+		usage = cgrp->bstat.cputime.sum_exec_runtime;
+		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
+			       &utime, &stime);
+		cgroup_rstat_flush_release();
+	} else {
+		root_cgroup_cputime(&cputime);
+		usage = cputime.sum_exec_runtime;
+		utime = cputime.utime;
+		stime = cputime.stime;
+	}
 
 	do_div(usage, NSEC_PER_USEC);
 	do_div(utime, NSEC_PER_USEC);
-- 
2.24.1

