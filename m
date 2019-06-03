From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 01/11] mm: vmscan: move inactive_list_is_low() swap check to the caller
Date: Mon,  3 Jun 2019 17:07:36 -0400
Message-ID: <20190603210746.15800-2-hannes@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0EoeyvI+6nSZVdPsXoo6A3bLjv7jCmnakg13/Vo0S7g=;
        b=jQQKpymP0x+HXM6AidEDpl+oryXhrFlsULaSJxrk+bRuLIK2zph32NK7fQ9YAJaCBe
         N7+enaR2Vc1oYLo8aptLEfjl+dIsZ+yBuVWMXGIzNgNQI9SdCmD/jLhITwBQ9ehLSkb+
         XEVP/h3PMZVC5vzDLRMA2ctacgD5ioiLhXBcIfjUB5IUWXVcT3hHScDrk9eh/9mNvu5o
         PWXDbM+Um+WQ9hcOjSXq+jo3FDIH6cYOI+MipuzXRWJvoaNI+qxII2acSgoctNl9nHHf
         375AuTgxJjHK4jIuhHyjGLr4uaIo2/oQ034Ox+mp98rzfJnHVOkExpOIKkw9vVPM1s+r
         yyag==
In-Reply-To: <20190603210746.15800-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

inactive_list_is_low() should be about one thing: checking the ratio
between inactive and active list. Kitchensink checks like the one for
swap space makes the function hard to use and modify its
callsites. Luckly, most callers already have an understanding of the
swap situation, so it's easy to clean up.

get_scan_count() has its own, memcg-aware swap check, and doesn't even
get to the inactive_list_is_low() check on the anon list when there is
no swap space available.

shrink_list() is called on the results of get_scan_count(), so that
check is redundant too.

age_active_anon() has its own totalswap_pages check right before it
checks the list proportions.

The shrink_node_memcg() site is the only one that doesn't do its own
swap check. Add it there.

Then delete the swap check from inactive_list_is_low().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 84dcb651d05c..f396424850aa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2165,13 +2165,6 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	unsigned long refaults;
 	unsigned long gb;
 
-	/*
-	 * If we don't have swap space, anonymous page deactivation
-	 * is pointless.
-	 */
-	if (!file && !total_swap_pages)
-		return false;
-
 	inactive = lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
 	active = lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
 
@@ -2592,7 +2585,7 @@ static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memc
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_list_is_low(lruvec, false, sc, true))
+	if (total_swap_pages && inactive_list_is_low(lruvec, false, sc, true))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 }
-- 
2.21.0

