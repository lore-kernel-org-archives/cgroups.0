From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Thu, 9 Jun 2022 10:43:24 +0800
Message-ID: <CAMZfGtX4hseDnJA9JrsXDG=nu28h+9UMMpKFnBZCL47Re1OvUg@mail.gmail.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=prX6WyWMXGMCSUeaVJB2ZxuxbAbxmHtKSKvsMPTKrf0=;
        b=HiKxEA77gEdI3I3BE79V5PQK3KMxHQbfmpv7jqv5Lsw73jYa7Mf/8CWcX6ikP+3dP+
         FkT/k0P7uNcR6LzK7utkZzBqWNXVP1LWSwwfuyEb+/g8zgNQbW7zCFaORPXRcwWQiK5w
         fpH4qCv/+ZhyxXyffZNzuXXcjSRNRbog1UOEkEFVZHnkuQwhXlw4ynGZBLQNiJpzGlB2
         UbC51DXUGA1XtA1M5azDogsiUfuuY4CNtdi1sX0HhOupR37jLkZ3UCs0wQRNK6woP+bU
         J7sy7fnr0IWA9emy2EzAHBvOTbvtKf/FiFjl6yvFGvjaGnxl306bEwMLBuiaER5dbng3
         pMFw==
In-Reply-To: <20220530074919.46352-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Xiongchun duan <duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi,

Friendly ping. Any comments or objections?

Thanks.

On Mon, May 30, 2022 at 3:50 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> This version is rebased on v5.18.
>
> Since the following patchsets applied. All the kernel memory are charged
> with the new APIs of obj_cgroup.
>
>         [v17,00/19] The new cgroup slab memory controller [1]
>         [v5,0/7] Use obj_cgroup APIs to charge kmem pages [2]
>
> But user memory allocations (LRU pages) pinning memcgs for a long time -
> it exists at a larger scale and is causing recurring problems in the real
> world: page cache doesn't get reclaimed for a long time, or is used by the
> second, third, fourth, ... instance of the same job that was restarted into
> a new cgroup every time. Unreclaimable dying cgroups pile up, waste memory,
> and make page reclaim very inefficient.
>
> We can convert LRU pages and most other raw memcg pins to the objcg direction
> to fix this problem, and then the LRU pages will not pin the memcgs.
>
> This patchset aims to make the LRU pages to drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> of the dying cgroups will not increase if we run the following test script.
>
> ```bash
> #!/bin/bash
>
> dd if=/dev/zero of=temp bs=4096 count=1
> cat /proc/cgroups | grep memory
>
> for i in {0..2000}
> do
>         mkdir /sys/fs/cgroup/memory/test$i
>         echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
>         cat temp >> log
>         echo $$ > /sys/fs/cgroup/memory/cgroup.procs
>         rmdir /sys/fs/cgroup/memory/test$i
> done
>
> cat /proc/cgroups | grep memory
>
> rm -f temp log
> ```
>
> [1] https://lore.kernel.org/linux-mm/20200623015846.1141975-1-guro-b10kYP2dOMg@public.gmane.org/
> [2] https://lore.kernel.org/linux-mm/20210319163821.20704-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>
> v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>
> v5:
>  - Lots of improvements from Johannes, Roman and Waiman.
>  - Fix lockdep warning reported by kernel test robot.
>  - Add two new patches to do code cleanup.
>  - Collect Acked-by and Reviewed-by from Johannes and Roman.
>  - I didn't replace local_irq_disable/enable() to local_lock/unlock_irq() since
>    local_lock/unlock_irq() takes an parameter, it needs more thinking to transform
>    it to local_lock.  It could be an improvement in the future.
>
> v4:
>  - Resend and rebased on v5.18.
>
> v3:
>  - Removed the Acked-by tags from Roman since this version is based on
>    the folio relevant.
>
> v2:
>  - Rename obj_cgroup_release_kmem() to obj_cgroup_release_bytes() and the
>    dependencies of CONFIG_MEMCG_KMEM (suggested by Roman, Thanks).
>  - Rebase to linux 5.15-rc1.
>  - Add a new pacth to cleanup mem_cgroup_kmem_disabled().
>
> v1:
>  - Drop RFC tag.
>  - Rebase to linux next-20210811.
>
> RFC v4:
>  - Collect Acked-by from Roman.
>  - Rebase to linux next-20210525.
>  - Rename obj_cgroup_release_uncharge() to obj_cgroup_release_kmem().
>  - Change the patch 1 title to "prepare objcg API for non-kmem usage".
>  - Convert reparent_ops_head to an array in patch 8.
>
> Thanks for Roman's review and suggestions.
>
> RFC v3:
>  - Drop the code cleanup and simplification patches. Gather those patches
>    into a separate series[1].
>  - Rework patch #1 suggested by Johannes.
>
> RFC v2:
>  - Collect Acked-by tags by Johannes. Thanks.
>  - Rework lruvec_holds_page_lru_lock() suggested by Johannes. Thanks.
>  - Fix move_pages_to_lru().
>
> Muchun Song (11):
>   mm: memcontrol: remove dead code and comments
>   mm: rename unlock_page_lruvec{_irq, _irqrestore} to
>     lruvec_unlock{_irq, _irqrestore}
>   mm: memcontrol: prepare objcg API for non-kmem usage
>   mm: memcontrol: make lruvec lock safe when LRU pages are reparented
>   mm: vmscan: rework move_pages_to_lru()
>   mm: thp: make split queue lock safe when LRU pages are reparented
>   mm: memcontrol: make all the callers of {folio,page}_memcg() safe
>   mm: memcontrol: introduce memcg_reparent_ops
>   mm: memcontrol: use obj_cgroup APIs to charge the LRU pages
>   mm: lru: add VM_BUG_ON_FOLIO to lru maintenance function
>   mm: lru: use lruvec lock to serialize memcg changes
>
>  fs/buffer.c                      |   4 +-
>  fs/fs-writeback.c                |  23 +-
>  include/linux/memcontrol.h       | 213 +++++++++------
>  include/linux/mm_inline.h        |   6 +
>  include/trace/events/writeback.h |   5 +
>  mm/compaction.c                  |  39 ++-
>  mm/huge_memory.c                 | 153 +++++++++--
>  mm/memcontrol.c                  | 560 +++++++++++++++++++++++++++------------
>  mm/migrate.c                     |   4 +
>  mm/mlock.c                       |   2 +-
>  mm/page_io.c                     |   5 +-
>  mm/swap.c                        |  62 ++---
>  mm/vmscan.c                      |  67 +++--
>  13 files changed, 767 insertions(+), 376 deletions(-)
>
>
> base-commit: 4b0986a3613c92f4ec1bdc7f60ec66fea135991f
> --
> 2.11.0
>
