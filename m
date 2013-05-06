From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/33] blk-throttle: remove spurious throtl_enqueue_tg() call
	from throtl_select_dispatch()
Date: Mon,  6 May 2013 15:45:45 -0700
Message-ID: <1367880372-28312-7-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
	:in-reply-to:references;
	bh=DDNupDLiQGdr0igBraZLcoPklNvyf6LheD1MuhyGCA0=;
	b=GcnOX4JQTjnTjjaeD9jxUzOMu3RFa1rtHu8+lrjsYyjjM8APwWoA+lNWYOdFVq0lAm
	c/m80S0w5mhQmkrFw23ukBOXSQKs1Ie2pfg9RZVAeNv8RgLfl6CZMcKmp56LiXOhgcOR
	gTvyucW0+o/j39X6oyZqHtcwgoLn305mpIrWKQSj9bakvFewDnn6HM3OHpWf+yYj03XM
	DOrYbu752Fbr3SdwJSrmXa1XzkKrz9ygqfMbgfUj776SUZ1goJb6AVMNTshiSCE0XBY3
	9A+frUQPgON5dJXgmOL0o16n6Byzq9FtvRd0k3tpLq+bqme1hFIl4UWU4c0NjXBU5YOW
	lUlQ==
In-Reply-To: <1367880372-28312-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

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
