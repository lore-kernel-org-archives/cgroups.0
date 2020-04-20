From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 06/18] mm: memcontrol: prepare uncharging for removal of private page type counters
Date: Mon, 20 Apr 2020 18:11:14 -0400
Message-ID: <20200420221126.341272-7-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dG5KZR2clXoJPnKFOV5SEHBLf26fT+nPwiogFzO+ldA=;
        b=0WaKHKwQVjmbBjFsTuOWUS+wcC0JLwQFHr5wj3CTY2kjqfMVSf29eOS5hCwn+W8cTO
         RaS/Clu0E2zgqMx7TxfVx4wFvJ3twiM9vkH/3BQPXiC90YhEkWGOVobolxEGs5oCrnpm
         Yp17gTJI8CxdmtYcRkYIT+iDXdwlx25mrcRBgHjgRDdl6xKZxnGrNKXEqeE1NJTJoKyg
         K8fP1gfYcCtmkBZ1dvSOhtMRAZi+CWDolI+0MVDYEZ4BA3t9DX5AuqMNoAVDp3CA6LR9
         /qheOYPf6Aw5mrvqaivEHFMNLvkGY6Ecycko2QIhT3fzUF8EUfAAmjHiH3C46VyuACvZ
         sBlA==
In-Reply-To: <20200420221126.341272-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The uncharge batching code adds up the anon, file, kmem counts to
determine the total number of pages to uncharge and references to
drop. But the next patches will remove the anon and file counters.

Maintain an aggregate nr_pages in the uncharge_gather struct.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b38c0a672d26..e3e8913a5b28 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6606,6 +6606,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
 
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
+	unsigned long nr_pages;
 	unsigned long pgpgout;
 	unsigned long nr_anon;
 	unsigned long nr_file;
@@ -6622,13 +6623,12 @@ static inline void uncharge_gather_clear(struct uncharge_gather *ug)
 
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
-	unsigned long nr_pages = ug->nr_anon + ug->nr_file + ug->nr_kmem;
 	unsigned long flags;
 
 	if (!mem_cgroup_is_root(ug->memcg)) {
-		page_counter_uncharge(&ug->memcg->memory, nr_pages);
+		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, nr_pages);
+			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
 			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
@@ -6640,16 +6640,18 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, nr_pages);
+	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
 	if (!mem_cgroup_is_root(ug->memcg))
-		css_put_many(&ug->memcg->css, nr_pages);
+		css_put_many(&ug->memcg->css, ug->nr_pages);
 }
 
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
+	unsigned long nr_pages;
+
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page) && !is_zone_device_page(page) &&
 			!PageHWPoison(page) , page);
@@ -6671,13 +6673,12 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 		ug->memcg = page->mem_cgroup;
 	}
 
-	if (!PageKmemcg(page)) {
-		unsigned int nr_pages = 1;
+	nr_pages = compound_nr(page);
+	ug->nr_pages += nr_pages;
 
-		if (PageTransHuge(page)) {
-			nr_pages = compound_nr(page);
+	if (!PageKmemcg(page)) {
+		if (PageTransHuge(page))
 			ug->nr_huge += nr_pages;
-		}
 		if (PageAnon(page))
 			ug->nr_anon += nr_pages;
 		else {
@@ -6687,7 +6688,7 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 		}
 		ug->pgpgout++;
 	} else {
-		ug->nr_kmem += compound_nr(page);
+		ug->nr_kmem += nr_pages;
 		__ClearPageKmemcg(page);
 	}
 
-- 
2.26.0

