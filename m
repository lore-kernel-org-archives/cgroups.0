From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] blk-iocost: don't make all constants unsigned long long
Date: Tue, 20 Dec 2022 21:18:19 +0100
Message-ID: <20221220201819.1497577-1-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>

My shiny new compiler (GCC 13) is reporting the following
warnings:

  ../block/blk-iocost.c: In function 'ioc_weight_prfill':
  ../block/blk-iocost.c:3035:37: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int' [-Wformat=]
   3035 |                 seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
        |                                    ~^            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                     |                             |
        |                                     unsigned int                  long unsigned int
        |                                    %lu
  ../block/blk-iocost.c: In function 'ioc_weight_show':
  ../block/blk-iocost.c:3045:34: warning: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int' [-Wformat=]
   3045 |         seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
        |                                 ~^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                  |                      |
        |                                  unsigned int           long unsigned int
        |                                 %lu

It appears WEIGHT_ONE enum is unnecessarly unsigned long
(or unsigned long long on 32bit) because of VTIME_PER_SEC
and/or AUTOP_CYCLE_NSEC need the enum to be that large.

Addressed by lazy splitting the "catch all" anonymous
enum and placing the unsigned long long constants in
their own anonymous enums.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 block/blk-iocost.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 495396425bad..bb1f8522c0f1 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -232,7 +232,9 @@ enum {
 
 	/* 1/64k is granular enough and can easily be handled w/ u32 */
 	WEIGHT_ONE		= 1 << 16,
+};
 
+enum {
 	/*
 	 * As vtime is used to calculate the cost of each IO, it needs to
 	 * be fairly high precision.  For example, it should be able to
@@ -255,7 +257,9 @@ enum {
 
 	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
 	VRATE_CLAMP_ADJ_PCT	= 4,
+};
 
+enum {
 	/* if IOs end up waiting for requests, issue less */
 	RQ_WAIT_BUSY_PCT	= 5,
 
@@ -293,10 +297,14 @@ enum {
 
 	/* don't let cmds which take a very long time pin lagging for too long */
 	MAX_LAGGING_PERIODS	= 10,
+};
 
+enum {
 	/* switch iff the conditions are met for longer than this */
 	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
+};
 
+enum {
 	/*
 	 * Count IO size in 4k pages.  The 12bit shift helps keeping
 	 * size-proportional components of cost calculation in closer
-- 
2.37.2

