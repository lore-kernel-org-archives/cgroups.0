From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg] memcg: enable memory accounting in __alloc_pages_bulk
Date: Fri, 8 Oct 2021 12:23:43 +0300
Message-ID: <bf3b1364-2c48-533f-9dae-22470074a037@virtuozzo.com>
References: <6411d3f7-b3a4-23a8-14fc-fcf6b9c5b73a@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=dpPiV3bJCSO+Krvm6GpN+2Uo7e56DJCpPVOsUghiKmE=; b=tqgKapK8JdPzur2w3X/
        6pSaHgtdkh0ouvn4j+ofbPaYDXCmaXkKg1LQwfrCq3EEpsUAhT6+2m3Y/euudRVCyKoy3SWFTb272
        eFW0FMx4A0IIjtdoqVrilXf+dVFn1+5Bq5B/gKKfJ6gJbdQBmMd48pW37dTXtMY1WdKCJ4hHbtA=;
In-Reply-To: <6411d3f7-b3a4-23a8-14fc-fcf6b9c5b73a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Enable memory accounting for bulk page allocator.

Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/page_alloc.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b37435c274cf..602819a232e5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5172,6 +5172,55 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+#ifdef CONFIG_MEMCG_KMEM
+static bool memcg_bulk_pre_charge_hook(struct obj_cgroup **objcgp, gfp_t gfp,
+					unsigned int nr_pages)
+{
+	struct obj_cgroup *objcg = NULL;
+
+	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT))
+		return true;
+
+	objcg = get_obj_cgroup_from_current();
+
+	if (objcg && obj_cgroup_charge(objcg, gfp, nr_pages << PAGE_SHIFT)) {
+		obj_cgroup_put(objcg);
+		return false;
+	}
+	obj_cgroup_get_many(objcg, nr_pages);
+	*objcgp = objcg;
+	return true;
+}
+
+static void memcg_bulk_charge_hook(struct obj_cgroup *objcg,
+					struct page *page)
+{
+	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
+}
+
+static void memcg_bulk_post_charge_hook(struct obj_cgroup *objcg,
+					unsigned int nr_pages)
+{
+	obj_cgroup_uncharge(objcg, nr_pages << PAGE_SHIFT);
+	percpu_ref_put_many(&objcg->refcnt, nr_pages + 1);
+}
+#else
+static bool memcg_bulk_pre_charge_hook(struct obj_cgroup **objcgp, gfp_t gfp,
+					unsigned int nr_pages)
+{
+	return true;
+}
+
+static void memcg_bulk_charge_hook(struct obj_cgroup *objcgp,
+					struct page *page)
+{
+}
+
+static void memcg_bulk_post_charge_hook(struct obj_cgroup *objcg,
+					unsigned int nr_pages)
+{
+}
+#endif
 /*
  * __alloc_pages_bulk - Allocate a number of order-0 pages to a list or array
  * @gfp: GFP flags for the allocation
@@ -5207,6 +5256,8 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
+	unsigned int nr_pre_charge = 0;
+	struct obj_cgroup *objcg = NULL;
 
 	/*
 	 * Skip populated array elements to determine if any pages need
@@ -5275,6 +5326,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	if (unlikely(!zone))
 		goto failed;
 
+	nr_pre_charge = nr_pages - nr_populated;
+	if (!memcg_bulk_pre_charge_hook(&objcg, gfp, nr_pre_charge))
+		goto failed;
+
 	/* Attempt the batch allocation */
 	local_lock_irqsave(&pagesets.lock, flags);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
@@ -5287,9 +5342,9 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nr_populated++;
 			continue;
 		}
-
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
+
 		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
@@ -5297,6 +5352,8 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			break;
 		}
 		nr_account++;
+		if (objcg)
+			memcg_bulk_charge_hook(objcg, page);
 
 		prep_new_page(page, 0, gfp, 0);
 		if (page_list)
@@ -5310,13 +5367,16 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
+	if (objcg)
+		memcg_bulk_post_charge_hook(objcg, nr_pre_charge - nr_account);
 
 out:
 	return nr_populated;
 
 failed_irq:
 	local_unlock_irqrestore(&pagesets.lock, flags);
-
+	if (objcg)
+		memcg_bulk_post_charge_hook(objcg, nr_pre_charge);
 failed:
 	page = __alloc_pages(gfp, 0, preferred_nid, nodemask);
 	if (page) {
-- 
2.31.1

