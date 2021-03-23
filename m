From: Arjun Roy <arjunroy@google.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 23 Mar 2021 11:47:54 -0700
Message-ID: <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0hZGL9ovQy+jWSfLjuO4yiUfJKwclwtM7TKVF346ck=;
        b=ZV0TRepGN/bTRrghylVvoSE2ass/5JiPwc7sWV/wAQVPb1uoehbKFxYd4S32T2g/0y
         bi8QRSGC4kiddQG52GuTZgZjLEO4L9GEbm0s0/mkY8Zy6+prXQuZMGBVscsMwTRldNqu
         lyWIYuzOG0oWrteGqrjaL6MJtGAJiNp/0XVN+6Of7kEDrx+5blNdgrFJEx40IIDQ0W+z
         cmAArxmrCm2xFu8htn/jaTt9xHXJKScLEwYLKM9GS7/7wd/U7vR/RgVPpaGOSmapqvr1
         +6LH315iekrNT5vGiRN5yU6KXXK5v2ezMT+076k3qWVhPbW0Geaur0UYFWCw4Pb+1DX3
         6Vtg==
In-Reply-To: <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Arjun Roy <arjunroy.kdev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Jakub Kicinski <kuba@kernel.org>, Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>

On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> [...]
> > Here is an idea of how it could work:
> >
> > struct page already has
> >
> >                 struct {        /* page_pool used by netstack */
> >                         /**
> >                          * @dma_addr: might require a 64-bit value even on
> >                          * 32-bit architectures.
> >                          */
> >                         dma_addr_t dma_addr;
> >                 };
> >
> > and as you can see from its union neighbors, there is quite a bit more
> > room to store private data necessary for the page pool.
> >
> > When a page's refcount hits zero and it's a networking page, we can
> > feed it back to the page pool instead of the page allocator.
> >
> > From a first look, we should be able to use the PG_owner_priv_1 page
> > flag for network pages (see how this flag is overloaded, we can add a
> > PG_network alias). With this, we can identify the page in __put_page()
> > and __release_page(). These functions are already aware of different
> > types of pages and do their respective cleanup handling. We can
> > similarly make network a first-class citizen and hand pages back to
> > the network allocator from in there.
>
> For compound pages we have a concept of destructors. Maybe we can extend
> that for order-0 pages as well. The struct page is heavily packed and
> compound_dtor shares the storage without other metadata
>                                         int    pages;    /*    16     4 */
>                         unsigned char compound_dtor;     /*    16     1 */
>                         atomic_t   hpage_pinned_refcount; /*    16     4 */
>                         pgtable_t  pmd_huge_pte;         /*    16     8 */
>                         void *     zone_device_data;     /*    16     8 */
>
> But none of those should really require to be valid when a page is freed
> unless I am missing something. It would really require to check their
> users whether they can leave the state behind. But if we can establish a
> contract that compound_dtor can be always valid when a page is freed
> this would be really a nice and useful abstraction because you wouldn't
> have to care about the specific type of page.
>
> But maybe I am just overlooking the real complexity there.
> --

For now probably the easiest way is to have network pages be first
class with a specific flag as previously discussed and have concrete
handling for it, rather than trying to establish the contract across
page types.

Thanks,
-Arjun

> Michal Hocko
> SUSE Labs
