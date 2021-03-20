From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page_alloc: fix memcg accounting leak in speculative
 cache lookup
Date: Fri, 19 Mar 2021 18:52:58 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2103191814040.1043@eggly.anvils>
References: <20210319071547.60973-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=bbqnt/9Bz0dwgnbwz2YuuMVEFJVwyS/lwtSrMVzL3KQ=;
        b=k3LlzQxQcReO0CIi6WRFB0czD21cyNNYz88NKLNL4trrdRK5/zKFure+Q8GTtYZJF2
         wFEqKvwzbNIC0IxUXvaK1jGVB14NNssZRUTv4Tncl1yvFTtYxXuUjAeOhGp+k8MAnZcH
         F8/l9+cOiCI4vpuXIyH+iNtx3elBg7YuThEUEBE1WjjCddczzu/OOGSvpju6tiFZxYVb
         tqopjrM2cCRs0H2EKjcPCEVMs8YgFxRyzztWcBWOjKkppl7k1zpDiL91mypTRvEPDAmC
         YC0s7nFCbOfv3icqQPTV3c0D9Jr/TowdgyY0nmwR1mLSgCtyg7iEAMZqUF1xNCh3PnCF
         Tf1w==
In-Reply-To: <20210319071547.60973-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zhou Guanghui <zhouguanghui1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, 19 Mar 2021, Johannes Weiner wrote:

> When the freeing of a higher-order page block (non-compound) races
> with a speculative page cache lookup, __free_pages() needs to leave
> the first order-0 page in the chunk to the lookup but free the buddy
> pages that the lookup doesn't know about separately.
> 
> However, if such a higher-order page is charged to a memcg (e.g. !vmap
> kernel stack)), only the first page of the block has page->memcg
> set. That means we'll uncharge only one order-0 page from the entire
> block, and leak the remainder.
> 
> Add a split_page_memcg() to __free_pages() right before it starts
> taking the higher-order page apart and freeing its individual
> constituent pages. This ensures all of them will have the memcg
> linkage set up for correct uncharging. Also update the comments a bit
> to clarify what exactly is happening to the page during that race.
> 
> This bug is old and has its roots in the speculative page cache patch
> and adding cgroup accounting of kernel pages. There are no known user
> reports. A backport to stable is therefor not warranted.
> 
> Reported-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

to the split_page_memcg() addition etc, but a doubt just hit me on the
original e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages"):
see comment below.

> ---
>  mm/page_alloc.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c53fe4fa10bf..f4bd56656402 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5112,10 +5112,9 @@ static inline void free_the_page(struct page *page, unsigned int order)
>   * the allocation, so it is easy to leak memory.  Freeing more memory
>   * than was allocated will probably emit a warning.
>   *
> - * If the last reference to this page is speculative, it will be released
> - * by put_page() which only frees the first page of a non-compound
> - * allocation.  To prevent the remaining pages from being leaked, we free
> - * the subsequent pages here.  If you want to use the page's reference
> + * This function isn't a put_page(). Don't let the put_page_testzero()
> + * fool you, it's only to deal with speculative cache references. It
> + * WILL free pages directly. If you want to use the page's reference
>   * count to decide when to free the allocation, you should allocate a
>   * compound page, and use put_page() instead of __free_pages().
>   *
> @@ -5124,11 +5123,33 @@ static inline void free_the_page(struct page *page, unsigned int order)
>   */
>  void __free_pages(struct page *page, unsigned int order)
>  {
> -	if (put_page_testzero(page))
> +	/*
> +	 * Drop the base reference from __alloc_pages and free. In
> +	 * case there is an outstanding speculative reference, from
> +	 * e.g. the page cache, it will put and free the page later.
> +	 */
> +	if (likely(put_page_testzero(page))) {
>  		free_the_page(page, order);
> -	else if (!PageHead(page))
> +		return;
> +	}
> +
> +	/*
> +	 * The speculative reference will put and free the page.
> +	 *
> +	 * However, if the speculation was into a higher-order page
> +	 * chunk that isn't marked compound, the other side will know
> +	 * nothing about our buddy pages and only free the order-0
> +	 * page at the start of our chunk! We must split off and free
> +	 * the buddy pages here.
> +	 *
> +	 * The buddy pages aren't individually refcounted, so they
> +	 * can't have any pending speculative references themselves.
> +	 */
> +	if (!PageHead(page) && order > 0) {

The put_page_testzero() has released our reference to the first
subpage of page: it's now under the control of the racing speculative
lookup.  So it seems to me unsafe to be checking PageHead(page) here:
if it was actually a compound page, PageHead might already be cleared
by now, and we doubly free its tail pages below?  I think we need to
use a "bool compound = PageHead(page)" on entry to __free_pages().

Or alternatively, it's wrong to call __free_pages() on a compound
page anyway, so we should not check PageHead at all, except in a
WARN_ON_ONCE(PageCompound(page)) at the start?

And would it be wrong to fix that too in this patch?
Though it ought then to be backported to 5.10 stable.

> +		split_page_memcg(page, 1 << order);
>  		while (order-- > 0)
>  			free_the_page(page + (1 << order), order);
> +	}
>  }
>  EXPORT_SYMBOL(__free_pages);
>  
> -- 
> 2.30.1
