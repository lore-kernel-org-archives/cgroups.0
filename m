From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v13 17/18] mm/memcg: Add folio_lruvec_relock_irq() and
 folio_lruvec_relock_irqsave()
Date: Tue, 13 Jul 2021 14:03:57 +0100
Message-ID: <YO2PPZE7gQqvQRl1@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
 <20210712194551.91920-18-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YR7NATxyKSxd5HD27IiNLrRjQZNsZ/ojvafQvUdLxNY=; b=CN0WbhvMWKDho8nug9H1cMQrn/
        56K6kuqZIyHLhPL3Tzt3IbD00nRBJ3r9EO31MguM4nAxpGWRZXFWWwplLgxg9UEIkyJm33PcooHd1
        GoGT0lt19FtzGSzJMlxE5tq44Apaq3hqGiDFdK8xgk+Yg/QgH6E/RsI7auFZb+P91zm/EMT4rkHIZ
        Wyp5DyhCDs0HW71HNtFImlHC7l7tkk8WBJRJemKDMaL4zGUwgyM0CIcJa6gkr8lcr7a8bIkxo/ISD
        qiY8p5z9FvQl1LKw148A6zpwrrqI1IJBeAs4LSYJfES33bEWmcsOMcEuPqbC30D7v0AZMMCTt0tWf
        aibAwPWQ==;
Content-Disposition: inline
In-Reply-To: <20210712194551.91920-18-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jul 12, 2021 at 08:45:50PM +0100, Matthew Wilcox (Oracle) wrote:
> These are the folio equivalents of relock_page_lruvec_irq() and
> folio_lruvec_relock_irqsave().  Also convert page_matches_lruvec()
> to folio_matches_lruvec().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
