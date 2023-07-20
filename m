From: Efly Young <yangyifei03@kuaishou.com>
Subject: [PATCH] mm:vmscan: fix inaccurate reclaim during proactive reclaim
Date: Thu, 20 Jul 2023 15:27:08 +0800
Message-ID: <20230720072708.55067-1-yangyifei03@kuaishou.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; d=kuaishou.com; s=dkim; c=relaxed/relaxed;
        t=1689838068; h=from:subject:to:date:message-id;
        bh=2hvt2nAb9FQGc8JWV2zRVOy7HcAR3TW4z5ZsrMla/mw=;
        b=Ov9ON0jOMvPY7tYxtSF27RXIYX5/ESwleAfyzbMcRkfahhvPD8+vCRgUolm4nuFAX7xrxXLLqLP
        VC0ugqxGe1jauqIjydi7S9YH2M2vjCjTteErwqG546qEglqgQx2dxnNycFZVOCvZX9fbPRgt69Um7
        2ew2dB1E6Kom/DkdCz0=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

Before commit f53af4285d77 ("mm: vmscan: fix extreme overreclaim and
swap floods"), proactive reclaim will extreme overreclaim sometimes.
But proactive reclaim still inaccurate and some extent overreclaim.

Problematic case is easy to construct. Allocate lots of anonymous
memory (e.g., 20G) in a memcg, then swapping by writing memory.recalim
and there is a certain probability of overreclaim. For example, request
1G by writing memory.reclaim will eventually reclaim 1.7G or other
values more than 1G.

The reason is that reclaimer may have already reclaimed part of requested
memory in one loop, but before adjust sc->nr_to_reclaim in outer loop,
call shrink_lruvec() again will still follow the current sc->nr_to_reclaim
to work. It will eventually lead to overreclaim. In theory, the amount
of reclaimed would be in [request, 2 * request).

Reclaimer usually tends to reclaim more than request. But either direct
or kswapd reclaim have much smaller nr_to_reclaim targets, so it is
less noticeable and not have much impact.

Proactive reclaim can usually come in with a larger value, so the error
is difficult to ignore. Considering proactive reclaim is usually low
frequency, handle the batching into smaller chunks is a better approach.

Signed-off-by: Efly Young <yangyifei03@kuaishou.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e24..d36cf88 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6741,8 +6741,8 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, reclaim_options);
+					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
+					GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
-- 
1.8.3.1

