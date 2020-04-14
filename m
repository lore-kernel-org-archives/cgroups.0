From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 0/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 20:35:41 +0200
Message-ID: <20200414183541.GS4629@dhcp22.suse.cz>
References: <20200414171840.22053-1-lmoiseichuk@magicleap.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200414171840.22053-1-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>

On Tue 14-04-20 13:18:38, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org wrote:
> From: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
> 
> Small tweak to populate vmpressure parameters to userspace without
> any built-in logic change.
> 
> The vmpressure is used actively (e.g. on Android) to track mm stress.
> vmpressure parameters selected empiricaly quite long time ago and not
> always suitable for modern memory configurations. Modern 8 GB devices
> starts triggering medium threshold when about 3 GB memory not used,
> and situation with 12 and 16 GB devices even worse.

I am sorry but this doesn't answer questions I've had for the previous
version of the patch. Please do not post newer versions until there is a
consensusn on the approach based on the review feedback. In order to not
fragment the discussion, let's continue in the original email thread
http://lkml.kernel.org/r/20200413215750.7239-1-lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org
-- 
Michal Hocko
SUSE Labs
