From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Tue, 18 May 2021 14:52:00 +0200
Message-ID: <20210518125202.78658-2-odin@uged.al>
References: <20210518125202.78658-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2m3StdkgN8j9sX0OOQRA/hs3X95klSzDGXdeM8HTJY=;
        b=vtTYi9jfJ+11Q8gjuzRabIbIUKKJyqDw2pUtj9GyYq0ftsy8WpejQqwF/PaksTkvyc
         E67MK7KCFtAD9K0Vzv1M8Bxsab4LMuvS1BFcFPicbl5vVl3wbbg36Rvy4C+mDBjmJWnU
         i1RHd6XsD+eheHVLbo1owEAmQdFFLNNmdDC/E3b4o9TVqEUdUGNmZBciHKjvhzGYXx2U
         AIsi+38lT8vu7gcHLdsPM8FJgXs+ZwIwAZFzksPlw5AudK7uFdgkTsCL23j3PHM4mR4r
         xVgDiSS6Vw4y+5jBPhFcNKOUwUSB3g6F23BHUHqi8eSvL4iStYz5xcleD5fjYA5zces/
         KggA==
In-Reply-To: <20210518125202.78658-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Make sure cfs_rq does not contribute to task group load avg when
checking if it is decayed. Due to how the pelt tracking works,
the divider can result in a situation where:

cfs_rq->avg.load_sum = 0
cfs_rq->avg.load_avg = 4
cfs_rq->avg.tg_load_avg_contrib = 4

If pelt tracking in this case does not cross a period, there is no
"change" in load_sum, and therefore load_avg is not recalculated, and
keeps its value.

If this cfs_rq is then removed from the leaf list, it results in a
situation where the load is never removed from the tg. If that happen,
the fiarness is permanently skewed.

Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3248e24a90b0..ceda53c2a87a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8004,6 +8004,9 @@ static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 	if (cfs_rq->avg.runnable_sum)
 		return false;
 
+	if (cfs_rq->tg_load_avg_contrib)
+		return false;
+
 	return true;
 }
 
-- 
2.31.1

