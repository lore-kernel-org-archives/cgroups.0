From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 20:49:17 +0200
Message-ID: <20200414184917.GT4629@dhcp22.suse.cz>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200414113730.GH4629@dhcp22.suse.cz>
 <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Cc: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 14-04-20 12:42:44, Leonid Moiseichuk wrote:
> Thanks Michal for quick response, see my answer below.
> I will update the commit message with numbers for 8 GB memory swapless
> devices.
> 
> On Tue, Apr 14, 2020 at 7:37 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > On Mon 13-04-20 17:57:48, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org wrote:
> > > From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
> > >
> > > Small tweak to populate vmpressure parameters to userspace without
> > > any built-in logic change.
> > >
> > > The vmpressure is used actively (e.g. on Android) to track mm stress.
> > > vmpressure parameters selected empiricaly quite long time ago and not
> > > always suitable for modern memory configurations.
> >
> > This needs much more details. Why it is not suitable? What are usual
> > numbers you need to set up to work properly? Why those wouldn't be
> > generally applicable?
> >
> As far I see numbers which vmpressure uses - they are closer to RSS of
> userspace processes for memory utilization.
> Default calibration in memory.pressure_level_medium as 60% makes 8GB device
> hit memory threshold when RSS utilization
> reaches ~5 GB and that is a bit too early, I observe it happened
> immediately after boot. Reasonable level should be
> in the 70-80% range depending on SW preloaded on your device.

I am not sure I follow. Levels are based on the reclaim ineffectivity not
the overall memory utilization. So it takes to have only 40% reclaim
effectivity to trigger the medium level. While you are right that the
threshold for the event is pretty arbitrary I would like to hear why
that doesn't work in your environment. It shouldn't really depend on the
amount of memory as this is a percentage, right?

> From another point of view having a memory.pressure_level_critical set to
> 95% may never happen as it comes to a level where an OOM killer already
> starts to kill processes,
> and in some cases it is even worse than the now removed Android low memory
> killer. For such cases has sense to shift the threshold down to 85-90% to
> have device reliably
> handling low memory situations and not rely only on oom_score_adj hints.
> 
> Next important parameter for tweaking is memory.pressure_window which has
> the sense to increase twice to reduce the number of activations of userspace
> to save some power by reducing sensitivity.

Could you be more specific, please?

> For 12 and 16 GB devices the situation will be similar but worse, based on
> fact in current settings they will hit medium memory usage when ~5 or 6.5
> GB memory will be still free.
> 
> 
> >
> > Anyway, I have to confess I am not a big fan of this. vmpressure turned
> > out to be a very weak interface to measure the memory pressure. Not only
> > it is not numa aware which makes it unusable on many systems it also
> > gives data way too late from the practice.
> >
> > Btw. why don't you use /proc/pressure/memory resp. its memcg counterpart
> > to measure the memory pressure in the first place?
> >
> 
> According to our checks PSI produced numbers only when swap enabled e.g.
> swapless device 75% RAM utilization:

I believe you should discuss that with the people familiar with PSI
internals (Johannes already in the CC list). 
-- 
Michal Hocko
SUSE Labs
