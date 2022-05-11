From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 1/6] Documentation: filesystems: proc: update meminfo
 section
Date: Wed, 11 May 2022 14:51:25 -0400
Message-ID: <YnwFraZlVWQoCjz3@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-2-hannes@cmpxchg.org>
 <7a6f8520-a496-e3c3-1fd9-8a30b7a12b14@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2M4Jyxc4ZhLMOpYVi4rOXmZMkxhNrB3SJA5cGP33wsw=;
        b=hIi47nK8NjD/G3LuJK2PAPk/bVzllp+fLuCexjLy4BH8rKTDb3JBxsVc6CiFPUlPYm
         RpZNxJsX1BtpycEgYFrmcIy0UVGH5dv8mOjYtvNKe9RPUDQdoiwdsJmIn2ep3UNfURjW
         E2QbN4oSEUFmANl6EfG54igt6AaiRFeW547fvOMgwfaYYttkG4s/xM7BvmDZEE+FR999
         PoZRqh0zXwAngexKVvPpKCphvB7Q5/CfbAIBTAJCimizzjDj+kdaFCYVEb9w5vWoA/4k
         vKDJcYdGNKq2txfo+LtyBaJ6k1DmnFn9pS7PeY4cEyEnaECtZ2cR9mfB3WB/92BT2wi0
         WG2A==
