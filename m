From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 11/11] mm: Wakeup kswapd if toptier memory need soft reclaim
Date: Mon,  5 Apr 2021 10:08:35 -0700
Message-ID: <9d6b4eff73aef26fff3ecfbfc0693b84309d8b4c.1617642418.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Detect during page allocation whether free toptier memory is low.
If so, wake up kswapd to reclaim memory from those mem cgroups
that have exceeded their limit.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/mmzone.h | 3 +++
 mm/page_alloc.c        | 2 ++
 mm/vmscan.c            | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 789319dffe1c..3603948e95cc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -886,6 +886,8 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx);
+bool pgdat_toptier_balanced(pg_data_t *pgdat, int order, int classzone_idx);
+
 /*
  * Memory initialization context, use to differentiate memory added by
  * the platform statically or via memory hotplug interface.
@@ -1466,5 +1468,6 @@ void sparse_init(void);
 #endif
 
 #endif /* !__GENERATING_BOUNDS.H */
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91212a837d8e..ca8aa789a967 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3519,6 +3519,8 @@ struct page *rmqueue(struct zone *preferred_zone,
 	if (test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags)) {
 		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
+	} else if (!pgdat_toptier_balanced(zone->zone_pgdat, order, zone_idx(zone))) {
+		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
 	}
 
 	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 270880c8baef..8fe709e3f5e4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3625,7 +3625,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 	return false;
 }
 
-static bool pgdat_toptier_balanced(pg_data_t *pgdat, int order, int classzone_idx)
+bool pgdat_toptier_balanced(pg_data_t *pgdat, int order, int classzone_idx)
 {
 	int i;
 	unsigned long mark;
-- 
2.20.1

