From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/19] blk-wbt: move private information from blk-wbt.h to blk-wbt.c
Date: Wed,  1 Feb 2023 14:41:14 +0100
Message-ID: <20230201134123.2656505-11-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XppORhqACzXr/tYTziTms4imtQlY5N3dyLLJTn5U4h0=; b=gS0IyX2ODrvyKlDI6hqlp5xTS8
        y2pKrxbY6RrBjs1nWaxr58+1EgxXSflVkNc/r+RSV+KWP/lrhqZ2fa6U9CjjaOPOC10SNWqXfBla3
        FVPn3mY2a737PhMxlq1gGTY3JqphGSiYZ+XwzqEvQ7/e3ufivF9cvIuXXSJ6gBOCUxD4taDHTQGOw
        AjEpdaWkwkHLiRvEWv0Qlhl7FomQgU154aPKZeknr2d7xxZz2HaqNvWtLTMsHlCImWaGjexXAot/C
        0m3IHBDx0wNf3taw28Yo59PWsLkHCzh3AwC7gVduAlOd3K9hVzAq1KvG5PH/fCJLFJtR9+6dgyM8T
        uv1tpNcw==;
In-Reply-To: <20230201134123.2656505-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A large part of blk-wbt.h is only used in blk-wbt.c, so move it there.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-settings.c |  1 +
 block/blk-sysfs.c    |  1 +
 block/blk-wbt.c      | 77 +++++++++++++++++++++++++++++++++++++++
 block/blk-wbt.h      | 86 --------------------------------------------
 4 files changed, 79 insertions(+), 86 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9c9713c9269cc4..896b4654ab00fa 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -16,6 +16,7 @@
 #include <linux/dma-mapping.h>
 
 #include "blk.h"
+#include "blk-rq-qos.h"
 #include "blk-wbt.h"
 
 void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index c2adf640e5c816..d70ebecb534798 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -16,6 +16,7 @@
 #include "blk-mq.h"
 #include "blk-mq-debugfs.h"
 #include "blk-mq-sched.h"
+#include "blk-rq-qos.h"
 #include "blk-wbt.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 542271fa99e8f7..58f41a98fda911 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -25,6 +25,7 @@
 #include <linux/backing-dev.h>
 #include <linux/swap.h>
 
+#include "blk-stat.h"
 #include "blk-wbt.h"
 #include "blk-rq-qos.h"
 #include "elevator.h"
@@ -32,6 +33,72 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/wbt.h>
 
+enum wbt_flags {
+	WBT_TRACKED		= 1,	/* write, tracked for throttling */
+	WBT_READ		= 2,	/* read */
+	WBT_KSWAPD		= 4,	/* write, from kswapd */
+	WBT_DISCARD		= 8,	/* discard */
+
+	WBT_NR_BITS		= 4,	/* number of bits */
+};
+
+enum {
+	WBT_RWQ_BG		= 0,
+	WBT_RWQ_KSWAPD,
+	WBT_RWQ_DISCARD,
+	WBT_NUM_RWQ,
+};
+
+/*
+ * If current state is WBT_STATE_ON/OFF_DEFAULT, it can be covered to any other
+ * state, if current state is WBT_STATE_ON/OFF_MANUAL, it can only be covered
+ * to WBT_STATE_OFF/ON_MANUAL.
+ */
+enum {
+	WBT_STATE_ON_DEFAULT	= 1,	/* on by default */
+	WBT_STATE_ON_MANUAL	= 2,	/* on manually by sysfs */
+	WBT_STATE_OFF_DEFAULT	= 3,	/* off by default */
+	WBT_STATE_OFF_MANUAL	= 4,	/* off manually by sysfs */
+};
+
+struct rq_wb {
+	/*
+	 * Settings that govern how we throttle
+	 */
+	unsigned int wb_background;		/* background writeback */
+	unsigned int wb_normal;			/* normal writeback */
+
+	short enable_state;			/* WBT_STATE_* */
+
+	/*
+	 * Number of consecutive periods where we don't have enough
+	 * information to make a firm scale up/down decision.
+	 */
+	unsigned int unknown_cnt;
+
+	u64 win_nsec;				/* default window size */
+	u64 cur_win_nsec;			/* current window size */
+
+	struct blk_stat_callback *cb;
+
+	u64 sync_issue;
+	void *sync_cookie;
+
+	unsigned int wc;
+
+	unsigned long last_issue;		/* last non-throttled issue */
+	unsigned long last_comp;		/* last non-throttled comp */
+	unsigned long min_lat_nsec;
+	struct rq_qos rqos;
+	struct rq_wait rq_wait[WBT_NUM_RWQ];
+	struct rq_depth rq_depth;
+};
+
+static inline struct rq_wb *RQWB(struct rq_qos *rqos)
+{
+	return container_of(rqos, struct rq_wb, rqos);
+}
+
 static inline void wbt_clear_state(struct request *rq)
 {
 	rq->wbt_flags = 0;
@@ -226,6 +293,16 @@ static u64 rwb_sync_issue_lat(struct rq_wb *rwb)
 	return now - issue;
 }
 
