From: chengming.zhou@linux.dev
Subject: [PATCH] blk-iocost: skip empty flush bio in iocost
Date: Thu, 20 Jul 2023 20:14:41 +0800
Message-ID: <20230720121441.1408522-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689855359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1qUoKI3SbOAj4JugO0eFEKpo/XtZkaAZd4jHbDGRCXI=;
        b=UYRVGSJeMWgVT/Cmj35t2ZweiX0f74MUBaOSw4MLtDmMy3IiuQrHv8RU4qRm/+sTXZG3zj
        +eK1+VPGThdCpfSCGWbopKgw5Dw3dyzfnI+h4Dk0lnIiYvGH6rNedI6u3cchFohjzDfaRp
        UtcGfRKuKFeW1oGmtQWsxdDyRcpHit4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, zhouchengming@bytedance.com

From: Chengming Zhou <zhouchengming@bytedance.com>

The flush bio may have data, may have no data (empty flush), we couldn't
calculate cost for empty flush bio. So we'd better just skip it for now.

Another side effect is that empty flush bio's bio_end_sector() is 0, cause
iocg->cursor reset to 0, may break the cost calculation of other bios.

This isn't good enough, since flush bio still consume the device bandwidth,
but flush request is special, can be merged randomly in the flush state
machine, we don't know how to calculate cost for it for now.

Its completion time also has flaws, which may include the pre-flush or
post-flush completion time, but I don't know if we need to fix that and
how to fix it.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 block/blk-iocost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6084a9519883..e735b3e9997c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2516,6 +2516,10 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 	u64 seek_pages = 0;
 	u64 cost = 0;
 
+	/* Can't calculate cost for empty bio */
+	if (!bio->bi_iter.bi_size)
+		goto out;
+
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_RSEQIO];
-- 
2.41.0

