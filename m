From: Chris Down <chris@chrisdown.name>
Subject: [PATCH 5/6] mm, memcg: Prevent memory.swap.max load tearing
Date: Thu, 12 Mar 2020 17:33:11 +0000
Message-ID: <bbec2c3d822217334855c8877a9d28b2a6d395fb.1584034301.git.chris@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=urzcg1/zbcSllHCQ82ap2K/ib0OV1jVM8zTOxSBSSFk=;
        b=L2f+CaL9yyAPG75AYGECf5KTcw7S8M4rdsMmRBSZMeGR8jRzPXKEG698E3haidM1SB
         EphvHD/U1lU3Tsfx19T+saKeeS1FVjHvlGAnaixK8Xiuvpf85YAi1FH8cmHHyStdVQ6x
         s3ChNGG7YtV2ejMML1Tln752ExwS8WXNN1Xzw=
Content-Disposition: inline
In-Reply-To: <cover.1584034301.git.chris@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The write side of this is xchg()/smp_mb(), so that's all good. Just a
few sites missing a READ_ONCE.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@fb.com
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e0ed790a2a8c..57048a38c75d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1511,7 +1511,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->swap)),
-			K((u64)memcg->swap.max), memcg->swap.failcnt);
+			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
 	else {
 		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
 			K((u64)page_counter_read(&memcg->memsw)),
@@ -1544,7 +1544,7 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 		unsigned long swap_max;
 
 		memsw_max = memcg->memsw.max;
-		swap_max = memcg->swap.max;
+		swap_max = READ_ONCE(memcg->swap.max);
 		swap_max = min(swap_max, (unsigned long)total_swap_pages);
 		max = min(max + swap_max, memsw_max);
 	}
@@ -7025,7 +7025,8 @@ bool mem_cgroup_swap_full(struct page *page)
 		return false;
 
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
-		if (page_counter_read(&memcg->swap) * 2 >= memcg->swap.max)
+		if (page_counter_read(&memcg->swap) * 2 >=
+		    READ_ONCE(memcg->swap.max))
 			return true;
 
 	return false;
-- 
2.25.1

