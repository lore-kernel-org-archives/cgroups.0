From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/6] mm: vmscan: delete unused pgdat_reclaimable_pages()
Date: Tue, 30 May 2017 14:17:19 -0400
Message-ID: <20170530181724.27197-2-hannes@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:
	Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tlvwjvOWqCkyRScC5dW5EzMXHJ6n8vR1Dupuq/ax9n8=; b=eRhlN1UtNib0G6c0IAVd0dqrQf
	EmtCoUGuoEX83w/Lqbmay9Ft/2w2yeJYQN5jL0bSLCXES505DUYjEVVhJrozd3rzLTvL36mrHSz+j
	4tOVpWumbBSSzwjyHtY0pgHG8/M9I+1tFxQIuBjNA6T2429zuhGt+Cl76xVbR9U2JFcE=;
In-Reply-To: <20170530181724.27197-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/swap.h |  1 -
 mm/vmscan.c          | 16 ----------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ba5882419a7d..6e3d1d0a7f48 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -289,7 +289,6 @@ extern void lru_cache_add_active_or_unevictable(struct page *page,
 
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
-extern unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ad39bbc79e6..c5f9d1673392 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -219,22 +219,6 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
 	return nr;
 }
 
-unsigned long pgdat_reclaimable_pages(struct pglist_data *pgdat)
-{
-	unsigned long nr;
-
-	nr = node_page_state_snapshot(pgdat, NR_ACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_INACTIVE_FILE) +
-	     node_page_state_snapshot(pgdat, NR_ISOLATED_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += node_page_state_snapshot(pgdat, NR_ACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_INACTIVE_ANON) +
-		      node_page_state_snapshot(pgdat, NR_ISOLATED_ANON);
-
-	return nr;
-}
-
 /**
  * lruvec_lru_size -  Returns the number of pages on the given LRU list.
  * @lruvec: lru vector
-- 
2.12.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
