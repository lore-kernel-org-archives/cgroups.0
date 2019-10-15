From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 11:09:59 +0300
Message-ID: <157112699975.7360.1062614888388489788.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571126999; bh=uBM99g9Ux3Kxexvrq/r6f01uJx9JtYqNm8Mfn0xVlC8=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=0zJyKpG7DWT6yZkKFLtLlBCDanDEvWtoPV22gBVytDfdFHCGcDN3cNYokg3xrx23a
         yV8iYJy6AziG4UYARUNuT4xWygPrhyB4XnTvju8yRj7eTLGBh/BrKL4wgr485tWZK/
         B1IZEXSXS1tFGgk3Jhtgz1t5/D9VbJfk5tJKB1mc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

Mapped, dirty and writeback pages are also counted in per-lruvec stats.
These counters needs update when page is moved between cgroups.

Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 mm/memcontrol.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bdac56009a38..363106578876 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5420,6 +5420,8 @@ static int mem_cgroup_move_account(struct page *page,
 				   struct mem_cgroup *from,
 				   struct mem_cgroup *to)
 {
+	struct lruvec *from_vec, *to_vec;
+	struct pglist_data *pgdat;
 	unsigned long flags;
 	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret;
@@ -5443,11 +5445,15 @@ static int mem_cgroup_move_account(struct page *page,
 
 	anon = PageAnon(page);
 
+	pgdat = page_pgdat(page);
+	from_vec = mem_cgroup_lruvec(pgdat, from);
+	to_vec = mem_cgroup_lruvec(pgdat, to);
+
 	spin_lock_irqsave(&from->move_lock, flags);
 
 	if (!anon && page_mapped(page)) {
-		__mod_memcg_state(from, NR_FILE_MAPPED, -nr_pages);
-		__mod_memcg_state(to, NR_FILE_MAPPED, nr_pages);
+		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
 	}
 
 	/*
@@ -5459,14 +5465,14 @@ static int mem_cgroup_move_account(struct page *page,
 		struct address_space *mapping = page_mapping(page);
 
 		if (mapping_cap_account_dirty(mapping)) {
-			__mod_memcg_state(from, NR_FILE_DIRTY, -nr_pages);
-			__mod_memcg_state(to, NR_FILE_DIRTY, nr_pages);
+			__mod_lruvec_state(from_vec, NR_FILE_DIRTY, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_FILE_DIRTY, nr_pages);
 		}
 	}
 
 	if (PageWriteback(page)) {
-		__mod_memcg_state(from, NR_WRITEBACK, -nr_pages);
-		__mod_memcg_state(to, NR_WRITEBACK, nr_pages);
+		__mod_lruvec_state(from_vec, NR_WRITEBACK, -nr_pages);
+		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE

