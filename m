From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] mm: fix numa stats for thp migration
Date: Sun, 27 Dec 2020 10:13:10 -0800
Message-ID: <20201227181310.3235210-2-shakeelb@google.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=j7pGoESECcJnUn1Gu4iB96Pgr1MQxVnZ8zJqEnq7HhA=;
        b=sFDh5UzBKicLvJ1rSvNdm19dsKKLr4qDzDc2quHExqawNylMQw803yweRQFCUTSA6B
         zkEHZCeLxdGapg3YdeQSa7zcEDjrsTveFxq5Ar/jFCWzE02orSCJjp9Q4tpbDs8rpbjq
         6apVzkZSw+TEoTnVlvQeVhExp9/wDOsHaKEHjtM/SPLGYqiFar5nDkFqZnnWPiVg1RLA
         uibFRgBA0mylKxp45uLlgHmoN+8JLwf9jS20MXiRvVm0rAJfNDeNiQjDv1StQk1UfqnI
         egYPPypITj5p0P395GPrvEiykeuEVFGezdUk/TnMIskRfivMft2/Rh3nxUyw4ekoJi5B
         YcJw==
Sender: "shakeelb via sendgmr" <shakeelb-rSQFlI6iZjOvss2yl3NHrPyj43VRqXoZVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <20201227181310.3235210-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently the kernel is not correctly updating the numa stats for
NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
handle THP migration as kernel still does not have write support for
file THP but to be more future proof, this patch adds the THP support
for those stats as well.

Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 mm/migrate.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 613794f6a433..ade163c6ecdf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	struct zone *oldzone, *newzone;
 	int dirty;
 	int expected_count = expected_page_refs(mapping, page) + extra_count;
+	int nr = thp_nr_pages(page);
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
@@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 */
 	newpage->index = page->index;
 	newpage->mapping = page->mapping;
-	page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
+	page_ref_add(newpage, nr); /* add cache reference */
 	if (PageSwapBacked(page)) {
 		__SetPageSwapBacked(newpage);
 		if (PageSwapCache(page)) {
@@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	if (PageTransHuge(page)) {
 		int i;
 
-		for (i = 1; i < HPAGE_PMD_NR; i++) {
+		for (i = 1; i < nr; i++) {
 			xas_next(&xas);
 			xas_store(&xas, newpage);
 		}
@@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
+	page_ref_unfreeze(page, expected_count - nr);
 
 	xas_unlock(&xas);
 	/* Leave irq disabled to prevent preemption while updating stats */
@@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		__dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
-		__inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
+		__mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+		__mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_lruvec_state(old_lruvec, NR_SHMEM);
-			__inc_lruvec_state(new_lruvec, NR_SHMEM);
+			__mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
+			__mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
-			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
-			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
+			__mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
+			__mod_zone_page_tate(oldzone, NR_ZONE_WRITE_PENDING, -nr);
+			__mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
+			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
 	}
 	local_irq_enable();
-- 
2.29.2.729.g45daf8777d-goog

