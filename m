From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v2 1/2] blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
Date: Tue, 30 Nov 2021 09:17:29 +0800
Message-ID: <20211130011730.2584339-2-yukuai3@huawei.com>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211130011730.2584339-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@infradead.org, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to reintroduce tg_drain_bios(), which will iterate until
throtl_rb_first() return NULL.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e68a9a2..f7244190cb2f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -502,7 +502,6 @@ throtl_rb_first(struct throtl_service_queue *parent_sq)
 	struct rb_node *n;
 
 	n = rb_first_cached(&parent_sq->pending_tree);
-	WARN_ON_ONCE(!n);
 	if (!n)
 		return NULL;
 	return rb_entry_tg(n);
@@ -521,8 +520,10 @@ static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
 	struct throtl_grp *tg;
 
 	tg = throtl_rb_first(parent_sq);
-	if (!tg)
+	if (!tg) {
+		WARN_ON_ONCE(1);
 		return;
+	}
 
 	parent_sq->first_pending_disptime = tg->disptime;
 }
@@ -1090,8 +1091,10 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 			break;
 
 		tg = throtl_rb_first(parent_sq);
-		if (!tg)
+		if (!tg) {
+			WARN_ON_ONCE(1);
 			break;
+		}
 
 		if (time_before(jiffies, tg->disptime))
 			break;
-- 
2.31.1

