From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 1/3] block, bfq: remove unused functions
Date: Tue, 16 Aug 2022 09:56:29 +0800
Message-ID: <20220816015631.1323948-2-yukuai1@huaweicloud.com>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

While doing code coverage testing(CONFIG_BFQ_CGROUP_DEBUG is disabled), we
found that some functions doesn't have caller, thus remove them.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-cgroup.c  |  5 -----
 block/bfq-iosched.h | 13 ++++++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 30b15a9a47c4..144bca006463 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -254,17 +254,12 @@ void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
 
 #else /* CONFIG_BFQ_CGROUP_DEBUG */
 
-void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
-			      blk_opf_t opf) { }
 void bfqg_stats_update_io_remove(struct bfq_group *bfqg, blk_opf_t opf) { }
 void bfqg_stats_update_io_merged(struct bfq_group *bfqg, blk_opf_t opf) { }
 void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
 				  u64 io_start_time_ns, blk_opf_t opf) { }
 void bfqg_stats_update_dequeue(struct bfq_group *bfqg) { }
-void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg) { }
-void bfqg_stats_update_idle_time(struct bfq_group *bfqg) { }
 void bfqg_stats_set_start_idle_time(struct bfq_group *bfqg) { }
-void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg) { }
 
 #endif /* CONFIG_BFQ_CGROUP_DEBUG */
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index ad8e513d7e87..f81ab3c8fa3c 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -993,20 +993,23 @@ void bfq_put_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 /* ---------------- cgroups-support interface ---------------- */
 
 void bfqg_stats_update_legacy_io(struct request_queue *q, struct request *rq);
-void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
-			      blk_opf_t opf);
 void bfqg_stats_update_io_remove(struct bfq_group *bfqg, blk_opf_t opf);
 void bfqg_stats_update_io_merged(struct bfq_group *bfqg, blk_opf_t opf);
 void bfqg_stats_update_completion(struct bfq_group *bfqg, u64 start_time_ns,
 				  u64 io_start_time_ns, blk_opf_t opf);
 void bfqg_stats_update_dequeue(struct bfq_group *bfqg);
-void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg);
-void bfqg_stats_update_idle_time(struct bfq_group *bfqg);
 void bfqg_stats_set_start_idle_time(struct bfq_group *bfqg);
-void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg);
 void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		   struct bfq_group *bfqg);
 
+#ifdef CONFIG_BFQ_CGROUP_DEBUG
+void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
+			      blk_opf_t opf);
+void bfqg_stats_set_start_empty_time(struct bfq_group *bfqg);
+void bfqg_stats_update_idle_time(struct bfq_group *bfqg);
+void bfqg_stats_update_avg_queue_size(struct bfq_group *bfqg);
+#endif
+
 void bfq_init_entity(struct bfq_entity *entity, struct bfq_group *bfqg);
 void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio);
 void bfq_end_wr_async(struct bfq_data *bfqd);
-- 
2.31.1

