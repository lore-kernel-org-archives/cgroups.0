From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 11/11] block, bfq: cleanup bfqq_group()
Date: Sat, 5 Mar 2022 17:12:05 +0800
Message-ID: <20220305091205.4188398-12-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Now that if bfqq is under root group, 'bfqq->entity.parent' is set to
root group's entity instead of NULL, there is no point for the judgement
in bfqq_group() anymore.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-cgroup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 58acaf14a91d..1fcb13e97cf0 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -307,11 +307,7 @@ static struct bfq_group *bfqg_parent(struct bfq_group *bfqg)
 
 struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
 {
-	struct bfq_entity *group_entity = bfqq->entity.parent;
-
-	return group_entity ? container_of(group_entity, struct bfq_group,
-					   entity) :
-			      bfqq->bfqd->root_group;
+	return container_of(bfqq->entity.parent, struct bfq_group, entity);
 }
 
 /*
-- 
2.31.1

