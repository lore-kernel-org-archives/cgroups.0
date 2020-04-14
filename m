From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/2] memcg, vmpressure: expose vmpressure controls
Date: Tue, 14 Apr 2020 15:23:29 -0400
Message-ID: <20200414192329.GC136578@cmpxchg.org>
References: <20200413215750.7239-1-lmoiseichuk@magicleap.com>
 <20200414113730.GH4629@dhcp22.suse.cz>
 <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IiZNJMCD1kbGltSbdSP42lcTPVfZZdCFmf+wp01qYTo=;
        b=RwwCmIB7ctPm2eZIIKDEiOKmos3jQdBxTVEG5RvZSbkV6qx3mS8owINSN9Q4vZ7OIS
         RV2m8pThdMF5zEvqM8E1gyAWGDKpUUtKRbX2qGs7db5dBKU+S9aWrAM7z6XMQCvIbpSV
         RHT+8Xv7lNrxl4dZwvcKb9a30lxz9ZqbNxtyS6EtjXe2NOPVf0EkQm45oLKdDhlO0rkz
         v/6G1qSst8Q0DW/UeN6I0cwt0GE7xhFcDsDyAUiLCDVa9nrQjXrKPI8lk1vvJwlt2RM5
         ynB6xM183bbjPmwSl74sG2i8nCWCJ6aKUCDDLZc4WfCYXrewgkvLvBlv8vntw/Acb09x
         3g9Q==
Content-Disposition: inline
In-Reply-To: <CAELvCDTGnpA4WBAMZjGSLTrg2-Dbb3kTmLjMTw_JLYXBdvpcxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leonid Moiseichuk <lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vinmenon-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Apr 14, 2020 at 12:42:44PM -0400, Leonid Moiseichuk wrote:
> On Tue, Apr 14, 2020 at 7:37 AM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Mon 13-04-20 17:57:48, svc_lmoiseichuk-baZASSJvGmz3oGB3hsPCZA@public.gmane.org wrote:
> > Anyway, I have to confess I am not a big fan of this. vmpressure turned
> > out to be a very weak interface to measure the memory pressure. Not only
> > it is not numa aware which makes it unusable on many systems it also
> > gives data way too late from the practice.

Yes, it's late in the game for vmpressure, and also a bit too late for
extensive changes in cgroup1.

> > Btw. why don't you use /proc/pressure/memory resp. its memcg counterpart
> > to measure the memory pressure in the first place?
> >
> 
> According to our checks PSI produced numbers only when swap enabled e.g.
> swapless device 75% RAM utilization:
> ==> /proc/pressure/io <==
> some avg10=0.00 avg60=1.18 avg300=1.51 total=9642648
> full avg10=0.00 avg60=1.11 avg300=1.47 total=9271174
> 
> ==> /proc/pressure/memory <==
> some avg10=0.00 avg60=0.00 avg300=0.00 total=0
> full avg10=0.00 avg60=0.00 avg300=0.00 total=0

That doesn't look right. With total=0, there couldn't have been any
reclaim activity, which means that vmpressure couldn't have reported
anything either.

By the time vmpressure reports a drop in reclaim efficiency, psi
should have already been reporting time spent doing reclaim. It
reports a superset of the information conveyed by vmpressure.

> Probably it is possible to activate PSI by introducing high IO and swap
> enabled but that is not a typical case for mobile devices.
> 
> With swap-enabled case memory pressure follows IO pressure with some
> fraction i.e. memory is io/2 ... io/10 depending on pattern.
> Light sysbench case with swap enabled
> ==> /proc/pressure/io <==
> some avg10=0.00 avg60=0.00 avg300=0.11 total=155383820
> full avg10=0.00 avg60=0.00 avg300=0.05 total=100516966
> ==> /proc/pressure/memory <==
> some avg10=0.00 avg60=0.00 avg300=0.06 total=465916397
> full avg10=0.00 avg60=0.00 avg300=0.00 total=368664282
> 
> Since not all devices have zram or swap enabled it makes sense to have
> vmpressure tuning option possible since
> it is well used in Android and related issues are understandable.

Android (since 10 afaik) uses psi to make low memory / OOM
decisions. See the introduction of the psi poll() support:
https://lwn.net/Articles/782662/

It's true that with swap you may see a more gradual increase in
pressure, whereas without swap you may go from idle to OOM much
faster, depending on what type of memory is being allocated. But psi
will still report it. You may just have to use poll() to get in-time
notification like you do with vmpressure.
