From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v13 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Tue, 13 Jul 2021 14:00:02 +0100
Message-ID: <YO2OUsXpXlOL3UrG@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
 <20210712194551.91920-15-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1V2jvMd6fkqgaw3BDHpPrRymG8iF/gqgfe5cZeoE7o4=; b=aASw1OG0HXB2Ba8ksyTd2aNaF4
        tbpIX+LCSBAiUPfKx2svBBM1WYcflGAi9Pj9I/u8f6S7y7VANyU4HAGiUY+S7azJQI2vJbRT0zLcs
        qdy7KzDflj1lahfNLXDjh/9Hw3zrZXkLqCWO9QHSFPcrHuJdlsah3/WhQuWj7TGN9NyC9CilmREo0
        youe0hjbL/NkmoFBsjgbg6kt/zWvr7OB2dhOwAwTuIx2/rhaP8p6bD+V/rFO7xgL7Fu9Wk0ElbMvy
        UeXIGX6AvJXiONZ9xfuQP+R7FPlrQJsKto92FVM7TSQxbFcY2qanIOfCB96A+rWlHNk3vtqYDh8k1
        k6WidyAA==;
Content-Disposition: inline
In-Reply-To: <20210712194551.91920-15-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jul 12, 2021 at 08:45:47PM +0100, Matthew Wilcox (Oracle) wrote:
> This saves dozens of bytes of text by eliminating a lot of calls to
> compound_head().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
