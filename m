From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] blkcg: shoot down blkgs if all policies are deactivated
Date: Fri, 13 Apr 2012 13:11:35 -0700
Message-ID: <1334347895-6268-12-git-send-email-tj@kernel.org>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=ThtmEAa9uk2lKCDOIkudYmfK85r/0t8XYW1q/6VHD+0=;
        b=g+XllOA4UO725qT0oCtRY+CrLFnlrauUJefYAeXvtSoJSn9L6t9w4kxJDHbcSxv2ov
         UMptrW4FYAb2DjNiQEm6rSyWZdpcSHhfopsXCzgMl6lpXWg372MyKLkY/z5GrqZyq+Nd
         DHpL/AY3rPrJj5gMuNL3BfdG9JxDJiv07v061UFyjjwmLp/gHaH7/z0RmqcHKRxl6lzU
         1l5GqeSfA1S15ce0kAzHDYTD8fDsVDvr83PMtEkd0izoA9Z0rAQ50OAYNRi0A0ef9SiI
         609HTAjy93B+w5UkjcihQ+xbL/+LCoD1bJTU2NF/7bXWZW12mlttAEbOozA1BcNB57sS
         ItXQ==
In-Reply-To: <1334347895-6268-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, Tejun Heo <tj@kernel.org>

There's no reason to keep blkgs around if no policy is activated for
the queue.  This patch moves queue locking out of blkg_destroy_all()
and call it from blkg_deactivate_policy() on deactivation of the last
policy on the queue.

This change was suggested by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 10f0d2f..b1807d4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -258,7 +258,7 @@ static void blkg_destroy_all(struct request_queue *q)
 {
 	struct blkio_group *blkg, *n;
 
-	spin_lock_irq(q->queue_lock);
+	lockdep_assert_held(q->queue_lock);
 
 	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
 		struct blkio_cgroup *blkcg = blkg->blkcg;
@@ -267,8 +267,6 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
-
-	spin_unlock_irq(q->queue_lock);
 }
 
 static void blkg_rcu_free(struct rcu_head *rcu_head)
@@ -646,7 +644,10 @@ void blkcg_drain_queue(struct request_queue *q)
  */
 void blkcg_exit_queue(struct request_queue *q)
 {
+	spin_lock_irq(q->queue_lock);
 	blkg_destroy_all(q);
+	spin_unlock_irq(q->queue_lock);
+
 	blk_throtl_exit(q);
 }
 
@@ -802,6 +803,10 @@ void blkcg_deactivate_policy(struct request_queue *q,
 
 	__clear_bit(pol->plid, q->blkcg_pols);
 
+	/* if no policy is left, no need for blkgs - shoot them down */
+	if (bitmap_empty(q->blkcg_pols, BLKCG_MAX_POLS))
+		blkg_destroy_all(q);
+
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		/* grab blkcg lock too while removing @pd from @blkg */
 		spin_lock(&blkg->blkcg->lock);
-- 
1.7.7.3
