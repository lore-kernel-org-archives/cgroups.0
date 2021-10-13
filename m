From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Wed, 13 Oct 2021 16:15:27 -0700
Message-ID: <YWdoj9FZy2B4oLj8@carbon.DHCP.thefacebook.com>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <YWdXv+RBjXvdmsK+@carbon.DHCP.thefacebook.com>
 <CALvZod6ZppPNk2XfvKFfdPhrsSF6NbSBKrOOOc6UyJMfDEfKoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sNuyzC9OG8MT+XbnK4abuJVvFQkez++T/XhUW8ob6JI=;
 b=HIuu3+2gNyWOY224Vyq3VYchiLJkquirw+xW9dbKSiIXPfqTskGjb+syzDvc+n0efiNb
 R6AH9OabqeLdeYHYi1LGvtkFDZgdPehASWeZPLIZv/HLkxHm01kAz+8v1JQFlywnnFl3
 3gHzg3wGl82Nrwhqwwp8bTjEC02qMAPoEUw= 
Content-Disposition: inline
In-Reply-To: <CALvZod6ZppPNk2XfvKFfdPhrsSF6NbSBKrOOOc6UyJMfDEfKoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Oct 13, 2021 at 03:26:11PM -0700, Shakeel Butt wrote:
> On Wed, Oct 13, 2021 at 3:03 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > On Wed, Oct 13, 2021 at 12:43:38PM -0700, Shakeel Butt wrote:
> > > The commit 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in
> > > __vmalloc_area_node()") switched to bulk page allocator for order 0
> > > allocation backing vmalloc. However bulk page allocator does not support
> > > __GFP_ACCOUNT allocations and there are several users of
> > > kvmalloc(__GFP_ACCOUNT).
> > >
> > > For now make __GFP_ACCOUNT allocations bypass bulk page allocator. In
> > > future if there is workload that can be significantly improved with the
> > > bulk page allocator with __GFP_ACCCOUNT support, we can revisit the
> > > decision.
> > >
> > > Fixes: 5c1f4e690eec ("mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()")
> > > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  mm/page_alloc.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 668edb16446a..b3acad4615d3 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -5215,6 +5215,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> > >       unsigned int alloc_flags = ALLOC_WMARK_LOW;
> > >       int nr_populated = 0, nr_account = 0;
> > >
> > > +     /* Bulk allocator does not support memcg accounting. */
> > > +     if (unlikely(gfp & __GFP_ACCOUNT))
> > > +             goto out;
> > > +
> >
> > Isn't it a bit too aggressive?
> >
> > How about
> >     if (WARN_ON_ONCE(gfp & __GFP_ACCOUNT))
> 
> We actually know that kvmalloc(__GFP_ACCOUNT) users exist and can
> trigger bulk page allocator through vmalloc, so I don't think the
> warning would be any helpful.
> 
> >        gfp &= ~__GFP_ACCOUNT;
> 
> Bulk allocator is best effort, so callers have adequate fallbacks.
> Transparently disabling accounting would be unexpected.

I see...

Shouldn't we then move this check to an upper level?

E.g.:

if (!(gfp & __GFP_ACCOUNT))
   call_into_bulk_allocator();
else
   call_into_per_page_allocator();

Not a big deal, I'm just worried about potential silent memory allocation
failures.

Thanks!
