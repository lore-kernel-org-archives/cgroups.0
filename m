From: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 24 Mar 2021 15:49:15 -0700
Message-ID: <CAOFY-A0Y0ye74bnpcWsKOPZMJSrFW8mJxVJrpwiy2dcGgUJ5Tw@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
 <CAOFY-A22Pp3Z0apYBWtOJCD8TxfrbZ_HE9Xd6eUds8aEvRL+uw@mail.gmail.com>
 <YFsA78FfzICrnFf7@dhcp22.suse.cz> <YFut+cZhsJec7Pud@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CnG9+rCYeZJOIO9wMA1OXXczz9AhODbjeHBnYJ2S+dQ=;
        b=eTp2wE3KCcGL21ofZv6+GyxjukrFrzM4orBTTCdTZi62hw3w9tW9Q7zv2c01Al6gsO
         97oQPxXzoeZKpLW8VSCq8NNFKYBlBiUZmZNJp3pJdLjTKwSJ8zzLXffVO6p/zEuJ+lp9
         Wqw+/wIvYMInmyLsmfJ2b4PEDWD58m2Ihzg4GKOgh6D3ydDkAE1KZEBCxIUEnIxM3pHH
         PfHP/whaBXAVlYcwax2Ci/U2I1x3kFfXHFXSdNYCZxR5WQZ0jns6WPKbBk4oZWTel0k7
         ro/niqhhCx94gnqMkOkn1iAWzkkLRUs7mXITMVx5WaYhy391bq59krI9cSMJSzYUaFMr
         ocAQ==
In-Reply-To: <YFut+cZhsJec7Pud-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Wed, Mar 24, 2021 at 2:24 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Mar 24, 2021 at 10:12:46AM +0100, Michal Hocko wrote:
> > On Tue 23-03-21 11:47:54, Arjun Roy wrote:
> > > On Tue, Mar 23, 2021 at 7:34 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
> > > > [...]
> > > > > Here is an idea of how it could work:
> > > > >
> > > > > struct page already has
> > > > >
> > > > >                 struct {        /* page_pool used by netstack */
> > > > >                         /**
> > > > >                          * @dma_addr: might require a 64-bit value even on
> > > > >                          * 32-bit architectures.
> > > > >                          */
> > > > >                         dma_addr_t dma_addr;
> > > > >                 };
> > > > >
> > > > > and as you can see from its union neighbors, there is quite a bit more
> > > > > room to store private data necessary for the page pool.
> > > > >
> > > > > When a page's refcount hits zero and it's a networking page, we can
> > > > > feed it back to the page pool instead of the page allocator.
> > > > >
> > > > > From a first look, we should be able to use the PG_owner_priv_1 page
> > > > > flag for network pages (see how this flag is overloaded, we can add a
> > > > > PG_network alias). With this, we can identify the page in __put_page()
> > > > > and __release_page(). These functions are already aware of different
> > > > > types of pages and do their respective cleanup handling. We can
> > > > > similarly make network a first-class citizen and hand pages back to
> > > > > the network allocator from in there.
> > > >
> > > > For compound pages we have a concept of destructors. Maybe we can extend
> > > > that for order-0 pages as well. The struct page is heavily packed and
> > > > compound_dtor shares the storage without other metadata
> > > >                                         int    pages;    /*    16     4 */
> > > >                         unsigned char compound_dtor;     /*    16     1 */
> > > >                         atomic_t   hpage_pinned_refcount; /*    16     4 */
> > > >                         pgtable_t  pmd_huge_pte;         /*    16     8 */
> > > >                         void *     zone_device_data;     /*    16     8 */
> > > >
> > > > But none of those should really require to be valid when a page is freed
> > > > unless I am missing something. It would really require to check their
> > > > users whether they can leave the state behind. But if we can establish a
> > > > contract that compound_dtor can be always valid when a page is freed
> > > > this would be really a nice and useful abstraction because you wouldn't
> > > > have to care about the specific type of page.
>
> Yeah technically nobody should leave these fields behind, but it
> sounds pretty awkward to manage an overloaded destructor with a
> refcounted object:
>
> Either every put would have to check ref==1 before to see if it will
> be the one to free the page, and then set up the destructor before
> putting the final ref. But that means we can't support lockless
> tryget() schemes like we have in the page cache with a destructor.
>

Ah, I think I see what you were getting at with your prior email - at
first I thought your suggestion was that, since the driver may have
its own refcount, every put would need to check ref == 1 and call into
the driver if need be.

Instead, and correct me if I'm wrong, it seems like what you're advocating is:
1) The (opted in) driver no longer hangs onto the ref,
2) Now refcount can go all the way to 0,
3) And when it does, due to the special destructor this page has, it
goes back to the driver, rather than the system?


> Or you'd have to set up the destructor every time an overloaded field
> reverts to its null state, e.g. hpage_pinned_refcount goes back to 0.
>
> Neither of those sound practical to me.
>




> > > > But maybe I am just overlooking the real complexity there.
> > > > --
> > >
> > > For now probably the easiest way is to have network pages be first
> > > class with a specific flag as previously discussed and have concrete
> > > handling for it, rather than trying to establish the contract across
> > > page types.
> >
> > If you are going to claim a page flag then it would be much better to
> > have it more generic. Flags are really scarce and if all you care about
> > is PageHasDestructor() and provide one via page->dtor then the similar
> > mechanism can be reused by somebody else. Or does anything prevent that?
>
> I was suggesting to alias PG_owner_priv_1, which currently isn't used
> on network pages. We don't need to allocate a brandnew page flag.
>

Just to be certain, is there any danger of having a page, that would
not be a network driver page originally, being inside __put_page(),
such that PG_owner_priv_1 is set (but with one of its other overloaded
meanings)?

Thanks,
-Arjun

> I agree that a generic destructor for order-0 pages would be nice, but
> due to the decentralized nature of refcounting the only way I think it
> would work in practice is by adding a new field to struct page that is
> not in conflict with any existing ones.
>
> Comparably, creating a network type page consumes no additional space.
