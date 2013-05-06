From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 28/33] blk-throttle: make tg_dispatch_one_bio() ready for hierarchy
Date: Mon,  6 May 2013 15:46:07 -0700
Message-ID: <1367880372-28312-29-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=8Vs2akjdwgibSXEp7I2n/j9bKZ1Rjl0B589NVp5M1L0=;
        b=Ild5uDH5YluTLmDJsjx1zmZK6ln+8/fOyBdh+SQtFcxcEvGUJ2ji3Gb0p6rDZ43O/K
         qb7DCrjfMr74C02i6/d8JKCFhsCC/kR81ECFatuTCwT7qx0/VLogwe2VnuOuhXsFFIEG
         1pBpVTh/McJYIBpOuyyfljRNoXHH7QFUxBi5ALei1AY6VKoOSYb66zowE7jnym2+JyLy
         4Y4OMopoDS3AN8PAGRmZ5UBSWZoClj2yCQGYEsdFKiV8Rv8DqH3xt+Qr2TYhwl+Qdqoi
         8rhouaumBGpz/x6EYpfmhYuaEy2/Yl7gqKBW1iSwUGlX8UG9pejnvV3xkyTzlyGptVkY
         nZjQ==
In-Reply-To: <1367880372-28312-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

tg_dispatch_one_bio() currently assumes that the parent_sq is the top
level one and the bio being dispatched is ready to be issued; however,
this assumption will be wrong with proper hierarchy support.  This
patch makes the following changes to make tg_dispatch_on_bio() ready
for hiearchy.

* throtl_data->nr_queued[] is incremented in blk_throtl_bio() instead
  of throtl_add_bio_tg() so that throtl_add_bio_tg() can be used to
  transfer a bio from a child tg to its parent.

* tg_dispatch_one_bio() is updated to distinguish whether its parent
  is another throtl_grp or the throtl_data.  If former, the bio is
  transferred to the parent throtl_grp using throtl_add_bio_tg().  If
  latter, the bio is ready to be issued and put on the top-level
  service_queue's bio_lists[] and throtl_data->nr_queued is
  decremented.

As all throtl_grps currently have the top level service_queue as their
->parent_sq, this patch in itself doesn't make any behavior
difference.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 52321a4..0420261 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -824,7 +824,6 @@ static void throtl_add_bio_tg(struct bio *bio, struct throtl_grp *tg)
 	/* Take a bio reference on tg */
 	blkg_get(tg_to_blkg(tg));
 	sq->nr_queued[rw]++;
-	tg->td->nr_queued[rw]++;
 	throtl_enqueue_tg(tg);
 }
 
@@ -855,20 +854,34 @@ static void tg_update_disptime(struct throtl_grp *tg)
 static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
+	struct throtl_service_queue *parent_sq = sq->parent_sq;
+	struct throtl_grp *parent_tg = sq_to_tg(parent_sq);
 	struct bio *bio;
 
 	bio = bio_list_pop(&sq->bio_lists[rw]);
 	sq->nr_queued[rw]--;
-	/* Drop bio reference on blkg */
-	blkg_put(tg_to_blkg(tg));
-
-	BUG_ON(tg->td->nr_queued[rw] <= 0);
-	tg->td->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
-	bio_list_add(&sq->parent_sq->bio_lists[rw], bio);
+
+	/*
+	 * If our parent is another tg, we just need to transfer @bio to
+	 * the parent using throtl_add_bio_tg().  If our parent is
+	 * @td->service_queue, @bio is ready to be issued.  Put it on its
+	 * bio_lists[] and decrease total number queued.  The caller is
+	 * responsible for issuing these bios.
+	 */
+	if (parent_tg) {
+		throtl_add_bio_tg(bio, parent_tg);
+	} else {
+		bio_list_add(&parent_sq->bio_lists[rw], bio);
+		BUG_ON(tg->td->nr_queued[rw] <= 0);
+		tg->td->nr_queued[rw]--;
+	}
 
 	throtl_trim_slice(tg, rw);
+
+	/* @bio is transferred to parent, drop its blkg reference */
+	blkg_put(tg_to_blkg(tg));
 }
 
 static int throtl_dispatch_tg(struct throtl_grp *tg)
@@ -1283,6 +1296,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		   sq->nr_queued[READ], sq->nr_queued[WRITE]);
 
 	bio_associate_current(bio);
+	tg->td->nr_queued[rw]++;
 	throtl_add_bio_tg(bio, tg);
 	throttled = true;
 
-- 
1.8.1.4
