From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to use a folio
Date: Wed, 30 Jun 2021 05:00:30 +0100
Message-ID: <20210630040034.1155892-15-willy@infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6f2u0OBpdjFMGS2fAPLgyHx8ij4yt1XVTz/CfYcHZnY=; b=WDVCtVkTmC2BLZGefiF7n9mIRD
        ELmXOagilDbdiGvcGFCJ96R68FVOmg3UMfAY92cj9F79YaObUPxgzEWmIYB66mEb2cjLLZlygiXrF
        H/kiQYjuMWAyiA0Vm/8dVMcevftiK1tSfaewGoxqzSS442aacZv26cqvzgxxhS1RHDtW4P0F2pbe1
        AZOnD6z3ySk1ppyXLJqfahVn4orBGV4OXHUjQH+0TiUfTAY66CoRrLlXZSmIdfTOXfNzrePHu+5Wb
        HRRGaOnymSI0KkswqTHbCG3XBtX6KHJ5VKdbnhw0RaDv92NEgm3n2hKU2GsYk1b+awX2U4ZKc/78q
        Rn0rCeJA==;
In-Reply-To: <20210630040034.1155892-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This saves dozens of bytes of text by eliminating a lot of calls to
compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/memcontrol.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b94a6122f27d..95795b65ae3e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5585,38 +5585,39 @@ static int mem_cgroup_move_account(struct page *page,
 				   struct mem_cgroup *from,
 				   struct mem_cgroup *to)
 {
+	struct folio *folio = page_folio(page);
 	struct lruvec *from_vec, *to_vec;
 	struct pglist_data *pgdat;
-	unsigned int nr_pages = compound ? thp_nr_pages(page) : 1;
+	unsigned int nr_pages = compound ? folio_nr_pages(folio) : 1;
 	int nid, ret;
 
 	VM_BUG_ON(from == to);
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-	VM_BUG_ON(compound && !PageTransHuge(page));
+	VM_BUG_ON_FOLIO(folio_lru(folio), folio);
+	VM_BUG_ON(compound && !folio_multi(folio));
 
 	/*
 	 * Prevent mem_cgroup_migrate() from looking at
 	 * page's memory cgroup of its source page while we change it.
 	 */
 	ret = -EBUSY;
-	if (!trylock_page(page))
+	if (!folio_trylock(folio))
 		goto out;
 
 	ret = -EINVAL;
-	if (page_memcg(page) != from)
+	if (folio_memcg(folio) != from)
 		goto out_unlock;
 
-	pgdat = page_pgdat(page);
+	pgdat = folio_pgdat(folio);
 	from_vec = mem_cgroup_lruvec(from, pgdat);
 	to_vec = mem_cgroup_lruvec(to, pgdat);
 
-	lock_page_memcg(page);
+	folio_memcg_lock(folio);
 
-	if (PageAnon(page)) {
-		if (page_mapped(page)) {
+	if (folio_anon(folio)) {
+		if (folio_mapped(folio)) {
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
-			if (PageTransHuge(page)) {
+			if (folio_multi(folio)) {
 				__mod_lruvec_state(from_vec, NR_ANON_THPS,
 						   -nr_pages);
 				__mod_lruvec_state(to_vec, NR_ANON_THPS,
@@ -5627,18 +5628,18 @@ static int mem_cgroup_move_account(struct page *page,
 		__mod_lruvec_state(from_vec, NR_FILE_PAGES, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_FILE_PAGES, nr_pages);
 
-		if (PageSwapBacked(page)) {
+		if (folio_swapbacked(folio)) {
 			__mod_lruvec_state(from_vec, NR_SHMEM, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_SHMEM, nr_pages);
 		}
 
-		if (page_mapped(page)) {
+		if (folio_mapped(folio)) {
 			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
 		}
 
-		if (PageDirty(page)) {
-			struct address_space *mapping = page_mapping(page);
+		if (folio_dirty(folio)) {
+			struct address_space *mapping = folio_mapping(folio);
 
 			if (mapping_can_writeback(mapping)) {
 				__mod_lruvec_state(from_vec, NR_FILE_DIRTY,
@@ -5649,7 +5650,7 @@ static int mem_cgroup_move_account(struct page *page,
 		}
 	}
 
-	if (PageWriteback(page)) {
+	if (folio_writeback(folio)) {
 		__mod_lruvec_state(from_vec, NR_WRITEBACK, -nr_pages);
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
@@ -5672,12 +5673,12 @@ static int mem_cgroup_move_account(struct page *page,
 	css_get(&to->css);
 	css_put(&from->css);
 
-	page->memcg_data = (unsigned long)to;
+	folio->memcg_data = (unsigned long)to;
 
 	__memcg_unlock(from);
 
 	ret = 0;
-	nid = page_to_nid(page);
+	nid = folio_nid(folio);
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(to, nr_pages);
@@ -5686,7 +5687,7 @@ static int mem_cgroup_move_account(struct page *page,
 	memcg_check_events(from, nid);
 	local_irq_enable();
 out_unlock:
-	unlock_page(page);
+	folio_unlock(folio);
 out:
 	return ret;
 }
-- 
2.30.2

