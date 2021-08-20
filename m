From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: [PATCH v2 2/5] cpuacct: convert BUG_ON() to WARN_ON_ONCE()
Date: Fri, 20 Aug 2021 12:40:02 +0300
Message-ID: <20210820094005.20596-2-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452405; bh=mk3pzEbe7hMn1PKFNH+h5kr4+QThbJ4FJbuURvEL6qs=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=g0VyrVHaOuAMmjd2ZJWhXG2vo65VTUvXvchTdCfP2AfxefsmvcYahKaaGiUfmKExi
         ZB+KhnnPoK4UUcnxXFVFSULaYzfNO59fiGR51VkiItQM9p2b83oVYzBYLRRPhscEHw
         yMvN4iH1D3EBfDV0Sx2Y98v9HCmkwxuL3kGvcVQE=
In-Reply-To: <20210820094005.20596-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, boris-UrQYPotlwNs@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>

Replace fatal BUG_ON() with more safe WARN_ON_ONCE() in cpuacct_cpuusage_read().

Signed-off-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
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
2.31.1

