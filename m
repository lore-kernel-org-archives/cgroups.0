From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 01:08:36 +0100
Message-ID: <YWd1BDuTinjTYXpH@casper.infradead.org>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <YWdXv+RBjXvdmsK+@carbon.DHCP.thefacebook.com>
 <CALvZod6ZppPNk2XfvKFfdPhrsSF6NbSBKrOOOc6UyJMfDEfKoQ@mail.gmail.com>
 <YWdoj9FZy2B4oLj8@carbon.DHCP.thefacebook.com>
 <CALvZod7oYyGvHAQVO5fg5eCJefeU1J70iUS6-9k0gQ2S8-y7NQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hwqhlhPOT3W8YxWprAXqKn5R1vpF1HMQTFeRCeyMhDw=; b=FoKN+/qrHz5uAO/YI3Jw7+DfcS
        wey8+yMn4jVTVdQoGQuytIvGWdeySGGmeXw6g9Cgzuo5y39x//Bf9qZFSnjr7kpg7ByYCy+gSATky
        682oPpANaPCttnbqHXfhwTYUHCodIC0TpKPuasCtPIbPzsYUecJz6k54iC6qXbUTt3Q+eSxyRyXE4
        LF/4GcKiTPXlxiOSIWf0UtbgyI+K84SVRgiAzeuPHJdW8/DMbLp/ul8hfUnODBK4CJIHXwIFAIgy+
        P0NEXXPdWRqWAdTnveAGZjFyh5yjv3miio+kzwuf4DIOFrjSUiw/Ey8u5DS35slALKBx3vT3XtGtW
        OshMlsug==;
Content-Disposition: inline
In-Reply-To: <CALvZod7oYyGvHAQVO5fg5eCJefeU1J70iUS6-9k0gQ2S8-y7NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

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

I agree with you.  Let's apply the patch as-is.
