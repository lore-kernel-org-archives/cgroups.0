From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v13 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Tue, 13 Jul 2021 13:58:55 +0100
Message-ID: <YO2OD5SdBnzec0no@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
 <20210712194551.91920-14-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nxAcv2j1eAtOyeVEwqJKCH7cpe8F3sW32yQHnBEh9S4=; b=QkBF61eScUV83eb84+fw9LH+bo
        wKTnfiTE+sBzDtQuu1H2K1Upyhml0uDAF1BKl3UtqFJ7MkmXYvsb/t8RUGr0vECqYehntmBz9UxaI
        D3wD5dq9cAxSddL3oL5uPTxT9ooO/pWuBqrSEix+5ZK54NegPLgZumBqy0Y4AKsXPTWqxiH2AOr1L
        PV5nF44rz3TL2LRn12PEV3iyiwzptKFeHTnt4XUyRvKHr7fGX+CY//z782ahhpsgfNBplMaze5TDY
        6BgBF29dwQRgDaP7UXzqztkzcEth2Gds4Ufo93Jtw7KcVzzXzPBkAOFo9GXIQBII9daCKCNTJ1Vwj
        7d/rmoyQ==;
Content-Disposition: inline
In-Reply-To: <20210712194551.91920-14-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jul 12, 2021 at 08:45:46PM +0100, Matthew Wilcox (Oracle) wrote:
> These are the folio equivalents of lock_page_memcg() and
> unlock_page_memcg().
> 
> lock_page_memcg() and unlock_page_memcg() have too many callers to be
> easily replaced in a single patch, so reimplement them as wrappers for
> now to be cleaned up later when enough callers have been converted to
> use folios.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
