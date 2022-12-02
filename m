From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Fri, 02 Dec 2022 09:57:23 +0800
Message-ID: <87y1rq36v0.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
        <Y35fw2JSAeAddONg@cmpxchg.org>
        <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
        <Y36XchdgTCsMP4jT@cmpxchg.org>
        <874juonbmv.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHbLzkrmxyzH4R7a9sJQavrUyKCEiNYeA543+sdJLsgRPrwBwQ@mail.gmail.com>
        <87a64ad1iz.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHbLzkpVZf-3K0Ys8HG8x6D_XpPChB-H2XMYar7UwnNDeMiw8w@mail.gmail.com>
        <87ilixatyw.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHbLzkr_njh2xtAf6RME_Fe0TgTKdC4mcsUe24orqVScjibUrA@mail.gmail.com>
        <87h6yfao37.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <CAHbLzkr9k8fvBGVskN1sMJiLX_JkWW7OrrscUrA0xASh+rYN7Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669946306; x=1701482306;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=fysh+aff57z8wg2qjnJH7xE46wjuAEx2ebPXMdqJugw=;
  b=bmSscclBGAgE/516zgCi+NkxBPVwEkNizJUrpcTyHjTitBvtmCYF/ogb
   DDwLj8xVsnmOdUe+FlzdIs09tNDObFEhWF6Khyq4yD9Ad1BN8L5A9PcDu
   gl05TK/wXlwHmXPVYwTWVANjJ8N3EYXmvHHbByQxWdd+mO7qSkM7b1btV
   glh4+AYF6+xpysZKda8F22IxJD5OLUeYKAWEoyfALxzn27ZBT8qoHGs+I
   qUgGFFyFWDll/HQ6MmnRiumRJY7tKDJEGbfrLrz4WCtn9mZS/NSgYy4WA
   VcCjXdSOhN+Jhxs/YM39JUgkw38dOL47vZtSnR6Q0CarFoGLfWpKGzOy+
   w==;
