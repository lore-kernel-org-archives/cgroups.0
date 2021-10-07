From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: memcg memory accounting in vmalloc is broken
Date: Thu, 7 Oct 2021 16:09:29 +0200
Message-ID: <YV7/mS8oIL4E5nmS@dhcp22.suse.cz>
References: <b3c232ff-d9dc-4304-629f-22cc95df1e2e@virtuozzo.com>
 <YV6sIz5UjfbhRyHN@dhcp22.suse.cz>
 <YV6s+ze8LzuxfvOM@dhcp22.suse.cz>
 <953ef8e2-1221-a12c-8f71-e34e477a52e8@virtuozzo.com>
 <0668b6d8-6f8c-07c7-75e0-5448ea87cb54@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633615772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WmZKoam4uBlUDsnpZKT/JNi5wCzxXcwmvOZK6uuOEFg=;
        b=DX00fro/nO0M6nMJsbLq5A59Q930GGbaG5RXcV0COZ9djL12NCiWBy9iyVEHyrkJTosAO7
        BpsNiM1nZ0wyW/3b0NgE9FcTgVDxjhXBMmG2Ix6e0OkQ5wAppcTI0pHu/sAzfpG8K0vGJN
        +BZQY9ZHD0bSulDNGigFjQ4WZ8sZHL0=
Content-Disposition: inline
In-Reply-To: <0668b6d8-6f8c-07c7-75e0-5448ea87cb54-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu 07-10-21 16:00:21, Vlastimil Babka wrote:
> On 10/7/21 10:50, Vasily Averin wrote:
> > On 10/7/21 11:16 AM, Michal Hocko wrote:
> >> Cc Mel and Uladzislau
> >> 
> >> On Thu 07-10-21 10:13:23, Michal Hocko wrote:
> >>> On Thu 07-10-21 11:04:40, Vasily Averin wrote:
> >>>> vmalloc was switched to __alloc_pages_bulk but it does not account the memory to memcg.
> >>>>
> >>>> Is it known issue perhaps?
> >>>
> >>> No, I think this was just overlooked. Definitely doesn't look
> >>> intentional to me.
> > 
> > I use following patch as a quick fix,
> > it helps though it is far from ideal and can be optimized.
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b37435c274cf..e6abe2cac159 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5290,6 +5290,12 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> >  
> >  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
> >  								pcp, pcp_list);
> > +
> > +		if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT) && page &&
> > +		    unlikely(__memcg_kmem_charge_page(page, gfp, 0) != 0)) {
> > +			__free_pages(page, 0);
> 
> It's too early for this here, we didn't go through prep_new_page() yet,
> minimally the post_alloc_hook() -> set_page_refcounted() part, required for
> put_page_testzero() in __free_pages() to work properly, and probably other
> stuff.
> Either do the full prep+free or a minimal reversion of  __rmqueue_pcplist -
> something to just put the page back to pcplist. Probably the former so we
> don't introduce subtle errors.

Very well spotted!
-- 
Michal Hocko
SUSE Labs
