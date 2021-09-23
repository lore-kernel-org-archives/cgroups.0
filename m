From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 1/6] rq-qos: introduce rq_qos_free()
Date: Thu, 23 Sep 2021 21:46:26 +0800
Message-ID: <20210923134631.105719-2-yukuai3@huawei.com>
References: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20210923134631.105719-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to split the release of rq_qos from blk_cleanup_queue() to
blk_release_queue() to fix a uaf problem, no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-rq-qos.c | 10 ++++++++++
 block/blk-rq-qos.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 14ff6d37698c..bc22d0312765 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -308,3 +308,13 @@ void rq_qos_exit(struct request_queue *q)
 		rqos->ops->exit(rqos);
 	}
 }
+
+void rq_qos_free(struct request_queue *q)
+{
+	while (q->rq_qos) {
+		struct rq_qos *rqos = q->rq_qos;
+
+		q->rq_qos = rqos->next;
+		rqos->ops->free(rqos);
+	}
+}
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index f000f83e0621..0af5750bb737 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -46,6 +46,7 @@ struct rq_qos_ops {
 	void (*cleanup)(struct rq_qos *, struct bio *);
 	void (*queue_depth_changed)(struct rq_qos *);
 	void (*exit)(struct rq_qos *);
+	void (*free)(struct rq_qos *);
 	const struct blk_mq_debugfs_attr *debugfs_attrs;
 };
 
@@ -215,5 +216,6 @@ static inline void rq_qos_queue_depth_changed(struct request_queue *q)
 }
 
 void rq_qos_exit(struct request_queue *);
+void rq_qos_free(struct request_queue *);
 
 #endif
-- 
2.31.1

