From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v3] mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()
Date: Wed, 30 Sep 2020 05:53:36 -0400
Message-ID: <20200930095336.21323-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field. So
we reword the comment as this would be helpful.
[Thanks Michal Hocko for rewording this comment.]

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6877c765b8d0..4f0c14cb8690 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1817,8 +1817,8 @@ static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
 	struct mem_cgroup *iter;
 
 	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
+	 * Be careful about under_oom underflows becase a child memcg
+	 * could have been added after mem_cgroup_mark_under_oom.
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-- 
2.19.1

