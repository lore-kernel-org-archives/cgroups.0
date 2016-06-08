From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: fix documentation for compound parameter
Date: Wed,  8 Jun 2016 14:43:36 +0800
Message-ID: <1465368216-9393-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

commit f627c2f53786 ("memcg: adjust to support new THP refcounting")
adds a compound parameter for several functions, and change one as
compound for mem_cgroup_move_account but it does not change the
comments.

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bc79b38..4d9a215 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4387,7 +4387,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
- * @nr_pages: number of regular pages (>1 for huge pages)
+ * @compound: charge the page as compound or small page
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  *
@@ -5249,6 +5249,7 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
  * @memcgp: charged memcg return
+ * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
@@ -5311,6 +5312,7 @@ out:
  * @page: page to charge
  * @memcg: memcg to charge the page to
  * @lrucare: page might be on LRU already
+ * @compound: charge the page as compound or small page
  *
  * Finalize a charge transaction started by mem_cgroup_try_charge(),
  * after page->mapping has been set up.  This must happen atomically
@@ -5362,6 +5364,7 @@ void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
  * mem_cgroup_cancel_charge - cancel a page charge
  * @page: page to charge
  * @memcg: memcg to charge the page to
+ * @compound: charge the page as compound or small page
  *
  * Cancel a charge transaction started by mem_cgroup_try_charge().
  */
-- 
2.1.4
