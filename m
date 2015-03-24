From: Jason Low <jason.low2@hp.com>
Subject: [PATCH v2 1/2] mm: Use READ_ONCE() for non-scalar types
Date: Tue, 24 Mar 2015 15:29:53 -0700
Message-ID: <1427236194-14582-2-git-send-email-jason.low2@hp.com>
References: <1427236194-14582-1-git-send-email-jason.low2@hp.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1427236194-14582-1-git-send-email-jason.low2@hp.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Jason Low <jason.low2@hp.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Aswin Chandramouleeswaran <aswin@hp.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Rik van Riel <riel@redhat.com>

Commit 38c5ce936a08 ("mm/gup: Replace ACCESS_ONCE with READ_ONCE")
converted ACCESS_ONCE usage in gup_pmd_range() to READ_ONCE, since
ACCESS_ONCE doesn't work reliably on non-scalar types.

This patch also fixes the other ACCESS_ONCE usages in gup_pte_range()
and __get_user_pages_fast() in mm/gup.c

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 mm/gup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ca7b607..6297f6b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1019,7 +1019,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 		 *
 		 * for an example see gup_get_pte in arch/x86/mm/gup.c
 		 */
-		pte_t pte = ACCESS_ONCE(*ptep);
+		pte_t pte = READ_ONCE(*ptep);
 		struct page *page;
 
 		/*
@@ -1309,7 +1309,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = ACCESS_ONCE(*pgdp);
+		pgd_t pgd = READ_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
-- 
1.7.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
