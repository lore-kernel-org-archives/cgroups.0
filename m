From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/6] mm: memcontrol: track LRU counts in the vmstats array
Date: Thu, 28 Feb 2019 11:30:15 -0500
Message-ID: <20190228163020.24100-2-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSVRB4KCxOzLiCcKtVzLdp3bqBiDRMqjw6+T+tZutHo=;
        b=mUmeIE5tnpsUGSnPqHmhaPEa7lf70tbLRHRnTncX97PvuH/o83yraWIA5zNr2rhiIp
         mpkAWKlqywdH7kW6UpgZyAHXZCyBpYNS+SG54JVKSe2fLL5wNcgjH9Q97zxt1D5RpII1
         WeWjuyR4YDKC3jKLczUULysqQOcc+yP8bzEynWwg3HCg5WHMxRZlTti0KtykiQuvv3kq
         YROup6kl8Iuyzca2iPVlj3322bMupx6H73LQkPOdGiwtgd6ZjWn0XHKo9doJy1JuxVuG
         Mo2SA/F1rgT6zxF9PDEGAuC8LLHWA/fy6BG5ikjx7h55H5U7V9xL4eH3UKlRj6MnSuI2
         /XsA==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The memcg code currently maintains private per-zone breakdowns of the
LRU counters. This is necessary for reclaim decisions which are still
zone-based, but there are a variety of users of these counters that
only want the aggregate per-lruvec or per-memcg LRU counts, and they
need to painfully sum up the zone counters on each request for that.

These would be better served using the memcg vmstats arrays, which
track VM statistics at the desired scope already. They just don't have
the LRU counts right now.

So to kick off the conversion, begin tracking LRU counts in those.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm_inline.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 04ec454d44ce..6f2fef7b0784 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -29,7 +29,7 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	__mod_node_page_state(pgdat, NR_LRU_BASE + lru, nr_pages);
+	__mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
 	__mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
-- 
2.20.1

