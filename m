From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 07/18] mm: memcontrol: prepare move_account for removal of private page type counters
Date: Mon, 20 Apr 2020 18:11:15 -0400
Message-ID: <20200420221126.341272-8-hannes@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DOOm476uJeMGLcBhM+Nnzpj1no5zTibX8MlOScPTZP8=;
        b=hioVkfM6+J8WLoqNgQvJex645fWjZjvT2/DsLybW7sYgjf412MeETUZ9sROh0R1aWj
         +PT6+SXjVnqxxmEOTA9tvabznzLoBPcJBFq4YE8hoEuzbzF40WKlwKaqtbAqUJo+/bas
         im+UJ8ycoNz8d4jRpIMsB++DBz0dnGnuMqlCB4hmyggGOAgndpABwHd17mrndefiJRwz
         Z2qXu1h9XDQmhj97BrOl/rj7HMgRojZXQSyqf2BDfruwfndNUIWs+LD73ZabCqzmMaCn
         cehSIavgIGYGeqhJF+aMCBuk7+NX/1IMdnuJyPVCfgAkX8NmPsXmgrRjB/kNROuj/5bz
         UYlg==
In-Reply-To: <20200420221126.341272-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

When memcg uses the generic vmstat counters, it doesn't need to do
anything at charging and uncharging time. It does, however, need to
migrate counts when pages move to a different cgroup in move_account.

Prepare the move_account function for the arrival of NR_FILE_PAGES,
NR_ANON_MAPPED, NR_ANON_THPS etc. by having a branch for files and a
branch for anon, which can then divided into sub-branches.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e3e8913a5b28..ac6f2b073a5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5374,7 +5374,6 @@ static int mem_cgroup_move_account(struct page *page,
 	struct pglist_data *pgdat;
 	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret;
-	bool anon;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5392,25 +5391,27 @@ static int mem_cgroup_move_account(struct page *page,
 	if (page->mem_cgroup != from)
 		goto out_unlock;
 
-	anon = PageAnon(page);
-
 	pgdat = page_pgdat(page);
 	from_vec = mem_cgroup_lruvec(from, pgdat);
 	to_vec = mem_cgroup_lruvec(to, pgdat);
 
 	lock_page_memcg(page);
 
-	if (!anon && page_mapped(page)) {
-		__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
-		__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
-	}
+	if (!PageAnon(page)) {
+		if (page_mapped(page)) {
+			__mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
+			__mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
+		}
 
-	if (!anon && PageDirty(page)) {
-		struct address_space *mapping = page_mapping(page);
+		if (PageDirty(page)) {
+			struct address_space *mapping = page_mapping(page);
 
-		if (mapping_cap_account_dirty(mapping)) {
-			__mod_lruvec_state(from_vec, NR_FILE_DIRTY, -nr_pages);
-			__mod_lruvec_state(to_vec, NR_FILE_DIRTY, nr_pages);
+			if (mapping_cap_account_dirty(mapping)) {
+				__mod_lruvec_state(from_vec, NR_FILE_DIRTY,
+						   -nr_pages);
+				__mod_lruvec_state(to_vec, NR_FILE_DIRTY,
+						   nr_pages);
+			}
 		}
 	}
 
-- 
2.26.0

