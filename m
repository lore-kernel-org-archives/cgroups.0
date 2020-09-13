From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: memcontrol: Correct the comment of mem_cgroup_iter()
Date: Sun, 13 Sep 2020 05:41:29 -0400
Message-ID: <20200913094129.44558-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), the arg @reclaim has no priority field anymore.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..a57aa0f42d40 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1138,9 +1138,9 @@ static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
  * invocations for reference counting, or use mem_cgroup_iter_break()
  * to cancel a hierarchy walk before the round-trip is complete.
  *
- * Reclaimers can specify a node and a priority level in @reclaim to
- * divide up the memcgs in the hierarchy among all concurrent
- * reclaimers operating on the same node and priority.
+ * Reclaimers can specify a node in @reclaim to divide up the memcgs
+ * in the hierarchy among all concurrent reclaimers operating on the
+ * same node.
  */
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
-- 
2.19.1

