From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] blk-iocost: avoid 64-bit division in ioc_timer_fn
Date: Wed, 18 Jan 2023 09:07:01 +0100
Message-ID: <20230118080706.3303186-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029233;
        bh=jV7i9GOJFI/Ud+m8L/XR9u5kzqRqvbbtkxuVTnegFv0=;
        h=From:To:Cc:Subject:Date:From;
        b=hE9uf9tA9pYO+pI66/xY5O8+jR+zScqB63M3U6aiTPIAe1bwEzMc5i+1ivbvdYs8C
         Y/NoVnKf6GSXY6DmNtXLL4WutHYj2zCjiy9q9zxjgrBaHX44DOd0ym+L63Z0kr54AN
         uChgkqEihIGa9nIoOMWtS/qJCBpC8iEYmTq7BipJKGEUHhnYs1Yw9BERk97XugR8+P
         D8JHi4jthfx/TajyRznKPg8X9J6MV6SzVBWukSRwkeO+TClzAywpoK6izRxeZsVvNV
         O9RzDY6EQnSELfSMmuOsjcagdPrNhauThPFk+Azop9nDovIJ6gZoYMfbc5HQgb+3iz
         i1t2zSYZ5Jw8A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

The behavior of 'enum' types has changed in gcc-13, so now the
UNBUSY_THR_PCT constant is interpreted as a 64-bit number because
it is defined as part of the same enum definition as some other
constants that do not fit within a 32-bit integer. This in turn
leads to some inefficient code on 32-bit architectures as well
as a link error:

arm-linux-gnueabi/bin/arm-linux-gnueabi-ld: block/blk-iocost.o: in function `ioc_timer_fn':
blk-iocost.c:(.text+0x68e8): undefined reference to `__aeabi_uldivmod'
arm-linux-gnueabi-ld: blk-iocost.c:(.text+0x6908): undefined reference to `__aeabi_uldivmod'

Split the enum definition to keep the 64-bit timing constants in
a separate enum type from those constants that can clearly fit
within a smaller type.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 block/blk-iocost.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6955605629e4..b691b6bb498f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -258,6 +258,11 @@ enum {
 	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
 	VRATE_CLAMP_ADJ_PCT	= 4,
 
+	/* switch iff the conditions are met for longer than this */
+	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
+};
+
+enum {
 	/* if IOs end up waiting for requests, issue less */
 	RQ_WAIT_BUSY_PCT	= 5,
 
@@ -296,9 +301,6 @@ enum {
 	/* don't let cmds which take a very long time pin lagging for too long */
 	MAX_LAGGING_PERIODS	= 10,
 
-	/* switch iff the conditions are met for longer than this */
-	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
-
 	/*
 	 * Count IO size in 4k pages.  The 12bit shift helps keeping
 	 * size-proportional components of cost calculation in closer
-- 
2.39.0

