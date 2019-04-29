From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg, oom: no oom-kill for __GFP_RETRY_MAYFAIL
Date: Mon, 29 Apr 2019 07:37:08 -0700
Message-ID: <CALvZod6-EOAkcuiuBpoE6uR2DFNUkUY8syHxenFEAZTxhgNMhQ@mail.gmail.com>
References: <20190428235613.166330-1-shakeelb@google.com> <20190429122214.GK21837@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/6XEsIqR8VWQpLXIhH0FRoDcnonKS2KQt8PYqdEcmQ=;
        b=ms9nqUQx6QnRoflbPjYgEjlFy2Y9D0/6+0G9VqgYNlscBxoReHFFvdNWni+KPvrniA
         LyI6meDC6xaCQQcZpNBsWnausZSGUkfQLsxB2kAWos+57OQ52Pucuo8tCUdUsIudCDHZ
         vElK/QYsTago67Nbpl89mqFDK5RGuySBGU82zoLexyXiz1juRlqppKtH90OmOxaXTtwX
         Fio82mWAZZel9R/jB+y1QQYy4IHkRmjTMwdLDcuhsJpgFPqDu7u+6OKrhzVYEH2LN4R6
         NvvyeAIeOtREkegp0JCSBfdKaIbf9KB9vV7F6z0b5Xawd5KXDHlUeFFLCsrW3vW8G+Cx
         KX1A==
In-Reply-To: <20190429122214.GK21837@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Apr 29, 2019 at 5:22 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Sun 28-04-19 16:56:13, Shakeel Butt wrote:
> > The documentation of __GFP_RETRY_MAYFAIL clearly mentioned that the
> > OOM killer will not be triggered and indeed the page alloc does not
> > invoke OOM killer for such allocations. However we do trigger memcg
> > OOM killer for __GFP_RETRY_MAYFAIL. Fix that.
>
> An example of __GFP_RETRY_MAYFAIL memcg OOM report would be nice. I
> thought we haven't been using that flag for memcg allocations yet.
> But this is definitely good to have addressed.

Actually I am planning to use it for memcg allocations (specifically
fsnotify allocations).

>
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
>
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

>
> > ---
> >  mm/memcontrol.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 2713b45ec3f0..99eca724ed3b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2294,7 +2294,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >       unsigned long nr_reclaimed;
> >       bool may_swap = true;
> >       bool drained = false;
> > -     bool oomed = false;
> >       enum oom_status oom_status;
> >
> >       if (mem_cgroup_is_root(memcg))
> > @@ -2381,7 +2380,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >       if (nr_retries--)
> >               goto retry;
> >
> > -     if (gfp_mask & __GFP_RETRY_MAYFAIL && oomed)
> > +     if (gfp_mask & __GFP_RETRY_MAYFAIL)
> >               goto nomem;
> >
> >       if (gfp_mask & __GFP_NOFAIL)
> > @@ -2400,7 +2399,6 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >       switch (oom_status) {
> >       case OOM_SUCCESS:
> >               nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> > -             oomed = true;
> >               goto retry;
> >       case OOM_FAILED:
> >               goto force;
> > --
> > 2.21.0.593.g511ec345e18-goog
> >
>
> --
> Michal Hocko
> SUSE Labs
