From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v6 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Sat, 9 Jul 2022 13:51:26 +0800
Message-ID: <YskXXlUAB1YZikkG@FVFYT0MHHV2J.usts.net>
References: <20220621125658.64935-1-songmuchun@bytedance.com>
 <CAJD7tkbeTtkMcVri9vzKHATjxAVZfC_vPNfApJiyRxY53c8pZQ@mail.gmail.com>
 <YrlYG0ecJyzFTVVz@FVFYT0MHHV2J.usts.net>
 <CAJD7tkbk-E+Skkj3xxELuGFHet940DovKi0z8NxPqePzXa-Wug@mail.gmail.com>
 <YsfUIpM5NlWZhUDT@FVFYT0MHHV2J.usts.net>
 <CAJD7tkazvC+kZgGaV3idapQp-zPFaWBxoHwnrqTFoodHZGQcPA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/6SKLEcLJ7T5Zb1OtQ+vJfwJtwEdNhr8M/GFRdSGfIk=;
        b=Jq2o5wdLilSV8tye5H/Xr1REHGGRIV9a/0dwGOxNz6QjZ1asjZwNFMGdjVwbxax62K
         A0Th+8YCkNwU02WVnTtYDIi6bbD9hYueO8x9MCPFId0mK8Q29zh+1P52AZ44z8ygxqEI
         sDCJhtNItQUJXH9VMABoVZwp6CCNeQ51JNSUOxSwp0LG25gYKh3f3m1k512ZE0kZVMjO
         RVg/aXIxQ5n8uQH4flqzttz4U+1pSp9v1Zz6jWddEimFVfcpfKAzZxOc5RimLNP+yiZm
         qd96rjGe+FR2gY01nWgL4cOsKBe/cUsh/EnBe+RnnLhDYa89i0cg/2zLkYw9S9hXFNyN
         XZ5w==
Content-Disposition: inline
In-Reply-To: <CAJD7tkazvC+kZgGaV3idapQp-zPFaWBxoHwnrqTFoodHZGQcPA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, longman@redhat.com, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>, duanxiongchun@bytedance.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>

