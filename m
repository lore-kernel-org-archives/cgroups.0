From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 27/48] writeback, blkcg: propagate non-root blkcg congestion state
Date: Mon, 23 Mar 2015 00:54:38 -0400
Message-ID: <1427086499-15657-28-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eZUjCGIC0NMGaZPwzrArbcgMoDGRLA3NkyicuPGgU5g=;
        b=ZP1wdgViJ5wjzHv9ZyVVYB0oksXX3CEQszf/vSQla8A3IsmDtOvEV7ygQNxpzcyEQx
         N2H1VRko6Gq06Tdh3L8ukCrcrxnNK7gbo8RJ6vbkxCZX7RDkclI3Jj/4IHFr+BbUzkn0
         RRzfhNLxZR3Hg5jDykqqAA+DD4q5NwA604OjKgXz8RnnS66go4eCkEFnEJ67fUszIraC
         ipJCWlYRVRUesyBVegiuqmiMUit93IoGCrlNMzKEogJki1ssukvjaB7UQruraaAw1WQd
         OFQ5azfsswyjvESRAk1SUpgYwY+wgDObFcHyXAINGLSkLqPk4hnSIJumGS/Y8IU65tiw
         M4MA==
In-Reply-To: <1427086499-15657-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Now that bdi layer can handle per-blkcg bdi_writeback_congested state,
blk_{set|clear}_congested() can propagate non-root blkcg congestion
state to them.

This can be easily achieved by disabling the root_rl tests in
blk_{set|clear}_congested().  Note that we still need those tests when
!CONFIG_CGROUP_WRITEBACK as otherwise we'll end up flipping root blkcg
wb's congestion state for events happening on other blkcgs.

v2: Updated for bdi_writeback_congested.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
