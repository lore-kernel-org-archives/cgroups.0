From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: account "kmem" consumers in cgroup2
 memory controller
Date: Wed, 9 Dec 2015 09:32:58 -0500
Message-ID: <20151209143258.GA21506@cmpxchg.org>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-8-git-send-email-hannes@cmpxchg.org>
 <20151209113037.GS11488@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209113037.GS11488@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Dec 09, 2015 at 02:30:38PM +0300, Vladimir Davydov wrote:
> On Tue, Dec 08, 2015 at 01:34:24PM -0500, Johannes Weiner wrote:
> > The original cgroup memory controller has an extension to account slab
> > memory (and other "kernel memory" consumers) in a separate "kmem"
> > counter, once the user set an explicit limit on that "kmem" pool.
> > 
> > However, this includes various consumers whose sizes are directly
> > linked to userspace activity. Accounting them as an optional "kmem"
> > extension is problematic for several reasons:
> > 
> > 1. It leaves the main memory interface with incomplete semantics. A
> >    user who puts their workload into a cgroup and configures a memory
> >    limit does not expect us to leave holes in the containment as big
> >    as the dentry and inode cache, or the kernel stack pages.
> > 
> > 2. If the limit set on this random historical subgroup of consumers is
> >    reached, subsequent allocations will fail even when the main memory
> >    pool available to the cgroup is not yet exhausted and/or has
> >    reclaimable memory in it.
> > 
> > 3. Calling it 'kernel memory' is misleading. The dentry and inode
> >    caches are no more 'kernel' (or no less 'user') memory than the
> >    page cache itself. Treating these consumers as different classes is
> >    a historical implementation detail that should not leak to users.
> > 
> > So, in addition to page cache, anonymous memory, and network socket
> > memory, account the following memory consumers per default in the
> > cgroup2 memory controller:
> > 
> >      - threadinfo
> >      - task_struct
> >      - task_delay_info
> >      - pid
> >      - cred
> >      - mm_struct
> >      - vm_area_struct and vm_region (nommu)
> >      - anon_vma and anon_vma_chain
> >      - signal_struct
> >      - sighand_struct
> >      - fs_struct
> >      - files_struct
> >      - fdtable and fdtable->full_fds_bits
> >      - dentry and external_name
> >      - inode for all filesystems.
> > 
> > This should give us reasonable memory isolation for most common
> > workloads out of the box.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thank you!

> The patch looks good to me, but I think we still need to add a boot-time
> knob to disable kmem accounting, as we do for sockets:
> 
> From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Subject: [PATCH] mm: memcontrol: allow to disable kmem accounting for cgroup2
> 
> Kmem accounting might incur overhead that some users can't put up with.
> Besides, the implementation is still considered unstable. So let's
> provide a way to disable it for those users who aren't happy with it.
> 
> To disable kmem accounting for cgroup2, pass cgroup.memory=nokmem at
> boot time.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Especially in the early release phases, there might be birthing pain
that users in the field would want to work around. And I'd rather they
can selectively disable problematic parts during the transition than
switching back wholesale to the old cgroup interface.

For me that would be the prime reason: a temporary workaround for
legacy users until we get our stuff sorted out. Unacceptable overhead
or instability would be something we would have to address anyway.
And then it's fine too that the flag continues to use the historic
misnomer "kmem".
