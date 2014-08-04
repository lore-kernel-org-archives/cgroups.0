From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm: memcontrol: clean up reclaim size variable use in try_charge()
Date: Mon,  4 Aug 2014 16:35:02 -0400
Message-ID: <1407184502-20818-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=2Xh8X8pBGeOHvHn8MXwIyN2kGg4og2FSntEONw27Da8=;
	b=WCelSV8M7DtFCPcRegoZwzflFGLORUfOHnk0Pgt9yKRwSIorn+VEn/fOIcnlIG7hkMgoRjHyyNePnKSk4UPRxaOy7JFw60UAmCGde8GBBAG54JN0XaEfbNakRP14FTKVuW746tb8iGGviqRlpZiRqyBrKYrG0moPTI1IRAkbpSs=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Charge reclaim and OOM currently use the charge batch variable, but
batching is already disabled at that point.  To simplify the charge
logic, the batch variable is reset to the original request size when
reclaim is entered, so it's functionally equal, but it's misleading.

Switch reclaim/OOM to nr_pages, which is the original request size.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8d65dadeec1b..ec4dcf1b9562 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2574,7 +2574,7 @@ retry:
 
 	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 
-	if (mem_cgroup_margin(mem_over_limit) >= batch)
+	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		goto retry;
 
 	if (gfp_mask & __GFP_NORETRY)
@@ -2588,7 +2588,7 @@ retry:
 	 * unlikely to succeed so close to the limit, and we fall back
 	 * to regular pages anyway in case of failure.
 	 */
-	if (nr_reclaimed && batch <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
 		goto retry;
 	/*
 	 * At task move, charge accounts can be doubly counted. So, it's
@@ -2606,7 +2606,7 @@ retry:
 	if (fatal_signal_pending(current))
 		goto bypass;
 
-	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
+	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
-- 
2.0.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
