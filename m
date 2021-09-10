From: Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] sched/core: Fix wrong burst unit in cgroup2 cpu.max write
Date: Fri, 10 Sep 2021 12:06:03 -0400
Message-ID: <20210910160603.606711-1-kailun.qin@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, changhuaixin-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In cpu_max_write(), as the eventual tg_set_cfs_bandwidth() operates on
the burst in nsec which is input from tg_get_cfs_burst() in usec, it
should be converted into nsec accordingly.

If not, this may cause a write into cgroup2 cpu.max to unexpectedly
change an already set cpu.max.burst.

This patch addresses the above issue.

Signed-off-by: Kailun Qin <kailun.qin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c4462c454ab9..fc9fcc56149f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10711,7 +10711,7 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 {
 	struct task_group *tg = css_tg(of_css(of));
 	u64 period = tg_get_cfs_period(tg);
-	u64 burst = tg_get_cfs_burst(tg);
+	u64 burst = (u64)tg_get_cfs_burst(tg) * NSEC_PER_USEC;
 	u64 quota;
 	int ret;
 
-- 
2.25.1

