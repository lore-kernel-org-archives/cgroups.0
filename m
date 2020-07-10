From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v14 07/20] mm/thp: narrow lru locking
Date: Fri, 10 Jul 2020 16:23:35 +0800
Message-ID: <e87f7dd1-41c4-3392-f1df-982dd28c0617@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-8-git-send-email-alex.shi@linux.alibaba.com>
 <124eeef1-ff2b-609e-3bf6-a118100c3f2a@linux.alibaba.com>
 <20200706113513.GY25523@casper.infradead.org>
 <alpine.LSU.2.11.2007062059420.2793@eggly.anvils>
 <20200709154816.wieg5thfejyv2h2l@box>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200709154816.wieg5thfejyv2h2l@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/7/9 =CF=C2=CE=E711:48, Kirill A. Shutemov =D0=B4=B5=C0:
> On Mon, Jul 06, 2020 at 09:52:34PM -0700, Hugh Dickins wrote:
>> On Mon, 6 Jul 2020, Matthew Wilcox wrote:
>>> On Mon, Jul 06, 2020 at 05:15:09PM +0800, Alex Shi wrote:
>>>> Hi Kirill & Johannes & Matthew,
>>
>> Adding Kirill, who was in patch's Cc list but not mail's Cc list.
>>
>> I asked Alex to direct this one particularly to Kirill and Johannes
>> and Matthew because (and I regret that the commit message still does
>> not make this at all clear) this patch changes the lock ordering:
>> which for years has been lru_lock outside memcg move_lock outside
>> i_pages lock, but here inverted to lru_lock inside i_pages lock.
>>
>> I don't see a strong reason to have them one way round or the other,
>> and think Alex is right that they can safely be reversed here: but
>> he doesn't actually give any reason for doing so (if cleanup, then
>> I think the cleanup should have been taken further), and no reason
>> for doing so as part of this series.
>=20
> I've looked around and changing order of lru_lock wrt. i_pages lock seems
> safe. I don't have much experience with memcg move_lock.

Hi Kirill,

Thanks for response!
mem_cgroup_move_account(page) could not reach here since 2 blocks,
1, isolate_lru_page() before it will take page from lru, this compete for
   page reclaim path, list non-null.

2, try_lock_page in it, will guard split_huge_page(), !list.

>=20
> Alex, if you are going ahead with the patch, please document the locking
> order. We have some locking orders listed at the beginning of filemap.c
> and rmap.c.

Thanks for reminder!
Hugh Dickins did this in above 2 files at the end of patchset, any comments?

diff --git a/mm/filemap.c b/mm/filemap.c
index f0ae9a6308cb..1b42aaae4d3e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -101,8 +101,8 @@
  *    ->swap_lock		(try_to_unmap_one)
  *    ->private_lock		(try_to_unmap_one)
  *    ->i_pages lock		(try_to_unmap_one)
- *    ->pgdat->lru_lock		(follow_page->mark_page_accessed)
- *    ->pgdat->lru_lock		(check_pte_range->isolate_lru_page)
+ *    ->lruvec->lru_lock	(follow_page->mark_page_accessed)
+ *    ->lruvec->lru_lock	(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->i_pages lock		(page_remove_rmap->set_page_dirty)
  *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d5e56be42f21..926d7d95dc1d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3057,7 +3057,7 @@ void __memcg_kmem_uncharge_page(struct page *page, in=
t order)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
=20
 /*
- * Because tail pages are not marked as "used", set it. We're under
+ * Because tail pages are not marked as "used", set it. Don't need
  * lruvec->lru_lock and migration entries setup in all page mappings.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
diff --git a/mm/rmap.c b/mm/rmap.c
index 5fe2dedce1fc..7fbc382e6f9e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -28,12 +28,12 @@
  *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *           anon_vma->rwsem
  *             mm->page_table_lock or pte_lock
- *               pgdat->lru_lock (in mark_page_accessed, isolate_lru_page)
  *               swap_lock (in swap_duplicate, swap_info_get)
  *                 mmlist_lock (in mmput, drain_mmlist and others)
  *                 mapping->private_lock (in __set_page_dirty_buffers)
- *                   mem_cgroup_{begin,end}_page_stat (memcg->move_lock)
+ *                   lock_page_memcg move_lock (in __set_page_dirty_buffer=
s)
  *                     i_pages lock (widely used)
+ *                       lock_page_lruvec_irq lruvec->lru_lock
  *                 inode->i_lock (in set_page_dirty's __mark_inode_dirty)
  *                 bdi.wb->list_lock (in set_page_dirty's __mark_inode_dir=
ty)
  *                   sb_lock (within inode_lock in fs/fs-writeback.c)

>=20
> local_irq_disable() also deserves a comment.
>=20

yes, I will add a comment for this. Do you mind give reviewed-by for this p=
atch?

Thanks
Alex