Content-Disposition: inline
In-Reply-To: <7a6f8520-a496-e3c3-1fd9-8a30b7a12b14-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, May 11, 2022 at 07:11:06PM +0200, David Hildenbrand wrote:
> On 10.05.22 17:28, Johannes Weiner wrote:
> > Add new entries. Minor corrections and cleanups.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  Documentation/filesystems/proc.rst | 155 ++++++++++++++++++-----------
> >  1 file changed, 99 insertions(+), 56 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index 061744c436d9..736ed384750c 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -942,56 +942,71 @@ can be substantial.  In many cases there are other means to find out
> >  additional memory using subsystem specific interfaces, for instance
> >  /proc/net/sockstat for TCP memory allocations.
> >  
> > -The following is from a 16GB PIII, which has highmem enabled.
> > -You may not have all of these fields.
> > +Example output. You may not have all of these fields.
> >  
> >  ::
> >  
> >      > cat /proc/meminfo
> >  
> > -    MemTotal:     16344972 kB
> > -    MemFree:      13634064 kB
> > -    MemAvailable: 14836172 kB
> > -    Buffers:          3656 kB
> > -    Cached:        1195708 kB
> > -    SwapCached:          0 kB
> > -    Active:         891636 kB
> > -    Inactive:      1077224 kB
> > -    HighTotal:    15597528 kB
> > -    HighFree:     13629632 kB
> > -    LowTotal:       747444 kB
> > -    LowFree:          4432 kB
> > -    SwapTotal:           0 kB
> > -    SwapFree:            0 kB
> > -    Dirty:             968 kB
> > -    Writeback:           0 kB
> > -    AnonPages:      861800 kB
> > -    Mapped:         280372 kB
> > -    Shmem:             644 kB
> > -    KReclaimable:   168048 kB
> > -    Slab:           284364 kB
> > -    SReclaimable:   159856 kB
> > -    SUnreclaim:     124508 kB
> > -    PageTables:      24448 kB
> > -    NFS_Unstable:        0 kB
> > -    Bounce:              0 kB
> > -    WritebackTmp:        0 kB
> > -    CommitLimit:   7669796 kB
> > -    Committed_AS:   100056 kB
> > -    VmallocTotal:   112216 kB
> > -    VmallocUsed:       428 kB
> > -    VmallocChunk:   111088 kB
> > -    Percpu:          62080 kB
> > -    HardwareCorrupted:   0 kB
> > -    AnonHugePages:   49152 kB
> > -    ShmemHugePages:      0 kB
> > -    ShmemPmdMapped:      0 kB
> > +    MemTotal:       32858820 kB
> > +    MemFree:        21001236 kB
> > +    MemAvailable:   27214312 kB
> > +    Buffers:          581092 kB
> > +    Cached:          5587612 kB
> > +    SwapCached:            0 kB
> > +    Active:          3237152 kB
> > +    Inactive:        7586256 kB
> > +    Active(anon):      94064 kB
> > +    Inactive(anon):  4570616 kB
> > +    Active(file):    3143088 kB
> > +    Inactive(file):  3015640 kB
> > +    Unevictable:           0 kB
> > +    Mlocked:               0 kB
> > +    SwapTotal:             0 kB
> > +    SwapFree:              0 kB
> > +    Dirty:                12 kB
> > +    Writeback:             0 kB
> > +    AnonPages:       4654780 kB
> > +    Mapped:           266244 kB
> > +    Shmem:              9976 kB
> > +    KReclaimable:     517708 kB
> > +    Slab:             660044 kB
> > +    SReclaimable:     517708 kB
> > +    SUnreclaim:       142336 kB
> > +    KernelStack:       11168 kB
> > +    PageTables:        20540 kB
> > +    NFS_Unstable:          0 kB
> > +    Bounce:                0 kB
> > +    WritebackTmp:          0 kB
> > +    CommitLimit:    16429408 kB
> > +    Committed_AS:    7715148 kB
> > +    VmallocTotal:   34359738367 kB
> > +    VmallocUsed:       40444 kB
> > +    VmallocChunk:          0 kB
> > +    Percpu:            29312 kB
> > +    HardwareCorrupted:     0 kB
> > +    AnonHugePages:   4149248 kB
> > +    ShmemHugePages:        0 kB
> > +    ShmemPmdMapped:        0 kB
> > +    FileHugePages:         0 kB
> > +    FilePmdMapped:         0 kB
> > +    CmaTotal:              0 kB
> > +    CmaFree:               0 kB
> > +    HugePages_Total:       0
> > +    HugePages_Free:        0
> > +    HugePages_Rsvd:        0
> > +    HugePages_Surp:        0
> > +    Hugepagesize:       2048 kB
> > +    Hugetlb:               0 kB
> > +    DirectMap4k:      401152 kB
> > +    DirectMap2M:    10008576 kB
> > +    DirectMap1G:    24117248 kB
> >  
> >  MemTotal
> >                Total usable RAM (i.e. physical RAM minus a few reserved
> >                bits and the kernel binary code)
> >  MemFree
> > -              The sum of LowFree+HighFree
> > +              Total free RAM. On highmem systems, the sum of LowFree+HighFree
> >  MemAvailable
> >                An estimate of how much memory is available for starting new
> >                applications, without swapping. Calculated from MemFree,
> > @@ -1005,8 +1020,9 @@ Buffers
> >                Relatively temporary storage for raw disk blocks
> >                shouldn't get tremendously large (20MB or so)
> >  Cached
> > -              in-memory cache for files read from the disk (the
> > -              pagecache).  Doesn't include SwapCached
> > +              In-memory cache for files read from the disk (the
> > +              pagecache) as well as tmpfs & shmem.
> > +              Doesn't include SwapCached.
> >  SwapCached
> >                Memory that once was swapped out, is swapped back in but
> >                still also is in the swapfile (if memory is needed it
> > @@ -1018,6 +1034,11 @@ Active
> >  Inactive
> >                Memory which has been less recently used.  It is more
> >                eligible to be reclaimed for other purposes
> > +Unevictable
> > +              Memory that cannot be reclaimed, such as mlocked pages,
> > +              ramfs backing pages, secret memfd pages etc.
> 
> 
> A little imprecise, because this only includes memory to be mapped into
> user space. For example, all kernel allocations are unevictable but not
> accounted here.

True. How about the below?

> Apart from that
> 
> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks!

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 9749ff8c0ecf..5e9791457876 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1035,8 +1035,8 @@ Inactive
               Memory which has been less recently used.  It is more
               eligible to be reclaimed for other purposes
 Unevictable
-              Memory that cannot be reclaimed, such as mlocked pages,
-              ramfs backing pages, secret memfd pages etc.
+              Memory allocated for userspace which cannot be reclaimed, such
+              as mlocked pages, ramfs backing pages, secret memfd pages etc.
 Mlocked
               Memory locked with mlock().
 HighTotal, HighFree
