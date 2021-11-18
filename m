From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7] hugetlb: Add hugetlb.*.numa_stat file
Date: Wed, 17 Nov 2021 20:15:17 -0800
Message-ID: <CAHS8izMsQyTs=OKa-rD=MTZOHNbRXRP80jUUSt4+QOuvMSsHyQ@mail.gmail.com>
References: <20211117201825.429650-1-almasrymina@google.com>
 <86d3ba7a-3706-d66c-cbf7-d2c39ad2cd4c@oracle.com> <CAMZfGtXgYPVOsGUE8OOzkx8K14BjHoMS1hLvxXX77+5cSycrPw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dv4FMpzTlhmMmFiifkPCQFCgRBuUEUnuMSwoqw5Fr4o=;
        b=omqr4cQnnPmevelwOr+q6Fi7C6sTodMQdwtDb3HvpoNVQa77lXcCb/dH3PXFqJMuTs
         jr9AZrmXT1DmrQpZU4wlwTOHAXpvP/+pqiII7JIq43ICkCV7JPTxAw3j+Z/q8hp7rDJg
         w3cIgOumYkd14BgMin0r0eU68m1UuKYP42up0V9aDnJjwcJcyxay/XqabvmNOCDo9Jvn
         s342YAKrSypETDBbiSWtwvxweyYi3WRFEaj6h+Eujf5DsY5upwrnews6eiY/rWJrfIUv
         t3NvRg+pUV+Uy4k/nVRNVeH+EofbNEYawSIqYhwWMGkq/f8wSWGrSmflOCGgvhv+sBmw
         Z0Pw==
In-Reply-To: <CAMZfGtXgYPVOsGUE8OOzkx8K14BjHoMS1hLvxXX77+5cSycrPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Oscar Salvador <osalvador-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jue Wang <juew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Yao <ygyao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joanna Li <joannali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cannon Matthews <cannonmatthews-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 17, 2021 at 7:55 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> On Thu, Nov 18, 2021 at 8:13 AM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On 11/17/21 12:18, Mina Almasry wrote:
> > ...
> > > diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> > ...
> > > @@ -288,11 +317,21 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> > >                                          struct hugetlb_cgroup *h_cg,
> > >                                          struct page *page, bool rsvd)
> > >  {
> > > +     unsigned long *usage;
> > > +
> >
> > I assume the use of a pointer is just to make the following WRITE_ONCE
> > look better?  I prefer the suggestion by Muchun:
> >
> > unsigned long usage = h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
> >
> > usage += nr_pages;
> > WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx], usage);
> >
> > I had to think for just a second 'why are we using/passing a pointer?'.
> > Not insisting we use Muchun's suggestion, it just caused me to think
> > a little more than necessary.
>
> At least I have the same question here. For me I think it's
> unnecessary to use a pointer.
>

Hmm to be honest I would have not thought it would be preferable to
duplicate a long string like
h_cg->nodeinfo[page_to_nid(page)]->usage[idx], and then for future
code changes to keep them in sync. I think Marco had the same thinking
and that was his initial suggestion, but I don't mind much either way.
I'll submit another iteration with the change :-)

> >
> > In any case, I would move the variable usage inside the
> > 'if (!rsvd)' block.
> >
> > >       if (hugetlb_cgroup_disabled() || !h_cg)
> > >               return;
> > >
> > >       __set_hugetlb_cgroup(page, h_cg, rsvd);
> > > -     return;
> > > +     if (!rsvd) {
> > > +             usage = &h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
> > > +             /*
> > > +              * This write is not atomic due to fetching *usage and writing
> > > +              * to it, but that's fine because we call this with
> > > +              * hugetlb_lock held anyway.
> > > +              */
> > > +             WRITE_ONCE(*usage, *usage + nr_pages);
> > > +     }
> > >  }
> > >
> > >  void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> > > @@ -316,6 +355,7 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
> > >                                          struct page *page, bool rsvd)
> > >  {
> > >       struct hugetlb_cgroup *h_cg;
> > > +     unsigned long *usage;
> >
> > Same here.
> >
> > Otherwise, looks good to me.
> > --
> > Mike Kravetz
