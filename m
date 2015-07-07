From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/9] cfq-iosched: minor cleanups
Date: Tue,  7 Jul 2015 11:35:56 -0400
Message-ID: <1436283361-3889-5-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KXitS1RJJsWQt9ZeFzawaTeyS6fq7PNCXSPLCmXunLw=;
        b=Xx+ARt4Fz9rRRpInh84SVj1RPBCk+Ln+tt8syknNavLXps24hnLFV5jtaZO8xstJH/
         sTIQ/kxnOFcEZW8k2qb9a1idmn2piiAA6EGBYezuep7aIBRsDKptkFL4m3FrKXAWQCp5
         zCc1Cpa7aGBjTiwe2yIAD8XRgWyA2Z9ZaZyAOeUHurYxrVP8Hi47xFZTCVWjIUNeORyX
         CllMAHi0glHSalbvCO6IzgXq4lsKPmqGj0KiX1qRIPrNZV6BnX+7YSzCKJ9/duuML3+K
         EqFE4gs9sjxT1em1n+Ti0mvRCQGAmRL4MNC1hBYpa14rg/6AqVbC7Edm5xYT0gteEsH8
         iEVA==
In-Reply-To: <1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

* Some were accessing cic->cfqq[] directly.  Always use cic_to_cfqq()
  and cic_set_cfqq().

* check_ioprio_changed() doesn't need to verify cfq_get_queue()'s
  return for NULL.  It's always non-NULL.  Simplify accordingly.

This patch doesn't cause any functional changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8acfb7a..bf6f49c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3506,14 +3506,14 @@ static void cfq_exit_icq(struct io_cq *icq)
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
 
@@ -3572,18 +3572,14 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
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
2.4.3
