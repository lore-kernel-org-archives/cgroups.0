From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Wed, 15 Apr 2020 09:55:32 +0200
Message-ID: <20200415075532.GZ4629@dhcp22.suse.cz>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200414113730.GH4629@dhcp22.suse.cz>
 <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw@mail.gmail.com>
 <20200414192329.GC136578@cmpxchg.org>
 <CAELvCDS_z-bTvRZ7fxkfHjnjV1WzFcxarzrbT1pDwkXX_dmOoA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAELvCDS_z-bTvRZ7fxkfHjnjV1WzFcxarzrbT1pDwkXX_dmOoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, svc lmoiseichuk <svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 14-04-20 18:12:47, Leonid Moiseichuk wrote:
> I do not agree with all comments, see below.
> 
> On Tue, Apr 14, 2020 at 3:23 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> 
> > On Tue, Apr 14, 2020 at 12:42:44PM -0400, Leonid Moiseichuk wrote:
> > > On Tue, Apr 14, 2020 at 7:37 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > On Mon 13-04-20 17:57:48, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org wrote:
> > > > Anyway, I have to confess I am not a big fan of this. vmpressure turned
> > > > out to be a very weak interface to measure the memory pressure. Not
> > only
> > > > it is not numa aware which makes it unusable on many systems it also
> > > > gives data way too late from the practice.
> >
> > Yes, it's late in the game for vmpressure, and also a bit too late for
> > extensive changes in cgroup1.
> >
> 200 lines just to move functionality from one place to another without
> logic change?
> There does not seem to be extensive changes.

Any user visible API is an big change. We have to maintain any api for
ever. So there has to be a really strong reason/use case for inclusion.
I haven't heard any strong justification so far. It all seems to me that
you are trying to workaround real vmpressure issues by fine tunning
parameters and that is almost always a bad reason for a adding a new
tunning.
-- 
Michal Hocko
SUSE Labs
