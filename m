From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/8] cfq-iosched: minor cleanups
Date: Mon,  8 Jun 2015 17:59:29 +0900
Message-ID: <1433753973-23684-5-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fNXWGxKtpzHTg03OTsCGvvdNEnsvXaCAicJAvaFcwPI=;
        b=rd2QnuUkD5hUKntiYLCBh1A9sUPXHdwf5aqWggzWjH5EIjPSQtUCqErvTjAiVl2e+Q
         GDRwdFXIjayKyFbTmXI3wYkCfOFppzRLZqEkx6hFuxPnjPz3OL36MAw+0ZIlGprFT4v1
         OZA26gSsbwlyJaTidn6HSO3xk7I8UrIH4oF8T0n5sWC9uUMzJmczWjAQOaSV9XuLn2v1
         IMCvXVoVuA1StbXSmHb4K4Bes4iUyn7as7jiUE/Lwn0NuZ6VifPsbkCekWAV+NEcolZh
         1gwstN1ua80R9/mEco7U2aRnladp/oBAbyfzdzEmE9wZQThcGrBN1KnA/ovmot//7bka
         LBOQ==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

* Some were accessing cic->cfqq[] directly.  Always use cic_to_cfqq()
  and cic_set_cfqq().

* check_ioprio_changed() doesn't need to verify cfq_get_queue()'s
  return for NULL.  It's always non-NULL.  Simplify accordingly.

This patch doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e0a34ba..90d5a87 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3438,14 +3438,14 @@ static void cfq_exit_icq(struct io_cq *icq)
 	struct cfq_io_cq *cic = icq_to_cic(icq);
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 
-	if (cic->cfqq[BLK_RW_ASYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
-		cic->cfqq[BLK_RW_ASYNC] = NULL;
+	if (cic_to_cfqq(cic, false)) {
+		cfq_exit_cfqq(cfqd, cic_to_cfqq(cic, false));
+		cic_set_cfqq(cic, NULL, false);
 	}
 
-	if (cic->cfqq[BLK_RW_SYNC]) {
-		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_SYNC]);
-		cic->cfqq[BLK_RW_SYNC] = NULL;
+	if (cic_to_cfqq(cic, true)) {
+		cfq_exit_cfqq(cfqd, cic_to_cfqq(cic, true));
+		cic_set_cfqq(cic, NULL, true);
 	}
 }
 
@@ -3504,18 +3504,14 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 	if (unlikely(!cfqd) || likely(cic->ioprio == ioprio))
 		return;
 
-	cfqq = cic->cfqq[BLK_RW_ASYNC];
+	cfqq = cic_to_cfqq(cic, false);
 	if (cfqq) {
-		struct cfq_queue *new_cfqq;
-		new_cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio,
-					 GFP_ATOMIC);
-		if (new_cfqq) {
-			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
-			cfq_put_queue(cfqq);
-		}
+		cfq_put_queue(cfqq);
+		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_ATOMIC);
+		cic_set_cfqq(cic, cfqq, false);
 	}
 
-	cfqq = cic->cfqq[BLK_RW_SYNC];
+	cfqq = cic_to_cfqq(cic, true);
 	if (cfqq)
 		cfq_mark_cfqq_prio_changed(cfqq);
 
-- 
2.4.2
