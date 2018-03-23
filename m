From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v2 2/4] mm/vmscan: remove redundant current_may_throttle() check
Date: Fri, 23 Mar 2018 18:20:27 +0300
Message-ID: <20180323152029.11084-3-aryabinin@virtuozzo.com>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=meYmxX9z9mCik64rbClE5+1kbzT/+N4qr5R4QpZxW4w=;
 b=f8HSQTLqohHWd1INhJVfjYzAxRHiyeFcE0v8auaUoxC2UzjZKjddltYNaQ1d2g8+QBTPXjCbo3Byz/mv+tG1eG1czaXidIbCkxfoixC/fwGhQW3ZHqxqhPPcviZd3iaQxd9UqvA9soXHPqnnl1pRgkEIJ/ssE8Xct27QJD72MNs=
In-Reply-To: <20180323152029.11084-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Only kswapd can have non-zero nr_immediate, and current_may_throttle() is
always true for kswapd (PF_LESS_THROTTLE bit is never set) thus it's
enough to check stat.nr_immediate only.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6d74b12099bd..403f59edd53e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1807,7 +1807,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (stat.nr_immediate && current_may_throttle())
+		if (stat.nr_immediate)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
-- 
2.16.1

