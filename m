From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 13:37:30 +0200
Message-ID: <20200414113730.GH4629@dhcp22.suse.cz>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200413215750.7239-1-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

On Mon 13-04-20 17:57:48, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org wrote:
> From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
> 
> Small tweak to populate vmpressure parameters to userspace without
> any built-in logic change.
> 
> The vmpressure is used actively (e.g. on Android) to track mm stress.
> vmpressure parameters selected empiricaly quite long time ago and not
> always suitable for modern memory configurations.

This needs much more details. Why it is not suitable? What are usual
numbers you need to set up to work properly? Why those wouldn't be
generally applicable?

Anyway, I have to confess I am not a big fan of this. vmpressure turned
out to be a very weak interface to measure the memory pressure. Not only
it is not numa aware which makes it unusable on many systems it also 
gives data way too late from the practice.

Btw. why don't you use /proc/pressure/memory resp. its memcg counterpart
to measure the memory pressure in the first place?

> Leonid Moiseichuk (2):
>   memcg: expose vmpressure knobs
>   memcg, vmpressure: expose vmpressure controls
> 
>  .../admin-guide/cgroup-v1/memory.rst          |  12 +-
>  include/linux/vmpressure.h                    |  35 ++++++
>  mm/memcontrol.c                               | 113 ++++++++++++++++++
>  mm/vmpressure.c                               | 101 +++++++---------
>  4 files changed, 200 insertions(+), 61 deletions(-)
> 
> -- 
> 2.17.1
> 

-- 
Michal Hocko
SUSE Labs
