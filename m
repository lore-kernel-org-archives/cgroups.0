From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 35/99] mm: Convert __do_page_cache_readahead to XArray
Date: Wed, 17 Jan 2018 12:20:59 -0800
Message-ID: <20180117202203.19756-36-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D8M3hOFBbLyULrl9YVFK8Bg7yKABGG8u8Da+4wV0B9U=; b=XArDuX/NLr7EJYq5JM2WdyLPN
        cJ8VL9lwzCBt68XEhw8TIkfgFaHN5PXMhIWvWmufjjXKc5n40f7v1tmDRRaz3Ii3RsNnmuDDW7gxO
        5YQJ4WjpMPVY0ePclVFtTiKmdM7vo00/8bMaKob9jhGk7ey7gHAw3wT5hk+1lw5/FdoyxzC5PsiIg
        eXrMy8qr1BDFKsfX1pPowPO28y/C3G2BXAUtp/JaG6iC/rNZZQvkSg94ek7fJScbtSieGfDmz/2EM
        PaDe+Ub3AC1zACTX1VdyE9M/AmrNUpAXYNHSVUlGddD4jayBZ/1u2DPGgQ5QChHhLiXmhcNvBGG0j
    
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

This one is trivial.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/readahead.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index f64b31b3a84a..66bcaffd47f0 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -174,9 +174,7 @@ int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		if (page_offset > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->pages, page_offset);
-		rcu_read_unlock();
+		page = xa_load(&mapping->pages, page_offset);
 		if (page && !xa_is_value(page))
 			continue;
 
-- 
2.15.1

