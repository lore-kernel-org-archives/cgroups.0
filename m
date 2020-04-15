From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Wed, 15 Apr 2020 14:28:57 +0200
Message-ID: <20200415122857.GL4629@dhcp22.suse.cz>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200414113730.GH4629@dhcp22.suse.cz>
 <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw@mail.gmail.com>
 <20200414184917.GT4629@dhcp22.suse.cz>
 <CAELvCDQRYmTZrGSwBUjnRJB3kfB_5JOJ5ELdGv+tkCyhvM=x9A@mail.gmail.com>
 <20200415075136.GY4629@dhcp22.suse.cz>
 <CAELvCDRpVi4zjpHCw1oeY=GXf8XO2TXGUFAwztvydS27Q8L9Sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAELvCDRpVi4zjpHCw1oeY=GXf8XO2TXGUFAwztvydS27Q8L9Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Cc: svc lmoiseichuk <svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 15-04-20 08:17:42, Leonid Moiseichuk wrote:
> As Chris Down stated cgroups v1 frozen, so no API changes in the mainline
> kernel.

Yes, this is true, _but_ if there are clear shortcomings in the existing
vmpressure implementation which could be addressed reasonably then there
is no reason to ignore them.

[...]

> > I still find this very confusing because the amount of used memory is
> > not really important. It really only depends on the reclaim activity and
> > that is either the memcg or the global reclaim. And you are getting
> > critical levels only if the reclaim is failing to reclaim way too many
> > pages.
> >
> 
> OK, agree from that point of view.
> But for larger systems reclaiming happens not so often and we can
> use larger window sizes to have better memory utilization approximation.

Nobody is saying the the window size has to be fixed. This all can be
auto tuned in the kernel.  It would, however, require to define what
"better utilization approximation" means much more specifically.

[...]
> > This looks more like a problem of vmpressure implementation than
> > something you want to workaround by tuning to me.
> >
> Basically it is how it works - collect the scanned page and activate worker
> activity to update the current level.

That is the case only for some vmpressure invocations. And your data
suggest that those might lead to misleading results. So this is likely
good to focus on and find out whether this can be addressed.
-- 
Michal Hocko
SUSE Labs
