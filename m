From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: optimize per-lruvec stats
 counter memory usage
Date: Mon, 7 Dec 2020 23:19:09 +0800
Message-ID: <CAMZfGtV36d0L7-+pSoD0Xqws-9naRNowTNJ3VTLwT5tFt09RJQ@mail.gmail.com>
References: <20201206085639.12627-1-songmuchun@bytedance.com>
 <20201207123605.GH25569@dhcp22.suse.cz> <CAMZfGtUhG26cTgbSmg4g+rwOtEFhgbE3QXPR_LUf3FS-s=YbOA@mail.gmail.com>
 <20201207150847.GM25569@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/8cl08sjjk7XgilYCDYzD/2g3tf6PI2yGU88Vpkn4A=;
        b=ZvtKJVWdEcz//9OHUucVTATmSAQTbpHT3os9hXUq1tI7hELUplnd8MnB7mAvrNTInG
         SXI4kX0qtpGl8NvMOqSz5ZfaT6by3X4IlHRJ1dCjN4mp9fiOygwBLBo7DGq6ShDGEAMz
         WOxaCJUpmiWjCm5juhwKjGc9XjQPRQSDnwAnhRxXwXihS5IazI64FczZA+mpY0zxmNqP
         YYzLxnSOq2ftnzGeU0a1TunNkm9DRSp+d30U4zGh7ThlOaZsMr5s5OIoy/merSHADQDV
         oWro9DLx5fUohiW9xYkhz0afQc7YYyYicgJicsHm+hnFVkW3yDp8CndN/hXzNdmyz8pw
         Zh0w==
In-Reply-To: <20201207150847.GM25569-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon, Dec 7, 2020 at 11:09 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 07-12-20 20:56:58, Muchun Song wrote:
> > On Mon, Dec 7, 2020 at 8:36 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Sun 06-12-20 16:56:39, Muchun Song wrote:
> > > > The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> > > > of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> > > > to optimize memory usage.
> > >
> > > How much savings are we talking about here? I am not deeply familiar
> > > with the pcp allocator but can it compact smaller data types much
> > > better?
> >
> > It is a percpu struct. The size of struct lruvec_stat is 304(tested on the
> > linux-5.5). So we can save 304 / 2 * nproc bytes per memcg where nproc
> > is the number of the possible CPU. If we have n memory cgroup in the
> > system. Finally, we can save (152 * nproc * n) bytes. In some configurations,
> > nproc here may be 512. And if we have a lot of dying cgroup. The n can be
> > 100, 000 (I once saw it on my server).
>
> This should be part of the changelog. In general, any optimization
> should come with some numbers showing the effect of the optimization.
>
> As I've said I am not really familiar with pcp internals and how
> efficiently it can organize smaller objects. Maybe it can really half
> the memory consumption.
>
> My only concern is that using smaller types for these counters can fire
> back later on because we have an inderect dependency between the batch
> size and the data type.  In general I do not really object to the patch
> as long as savings are non trivial so that we are not creating a
> potential trap for something that is practically miniscule
> microptimization.

There is a similar structure named struct per_cpu_nodestat.

struct per_cpu_nodestat {
        s8 stat_threshold;
        s8 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
};

The s8 is enough for per-node vmstat counters. This also depends on
the batch size. It can be s8 for a long time. Why not s32 is not suitable
for the per-memcg vmstat counters? They are very similar, right?

Thanks.

> --
> Michal Hocko
> SUSE Labs



-- 
Yours,
Muchun
