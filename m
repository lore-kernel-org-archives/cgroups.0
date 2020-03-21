From: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Subject: [RFC 2/3] bio: track timestamp of submitting bio the disk driver
Date: Sat, 21 Mar 2020 09:21:12 +0800
Message-ID: <178d7f1408a7d6465840c8d8730dd490cecf96b0.1584728740.git.zhangweiping@didiglobal.com>
References: <cover.1584728740.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1584728740.git.zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Change-Id: Ibb9caf20616f83e111113ab5c824c05930c0e523
Signed-off-by: Weiping Zhang <zhangweiping-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
---
 block/blk-mq.c             |  3 +++
 include/linux/blk-cgroup.h |  6 ++++++
 include/linux/blk_types.h  | 29 +++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5b2e6550e0b6..53db008ac8d0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -652,6 +652,7 @@ EXPORT_SYMBOL(blk_mq_complete_request);
 void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
+	struct bio *bio;
 
 	trace_block_rq_issue(q, rq);
 
@@ -660,6 +661,8 @@ void blk_mq_start_request(struct request *rq)
 		rq->stats_sectors = blk_rq_sectors(rq);
 		rq->rq_flags |= RQF_STATS;
 		rq_qos_issue(q, rq);
+		__rq_for_each_bio(bio, rq)
+			blkcg_bio_start_init(bio);
 	}
 
 	WARN_ON_ONCE(blk_mq_rq_state(rq) != MQ_RQ_IDLE);
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index e4a6949fd171..9720f04a9523 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -579,6 +579,11 @@ static inline void blkcg_bio_issue_init(struct bio *bio)
 	bio_issue_init(&bio->bi_issue, bio_sectors(bio));
 }
 
+static inline void blkcg_bio_start_init(struct bio *bio)
+{
+	bio_start_init(&bio->bi_start);
+}
+
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
@@ -738,6 +743,7 @@ static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
 
 static inline bool blkcg_punt_bio_submit(struct bio *bio) { return false; }
++static inline void blkcg_bio_start_init(struct bio *bio) { }
 static inline void blkcg_bio_issue_init(struct bio *bio) { }
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio) { return true; }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 56e41ef3e827..30dc3a73235f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -109,10 +109,38 @@ static inline bool blk_path_error(blk_status_t error)
 /* Reserved bit for blk-throtl */
 #define BIO_ISSUE_THROTL_SKIP_LATENCY (1ULL << 63)
 
+/* submit bio to block layer */
 struct bio_issue {
 	u64 value;
 };
 
+/*
+ * submit bio to the disk driver layer
+ *
+ * 63:51	reserved
+ * 50:0		bits: start time of bio
+ *
+ * same bitmask as bi_issue
+ */
+struct bio_start {
+	u64 value;
+};
+
+static inline u64 __bio_start_time(u64 time)
+{
+	return time & BIO_ISSUE_TIME_MASK;
+}
+
+static inline u64 bio_start_time(struct bio_start *start)
+{
+	return __bio_start_time(start->value);
+}
+
+static inline void bio_start_init(struct bio_start *start)
+{
+	start->value = ktime_get_ns() & BIO_ISSUE_TIME_MASK;
+}
+
 static inline u64 __bio_issue_time(u64 time)
 {
 	return time & BIO_ISSUE_TIME_MASK;
@@ -178,6 +206,7 @@ struct bio {
 	 */
 	struct blkcg_gq		*bi_blkg;
 	struct bio_issue	bi_issue;
+	struct bio_start	bi_start;
 #ifdef CONFIG_BLK_CGROUP_IOCOST
 	u64			bi_iocost_cost;
 #endif
-- 
2.18.1

