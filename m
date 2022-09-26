From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 3/4] mm: memcontrol: use do_memsw_account() in a few more places
Date: Mon, 26 Sep 2022 09:57:03 -0400
Message-ID: <20220926135704.400818-4-hannes@cmpxchg.org>
References: <20220926135704.400818-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=nxWlvz8nHKxF79bLiRXoWvFCmNni5yV7mxHmCxzwA1c=;
        b=Pm8S7GcSFRJWTzik7LhbfogyC+//ZqsABilFvcQgI1rbJfqhpFRdanL1+GHXzprwnB
         rX2IGIitEbL0wUDSi9cTNbod47SaPSyBy1s2M/5H5oBEUnarJed+X2kV8S+NiGjcxDM2
         vyiCvtjy2NTBluE9HJcH16mhvyA2bKbIXJVu1otPRo9tqdUIPRMnydMZ/oIzuoWf11ut
         +nM6kLfw8XCbjB5tY3+nupim51GjwAgoM6PbDihvDKfLcwrDvb6/cuOqvgB8YzwSaOsa
         psRi+d0w+GC+hRxyaO6MjNfx63poKtPW1lqwUQp53OOsA/8Eh8fpODIaU+m2krXZThHf
         NCJA==
In-Reply-To: <20220926135704.400818-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It's slightly more descriptive and consistent with other places that
distinguish cgroup1's combined memory+swap accounting scheme from
cgroup2's dedicated swap accounting.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4be1b48b9659..76bb0a18a2f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1667,17 +1667,17 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		if (mem_cgroup_swappiness(memcg))
-			max += min(READ_ONCE(memcg->swap.max),
-				   (unsigned long)total_swap_pages);
-	} else { /* v1 */
+	if (do_memsw_account()) {
 		if (mem_cgroup_swappiness(memcg)) {
 			/* Calculate swap excess capacity from memsw limit */
 			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
 
 			max += min(swap, (unsigned long)total_swap_pages);
 		}
+	} else {
+		if (mem_cgroup_swappiness(memcg))
+			max += min(READ_ONCE(memcg->swap.max),
+				   (unsigned long)total_swap_pages);
 	}
 	return max;
 }
@@ -7334,7 +7334,7 @@ void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
 	if (mem_cgroup_disabled())
 		return;
 
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!do_memsw_account())
 		return;
 
 	memcg = folio_memcg(folio);
@@ -7399,7 +7399,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (do_memsw_account())
 		return 0;
 
 	memcg = folio_memcg(folio);
@@ -7451,10 +7451,10 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
-			if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-				page_counter_uncharge(&memcg->swap, nr_pages);
-			else
+			if (do_memsw_account())
 				page_counter_uncharge(&memcg->memsw, nr_pages);
+			else
+				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 		mem_cgroup_id_put_many(memcg, nr_pages);
-- 
2.37.3