On Fri, Jul 08, 2022 at 02:26:08AM -0700, Yosry Ahmed wrote:
> On Thu, Jul 7, 2022 at 11:52 PM Muchun Song <songmuchun@bytedance.com> wr=
ote:
> >
> > On Thu, Jul 07, 2022 at 03:14:26PM -0700, Yosry Ahmed wrote:
> > > On Mon, Jun 27, 2022 at 12:11 AM Muchun Song <songmuchun@bytedance.co=
m> wrote:
> > > >
> > > > On Sun, Jun 26, 2022 at 03:32:02AM -0700, Yosry Ahmed wrote:
> > > > > On Tue, Jun 21, 2022 at 5:57 AM Muchun Song <songmuchun@bytedance=
.com> wrote:
> > > > > >
> > > > > > This version is rebased on mm-unstable. Hopefully, Andrew can g=
et this series
> > > > > > into mm-unstable which will help to determine whether there is =
a problem or
> > > > > > degradation. I am also doing some benchmark tests in parallel.
> > > > > >
> > > > > > Since the following patchsets applied. All the kernel memory ar=
e charged
> > > > > > with the new APIs of obj_cgroup.
> > > > > >
> > > > > >         commit f2fe7b09a52b ("mm: memcg/slab: charge individual=
 slab objects instead of pages")
> > > > > >         commit b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup AP=
Is to charge kmem pages")
> > > > > >
> > > > > > But user memory allocations (LRU pages) pinning memcgs for a lo=
ng time -
> > > > > > it exists at a larger scale and is causing recurring problems i=
n the real
> > > > > > world: page cache doesn't get reclaimed for a long time, or is =
used by the
> > > > > > second, third, fourth, ... instance of the same job that was re=
started into
> > > > > > a new cgroup every time. Unreclaimable dying cgroups pile up, w=
aste memory,
> > > > > > and make page reclaim very inefficient.
> > > > > >
> > > > > > We can convert LRU pages and most other raw memcg pins to the o=
bjcg direction
> > > > > > to fix this problem, and then the LRU pages will not pin the me=
mcgs.
> > > > > >
> > > > > > This patchset aims to make the LRU pages to drop the reference =
to memory
> > > > > > cgroup by using the APIs of obj_cgroup. Finally, we can see tha=
t the number
> > > > > > of the dying cgroups will not increase if we run the following =
test script.
> > > > >
> > > > > This is amazing work!
> > > > >
> > > > > Sorry if I came late, I didn't follow the threads of previous ver=
sions
> > > > > so this might be redundant, I just have a couple of questions.
> > > > >
> > > > > a) If LRU pages keep getting parented until they reach root_mem_c=
group
> > > > > (assuming they can), aren't these pages effectively unaccounted at
> > > > > this point or leaked? Is there protection against this?
> > > > >
> > > >
> > > > In this case, those pages are accounted in root memcg level. Unfort=
unately,
> > > > there is no mechanism now to transfer a page's memcg from one to an=
other.
> > > >
> > >
> > > Hey Muchun,
> > >
> > > Quick question regarding the behavior of this change on cgroup v1 (I
> > > know .. I know .. sorry):
> > >
> > > When a memcg dies, its LRU pages are reparented, but what happens to
> > > the charge? IIUC we don't do anything because the pages are already
> > > hierarchically charged to the parent. Is this correct?
> > >
> >
> > Correct.
> >
> > > In cgroup v1, we have non-hierarchical stats as well, so I am trying
> > > to understand if the reparented memory will appear in the
> > > non-hierarchical stats of the parent (my understanding is that the
> > > will not). I am also particularly interested in the charging behavior
> > > of pages that get reparented to root_mem_cgroup.
> > >
> >
> > I didn't change any memory stats when reparenting.
> >
> > > The main reason I am asking is that (hierarchical_usage -
> > > non-hierarchical_usage - children_hierarchical_usage) is *roughly*
> > > something that we use, especially at the root level, to estimate
> > > zombie memory usage. I am trying to see if this change will break such
> > > calculations. Thanks!
> > >
> >
> > So I think your calculations will still be correct. If you have
> > any unexpected result, please let me know. Thanks.
>=20
> I have been looking at the code and the patchset and I think there
> might be a problem with the stats, at least for cgroup v1. Lets say we
> have a parent memcg P, which has a child memcg C. When processes in
> memcg C allocate memory the stats (e.g. NR_ANON_MAPPED) are updated
> for C (non-hierarchical per-cpu counters, memcg->vmstats_percpu), and
> for P (aggregated stats, memcg->vmstats).
>=20
> When memcg C is offlined, its pages are reparented to memcg P, so far
> P->vmstats (hierarchical) still have those pages, and
> P->vmstats_percpu (non-hierarchical) don't. So far so good.
>=20
> Now those reparented pages get uncharged, but their memcg is P now, so
> they get subtracted from P's *non-hierarchical* stats (and eventually
> hierarchical stats as well). So now P->vmstats (hierarchical)
> decreases, which is correct, but P->vmstats_percpu (non-hierarchical)
> also decreases, which is wrong, as those stats were never added to
> P->vmstats_percpu to begin with.
>=20
> From a cgroup v2 perspective *maybe* everything continues to work, but
> this breaks cgroup v1 non-hierarchical stats. In fact, if the
> reparented memory exceeds the original non-hierarchical memory in P,
> we can underflow those stats  because we are subtracting stats that
> were never added in the first place.
>=20
> Please let me know if I am misunderstanding something and there is
> actually no problem with the non-hierarchical stats (you can stop
> reading here if this is all in my head and there's actually no
> problem).
>

Thanks for patient explanation. Now I got your point.
=20
> Off the top of my mind we can handle stats modifications of reparented
> memory separately. We should not updated local per-cpu counters, maybe
> we should rather update memcg->vmstat.state_pending directly so that
> the changes appear as if they come from a child memcg. Two problems
> come with such an approach:
>

Instead of avoiding updating local per-cpu counters for reparented pages,
after reparenting, how about propagating the child memcg's local per-cpu
counters to its parent after LRU pages reparenting? And we do not need to
propagate all vmstats, just some vmstats exposed to cgroup v1 users (like
memcg1_stats, memcg1_events and lru list pages). I think a reparented page
is just a little bit of difference compared to other non-reparented pages,
propagating local per-cpu counters may be acceptable. What do you think?

> 1) memcg->vmstat.state_pending is shared between cpus, and so far is
> only modified by mem_cgroup_css_rstat_flush() in locked context. A
> solution would be to add reparented state to
> memcg->vmstat.state_percpu instead and treat it like
> memcg->vmstat.state_pending in mem_cgroup_css_rstat_flush(). Keep in
> mind that this adds a tiny bit of memory overhead (roughly 8
> bytes*num_cpus for each memcg).
>=20
> 2) Identifying that we are updating stats of reparented memory. This
> should be easy if we have a pointer to the page to compare page->objcg
> with page->objcg->memcg->objcg, but AFAICT the memcg stats are updated
> in __mod_memcg_state() and __mod_memcg_lruvec_state(), and we have no
> idea in each of these what page(s) is the stats update associated
> with. They are called from many different places, it would be
> troublesome to pass such information down from all call sites. I have
> nothing off the top of my head to fix this problem except passing the
> necessary info through all code paths to __mod_memcg_state() and
> __mod_memcg_lruvec_state(), which is far from ideal.
>=20
> Again, I am sorry if these discussions are late, I didn't have time to
> look at previous versions of this patchset.
>

