From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/31] blk-throttle: remove spurious throtl_enqueue_tg() call from throtl_select_dispatch()
Date: Wed,  1 May 2013 17:39:24 -0700
Message-ID: <1367455189-6957-7-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=DDNupDLiQGdr0igBraZLcoPklNvyf6LheD1MuhyGCA0=;
        b=VMS3rvgRjlByDYxRLIfGOOZu0CnRJJ+p9yDXYRba/8MONdWJ1ibhWk1f8Tkn7TA9Iv
         mpG+yI4P2mlK6T0Og2Dv+nzV81ENAMKf8FTA+9JBU1MS9rQPGHF4uSqcf754XrhW5Nr6
         ADcpXDfreLuMrTJtkUmxpGl5FGoJIdkvafN8A73SHuSfKD2CeXbzxHXGP+6I3LY/acMJ
         dY+5GBulA+rdzy96YztDw1dD7R60lNiF6sw07kocxrqFCgneJkuLvEVssiEAoHGhaUaH
         b4lrbFRZdGLbr8EDjoX/q1FIaRuicCpnqDO0O8s5tYCDvqxB6xf/xQDWTa2pTC5qpkw+
         /nnQ==
In-Reply-To: <1367455189-6957-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

throtl_select_dispatch() calls throtl_enqueue_tg() right after
tg_update_disptime(), which always calls the function anyway.  The
call is, while harmless, unnecessary.  Remove it.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3114622..3960787 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -816,10 +816,8 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 
 		nr_disp += throtl_dispatch_tg(td, tg, bl);
 
-		if (tg->nr_queued[0] || tg->nr_queued[1]) {
+		if (tg->nr_queued[0] || tg->nr_queued[1])
 			tg_update_disptime(td, tg);
-			throtl_enqueue_tg(td, tg);
-		}
 
 		if (nr_disp >= throtl_quantum)
 			break;
-- 
1.8.1.4
