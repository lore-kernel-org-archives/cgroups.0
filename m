From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/8] mm: Use find_get_swap_page in memcontrol
Date: Thu, 27 Aug 2020 10:22:29 -0400
Message-ID: <20200827142229.GB1002856@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-3-willy@infradead.org>
 <20200826142002.GA988805@cmpxchg.org>
 <20200827125941.GG14765@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BmSkU8kL1DJIMf//B6UvwY8ukjXeH0WHbYlFQli5/Kw=;
 b=KPqGwrmsmOIuf+JiWEW/k7gGWQ1y3K+MpxQ+GlJBR4JHV9vGFTTbjyFMl+FZ4Y0eR1
 K2BXbisksDsJdOWmVO1uqUYQ2h1rz6x4zhmDciS7F7QXhAv9oK2efTTjrKFY2lV0MX2h
 m+NX4PEHBJLAtiNCQ+E62vD9YoMqRVe4nQ2rLdY2M6j+IN9GUIPk+F93i5PMufggiU+5
 7qfQtxk5IGmbE2ZD7qvuDqJQO8zKxEiYo6gkbc90Yi69wGk+9eBBpz/JoSeL/G/aFyFt
 vrKHByeeVrxLF5cwGuOVUkygA2VuBjAX42oiZQSqxkRduIvG36gg5Hfhjg+H7Ukg95zP
 RpMg==
Content-Disposition: inline
In-Reply-To: <20200827125941.GG14765@casper.infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Huang Ying <ying.huang@intel.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Thu, Aug 27, 2020 at 01:59:41PM +0100, Matthew Wilcox wrote:
> On Wed, Aug 26, 2020 at 10:20:02AM -0400, Johannes Weiner wrote:
> > The refactor makes sense to me, but the name is confusing. We're not
> > looking for a swap page, we're primarily looking for a file page in
> > the page cache mapping that's handed in. Only in the special case
> > where it's a shmem mapping and there is a swap entry do we consult the
> > auxiliary swap cache.
> > 
> > How about find_get_page_or_swapcache()? find_get_page_shmemswap()?
> > Maybe you have a better idea. It's a fairly specialized operation that
> > isn't widely used, so a longer name isn't a bad thing IMO.
> 
> Got it.  find_get_incore_page().  I was going to go with inmem, but that
> it matches mincore sold me on it.
>
> /**
>  * find_get_incore_page - Find and get a page from the page or swap caches.
>  * @mapping: The address_space to search.
>  * @index: The page cache index.
>  *
>  * This differs from find_get_page() in that it will also look for the
>  * page in the swap cache.
>  *
>  * Return: The found page or %NULL.
>  */

Nice work, that's perfect.

> I was focusing too much on what the function did, not why it was doing it.

Me too.
