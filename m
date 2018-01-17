From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 29/99] page cache: Convert
 filemap_range_has_page to XArray
Date: Wed, 17 Jan 2018 12:20:53 -0800
Message-ID: <20180117202203.19756-30-willy@infradead.org>
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
 bh=0gMKEn41sEQQ8rydM8ONdiHZ+WPLzqkRu7DXivUh31k=; b=CX/Fd1EivbiS4OTTbegetOOBTA
 Hwi8+YXUimQX5MM1OWcThFW72GzA8sGHomDvUsXszc94RUV1rcqZX3qqkbxD2TEjPiTF9mYQzBolT
 7AgMGfRwRPloA3i4MNK6Lg+g9lXs93yLBGH1r/i+LtFMLuRfJG8tEkdFWH2UdbuKoFUY=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=0gMKEn41sEQQ8rydM8ONdiHZ+WPLzqkRu7DXivUh31k=; b=dhWBdV7wIFtOHYavJDpjC7NPnN
 +PH4j/5scFEsQJH8grPnkVGzVUfjAmKgbcZGF5d+c+Aa0rMRZ8RNtDW9hjmqf5ZmkiHWcuPVkYfpQ
 g3wXdcHrzS0CJdcHDrwIsgYgj08ahz6Wo8NPZ/GhQu1j6cOAm3uPZhVZuj+lRxWdPic0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=0gMKEn41sEQQ8rydM8ONdiHZ+WPLzqkRu7DXivUh31k=; b=X139ivviHqRVhDz3vsz7dLt/x
 BFV8kthyz/a7f19n7nM1DD4gQcNFNLphFzVi0STyiIfFsnnq8GIPULsThL/dSYom6D+v7H0/VqNK2
 oYGL1fMHkVnUyJCKq1LRZ8cQTsw5jpgLIko9fxKFZhNB2Jm6qNhIVpkgUCBecW8DaZQfAjyL1VD2C
 S4cwsW6L/u96j7tWgbxyij3p7qIPXUuwJ53MJ+fukbVeSKRwId074DeVm+1uCevYyNQQ5lsc+8f1d
 5OMqu4FkflqHXYbYe7Pd1xcR1hwDOiR2Lsxdf6NPySaRzJShWGAXWn/amhJb3bdtcIeLMpr1tie8v
 zP1zanh7Q==;
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

Instead of calling find_get_pages_range() and putting any reference,
just use xa_find() to look for a page in the right range.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2536fcacb5bc..cd01f353cf6a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -461,18 +461,11 @@ bool filemap_range_has_page(struct address_space *mapping,
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
-	struct page *page;
 
 	if (end_byte < start_byte)
 		return false;
 
-	if (mapping->nrpages == 0)
-		return false;
-
-	if (!find_get_pages_range(mapping, &index, end, 1, &page))
-		return false;
-	put_page(page);
-	return true;
+	return xa_find(&mapping->pages, &index, end, XA_PRESENT);
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
