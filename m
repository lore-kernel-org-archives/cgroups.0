From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 23 Jun 2022 10:26:11 -0700
Message-ID: <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
References: <20220623000530.1194226-1-yosryahmed@google.com>
 <YrQe5A+FXnbgOR1f@dhcp22.suse.cz> <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz> <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz> <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7TDx1GAcTZr/mKBq1FDoJ+WDlWvqn8HIrUeDOsFdpYQ=;
        b=ligNsGWDaeaYYd/G23On/R6o4SOm7zU5YC8HoZNU95O944imBcwrspvEgFwN/jGZhy
         BsqxtmSbvZWbeBbv+nhfMCexAkXOJe09iXp5EF8jD89itp1j+SwO0SyJqwT+axErD/Gb
         RLoYBG7mmML1wacS5w7d+BkAOcQFmQvKA/pXN1LSgzFGqLrJ4uawFe8Xc42ASPtIkwoj
         q/6hAWrCjPXdsSiMhicJLxhTYSpzYoslUad6fyTGV1PSr25ZDlw/QK7ERDUClaOKrabX
         8w8zveECT9r55DBweEavza7Ov5K5Z06nVub55c0/iBZGS/2SSDgVQZKOHdoAbnjZ1yMl
         AZdA==
In-Reply-To: <YrSdFy3qYdG+rGR6-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Jun 23, 2022 at 10:04 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 23-06-22 09:42:43, Shakeel Butt wrote:
> > On Thu, Jun 23, 2022 at 9:37 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 23-06-22 09:22:35, Yosry Ahmed wrote:
> > > > On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
> > > [...]
> > > > > > In our internal version of memory.reclaim that we recently upstreamed,
> > > > > > we do not account vmpressure during proactive reclaim (similar to how
> > > > > > psi is handled upstream). We want to make sure this behavior also
> > > > > > exists in the upstream version so that consolidating them does not
> > > > > > break our users who rely on vmpressure and will start seeing increased
> > > > > > pressure due to proactive reclaim.
> > > > >
> > > > > These are good reasons to have this patch in your tree. But why is this
> > > > > patch benefitial for the upstream kernel? It clearly adds some code and
> > > > > some special casing which will add a maintenance overhead.
> > > >
> > > > It is not just Google, any existing vmpressure users will start seeing
> > > > false pressure notifications with memory.reclaim. The main goal of the
> > > > patch is to make sure memory.reclaim does not break pre-existing users
> > > > of vmpressure, and doing it in a way that is consistent with psi makes
> > > > sense.
> > >
> > > memory.reclaim is v2 only feature which doesn't have vmpressure
> > > interface. So I do not see how pre-existing users of the upstream kernel
> > > can see any breakage.
> > >
> >
> > Please note that vmpressure is still being used in v2 by the
> > networking layer (see mem_cgroup_under_socket_pressure()) for
> > detecting memory pressure.
>
> I have missed this. It is hidden quite good. I thought that v2 is
> completely vmpressure free. I have to admit that the effect of
> mem_cgroup_under_socket_pressure is not really clear to me. Not to
> mention whether it should or shouldn't be triggered for the user
> triggered memory reclaim. So this would really need some explanation.

vmpressure was tied into socket pressure by 8e8ae645249b ("mm:
memcontrol: hook up vmpressure to socket pressure"). A quick look at
the commit log and the code suggests that this is used all over the
socket and tcp code to throttles the memory consumption of the
networking layer if we are under pressure.

However, for proactive reclaim like memory.reclaim, the target is to
probe the memcg for cold memory. Reclaiming such memory should not
have a visible effect on the workload performance. I don't think that
any network throttling side effects are correct here.

>
> > Though IMO we should deprecate vmpressure altogether.
>
> Yes it should be really limited to v1. But as I've said the effect on
> mem_cgroup_under_socket_pressure is not really clear to me. It really
> seems the v2 support has been introduced deliberately.
>
> --
> Michal Hocko
> SUSE Labs
