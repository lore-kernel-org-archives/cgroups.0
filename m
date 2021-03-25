From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 13/14] bfq: remove unnecessary initialization logic
Date: Thu, 25 Mar 2021 14:57:57 +0800
Message-ID: <e26a3b14976a833e1350799f84f49c10a50e3705.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Qko9xgJWdOHvuiNbVOg4Moyiw5zlG2MS/A0wr9gMovI=;
        b=gPAx01xm/r3iBawJ1NuBPdBcHS3OM1cuHtXiXwjkO9IJTncPqMSyYWAyOPZovOy7+M
         HKXJZuHXPuOl/J9elmeo6iMwBmeyFrz00y071+NCTvU1nq1hj/j/84H6Oa4uwPQ9/+Ae
         IqfRId9AUwEcQaNy0eow2CeBabWIFg6tAS2jOAs3kAnJshCm9bwwS/uWGs15p/bgKvhG
         5bCKxZEFicPLPckJHicYsivZIHUpFKQeDmMOPVnwV42vWhPnBQ5dWejb4wD2klnEdx7i
         YHerNeGnF96sZM7WaDwpZ5MgykN+gp4OWExqZxgwT7LLZB30esjasWGaanZ3mwDbmoMP
         S3Vg==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Since we will initialize sched_data.service_tree[] in
bfq_init_root_group(), bfq_create_group_hierarchy() can
ignore this part of the initialization, which can avoid
repeated initialization.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index ab4bc41..05054e1 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1514,15 +1514,11 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg) {}
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node)
 {
 	struct bfq_group *bfqg;
-	int i;
 
 	bfqg = kmalloc_node(sizeof(*bfqg), GFP_KERNEL | __GFP_ZERO, node);
 	if (!bfqg)
 		return NULL;
 
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++)
-		bfqg->sched_data.service_tree[i] = BFQ_SERVICE_TREE_INIT;
-
 	return bfqg;
 }
 #endif	/* CONFIG_BFQ_GROUP_IOSCHED */
-- 
1.8.3.1

