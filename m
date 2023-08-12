From: zhuxiaohui <zhuxiaohui400-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] blk-throttle: fix throttle configuring not effective
Date: Sat, 12 Aug 2023 15:21:16 +0800
Message-ID: <20230812072116.42321-1-zhuxiaohui.400@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691824884; x=1692429684;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IEENV70+bdbkoZdaUV5XqhM/23tTitj6To+lYwver7M=;
        b=o7GwMmBzt4k4OkA91irOXoOtbUDgvM2iz+y5d7B6/5HN74c1sjPuZ6uZJQa3Ce+sc7
         vGTTqxblgVyVBvKDBfMPjt8Exmr1eHtAb8vexkXuORyuHK/BOil+XQUl7R7uhPIzFQQj
         OQbd/KCOE/okri3p5POGhiZwk0my/2A5dfjbz8T4qb8D+6IwPItdM9J1s7AkKdjxymSd
         IOx/678dJNyXnwZnxzdeahovq7hwmyCqCDj0BFvrhqWnZj8ZL9Fhv2idMpVuXAPp78H0
         BTSXV3rRqQSWLUwzzkdRwYJD40P/f/4licOGWFA2z9WeIrpAOZ2yiaOLM6UMIzuvEN6V
         dXfg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhuxiaohui <zhuxiaohui.400-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

when updating block throttle limit with persistence and stable io
pressure, especially a relative high io pressure, fio test e.g.,
there may never be a change to start a new slice, and carryover_ios &
carryover_bytes will not be cleared.

As a result, when reconfiguring block throttle limit, we can notice that
the actual iops and throughput is a random value far away from what is
set

So we need to update carryover value when dispatching bio

Signed-off-by: zhuxiaohui <zhuxiaohui.400-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 block/blk-throttle.c | 26 ++++++++++++++++++++++++++
 block/blk-throttle.h |  4 ++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7397ff199d66..13c9d87a7201 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -821,6 +821,30 @@ static void tg_update_carryover(struct throtl_grp *tg)
 		   tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
 }
 
+static void tg_charge_carryover(struct throtl_grp *tg, struct bio *bio)
+{
+	bool rw = bio_data_dir(bio);
+
+	if (unlikely(tg->carryover_bytes[rw])) {
+		unsigned int bio_size = throtl_bio_data_size(bio);
+		unsigned int carryout_size = abs(tg->carryover_bytes[rw]);
+
+		carryout_size = min(carryout_size, bio_size);
+
+		if (tg->carryover_bytes[rw] < 0)
+			tg->carryover_bytes[rw] += carryout_size;
+		else
+			tg->carryover_bytes[rw] -= carryout_size;
+	}
+
+	if (unlikely(tg->carryover_ios[rw])) {
+		if (tg->carryover_ios[rw] < 0)
+			tg->carryover_ios[rw] += 1;
+		else
+			tg->carryover_ios[rw] -= 1;
+	}
+}
+
 static unsigned long tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
 				 u32 iops_limit)
 {
@@ -965,6 +989,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 
 	tg->io_disp[rw]++;
 	tg->last_io_disp[rw]++;
+
+	tg_charge_carryover(tg, bio);
 }
 
 /**
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index d1ccbfe9f797..8f1642becb23 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -127,8 +127,8 @@ struct throtl_grp {
 	 * bytes/ios are waited already in previous configuration, and they will
 	 * be used to calculate wait time under new configuration.
 	 */
-	uint64_t carryover_bytes[2];
-	unsigned int carryover_ios[2];
+	int64_t carryover_bytes[2];
+	int carryover_ios[2];
 
 	unsigned long last_check_time;
 
-- 
2.39.2

