From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Wed, 15 Apr 2020 09:51:36 +0200
Message-ID: <20200415075136.GY4629@dhcp22.suse.cz>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200414113730.GH4629@dhcp22.suse.cz>
 <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw@mail.gmail.com>
 <20200414184917.GT4629@dhcp22.suse.cz>
 <CAELvCDQRYmTZrGSwBUjnRJB3kfB_5JOJ5ELdGv+tkCyhvM=x9A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAELvCDQRYmTZrGSwBUjnRJB3kfB_5JOJ5ELdGv+tkCyhvM=x9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Cc: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 14-04-20 16:53:55, Leonid Moiseichuk wrote:
> It would be nice if you can specify exact numbers you like to see.

You are proposing an interface which allows to tune thresholds from
userspace. Which suggests that you want to tune them. I am asking what
kind of tuning you are using and why cannot we use them as defaults in
the kernel.

> On Tue, Apr 14, 2020 at 2:49 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > ....
> 
> > As far I see numbers which vmpressure uses - they are closer to RSS of
> > > userspace processes for memory utilization.
> > > Default calibration in memory.pressure_level_medium as 60% makes 8GB
> > device
> > > hit memory threshold when RSS utilization
> > > reaches ~5 GB and that is a bit too early, I observe it happened
> > > immediately after boot. Reasonable level should be
> > > in the 70-80% range depending on SW preloaded on your device.
> >
> > I am not sure I follow. Levels are based on the reclaim ineffectivity not
> > the overall memory utilization. So it takes to have only 40% reclaim
> > effectivity to trigger the medium level. While you are right that the
> > threshold for the event is pretty arbitrary I would like to hear why
> > that doesn't work in your environment. It shouldn't really depend on the
> > amount of memory as this is a percentage, right?
> >
> It is not only depends from amount of memory or reclams but also what is
> software running.
> 
> As I see from vmscan.c vmpressure activated from various shrink_node()  or,
> basically do_try_to_free_pages().
> To hit this state you need to somehow lack memory due to various reasons,
> so the amount of memory plays a role here.
> In particular my case is very impacted by GPU (using CMA) consumption which
> can easily take gigs.
> Apps can take gigabyte as well.
> So reclaiming will be quite often called in case of lack of memory (4K
> calls are possible).
> 
> Handling level change will happen if the amount of scanned pages is more
> than window size, 512 is too little as now it is only 2 MB.
> So small slices are a source of false triggers.
> 
> Next, pressure counted as
>         unsigned long scale = scanned + reclaimed;
>         pressure = scale - (reclaimed * scale / scanned);
>         pressure = pressure * 100 / scale;

Just to make this more obvious this is essentially 
	100 * (1 - reclaimed/scanned)

> Or for 512 pages (lets use minimal) it leads to reclaimed should be 204
> pages for 60% threshold and 25 pages for 95% (as critical)
>
> In case of pressure happened (usually at 85% of memory used, and hittin
> critical level)

I still find this very confusing because the amount of used memory is
not really important. It really only depends on the reclaim activity and
that is either the memcg or the global reclaim. And you are getting
critical levels only if the reclaim is failing to reclaim way too many
pages. 

> I rarely see something like closer to real numbers
> vmpressure_work_fn: scanned 545, reclaimed 144   <-- 73%
> vmpressure_work_fn: scanned 16283, reclaimed 2495  <-- same session but 83%
> Most of the time it is looping between kswapd and lmkd reclaiming failures,
> consuming quite a high amount of cpu.
> 
> On vmscan calls everything looks as expected
> [  312.410938] vmpressure: tree 0 scanned 4, reclaimed 2
> [  312.410939] vmpressure: tree 0 scanned 120, reclaimed 62
> [  312.410939] vmpressure: tree 1 scanned 2, reclaimed 1
> [  312.410940] vmpressure: tree 1 scanned 120, reclaimed 62
> [  312.410941] vmpressure: tree 0 scanned 0, reclaimed 0

This looks more like a problem of vmpressure implementation than
something you want to workaround by tuning to me.

-- 
Michal Hocko
SUSE Labs
