From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] mm: memcontrol: Add the missing
 numa_stat interface for cgroup v2
Date: Tue, 15 Sep 2020 10:44:01 +0800
Message-ID: <CAMZfGtVvi5uY7iDAfWVVzaAy8YmfM9-UJ60p=aCw59Q=KKS-Vw@mail.gmail.com>
References: <20200913070010.44053-1-songmuchun@bytedance.com> <8387344f-0e43-9b6e-068d-b2c45bbda1de@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRm2Nxbq6RoVxMTPA/SHMqmJrVHr838yuFX4cqndMt0=;
        b=eFWJJ0TF8vJC4+HhW6AD/lLi2RSYaQDrfjMEP5aBQwKpOBh+N89x6QvOvayKTyfUAv
         J1VijI5i7/xN7kqGEV3O9vOg2jd37zxxSvagDqHHsFxvqOrKSIPgQlRF02NPvFru9249
         6FEZNt14c57Y1HZfaWJ4194FK/cVLCXbSwWHDqmGVVhfG6R+DYJqiI8woGHMfB8UbBI5
         GzM6ol77fu87BqvhuvY4IfjF+RehsqB3RsQcYvZHpKdSYE9672De8rmIQjtoMLebx4bW
         Wm1gNdEATLWCiB3Ebhku7lVbSw/2hVV2QcZwW7pGs3Nl+MSSI6x52vcD8b8QONt025UP
         5I+g==
In-Reply-To: <8387344f-0e43-9b6e-068d-b2c45bbda1de-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Sep 15, 2020 at 3:07 AM Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On 9/13/20 12:00 AM, Muchun Song wrote:
> > In the cgroup v1, we have a numa_stat interface. This is useful for
> > providing visibility into the numa locality information within an
> > memcg since the pages are allowed to be allocated from any physical
> > node. One of the use cases is evaluating application performance by
> > combining this information with the application's CPU allocation.
> > But the cgroup v2 does not. So this patch adds the missing information.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  changelog in v3:
> >  1. Fix compiler error on powerpc architecture reported by kernel test robot.
> >  2. Fix a typo from "anno" to "anon".
> >
> >  changelog in v2:
> >  1. Add memory.numa_stat interface in cgroup v2.
> >
> >  Documentation/admin-guide/cgroup-v2.rst |  72 ++++++++++++++++
> >  mm/memcontrol.c                         | 107 ++++++++++++++++++++++++
> >  2 files changed, 179 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 6be43781ec7f..92207f0012e4 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1368,6 +1368,78 @@ PAGE_SIZE multiple when read back.
> >               collapsing an existing range of pages. This counter is not
> >               present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
> >
> > +  memory.numa_stat
> > +     A read-only flat-keyed file which exists on non-root cgroups.
> > +
> > +     This breaks down the cgroup's memory footprint into different
> > +     types of memory, type-specific details, and other information
> > +     per node on the state of the memory management system.
> > +
> > +     This is useful for providing visibility into the numa locality
>
> capitalize acronyms, please:                             NUMA

OK, I will do that. Thanks.

>
>
> > +     information within an memcg since the pages are allowed to be
> > +     allocated from any physical node. One of the use cases is evaluating
> > +     application performance by combining this information with the
> > +     application's CPU allocation.
> > +
> > +     All memory amounts are in bytes.
> > +
> > +     The output format of memory.numa_stat is::
> > +
> > +       type N0=<node 0 pages> N1=<node 1 pages> ...
>
> Now I'm confused.  5 lines above here it says "All memory amounts are in bytes"
> but these appear to be in pages. Which is it?  and what size pages if that matters?

Sorry. It's my mistake. I will fix it.

>
> Is it like this?
>           type N0=<bytes in node 0 pages> N1=<bytes in node 1 pages> ...

Thanks.

>
>
>
> > +     The entries are ordered to be human readable, and new entries
> > +     can show up in the middle. Don't rely on items remaining in a
> > +     fixed position; use the keys to look up specific values!
> > +
> > +       anon
> > +             Amount of memory per node used in anonymous mappings such
> > +             as brk(), sbrk(), and mmap(MAP_ANONYMOUS)
> > +
> > +       file
> > +             Amount of memory per node used to cache filesystem data,
> > +             including tmpfs and shared memory.
> > +
> > +       kernel_stack
> > +             Amount of memory per node allocated to kernel stacks.
> > +
> > +       shmem
> > +             Amount of cached filesystem data per node that is swap-backed,
> > +             such as tmpfs, shm segments, shared anonymous mmap()s
> > +
> > +       file_mapped
> > +             Amount of cached filesystem data per node mapped with mmap()
> > +
> > +       file_dirty
> > +             Amount of cached filesystem data per node that was modified but
> > +             not yet written back to disk
> > +
> > +       file_writeback
> > +             Amount of cached filesystem data per node that was modified and
> > +             is currently being written back to disk
> > +
> > +       anon_thp
> > +             Amount of memory per node used in anonymous mappings backed by
> > +             transparent hugepages
> > +
> > +       inactive_anon, active_anon, inactive_file, active_file, unevictable
> > +             Amount of memory, swap-backed and filesystem-backed,
> > +             per node on the internal memory management lists used
> > +             by the page reclaim algorithm.
> > +
> > +             As these represent internal list state (eg. shmem pages are on anon
>
>                                                          e.g.

Thanks.

>
> > +             memory management lists), inactive_foo + active_foo may not be equal to
> > +             the value for the foo counter, since the foo counter is type-based, not
> > +             list-based.
> > +
> > +       slab_reclaimable
> > +             Amount of memory per node used for storing in-kernel data
> > +             structures which might be reclaimed, such as dentries and
> > +             inodes.
> > +
> > +       slab_unreclaimable
> > +             Amount of memory per node used for storing in-kernel data
> > +             structures which cannot be reclaimed on memory pressure.
>
> Some of the descriptions above end with a '.' and some do not. Please be consistent.

Will do that.

>
> > +
> >    memory.swap.current
> >       A read-only single value file which exists on non-root
> >       cgroups.
>
>
> thanks.
> --
> ~Randy
>


-- 
Yours,
Muchun
