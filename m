From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Sun, 3 Apr 2022 08:04:29 -0700
Message-ID: <CAJuCfpHneDZMXO_MmQDPA+igAOdAPRUChiq+zftFXGfDzPHNhQ@mail.gmail.com>
References: <1648713656-24254-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YkVt0m+VxnXgnulq@dhcp22.suse.cz> <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz> <CAGWkznHxAD0757m1i1Csw1CVRDtQddfCL08dYf12fa47=-uYYQ@mail.gmail.com>
 <YkbjNYMY8VjHoSHR@dhcp22.suse.cz> <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1a2JVSeIsg2n4ZPERcRwhBo2C98JOFbdzvDc4k4uyY=;
        b=lPiPbC/t1ZONedq5p4jRaLJSgnXNlu8ckGlSdays2/JRFNJ8SQ22JXehsnSCOBhtRE
         oQBxdjUsuCd7ZmU+nVc7oWCZNnoynu9fz9eSmY/Duz2fHGiCsVlmHmeJzqIKQh999KLv
         k4d1agL0ZunXTrAdcC7/I3mWf+udbWmRvNfgdN0IUCDpKwo0j7Aqk4TD3hKC4vwmY6V/
         ijxSemBS8EgzN0y9OReOorBobYABLcxH6k1uHuH2f/z6zoO3CO89P+yOqWpnEM8XP2Mo
         rbpFshHNFodJb+MFXRq6CoFAazWBBDm3vxKlIyvFCnZxDl1mdI1fPhj4yiWNQ7WjczKI
         QgFQ==
In-Reply-To: <CAGWkznF7cSyPU0ceYwH6zweJzf-X1bQnS6AJ2-J+WEL0u8jzng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 1, 2022 at 10:18 PM Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Fri, Apr 1, 2022 at 7:34 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Fri 01-04-22 09:34:02, Zhaoyang Huang wrote:
> > > On Thu, Mar 31, 2022 at 7:35 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Thu 31-03-22 19:18:58, Zhaoyang Huang wrote:
> > > > > On Thu, Mar 31, 2022 at 5:01 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > >
> > > > > > On Thu 31-03-22 16:00:56, zhaoyang.huang wrote:
> > > > > > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > > > > > >
> > > > > > > For some kind of memcg, the usage is varies greatly from scenarios. Such as
> > > > > > > multimedia app could have the usage range from 50MB to 500MB, which generated
> > > > > > > by loading an special algorithm into its virtual address space and make it hard
> > > > > > > to protect the expanded usage without userspace's interaction.
> > > > > >
> > > > > > Do I get it correctly that the concern you have is that you do not know
> > > > > > how much memory your workload will need because that depends on some
> > > > > > parameters?
> > > > > right. such as a camera APP will expand the usage from 50MB to 500MB
> > > > > because of launching a special function(face beauty etc need special
> > > > > algorithm)
> > > > > >
> > > > > > > Furthermore, fixed
> > > > > > > memory.low is a little bit against its role of soft protection as it will response
> > > > > > > any system's memory pressure in same way.
> > > > > >
> > > > > > Could you be more specific about this as well?
> > > > > As the camera case above, if we set memory.low as 200MB to keep the
> > > > > APP run smoothly, the system will experience high memory pressure when
> > > > > another high load APP launched simultaneously. I would like to have
> > > > > camera be reclaimed under this scenario.
> > > >
> > > > OK, so you effectivelly want to keep the memory protection when there is
> > > > a "normal" memory pressure but want to relax the protection on other
> > > > high memory utilization situations?
> > > >
> > > > How do you exactly tell a difference between a steady memory pressure
> > > > (say stream IO on the page cache) from "high load APP launched"? Should
> > > > you reduce the protection on the stram IO situation as well?
> > > We can take either system's io_wait or PSI_IO into consideration for these.
> >
> > I do not follow. Let's say you have a stream IO workload which is mostly
> > RO. Reclaiming those pages means effectivelly to drop them from the
> > cache so there is no IO involved during the reclaim. This will generate
> > a constant flow of reclaim that shouldn't normally affect other
> > workloads (as long as kswapd keeps up with the IO pace). How does your
> > scheme cope with this scenario? My understanding is that it will simply
> > relax the protection.
> You are right. This scheme treats the system's memory pressure
> equally, no matter if it comes from in-kernel page allocation with
> high order or cache drop by IO like things. The decay_factor composed
> of PSI_SOME and PSI_FULL which represent the system is tight on
> memory, every entity has the obligation to donate to solve this issue.
> >
> > > > [...]
> > > > > > One very important thing that I am missing here is the overall objective of this
> > > > > > tuning. From the above it seems that you want to (ab)use memory->low to
> > > > > > protect some portion of the charged memory and that the protection
> > > > > > shrinks over time depending on the the global PSI metrict and time.
> > > > > > But why this is a good thing?
> > > > > 'Good' means it meets my original goal of keeping the usage during a
> > > > > period of time and responding to the system's memory pressure. For an
> > > > > android like system, memory is almost forever being in a tight status
> > > > > no matter how many RAM it has. What we need from memcg is more than
> > > > > control and grouping, we need it to be more responsive to the system's
> > > > > load and could  sacrifice its usage  under certain criteria.
> > > >
> > > > Why existing tools/APIs are insufficient for that? You can watch for
> > > > both global and memcg memory pressure including PSI metrics and update
> > > > limits dynamically. Why is it necessary to put such a logic into the
> > > > kernel?
> > > Poll and then React method in userspace requires a polling interval
> > > and response time. Take PSI as an example, it polls ten times during
> > > POLLING_INTERVAL while just report once, which introduce latency in
> > > some extend.
> >
> > Do workload transitions happen so often in your situation that the
> > interval really matters? As Suren already pointed out starting a new
> > application is usually an explicit event which can pro-activelly update
> > limits.
> Yes. As my reply to Suren's comment, even a positive monitor service
> which could be aware of the activity starting(APP launching etc) at
> the very first time, has to 1. read PSI and memcg->watermark/usage 2.
> make a decision. 3. write memcg->memory.low to adjust memory
> allowance. Furthermore, monitors could not supervise the APP for whole
> life time, while the reclaiming could arise at any time.

Ok, sounds like you want this dynamic limit to be active all the time,
not only at specific points in the process's life cycle.
One thing that I don't understand in this approach is: why memory.low
should depend on the system's memory pressure. It seems you want to
allow a process to allocate more when memory pressure is high. That is
very counter-intuitive to me. Could you please explain the underlying
logic of why this is the right thing to do, without going into
technical details?

>
> > --
> > Michal Hocko
> > SUSE Labs
