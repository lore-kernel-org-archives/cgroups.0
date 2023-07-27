From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] mm/memcg: fix obsolete function name in mem_cgroup_protection()
Date: Thu, 27 Jul 2023 19:59:34 +0800
Message-ID: <20230727115934.657787-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Commit 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from
protection checks") changed the function name but not the corresponding
comment.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e765d1ff9cbb..3bd00f224224 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -585,7 +585,7 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 	/*
 	 * There is no reclaim protection applied to a targeted reclaim.
 	 * We are special casing this specific case here because
-	 * mem_cgroup_protected calculation is not robust enough to keep
+	 * mem_cgroup_calculate_protection is not robust enough to keep
 	 * the protection invariant for calculated effective values for
 	 * parallel reclaimers with different reclaim target. This is
 	 * especially a problem for tail memcgs (as they have pages on LRU)
-- 
2.33.0

