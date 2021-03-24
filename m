From: Arjun Roy <arjunroy@google.com>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 24 Mar 2021 13:39:06 -0700
Message-ID: <CAOFY-A1+TT5EgT0oVEkGgHAaJavbLzbKp5fQx_uOrMtw-7VEiA@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com> <YFsA78FfzICrnFf7@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qcDyxyk5bvCS0WEAV1+mJY8jO/8xTEDVqNFuTGwD3vw=;
        b=LQv/zun+j1/d9r4zt9gm0IaWVEHFp8r2eRBRjyUN6GFZODOU1mbnZt2VglPEMqNrMk
         5XO3EJkRspqLHmcUlkVAoJFRaMzGO65rMOxOVb89V6LEr3WYzYSl+7LKLIW3XD5V/y+J
         CjJh7fXJoQ5eSHjuGEm0atA60APspXDZ2TJJlFC34cmQda/5bX9QW968cxxC00GNf9yj
         73+uXyYSMPdhj/hgFSsp4QabE3/KzaQ+YoUte/HNOtLyEX5iyrUeQb786gluhJc4wQ2/
         U2hJkhVbGvJWYbEF8SsnOsjUTOxexa8kSlA64w/vw5ylM6SNWnXSPaYLHextD3GJ82Ir
         WeCw==
In-Reply-To: <YFsA78FfzICrnFf7@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Arjun Roy <arjunroy.kdev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Jakub Kicinski <kuba@kernel.org>, Yang Shi <shy828301@gmail.com>, Roman Gushchin <guro@fb.com>

On Wed, Mar 24, 2021 at 2:12 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko@suse.com> wrote:
> > >
> > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > [...]
> > > > Here is an idea of how it could work:
> > > >
> > > > struct page already has
> > > >
> > > >                 struct {        /* page_pool used by netstack */
> > > >                         /**
> > > >                          * @dma_addr: might require a 64-bit value even on
> > > >                          * 32-bit architectures.
> > > >                          */
> > > >                         dma_addr_t dma_addr;
> > > >                 };
> > > >
> > > > and as you can see from its union neighbors, there is quite a bit more
> > > > room to store private data necessary for the page pool.
> > > >
> > > > When a page's refcount hits zero and it's a networking page, we can
> > > > feed it back to the page pool instead of the page allocator.
> > > >
> > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > and __release_page(). These functions are already aware of different
> > > > types of pages and do their respective cleanup handling. We can
> > > > similarly make network a first-class citizen and hand pages back to
> > > > the network allocator from in there.
> > >
> > > For compound pages we have a concept of destructors. Maybe we can extend
> > > that for order-0 pages as well. The struct page is heavily packed and
> > > compound_dtor shares the storage without other metadata
> > >                                         int    pages;    /*    16     4 */
> > >                         unsigned char compound_dtor;     /*    16     1 */
> > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > >                         void *     zone_device_data;     /*    16     8 */
> > >
> > > But none of those should really require to be valid when a page is freed
> > > unless I am missing something. It would really require to check their
> > > users whether they can leave the state behind. But if we can establish a
> > > contract that compound_dtor can be always valid when a page is freed
> > > this would be really a nice and useful abstraction because you wouldn't
> > > have to care about the specific type of page.
> > >
> > > But maybe I am just overlooking the real complexity there.
> > > --
> >
> > For now probably the easiest way is to have network pages be first
> > class with a specific flag as previously discussed and have concrete
> > handling for it, rather than trying to establish the contract across
> > page types.
>
> If you are going to claim a page flag then it would be much better to
> have it more generic. Flags are really scarce and if all you care about
> is PageHasDestructor() and provide one via page->dtor then the similar
> mechanism can be reused by somebody else. Or does anything prevent that?

The way I see it - the fundamental want here is, for some arbitrary
page that we are dropping a reference on, to be able to tell that the
provenance of the page is some network driver's page pool. If we added
an enum target to compound_dtor, if we examine that offset in the page
and look at that value, what guarantee do we have that the page isn't
instead some other kind of page, and the byte value there was just
coincidentally the one we were looking for (but it wasn't a network
driver pool page)?

Existing users of compound_dtor seem to check first that a
PageCompound() or PageHead() return true - the specific scenario here,
of receiving network packets, those pages will tend to not be compound
(and more specifically, compound pages are explicitly disallowed for
TCP receive zerocopy).

Given that's the case, the options seem to be:
1) Use a page flag - with the downside that they are a severely
limited resource,
2) Use some bits inside page->memcg_data - this I believe Johannes had
reasons against, and it isn't always the case that MEMCG support is
enabled.
3) Use compound_dtor - but I think this would have problems for the
prior reasons.

Thanks,
-Arjun



> --
> Michal Hocko
> SUSE Labs
