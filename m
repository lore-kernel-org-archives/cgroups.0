From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/31] blk-throttle: set REQ_THROTTLED from throtl_charge_bio() and gate stats update with it
Date: Wed,  1 May 2013 17:39:40 -0700
Message-ID: <1367455189-6957-23-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=oaHL0NbgqEffdKgvJpsXBlBuFOFYWIX/fbJUjoL8hXM=;
        b=FrxyLa8tcLpnxxGQ98Oia/xQu37TgFeOX9BylrT+t7iigJyzeod5n7CqL7wXTkRTeL
         M7Zug6zHFeSxEfhC5RVwPexjfuT8ERzqNzypNDuBpg0qZHmC38+ltLq7LlFWetxyTkCJ
         K1MvTY22XgAmTwIegT5IWXwk+J5zy6nJxCWHWqlClDz1H/kI+TBEwD/R/LCGrRHW6FVk
         rKggUazInZ1FvqwO0qaWyZm9ONT8KyUj+fiyOZYhyZdfK6IpjrQAB3qB6Fx7FOoabIgY
         /ul5KNs+awIX7a3TXOJCLfAGEXDu9ViM9ekU2G94RP5WhlYQoqvo7HujaxQWXozFjb7I
         vM3g==
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

With proper hierarchy support, a bio can be dispatched multiple times
until it reaches the top-level service_queue and we don't want to
update dispatch stats at each step.  They are local stats and will be
kept local.  If recursive stats are necessary, they should be
implemented separately and definitely not by updating counters
recursively on each dispatch.

This patch moves REQ_THROTTLED setting to throtl_charge_bio() and gate
stats update with it so that dispatch stats are updated only on the
first time the bio is charged to a throtl_grp, which will always be
the throtl_grp the bio was originally queued to.

This means that REQ_THROTTLED would be set even for bios which don't
get throttled.  As we don't want bios to leave blk-throtl with the
flag set, move REQ_THROTLLED clearing to the end of blk_throtl_bio()
and clear if the bio is being issued directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9bbe312..7f8ca43 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -754,7 +754,22 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
+	/*
+	 * REQ_THROTTLED is used to prevent the same bio to be throttled
+	 * more than once as a throttled bio will go through blk-throtl the
+	 * second time when it eventually gets issued.  Set it when a bio
+	 * is being charged to a tg.
+	 *
+	 * Dispatch stats aren't recursive and each @bio should only be
+	 * accounted by the @tg it was originally associated with.  Let's
+	 * update the stats when setting REQ_THROTTLED for the first time
+	 * which is guaranteed to be for the @bio's original tg.
+	 */
+	if (!(bio->bi_rw & REQ_THROTTLED)) {
+		bio->bi_rw |= REQ_THROTTLED;
+		throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size,
+					     bio->bi_rw);
+	}
 }
 
 static void throtl_add_bio_tg(struct bio *bio, struct throtl_grp *tg)
@@ -818,7 +833,6 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 
 	throtl_charge_bio(tg, bio);
 	bio_list_add(&sq->parent_sq->bio_lists[rw], bio);
-	bio->bi_rw |= REQ_THROTTLED;
 
 	throtl_trim_slice(tg, rw);
 }
@@ -1128,10 +1142,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	struct blkcg *blkcg;
 	bool throttled = false;
 
-	if (bio->bi_rw & REQ_THROTTLED) {
-		bio->bi_rw &= ~REQ_THROTTLED;
+	/* see throtl_charge_bio() */
+	if (bio->bi_rw & REQ_THROTTLED)
 		goto out;
-	}
 
 	/*
 	 * A throtl_grp pointer retrieved under rcu can be used to access
@@ -1205,6 +1218,13 @@ out_unlock:
 out_unlock_rcu:
 	rcu_read_unlock();
 out:
+	/*
+	 * As multiple blk-throtls may stack in the same issue path, we
+	 * don't want bios to leave with the flag set.  Clear the flag if
+	 * being issued.
+	 */
+	if (!throttled)
+		bio->bi_rw &= ~REQ_THROTTLED;
 	return throttled;
 }
 
-- 
1.8.1.4
