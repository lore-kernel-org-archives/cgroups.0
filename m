From: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mpenttil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Mon, 27 Jun 2022 13:43:38 +0300
Message-ID: <e96f0885-16dc-3d2a-7220-2ff5e7a37737@redhat.com>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
 <CAJD7tkbeTtkMcVri9vzKHATjxAVZfC_vPNfApJiyRxY53c8pZQ@mail.gmail.com>
 <YrlYG0ecJyzFTVVz@FVFYT0MHHV2J.usts.net>
 <CAJD7tkbubDhpJV81qkXqRE5-yvvcjKrtPnZnECenafz+to=3_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656326625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kr/grU3kkgeweF+fN7RAjBDwzZqei/Z54c4DEpy1KMs=;
        b=cpR/mdhvmKtoV4nOgDnYYNfJjR/S+MqVogf5uxZuQ3+HY3BkRU/DwpvfqegvWsFB2Wi8e2
        I7ZQrxU5NeKwvI7LZWdihP2prBPmmHnIeZH14AEW3hy1NyUM67X5/JOWlxrQiLqTh6/39x
        VfR6jwu2CxhdNrpfg9YsDBcGW/Jv2vE=
Content-Language: en-US
In-Reply-To: <CAJD7tkbubDhpJV81qkXqRE5-yvvcjKrtPnZnECenafz+to=3_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>



On 27.6.2022 11.05, Yosry Ahmed wrote:
> On Mon, Jun 27, 2022 at 12:11 AM Muchun Song <songmuchun-EC8Uxl6Npydl57MI=
dRCFDg@public.gmane.org> wrote:
>>
>> On Sun, Jun 26, 2022 at 03:32:02AM -0700, Yosry Ahmed wrote:
>>> On Tue, Jun 21, 2022 at 5:57 AM Muchun Song <songmuchun-EC8Uxl6Npydl57M=
IdRCFDg@public.gmane.org> wrote:
>>>>
>>>> This version is rebased on mm-unstable. Hopefully, Andrew can get this=
 series
