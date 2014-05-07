From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] memcg: correct comments for __mem_cgroup_begin_update_page_stat
Date: Wed, 7 May 2014 16:27:13 +0800
Message-ID: <5369EE61.1040003@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5804d71..f96e68e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2251,12 +2251,11 @@ cleanup:
 }

 /*
- * Currently used to update mapped file statistics, but the routine can be
- * generalized to update other statistics as well.
+ * Used to update mapped file or writeback or other statistics.
  *
  * Notes: Race condition
  *
- * We usually use page_cgroup_lock() for accessing page_cgroup member but
+ * We usually use lock_page_cgroup() for accessing page_cgroup member but
  * it tends to be costly. But considering some conditions, we doesn't need
  * to do so _always_.
  *
@@ -2270,8 +2269,8 @@ cleanup:
  * by flags.
  *
  * Considering "move", this is an only case we see a race. To make the race
- * small, we check mm->moving_account and detect there are possibility of race
- * If there is, we take a lock.
+ * small, we check memcg->moving_account and detect there are possibility
+ * of race or not. If there is, we take a lock.
  */

 void __mem_cgroup_begin_update_page_stat(struct page *page,
-- 
1.8.3
