From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH V1] mm: Disable demotion from proactive reclaim
Date: Thu, 24 Nov 2022 13:51:20 +0800
Message-ID: <874juonbmv.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
        <Y35fw2JSAeAddONg@cmpxchg.org>
        <CAHS8izN+xqM67XLT4y5qyYnGQMUWRQCJrdvf2gjTHd8nZ_=0sw@mail.gmail.com>
        <Y36XchdgTCsMP4jT@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669269135; x=1700805135;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=6G7nnH68EGLhd5S/EKcOEOe5slAPl+r6rFU7g2dJ4Z8=;
  b=Npo54Z8yRkPyCdpPwpwFxFJVtkQIIFMp33BhLHwbrHOZrzvW0lcQnHjj
   u2GpjVdBjFJUEu07WGee9+xEG8fo0XgXXT2aVzzXrzLj1FQ6/kj0h7Fkw
   YhhFYfKD91w3l+DZHutE6ZE+k/yeVsumwI0DmnG6MRJlB3hHBKgPFERcy
   43DSLEL3YnAe+/Yr1PiCU62mDTNlaOdUp2KHz42ppfDrGvYGy4DeV1gFA
   5kWFKiuy6CociveVI2ny/4YdYHrfB2eXpAeNdKM84LdRnid3MZAga1jI5
   idasOP0yZseugaz7H0lWqc7B4VwKdvkS2eZITvkSgwCIS4Pe4waodpd7d
   Q==;
In-Reply-To: <Y36XchdgTCsMP4jT-druUgvl0LCNAfugRpC6u6w@public.gmane.org> (Johannes Weiner's message of
        "Wed, 23 Nov 2022 16:58:10 -0500")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi, Johannes,

Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> writes:
[...]
>
> The fallback to reclaim actually strikes me as wrong.
>
> Think of reclaim as 'demoting' the pages to the storage tier. If we
> have a RAM -> CXL -> storage hierarchy, we should demote from RAM to
> CXL and from CXL to storage. If we reclaim a page from RAM, it means
> we 'demote' it directly from RAM to storage, bypassing potentially a
> huge amount of pages colder than it in CXL. That doesn't seem right.
>
> If demotion fails, IMO it shouldn't satisfy the reclaim request by
> breaking the layering. Rather it should deflect that pressure to the
> lower layers to make room. This makes sure we maintain an aging
> pipeline that honors the memory tier hierarchy.

Yes.  I think that we should avoid to fall back to reclaim as much as
possible too.  Now, when we allocate memory for demotion
(alloc_demote_page()), __GFP_KSWAPD_RECLAIM is used.  So, we will trigger
kswapd reclaim on lower tier node to free some memory to avoid fall back
to reclaim on current (higher tier) node.  This may be not good enough,
for example, the following patch from Hasan may help via waking up
kswapd earlier.

https://lore.kernel.org/linux-mm/b45b9bf7cd3e21bca61d82dcd1eb692cd32c122c.1637778851.git.hasanalmaruf-b10kYP2dOMg@public.gmane.org/

Do you know what is the next step plan for this patch?

Should we do even more?

From another point of view, I still think that we can use falling back
to reclaim as the last resort to avoid OOM in some special situations,
for example, most pages in the lowest tier node are mlock() or too hot
to be reclaimed.

> So I'm hesitant to design cgroup controls around the current behavior.
>

Best Regards,
Huang, Ying
