From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Tue, 29 Nov 2022 08:53:24 +0800
Message-ID: <87a64ad1iz.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
        <Y35fw2JSAeAddONg@cmpxchg.org>
        <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
        <Y36XchdgTCsMP4jT@cmpxchg.org>
        <874juonbmv.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHbLzkrmxyzH4R7a9sJQavrUyKCEiNYeA543+sdJLsgRPrwBwQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669683278; x=1701219278;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=4P2+jl1RIyYOuHVHfl3LKEnthZGh8okJ/3m5N/abcaU=;
  b=mv0eUFejlhHqmi48wjkhbZxd7n2qUEVnd/VcS7i/wSTBV3B92KaePOW9
   +xFQNawG1eiZmktgVRS3/02RcyJIPtlIcjprNaWp88gLxfy2Te2mr1XWi
   2wgGFiU0cgW5qvi9yjMyLnq3wtcXDrOYxVzYVH5/VZSnDjjcN7K6Z8Inq
   5NSt5L3hLT+fTgctUi+REtD10jNkfEj4AjYGzDCqiZZVZHuaSlKkfXETI
   ae+nEdfU5RHaxbMa0fhBUtz03nPJk228fcyuz8OFdBw6VejG9pThhlIBT
   TpJDcBXQo2DaJsL3cOERuw7ReAbsAX5quNkN/x3d6CWYQEmWCy3Oh4io3
   w==;
In-Reply-To: <CAHbLzkrmxyzH4R7a9sJQavrUyKCEiNYeA543+sdJLsgRPrwBwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Yang Shi's message of "Mon, 28 Nov 2022 14:24:03 -0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On Wed, Nov 23, 2022 at 9:52 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hi, Johannes,
>>
>> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
>> [...]
>> >
>> > The fallback to reclaim actually strikes me as wrong.
>> >
>> > Think of reclaim as 'demoting' the pages to the storage tier. If we
>> > have a RAM -> CXL -> storage hierarchy, we should demote from RAM to
>> > CXL and from CXL to storage. If we reclaim a page from RAM, it means
>> > we 'demote' it directly from RAM to storage, bypassing potentially a
>> > huge amount of pages colder than it in CXL. That doesn't seem right.
>> >
>> > If demotion fails, IMO it shouldn't satisfy the reclaim request by
>> > breaking the layering. Rather it should deflect that pressure to the
>> > lower layers to make room. This makes sure we maintain an aging
>> > pipeline that honors the memory tier hierarchy.
>>
>> Yes.  I think that we should avoid to fall back to reclaim as much as
>> possible too.  Now, when we allocate memory for demotion
>> (alloc_demote_page()), __GFP_KSWAPD_RECLAIM is used.  So, we will trigger
>> kswapd reclaim on lower tier node to free some memory to avoid fall back
>> to reclaim on current (higher tier) node.  This may be not good enough,
>> for example, the following patch from Hasan may help via waking up
>> kswapd earlier.
>
> For the ideal case, I do agree with Johannes to demote the page tier
> by tier rather than reclaiming them from the higher tiers. But I also
> agree with your premature OOM concern.
>
>>
>> https://lore.kernel.org/linux-mm/b45b9bf7cd3e21bca61d82dcd1eb692cd32c122c.1637778851.git.hasanalmaruf-b10kYP2dOMg@public.gmane.org/
>>
>> Do you know what is the next step plan for this patch?
>>
>> Should we do even more?
>
> In my initial implementation I implemented a simple throttle logic
> when the demotion is not going to succeed if the demotion target has
> not enough free memory (just check the watermark) to make migration
> succeed without doing any reclamation. Shall we resurrect that?

Can you share the link to your throttle patch?  Or paste it here?

> Waking kswapd sooner is fine to me, but it may be not enough, for
> example, the kswapd may not keep up so remature OOM may happen on
> higher tiers or reclaim may still happen. I think throttling the
> reclaimer/demoter until kswapd makes progress could avoid both. And
> since the lower tiers memory typically is quite larger than the higher
> tiers, so the throttle should happen very rarely IMHO.
>
>>
>> From another point of view, I still think that we can use falling back
>> to reclaim as the last resort to avoid OOM in some special situations,
>> for example, most pages in the lowest tier node are mlock() or too hot
>> to be reclaimed.
>>
>> > So I'm hesitant to design cgroup controls around the current behavior.

Best Regards,
Huang, Ying
