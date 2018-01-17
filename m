From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 66/99] page cache: Finish XArray conversion
Date: Wed, 17 Jan 2018 12:21:30 -0800
Message-ID: <20180117202203.19756-67-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=ZUixE8UIx+Uw33Ptxtp6ch2sD7OyVIqIqzQrNWtBjXg=; b=aZQCFV6wuMHvlK+PoTv+bYM7R
	u2h977vzY0bh5PK3j4eUygqAGyEARVw7gPv43GXsQ8xH0sDhcIrou5k9RrXpRMWCNxrEhQpph2qis
	B8FROZEUXzpD2B9WJXjwC8AX4ENVL2xF+XAvSq2NOSL6fRpzDKFuEaKDQ2Je1CNFo5EqJ05BqIqLO
	sUvgkeVTWYgNibpzvlQG62Rvnkp32oIiL4jt0Us0Puup33YL/9IF3sUQx1nT196kWMku7jAMgftMW
	lvuYkuJlgvSLpKaIHXUtxxkEMhqJ8jjd9BIsztDUyRJGBiASvTe7jee/llwLgV7dYkhMnRbfxgfd8
	1oBp3qNUA==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

With no more radix tree API users left, we can drop the GFP flags
and use xa_init() instead of INIT_RADIX_TREE().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/inode.c         | 2 +-
 include/linux/fs.h | 2 +-
 mm/swap_state.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c7b00573c10d..f5680b805336 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -348,7 +348,7 @@ EXPORT_SYMBOL(inc_nlink);
 void address_space_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->pages, GFP_ATOMIC | __GFP_ACCOUNT);
+	xa_init_flags(&mapping->pages, XA_FLAGS_LOCK_IRQ);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c58bc3c619bf..b459bf4ddb62 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -410,7 +410,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  */
 struct address_space {
 	struct inode		*host;
-	struct radix_tree_root	pages;
+	struct xarray		pages;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
 	struct rb_root_cached	i_mmap;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 219e3b4f09e6..25f027d0bb00 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -573,7 +573,7 @@ int init_swap_address_space(unsigned int type, unsigned long nr_pages)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
 		space = spaces + i;
-		INIT_RADIX_TREE(&space->pages, GFP_ATOMIC|__GFP_NOWARN);
+		xa_init_flags(&space->pages, XA_FLAGS_LOCK_IRQ);
 		atomic_set(&space->i_mmap_writable, 0);
 		space->a_ops = &swap_aops;
 		/* swap cache doesn't use writeback related tags */
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
