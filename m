From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Mon, 27 Jun 2022 10:25:21 +0200
Message-ID: <YrlpcdgF1HzA7bHS@dhcp22.suse.cz>
References: <20220623000530.1194226-1-yosryahmed@google.com>
 <YrQe5A+FXnbgOR1f@dhcp22.suse.cz>
 <CAJD7tkanavKpKrQr8-jA8pukgD7OY4eOwJRZufJ2NoThD12G+Q@mail.gmail.com>
 <YrQ1o3CeaZWhm+h4@dhcp22.suse.cz>
 <CAJD7tkadsLOV7GMFAm+naX4Y1WpZ-4=NkAhAMxNw60iaRPWx=w@mail.gmail.com>
 <YrSWruhPlJV1X9kp@dhcp22.suse.cz>
 <CALvZod6eLa1X1FJ2Qi6FXhFA-qBCP4mN2SB31MSgjj+g8hKo6Q@mail.gmail.com>
 <YrSdFy3qYdG+rGR6@dhcp22.suse.cz>
 <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656318322; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RdjZ81SzFUwlHNc7CnTKQAx6FQYkKfx1logzGP6DqeY=;
        b=rQn3PD59u/64iGg/OHUj9gw4KyNHEJJhftM7xBja/rSOmM8ZC6tWBdaQollFZlPepOguh2
        Mpv08kDiPaqVBYCA1o1BqfyhFONXhDb0HHGiObc2jGV4xOxMEcYIFP2F5RxWEZRIp2Hv7d
        s+u4et2mc6Wp4MixE9TzMgQ89j8F1zk=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu 23-06-22 10:26:11, Yosry Ahmed wrote:
> On Thu, Jun 23, 2022 at 10:04 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Thu 23-06-22 09:42:43, Shakeel Butt wrote:
> > > On Thu, Jun 23, 2022 at 9:37 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > > > On Thu 23-06-22 09:22:35, Yosry Ahmed wrote:
> > > > > On Thu, Jun 23, 2022 at 2:43 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > >
> > > > > > On Thu 23-06-22 01:35:59, Yosry Ahmed wrote:
> > > > [...]
> > > > > > > In our internal version of memory.reclaim that we recently upstreamed,
> > > > > > > we do not account vmpressure during proactive reclaim (similar to how
> > > > > > > psi is handled upstream). We want to make sure this behavior also
> > > > > > > exists in the upstream version so that consolidating them does not
> > > > > > > break our users who rely on vmpressure and will start seeing increased
> > > > > > > pressure due to proactive reclaim.
> > > > > >
> > > > > > These are good reasons to have this patch in your tree. But why is this
> > > > > > patch benefitial for the upstream kernel? It clearly adds some code and
> > > > > > some special casing which will add a maintenance overhead.
> > > > >
> > > > > It is not just Google, any existing vmpressure users will start seeing
> > > > > false pressure notifications with memory.reclaim. The main goal of the
> > > > > patch is to make sure memory.reclaim does not break pre-existing users
> > > > > of vmpressure, and doing it in a way that is consistent with psi makes
> > > > > sense.
> > > >
> > > > memory.reclaim is v2 only feature which doesn't have vmpressure
> > > > interface. So I do not see how pre-existing users of the upstream kernel
> > > > can see any breakage.
> > > >
> > >
> > > Please note that vmpressure is still being used in v2 by the
> > > networking layer (see mem_cgroup_under_socket_pressure()) for
> > > detecting memory pressure.
> >
> > I have missed this. It is hidden quite good. I thought that v2 is
> > completely vmpressure free. I have to admit that the effect of
> > mem_cgroup_under_socket_pressure is not really clear to me. Not to
> > mention whether it should or shouldn't be triggered for the user
> > triggered memory reclaim. So this would really need some explanation.
> 
> vmpressure was tied into socket pressure by 8e8ae645249b ("mm:
> memcontrol: hook up vmpressure to socket pressure"). A quick look at
> the commit log and the code suggests that this is used all over the
> socket and tcp code to throttles the memory consumption of the
> networking layer if we are under pressure.
> 
> However, for proactive reclaim like memory.reclaim, the target is to
> probe the memcg for cold memory. Reclaiming such memory should not
> have a visible effect on the workload performance. I don't think that
> any network throttling side effects are correct here.

Please describe the user visible effects of this change. IIUC this is
changing the vmpressure semantic for pre-existing users (v1 when setting
the hard limit for example) and it really should be explained why
this is good for them after those years. I do not see any actual bug
being described explicitly so please make sure this is all properly
documented.

-- 
Michal Hocko
SUSE Labs
