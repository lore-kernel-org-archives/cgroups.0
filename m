From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: optimize per-lruvec stats
 counter memory usage
Date: Mon, 7 Dec 2020 16:09:01 +0100
Message-ID: <20201207150847.GM25569@dhcp22.suse.cz>
References: <20201206085639.12627-1-songmuchun@bytedance.com>
 <20201207123605.GH25569@dhcp22.suse.cz>
 <CAMZfGtUhG26cTgbSmg4g+rwOtEFhgbE3QXPR_LUf3FS-s=YbOA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607353743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7RsLkVdlKW2JLj2RfGQG78NhVgvfEuANtMbySI98QQQ=;
        b=FpL5im6xdBPNTwI0VJejyVkNHligc44w05ikwoMOxpq6LgNg3/4lSSlUjejunNBLXOIRIn
        F0HGr8LRMJYqby5qTOJhh9/p3FqCfVQA74WaKBYtiB99a/gVZp53Wd7MMzQkD7NLJ38uNB
        b1W+ClaJOZdhrEoN/UrEnHLAZTf4Kcw=
Content-Disposition: inline
In-Reply-To: <CAMZfGtUhG26cTgbSmg4g+rwOtEFhgbE3QXPR_LUf3FS-s=YbOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon 07-12-20 20:56:58, Muchun Song wrote:
> On Mon, Dec 7, 2020 at 8:36 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Sun 06-12-20 16:56:39, Muchun Song wrote:
> > > The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> > > of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> > > to optimize memory usage.
> >
> > How much savings are we talking about here? I am not deeply familiar
> > with the pcp allocator but can it compact smaller data types much
> > better?
> 
> It is a percpu struct. The size of struct lruvec_stat is 304(tested on the
> linux-5.5). So we can save 304 / 2 * nproc bytes per memcg where nproc
> is the number of the possible CPU. If we have n memory cgroup in the
> system. Finally, we can save (152 * nproc * n) bytes. In some configurations,
> nproc here may be 512. And if we have a lot of dying cgroup. The n can be
> 100, 000 (I once saw it on my server).

This should be part of the changelog. In general, any optimization
should come with some numbers showing the effect of the optimization.

As I've said I am not really familiar with pcp internals and how
efficiently it can organize smaller objects. Maybe it can really half
the memory consumption.

My only concern is that using smaller types for these counters can fire
back later on because we have an inderect dependency between the batch
size and the data type.  In general I do not really object to the patch
as long as savings are non trivial so that we are not creating a
potential trap for something that is practically miniscule
microptimization.
-- 
Michal Hocko
SUSE Labs
