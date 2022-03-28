From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 09/43] block: throttle split bio in case of iops limit
Date: Mon, 28 Mar 2022 07:17:53 -0400
Message-ID: <20220328111828.1554086-9-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466327;
        bh=CwNmiHP3kD2ALWMRRxrmMavzMxlIsHerayanhfBCWHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODxbLQ0xzKW+OAIuli4A3kNCXPy0ImubFYF1GZ/S0DznXOdeE3s7lKgap699HTmTN
         c0Z6fgFryWmLhT9QIfwEeWwOg8jpP4ZMYHId95eHb7YkLg92W1FaNq+evZ01oa82vV
         4mkMr7vNt0/h3TX2eClhR5hhKRUfm9t402vfgAtSMyxJPE6OkoYUKHlLU2e/yHPr4u
         NhpGEAlaEUA4ImuYAh9lLAcIseqMjoGv+46rxWDcwQIuvPidIkjcaGJLlOciyIQccl
         mS/iIEINYjRT4lCz/QWqQJGKt9W+SkM91K56orv+zFt8vv63FmnGW7iZaKc0d6I6tN
         LfuDQok2I8bFw==
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>, Ning Li <lining2020x@163.com>, Tejun Heo <tj@kernel.org>, Chunguang Xu <brookxu@tencent.com>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 9f5ede3c01f9951b0ae7d68b28762ad51d9bacc8 ]

Commit 111be8839817 ("block-throttle: avoid double charge") marks bio as
BIO_THROTTLED unconditionally if __blk_throtl_bio() is called on this bio,
then this bio won't be called into __blk_throtl_bio() any more. This way
is to avoid double charge in case of bio splitting. It is reasonable for
read/write throughput limit, but not reasonable for IOPS limit because
block layer provides io accounting against split bio.

Chunguang Xu has already observed this issue and fixed it in commit
4f1e9630afe6 ("blk-throtl: optimize IOPS throttle for large IO scenarios").
However, that patch only covers bio splitting in __blk_queue_split(), and
we have other kind of bio splitting, such as bio_split() &
submit_bio_noacct() and other ways.

This patch tries to fix the issue in one generic way by always charging
the bio for iops limit in blk_throtl_bio(). This way is reasonable:
re-submission & fast-cloned bio is charged if it is submitted to same
disk/queue, and BIO_THROTTLED will be cleared if bio->bi_bdev is changed.

This new approach can get much more smooth/stable iops limit compared with
commit 4f1e9630afe6 ("blk-throtl: optimize IOPS throttle for large IO
scenarios") since that commit can't throttle current split bios actually.

Also this way won't cause new double bio iops charge in
blk_throtl_dispatch_work_fn() in which blk_throtl_bio() won't be called
any more.

Reported-by: Ning Li <lining2020x@163.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Chunguang Xu <brookxu@tencent.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220216044514.2903784-7-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c    |  2 --
 block/blk-throttle.c | 10 +++++++---
 block/blk-throttle.h |  2 --
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4de34a332c9f..f5255991b773 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -368,8 +368,6 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
-
-		blk_throtl_charge_bio_split(*bio);
 	}
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7c462c006b26..87769b337fc5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -808,7 +808,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
-	if (bps_limit == U64_MAX) {
+	/* no need to throttle if this bio's bytes have been accounted */
+	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -920,9 +921,12 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	/* Charge the bio to the group */
-	tg->bytes_disp[rw] += bio_size;
+	if (!bio_flagged(bio, BIO_THROTTLED)) {
+		tg->bytes_disp[rw] += bio_size;
+		tg->last_bytes_disp[rw] += bio_size;
+	}
+
 	tg->io_disp[rw]++;
-	tg->last_bytes_disp[rw] += bio_size;
 	tg->last_io_disp[rw]++;
 
 	/*
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 175f03abd9e4..cb43f4417d6e 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -170,8 +170,6 @@ static inline bool blk_throtl_bio(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 
-	if (bio_flagged(bio, BIO_THROTTLED))
-		return false;
 	if (!tg->has_rules[bio_data_dir(bio)])
 		return false;
 
-- 
2.34.1

