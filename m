From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH V12 0/3] Charge loop device i/o to issuing cgroup
Date: Mon, 12 Apr 2021 11:45:43 -0400
Message-ID: <YHRrJ9V6ivpH2QUN@cmpxchg.org>
References: <20210402191638.3249835-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kfoth3DUauDj/zrpRCce8PdDzNFJJLR4/XpIPoAKXQU=;
        b=Owzv05Whms1oDjuZM/6YbmVlFXK8+Ru+WOmEeTUw67LZ9MzyO3tjJcMFUYIgu8JsB/
         F+sdUXv/uPOYDFFOuLUXCEhTfHNicqCX2k8/+9mUBv6WL89MISNCnmgx/F/je51Oqvhh
         ZKfJQzNtFnPaqxkS5robFFOh/ZI2NYKdCGFjCaqgQJrNwko2SThfMxcwbaWyFYSq2cb8
         87AjDiof+oM9uMz9xSWz3ehvEmrX6eySasPvyQHIVtg+6Vr8Rtwy44bpcBJoyOZx/5yy
         YgGWHnrkJw2Q77RhyHZxAINS4Z2N8V8UXge4yxiozkuQWMOPCzhfLxSHpwy4L4YjZVW3
         kZLw==
Content-Disposition: inline
In-Reply-To: <20210402191638.3249835-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

It looks like all feedback has been addressed and there hasn't been
any new activity on it in a while.

As per the suggestion last time [1], Andrew, Jens, could this go
through the -mm tree to deal with the memcg conflicts?

[1] https://lore.kernel.org/lkml/CALvZod6FMQQC17Zsu9xoKs=dFWaJdMC2Qk3YiDPUUQHx8teLYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

On Fri, Apr 02, 2021 at 12:16:31PM -0700, Dan Schatzberg wrote:
> No major changes, rebased on top of latest mm tree
> 
> Changes since V12:
> 
> * Small change to get_mem_cgroup_from_mm to avoid needing
>   get_active_memcg
> 
> Changes since V11:
> 
> * Removed WQ_MEM_RECLAIM flag from loop workqueue. Technically, this
>   can be driven by writeback, but this was causing a warning in xfs
>   and likely other filesystems aren't equipped to be driven by reclaim
>   at the VFS layer.
> * Included a small fix from Colin Ian King.
> * reworked get_mem_cgroup_from_mm to institute the necessary charge
>   priority.
> 
> Changes since V10:
> 
> * Added page-cache charging to mm: Charge active memcg when no mm is set
> 
> Changes since V9:
> 
> * Rebased against linus's branch which now includes Roman Gushchin's
>   patch this series is based off of
> 
> Changes since V8:
> 
> * Rebased on top of Roman Gushchin's patch
>   (https://lkml.org/lkml/2020/8/21/1464) which provides the nesting
>   support for setting active memcg. Dropped the patch from this series
>   that did the same thing.
> 
> Changes since V7:
> 
> * Rebased against linus's branch
> 
> Changes since V6:
> 
> * Added separate spinlock for worker synchronization
> * Minor style changes
> 
> Changes since V5:
> 
> * Fixed a missing css_put when failing to allocate a worker
> * Minor style changes
> 
> Changes since V4:
> 
> Only patches 1 and 2 have changed.
> 
> * Fixed irq lock ordering bug
> * Simplified loop detach
> * Added support for nesting memalloc_use_memcg
> 
> Changes since V3:
> 
> * Fix race on loop device destruction and deferred worker cleanup
> * Ensure charge on shmem_swapin_page works just like getpage
> * Minor style changes
> 
> Changes since V2:
> 
> * Deferred destruction of workqueue items so in the common case there
>   is no allocation needed
> 
> Changes since V1:
> 
> * Split out and reordered patches so cgroup charging changes are
>   separate from kworker -> workqueue change
> 
> * Add mem_css to struct loop_cmd to simplify logic
> 
> The loop device runs all i/o to the backing file on a separate kworker
> thread which results in all i/o being charged to the root cgroup. This
> allows a loop device to be used to trivially bypass resource limits
> and other policy. This patch series fixes this gap in accounting.
> 
> A simple script to demonstrate this behavior on cgroupv2 machine:
> 
> '''
> #!/bin/bash
> set -e
> 
> CGROUP=/sys/fs/cgroup/test.slice
> LOOP_DEV=/dev/loop0
> 
> if [[ ! -d $CGROUP ]]
> then
>     sudo mkdir $CGROUP
> fi
> 
> grep oom_kill $CGROUP/memory.events
> 
> # Set a memory limit, write more than that limit to tmpfs -> OOM kill
> sudo unshare -m bash -c "
> echo \$\$ > $CGROUP/cgroup.procs;
> echo 0 > $CGROUP/memory.swap.max;
> echo 64M > $CGROUP/memory.max;
> mount -t tmpfs -o size=512m tmpfs /tmp;
> dd if=/dev/zero of=/tmp/file bs=1M count=256" || true
> 
> grep oom_kill $CGROUP/memory.events
> 
> # Set a memory limit, write more than that limit through loopback
> # device -> no OOM kill
> sudo unshare -m bash -c "
> echo \$\$ > $CGROUP/cgroup.procs;
> echo 0 > $CGROUP/memory.swap.max;
> echo 64M > $CGROUP/memory.max;
> mount -t tmpfs -o size=512m tmpfs /tmp;
> truncate -s 512m /tmp/backing_file
> losetup $LOOP_DEV /tmp/backing_file
> dd if=/dev/zero of=$LOOP_DEV bs=1M count=256;
> losetup -D $LOOP_DEV" || true
> 
> grep oom_kill $CGROUP/memory.events
> '''
> 
> Naively charging cgroups could result in priority inversions through
> the single kworker thread in the case where multiple cgroups are
> reading/writing to the same loop device. This patch series does some
> minor modification to the loop driver so that each cgroup can make
> forward progress independently to avoid this inversion.
> 
> With this patch series applied, the above script triggers OOM kills
> when writing through the loop device as expected.
> 
> Dan Schatzberg (3):
>   loop: Use worker per cgroup instead of kworker
>   mm: Charge active memcg when no mm is set
>   loop: Charge i/o to mem and blk cg
> 
>  drivers/block/loop.c       | 244 ++++++++++++++++++++++++++++++-------
>  drivers/block/loop.h       |  15 ++-
>  include/linux/memcontrol.h |   6 +
>  kernel/cgroup/cgroup.c     |   1 +
>  mm/filemap.c               |   2 +-
>  mm/memcontrol.c            |  49 +++++---
>  mm/shmem.c                 |   4 +-
>  7 files changed, 253 insertions(+), 68 deletions(-)
> 
> -- 
> 2.30.2
> 
> 
