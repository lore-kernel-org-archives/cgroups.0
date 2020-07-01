From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] writeback: remove {set,clear}_wb_congested
Date: Wed,  1 Jul 2020 11:06:20 +0200
Message-ID: <20200701090622.3354860-3-hch@lst.de>
References: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ku+5GjH8zw0sgTMrbEULwF4NzqIBXBwEjjtLU2qAwlM=; b=er4MMFOQrl/EQTzzOFx0jLMbL1
        2BlAhROcLRQHs9N0QXhFPhvJi5+bfLZK4yDkD37adIF+HBxn4T+r0YwAfPFqkS8QBbPUrpqM0vPmv
        n6/o4vznQwr5Jx5hrVCzh37vvRP9Nm6lJIjoGRCnfYMQ4u+ytmJUSb7Z5F/jEOpblD+kLEHkPAvKA
        /cUETJzHINIg4mXF7ZiPlJ2gV0swogcP08o6R9OZWnq9qtmFx4RVgfyl/htLKpDJAk0BLey0yKXj8
        2lCydjn5ZnyasyjctAWiTxlbip2/b5l4Gh9+vEK3rFp7qHvA2yC+BHttT9Ob1ID7leVLa595lMtoe
        BTI41cJw==;
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Just merge them into their only callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/backing-dev-defs.h | 14 ++------------
 mm/backing-dev.c                 | 12 ++++++------
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 90a7e844a098f3..cc5aa1f32b91f0 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -232,18 +232,8 @@ enum {
 	BLK_RW_SYNC	= 1,
 };
 
-void clear_wb_congested(struct bdi_writeback_congested *congested, int sync);
-void set_wb_congested(struct bdi_writeback_congested *congested, int sync);
-
-static inline void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	clear_wb_congested(bdi->wb.congested, sync);
-}
-
-static inline void set_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	set_wb_congested(bdi->wb.congested, sync);
-}
+void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
+void set_bdi_congested(struct backing_dev_info *bdi, int sync);
 
 struct wb_lock_cookie {
 	bool locked;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d382272bcc3100..3ebe5144a102f2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1047,29 +1047,29 @@ static wait_queue_head_t congestion_wqh[2] = {
 	};
 static atomic_t nr_wb_congested[2];
 
-void clear_wb_congested(struct bdi_writeback_congested *congested, int sync)
+void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 	enum wb_congested_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &congested->state))
+	if (test_and_clear_bit(bit, &bdi->wb.congested->state))
 		atomic_dec(&nr_wb_congested[sync]);
 	smp_mb__after_atomic();
 	if (waitqueue_active(wqh))
 		wake_up(wqh);
 }
-EXPORT_SYMBOL(clear_wb_congested);
+EXPORT_SYMBOL(clear_bdi_congested);
 
-void set_wb_congested(struct bdi_writeback_congested *congested, int sync)
+void set_bdi_congested(struct backing_dev_info *bdi, int sync)
 {
 	enum wb_congested_state bit;
 
 	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &congested->state))
+	if (!test_and_set_bit(bit, &bdi->wb.congested->state))
 		atomic_inc(&nr_wb_congested[sync]);
 }
-EXPORT_SYMBOL(set_wb_congested);
+EXPORT_SYMBOL(set_bdi_congested);
 
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
-- 
2.26.2

