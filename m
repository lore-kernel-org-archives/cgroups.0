From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 30 Jun 2022 10:22:19 +0200
Message-ID: <Yr1dOxHo0HsyG2X7@dhcp22.suse.cz>
References: <YrSdFy3qYdG+rGR6@dhcp22.suse.cz>
 <CAJD7tkZNEtzJMDsLMHuNHkxFfurS37UuK=zFcPCkOkWfN-dbJQ@mail.gmail.com>
 <YrlpcdgF1HzA7bHS@dhcp22.suse.cz>
 <CAJD7tkYVy2uNwaPiiJdPKT5P_O-9WgxD68iFJ6vw=TLJcQV3Ag@mail.gmail.com>
 <Yrl2T632Vfv8QGPn@dhcp22.suse.cz>
 <CAJD7tkZzwzHq7Q7KKUdVSdO4LWTPkrGprp0Q-ze_SWhUd_mTMw@mail.gmail.com>
 <YrmjH2FZF7iNn8da@dhcp22.suse.cz>
 <CAJD7tkYemNQqu_O2nYG3cqxPWGELvc6Lh5i+KKNCtv6cgSPmdA@mail.gmail.com>
 <CALvZod68WdrXEmBpOkadhB5GPYmCXaDZzXH=yyGOCAjFRn4NDQ@mail.gmail.com>
 <CAJD7tkZeySa9V+nuoGfmugrOcxaiaXFspPKLkgTFkvsrri=J3g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656577340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VazjpIcq3Rp1eYxn5z7a3G7XqRklXOW4+Iv+aLJycac=;
        b=Z4q7b7Tv2K4y6bML5JDMKNXAp/3cMhrw1YjTHkivEtZmt0HRHEcPn1LT7wVU5jJ+CuX9AX
        ZGMpT+XS8r5g90JtJgzl+AR29D1omYEZ+O9qayyZTh/y+Ubo1diTU+Y6QJjnphzSqTeo1E
        Fc1wPLLAl5HxlD1w1Y1Anr89gy5iC/E=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZeySa9V+nuoGfmugrOcxaiaXFspPKLkgTFkvsrri=J3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed 29-06-22 19:08:42, Yosry Ahmed wrote:
> On Wed, Jun 29, 2022 at 6:07 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Mon, Jun 27, 2022 at 10:04 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Mon, Jun 27, 2022 at 5:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > >
> > [...]
> > > >
> > > > I can see clear arguments for memory.reclaim opt out for vmpressure
> > > > because we have established that this is not a measure to express a
> > > > memory pressure on the cgroup.
> > > >
> > > > Max/High are less clear to me, TBH. I do understand reasoning for PSI
> > > > exclusion because considering the calling process to be stalled and
> > > > non-productive is misleading. It just does its work so in a way it is
> > > > a productive time in the end. For the vmpressure, which measures how
> > > > hard/easy it is to reclaim memory why this should special for this
> > > > particular reclaim?
> > > >
> > > > Again, an explanation of the effect on the socket pressure could give a
> > > > better picture. Say that I somebody reduces the limit (hard/high) and it
> > > > takes quite some effort to shrink the consumption down. Should the
> > > > networking layer react to that in any way or should it wait for the
> > > > active allocation during that process to find that out?
> > >
> > > I am out of my depth here. Any answer on my side would be purely
> > > speculation at this point. Shakeel, can you help us here or tag some
> > > networking people?
> >
> > So, the effect of returning true from mem_cgroup_under_socket_pressure() are:
> >
> > 1. Reducing send and receive buffers of the current socket.
> > 2. May drop packets on the rx path.
> > 3. May throttle current thread on the tx path.
> >
> > Now regarding the behavior from the reclaim due to reducing max or
> > high, I think the kernel should not ignore vmpressure. Please note
> > that unlike PSI which is associated with the current process,
> > vmpressure is associated with the target memcg. So, any reclaim on
> > that memcg due to real shortage of memory should not be ignored. That
> > reclaim can be global reclaim or limit reclaim of ancestor or itself
> > or reclaim due to lowering the limit of ancestor or itself.
> 
> So it seems like we should only ignore vmpressure for proactive
> reclaim (aka memory.reclaim).
> 
> Michal, let me know what you think here, I can drop psi and
> limit-setting changes in v3 and basically just ignore vmpressure for
> memory.reclaim (MEMCG_RECLAIM_PROACTIVE / sc->proactive instead of
> MEMCG_RECLAIM_CONTROLLED / sc->controlled maybe).

Yes, that makes much more sense to me.

-- 
Michal Hocko
SUSE Labs
