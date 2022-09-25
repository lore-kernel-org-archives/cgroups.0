From: Elijah Conners <business@elijahpepe.com>
Subject: [PATCH] blk-iocost: explicitly declare long in seq_printf
Date: Sun, 25 Sep 2022 13:43:36 -0700
Message-ID: <18376641f12.db248b2f186661.4401757561282192350@elijahpepe.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: axboe <axboe@kernel.dk>
Cc: tj <tj@kernel.org>, newella <newella@fb.com>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

On lines 3038 and 3048, seq_printf() is used with iocg->cfg_weight /
WEIGHT_ONE. This operation is a long, not an unsigned int, so the usage
of %u in this printf() function is unusual. While C will automatically
promote iocg->cfg_weight / WEIGHT_ONE to an unsigned int—and safely—it
is ultimately better to tell seq_printf() that this is a long.

Signed-off-by: Elijah Conners <business@elijahpepe.com>
---
 block/blk-iocost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7936e5f5821c..78aae116793e 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3035,7 +3035,7 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 
 	if (dname && iocg->cfg_weight)
-		seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
+		seq_printf(sf, "%s %ld\n", dname, iocg->cfg_weight / WEIGHT_ONE);
 	return 0;
 }
 
@@ -3045,7 +3045,7 @@ static int ioc_weight_show(struct seq_file *sf, void *v)
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
 	struct ioc_cgrp *iocc = blkcg_to_iocc(blkcg);
 
-	seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
+	seq_printf(sf, "default %ld\n", iocc->dfl_weight / WEIGHT_ONE);
 	blkcg_print_blkgs(sf, blkcg, ioc_weight_prfill,
 			  &blkcg_policy_iocost, seq_cft(sf)->private, false);
 	return 0;
-- 
2.29.2.windows.2
