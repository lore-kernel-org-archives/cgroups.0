From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v2 2/8] mm: Use find_get_incore_page in
 memcontrol
Date: Thu, 10 Sep 2020 19:33:12 +0100
Message-ID: <20200910183318.20139-3-willy@infradead.org>
References: <20200910183318.20139-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=9Kn2iFLtjBF2LN/hYtvFQ/WKPU3K2jlU8w46DPT4v9k=; b=t24P+wZGPBULu7P1ekGMrb5y9T
 +Q1IxPXTncTG4gGwrZhjgf4JJghC8ojB18ezEOesNeo4Xuqjhr0wHwKeYeiTkSWAu/RAssUiItsYh
 NYU5A8Djhbd24fNw+Oz5dTRDqjbttRVgFEDZVwFxAFDmZKu/vgIL+3rT5W9t2BvdUeUTKwYjFasW4
 +6lT8Ru9pPL8wGIiD6mjfygYSG5lYSrgza1ShAHEuy5rL7B422LXHzNcpvSvfiupaPI4Ph8RJyLX6
 bUKIAao2SDGexvS6Pn8LYeVeNjsBmywkZEQZuiQhcC54PcAvlH1iO/eZraGUIu0C56F46awFsb6qI
 jNq1efPg==;
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

The current code does not protect against swapoff of the underlying
swap device, so this is a bug fix as well as a worthwhile reduction in
code complexity.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memcontrol.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b807952b4d43..2f02eaee7115 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5539,35 +5539,15 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	struct page *page = NULL;
-	struct address_space *mapping;
-	pgoff_t pgoff;
-
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
 	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
-	mapping = vma->vm_file->f_mapping;
-	pgoff = linear_page_index(vma, addr);
-
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-#ifdef CONFIG_SWAP
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	if (shmem_mapping(mapping)) {
-		page = find_get_entry(mapping, pgoff);
-		if (xa_is_value(page)) {
-			swp_entry_t swp = radix_to_swp_entry(page);
-			*entry = swp;
-			page = find_get_page(swap_address_space(swp),
-					     swp_offset(swp));
-		}
-	} else
-		page = find_get_page(mapping, pgoff);
-#else
-	page = find_get_page(mapping, pgoff);
-#endif
-	return page;
+	return find_get_incore_page(vma->vm_file->f_mapping,
+			linear_page_index(vma, addr));
 }
 
 /**
-- 
2.28.0
