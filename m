From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] block: Use div64_ul instead of do_div
Date: Thu, 18 Nov 2021 03:40:33 +0000
Message-ID: <20211118034033.163550-1-deng.changcheng@zte.com.cn>
References: <20211117010358.158313-1-deng.changcheng@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZzliISo7V8uUVqku+DWJNIL5TjLAAP7mfcGc98fW6A0=;
        b=RPSIL/Dm0fYurjsad/c0q8w5buiL0J62pQPw+GejaPg7nomIQasr4+DbviD0RltvFY
         azOgTDjzXW6oQ06DjBq+cJU5zj1kd0W7jgbSMNPyRJuqnSJoLZWrKJP0i0aXP/sHY4gH
         Zw7g+8FO+V/MARbljaiuJS7mhBYhrvBL/2nyp1m5TzPtbAlz2lnlwDxnmBA4Kfdj7Cc6
         y4xSeP8y/1cpndIpFgDjyY6TSLV5t9XKKOr3W/Xz/pid+2n6aAiovEbhV0H7/yoFe1vU
         rzhm7iPiFGfA6Sr1OPnZ4C4WCbbDxZ+Iu0sQEjAD6x9w7kczgRNMQET7LjHbErEIGfVV
         zgVw==
In-Reply-To: <20211117010358.158313-1-deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

From: Changcheng Deng <deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

do_div() does a 64-by-32 division. Here the divisor is an unsigned long
which on some platforms is 64 bit wide. So use div64_ul instead of do_div
to avoid a possible truncation.

Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: Changcheng Deng <deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
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
+		bps = div64_ul(bps, elapsed_time);
 		if (bps >= tg->bps[READ][LIMIT_LOW])
 			tg->last_low_overflow_time[READ] = now;
 	}
-- 
2.25.1

