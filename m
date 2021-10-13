From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v3] memcg: enable memory accounting in __alloc_pages_bulk
Date: Wed, 13 Oct 2021 10:30:05 -0700
Message-ID: <CALvZod5V_NK_mVFY7ik6wSWPxqSqRrhzJkdtuyQjzMB-0yjHGw@mail.gmail.com>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
 <60df0efd-f458-a13c-7c89-749bdab21d1d@virtuozzo.com> <YWWrai/ChIgycgCo@dhcp22.suse.cz>
 <CALvZod7LpEY98r=pD-k=WbOT-z=Ux16Mfmv3s7PDtJg6=ZStgw@mail.gmail.com>
 <YWXS09ZBhZSy6FQQ@dhcp22.suse.cz> <CALvZod6K6UXxDrkHp=mVDV7O-fAtmRkgMDngPazBhcyDUNxy_Q@mail.gmail.com>
 <YWcUbXfBsbNzYIad@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQOoabUNu0R7IbgTfWQ9QRtHLdgX6BHbDT/1BhoTe9M=;
        b=btRQMBymcZokHMewh1RWraDTkJdKm+n2ddZG7Lw2znxC/GSJbWy87egZvb6rXSdldy
         IDXCUqPWaFPmQafIM46OPWdnNjB9VuaJcU33bm66NfS7PNnHNh1b+TblPKadHz2CoEMD
         OePatUFeM/gA764CLWpwIycRbUOXojpKlgVbJwF8yAqXJsZil9DrYE602MkiWjzKEAiV
         JxApHT16J9oA9iZW5O/MGbMxz40m7i6boNVwWnxXxV4GLBMC9wMEpT1pvXcbwFxSBbU1
         Vg8PN+eyytYs/gund8DNu5b4r0AxEaZ153lRDvRPVV4ruMrlDJeTr+sbnEsxtXA9oiOC
         gwog==
In-Reply-To: <YWcUbXfBsbNzYIad-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Wed, Oct 13, 2021 at 10:16 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
> > > If this is really that complicated (I haven't tried) then it would be
> > > much more simple to completely skip the bulk allocator for __GFP_ACCOUNT
> > > rather than add a tricky code. The bulk allocator is meant to be used
> > > for ultra hot paths and memcg charging along with the reclaim doesn't
> > > really fit into that model anyway. Or are there any actual users who
> > > really need bulk allocator optimization and also need memcg accounting?
> >
> > Bulk allocator is being used for vmalloc and we have several
> > kvmalloc() with __GFP_ACCOUNT allocations.
>
> Do we really need to use bulk allocator for these allocations?
> Bulk allocator is an bypass of the page allocator for performance reason
> and I can see why that can be useful but considering that the charging
> path can imply some heavy lifting is all the code churn to make bulk
> allocator memcg aware really worth it? Why cannot we simply skip over
> bulk allocator for __GFP_ACCOUNT. That would be a trivial fix.
> --

Actually that might be the simplest solution and I agree to skip bulk
allocator for __GFP_ACCOUNT allocations.
