From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Thu, 25 Mar 2021 18:50:30 +0100
Message-ID: <YFzNZjuYjIgy1Sb9@dhcp22.suse.cz>
References: <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
 <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz>
 <YFut+cZhsJec7Pud@cmpxchg.org>
 <CAOFY-A0Y0ye74bnpcWsKOPZMJSrFW8mJxVJrpwiy2dcGgUJ5Tw@mail.gmail.com>
 <YFxRpKfwQwobt7IK@dhcp22.suse.cz>
 <YFy+iPiL1YbjjapV@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616694638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1FeCnC7WnMeWEj1gEjR7GjHOI7D/MTEeLRIo3/QZ87I=;
        b=bZAJb6mLyiAMxcYv0r40lqxfJfIz0ihLWV4bk7vzIJNh5hPJ+eEuKDstI9YikR9cKGp6Ll
        TcgCo2d5VBwmadG4q4RyCi0yXJ+VP4ewWHYbqcT0TYOGWe0SgOquLhuLOnytimqlhZVJUk
        2M+e8raAOYjJaSFiw4KyiNuQ+mb6z9I=
Content-Disposition: inline
In-Reply-To: <YFy+iPiL1YbjjapV-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu 25-03-21 12:47:04, Johannes Weiner wrote:
> On Thu, Mar 25, 2021 at 10:02:28AM +0100, Michal Hocko wrote:
> > On Wed 24-03-21 15:49:15, Arjun Roy wrote:
> > > On Wed, Mar 24, 2021 at 2:24 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > >
> > > > On Wed, Mar 24, 2021 at 10:12:46AM +0100, Michal Hocko wrote:
> > > > > On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > > > > > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > >
> > > > > > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > > > > > [...]
> > > > > > > > Here is an idea of how it could work:
> > > > > > > >
> > > > > > > > struct page already has
> > > > > > > >
> > > > > > > >                 struct {        /* page_pool used by netstack */
> > > > > > > >                         /**
> > > > > > > >                          * @dma_addr: might require a 64-bit value even on
> > > > > > > >                          * 32-bit architectures.
> > > > > > > >                          */
> > > > > > > >                         dma_addr_t dma_addr;
> > > > > > > >                 };
> > > > > > > >
> > > > > > > > and as you can see from its union neighbors, there is quite a bit more
> > > > > > > > room to store private data necessary for the page pool.
> > > > > > > >
> > > > > > > > When a page's refcount hits zero and it's a networking page, we can
> > > > > > > > feed it back to the page pool instead of the page allocator.
> > > > > > > >
> > > > > > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > > > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > > > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > > > > > and __release_page(). These functions are already aware of different
> > > > > > > > types of pages and do their respective cleanup handling. We can
> > > > > > > > similarly make network a first-class citizen and hand pages back to
> > > > > > > > the network allocator from in there.
> > > > > > >
> > > > > > > For compound pages we have a concept of destructors. Maybe we can extend
> > > > > > > that for order-0 pages as well. The struct page is heavily packed and
> > > > > > > compound_dtor shares the storage without other metadata
> > > > > > >                                         int    pages;    /*    16     4 */
> > > > > > >                         unsigned char compound_dtor;     /*    16     1 */
> > > > > > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > > > > > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > > > > > >                         void *     zone_device_data;     /*    16     8 */
> > > > > > >
> > > > > > > But none of those should really require to be valid when a page is freed
> > > > > > > unless I am missing something. It would really require to check their
> > > > > > > users whether they can leave the state behind. But if we can establish a
> > > > > > > contract that compound_dtor can be always valid when a page is freed
> > > > > > > this would be really a nice and useful abstraction because you wouldn't
> > > > > > > have to care about the specific type of page.
> > > >
> > > > Yeah technically nobody should leave these fields behind, but it
> > > > sounds pretty awkward to manage an overloaded destructor with a
> > > > refcounted object:
> > > >
> > > > Either every put would have to check ref==1 before to see if it will
> > > > be the one to free the page, and then set up the destructor before
> > > > putting the final ref. But that means we can't support lockless
> > > > tryget() schemes like we have in the page cache with a destructor.
> > 
> > I do not follow the ref==1 part. I mean to use the hugetlb model where
> > the destructore is configured for the whole lifetime until the page is
> > freed back to the allocator (see below).
> 
> That only works if the destructor field doesn't overlap with a member
> the page type itself doesn't want to use. Page types that do want to
> use it would need to keep that field exclusive.

Right.

> We couldn't use it for LRU pages e.g. because it overlaps with the
> lru.next pointer.

Dang, I have completely missed this. I was looking at pahole because
struct page is unreadable in the C code but I tricked myself to only
look at offset 16. The initial set of candidate looked really
promissing. But overlapping with list_head is a deal breaker. This makes
use of dtor for most order-0 pages indeed unfeasible. Maybe dtor can be
rellocated but that is certain a rabbit hole people (rightfully) avoid
as much as possible. So you are right and going with networking specific
way is more reasonable.

[...]
> So again, yes it would be nice to have generic destructors, but I just
> don't see how it's practical.

just to clarify on this. I didn't really mean to use this mechanism to
all/most pages I just wanted to have PageHasDestructor rather than
PageNetwork because both would express a special nead for freeing but
that would require that the dtor would be outside of lru.

Thanks!
-- 
Michal Hocko
SUSE Labs
