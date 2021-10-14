From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 08:01:16 -0700
Message-ID: <CALvZod4Br9iwq-qfdwj6dzgW2g1vEr2YL4=w_mQjOeWWDQzFjw@mail.gmail.com>
References: <20211013194338.1804247-1-shakeelb@google.com> <YWfZNF7T7Fm69sik@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7BgPbMZUg3AHIPgZBVoqfyExpxLxFLTly+c7L8vjvng=;
        b=EtQS7B1AIWL9XFdEes5Dd/g1277fNmryyfdb+sMr26dYVhXPs2hcQ8HJVpr3gwACIM
         ZB9qrXIzQ4oCn+3yIYMoCKeQ39Y/9PVMkmWvGzNYfXTZX/2B+zekABjJzUSBeOqOjTZ4
         PL4Q1C4V7CN5kslWMxr/cHoRzdi7s2LmYwnvkrsRR6Lvk+26uQ495rDHhKxfJWs2acgO
         +2ZTX9V6PdVRBNj2r8R1YHOaL40ky3yYNfQ/teOP2qx5qqZwaz/ynOyBj2B0a17/x/bO
         xl0N5oovJudgWPf/FH36Wml2+J9OcE/tAh87QEXuqiqX3dajD52YWwzNwc7ejn0/oEyq
         ckCw==
In-Reply-To: <YWfZNF7T7Fm69sik-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Oct 14, 2021 at 12:16 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 13-10-21 12:43:38, Shakeel Butt wrote:
> [...]
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 668edb16446a..b3acad4615d3 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5215,6 +5215,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
> >       unsigned int alloc_flags = ALLOC_WMARK_LOW;
> >       int nr_populated = 0, nr_account = 0;
> >
> > +     /* Bulk allocator does not support memcg accounting. */
> > +     if (unlikely(gfp & __GFP_ACCOUNT))
> > +             goto out;
>
> Did you mean goto failed here? This would break some which do not
> have any fallback. E.g. xfs_buf_alloc_pages but likely more.
>
> Sorry I could have been more specific when talking about bypassing the
> bulk allocator. It is quite confusing because the bulk allocator
> interface consists of the bulk allocator and the fallback to the normal
> page allocator.
>

I did consider 'goto failed' here but for that I have to move
__GFP_ACCOUNT check after the "Already populated array" check in the
function. Basically what's the point of doing other operations
(incrementing nr_populated) if we are gonna skip bulk anyways.

Regarding xfs_buf_alloc_pages(), it is not using __GFP_ACCOUNT and
vmalloc() is the only __GFP_ACCOUNT user at this point. So, not an
issue for now but I suppose it is better to be future-proof and do the
'goto failed'.

Let me know what you think.
