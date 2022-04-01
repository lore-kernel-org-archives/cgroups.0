From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Fri, 1 Apr 2022 09:51:21 +0800
Message-ID: <CAGWkznHyAG1wZcUrGE4-amptT_MkSnpZCrDLy0vUWBm3z2cmJw@mail.gmail.com>
References: <1648713656-24254-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YkVt0m+VxnXgnulq@dhcp22.suse.cz> <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz> <CAJuCfpFgi+Dph-dcDAvGQXwgeZVDBhok1UQ3X5kxFEfPQnxSSg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5dbe41dvMeibhzpqOSIQnkhPlg4dZw5Ah44FWg9H4CM=;
        b=NNOnVEr19neIM7273P28aPKE9z7zRSXH889QcLQTa17aFwCGYWyoOjGZq7agLkuR/A
         InpsvR1AP9H4yyco9jZiHjV6ZXr5gY1eGXsQGrPfsBBBZQXLq5eU/0eZYY9xusv5Y5g5
         ul3y4ser5TjHRk3ToUENstkT9vmPN3sTyG72qBStx5y0JCsDie9YO3bY7Va16uEWEnog
         2X9qzH7FSmwQh4flfr7TTaXc0I0+v06FBNUjYcZ5ljTCckVrBAWJiLuFlbaTR99p32Ue
         HqIx2lCXjUKa0VFbqMXi0SFcKPClu1rvpWyXp2Tn82RQZjlsU4/psD1MUh3FmLarTCaF
         Ycyw==
In-Reply-To: <CAJuCfpFgi+Dph-dcDAvGQXwgeZVDBhok1UQ3X5kxFEfPQnxSSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 1, 2022 at 3:26 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Mar 31, 2022 at 4:35 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Thu 31-03-22 19:18:58, Zhaoyang Huang wrote:
> > > On Thu, Mar 31, 2022 at 5:01 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Thu 31-03-22 16:00:56, zhaoyang.huang wrote:
> > > > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > > > >
> > > > > For some kind of memcg, the usage is varies greatly from scenarios. Such as
> > > > > multimedia app could have the usage range from 50MB to 500MB, which generated
> > > > > by loading an special algorithm into its virtual address space and make it hard
> > > > > to protect the expanded usage without userspace's interaction.
> > > >
> > > > Do I get it correctly that the concern you have is that you do not know
> > > > how much memory your workload will need because that depends on some
> > > > parameters?
> > > right. such as a camera APP will expand the usage from 50MB to 500MB
> > > because of launching a special function(face beauty etc need special
> > > algorithm)
> > > >
> > > > > Furthermore, fixed
> > > > > memory.low is a little bit against its role of soft protection as it will response
> > > > > any system's memory pressure in same way.
> > > >
> > > > Could you be more specific about this as well?
> > > As the camera case above, if we set memory.low as 200MB to keep the
> > > APP run smoothly, the system will experience high memory pressure when
> > > another high load APP launched simultaneously. I would like to have
> > > camera be reclaimed under this scenario.
> >
> > OK, so you effectivelly want to keep the memory protection when there is
> > a "normal" memory pressure but want to relax the protection on other
> > high memory utilization situations?
> >
> > How do you exactly tell a difference between a steady memory pressure
> > (say stream IO on the page cache) from "high load APP launched"? Should
> > you reduce the protection on the stram IO situation as well?
>
> IIUC what you are implementing here is a "memory allowance boost"
> feature and it seems you are implementing it entirely inside the
> kernel, while only userspace knows when to apply this boost (say at
> app launch time). This does not make sense to me.
I am wondering if it could be more helpful to apply this patch on the
background services(system_server etc) than APP, while the latter ones
are persistent to the system.
>
> >
> > [...]
> > > > One very important thing that I am missing here is the overall objective of this
> > > > tuning. From the above it seems that you want to (ab)use memory->low to
> > > > protect some portion of the charged memory and that the protection
> > > > shrinks over time depending on the the global PSI metrict and time.
> > > > But why this is a good thing?
> > > 'Good' means it meets my original goal of keeping the usage during a
> > > period of time and responding to the system's memory pressure. For an
> > > android like system, memory is almost forever being in a tight status
> > > no matter how many RAM it has. What we need from memcg is more than
> > > control and grouping, we need it to be more responsive to the system's
> > > load and could  sacrifice its usage  under certain criteria.
> >
> > Why existing tools/APIs are insufficient for that? You can watch for
> > both global and memcg memory pressure including PSI metrics and update
> > limits dynamically. Why is it necessary to put such a logic into the
> > kernel?
>
> I had exactly the same thought while reading through this.
> In Android you would probably need to implement a userspace service
> which would temporarily relax the memcg limits when required, monitor
> PSI levels and adjust the limits accordingly.
As my response to Michal's comment. Userspace monitors introduce
latency. Take LMKD as an example, it is actually driven by the
PSI_POLL_PERIOD_XXX_MS after first wakeup, which means
PSI_WINDOW_SIZE_MS could be too big to rely on. IMHO, with regards to
the responding time, LMKD is less efficient than lmk driver but more
strong in strategy things. I would like to test this patch in real
android's work load and feedback in next version.
>
> >
> > --
> > Michal Hocko
> > SUSE Labs
