From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH 5/7] vmscan: memcg: sleep when flushing stats during reclaim
Date: Thu, 23 Mar 2023 04:00:35 +0000
Message-ID: <20230323040037.2389095-6-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9m7S+Ebo8MkLWAncbvKsOW8wVqp1O+0Jr3lM7bEbkLI=;
        b=VdCCijFiKDJ4yDz8tFMap2tBXNfAakMH2cmowf1HUrZHuzx98c171wgP+Q37bsMmOY
         dvm3L1704oXKLAgAkOK0GjUnYQoP54+fQujrx3ACvUW9YBMoC0EV4BPolgDqFHWKSqHY
         vC+M0AbP8Thw306r5f0tU0s0RnClNRrpM7iLZQZCh4urjjm1nPlLVN2cvKbhB0gks3OE
         JIza4tgsYELq7gTHgeHRM8vhlVtpzgxg6m7gbPXptQ7q4d0Q9K++kyZO3UiZG82ponKY
         DM+ht1D3A+Eg8Co2dt+ym/gky/eIx2ki3TeVSJ2PxhVMHdlX5/2KaImaACWOeUxKy2jU
         FXPQ==
In-Reply-To: <20230323040037.2389095-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Memory reclaim should be a sleepable context. Allow sleeping when
flushing memcg stats to avoid unnecessarily performing a lot of work
without sleeping. This can slow down reclaim code if flushing stats is
taking too long, but there is already multiple cond_resched()'s in
reclaim code.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 59d1830d08ac..bae35cfb33c8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats(false);
+	mem_cgroup_flush_stats(true);
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
-- 
2.40.0.rc1.284.g88254d51c5-goog

