From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Wed, 17 Jun 2020 19:07:20 +0530
Message-ID: <CA+G9fYsdsgRmwLtSKJSzB1eWcUQ1z-_aaU+BNcQpker34XT6_w@mail.gmail.com>
References: <CA+G9fYu2ruH-8uxBHE0pdE6RgRTSx4QuQPAN=Nv3BCdRd2ouYA@mail.gmail.com>
 <20200501135806.4eebf0b92f84ab60bba3e1e7@linux-foundation.org>
 <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz> <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name> <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqR44w8izx/KE5EkQ1Ws5ETNchnRTHELluIzCKgLjZQ=;
        b=AQDHF9j1wumEdOF8jW/1ZD+wMd/8SpKXUSrLOHAhi0A44X1JaVVNvxPIvK23AWFQl1
         lcfd2qLeHyI1mOR56hQwvpPqFkxdvrqlLEDd85my4N1iUDfAlgcF8AzsgKWBK3zrgNCe
         FfcZd/NGkaf2Mw5/0Wi7/NN8GlYj/dE1H3Y2K/UdByyIhfAVRQSJIdp1UXJN3EirQcCx
         gGhwwgc+eOdRDRZohnKU4obNcVnQwSt7TB0Y31V6blCHXIgexA++Mbo6gO8D5gHDGqpn
         e08UA7hYCS3YGjFr+hICEEExE+bXh2EV+2ZuVFnYmW334FTROJKMWUws6mNfrG1VlVfC
         NXPg==
In-Reply-To: <20200521163450.GV6462-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman

On Thu, 21 May 2020 at 22:04, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Thu 21-05-20 11:55:16, Michal Hocko wrote:
> > On Wed 20-05-20 20:09:06, Chris Down wrote:
> > > Hi Naresh,
> > >
> > > Naresh Kamboju writes:
> > > > As a part of investigation on this issue LKFT teammate Anders Roxell
> > > > git bisected the problem and found bad commit(s) which caused this problem.
> > > >
> > > > The following two patches have been reverted on next-20200519 and retested the
> > > > reproducible steps and confirmed the test case mkfs -t ext4 got PASS.
> > > > ( invoked oom-killer is gone now)
> > > >
> > > > Revert "mm, memcg: avoid stale protection values when cgroup is above
> > > > protection"
> > > >    This reverts commit 23a53e1c02006120f89383270d46cbd040a70bc6.
> > > >
> > > > Revert "mm, memcg: decouple e{low,min} state mutations from protection
> > > > checks"
> > > >    This reverts commit 7b88906ab7399b58bb088c28befe50bcce076d82.
> > >
> > > Thanks Anders and Naresh for tracking this down and reverting.
> > >
> > > I'll take a look tomorrow. I don't see anything immediately obviously wrong
> > > in either of those commits from a (very) cursory glance, but they should
> > > only be taking effect if protections are set.
> >
> > Agreed. If memory.{low,min} is not used then the patch should be
> > effectively a nop.
>
> I was staring into the code and do not see anything.  Could you give the
> following debugging patch a try and see whether it triggers?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index cc555903a332..df2e8df0eb71 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2404,6 +2404,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>                          * sc->priority further than desirable.
>                          */
>                         scan = max(scan, SWAP_CLUSTER_MAX);
> +
> +                       trace_printk("scan:%lu protection:%lu\n", scan, protection);
>                 } else {
>                         scan = lruvec_size;
>                 }
> @@ -2648,6 +2650,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>                 mem_cgroup_calculate_protection(target_memcg, memcg);
>
>                 if (mem_cgroup_below_min(memcg)) {
> +                       trace_printk("under min:%lu emin:%lu\n", memcg->memory.min, memcg->memory.emin);
>                         /*
>                          * Hard protection.
>                          * If there is no reclaimable memory, OOM.
> @@ -2660,6 +2663,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>                          * there is an unprotected supply
>                          * of reclaimable memory from other cgroups.
>                          */
> +                       trace_printk("under low:%lu elow:%lu\n", memcg->memory.low, memcg->memory.elow);
>                         if (!sc->memcg_low_reclaim) {
>                                 sc->memcg_low_skipped = 1;
>                                 continue;

As per your suggestions on debugging this problem,
trace_printk is replaced with printk and applied to your patch on top of the
problematic kernel and here is the test output and link.

mkfs -t ext4 /dev/disk/by-id/ata-TOSHIBA_MG04ACA100N_Y8RQK14KF6XF
mke2fs 1.43.8 (1-Jan-2018)
Creating filesystem with 244190646 4k blocks and 61054976 inodes
Filesystem UUID: 7c380766-0ed8-41ba-a0de-3c08e78f1891
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
102400000, 214990848
Allocating group tables:    0/7453 done
Writing inode tables:    0/7453 done
Creating journal (262144 blocks): [   51.544525] under min:0 emin:0
[   51.845304] under min:0 emin:0
[   51.848738] under min:0 emin:0
[   51.858147] under min:0 emin:0
[   51.861333] under min:0 emin:0
[   51.862034] under min:0 emin:0
[   51.862442] under min:0 emin:0
[   51.862763] under min:0 emin:0

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1497412#L1451

- Naresh
