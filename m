From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 5/8] blk-throttle: Move the list operation after list validation
Date: Thu,  8 Oct 2020 11:52:26 +0800
Message-ID: <48232fffcfb16d40aa0fedc455a0f69f1f7c45f4.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

We should move the list operation after validation.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0649bce..f1bcb5c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -423,12 +423,13 @@ static void throtl_qnode_add_bio(struct bio *bio, struct throtl_qnode *qn,
  */
 static struct bio *throtl_peek_queued(struct list_head *queued)
 {
-	struct throtl_qnode *qn = list_first_entry(queued, struct throtl_qnode, node);
+	struct throtl_qnode *qn;
 	struct bio *bio;
 
 	if (list_empty(queued))
 		return NULL;
 
+	qn = list_first_entry(queued, struct throtl_qnode, node);
 	bio = bio_list_peek(&qn->bios);
 	WARN_ON_ONCE(!bio);
 	return bio;
@@ -451,12 +452,13 @@ static struct bio *throtl_peek_queued(struct list_head *queued)
 static struct bio *throtl_pop_queued(struct list_head *queued,
 				     struct throtl_grp **tg_to_put)
 {
-	struct throtl_qnode *qn = list_first_entry(queued, struct throtl_qnode, node);
+	struct throtl_qnode *qn;
 	struct bio *bio;
 
 	if (list_empty(queued))
 		return NULL;
 
+	qn = list_first_entry(queued, struct throtl_qnode, node);
 	bio = bio_list_pop(&qn->bios);
 	WARN_ON_ONCE(!bio);
 
-- 
1.8.3.1

