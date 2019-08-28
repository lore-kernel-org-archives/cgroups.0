From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] blkcg: s/RQ_QOS_CGROUP/RQ_QOS_LATENCY/
Date: Wed, 28 Aug 2019 15:05:56 -0700
Message-ID: <20190828220600.2527417-7-tj@kernel.org>
References: <20190828220600.2527417-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KICYxWKT5dxQPbrCwvbX65RDkKc1Qm5xckGukET75uw=;
        b=hGSObE46mrzPGCerWrDrpt0b7WXeKGm/n3XDOQo+v8RG3F68dq2ll00C64WPj7mfL5
         GdDA5ZzVNIuL+kCHazgDanC19G4392qfBA1Xb7FZTFEfTmDn7yhciq/yEiqxFpcQHd3Z
         gOdcU067Z0at2ye7SUTC3sAIKBD2aTnYNvweQJfQ+XWQ03CAQS67/Gw6hCeIo7AVloZJ
         RIiOSpIPM/LmSpABoGyI+J1DL+Pozvqrcb1/uMgF+X5N+u1ODKlXCGxBvGxd9BjaTvax
         hAmAtuiJ5U6wBH0vmOwPUAatFI6M2rDtKPluGKhGO/nopDx3ejPNk2iLSF3khWNzinZg
         15IQ==
In-Reply-To: <20190828220600.2527417-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

io.weight is gonna be another rq_qos cgroup mechanism.  Let's rename
RQ_QOS_CGROUP which is being used by io.latency to RQ_QOS_LATENCY in
preparation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iolatency.c | 2 +-
 block/blk-rq-qos.h    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 46fa6449f4bb..c128d50cb410 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -725,7 +725,7 @@ int blk_iolatency_init(struct request_queue *q)
 		return -ENOMEM;
 
 	rqos = &blkiolat->rqos;
-	rqos->id = RQ_QOS_CGROUP;
+	rqos->id = RQ_QOS_LATENCY;
 	rqos->ops = &blkcg_iolatency_ops;
 	rqos->q = q;
 
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index e15b6907b76d..5f8b75826a98 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -14,7 +14,7 @@ struct blk_mq_debugfs_attr;
 
 enum rq_qos_id {
 	RQ_QOS_WBT,
-	RQ_QOS_CGROUP,
+	RQ_QOS_LATENCY,
 };
 
 struct rq_wait {
@@ -74,7 +74,7 @@ static inline struct rq_qos *wbt_rq_qos(struct request_queue *q)
 
 static inline struct rq_qos *blkcg_rq_qos(struct request_queue *q)
 {
-	return rq_qos_id(q, RQ_QOS_CGROUP);
+	return rq_qos_id(q, RQ_QOS_LATENCY);
 }
 
 static inline const char *rq_qos_id_to_name(enum rq_qos_id id)
@@ -82,8 +82,8 @@ static inline const char *rq_qos_id_to_name(enum rq_qos_id id)
 	switch (id) {
 	case RQ_QOS_WBT:
 		return "wbt";
-	case RQ_QOS_CGROUP:
-		return "cgroup";
+	case RQ_QOS_LATENCY:
+		return "latency";
 	}
 	return "unknown";
 }
-- 
2.17.1

