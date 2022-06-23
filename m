From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 23 Jun 2022 09:22:35 -0700
Message-ID: <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
References: <20220623000530.1194226-1-yosryahmed@google.com>
 <YrQe5A+FXnbgOR1f@dhcp22.suse.cz> <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Prnv934r/fiLrvMDb9R4Q9UAwnFSkafyVnLRJO0ekrY=;
        b=LcoScsX3IhV4fd9f8iupQ0Dlh9F4jxJt+pgI6sQwesfY1uulJbPFxxz3e47Y2gN5vK
         YwtUZOQhD+OdIkZq5h5316VrCYA3zkWya3oWSYp4ktmB127kUkw7jZv3YcpAhKXNZzWo
         1CP4PSfO9KCvKOxJTo+viKnOKsiH2EnZ9nV1sMg+EMAMtWPKjMLsiI6Uoq3ZeBAMuudO
         eTY+3/kHyPgm68smgmjFRHiyd9g+n46HURNhMJpQIzk1BuWIibHuWzfBoKlJCRreeDvr
         8DcMZuSyY9c//NpF//WcukCphUzRbNnFTdq7wpzcjzX96KvWRWrKZXgHpYsIq/UCMrL5
         mNMQ==
In-Reply-To: <YrQ1o3CeaZWhm+h4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
> > On Thu, Jun 23, 2022 at 1:05 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 23-06-22 00:05:30, Yosry Ahmed wrote:
> > > > Commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> > > > as memory pressure") made sure that memory reclaim that is induced by
> > > > userspace (limit-setting, proactive reclaim, ..) is not counted as
> > > > memory pressure for the purposes of psi.
> > > >
> > > > Instead of counting psi inside try_to_free_mem_cgroup_pages(), callers
> > > > from try_charge() and reclaim_high() wrap the call to
> > > > try_to_free_mem_cgroup_pages() with psi handlers.
> > > >
> > > > However, vmpressure is still counted in these cases where reclaim is
> > > > directly induced by userspace. This patch makes sure vmpressure is not
> > > > counted in those operations, in the same way as psi. Since vmpressure
> > > > calls need to happen deeper within the reclaim path, the same approach
> > > > could not be followed. Hence, a new "controlled" flag is added to struct
> > > > scan_control to flag a reclaim operation that is controlled by
> > > > userspace. This flag is set by limit-setting and proactive reclaim
> > > > operations, and is used to count vmpressure correctly.
> > > >
> > > > To prevent future divergence of psi and vmpressure, commit e22c6ed90aa9
> > > > ("mm: memcontrol: don't count limit-setting reclaim as memory pressure")
> > > > is effectively reverted and the same flag is used to control psi as
> > > > well.
> > >
> > > Why do we need to add this is a legacy interface now? Are there any
> > > pre-existing users who realized this is bugging them? Please be more
> > > specific about the usecase.
> >
> > Sorry if I wasn't clear enough. Unfortunately we still have userspace
> > workloads at Google that use vmpressure notifications.
> >
> > In our internal version of memory.reclaim that we recently upstreamed,
> > we do not account vmpressure during proactive reclaim (similar to how
> > psi is handled upstream). We want to make sure this behavior also
> > exists in the upstream version so that consolidating them does not
> > break our users who rely on vmpressure and will start seeing increased
> > pressure due to proactive reclaim.
>
> These are good reasons to have this patch in your tree. But why is this
> patch benefitial for the upstream kernel? It clearly adds some code and
> some special casing which will add a maintenance overhead.

It is not just Google, any existing vmpressure users will start seeing
false pressure notifications with memory.reclaim. The main goal of the
patch is to make sure memory.reclaim does not break pre-existing users
of vmpressure, and doing it in a way that is consistent with psi makes
sense.

> --
> Michal Hocko
> SUSE Labs
