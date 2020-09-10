From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v2 3/8] mm: Optimise madvise WILLNEED
Date: Thu, 10 Sep 2020 19:33:13 +0100
Message-ID: <20200910183318.20139-4-willy@infradead.org>
References: <20200910183318.20139-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=5pz6pk0hQVCAmUCzXhhMl6SI7ek8eXmhvDqxhMsMWZA=; b=Z0ig8BZOOs874Iqk+s8Hjq2poV
 GfUU0UHAUN9Q10UU2Qc227BQGYSAuBuImaK2JLeoDFbGlpRzkAAOn6+/YaptLDl2FRANNaxYmEE3w
 mM4+ZjVmKwqOk3NY3DlezWO3uDRW1yESEcjvvUwqea0D+xOlNL846Qr76zhGuKKjx9HOj3KgtZscS
 jit7EaGeKPNdD6jg3LNu0n3gynAd6wlhzi9Hsj3R5Mi0n4mt1NX4STEfYrPFDWo1mhNjNsHg18nlj
 vZc8Lz/HCP7Iav4W1Li83NNG/RE38e7EQqq6JJ3V+y6qbzdR40ePerF8p7gTuN16/gueZ/fX6Ngp1
 qzZoxrDw==;
In-Reply-To: <20200910183318.20139-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: linux-mm@kvack.org
Cc: intel-gfx@lists.freedesktop.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, William Kucharski <william.kucharski@oracle.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, Matthew Auld <matthew.auld@intel.com>

Instead of calling find_get_entry() for every page index, use an XArray
iterator to skip over NULL entries, and avoid calling get_page(),
because we only want the swap entries.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/madvise.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index dd1d43cf026d..96189acd6969 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -224,25 +224,28 @@ static void force_shm_swapin_readahead(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct address_space *mapping)
 {
-	pgoff_t index;
+	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
+	pgoff_t end_index = end / PAGE_SIZE;
 	struct page *page;
-	swp_entry_t swap;
 
-	for (; start < end; start += PAGE_SIZE) {
-		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	rcu_read_lock();
+	xas_for_each(&xas, page, end_index) {
+		swp_entry_t swap;
 
-		page = find_get_entry(mapping, index);
-		if (!xa_is_value(page)) {
-			if (page)
-				put_page(page);
+		if (!xa_is_value(page))
 			continue;
-		}
+		rcu_read_unlock();
+
 		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
 							NULL, 0, false);
 		if (page)
 			put_page(page);
+
+		rcu_read_lock();
+		xas_reset(&xas);
 	}
+	rcu_read_unlock();
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 }
-- 
2.28.0
