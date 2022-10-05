From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/vmscan: check references from all memcgs for
 swapbacked memory
Date: Wed, 5 Oct 2022 14:01:55 -0700
Message-ID: <CAJD7tkaS4T5dD3CpST2wsie5uP1ruHiaWL5AJv0j8V9=yiOuug@mail.gmail.com>
References: <20221005173713.1308832-1-yosryahmed@google.com> <CAOUHufaDhmHwY_qd2z26k6vK=eCHudJL1Pp4xALP25iZfbSJWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=HPUxNB9MAwfSiCjJ5k2ShYT0pkIe+fckBsowNt59HiU=;
        b=To/UngnwRjZ1zcui5/7edHRckWOASAvX1nCD7uw4oP6oQB9gj9fItEb7R7KXB0Uh+Z
         ofyHGd/dLIhhiBIsPxk1k271j6xdnEwHe7sx4QmCS359PSa57zhos0T12EA+u6n4e0Md
         rtML6PrISEHmQ9NzfX8vzYQPvHJzV6bcEesiiKbQGitIkz5QQ3TPShpYZkdqBlLytQ4m
         OP2jhY1Qhl09NdGxwRX/0EiW91btEJ0UEQycHayJZbHr5uI8xm+PZYTnz1koZmKQf4Tf
         cSYuiD7bBV4AkcLip+/MmfL4aRUnsBJqtkrPIi4W2n4TqdIvUAOuV1pEBGpEQxmEtqXC
         Lngw==
In-Reply-To: <CAOUHufaDhmHwY_qd2z26k6vK=eCHudJL1Pp4xALP25iZfbSJWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Oct 5, 2022 at 1:48 PM Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Oct 5, 2022 at 11:37 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > During page/folio reclaim, we check if a folio is referenced using
> > folio_referenced() to avoid reclaiming folios that have been recently
> > accessed (hot memory). The rationale is that this memory is likely to be
> > accessed soon, and hence reclaiming it will cause a refault.
> >
> > For memcg reclaim, we currently only check accesses to the folio from
> > processes in the subtree of the target memcg. This behavior was
> > originally introduced by commit bed7161a519a ("Memory controller: make
> > page_referenced() cgroup aware") a long time ago. Back then, refaulted
> > pages would get charged to the memcg of the process that was faulting them
> > in. It made sense to only consider accesses coming from processes in the
> > subtree of target_mem_cgroup. If a page was charged to memcg A but only
> > being accessed by a sibling memcg B, we would reclaim it if memcg A is
> > is the reclaim target. memcg B can then fault it back in and get charged
> > for it appropriately.
> >
> > Today, this behavior still makes sense for file pages. However, unlike
> > file pages, when swapbacked pages are refaulted they are charged to the
> > memcg that was originally charged for them during swapping out. Which
> > means that if a swapbacked page is charged to memcg A but only used by
> > memcg B, and we reclaim it from memcg A, it would simply be faulted back
> > in and charged again to memcg A once memcg B accesses it. In that sense,
> > accesses from all memcgs matter equally when considering if a swapbacked
> > page/folio is a viable reclaim target.
> >
> > Modify folio_referenced() to always consider accesses from all memcgs if
> > the folio is swapbacked.
>
> It seems to me this change can potentially increase the number of
> zombie memcgs. Any risk assessment done on this?

Do you mind elaborating the case(s) where this could happen? Is this
the cgroup v1 case in mem_cgroup_swapout() where we are reclaiming
from a zombie memcg and swapping out would let us move the charge to
the parent?
