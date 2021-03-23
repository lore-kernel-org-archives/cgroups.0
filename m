From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: page_alloc: fix memcg accounting leak in speculative
 cache lookup
Date: Tue, 23 Mar 2021 19:12:07 +0000
Message-ID: <20210323191207.GJ1719932@casper.infradead.org>
References: <20210319071547.60973-1-hannes@cmpxchg.org>
 <alpine.LSU.2.11.2103191814040.1043@eggly.anvils>
 <YFo7SOni0s0TbXUm@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Z0WR90dUR0c8O+Ghca91EEE7yMOJD4p7F63jROsdls=; b=icwXA+ar6ra1hlZuLW8OIAW/xA
        Al6ajurXvvGV5WRst3/GGWSzOnrYZVZxCEGKJJIfB+dSF6BTOK/h2cq2ZNrN63RLBMDS5SJa0lyVa
        70IUsot7vahFotNehhva+olPZZvTW9kdHQV2eow5ow70SvWHCFw7jccUWSR9DWW/w1nAn8yp722if
        SzWGyP9sID4+6Mok1PhDAgaltHLzi8Jvq+1z5zDDb2jSWHgepVc2LUd8+iDOevZ2mlJjixvigzj9t
        Ks7n+MJKAtADgkGQe5lMRhd6cGrCLUdiDzYHRWAnjAC6lseavVVdsAMGIgXEA4bQumWAfNpZFKNbw
        TprxQfoQ==;
Content-Disposition: inline
In-Reply-To: <YFo7SOni0s0TbXUm@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Zhou Guanghui <zhouguanghui1@huawei.com>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Mar 23, 2021 at 03:02:32PM -0400, Johannes Weiner wrote:
> >From f6f062a3ec46f4fb083dcf6792fde9723f18cfc5 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Fri, 19 Mar 2021 02:17:00 -0400
> Subject: [PATCH] mm: page_alloc: fix allocation imbalances from speculative
>  cache lookup
> 
> When the freeing of a higher-order page block (non-compound) races
> with a speculative page cache lookup, __free_pages() needs to leave
> the first order-0 page in the chunk to the lookup but free the buddy
> pages that the lookup doesn't know about separately.
> 
> There are currently two problems with it:
> 
> 1. It checks PageHead() to see whether we're dealing with a compound
>    page after put_page_testzero(). But the speculative lookup could
>    have freed the page after our put and cleared PageHead, in which
>    case we would double free the tail pages.
> 
>    To fix this, test PageHead before the put and cache the result for
>    afterwards.
> 
> 2. If such a higher-order page is charged to a memcg (e.g. !vmap
>    kernel stack)), only the first page of the block has page->memcg
>    set. That means we'll uncharge only one order-0 page from the
>    entire block, and leak the remainder.
> 
>    To fix this, add a split_page_memcg() before it starts freeing tail
>    pages, to ensure they all have page->memcg set up.
> 
> While at it, also update the comments a bit to clarify what exactly is
> happening to the page during that race.
> 
> Fixes: e320d3012d25 mm/page_alloc.c: fix freeing non-compound pages
> Reported-by: Hugh Dickins <hughd@google.com>
> Reported-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@vger.kernel.org> # 5.10+

This version makes me happy.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks for fixing my buggy fix.
