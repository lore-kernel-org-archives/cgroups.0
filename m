From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 8/9] vmscan: memcg: sleep when flushing stats during reclaim
Date: Tue, 28 Mar 2023 22:16:43 +0000
Message-ID: <20230328221644.803272-9-yosryahmed@google.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AvW0vRtvUGz6RfpHjuJf5DcrLtUCw4uDLtzj7kPXkaI=;
        b=s2Rhy6bhmsxOtwUgNmtWPZ1OIy2px3+ZgcKdui8SYbOasl9GBmkC/HgOP+eca1phsP
         jP5oqLAVmD71L+yTcF9Qf7RNoZtsSSFPX0S6Mq6S5HfUed3nW8TUcaJtaUm/tsI8O9Am
         d5OJg/swbll5+1GgM/EDnx0GyYjs89Yzqk1B1Gc+8UCS388fxVzDgMBm93/UJRyrTJYr
         f1CeTGEfaowg6ARY0FoahfZMcN2kOGoi1UzCuTmmzShA86ZvRPo5Rcmo6znhWB9xOjYc
         VRAX/Gquhhjvyizfw+QszvCjk77JT0+yZFVam4Xqz3PGsmr5F2QrldBe6NoQ8SARTtvR
         pWDg==
In-Reply-To: <20230328221644.803272-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Memory reclaim is a sleepable context. Allow sleeping when flushing
memcg stats to avoid unnecessarily performing a lot of work without
sleeping. This can slow down reclaim code if flushing stats is taking
too long, but there is already multiple cond_resched()'s in reclaim
code.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9511ccb936f..9c1c5e8b24b8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats_atomic();
+	mem_cgroup_flush_stats();
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
-- 
2.40.0.348.gf938b09366-goog