+static inline unsigned int wbt_inflight(struct rq_wb *rwb)
+{
+	unsigned int i, ret = 0;
+
+	for (i = 0; i < WBT_NUM_RWQ; i++)
+		ret += atomic_read(&rwb->rq_wait[i].inflight);
+
+	return ret;
+}
+
 enum {
 	LAT_OK = 1,
 	LAT_UNKNOWN,
diff --git a/block/blk-wbt.h b/block/blk-wbt.h
index b673da41a867d3..ba6cca5849a655 100644
--- a/block/blk-wbt.h
+++ b/block/blk-wbt.h
@@ -2,92 +2,6 @@
 #ifndef WB_THROTTLE_H
 #define WB_THROTTLE_H
 
-#include <linux/kernel.h>
-#include <linux/atomic.h>
-#include <linux/wait.h>
-#include <linux/timer.h>
-#include <linux/ktime.h>
-
-#include "blk-stat.h"
-#include "blk-rq-qos.h"
-
-enum wbt_flags {
-	WBT_TRACKED		= 1,	/* write, tracked for throttling */
-	WBT_READ		= 2,	/* read */
-	WBT_KSWAPD		= 4,	/* write, from kswapd */
-	WBT_DISCARD		= 8,	/* discard */
-
-	WBT_NR_BITS		= 4,	/* number of bits */
-};
-
-enum {
-	WBT_RWQ_BG		= 0,
-	WBT_RWQ_KSWAPD,
-	WBT_RWQ_DISCARD,
-	WBT_NUM_RWQ,
-};
-
-/*
- * If current state is WBT_STATE_ON/OFF_DEFAULT, it can be covered to any other
- * state, if current state is WBT_STATE_ON/OFF_MANUAL, it can only be covered
- * to WBT_STATE_OFF/ON_MANUAL.
- */
-enum {
-	WBT_STATE_ON_DEFAULT	= 1,	/* on by default */
-	WBT_STATE_ON_MANUAL	= 2,	/* on manually by sysfs */
-	WBT_STATE_OFF_DEFAULT	= 3,	/* off by default */
-	WBT_STATE_OFF_MANUAL	= 4,	/* off manually by sysfs */
-};
-
-struct rq_wb {
-	/*
-	 * Settings that govern how we throttle
-	 */
-	unsigned int wb_background;		/* background writeback */
-	unsigned int wb_normal;			/* normal writeback */
-
-	short enable_state;			/* WBT_STATE_* */
-
-	/*
-	 * Number of consecutive periods where we don't have enough
-	 * information to make a firm scale up/down decision.
-	 */
-	unsigned int unknown_cnt;
-
-	u64 win_nsec;				/* default window size */
-	u64 cur_win_nsec;			/* current window size */
-
-	struct blk_stat_callback *cb;
-
-	u64 sync_issue;
-	void *sync_cookie;
-
-	unsigned int wc;
-
-	unsigned long last_issue;		/* last non-throttled issue */
-	unsigned long last_comp;		/* last non-throttled comp */
-	unsigned long min_lat_nsec;
-	struct rq_qos rqos;
-	struct rq_wait rq_wait[WBT_NUM_RWQ];
-	struct rq_depth rq_depth;
-};
-
-static inline struct rq_wb *RQWB(struct rq_qos *rqos)
-{
-	return container_of(rqos, struct rq_wb, rqos);
-}
-
-static inline unsigned int wbt_inflight(struct rq_wb *rwb)
-{
-	unsigned int i, ret = 0;
-
-	for (i = 0; i < WBT_NUM_RWQ; i++)
-		ret += atomic_read(&rwb->rq_wait[i].inflight);
-
-	return ret;
-}
-
-
 #ifdef CONFIG_BLK_WBT
 
 int wbt_init(struct gendisk *disk);
-- 
2.39.0

