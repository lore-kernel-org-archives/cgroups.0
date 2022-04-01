From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: introduce dynamic protection for memcg
Date: Fri, 1 Apr 2022 09:34:02 +0800
Message-ID: <CAGWkznHxAD0757m1i1Csw1CVRDtQddfCL08dYf12fa47=-uYYQ@mail.gmail.com>
References: <1648713656-24254-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YkVt0m+VxnXgnulq@dhcp22.suse.cz> <CAGWkznF4qb2EP3=xVamKO8qk08vaFg9JeHD7g80xvBfxm39Hkg@mail.gmail.com>
 <YkWR8t8yEe6xyzCM@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OO61RXD1UQQlNqnQzgeVM0kWox51DdMl6bQr1525nQg=;
        b=p4gwZPXJ32qPFxQBPNIwc2U4bV4VVZK1GVtHoEpqp8EeXPTpe/97y8CCj+AG+Sf/yj
         ej3wJrClyAZ29L642a9Mts49QtN2MIUmhNqKaZ47CIgNlVIcGuFIJBoIFqGUsQD8NMf/
         foB8uj4lZnc5b2yY0Lo9CfcokPcgJ84OvzuLXGUk58gws1Mn5MsL+PReCOR74hz0ryAG
         HaLLloFD0vxVIiySn8Fpv5K5WoPwDB2GlGP4Vnh/zovEGJjJ06eedD9f00/Limyu+SpK
         X51T7UekluL2AArKcmG6OPYcilTV5HPVcig62WZR18cdiSpN8uqXqgrzqM3GNQqI6uyE
         eTRw==
In-Reply-To: <YkWR8t8yEe6xyzCM-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

On Thu, Mar 31, 2022 at 7:35 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 31-03-22 19:18:58, Zhaoyang Huang wrote:
> > On Thu, Mar 31, 2022 at 5:01 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 31-03-22 16:00:56, zhaoyang.huang wrote:
> > > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > For some kind of memcg, the usage is varies greatly from scenarios. Such as
> > > > multimedia app could have the usage range from 50MB to 500MB, which generated
> > > > by loading an special algorithm into its virtual address space and make it hard
> > > > to protect the expanded usage without userspace's interaction.
> > >
> > > Do I get it correctly that the concern you have is that you do not know
> > > how much memory your workload will need because that depends on some
> > > parameters?
> > right. such as a camera APP will expand the usage from 50MB to 500MB
> > because of launching a special function(face beauty etc need special
> > algorithm)
> > >
> > > > Furthermore, fixed
> > > > memory.low is a little bit against its role of soft protection as it will response
> > > > any system's memory pressure in same way.
> > >
> > > Could you be more specific about this as well?
> > As the camera case above, if we set memory.low as 200MB to keep the
> > APP run smoothly, the system will experience high memory pressure when
> > another high load APP launched simultaneously. I would like to have
> > camera be reclaimed under this scenario.
>
> OK, so you effectivelly want to keep the memory protection when there is
> a "normal" memory pressure but want to relax the protection on other
> high memory utilization situations?
>
> How do you exactly tell a difference between a steady memory pressure
> (say stream IO on the page cache) from "high load APP launched"? Should
> you reduce the protection on the stram IO situation as well?
We can take either system's io_wait or PSI_IO into consideration for these.
>
> [...]
> > > One very important thing that I am missing here is the overall objective of this
> > > tuning. From the above it seems that you want to (ab)use memory->low to
> > > protect some portion of the charged memory and that the protection
> > > shrinks over time depending on the the global PSI metrict and time.
> > > But why this is a good thing?
> > 'Good' means it meets my original goal of keeping the usage during a
> > period of time and responding to the system's memory pressure. For an
> > android like system, memory is almost forever being in a tight status
> > no matter how many RAM it has. What we need from memcg is more than
> > control and grouping, we need it to be more responsive to the system's
> > load and could  sacrifice its usage  under certain criteria.
>
> Why existing tools/APIs are insufficient for that? You can watch for
> both global and memcg memory pressure including PSI metrics and update
> limits dynamically. Why is it necessary to put such a logic into the
> kernel?
Poll and then React method in userspace requires a polling interval
and response time. Take PSI as an example, it polls ten times during
POLLING_INTERVAL while just report once, which introduce latency in
some extend.
>
> --
> Michal Hocko
> SUSE Labs
