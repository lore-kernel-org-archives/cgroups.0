From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Sun, 18 Jul 2021 14:32:02 -0700
Message-ID: <CAJuCfpH-E9wJZysL7g8wvD1t62tkSoxjRzr0-aCYn-5XK8KUzg@mail.gmail.com>
References: <20210710003626.3549282-1-surenb@google.com> <20210710003626.3549282-2-surenb@google.com>
 <YPRdH56+dOFs/Ypu@casper.infradead.org> <CAJuCfpFNXmH3gQ51c-+3U_0HPG401dE9Mp9_hwMP67Tyg-zWGg@mail.gmail.com>
 <YPSdONIP8r9S31wM@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2+/+LhyG5jvyV2FwgkrvUngRXo+GiZNFji+6rwemUzs=;
        b=vedZyKz3lL38LRdICKgLFxrEXvjXGc5BgkO2T78tkSNG8sI2Hlk33sbY4W5Y63syJE
         mURxKSpo24wSQ9o/ud5y4QDgt6SvMpf9VVsh6F507XJUpmQHNL0dW9oxTms5nlK0xUSc
         PuHLZCQNZUwHfduWT20rlRZOCXMBJrXKRIYo8Mb7fDiylsOGnIrE0HgtfxVul6uQd/rV
         1LG0LAQ4sJ9oJ6jQ9RuzMIK2dpGVBQhO5zFqDDnpLK9olnfgkR0dUTgG7hbqRmoeiac5
         zKoaJ6wS4qh1aAk9zJR/Tn2YTD8GhmJhjazXSfsyDxBgXeizJ4jqLkfMgQDSenGJ6lCg
         SJlQ==
In-Reply-To: <YPSdONIP8r9S31wM-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team@a>

On Sun, Jul 18, 2021 at 2:30 PM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Sun, Jul 18, 2021 at 02:25:50PM -0700, Suren Baghdasaryan wrote:
> > On Sun, Jul 18, 2021 at 9:56 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > >
> > > On Fri, Jul 09, 2021 at 05:36:25PM -0700, Suren Baghdasaryan wrote:
> > > > @@ -6723,7 +6722,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> > > >  }
> > > >
> > > >  /**
> > > > - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> > > > + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
> > > >   * @page: page to charge
> > > >   * @mm: mm context of the victim
> > > >   * @gfp_mask: reclaim mode
> > >
> > > This patch conflicts with the folio work, so I'm just rebasing the
> > > folio patches on top of this, and I think this part of the patch is a
> > > mistake.  We don't want to document the __mem_cgroup_charge() function.
> > > That's an implementation detail.  This patch should instead have moved the
> > > kernel-doc to memcontrol.h and continued to document mem_cgroup_charge().
> >
> > Ack.
> > There was a v4 version of this patch:
> > https://lore.kernel.org/patchwork/patch/1458907 which was picked up by
> > Andrew already. If others agree that documentation should be moved
> > into the header file then I'll gladly post another version. Or I can
> > post a separate patch moving the documentation only. Whatever works
> > best. Andrew, Michal, Johannes, WDYT?
>
> At this point, I've moved the documentation as part of the folio patch.
> I'd rather not redo that patch again ...

Ok. If you need me to redo anything please let me know.
