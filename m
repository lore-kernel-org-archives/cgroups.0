From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Wed, 13 Oct 2021 17:06:58 -0700
Message-ID: <YWd0ohzK7RScx9TO@carbon.DHCP.thefacebook.com>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <YWdXv+RBjXvdmsK+@carbon.DHCP.thefacebook.com>
 <CALvZod6ZppPNk2XfvKFfdPhrsSF6NbSBKrOOOc6UyJMfDEfKoQ@mail.gmail.com>
 <YWdoj9FZy2B4oLj8@carbon.DHCP.thefacebook.com>
 <CALvZod7oYyGvHAQVO5fg5eCJefeU1J70iUS6-9k0gQ2S8-y7NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kOIvmYwfcct8O15b9j4U2rcCPpmYFpboayjhaKQdueo=;
 b=qKjrE6h7jRZpk3aFdsB0+/v/ZFLx/RBM2MqCm8pe+2muU4pIfQtlDT1vccAC1kQSvo0R
 CdDZBnAi5zGf5qZ/CGCtTcpbbSgG0PyHbQVbXshJ4cMyZTsZdqwZSzTWasxcZUQFDdYu
 09v6linhDg6nXEAoI072QSw7wtRtF/dJ32Y= 
Content-Disposition: inline
In-Reply-To: <CALvZod7oYyGvHAQVO5fg5eCJefeU1J70iUS6-9k0gQ2S8-y7NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Oct 13, 2021 at 04:45:35PM -0700, Shakeel Butt wrote:
> On Wed, Oct 13, 2021 at 4:15 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> [...]
> > > >
> > > > Isn't it a bit too aggressive?
> > > >
> > > > How about
> > > >     if (WARN_ON_ONCE(gfp & __GFP_ACCOUNT))
> > >
> > > We actually know that kvmalloc(__GFP_ACCOUNT) users exist and can
> > > trigger bulk page allocator through vmalloc, so I don't think the
> > > warning would be any helpful.
> > >
> > > >        gfp &= ~__GFP_ACCOUNT;
> > >
> > > Bulk allocator is best effort, so callers have adequate fallbacks.
> > > Transparently disabling accounting would be unexpected.
> >
> > I see...
> >
> > Shouldn't we then move this check to an upper level?
> >
> > E.g.:
> >
> > if (!(gfp & __GFP_ACCOUNT))
> >    call_into_bulk_allocator();
> > else
> >    call_into_per_page_allocator();
> >
> 
> If we add this check in the upper level (e.g. in vm_area_alloc_pages()
> ) then I think we would need WARN_ON_ONCE(gfp & __GFP_ACCOUNT) in the
> bulk allocator to detect future users.
> 
> At the moment I am more inclined towards this patch's approach. Let's
> say in future we find there is a __GFP_ACCOUNT allocation which can
> benefit from bulk allocator and we decide to add such support in bulk
> allocator then we would not need to change the bulk allocator callers
> at that time just the bulk allocator.

Ok, no objections from me.

Thanks!
