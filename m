From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/vmscan: check references from all memcgs for
 swapbacked memory
Date: Thu, 6 Oct 2022 00:30:45 -0700
Message-ID: <CAJD7tkao9DU2e_2co_HgOm38PxvLqdRS=kHcOdRfqcqN6MRdaw@mail.gmail.com>
References: <20221005173713.1308832-1-yosryahmed@google.com>
 <CAOUHufaDhmHwY_qd2z26k6vK=eCHudJL1Pp4xALP25iZfbSJWA@mail.gmail.com>
 <CAJD7tkaS4T5dD3CpST2wsie5uP1ruHiaWL5AJv0j8V9=yiOuug@mail.gmail.com>
 <CAOUHufYKvbZTJ_ofD4+DyzY+DuHrRKYChnJVwqD7OKwe6sw-hw@mail.gmail.com> <Yz5XVZfq8abvMYJ8@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=RVWW/BaJYSJb5iFCcmVWgHh8lf5q5nSO5D6+WwfrGO0=;
        b=mBl1Gv36EpxEHwxD8G7c2u80/IL6+9yVxn+9bsflcmtYODk4l9xKEbagkili2v3OxI
         XjdikoyYoP1QyAmW0TZErMbO84gMIB6gcm6OYndYagBwSrqg9Gy4hv7im3obX0sBrq3p
         qG/hjkBWPS6Ku3/fjoIlhVjcF58vx5EDYDbEXQV215CHEO4WTUxZ6janp1qrFyDboI/w
         OOo7kmv3GN2o97SK1InevEG172WD5n92gOjtHgaSDG0nvTAvYaHKUFk1a40joFB5wq9W
         04WeKaJxs/LPaW2NmdgChnXxn6tpuD1tcm9ISfoO9lHunE2GHuEn5rl04s9FhpFGXaMN
         smIA==
In-Reply-To: <Yz5XVZfq8abvMYJ8-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Oct 5, 2022 at 9:19 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Oct 05, 2022 at 03:13:38PM -0600, Yu Zhao wrote:
> > On Wed, Oct 5, 2022 at 3:02 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Wed, Oct 5, 2022 at 1:48 PM Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > On Wed, Oct 5, 2022 at 11:37 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > >
> > > > > During page/folio reclaim, we check if a folio is referenced using
> > > > > folio_referenced() to avoid reclaiming folios that have been recently
> > > > > accessed (hot memory). The rationale is that this memory is likely to be
> > > > > accessed soon, and hence reclaiming it will cause a refault.
> > > > >
> > > > > For memcg reclaim, we currently only check accesses to the folio from
> > > > > processes in the subtree of the target memcg. This behavior was
> > > > > originally introduced by commit bed7161a519a ("Memory controller: make
> > > > > page_referenced() cgroup aware") a long time ago. Back then, refaulted
> > > > > pages would get charged to the memcg of the process that was faulting them
> > > > > in. It made sense to only consider accesses coming from processes in the
> > > > > subtree of target_mem_cgroup. If a page was charged to memcg A but only
> > > > > being accessed by a sibling memcg B, we would reclaim it if memcg A is
> > > > > is the reclaim target. memcg B can then fault it back in and get charged
> > > > > for it appropriately.
> > > > >
> > > > > Today, this behavior still makes sense for file pages. However, unlike
> > > > > file pages, when swapbacked pages are refaulted they are charged to the
> > > > > memcg that was originally charged for them during swapping out. Which
> > > > > means that if a swapbacked page is charged to memcg A but only used by
> > > > > memcg B, and we reclaim it from memcg A, it would simply be faulted back
> > > > > in and charged again to memcg A once memcg B accesses it. In that sense,
> > > > > accesses from all memcgs matter equally when considering if a swapbacked
> > > > > page/folio is a viable reclaim target.
> > > > >
> > > > > Modify folio_referenced() to always consider accesses from all memcgs if
> > > > > the folio is swapbacked.
> > > >
> > > > It seems to me this change can potentially increase the number of
> > > > zombie memcgs. Any risk assessment done on this?
> > >
> > > Do you mind elaborating the case(s) where this could happen? Is this
> > > the cgroup v1 case in mem_cgroup_swapout() where we are reclaiming
> > > from a zombie memcg and swapping out would let us move the charge to
> > > the parent?
> >
> > The scenario is quite straightforward: for a page charged to memcg A
> > and also actively used by memcg B, if we don't ignore the access from
> > memcg B, we won't be able to reclaim it after memcg A is deleted.
>
> This patch changes the behavior of limit-induced reclaim. There is no
> limit reclaim on A after it's been deleted. And parental/global
> reclaim has always recognized outside references.

Do you mind elaborating on the parental reclaim part?

I am looking at the code and it looks like memcg reclaim of a parent
(limit-induced or proactive) will only consider references coming from
its subtree, even when reclaiming from its dead children. It looks
like as long as sc->target_mem_cgroup is set, we ignore outside
references (relative to sc->target_mem_cgroup).

If that is true, maybe we want to keep ignoring outside references for
swap-backed pages if the folio is charged to a dead memcg? My
understanding is that in this case we will uncharge the page from the
dead memcg and charge the swapped entry to the parent, reducing the
number of refs on the dead memcg. Without this check, this patch might
prevent the charge from being moved to the parent in this case. WDYT?
