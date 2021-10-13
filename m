From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Wed, 13 Oct 2021 16:45:35 -0700
Message-ID: <CALvZod7oYyGvHAQVO5fg5eCJefeU1J70iUS6-9k0gQ2S8-y7NQ@mail.gmail.com>
References: <20211013194338.1804247-1-shakeelb@google.com> <YWdXv+RBjXvdmsK+@carbon.DHCP.thefacebook.com>
 <CALvZod6ZppPNk2XfvKFfdPhrsSF6NbSBKrOOOc6UyJMfDEfKoQ@mail.gmail.com> <YWdoj9FZy2B4oLj8@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIPgO8yQiZn6tL7PQw0ynB/vmiHfdbnsw7Yxik4Gs5c=;
        b=Zo/oxYeUHUiu5epy5RMTUChC69BfvR/wzXIz5N5eUMfhimDPUDYzklPhtmFozV4kR2
         nql9Z92aM87i6pjK6Xmv7cDjU1nKQ8VNvISZjUcdFcl7sX54/5sivvQJF0112hHD5cAu
         6FSMFfQxpW8Bhe8w72Ns8DjQaO2vBG6jBTMjYQV4l81pQMst03i4Drd2f9IF2na682+u
         HpGrHoNfUa0Gg0sRUqFJbuOs+PoVDiErmce946h8Kc/RfXxI9lviBiTCLqjrAlsVcFt2
         tYwVoR5zv7LJqtTFU0rkKAiE4bscZAQWKs3CO77dpKj2PYCI1awVeJ1tAWTq6ZcVwPKh
         tq8g==
In-Reply-To: <YWdoj9FZy2B4oLj8@carbon.DHCP.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Uladzislau Rezki <urezki@gmail.com>, Vasily Averin <vvs@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Oct 13, 2021 at 4:15 PM Roman Gushchin <guro@fb.com> wrote:
>
[...]
> > >
> > > Isn't it a bit too aggressive?
> > >
> > > How about
> > >     if (WARN_ON_ONCE(gfp & __GFP_ACCOUNT))
> >
> > We actually know that kvmalloc(__GFP_ACCOUNT) users exist and can
> > trigger bulk page allocator through vmalloc, so I don't think the
> > warning would be any helpful.
> >
> > >        gfp &= ~__GFP_ACCOUNT;
> >
> > Bulk allocator is best effort, so callers have adequate fallbacks.
> > Transparently disabling accounting would be unexpected.
>
> I see...
>
> Shouldn't we then move this check to an upper level?
>
> E.g.:
>
> if (!(gfp & __GFP_ACCOUNT))
>    call_into_bulk_allocator();
> else
>    call_into_per_page_allocator();
>

If we add this check in the upper level (e.g. in vm_area_alloc_pages()
) then I think we would need WARN_ON_ONCE(gfp & __GFP_ACCOUNT) in the
bulk allocator to detect future users.

At the moment I am more inclined towards this patch's approach. Let's
say in future we find there is a __GFP_ACCOUNT allocation which can
benefit from bulk allocator and we decide to add such support in bulk
allocator then we would not need to change the bulk allocator callers
at that time just the bulk allocator.
