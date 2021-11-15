From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: [PATCH v3 2/4] cpuacct: convert BUG_ON() to WARN_ON_ONCE()
Date: Mon, 15 Nov 2021 19:46:05 +0300
Message-ID: <20211115164607.23784-2-arbn@yandex-team.com>
References: <20211115164607.23784-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636994682; bh=tKgob4UDDd5k1op7XILIrY6rAd3bCvER424NTeWbm4Q=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=t0fIktdpmSujm36dDAZrA6JrmNIqtt4UIS5RJhmDT0xCPsE8zwJn5eCt6Lue5LBRQ
         d/VnuoMc1+8QL42CErTA2SkL0wZNvRU5gHh3DWckPZyTNxCAlj1dQ1D8KEG8SrISYc
         RknrySiVPuc2bDmD2FBGosdgSq1z7o0/9B9mGSC8=
In-Reply-To: <20211115164607.23784-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Replace fatal BUG_ON() with more safe WARN_ON_ONCE() in cpuacct_cpuusage_read().

Signed-off-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/sched/cpuacct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 893eece65bfd..f347cf9e4634 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -106,7 +106,8 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
 	 * We allow index == CPUACCT_STAT_NSTATS here to read
 	 * the sum of usages.
 	 */
-	BUG_ON(index > CPUACCT_STAT_NSTATS);
+	if (WARN_ON_ONCE(index > CPUACCT_STAT_NSTATS))
+		return 0;
 
 #ifndef CONFIG_64BIT
 	/*
-- 
2.32.0

