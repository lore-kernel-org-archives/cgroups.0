From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [PATCH v2 3/4] mm/vmscan: Don't change pgdat state on base of a
 single LRU list state.
Date: Fri, 6 Apr 2018 20:25:10 +0300
Message-ID: <312906df-80c4-aaaf-3d0f-caaeeceb9f39@virtuozzo.com>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
 <20180323152029.11084-4-aryabinin@virtuozzo.com>
 <20180406162835.GD20806@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5R3zq4IZ6J0W6STusX0nl8ua2fLRXkNcuFoH4SLlnSE=;
 b=SzBpXbkaN5+71ckFijNN7pNY6hzP5ocjghpmkoPAEaln7L6L8piYU5yBQbW637EhlTZUbSAZ3cwo9qDauEbC4GLsTn/JvGBH162ozkRBt62VHuDn0v1NZzfqCtfNwrFXuZkd+MIHU8Yp8O8J5Dw9PKfzHBOLvztNEJuvmSCsD7I=
In-Reply-To: <20180406162835.GD20806@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org



On 04/06/2018 07:28 PM, Johannes Weiner wrote:
> 
> This isn't quite equivalent to what we have right now.
> 
> Yes, nr_dirty, nr_unqueued_dirty and nr_congested apply to file pages
> only. That part is about waking the flushers and avoiding writing
> files in 4k chunks from reclaim context. So those numbers do need to
> be compared against scanned *file* pages.
> 
> But nr_writeback and nr_immediate is about throttling reclaim when we
> hit too many pages under writeout, and that applies to both file and
> anonymous/swap pages. We do want to throttle on swapout, too.
> 
> So nr_writeback needs to check against all nr_taken, not just file.
> 

Agreed, the fix bellow. It causes conflict in the next 4/4 patch,
so I'll just send v3 with all fixes folded.

---
 mm/vmscan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4d848b8df01f..c45497475e84 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -124,6 +124,7 @@ struct scan_control {
 		unsigned int writeback;
 		unsigned int immediate;
 		unsigned int file_taken;
+		unsigned int taken;
 	} nr;
 };
 
@@ -1771,6 +1772,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
+	sc->nr.taken += nr_taken;
 	if (file)
 		sc->nr.file_taken += nr_taken;
 
@@ -2553,7 +2555,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 		 * number of pages under pages flagged for immediate reclaim and
 		 * stall if any are encountered in the nr_immediate check below.
 		 */
-		if (sc->nr.writeback && sc->nr.writeback == sc->nr.file_taken)
+		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
 			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 		/*
-- 
2.16.1
