From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 47/99] shmem: Convert shmem_alloc_hugepage to
 XArray
Date: Wed, 17 Jan 2018 12:21:11 -0800
Message-ID: <20180117202203.19756-48-willy@infradead.org>
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
 bh=aIbRDzO9b/FZkL8A0ugczgvss8atkjuQl/VoqT5lYcQ=; b=AMlBItx6OpNejr757A+lgpCk7d
 thQtovtKq6epfm/8EUdG5tjzmdXE78Qa28FIyugHPZTnqfbdSEOZ418V3mlsen8ErkRuz/RWo2ld8
 Hy5d2yO6L51s3ZxIUnjVenp/w9PTvh4Wi9v6U7BoY8JR5xH5t/260+F50vrmPsJW5x1w=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=aIbRDzO9b/FZkL8A0ugczgvss8atkjuQl/VoqT5lYcQ=; b=Z7EOmVN5nVbMbWi84jRyaAEZU/
 vhSWUJ4eiKU7CVV51ZA5utywVuUA+WpZwrYsoZRfF5PRFAVzTJyrGeIMuvoCy6bN1W+CdpA8uTsiD
 XXat/qBRaPYf90VcFMvW4E4Tu4nP7O+PtdCzppFvbHBhDMW/8ikGVyX5iJfsj8O4QxYQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=aIbRDzO9b/FZkL8A0ugczgvss8atkjuQl/VoqT5lYcQ=; b=YzvF8pwS+t8fpREwOjfZ6iluH
 u1lxcF33VmZAqquEYHsIqLoFTN2h73A+LpCjcb3ThRGN7oNH9nfRJpt+20BD1Lt9p6NkA1j1AbZYY
 ZvsKxKn7Nns0UrQ+B0rDBra02Dr7gn1ZEXl9AXcyTcXdWK+mGX9IeBRrJ4KrW0UcrdfCfdReaZefl
 R1QqThC4W8LKtduvDDp1Y6iIHX62xHWp752FtbMjna+5xnxAc82dKzG3vsWR+36BBw+nYeBr6myRN
 eateU7x3R38og+Hx/YWlSUkrr6aU6GGct4nyM4Mp/o8SHOsqZZgfCmgaCylkceXZK4sNFZOsaIAMX
 BLmyvfS8w==;
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

xa_find() is a slightly easier API to use than
radix_tree_gang_lookup_slot() because it contains its own RCU locking.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0f49edae05e4..e8233cb7ab5c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1413,23 +1413,17 @@ static struct page *shmem_alloc_hugepage(gfp_t gfp,
 		struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
-	struct inode *inode = &info->vfs_inode;
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t idx, hindex;
-	void __rcu **results;
+	struct address_space *mapping = info->vfs_inode.i_mapping;
+	pgoff_t hindex;
 	struct page *page;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
 		return NULL;
 
 	hindex = round_down(index, HPAGE_PMD_NR);
-	rcu_read_lock();
-	if (radix_tree_gang_lookup_slot(&mapping->pages, &results, &idx,
-				hindex, 1) && idx < hindex + HPAGE_PMD_NR) {
-		rcu_read_unlock();
+	if (xa_find(&mapping->pages, &hindex, hindex + HPAGE_PMD_NR - 1,
+								XA_PRESENT))
 		return NULL;
-	}
-	rcu_read_unlock();
 
 	shmem_pseudo_vma_init(&pvma, info, hindex);
 	page = alloc_pages_vma(gfp | __GFP_COMP | __GFP_NORETRY | __GFP_NOWARN,
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
