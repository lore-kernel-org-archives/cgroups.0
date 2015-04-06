From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/49] writeback, blkcg: propagate non-root blkcg congestion state
Date: Mon,  6 Apr 2015 15:58:17 -0400
Message-ID: <1428350318-8215-29-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eZUjCGIC0NMGaZPwzrArbcgMoDGRLA3NkyicuPGgU5g=;
        b=P3UdVqle8etyd7ntSs3a7W2bUDKRci3P0bevbuS+KS/mfbqG68d9eG2zULOWHwQAEw
         NK44KqjjP8K7bZUK7LayRBm1FR8Ykc+hbjCgoNVGce9K/K3LM3FgJENUzeZvRDKL6glX
         gbeQF1RJM1JfSPHFjZojeEmqG13CEf3XTy497A6cjIttKVKN2wHV8D5FWh2L8LLWIo7L
         KoRprByI+twIjlyu7gVso1+ySEVCQAAoMGk1eQ2CWOkshSSVYZt65WCSUTJDBLVQxAp6
         qm1ndRZ7Bv/y+r2Tebz8XtAFsKoszSRkwleBq5Rhl4CyczzytZGbVz7C+yUF1xtnDGrJ
         RKgA==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Now that bdi layer can handle per-blkcg bdi_writeback_congested state,
blk_{set|clear}_congested() can propagate non-root blkcg congestion
state to them.

This can be easily achieved by disabling the root_rl tests in
blk_{set|clear}_congested().  Note that we still need those tests when
!CONFIG_CGROUP_WRITEBACK as otherwise we'll end up flipping root blkcg
wb's congestion state for events happening on other blkcgs.

v2: Updated for bdi_writeback_congested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cad26e3..95488fb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -65,23 +65,26 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void blk_clear_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	clear_wb_congested(rl->blkg->wb_congested, sync);
 #else
-	clear_wb_congested(rl->q->backing_dev_info.wb.congested, sync);
+	/*
+	 * If !CGROUP_WRITEBACK, all blkg's map to bdi->wb and we shouldn't
+	 * flip its congestion state for events on other blkcgs.
+	 */
+	if (rl == &rl->q->root_rl)
+		clear_wb_congested(rl->q->backing_dev_info.wb.congested, sync);
 #endif
 }
 
 static void blk_set_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	set_wb_congested(rl->blkg->wb_congested, sync);
 #else
-	set_wb_congested(rl->q->backing_dev_info.wb.congested, sync);
+	/* see blk_clear_congested() */
+	if (rl == &rl->q->root_rl)
+		set_wb_congested(rl->q->backing_dev_info.wb.congested, sync);
 #endif
 }
 
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
