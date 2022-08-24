From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Wed, 24 Aug 2022 10:13:43 -0700
Message-ID: <CAJuCfpF3oH5nPKG5qVwORKJw8x_LPgF-7aZTY8qwKQhJ1s9ssg@mail.gmail.com>
References: <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
 <Yv/EArPDTcCrGqJh@slm.duckdns.org> <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
 <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
 <YwRjyx6wFLk8WTDe@dhcp22.suse.cz> <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
 <YwSQ4APOu/H7lYGL@dhcp22.suse.cz> <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz> <CAJuCfpH+T9+eOVYDfOv9yNSfAvq=pJtMp4ZaoYaM7iMY9XkaUw@mail.gmail.com>
 <YwXaXHRhy51xH4rk@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nALw85bqOF3gyi0IhYuUBAdShMU6pleGfRDPmIPW20o=;
        b=TvMpTzzprKB3QQsEsxpI6k6LbDetrJ6rCT+0LkjJ52Y8ACXF2oZ2UiUTjQmUzRTHNX
         ZSMC/uHhXMTLWadDIylZQbtLSbYb+o+RDxb83Jx4hsLdQy/2adQOWzB1Acr5QssUCVYO
         805SbwHsXmGqRmqOfdfws/s238Ow1e4LD7pEodwsewLLMGUr+QGT/MOt5E7Cf2tbYTeB
         uhkJdGeATjYm09x6D8CjbfhkvTp/g4/hD9nmZDHKqWcHHkMPGJBYuqexJ7gcRqWRdow2
         e/IcQ89lTNCSTEjLWvozENuPJxmKTyR693FGsrIPFAHBSG+9WyuU1UBA329tTD8DquTx
         YlbQ==
In-Reply-To: <YwXaXHRhy51xH4rk-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Wed, Aug 24, 2022 at 12:59 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 23-08-22 09:21:16, Suren Baghdasaryan wrote:
> > On Tue, Aug 23, 2022 at 4:51 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Tue 23-08-22 17:20:59, Zhaoyang Huang wrote:
> > > > On Tue, Aug 23, 2022 at 4:33 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Tue 23-08-22 14:03:04, Zhaoyang Huang wrote:
> > > > > > On Tue, Aug 23, 2022 at 1:21 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > > >
> > > > > > > On Tue 23-08-22 10:31:57, Zhaoyang Huang wrote:
> > > > > [...]
> > > > > > > > I would like to quote the comments from google side for more details
> > > > > > > > which can also be observed from different vendors.
> > > > > > > > "Also be advised that when you enable memcg v2 you will be using
> > > > > > > > per-app memcg configuration which implies noticeable overhead because
> > > > > > > > every app will have its own group. For example pagefault path will
> > > > > > > > regress by about 15%. And obviously there will be some memory overhead
> > > > > > > > as well. That's the reason we don't enable them in Android by
> > > > > > > > default."
> > > > > > >
> > > > > > > This should be reported and investigated. Because per-application memcg
> > > > > > > vs. memcg in general shouldn't make much of a difference from the
> > > > > > > performance side. I can see a potential performance impact for no-memcg
> > > > > > > vs. memcg case but even then 15% is quite a lot.
> > > > > > Less efficiency on memory reclaim caused by multi-LRU should be one of
> > > > > > the reason, which has been proved by comparing per-app memcg on/off.
> > > > > > Besides, theoretically workingset could also broken as LRU is too
> > > > > > short to compose workingset.
> > > > >
> > > > > Do you have any data to back these claims? Is this something that could
> > > > > be handled on the configuration level? E.g. by applying low limit
> > > > > protection to keep the workingset in the memory?
> > > > I don't think so. IMO, workingset works when there are pages evicted
> > > > from LRU and then refault which provide refault distance for pages.
> > > > Applying memcg's protection will have all LRU out of evicted which
> > > > make the mechanism fail.
> > >
> > > It is really hard to help you out without any actual data. The idea was
> > > though to use the low limit protection to adaptively configure
> > > respective memcgs to reduce refaults. You already have data about
> > > refaults ready so increasing the limit for often refaulting memcgs would
> > > reduce the trashing.
> >
> > Sorry for joining late.
> > A couple years ago I tested root-memcg vs per-app memcg configurations
> > on an Android phone. Here is a snapshot from my findings:
> >
> > Problem
> > =======
> > We see tangible increase in major faults and workingset refaults when
> > transitioning from root-only memory cgroup to per-application cgroups
> > on Android.
> >
> > Test results
> > ============
> > Results while running memory-demanding workload:
> > root memcg     per-app memcg     delta
> > workingset_refault 1771228 3874281 +118.73%
> > workingset_nodereclaim 4543 13928 +206.58%
> > pgpgin 13319208 20618944 +54.81%
> > pgpgout 1739552 3080664 +77.1%
> > pgpgoutclean 2616571 4805755 +83.67%
> > pswpin 359211 3918716 +990.92%
> > pswpout 1082238 5697463 +426.45%
> > pgfree 28978393 32531010 +12.26%
> > pgactivate 2586562 8731113 +237.56%
> > pgdeactivate 3811074 11670051 +206.21%
> > pgfault 38692510 46096963 +19.14%
> > pgmajfault 441288 4100020 +829.1%
> > pgrefill 4590451 12768165 +178.15%
> >
> > Results while running application cycle test (20 apps, 20 cycles):
> > root memcg     per-app memcg     delta
> > workingset_refault 10634691 11429223 +7.47%
> > workingset_nodereclaim 37477 59033 +57.52%
> > pgpgin 70662840 69569516 -1.55%
> > pgpgout 2605968 2695596 +3.44%
> > pgpgoutclean 13514955 14980610 +10.84%
> > pswpin 1489851 3780868 +153.77%
> > pswpout 4125547 8050819 +95.15%
> > pgfree 99823083 105104637 +5.29%
> > pgactivate 7685275 11647913 +51.56%
> > pgdeactivate 14193660 21459784 +51.19%
> > pgfault 89173166 100598528 +12.81%
> > pgmajfault 1856172 4227190 +127.74%
> > pgrefill 16643554 23203927 +39.42%
>
> Thanks! It would be interesting to see per memcg stats as well. Are
> there any outliers? Are there any signs of over-reclaim (more pages
> scanned & reclaimed by both kswapd and direct reclaim?

I don't have all the details from that study but will capture them
when I rerun the tests on newer kernels.

>
> > Tests were conducted on an Android phone with 4GB RAM.
> > Similar regression was reported a couple years ago here:
> > https://www.spinics.net/lists/linux-mm/msg121665.html
> >
> > I plan on checking the difference again on newer kernels (likely 5.15)
> > after LPC this September.
>
> Thanks, that would be useful!
>
> --
> Michal Hocko
> SUSE Labs
