From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Sun, 26 Jun 2022 03:32:02 -0700
Message-ID: <CAJD7tkbeTtkMcVri9vzKHATjxAVZfC_vPNfApJiyRxY53c8pZQ@mail.gmail.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FGwBQWTfDP6NE9brdT5NpzAYQxVOdxA8Jol43hGxIq4=;
        b=F1UaSNRjTXS2/5lwFjrcRrOhaAihT2PhrHs5IN+vAP194dJCSPRi2f4Wcy4HRiDFXr
         z9RDXTNqOU8Kor9bg9JVir4Vq1k19REe1H5I9Yjy7dNSfJYwYekTzJoXw7e1AoTZp57e
         3P3jhkbyobnGxWKU+R7p5c3t7y5IIGmC+Nyc6P+5+xlPi2UXxrMKgCvMQYpWxMtSPBUP
         Te6C9AT25mJZlhbY2bK4jnMlOGbUUjrpwvIViYOVxV+DSQnWYjhxxQZ+z32yRES3lIYz
         qazhfNZa+OE63i9s+VfcF1R3VF0rS92upyMIr1LKocriqOvOnHdajyRRg6AfL3KW7frF
         8aVw==
In-Reply-To: <20220621125658.64935-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Jun 21, 2022 at 5:57 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrot=
e:
>
> This version is rebased on mm-unstable. Hopefully, Andrew can get this se=
ries
> into mm-unstable which will help to determine whether there is a problem =
or
> degradation. I am also doing some benchmark tests in parallel.
>
> Since the following patchsets applied. All the kernel memory are charged
> with the new APIs of obj_cgroup.
>
>         commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab obje=
cts instead of pages")
>         commit b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to char=
ge kmem pages")
>
> But user memory allocations (LRU pages) pinning memcgs for a long time -
> it exists at a larger scale and is causing recurring problems in the real
> world: page cache doesn't get reclaimed for a long time, or is used by th=
e
> second, third, fourth, ... instance of the same job that was restarted in=
to
> a new cgroup every time. Unreclaimable dying cgroups pile up, waste memor=
y,
> and make page reclaim very inefficient.
>
> We can convert LRU pages and most other raw memcg pins to the objcg direc=
tion
> to fix this problem, and then the LRU pages will not pin the memcgs.
>
> This patchset aims to make the LRU pages to drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the numb=
er
> of the dying cgroups will not increase if we run the following test scrip=
t.

This is amazing work!

Sorry if I came late, I didn't follow the threads of previous versions
so this might be redundant, I just have a couple of questions.

a) If LRU pages keep getting parented until they reach root_mem_cgroup
(assuming they can), aren't these pages effectively unaccounted at
this point or leaked? Is there protection against this?

b) Since moving charged pages between memcgs is now becoming easier by
using the APIs of obj_cgroup, I wonder if this opens the door for
future work to transfer charges to memcgs that are actually using
reparented resources. For example, let's say cgroup A reads a few
pages into page cache, and then they are no longer used by cgroup A.
cgroup B, however, is using the same pages that are currently charged
to cgroup A, so it keeps taxing cgroup A for its use. When cgroup A
dies, and these pages are reparented to A's parent, can we possibly
mark these reparented pages (maybe in the page tables somewhere) so
that next time they get accessed we recharge them to B instead
(possibly asynchronously)?
I don't have much experience about page tables but I am pretty sure
they are loaded so maybe there is no room in PTEs for something like
this, but I have always wondered about what we can do for this case
where a cgroup is consistently using memory charged to another cgroup.
Maybe when this memory is reparented is a good point in time to decide
to recharge appropriately. It would also fix the reparenty leak to
root problem (if it even exists).

Thanks again for this work and please excuse my ignorance if any part
of what I said doesn't make sense :)

>
> ```bash
> #!/bin/bash
>
> dd if=3D/dev/zero of=3Dtemp bs=3D4096 count=3D1
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
> v5: https://lore.kernel.org/all/20220530074919.46352-1-songmuchun@bytedan=
ce.com/
> v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuchun@bytedan=
ce.com/
> v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuchun@bytedan=
ce.com/
> v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuchun@bytedan=
ce.com/
> v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuchun@bytedan=
ce.com/
> RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-songmuchun@byt=
edance.com/
> RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-songmuchun@byt=
edance.com/
> RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-songmuchun@byt=
edance.com/
> RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun@byt=
edance.com/
>
> v6:
>  - Collect Acked-by and Reviewed-by from Roman and Michal Koutn=C3=BD. Th=
anks.
>  - Rebase to mm-unstable.
>
> v5:
>  - Lots of improvements from Johannes, Roman and Waiman.
>  - Fix lockdep warning reported by kernel test robot.
>  - Add two new patches to do code cleanup.
>  - Collect Acked-by and Reviewed-by from Johannes and Roman.
>  - I didn't replace local_irq_disable/enable() to local_lock/unlock_irq()=
 since
>    local_lock/unlock_irq() takes an parameter, it needs more thinking to =
transform
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
>   mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance function
>   mm: lru: use lruvec lock to serialize memcg changes
>
>  fs/buffer.c                      |   4 +-
>  fs/fs-writeback.c                |  23 +-
>  include/linux/memcontrol.h       | 218 +++++++++------
>  include/linux/mm_inline.h        |   6 +
>  include/trace/events/writeback.h |   5 +
>  mm/compaction.c                  |  39 ++-
>  mm/huge_memory.c                 | 153 ++++++++--
>  mm/memcontrol.c                  | 584 +++++++++++++++++++++++++++------=
------
>  mm/migrate.c                     |   4 +
>  mm/mlock.c                       |   2 +-
>  mm/page_io.c                     |   5 +-
>  mm/swap.c                        |  49 ++--
>  mm/vmscan.c                      |  66 ++---
>  13 files changed, 776 insertions(+), 382 deletions(-)
>
>
> base-commit: 882be1ed6b1b5073fc88552181b99bd2b9c0031f
> --
> 2.11.0
>
>
