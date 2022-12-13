From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH v2] block/blk-iocost (gcc13): move large values to a new enum
Date: Tue, 13 Dec 2022 12:21:48 +0100
Message-ID: <20221213112148.15235-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670930512;
        bh=J8x8Q0IckMxnqDnsgI2Wl/DvLqCZm0+N48vFcdoYvvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fXVbA9CX1PAN+uCX6/B5dIVEqPM79vKoPn75G/RWzE33kElapIjl38ecyLeGmocUI
         DazJiamEFfuCOhcni70skTH0I/4Xebq3I3BDyVGAj/Z/8ZDwz1UyJfVfJG7fwpkqmy
         /I8LLBYn6eabc1baaFDwqmOmW1RuCIzwkr5H01N3mjYlUpzzfvV9UlfSftkBLImPpz
         /XUI5V2yWA4hiIDTMT5KV0YmPDVKMMQW2h1fWKsUBfYCKbMp5CtFaCUqmOVipccH3I
         0VmDj6YSFV07jFiXv6tS94CY3SIWBi0XIrFVm3+2T2oIgcEFcmQqUKlp5d2XR/hIFl
         pDQiJSCts1Zbg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Jiri Slaby (SUSE)" <jirislaby@kernel.org>, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided:
  VTIME_PER_SEC_SHIFT     = 37,
  VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
the named type is unsigned long.

This generates warnings with gcc-13:
  block/blk-iocost.c: In function 'ioc_weight_prfill':
  block/blk-iocost.c:3037:37: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int'

  block/blk-iocost.c: In function 'ioc_weight_show':
  block/blk-iocost.c:3047:34: error: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int'

So move the large VTIME values away to a separate enum, so that they
don't affect other members. Move also VRATE ones as they depend on
VTIME.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org
Cc: linux-block@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---

Notes:
    [v2] move to a new enum

 block/blk-iocost.c | 48 ++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d1bdc12deaa7..49d6e5aec3d5 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -233,29 +233,6 @@ enum {
 	/* 1/64k is granular enough and can easily be handled w/ u32 */
 	WEIGHT_ONE		= 1 << 16,
 
-	/*
-	 * As vtime is used to calculate the cost of each IO, it needs to
-	 * be fairly high precision.  For example, it should be able to
-	 * represent the cost of a single page worth of discard with
-	 * suffificient accuracy.  At the same time, it should be able to
-	 * represent reasonably long enough durations to be useful and
-	 * convenient during operation.
-	 *
-	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
-	 * granularity and days of wrap-around time even at extreme vrates.
-	 */
-	VTIME_PER_SEC_SHIFT	= 37,
-	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
-	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
-	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
-
-	/* bound vrate adjustments within two orders of magnitude */
-	VRATE_MIN_PPM		= 10000,	/* 1% */
-	VRATE_MAX_PPM		= 100000000,	/* 10000% */
-
-	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
-	VRATE_CLAMP_ADJ_PCT	= 4,
-
 	/* if IOs end up waiting for requests, issue less */
 	RQ_WAIT_BUSY_PCT	= 5,
 
@@ -310,6 +287,31 @@ enum {
 	LCOEF_RANDIO_PAGES	= 4096,
 };
 
+enum {
+	/*
+	 * As vtime is used to calculate the cost of each IO, it needs to
+	 * be fairly high precision.  For example, it should be able to
+	 * represent the cost of a single page worth of discard with
+	 * suffificient accuracy.  At the same time, it should be able to
+	 * represent reasonably long enough durations to be useful and
+	 * convenient during operation.
+	 *
+	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
+	 * granularity and days of wrap-around time even at extreme vrates.
+	 */
+	VTIME_PER_SEC_SHIFT	= 37,
+	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
+	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
+	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
+
+	/* bound vrate adjustments within two orders of magnitude */
+	VRATE_MIN_PPM		= 10000,	/* 1% */
+	VRATE_MAX_PPM		= 100000000,	/* 10000% */
+
+	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
+	VRATE_CLAMP_ADJ_PCT	= 4,
+};
+
 enum ioc_running {
 	IOC_IDLE,
 	IOC_RUNNING,
-- 
2.39.0

