From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Fri, 8 Oct 2021 12:24:21 +0300
Message-ID: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=BI1fdFpITncugnI8ZOhVcndov2suSbcgpwHQSA5zss0=; b=iSABWY+WWWhoqDCrxQC
        nB38taiVHhY686asLMwJQ4di0B+mUTrr288WyjGCl9ynJipevi7RY3SuBjRNjmNCLTlUj8mSE4ljD
        tQofyyvZhYa9lprVxChFOb4X+uFXhRoedlxKklPCAF/7NIpb/kdKl6V804E/sf2OLIncHyrVjYg=;
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

__alloc_pages_bulk can call __count_zid_vm_events and zone_statistics
with nr_account = 0.

Fixes: 3e23060b2d0b ("mm/page_alloc: batch the accounting updates in the bulk allocator")
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/page_alloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 602819a232e5..e67113452ee8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5364,9 +5364,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	}
 
 	local_unlock_irqrestore(&pagesets.lock, flags);
-
-	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
-	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
+	if (nr_account) {
+		__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
+		zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
+	}
 	if (objcg)
 		memcg_bulk_post_charge_hook(objcg, nr_pre_charge - nr_account);
 
-- 
2.31.1

