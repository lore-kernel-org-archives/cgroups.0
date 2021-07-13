From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v13 16/18] mm/memcg: Add folio_lruvec_lock() and similar
 functions
Date: Tue, 13 Jul 2021 14:03:04 +0100
Message-ID: <YO2PCM9h8sFaHK14@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
 <20210712194551.91920-17-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JYBnZ/UoKQnWGfv6A36EmkLu9KZZfuRPPECPY/WoAvE=; b=DDKMLNyhTcSdr3WYSYlxuLzqxW
        4Yya9zmjvw5wL//vjQbDFT69j15KyI4WG7KsyRB+X7hENue5GHGDhAFjpU+ePrPv1y3oUsqbW/YAj
        0IU7pF28y3B3DadQa3pBmlMt9GNdOjUQ+pebiGozRebKPogHKs43K1TW3LJvKZ27Qb7fQrivT+H1r
        sD/cwzv6e1fIOsqDnwVsgIsVrR1K6s/Cl4T9Bsmt5jdCLB1sPBTvVzp8Rel+rTsXpiP9WcKx+SBiX
        iJRpkTcj9jSbXIR5qiI6NZDqHxeWXLyvmaiZ15vbqqwrGw06QILwh8zKEoyyI9zDvA0Ddvolp4OAx
        DN67Lslg==;
Content-Disposition: inline
In-Reply-To: <20210712194551.91920-17-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jul 12, 2021 at 08:45:49PM +0100, Matthew Wilcox (Oracle) wrote:
> These are the folio equivalents of lock_page_lruvec() and similar
> functions.  Also convert lruvec_memcg_debug() to take a folio.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
