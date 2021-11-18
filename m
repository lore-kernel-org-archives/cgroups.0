From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v7] hugetlb: Add hugetlb.*.numa_stat file
Date: Thu, 18 Nov 2021 11:54:37 +0800
Message-ID: <CAMZfGtXgYPVOsGUE8OOzkx8K14BjHoMS1hLvxXX77+5cSycrPw@mail.gmail.com>
References: <20211117201825.429650-1-almasrymina@google.com> <86d3ba7a-3706-d66c-cbf7-d2c39ad2cd4c@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7t2KOfThi8hwqtjS9xYJIJMpMs4r7+aUCTbqpqaQgB8=;
        b=VegwIcpX4FTIU4RKip0IPMIg6bX57jiY+9C8sQOQlBEqaM0YS6p0Xj1UBjhlrmsTws
         nFsgLGqhsql/oJaUZmT23eSUFDPYJKFEBLYMdg1sCfGd73WqCBwrljXGCjUDAyycs1Ui
         KiKS2L8yF5rQ4s0DOtrMCJQyrko1gAm1Be0794OMriv4R96ZDyOQwF3Ki6qUVRKGz/zl
         0KsMERtV0Zk2+MG1lLyY2S/d2TIpwYf99h/8vuodrpwrJIDdDDY2rSzEXyJSryp2zD9Q
         JpMxhMN6GcLXDPQBFy86gmFjQ8pVlEXwfZzR0LT2a7bhXaOceJg0a2A/fBAKxn+o6p8k
         5Bmg==
In-Reply-To: <86d3ba7a-3706-d66c-cbf7-d2c39ad2cd4c-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Oscar Salvador <osalvador-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jue Wang <juew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Yao <ygyao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joanna Li <joannali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cannon Matthews <cannonmatthews-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 18, 2021 at 8:13 AM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 11/17/21 12:18, Mina Almasry wrote:
> ...
> > diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> ...
> > @@ -288,11 +317,21 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> >                                          struct hugetlb_cgroup *h_cg,
> >                                          struct page *page, bool rsvd)
> >  {
> > +     unsigned long *usage;
> > +
>
> I assume the use of a pointer is just to make the following WRITE_ONCE
> look better?  I prefer the suggestion by Muchun:
>
> unsigned long usage = h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
>
> usage += nr_pages;
> WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx], usage);
>
> I had to think for just a second 'why are we using/passing a pointer?'.
> Not insisting we use Muchun's suggestion, it just caused me to think
> a little more than necessary.

At least I have the same question here. For me I think it's
unnecessary to use a pointer.

>
> In any case, I would move the variable usage inside the
> 'if (!rsvd)' block.
>
> >       if (hugetlb_cgroup_disabled() || !h_cg)
> >               return;
> >
> >       __set_hugetlb_cgroup(page, h_cg, rsvd);
> > -     return;
> > +     if (!rsvd) {
> > +             usage = &h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
> > +             /*
> > +              * This write is not atomic due to fetching *usage and writing
> > +              * to it, but that's fine because we call this with
> > +              * hugetlb_lock held anyway.
> > +              */
> > +             WRITE_ONCE(*usage, *usage + nr_pages);
> > +     }
> >  }
> >
> >  void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> > @@ -316,6 +355,7 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
> >                                          struct page *page, bool rsvd)
> >  {
> >       struct hugetlb_cgroup *h_cg;
> > +     unsigned long *usage;
>
> Same here.
>
> Otherwise, looks good to me.
> --
> Mike Kravetz
