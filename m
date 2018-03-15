From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH 4/6] mm/vmscan: remove redundant current_may_throttle() check
Date: Thu, 15 Mar 2018 19:45:51 +0300
Message-ID: <20180315164553.17856-4-aryabinin@virtuozzo.com>
References: <20180315164553.17856-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=21KwmvCTSUPnZHj3pXAyeH6anKkTMi8uLurXAUGswBU=;
 b=RNnuMtHIpi4PxapykdLWbrqc5WHQBJxJYuHuJ0A+fzncIduNti94fHQQsQQsnUrQqe/Da0aDxT+17mImZ1qGlc7RfdJpKoHXmoX1dDHAM6ZXKR63Ah+5CmPM1PCXD5gxWN4odv4G0lyUgcKUo+IgurnuQyEQhnL2JTwzfeN/DBY=
In-Reply-To: <20180315164553.17856-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Only kswapd can have non-zero nr_immediate, and current_may_throttle() is
always true for kswapd (PF_LESS_THROTTLE bit is never set) thus it's
enough to check stat.nr_immediate only.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0d5ab312a7f4..a8f6e4882e00 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1806,7 +1806,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (stat.nr_immediate && current_may_throttle())
+		if (stat.nr_immediate)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
-- 
2.16.1

