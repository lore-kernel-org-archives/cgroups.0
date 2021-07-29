From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 3/5] mm, memcg: save some atomic ops when flush is already true
Date: Thu, 29 Jul 2021 20:57:53 +0800
Message-ID: <20210729125755.16871-4-linmiaohe@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20210729125755.16871-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: shakeelb@google.com, guro@fb.com, willy@infradead.org, alexs@kernel.org, richard.weiyang@gmail.com, songmuchun@bytedance.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linmiaohe@huawei.com

Add 'else' to save some atomic ops in obj_stock_flush_required() when
flush is already true. No functional change intended here.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a03e24e57cd9..5b4592d1e0f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2231,7 +2231,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 		if (memcg && stock->nr_pages &&
 		    mem_cgroup_is_descendant(memcg, root_memcg))
 			flush = true;
-		if (obj_stock_flush_required(stock, root_memcg))
+		else if (obj_stock_flush_required(stock, root_memcg))
 			flush = true;
 		rcu_read_unlock();
 
-- 
2.23.0