>>>> into mm-unstable which will help to determine whether there is a probl=
em or
>>>> degradation. I am also doing some benchmark tests in parallel.
>>>>
>>>> Since the following patchsets applied. All the kernel memory are charg=
ed
>>>> with the new APIs of obj_cgroup.
>>>>
>>>>          commit f2fe7b09a52b ("mm: memcg/slab: charge individual slab =
objects instead of pages")
>>>>          commit b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to =
charge kmem pages")
>>>>
>>>> But user memory allocations (LRU pages) pinning memcgs for a long time=
 -
>>>> it exists at a larger scale and is causing recurring problems in the r=
eal
>>>> world: page cache doesn't get reclaimed for a long time, or is used by=
 the
>>>> second, third, fourth, ... instance of the same job that was restarted=
 into
>>>> a new cgroup every time. Unreclaimable dying cgroups pile up, waste me=
mory,
>>>> and make page reclaim very inefficient.
>>>>
>>>> We can convert LRU pages and most other raw memcg pins to the objcg di=
rection
>>>> to fix this problem, and then the LRU pages will not pin the memcgs.
>>>>
>>>> This patchset aims to make the LRU pages to drop the reference to memo=
ry
>>>> cgroup by using the APIs of obj_cgroup. Finally, we can see that the n=
umber
>>>> of the dying cgroups will not increase if we run the following test sc=
ript.
>>>
>>> This is amazing work!
>>>
>>> Sorry if I came late, I didn't follow the threads of previous versions
>>> so this might be redundant, I just have a couple of questions.
>>>
>>> a) If LRU pages keep getting parented until they reach root_mem_cgroup
>>> (assuming they can), aren't these pages effectively unaccounted at
>>> this point or leaked? Is there protection against this?
>>>
>>
>> In this case, those pages are accounted in root memcg level. Unfortunate=
ly,
>> there is no mechanism now to transfer a page's memcg from one to another.
>>
>>> b) Since moving charged pages between memcgs is now becoming easier by
>>> using the APIs of obj_cgroup, I wonder if this opens the door for
>>> future work to transfer charges to memcgs that are actually using
>>> reparented resources. For example, let's say cgroup A reads a few
>>> pages into page cache, and then they are no longer used by cgroup A.
>>> cgroup B, however, is using the same pages that are currently charged
>>> to cgroup A, so it keeps taxing cgroup A for its use. When cgroup A
>>> dies, and these pages are reparented to A's parent, can we possibly
>>> mark these reparented pages (maybe in the page tables somewhere) so
>>> that next time they get accessed we recharge them to B instead
>>> (possibly asynchronously)?
>>> I don't have much experience about page tables but I am pretty sure
>>> they are loaded so maybe there is no room in PTEs for something like
>>> this, but I have always wondered about what we can do for this case
>>> where a cgroup is consistently using memory charged to another cgroup.
>>> Maybe when this memory is reparented is a good point in time to decide
>>> to recharge appropriately. It would also fix the reparenty leak to
>>> root problem (if it even exists).
>>>
>>
>>  From my point of view, this is going to be an improvement to the memcg
>> subsystem in the future.  IIUC, most reparented pages are page cache
>> pages without be mapped to users. So page tables are not a suitable
>> place to record this information. However, we already have this informat=
ion
>> in struct obj_cgroup and struct mem_cgroup. If a page's obj_cgroup is not
>> equal to the page's obj_cgroup->memcg->objcg, it means this page have
>> been reparented. I am thinking if a place where a page is mapped (probab=
ly
>> page fault patch) or page (cache) is written (usually vfs write path)
>> is suitable to transfer page's memcg from one to another. But need more
>=20
> Very good point about unmapped pages, I missed this. Page tables will
> do us no good here. Such a change would indeed require careful thought
> because (like you mentioned) there are multiple points in time where
> it might be suitable to consider recharging the page (e.g. when the
> page is mapped). This could be an incremental change though. Right now
> we have no recharging at all, so maybe we can gradually add recharging
> to suitable paths.
>=20
>> thinking, e.g. How to decide if a reparented page needs to be transferre=
d?
>=20
> Maybe if (page's obj_cgroup->memcg =3D=3D root_mem_cgroup) OR (memcg of
> current is not a descendant of page's obj_cgroup->memcg) is a good
> place to start?
>=20
> My rationale is that if the page is charged to root_mem_cgroup through
> reparenting and a process in a memcg is using it then this is probably
> an accounting leak. If a page is charged to a memcg A through
> reparenting and is used by a memcg B in a different subtree, then
> probably memcg B is getting away with using the page for free while A
> is being taxed. If B is a descendant of A, it is still getting away
> with using the page unaccounted, but at least it makes no difference
> for A.
>=20
> One could argue that we might as well recharge a reparented page
> anyway if the process is cheap (or done asynchronously), and the paths
> where we do recharging are not very common.
>=20
> All of this might be moot, I am just thinking out loud. In any way
> this would be future work and not part of this work.
>=20


I think you have to uncharge at the reparented parent to keep balances=20
right (because parent is hierarchically charged thru page_counter). And=20
maybe recharge after that if appropriate.




>=20
>> If we need more information to make this decision, where to store those
>> information? This is my primary thoughts on this question.
>=20
>>
>> Thanks.
>>
>>> Thanks again for this work and please excuse my ignorance if any part
>>> of what I said doesn't make sense :)
>>>
>>>>
>>>> ```bash
>>>> #!/bin/bash
>>>>
>>>> dd if=3D/dev/zero of=3Dtemp bs=3D4096 count=3D1
>>>> cat /proc/cgroups | grep memory
>>>>
>>>> for i in {0..2000}
>>>> do
>>>>          mkdir /sys/fs/cgroup/memory/test$i
>>>>          echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
>>>>          cat temp >> log
>>>>          echo $$ > /sys/fs/cgroup/memory/cgroup.procs
>>>>          rmdir /sys/fs/cgroup/memory/test$i
>>>> done
>>>>
>>>> cat /proc/cgroups | grep memory
>>>>
>>>> rm -f temp log
>>>> ```
>>>>
>>>> v5: https://lore.kernel.org/all/20220530074919.46352-1-songmuchun-EC8U=
xl6Npydl57MIdRCFDg@public.gmane.org/
>>>> v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuchun-EC8U=
xl6Npydl57MIdRCFDg@public.gmane.org/
>>>> v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuchun-EC8U=
xl6Npydl57MIdRCFDg@public.gmane.org/
>>>> v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuchun-EC8U=
xl6Npydl57MIdRCFDg@public.gmane.org/
>>>> v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuchun-EC8U=
xl6Npydl57MIdRCFDg@public.gmane.org/
>>>> RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-songmuchun-=
EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>>>> RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-songmuchun-=
EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>>>> RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-songmuchun-=
EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>>>> RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun-=
EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>>>>
>>>> v6:
>>>>   - Collect Acked-by and Reviewed-by from Roman and Michal Koutn=C3=BD=
. Thanks.
>>>>   - Rebase to mm-unstable.
>>>>
>>>> v5:
>>>>   - Lots of improvements from Johannes, Roman and Waiman.
>>>>   - Fix lockdep warning reported by kernel test robot.
>>>>   - Add two new patches to do code cleanup.
>>>>   - Collect Acked-by and Reviewed-by from Johannes and Roman.
>>>>   - I didn't replace local_irq_disable/enable() to local_lock/unlock_i=
rq() since
>>>>     local_lock/unlock_irq() takes an parameter, it needs more thinking=
 to transform
>>>>     it to local_lock.  It could be an improvement in the future.
>>>>
>>>> v4:
>>>>   - Resend and rebased on v5.18.
>>>>
>>>> v3:
>>>>   - Removed the Acked-by tags from Roman since this version is based on
>>>>     the folio relevant.
>>>>
>>>> v2:
>>>>   - Rename obj_cgroup_release_kmem() to obj_cgroup_release_bytes() and=
 the
>>>>     dependencies of CONFIG_MEMCG_KMEM (suggested by Roman, Thanks).
>>>>   - Rebase to linux 5.15-rc1.
>>>>   - Add a new pacth to cleanup mem_cgroup_kmem_disabled().
>>>>
>>>> v1:
>>>>   - Drop RFC tag.
>>>>   - Rebase to linux next-20210811.
>>>>
>>>> RFC v4:
>>>>   - Collect Acked-by from Roman.
>>>>   - Rebase to linux next-20210525.
>>>>   - Rename obj_cgroup_release_uncharge() to obj_cgroup_release_kmem().
>>>>   - Change the patch 1 title to "prepare objcg API for non-kmem usage".
>>>>   - Convert reparent_ops_head to an array in patch 8.
>>>>
>>>> Thanks for Roman's review and suggestions.
>>>>
>>>> RFC v3:
>>>>   - Drop the code cleanup and simplification patches. Gather those pat=
ches
>>>>     into a separate series[1].
>>>>   - Rework patch #1 suggested by Johannes.
>>>>
>>>> RFC v2:
>>>>   - Collect Acked-by tags by Johannes. Thanks.
>>>>   - Rework lruvec_holds_page_lru_lock() suggested by Johannes. Thanks.
>>>>   - Fix move_pages_to_lru().
>>>>
>>>> Muchun Song (11):
>>>>    mm: memcontrol: remove dead code and comments
>>>>    mm: rename unlock_page_lruvec{_irq, _irqrestore} to
>>>>      lruvec_unlock{_irq, _irqrestore}
>>>>    mm: memcontrol: prepare objcg API for non-kmem usage
>>>>    mm: memcontrol: make lruvec lock safe when LRU pages are reparented
>>>>    mm: vmscan: rework move_pages_to_lru()
>>>>    mm: thp: make split queue lock safe when LRU pages are reparented
>>>>    mm: memcontrol: make all the callers of {folio,page}_memcg() safe
>>>>    mm: memcontrol: introduce memcg_reparent_ops
>>>>    mm: memcontrol: use obj_cgroup APIs to charge the LRU pages
>>>>    mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance function
>>>>    mm: lru: use lruvec lock to serialize memcg changes
>>>>
>>>>   fs/buffer.c                      |   4 +-
>>>>   fs/fs-writeback.c                |  23 +-
>>>>   include/linux/memcontrol.h       | 218 +++++++++------
>>>>   include/linux/mm_inline.h        |   6 +
>>>>   include/trace/events/writeback.h |   5 +
>>>>   mm/compaction.c                  |  39 ++-
>>>>   mm/huge_memory.c                 | 153 ++++++++--
>>>>   mm/memcontrol.c                  | 584 +++++++++++++++++++++++++++--=
----------
>>>>   mm/migrate.c                     |   4 +
>>>>   mm/mlock.c                       |   2 +-
>>>>   mm/page_io.c                     |   5 +-
>>>>   mm/swap.c                        |  49 ++--
>>>>   mm/vmscan.c                      |  66 ++---
>>>>   13 files changed, 776 insertions(+), 382 deletions(-)
>>>>
>>>>
>>>> base-commit: 882be1ed6b1b5073fc88552181b99bd2b9c0031f
>>>> --
>>>> 2.11.0
>>>>
>>>>
>>>
>=20

