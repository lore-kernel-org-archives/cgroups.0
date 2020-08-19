From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 8/8] mm: Hoist find_subpage call further up in
 pagecache_get_page
Date: Wed, 19 Aug 2020 19:48:50 +0100
Message-ID: <20200819184850.24779-9-willy@infradead.org>
References: <20200819184850.24779-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=7+YSI5YaFA7nV1yaE7i/RW3xZbJtF/8x3LDr4io57Q8=; b=QBZEY6GNdSOmnF4ujehB7tIL/+
 8WlFkWpSxuLPFzkGOnnhlBlJavyO4Z+T0yXOfXgJgAGvoDk+Cf1m8ak9wPM8AkhSIMWn8nFA51xkD
 WHXh1JSEJrwxa10n1dsaReCF4jaEG4ACDpvQROgOqopHoed3BHKh9cV153/2lHtDBdHzNGvzALDwt
 xhCJjd4YgCOtHb28bEt8UYDUq80/QJIuQXJRj9csQ+VHnOkdnIJ+SSvdZLDIr692dGd7QtGw5TKT0
 kT9IZJattIKOxBcoS1wr/w22x9PoXKBXAMBPZyBB/EKkYK4S922ZQv2l+P8miuoSBxQIRrrF5OJXs
 10W3+YmQ==;
In-Reply-To: <20200819184850.24779-1-willy@infradead.org>
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

This avoids a call to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6594baae7cd2..8c354277108d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1667,7 +1667,6 @@ struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		page = NULL;
 	if (!page)
 		goto no_page;
-	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
@@ -1680,12 +1679,12 @@ struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		}
 
 		/* Has the page been truncated? */
-		if (unlikely(compound_head(page)->mapping != mapping)) {
+		if (unlikely(page->mapping != mapping)) {
 			unlock_page(page);
 			put_page(page);
 			goto repeat;
 		}
-		VM_BUG_ON_PAGE(page->index != index, page);
+		VM_BUG_ON_PAGE(!thp_valid_index(page, index), page);
 	}
 
 	if (fgp_flags & FGP_ACCESSED)
@@ -1695,6 +1694,7 @@ struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		if (page_is_idle(page))
 			clear_page_idle(page);
 	}
+	page = find_subpage(page, index);
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
-- 
2.28.0
