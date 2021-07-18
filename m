From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Sun, 18 Jul 2021 22:29:28 +0100
Message-ID: <YPSdONIP8r9S31wM@casper.infradead.org>
References: <20210710003626.3549282-1-surenb@google.com>
 <20210710003626.3549282-2-surenb@google.com>
 <YPRdH56+dOFs/Ypu@casper.infradead.org>
 <CAJuCfpFNXmH3gQ51c-+3U_0HPG401dE9Mp9_hwMP67Tyg-zWGg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=saEY/4vR5oVUgdhiPTwdJ9ZlWWuuc9HoXDEQmM/u3RI=; b=SpOFLg8Z3oudwQfDI8th2AcBRG
        cyxA4iKcmxJ4ZhLHx411qiILoxlaYfk57jk//4rQpDLbsRJ9JPv5UoWg+zL6atAPMUqIBZabwFNmo
        ixzlJ2aHsas4CUgAsPCm5ayH6KsAMDXL8PocJ+/BIsCkTrm9G4R2oVWuYo94moamUne87giTl6CbN
        UMVqq7/npPjhOf5WR3mW2KBO7dBwtfV8OmUKM3N7eut0euO5Q/dikDmpDdvB8V2Fkq2bSb8aJI5jr
        wQWz0NkNqRcmSJeZ9BWfq6Sk3ctONHj7jPLFcVstZhavfaX4BFaQMw3Yf5dkpECzyQCfrECPJ1GOl
        Q4s06rwA==;
Content-Disposition: inline
In-Reply-To: <CAJuCfpFNXmH3gQ51c-+3U_0HPG401dE9Mp9_hwMP67Tyg-zWGg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Hildenbrand <david@redhat.com>, apopple@nvidia.com, Minchan Kim <minchan@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, kernel-team <kernel-team@a>

On Sun, Jul 18, 2021 at 02:25:50PM -0700, Suren Baghdasaryan wrote:
> On Sun, Jul 18, 2021 at 9:56 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Jul 09, 2021 at 05:36:25PM -0700, Suren Baghdasaryan wrote:
> > > @@ -6723,7 +6722,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
> > >  }
> > >
> > >  /**
> > > - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> > > + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
> > >   * @page: page to charge
> > >   * @mm: mm context of the victim
> > >   * @gfp_mask: reclaim mode
> >
> > This patch conflicts with the folio work, so I'm just rebasing the
> > folio patches on top of this, and I think this part of the patch is a
> > mistake.  We don't want to document the __mem_cgroup_charge() function.
> > That's an implementation detail.  This patch should instead have moved the
> > kernel-doc to memcontrol.h and continued to document mem_cgroup_charge().
> 
> Ack.
> There was a v4 version of this patch:
> https://lore.kernel.org/patchwork/patch/1458907 which was picked up by
> Andrew already. If others agree that documentation should be moved
> into the header file then I'll gladly post another version. Or I can
> post a separate patch moving the documentation only. Whatever works
> best. Andrew, Michal, Johannes, WDYT?

At this point, I've moved the documentation as part of the folio patch.
I'd rather not redo that patch again ...
