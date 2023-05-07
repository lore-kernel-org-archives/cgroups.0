From: Jinke Han <hanjinke.666@bytedance.com>
Subject: [PATCH v3] blk-throttle: Fix io statistics for cgroup v1
Date: Mon,  8 May 2023 01:06:31 +0800
Message-ID: <20230507170631.89607-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683479248; x=1686071248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GwSoQAc7RbQrYw6wtZrAMpWLXHB/By9Q7OuDr1RV12Y=;
        b=PHn3HatrrXTilibhO/B32WQZfXLxtuQRjz3v3L2ZfTB9+VVfks2XHVrwDw8QEDzc34
         nRzUlgMxNktS121uu7zypH1Rp/S3fBwUJqtWRT1wB17zDGnc1bsbLAoWowu4t2QAb293
         UDM2cCdAcdgO7PF9CmnXJl8XDJCaL7J0alieJUM3hyb+3l1TloGpfuq82/xDVa8DWLn7
         IBnroT+IA39zWwwC3YexhUD/iQBhTujVWyEmuN2sORnYQ4/zxRtOhmcVZJZorD5X8D4t
         ZxyRhJMgR2J7/mpg2D/S9x79GzL4iSHtI8KbysR0Wx5//OGYvrcMTUUUjgP/5Ivs6OZD
         fEBQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, andrea.righi@canonical.com, Jinke Han <hanjinke.666@bytedance.com>

From: Jinke Han <hanjinke.666@bytedance.com>

After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
the only stable io stats interface of cgroup v1, and these statistics
are done in the blk-throttle code. But the current code only counts the
bios that are actually throttled. When the user does not add the throttle
limit, the io stats for cgroup v1 has nothing. I fix it according to the
statistical method of v2, and made it count all ios accurately.

Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
---
 block/blk-cgroup.c   | 6 ++++--
 block/blk-throttle.c | 6 ------
 block/blk-throttle.h | 9 +++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0ce64dd73cfe..5b29912a0ee2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2048,6 +2048,9 @@ void blk_cgroup_bio_start(struct bio *bio)
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
 
+	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
+		return;
+
 	/* Root-level stats are sourced from system-wide IO stats */
 	if (!cgroup_parent(blkcg->css.cgroup))
 		return;
@@ -2079,8 +2082,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
-	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
-		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
+	cgroup_rstat_updated(blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9d010d867fbf..7397ff199d66 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2178,12 +2178,6 @@ bool __blk_throtl_bio(struct bio *bio)
 
 	rcu_read_lock();
 
-	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
-		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
-				bio->bi_iter.bi_size);
-		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
-	}
-
 	spin_lock_irq(&q->queue_lock);
 
 	throtl_update_latency_buckets(td);
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index ef4b7a4de987..d1ccbfe9f797 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -185,6 +185,15 @@ static inline bool blk_should_throtl(struct bio *bio)
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 	int rw = bio_data_dir(bio);
 
+	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
+		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
+			bio_set_flag(bio, BIO_CGROUP_ACCT);
+			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
+					bio->bi_iter.bi_size);
+		}
+		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
+	}
+
 	/* iops limit is always counted */
 	if (tg->has_rules_iops[rw])
 		return true;
-- 
2.20.1

