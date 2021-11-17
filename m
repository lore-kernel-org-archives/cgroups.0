From: cgel.zte@gmail.com
Subject: [PATCH] block: Use div64_ul instead of do_div
Date: Wed, 17 Nov 2021 01:03:58 +0000
Message-ID: <20211117010358.158313-1-deng.changcheng@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PLz5baL/tForuA6NLmg8XFMsVJ3OJ6G5avfxPN9wfAY=;
        b=CkHizIwo5OxrH6SXMtbFaBo3rxwHUxfjaYQqiQXz2DG4k37ZPaiTMLniKDmBOEYATR
         m3NFrhQCYldaZCZRLdM++qdG+mkLTik41OH67xg1jaWt3Gz8jH2zkJqAXcUoLuPpJNwr
         a7+Iq2UkHkQAANfQ5gvMuaCvpIPB5LbL0b51sVBNMdnBDjbIoEB0ujCNjNhF/FCTBoLq
         aSQ+OS81elts5Tre9UNFtGkR9+gcmDWlcMaVmFd9EYWtsodEyX740N7WRAOPsrRcx/BV
         f+Jr0PYJwF3Z3NzFAWp1mwRjsMB0/ei2In+9mI79i3swOtidWcCeWFU4eyERo0mJHkWe
         dSNg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Changcheng Deng <deng.changcheng@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>

From: Changcheng Deng <deng.changcheng@zte.com.cn>

do_div() does a 64-by-32 division. If the divisor is unsigned long, using
div64_ul can avoid truncation to 32-bit.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e68a9a2..2db635d66617 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1903,7 +1903,7 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 
 	if (tg->bps[READ][LIMIT_LOW]) {
 		bps = tg->last_bytes_disp[READ] * HZ;
-		do_div(bps, elapsed_time);
+		div64_ul(bps, elapsed_time);
 		if (bps >= tg->bps[READ][LIMIT_LOW])
 			tg->last_low_overflow_time[READ] = now;
 	}
-- 
2.25.1

