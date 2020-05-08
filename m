From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 07/19] mm: memcontrol: prepare move_account for removal of private page type counters
Date: Fri,  8 May 2020 14:30:54 -0400
Message-ID: <20200508183105.225460-8-hannes@cmpxchg.org>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfCvK5ICX9RLV3lPlzIAY41JRodQH86fFkwrgQlSEf8=;
        b=CmwijAWGrB9GpiDIRRkJD4jSnT43gKAmAnGfjMaA25Kt/6/LLUOt4eOCmLPfSIMGOT
         aW9ShVJ6f895PpkJvDJVVoFWx5BgKEjpiM1k6aB0HHEse5SZQ2jgfYQwrhgGFc295/53
         c0firhINkXK8AhvGbh6gPtL7EkztISznspA8/2XedHiWj27+y2kPRk+C3Qyyd37UqCb/
         Llgeupzc7yudqB6GBoOzm51I3hJ4r0VphHkIxYSiDfkxQJHcvK4xfuG+CLwHYBO4dkIO
         LbKGvdO0IK037kd4xPNaYTmJxNke7bjWj88R1s0cINtHKjji7z8isPYV8KpPWPEjBxTw
         d/wg==
In-Reply-To: <20200508183105.225460-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When memcg uses the generic vmstat counters, it doesn't need to do
anything at charging and uncharging time. It does, however, need to
migrate counts when pages move to a different cgroup in move_account.

Prepare the move_account function for the arrival of NR_FILE_PAGES,
NR_ANON_MAPPED, NR_ANON_THPS etc. by having a branch for files and a
branch for anon, which can then divided into sub-branches.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
---
 mm/memcontrol.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a5efdad77be4..fe4212db8411 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5378,7 +5378,6 @@ static int mem_cgroup_move_account(struct page *page,
 	struct pglist_data *pgdat;
 	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret;
-	bool anon;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5396,25 +5395,27 @@ static int mem_cgroup_move_account(struct page *page,
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
2.26.2

