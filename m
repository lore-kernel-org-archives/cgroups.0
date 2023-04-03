From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH mm-unstable RFC 2/5] memcg: flush stats non-atomically in mem_cgroup_wb_stats()
Date: Mon,  3 Apr 2023 22:03:34 +0000
Message-ID: <20230403220337.443510-3-yosryahmed@google.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680559423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Hf88QAEgRalaH3f7thcio7vExcVqqDxAYa/aCaE9Jc=;
        b=Qd1B7SbDQyGizezUFQyV/0tO/bOhj44AtZ1VKHtgOG9TbJavAnnMGZmO6zQIpqIoK7
         5cj24hiW5m5RcceJDQ1KEplDfhRxIe4M8gmfj3L+NZAuLHvyis3MtYjzW6MZhBerb1QT
         JbsSvLpI6syO5GW80nsYNqGOYj2kCCLCJxDrHY++EHRBCuORnOG3ZRIIIY9qF02f9mrK
         7QKQBjFz8zSpKFSQE5ME0/wr0Ah4Zv+Tdpoq6l9nLH2lZJPiIROIUeme5UI6HVL7rK6b
         PMhT9C0HP1QYba587rjt9xa6OsG8uX3e11ytS9ZKFnspyAhVnb6ce2SHS6u9IWMy0H74
         szug==
In-Reply-To: <20230403220337.443510-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>

The previous patch moved the wb_over_bg_thresh()->mem_cgroup_wb_stats()
code path in wb_writeback() outside the lock section. We no longer need
to flush the stats atomically. Flush the stats non-atomically.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d040a5fa7a35..bdd52fe9e7e4b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4637,11 +4637,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	/*
-	 * wb_writeback() takes a spinlock and calls
-	 * wb_over_bg_thresh()->mem_cgroup_wb_stats(). Do not sleep.
-	 */
-	mem_cgroup_flush_stats_atomic();
+	mem_cgroup_flush_stats();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
-- 
2.40.0.348.gf938b09366-goog

