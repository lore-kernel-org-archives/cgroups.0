From: Weiping Zhang <zhangweiping@didiglobal.com>
Subject: [RFC PATCH v2 1/3] bio: update the real issue size when bio_split
Date: Fri, 27 Mar 2020 14:28:50 +0800
Message-ID: <20200327062850.GA12578@192.168.3.9>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

The split.bi_iter.bi_size was copied from @bio,
bi_issue was initialized in this flow:
bio_clone_fast->__bio_clone_fast->blkcg_bio_issue_init

So the split->bi_issue has a wrong size, so update the size
at here.

Change-Id: I1f9c8c973ac1d41f4aea17a9a766b4c4d532f642
Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
---
 block/bio.c               | 13 +++++++++++++
 include/linux/blk_types.h |  9 +++++++++
 2 files changed, 22 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 0985f3422556..8654c4d692e5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1911,6 +1911,19 @@ struct bio *bio_split(struct bio *bio, int sectors,
 
 	split->bi_iter.bi_size = sectors << 9;
 
+	/*
+	 * reinit bio->bi_issue, the split.bi_iter.bi_size was copied
+	 * from @bio, bi_issue was initialized in this flow:
+	 * bio_clone_fast->__bio_clone_fast->blkcg_bio_issue_init
+	 *
+	 * So the split->bi_issue has a wrong size, so update the size
+	 * at here.
+	 *
+	 * Actually, we can just use blkcg_bio_issue_init, there is just
+	 * a bit difference for the issue_time.
+	 */
+	bio_issue_update_size(&split->bi_issue, bio_sectors(split));
+
 	if (bio_integrity(split))
 		bio_integrity_trim(split);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 70254ae11769..fea81e3775c4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -128,6 +128,15 @@ static inline sector_t bio_issue_size(struct bio_issue *issue)
 	return ((issue->value & BIO_ISSUE_SIZE_MASK) >> BIO_ISSUE_SIZE_SHIFT);
 }
 
+static inline void bio_issue_update_size(struct bio_issue *issue, sector_t size)
+{
+	size &= (1ULL << BIO_ISSUE_SIZE_BITS) - 1;
+	/* clear issue_size bits to 0 */
+	issue->value &= ~(u64)BIO_ISSUE_SIZE_MASK;
+	/* set new size */
+	issue->value |= ((u64)size << BIO_ISSUE_SIZE_SHIFT);
+}
+
 static inline void bio_issue_init(struct bio_issue *issue,
 				       sector_t size)
 {
-- 
2.18.1

