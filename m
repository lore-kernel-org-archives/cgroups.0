From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v3] memcg: enable memory accounting in __alloc_pages_bulk
Date: Tue, 12 Oct 2021 09:08:38 -0700
Message-ID: <CALvZod7LpEY98r=pD-k=WbOT-z=Ux16Mfmv3s7PDtJg6=ZStgw@mail.gmail.com>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
 <60df0efd-f458-a13c-7c89-749bdab21d1d@virtuozzo.com> <YWWrai/ChIgycgCo@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SUSRBbgEONe1rUoJU8RUgo+k+yVw3zQ7WDhpeBulOJo=;
        b=U2adeNOvUPaST/L3dSzVje06TwnmZra9J3YOC3Ib1CnFQxFgTZmUh+QSJm10Oc5t9V
         3XiOM53aTlVLZ+rZhOyYQ3hcLSToUPIHsMGF0LCNQn86Gn/x14THrcqcwrrDrBZLriR8
         5SOd7yfJTgEdDoEiCreoIErh2BIJI4DfV9DAY6U5MGG1phvpd4fOzymvLrXfZ+X3c1Oz
         RuQbvFSJBA8XgOGS741rhWf+98RLMOt0k7375Ww4+8WdRix5eXzY68cRbtp1Q97C0sBZ
         3bLzwD7cZ+yveWz4jdGqUZRUSkRuwauS9FSALhacAiA90OpBjhp6R0NstWF885Z2TPcv
         NnQA==
In-Reply-To: <YWWrai/ChIgycgCo-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Oct 12, 2021 at 8:36 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 12-10-21 17:58:21, Vasily Averin wrote:
> > Enable memory accounting for bulk page allocator.
>
> ENOCHANGELOG
>
> And I have to say I am not very happy about the solution. It adds a very
> tricky code where it splits different charging steps apart.
>
> Would it be just too inefficient to charge page-by-page once all pages
> are already taken away from the pcp lists? This bulk should be small so
> this shouldn't really cause massive problems. I mean something like
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b37435c274cf..8bcd69195ef5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5308,6 +5308,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>
>         local_unlock_irqrestore(&pagesets.lock, flags);
>
> +       if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT)) {
> +               /* charge pages here */
> +       }

It is not that simple because __alloc_pages_bulk only allocate pages
for empty slots in the page_array provided by the caller.

The failure handling for post charging would be more complicated.
