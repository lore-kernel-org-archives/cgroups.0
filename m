From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: page_cgroup_ino() get memcg from
 compound_head(page)
Date: Thu, 16 Mar 2023 03:07:11 +0000
Message-ID: <ZBKH3xT3FesWeX2c@casper.infradead.org>
References: <20230313083452.1319968-1-yosryahmed@google.com>
 <20230313124431.fe901d79bc8c7dc96582539c@linux-foundation.org>
 <CAJD7tkZKhNRiWOrUOiHWuEQbOuDhjyHx0H01M1mQziM36viq9w@mail.gmail.com>
 <ZBFPh6j+4Khl1Je8@casper.infradead.org>
 <CAJD7tkYFjRPq6ATj-d0P25FhDaMzKdXfqTa_hh7TZp_Xyt4v+w@mail.gmail.com>
 <ZBG3xzGd6j+uByyN@casper.infradead.org>
 <CAJD7tkbcTMo1oZAa0Pa3v_6d0n4bHCo+8vTxzXGU6UBVOhrUQw@mail.gmail.com>
 <8d4e1b74-6ae8-4243-d5c2-e63e8046d355@redhat.com>
 <CAJD7tkbNtJHse5BH=FzgRGUW=oLLoORb7yb8xqUFhF097zDLyg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GaBSB/q5RZZv1uL/3Gq3Md5Uoooa7QyxjRaawK+7oNc=; b=W5oNDduDSzHnSn/lHr3XclBBJs
        ZPwReYpP5TY0WawtqJ8+3M0EJlPasIOJQegxsnYSkfDL1mQalzoPS437vUWx0UptRdGYEzzETqQXW
        1agZd7h7fAJWQeMKqlJGAo0q7NKtDOe+2tFErdTQMPlmS7hWIy8aV3OrZiVfoluTY74Sfl8wIxPJ7
        BGcCxUJnSKrzodiaIL5vNpzajhQOjG/YhGUpIY5TUk+0SQLu6n+ryw2HbCK+zVely58ba+rYjdEvl
        egKlXwNA1WRqkm2+pvtvzLHm/wty6mlE8f5UobHyTwcLExFjqmuEWPL+V5B/Dipi0651gmPshUgzf
        YE8v/lRw==;
Content-Disposition: inline
In-Reply-To: <CAJD7tkbNtJHse5BH=FzgRGUW=oLLoORb7yb8xqUFhF097zDLyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Naoya Horiguchi <naoya.horiguchi-YMj9X0ASwKA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 15, 2023 at 05:25:49PM -0700, Yosry Ahmed wrote:
[snipped 80 lines.  please learn to trim]
> I think instead of explicitly checking page->memcg_data, we can check
> PageTail() and return explicitly for tail pages tails, check
> PageSlab() to print the message for slab pages, then get the page's
> memcg through folio_memcg_check(page_folio(page)).
> 
> Something like:
> 
> static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
> struct page *page)
> {
>     ...
>     rcu_read_lock();
> 
>     /* Only head pages hold refs to a memcg */
>     if (PageTail(page))
>         goto out_unlock;
> 
>     if (PageSlab(page))
>         ret += scnprintf(kbuf + ret, count - ret, "Slab cache page\n");
> 
>     memcg = folio_memcg_check(page_folio(page));
>     if (!memcg)
>         goto out_unlock;
>     ...
> }
> 
> Matthew, What do you think?

Brrr, this is hard.  read_page_owner() holds no locks or references,
so pages can transform between being head/tail/order-0 while we're
running.

It _tries_ to skip over tail pages in the most inefficient way possible:

                if (!IS_ALIGNED(pfn, 1 << page_owner->order))
                        goto ext_put_continue;

But any attempt to use folio APIs is going to risk tripping the
assertions in the folio code that it's not a tail.  This requires
more thought.
