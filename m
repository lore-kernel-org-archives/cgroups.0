From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 23 Mar 2021 15:34:20 +0100
Message-ID: <YFn8bLBMt7txj3AZ@dhcp22.suse.cz>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org>
 <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616510061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U6AYmAE3axZU7Y0KUT99DSxo5RPJIf5s+7Dy88I1Wdg=;
        b=vUoROcuhUJ8TVeKb7PORfNjQR1dmz/iSaXTllYT7iJQTfH0qjQLXrU+7jK2uLB7GR2hoFG
        m+8V9mml9J2vpquf2lzURMMvfwwKcmQCcNKfWXvUV0odfTIdwUgQSOhBILiplh1EFx4ucw
        ppXcwU9GX3xYTiamctYDF0mhMZc1NBQ=
Content-Disposition: inline
In-Reply-To: <YFJ+5+NBOBiUbGWS-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Wed 17-03-21 18:12:55, Johannes Weiner wrote:
[...]
> Here is an idea of how it could work:
> 
> struct page already has
> 
>                 struct {        /* page_pool used by netstack */
>                         /**
>                          * @dma_addr: might require a 64-bit value even on
>                          * 32-bit architectures.
>                          */
>                         dma_addr_t dma_addr;
>                 };
> 
> and as you can see from its union neighbors, there is quite a bit more
> room to store private data necessary for the page pool.
> 
> When a page's refcount hits zero and it's a networking page, we can
> feed it back to the page pool instead of the page allocator.
> 
> From a first look, we should be able to use the PG_owner_priv_1 page
> flag for network pages (see how this flag is overloaded, we can add a
> PG_network alias). With this, we can identify the page in __put_page()
> and __release_page(). These functions are already aware of different
> types of pages and do their respective cleanup handling. We can
> similarly make network a first-class citizen and hand pages back to
> the network allocator from in there.

For compound pages we have a concept of destructors. Maybe we can extend
that for order-0 pages as well. The struct page is heavily packed and
compound_dtor shares the storage without other metadata
                                        int    pages;    /*    16     4 */
                        unsigned char compound_dtor;     /*    16     1 */
                        atomic_t   hpage_pinned_refcount; /*    16     4 */
                        pgtable_t  pmd_huge_pte;         /*    16     8 */
                        void *     zone_device_data;     /*    16     8 */

But none of those should really require to be valid when a page is freed
unless I am missing something. It would really require to check their
users whether they can leave the state behind. But if we can establish a
contract that compound_dtor can be always valid when a page is freed
this would be really a nice and useful abstraction because you wouldn't
have to care about the specific type of page.

But maybe I am just overlooking the real complexity there.
-- 
Michal Hocko
SUSE Labs
