From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 2/4] blk-throtl: don't warn in tg_drain_bios()
Date: Wed, 22 Sep 2021 20:51:13 +0800
Message-ID: <20210922125115.381752-3-yukuai3@huawei.com>
References: <20210922125115.381752-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20210922125115.381752-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

tg_drain_bios() will iterate until throtl_rb_first() return NULL,
don't warn in such situation.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 43dee985170b..3892ead7a0b5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -644,12 +644,13 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 }
 
 static struct throtl_grp *
-throtl_rb_first(struct throtl_service_queue *parent_sq)
+throtl_rb_first(struct throtl_service_queue *parent_sq, bool warn)
 {
 	struct rb_node *n;
 
 	n = rb_first_cached(&parent_sq->pending_tree);
-	WARN_ON_ONCE(!n);
+	if (warn)
+		WARN_ON_ONCE(!n);
 	if (!n)
 		return NULL;
 	return rb_entry_tg(n);
@@ -667,7 +668,7 @@ static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
 {
 	struct throtl_grp *tg;
 
-	tg = throtl_rb_first(parent_sq);
+	tg = throtl_rb_first(parent_sq, true);
 	if (!tg)
 		return;
 
@@ -1236,7 +1237,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 		if (!parent_sq->nr_pending)
 			break;
 
-		tg = throtl_rb_first(parent_sq);
+		tg = throtl_rb_first(parent_sq, true);
 		if (!tg)
 			break;
 
@@ -2421,7 +2422,7 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
 {
 	struct throtl_grp *tg;
 
-	while ((tg = throtl_rb_first(parent_sq))) {
+	while ((tg = throtl_rb_first(parent_sq, false))) {
 		struct throtl_service_queue *sq = &tg->service_queue;
 		struct bio *bio;
 
-- 
2.31.1

