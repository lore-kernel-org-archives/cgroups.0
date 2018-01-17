From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 23/99] page cache: Add page_cache_range_empty
 function
Date: Wed, 17 Jan 2018 12:20:47 -0800
Message-ID: <20180117202203.19756-24-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WmXvZpBeEv3qtPchMWQI6SbRbU4BFsdbZY1NmyUCjzA=; b=Me4VLcMCkCsGh5xBWvCkhEsPMi
 INPMcqr1VMQGDU/Ainvr8Hls4Q4bMS11LI1+8BkXWlTYIf8B7MWyujPz3kpMH6mHX2Q9oQDZRB2/P
 iZA+Do7SuyYzUt+nx2UjjQc3fFqk18bqtvhj3Cd4WcRsseJUmesGMdDa9XmUy7UjzjJk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=WmXvZpBeEv3qtPchMWQI6SbRbU4BFsdbZY1NmyUCjzA=; b=X7lFFa3leh0ycldr+Fme0ZDHqp
 l9/JQJf1lXmYFzlQO6e2zGH2r8l9X1vwVIYXsPsGN0E6yapLe/nz3mk8RFZXOKBsOwywiMk2hsELc
 iQUq0zAZpedXxKm/SVkuYKBNogxQ81JYLuWmRYa0GHce1TStBFeOKal6faPJinyXGndY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=WmXvZpBeEv3qtPchMWQI6SbRbU4BFsdbZY1NmyUCjzA=; b=fBRusbgXml36No4xMHUBJwOhM
 j5GTTwVT6Ob5cGko5KxsFYyPM13/e9cBfgi/nCFevIeIrsh38jORN24XOTdC/E9jbk/Zo3jz8XEJu
 rkRzT/RGt57RF6S8J7COrTOwJxPpgCkhi6jsaIaqcen30Jbcv88B7VcvY6J71wykpW6+f/Nb0lE88
 X4bzOUKWtc8ops93tkaI6MplaqZzdV7zy+dKE6BqMV0bnT+OeAlHSioj7JjfH2nHzVhPVui21q5Hd
 ee97upY9aj3iuGzeJrOvN1VKF1JGJWsyJgelDW4eVtSe08Yv/CfHBJzrJh1Fd8jo3Vzxk5MFdpl16
 Y6AoGezrA==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

btrfs has its own custom function for determining whether the page cache
has any pages in a particular range.  Move this functionality to the
page cache, and call it from btrfs.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/btrfs_inode.h  |  7 ++++-
 fs/btrfs/inode.c        | 70 -------------------------------------------------
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 26 ++++++++++++++++++
 4 files changed, 34 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 63f0ccc92a71..a48bd6e0a0bb 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -365,6 +365,11 @@ static inline void btrfs_print_data_csum_error(struct btrfs_inode *inode,
 			logical_start, csum, csum_expected, mirror_num);
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end);
+static inline bool btrfs_page_exists_in_range(struct inode *inode,
+						loff_t start, loff_t end)
+{
+	return page_cache_range_empty(inode->i_mapping, start >> PAGE_SHIFT,
+							end >> PAGE_SHIFT);
+}
 
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dbdb5bf6bca1..d7d2c556d5a2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7541,76 +7541,6 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	return ret;
 }
 
-bool btrfs_page_exists_in_range(struct inode *inode, loff_t start, loff_t end)
-{
-	struct radix_tree_root *root = &inode->i_mapping->pages;
-	bool found = false;
-	void **pagep = NULL;
-	struct page *page = NULL;
-	unsigned long start_idx;
-	unsigned long end_idx;
-
-	start_idx = start >> PAGE_SHIFT;
-
-	/*
-	 * end is the last byte in the last page.  end == start is legal
-	 */
-	end_idx = end >> PAGE_SHIFT;
-
-	rcu_read_lock();
-
-	/* Most of the code in this while loop is lifted from
-	 * find_get_page.  It's been modified to begin searching from a
-	 * page and return just the first page found in that range.  If the
-	 * found idx is less than or equal to the end idx then we know that
-	 * a page exists.  If no pages are found or if those pages are
-	 * outside of the range then we're fine (yay!) */
-	while (page == NULL &&
-	       radix_tree_gang_lookup_slot(root, &pagep, NULL, start_idx, 1)) {
-		page = radix_tree_deref_slot(pagep);
-		if (unlikely(!page))
-			break;
-
-		if (radix_tree_exception(page)) {
-			if (radix_tree_deref_retry(page)) {
-				page = NULL;
-				continue;
-			}
-			/*
-			 * Otherwise, shmem/tmpfs must be storing a swap entry
-			 * here so return it without attempting to raise page
-			 * count.
-			 */
-			page = NULL;
-			break; /* TODO: Is this relevant for this use case? */
-		}
-
-		if (!page_cache_get_speculative(page)) {
-			page = NULL;
-			continue;
-		}
-
-		/*
-		 * Has the page moved?
-		 * This is part of the lockless pagecache protocol. See
-		 * include/linux/pagemap.h for details.
-		 */
-		if (unlikely(page != *pagep)) {
-			put_page(page);
-			page = NULL;
-		}
-	}
-
-	if (page) {
-		if (page->index <= end_idx)
-			found = true;
-		put_page(page);
-	}
-
-	rcu_read_unlock();
-	return found;
-}
-
 static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			      struct extent_state **cached_state, int writing)
 {
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0db127c3ccac..34d4fa3ad1c5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -245,6 +245,8 @@ pgoff_t page_cache_next_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
 pgoff_t page_cache_prev_gap(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan);
+bool page_cache_range_empty(struct address_space *mapping,
+				pgoff_t index, pgoff_t max);
 
 #define FGP_ACCESSED		0x00000001
 #define FGP_LOCK		0x00000002
diff --git a/mm/filemap.c b/mm/filemap.c
index 146e8ec16ec0..f1b4480723dd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1398,6 +1398,32 @@ pgoff_t page_cache_prev_gap(struct address_space *mapping,
 }
 EXPORT_SYMBOL(page_cache_prev_gap);
 
+bool page_cache_range_empty(struct address_space *mapping, pgoff_t index,
+				pgoff_t max)
+{
+	struct page *page;
+	XA_STATE(xas, &mapping->pages, index);
+
+	rcu_read_lock();
+	do {
+		page = xas_find(&xas, max);
+		if (xas_retry(&xas, page))
+			continue;
+		/* Shadow entries don't count */
+		if (xa_is_value(page))
+			continue;
+		/*
+		 * We don't need to try to pin this page; we're about to
+		 * release the RCU lock anyway.  It is enough to know that
+		 * there was a page here recently.
+		 */
+	} while (0);
+	rcu_read_unlock();
+
+	return page != NULL;
+}
+EXPORT_SYMBOL_GPL(page_cache_range_empty);
+
 /**
  * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