Not late, thanks for your feedback.

> >
> > > > > b) Since moving charged pages between memcgs is now becoming easi=
er by
> > > > > using the APIs of obj_cgroup, I wonder if this opens the door for
> > > > > future work to transfer charges to memcgs that are actually using
> > > > > reparented resources. For example, let's say cgroup A reads a few
> > > > > pages into page cache, and then they are no longer used by cgroup=
 A.
> > > > > cgroup B, however, is using the same pages that are currently cha=
rged
> > > > > to cgroup A, so it keeps taxing cgroup A for its use. When cgroup=
 A
> > > > > dies, and these pages are reparented to A's parent, can we possib=
ly
> > > > > mark these reparented pages (maybe in the page tables somewhere) =
so
> > > > > that next time they get accessed we recharge them to B instead
> > > > > (possibly asynchronously)?
> > > > > I don't have much experience about page tables but I am pretty su=
re
> > > > > they are loaded so maybe there is no room in PTEs for something l=
ike
> > > > > this, but I have always wondered about what we can do for this ca=
se
> > > > > where a cgroup is consistently using memory charged to another cg=
roup.
> > > > > Maybe when this memory is reparented is a good point in time to d=
ecide
> > > > > to recharge appropriately. It would also fix the reparenty leak to
> > > > > root problem (if it even exists).
> > > > >
> > > >
> > > > From my point of view, this is going to be an improvement to the me=
mcg
> > > > subsystem in the future.  IIUC, most reparented pages are page cache
> > > > pages without be mapped to users. So page tables are not a suitable
> > > > place to record this information. However, we already have this inf=
ormation
> > > > in struct obj_cgroup and struct mem_cgroup. If a page's obj_cgroup =
is not
> > > > equal to the page's obj_cgroup->memcg->objcg, it means this page ha=
ve
> > > > been reparented. I am thinking if a place where a page is mapped (p=
robably
> > > > page fault patch) or page (cache) is written (usually vfs write pat=
h)
> > > > is suitable to transfer page's memcg from one to another. But need =
more
> > > > thinking, e.g. How to decide if a reparented page needs to be trans=
ferred?
> > > > If we need more information to make this decision, where to store t=
hose
> > > > information? This is my primary thoughts on this question.
> > > >
> > > > Thanks.
> > > >
> > > > > Thanks again for this work and please excuse my ignorance if any =
part
> > > > > of what I said doesn't make sense :)
> > > > >
> > > > > >
> > > > > > ```bash
> > > > > > #!/bin/bash
> > > > > >
> > > > > > dd if=3D/dev/zero of=3Dtemp bs=3D4096 count=3D1
> > > > > > cat /proc/cgroups | grep memory
> > > > > >
> > > > > > for i in {0..2000}
> > > > > > do
> > > > > >         mkdir /sys/fs/cgroup/memory/test$i
> > > > > >         echo $$ > /sys/fs/cgroup/memory/test$i/cgroup.procs
> > > > > >         cat temp >> log
> > > > > >         echo $$ > /sys/fs/cgroup/memory/cgroup.procs
> > > > > >         rmdir /sys/fs/cgroup/memory/test$i
> > > > > > done
> > > > > >
> > > > > > cat /proc/cgroups | grep memory
> > > > > >
> > > > > > rm -f temp log
> > > > > > ```
> > > > > >
> > > > > > v5: https://lore.kernel.org/all/20220530074919.46352-1-songmuch=
un@bytedance.com/
> > > > > > v4: https://lore.kernel.org/all/20220524060551.80037-1-songmuch=
un@bytedance.com/
> > > > > > v3: https://lore.kernel.org/all/20220216115132.52602-1-songmuch=
un@bytedance.com/
> > > > > > v2: https://lore.kernel.org/all/20210916134748.67712-1-songmuch=
un@bytedance.com/
> > > > > > v1: https://lore.kernel.org/all/20210814052519.86679-1-songmuch=
un@bytedance.com/
> > > > > > RFC v4: https://lore.kernel.org/all/20210527093336.14895-1-song=
muchun@bytedance.com/
> > > > > > RFC v3: https://lore.kernel.org/all/20210421070059.69361-1-song=
muchun@bytedance.com/
> > > > > > RFC v2: https://lore.kernel.org/all/20210409122959.82264-1-song=
muchun@bytedance.com/
> > > > > > RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-song=
muchun@bytedance.com/
> > > > > >
> > > > > > v6:
> > > > > >  - Collect Acked-by and Reviewed-by from Roman and Michal Koutn=
=FD. Thanks.
> > > > > >  - Rebase to mm-unstable.
> > > > > >
> > > > > > v5:
> > > > > >  - Lots of improvements from Johannes, Roman and Waiman.
> > > > > >  - Fix lockdep warning reported by kernel test robot.
> > > > > >  - Add two new patches to do code cleanup.
> > > > > >  - Collect Acked-by and Reviewed-by from Johannes and Roman.
> > > > > >  - I didn't replace local_irq_disable/enable() to local_lock/un=
lock_irq() since
> > > > > >    local_lock/unlock_irq() takes an parameter, it needs more th=
inking to transform
> > > > > >    it to local_lock.  It could be an improvement in the future.
> > > > > >
> > > > > > v4:
> > > > > >  - Resend and rebased on v5.18.
> > > > > >
> > > > > > v3:
> > > > > >  - Removed the Acked-by tags from Roman since this version is b=
ased on
> > > > > >    the folio relevant.
> > > > > >
> > > > > > v2:
> > > > > >  - Rename obj_cgroup_release_kmem() to obj_cgroup_release_bytes=
() and the
> > > > > >    dependencies of CONFIG_MEMCG_KMEM (suggested by Roman, Thank=
s).
> > > > > >  - Rebase to linux 5.15-rc1.
> > > > > >  - Add a new pacth to cleanup mem_cgroup_kmem_disabled().
> > > > > >
> > > > > > v1:
> > > > > >  - Drop RFC tag.
> > > > > >  - Rebase to linux next-20210811.
> > > > > >
> > > > > > RFC v4:
> > > > > >  - Collect Acked-by from Roman.
> > > > > >  - Rebase to linux next-20210525.
> > > > > >  - Rename obj_cgroup_release_uncharge() to obj_cgroup_release_k=
mem().
> > > > > >  - Change the patch 1 title to "prepare objcg API for non-kmem =
usage".
> > > > > >  - Convert reparent_ops_head to an array in patch 8.
> > > > > >
> > > > > > Thanks for Roman's review and suggestions.
> > > > > >
> > > > > > RFC v3:
> > > > > >  - Drop the code cleanup and simplification patches. Gather tho=
se patches
> > > > > >    into a separate series[1].
> > > > > >  - Rework patch #1 suggested by Johannes.
> > > > > >
> > > > > > RFC v2:
> > > > > >  - Collect Acked-by tags by Johannes. Thanks.
> > > > > >  - Rework lruvec_holds_page_lru_lock() suggested by Johannes. T=
hanks.
> > > > > >  - Fix move_pages_to_lru().
> > > > > >
> > > > > > Muchun Song (11):
> > > > > >   mm: memcontrol: remove dead code and comments
> > > > > >   mm: rename unlock_page_lruvec{_irq, _irqrestore} to
> > > > > >     lruvec_unlock{_irq, _irqrestore}
> > > > > >   mm: memcontrol: prepare objcg API for non-kmem usage
> > > > > >   mm: memcontrol: make lruvec lock safe when LRU pages are repa=
rented
> > > > > >   mm: vmscan: rework move_pages_to_lru()
> > > > > >   mm: thp: make split queue lock safe when LRU pages are repare=
nted
> > > > > >   mm: memcontrol: make all the callers of {folio,page}_memcg() =
safe
> > > > > >   mm: memcontrol: introduce memcg_reparent_ops
> > > > > >   mm: memcontrol: use obj_cgroup APIs to charge the LRU pages
> > > > > >   mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance function
> > > > > >   mm: lru: use lruvec lock to serialize memcg changes
> > > > > >
> > > > > >  fs/buffer.c                      |   4 +-
> > > > > >  fs/fs-writeback.c                |  23 +-
> > > > > >  include/linux/memcontrol.h       | 218 +++++++++------
> > > > > >  include/linux/mm_inline.h        |   6 +
> > > > > >  include/trace/events/writeback.h |   5 +
> > > > > >  mm/compaction.c                  |  39 ++-
> > > > > >  mm/huge_memory.c                 | 153 ++++++++--
> > > > > >  mm/memcontrol.c                  | 584 +++++++++++++++++++++++=
++++------------
> > > > > >  mm/migrate.c                     |   4 +
> > > > > >  mm/mlock.c                       |   2 +-
> > > > > >  mm/page_io.c                     |   5 +-
> > > > > >  mm/swap.c                        |  49 ++--
> > > > > >  mm/vmscan.c                      |  66 ++---
> > > > > >  13 files changed, 776 insertions(+), 382 deletions(-)
> > > > > >
> > > > > >
> > > > > > base-commit: 882be1ed6b1b5073fc88552181b99bd2b9c0031f
> > > > > > --
> > > > > > 2.11.0
> > > > > >
> > > > > >
> > > > >
> > >
>=20
