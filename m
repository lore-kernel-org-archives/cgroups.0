From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Tue, 10 May 2022 12:34:20 -0700
Message-ID: <CAHbLzkqztB+NXVcxtd7bVo7onH6AcMJ3JWCAHHqH3OAdbZsMOQ@mail.gmail.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn> <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com> <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com> <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bQthYIwGazUHXvJP4lOeiwCuBM9QlZF5ToR+SlrapXg=;
        b=WKDEchBVC4Mp134gTUdZstuBf95M4RJvGSkZViPHvH1YSJM33gQRVZWZL9HZNWW223
         Qgy84a9u4AjEUm9YrMVUW9UNx0E2sQYgIN0MYN+gOf1caJZneovM75xCXkgevzWeAsSs
         fM6pqvNvNTmffmbhpx9GcAic/N3JOAqSHe9kcVUGE4Hq0Zaxgnv8Fjt1Naee4CaKnfjj
         RCinT3zwa59llD67qILIX1cl1IPfp6fk0aGqq7nXOd/ahyrQ90DNGCjyCv6aprfqu2uC
         vgmyE+UAa2PzfG4jdNqQlPInnL6EHMiLb94OdoFMMrvQT9Bx1Ici0tfDSEEqtb0cASaT
         F32Q==
In-Reply-To: <6279c354.1c69fb81.7f6c1.15e0-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Mon, May 9, 2022 at 6:43 PM CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, May 09, 2022 at 01:48:39PM +0200, Michal Hocko wrote:
> > On Mon 09-05-22 11:26:43, CGEL wrote:
> > > On Mon, May 09, 2022 at 12:00:28PM +0200, Michal Hocko wrote:
> > > > On Sat 07-05-22 02:05:25, CGEL wrote:
> > > > [...]
> > > > > If there are many containers to run on one host, and some of them have high
> > > > > performance requirements, administrator could turn on thp for them:
> > > > > # docker run -it --thp-enabled=always
> > > > > Then all the processes in those containers will always use thp.
> > > > > While other containers turn off thp by:
> > > > > # docker run -it --thp-enabled=never
> > > >
> > > > I do not know. The THP config space is already too confusing and complex
> > > > and this just adds on top. E.g. is the behavior of the knob
> > > > hierarchical? What is the policy if parent memcg says madivise while
> > > > child says always? How does the per-application configuration aligns
> > > > with all that (e.g. memcg policy madivise but application says never via
> > > > prctl while still uses some madvised - e.g. via library).
> > > >
> > >
> > > The cgroup THP behavior is align to host and totally independent just likes
> > > /sys/fs/cgroup/memory.swappiness. That means if one cgroup config 'always'
> > > for thp, it has no matter with host or other cgroup. This make it simple for
> > > user to understand or control.
> >
> > All controls in cgroup v2 should be hierarchical. This is really
> > required for a proper delegation semantic.
> >
>
> Could we align to the semantic of /sys/fs/cgroup/memory.swappiness?
> Some distributions like Ubuntu is still using cgroup v1.

Other than enable flag, how would you handle the defrag flag
hierarchically? It is much more complicated.

>
> > > If memcg policy madivise but application says never, just like host, the result
> > > is no THP for that application.
> > >
> > > > > By doing this we could promote important containers's performance with less
> > > > > footprint of thp.
> > > >
> > > > Do we really want to provide something like THP based QoS? To me it
> > > > sounds like a bad idea and if the justification is "it might be useful"
> > > > then I would say no. So you really need to come with a very good usecase
> > > > to promote this further.
> > >
> > > At least on some 5G(communication technology) machine, it's useful to provide
> > > THP based QoS. Those 5G machine use micro-service software architecture, in
> > > other words one service application runs in one container.
> >
> > I am not really sure I understand. If this is one application per
> > container (cgroup) then why do you really need per-group setting?
> > Does the application is a set of different processes which are only very
> > loosely tight?
> >
> For micro-service architecture, the application in one container is not a
> set of loosely tight processes, it's aim at provide one certain service,
> so different containers means different service, and different service
> has different QoS demand.
>
> The reason why we need per-group(per-container) setting is because most
> container are managed by compose software, the compose software provide
> UI to decide how to run a container(likes setting swappiness value). For
> example the docker compose:
> https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command
>
> To make it clearer, I try to make a summary for why container needs this patch:
>     1.one machine can run different containers;
>     2.for some scenario, container runs only one service inside(can be only one
> application);
>     3.different containers provide different services, different services have
> different QoS demands;
>     4.THP has big influence on QoS. It's fast for memory access, but eat more
> memory;

I have been involved in this kind of topic discussion offline a couple
of times. But TBH I don't see how you could achieve QoS by this flag.
THP allocation is *NOT* guaranteed. And the overhead may be quite
high. It depends on how fragmented the system is.

>     5.containers usually managed by compose software, which treats container as
> base management unit;
>     6.this patch provide cgroup THP controller, which can be a method to adjust
> container memory QoS.
>
> > > Container becomes
> > > the suitable management unit but not the whole host. And some performance
> > > sensitive containers desiderate THP to provide low latency communication.
> > > But if we use THP with 'always', it will consume more memory(on our machine
> > > that is about 10% of total memory). And unnecessary huge pages will increase
> > > memory pressure, add latency for minor pages faults, and add overhead when
> > > splitting huge pages or coalescing normal sized pages into huge pages.
> >
> > It is still not really clear to me how do you achieve that the whole
> > workload in the said container has the same THP requirements.
> > --
> > Michal Hocko
> > SUSE Labs
