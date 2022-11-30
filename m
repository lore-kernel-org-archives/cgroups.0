From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Tue, 29 Nov 2022 22:06:57 -0800
Message-ID: <CAHS8izM6_uUSqWjMAOoMgNup9ZMsB9n_9CMpdW1Y=T558hLHwQ@mail.gmail.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
 <Y35fw2JSAeAddONg@cmpxchg.org> <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
 <Y36XchdgTCsMP4jT@cmpxchg.org> <874juonbmv.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <CAHS8izMhoHVCGxXGt8qRtf-fPpAR8=pTy7Rc3j2=Wf8vJz-C+g@mail.gmail.com> <87edtlatmg.fsf@yhuang6-desk2.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FWjVwsfaKDFRr8VkwYzgxCXQbcwfzKH8w2b9Cg9S3Qg=;
        b=G7O5bwbCEbvRUawdrMo0STCjIPBtikhsjYt5P2BbfdIgSX/6UUKrw+39wtAX3MzM3l
         asRuDPtvRAgh9vfobCy2BwwtQccULYWiaOcNFO0s4JiArEE6S4merDcjjJsdaJxZO0Lo
         uPyC5dNSHfSqryuTnefPXdCvzQOqfMVQT1Q5liZOs7a+r98V2iHJSORCQLhj5X1mLHFe
         MKbxTUXDzXCaXA12A8ibCEedbfC3hBGfeE9kq4l2Mn92IXBHHaT4/l2FjByD6fgQMBs1
         hsWd6zuklbsRveIaFWwQa160MDjpU6F/UlFuI+0fLDn7OEOjdi3/Uh7m10etrOAQZAux
         ZHaA==
In-Reply-To: <87edtlatmg.fsf-fFUE1NP8JkzwuUmzmnQr+vooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Nov 29, 2022 at 9:40 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> > On Wed, Nov 23, 2022 at 9:52 PM Huang, Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> Hi, Johannes,
> >>
> >> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
> >> [...]
> >> >
> >> > The fallback to reclaim actually strikes me as wrong.
> >> >
> >> > Think of reclaim as 'demoting' the pages to the storage tier. If we
> >> > have a RAM -> CXL -> storage hierarchy, we should demote from RAM to
> >> > CXL and from CXL to storage. If we reclaim a page from RAM, it means
> >> > we 'demote' it directly from RAM to storage, bypassing potentially a
> >> > huge amount of pages colder than it in CXL. That doesn't seem right.
> >> >
> >> > If demotion fails, IMO it shouldn't satisfy the reclaim request by
> >> > breaking the layering. Rather it should deflect that pressure to the
> >> > lower layers to make room. This makes sure we maintain an aging
> >> > pipeline that honors the memory tier hierarchy.
> >>
> >> Yes.  I think that we should avoid to fall back to reclaim as much as
> >> possible too.  Now, when we allocate memory for demotion
> >> (alloc_demote_page()), __GFP_KSWAPD_RECLAIM is used.  So, we will trigger
> >
> > I may be missing something but as far I can tell reclaim is disabled
> > for allocations from lower tier memory:
> > https://elixir.bootlin.com/linux/v6.1-rc7/source/mm/vmscan.c#L1583
>
> #define GFP_NOWAIT      (__GFP_KSWAPD_RECLAIM)
>
> We have GFP_NOWAIT set in gfp.
>

Ah, thanks. I missed that.

> > I think this is maybe a good thing when doing proactive demotion. In
> > this case we probably don't want to try to reclaim from lower tier
> > nodes and instead fail the proactive demotion.
>
> Do you have some real use cases for this?  If so, we can tweak the
> logic.
>

Nothing real at the moment. I was thinking this may be something
desirable to tune at some point.

> > However I can see this being desirable when the top tier nodes are
> > under real memory pressure to deflect that pressure to the lower tier
> > nodes.
>
> Yes.
>
> Best Regards,
> Huang, Ying
>
> >> kswapd reclaim on lower tier node to free some memory to avoid fall back
> >> to reclaim on current (higher tier) node.  This may be not good enough,
> >> for example, the following patch from Hasan may help via waking up
> >> kswapd earlier.
> >>
> >> https://lore.kernel.org/linux-mm/b45b9bf7cd3e21bca61d82dcd1eb692cd32c122c.1637778851.git.hasanalmaruf-b10kYP2dOMg@public.gmane.org/
> >>
> >> Do you know what is the next step plan for this patch?
> >>
> >> Should we do even more?
> >>
> >> From another point of view, I still think that we can use falling back
> >> to reclaim as the last resort to avoid OOM in some special situations,
> >> for example, most pages in the lowest tier node are mlock() or too hot
> >> to be reclaimed.
> >>
> >> > So I'm hesitant to design cgroup controls around the current behavior.
> >
> > I sent RFC v2 patch:
> > https://lore.kernel.org/linux-mm/20221130020328.1009347-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/T/#u
> >
> > Please take a look when convenient. Thanks!
> >
> >> >
> >>
> >> Best Regards,
> >> Huang, Ying
> >>
>
