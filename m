From: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: Remove the redundant updating of stats_flush_threshold
Date: Sat, 23 Jul 2022 00:49:49 +0800
Message-ID: <20220722164949.47760-1-jiebin.sun@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658478713; x=1690014713;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uv07SzM5PWTt1IVQuWHDCVeHL3I17tUX88W1yhEAfGk=;
  b=Lhy5jvwu90NJ7gdKMPIIfYuQ85pf9L39j38JfJ3JErfSNcOXmb5hutTT
   ZUUXR/+FXrE8uq3+o6eHJCfyl3Y4EC3FWPBZ/r+DWhvGl3yd6wHnCDNQ/
   YfzEymxIDMdCdhXWsN+FF64aBA6rSZXwYn5Ew3qRR0UdOovdXJlrCtTuZ
   23khOisxGersi0DSJGITTa8SN1kiSu4uAezyUK+VZHbMdD1Odtrbz6Lqw
   zW+kwVlNGJG5otnCVdBrbQEpIUhlfXwKtEWpPm9D8a2Tu9jomss6dQXfn
   tLerFdbPPPgilSCUj6Y/25fg5ydRW7wS0WIfP+Ci/qfLosdsMYeD8z/5b
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, amadeuszx.slawinski-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tianyou.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wangyang.guo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jiebin sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: jiebin sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove the redundant updating of stats_flush_threshold. If the
global var stats_flush_threshold has exceeded the trigger value
for __mem_cgroup_flush_stats, further increment is unnecessary.

Apply the patch and test the pts/hackbench-1.0.0 Count:4 (160 threads).

Score gain: 1.95x
Reduce CPU cycles in __mod_memcg_lruvec_state (44.88% -> 0.12%)

CPU: ICX 8380 x 2 sockets
Core number: 40 x 2 physical cores
Benchmark: pts/hackbench-1.0.0 Count:4 (160 threads)

Signed-off-by: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abec50f31fe6..9e8c6f24c694 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -626,7 +626,14 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
 	if (x > MEMCG_CHARGE_BATCH) {
-		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		/*
+		 * If stats_flush_threshold exceeds the threshold
+		 * (>num_online_cpus()), cgroup stats update will be triggered
+		 * in __mem_cgroup_flush_stats(). Increasing this var further
+		 * is redundant and simply adds overhead in atomic update.
+		 */
+		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
+			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
 		__this_cpu_write(stats_updates, 0);
 	}
 }
-- 
2.31.1

