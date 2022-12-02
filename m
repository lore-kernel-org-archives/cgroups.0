From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Fri, 02 Dec 2022 10:01:39 +0800
Message-ID: <87tu2e36nw.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
        <Y35fw2JSAeAddONg@cmpxchg.org>
        <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
        <Y36XchdgTCsMP4jT@cmpxchg.org>
        <874juonbmv.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <Y4ZKgXdUXZ3ycMp4@cmpxchg.org>
        <87wn7dayfz.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHS8izNc=NeMcNudOB0r4aYbZURpU+Y9xpek_KpO=55R+7ec5g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669946569; x=1701482569;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=DUxVs+XVQBl0UL/Tbqjptes7IbkNXXTyQuoYBy96rpk=;
  b=j6dshGYfJbKwqWnN4MuAxALAQwRM98LrhOmPN9c8yLkOYVX/DQLEEUMN
   j9UWv1+dgZLaRYH3laGgTbIRk9YkL6KoEOZkajW2fJzyjjIQPx9cM7TzG
   eRxvHSPzih+0Wm6wKYZOtgPbVeQl7S48Z3qjwmQr//fvxWl86/hAXOqhu
   KHZldeZ+I7A1o+F/9cL3iEJ6/89SffI534jrm8hado448uYtUTeMVOqzI
   zHRKkRem4TpZ3XIrzjKXQj4j38dJHBLcGBcoPzfPYLeSqAAWxdxfloEJ7
   EZfhK3VwhV0nXDFTNWBUBXua/y5AumMxMWuOF1vKQe8DuRPKxT1ikYx8G
   A==;
In-Reply-To: <CAHS8izNc=NeMcNudOB0r4aYbZURpU+Y9xpek_KpO=55R+7ec5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Mina Almasry's message of "Thu, 1 Dec 2022 12:40:16 -0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> On Tue, Nov 29, 2022 at 7:56 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
>>
>> > Hello Ying,
>> >
>> > On Thu, Nov 24, 2022 at 01:51:20PM +0800, Huang, Ying wrote:
>> >> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
>> >> > The fallback to reclaim actually strikes me as wrong.
>> >> >
>> >> > Think of reclaim as 'demoting' the pages to the storage tier. If we
>> >> > have a RAM -> CXL -> storage hierarchy, we should demote from RAM to
>> >> > CXL and from CXL to storage. If we reclaim a page from RAM, it means
>> >> > we 'demote' it directly from RAM to storage, bypassing potentially a
>> >> > huge amount of pages colder than it in CXL. That doesn't seem right.
>> >> >
>> >> > If demotion fails, IMO it shouldn't satisfy the reclaim request by
>> >> > breaking the layering. Rather it should deflect that pressure to the
>> >> > lower layers to make room. This makes sure we maintain an aging
>> >> > pipeline that honors the memory tier hierarchy.
>> >>
>> >> Yes.  I think that we should avoid to fall back to reclaim as much as
>> >> possible too.  Now, when we allocate memory for demotion
>> >> (alloc_demote_page()), __GFP_KSWAPD_RECLAIM is used.  So, we will trigger
>> >> kswapd reclaim on lower tier node to free some memory to avoid fall back
>> >> to reclaim on current (higher tier) node.  This may be not good enough,
>> >> for example, the following patch from Hasan may help via waking up
>> >> kswapd earlier.
>> >>
>> >> https://lore.kernel.org/linux-mm/b45b9bf7cd3e21bca61d82dcd1eb692cd32c122c.1637778851.git.hasanalmaruf-b10kYP2dOMg@public.gmane.org/
>> >>
>> >> Do you know what is the next step plan for this patch?
>> >>
>> >> Should we do even more?
>> >>
>> >> From another point of view, I still think that we can use falling back
>> >> to reclaim as the last resort to avoid OOM in some special situations,
>> >> for example, most pages in the lowest tier node are mlock() or too hot
>> >> to be reclaimed.
>> >
>> > If they're hotter than reclaim candidates on the toptier, shouldn't
>> > they get promoted instead and make room that way? We may have to tweak
>> > the watermark logic a bit to facilitate that (allow promotions where
>> > regular allocations already fail?). But this sort of resorting would
>> > be preferable to age inversions.
>>
>> Now it's legal to enable demotion and disable promotion.  Yes, this is
>> wrong configuration in general.  But should we trigger OOM for these
>> users?
>>
>> And now promotion only works for default NUMA policy (and MPOL_BIND to
>> both promotion source and target nodes with MPOL_F_NUMA_BALANCING).  If
>> we use some other NUMA policy, the pages cannot be promoted too.
>>
>> > The mlock scenario sounds possible. In that case, it wouldn't be an
>> > aging inversion, since there is nothing colder on the CXL node.
>> >
>> > Maybe a bypass check should explicitly consult the demotion target
>> > watermarks against its evictable pages (similar to the file_is_tiny
>> > check in prepare_scan_count)?
>>
>> Yes.  This sounds doable.
>>
>> > Because in any other scenario, if there is a bug in the promo/demo
>> > coordination, I think we'd rather have the OOM than deal with age
>> > inversions causing intermittent performance issues that are incredibly
>> > hard to track down.
>>
>> Previously, I thought that people will always prefer performance
>> regression than OOM.  Apparently, I am wrong.
>>
>> Anyway, I think that we need to reduce the possibility of OOM or falling
>> back to reclaim as much as possible firstly.  Do you agree?
>>
>
> I've been discussing this with a few folks here. I think FWIW general
> feeling here is that demoting from top tier nodes is preferred, except
> in extreme circumstances we would indeed like to run with a
> performance issue rather than OOM a customer VM. I wonder if there is
> another way to debug mis-tiered pages rather than trigger an oom to
> debug.
>
> One thing I think/hope we can trivially agree on is that proactive
> reclaim/demotion is _not_ an extreme circumstance. I would like me or
> someone from the team to follow up with a patch that disables fallback
> to reclaim on proactive reclaim/demotion (sc->proactive).

Yes.  This makes sense to me.

Best Regards,
Huang, Ying

>> One possibility, can we fall back to reclaim only if the sc->priority is
>> small enough (even 0)?
>>
>
> This makes sense to me.
>
>> Best Regards,
>> Huang, Ying
>>