In-Reply-To: <CAHbLzkr9k8fvBGVskN1sMJiLX_JkWW7OrrscUrA0xASh+rYN7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Yang Shi's message of "Thu, 1 Dec 2022 14:45:36 -0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> On Wed, Nov 30, 2022 at 5:52 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>> > On Tue, Nov 29, 2022 at 9:33 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >> Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> >>
>> >> > On Mon, Nov 28, 2022 at 4:54 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >> >>
>> >> >> Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>> >> >>
>> >> >> > On Wed, Nov 23, 2022 at 9:52 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >> >> >>
>> >> >> >> Hi, Johannes,
>> >> >> >>
>> >> >> >> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
>> >> >> >> [...]
>> >> >> >> >
>> >> >> >> > The fallback to reclaim actually strikes me as wrong.
>> >> >> >> >
>> >> >> >> > Think of reclaim as 'demoting' the pages to the storage tier. If we
>> >> >> >> > have a RAM -> CXL -> storage hierarchy, we should demote from RAM to
>> >> >> >> > CXL and from CXL to storage. If we reclaim a page from RAM, it means
>> >> >> >> > we 'demote' it directly from RAM to storage, bypassing potentially a
>> >> >> >> > huge amount of pages colder than it in CXL. That doesn't seem right.
>> >> >> >> >
>> >> >> >> > If demotion fails, IMO it shouldn't satisfy the reclaim request by
>> >> >> >> > breaking the layering. Rather it should deflect that pressure to the
>> >> >> >> > lower layers to make room. This makes sure we maintain an aging
>> >> >> >> > pipeline that honors the memory tier hierarchy.
>> >> >> >>
>> >> >> >> Yes.  I think that we should avoid to fall back to reclaim as much as
>> >> >> >> possible too.  Now, when we allocate memory for demotion
>> >> >> >> (alloc_demote_page()), __GFP_KSWAPD_RECLAIM is used.  So, we will trigger
>> >> >> >> kswapd reclaim on lower tier node to free some memory to avoid fall back
>> >> >> >> to reclaim on current (higher tier) node.  This may be not good enough,
>> >> >> >> for example, the following patch from Hasan may help via waking up
>> >> >> >> kswapd earlier.
>> >> >> >
>> >> >> > For the ideal case, I do agree with Johannes to demote the page tier
>> >> >> > by tier rather than reclaiming them from the higher tiers. But I also
>> >> >> > agree with your premature OOM concern.
>> >> >> >
>> >> >> >>
>> >> >> >> https://lore.kernel.org/linux-mm/b45b9bf7cd3e21bca61d82dcd1eb692cd32c122c.1637778851.git.hasanalmaruf-b10kYP2dOMg@public.gmane.org/
>> >> >> >>
>> >> >> >> Do you know what is the next step plan for this patch?
>> >> >> >>
>> >> >> >> Should we do even more?
>> >> >> >
>> >> >> > In my initial implementation I implemented a simple throttle logic
>> >> >> > when the demotion is not going to succeed if the demotion target has
>> >> >> > not enough free memory (just check the watermark) to make migration
>> >> >> > succeed without doing any reclamation. Shall we resurrect that?
>> >> >>
>> >> >> Can you share the link to your throttle patch?  Or paste it here?
>> >> >
>> >> > I just found this on the mailing list.
>> >> > https://lore.kernel.org/linux-mm/1560468577-101178-8-git-send-email-yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org/
>> >>
>> >> Per my understanding, this patch will avoid demoting if there's no free
>> >> space on demotion target?  If so, I think that we should trigger kswapd
>> >> reclaiming on demotion target before that.  And we can simply avoid to
>> >> fall back to reclaim firstly, then avoid to scan as an improvement as
>> >> that in your patch above.
>> >
>> > Yes, it should. The rough idea looks like:
>> >
>> > if (the demote target is contended)
>> >     wake up kswapd
>> >     reclaim_throttle(VMSCAN_THROTTLE_DEMOTION)
>> >     retry demotion
>> >
>> > The kswapd is responsible for clearing the contention flag.
>>
>> We may do this, at least for demotion in kswapd.  But I think that this
>> could be the second step optimization after we make correct choice
>> between demotion/reclaim.  What if the pages in demotion target is too
>> hot to be reclaimed first?  Should we reclaim in fast memory node to
>> avoid OOM?
>
> IMHO we can't avoid reclaiming from the fast nodes entirely if we
> prioritize avoiding OOMs.

Yes.  I think so too.

> But it should happen very very rarely with the throttling logic or
> other methods.

Yes.  I think that this is possible.

> BTW did you run any test to see how many times vmscan reclaims from
> fast nodes instead of demotion with the current implementation for
> some typical workloads?

No.  I haven't done that.

Best Regards,
Huang, Ying

>>
>> >>
>> >> > But it didn't have the throttling logic, I may not submit that version
>> >> > to the mailing list since we decided to drop this and merge mine and
>> >> > Dave's.
>> >> >
>> >> > Anyway it is not hard to add the throttling logic, we already have a
>> >> > few throttling cases in vmscan, for example, "mm/vmscan: throttle
>> >> > reclaim until some writeback completes if congested".
>> >> >>
>> >> >> > Waking kswapd sooner is fine to me, but it may be not enough, for
>> >> >> > example, the kswapd may not keep up so remature OOM may happen on
>> >> >> > higher tiers or reclaim may still happen. I think throttling the
>> >> >> > reclaimer/demoter until kswapd makes progress could avoid both. And
>> >> >> > since the lower tiers memory typically is quite larger than the higher
>> >> >> > tiers, so the throttle should happen very rarely IMHO.
>> >> >> >
>> >> >> >>
>> >> >> >> From another point of view, I still think that we can use falling back
>> >> >> >> to reclaim as the last resort to avoid OOM in some special situations,
>> >> >> >> for example, most pages in the lowest tier node are mlock() or too hot
>> >> >> >> to be reclaimed.
>> >> >> >>
>> >> >> >> > So I'm hesitant to design cgroup controls around the current behavior.
>> >> >>
>> >> >> Best Regards,
>> >> >> Huang, Ying
