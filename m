From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/45] writeback, blkcg: propagate non-root blkcg congestion state
Date: Tue,  6 Jan 2015 16:25:48 -0500
Message-ID: <1420579582-8516-12-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=flCz7BTEpmUgXwAUztV39dmO8WwkmhNOnD+eXjbg7i4=;
        b=ek3aNmpi4z9KXleoKBeVqYFMPKQyWBWJ9F32t/Kg+jS5qwEK5RHinDA95nM8fJ+pCN
         jR9h+CcMF+V1x3HeIoM6sQjLxXYgfYJl7h+eAj+ABh/v5wANvATvBDhcufvdGDzteOTD
         pyfsM7b53kQgKu95GDj7f1huRrCOmFBmak+78cB8VsxAfiEFCRijmkcfVKZun+sseJ+W
         t3EWMO3ITLKO7xnhuZ2nEEIAqhbNycJaWIZAT1jWKh1GHDGDx/xi1qH0LZfXM11BfqUG
         Y3VS0Tsr1DkFbBJpEzXHZYR5jgMSSKnKmuvtCVZXfVO2+KP3zmelEGGpgpz6GLNq2qQ7
         f8pA==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

Now that bdi layer can handle per cgwb (cgroup bdi_writeback)
congestion state, blk_{set|clear}_congested() can propagate non-root
blkcg congestion state to them.

This can be easily achieved by disabling the root_rl tests in
blk_{set|clear}_congested().  Note that we still need those tests when
!CONFIG_CGROUP_WRITEBACK as otherwise we'll end up flipping root blkcg
wb's congestion state for events happening on other blkcgs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c9a7d6c..d731f1a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -65,23 +65,26 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void blk_clear_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	clear_wb_congested(rl->blkg->wb, sync);
 #else
-	clear_wb_congested(&rl->q->backing_dev_info.wb, sync);
+	/*
+	 * If !CGROUP_WRITEBACK, all blkg's map to bdi->wb and we shouldn't
+	 * flip its congestion state for events on other blkcgs.
+	 */
+	if (rl == &rl->q->root_rl)
+		clear_wb_congested(&rl->q->backing_dev_info.wb, sync);
 #endif
 }
 
 static void blk_set_congested(struct request_list *rl, int sync)
 {
-	if (rl != &rl->q->root_rl)
-		return;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	set_wb_congested(rl->blkg->wb, sync);
 #else
-	set_wb_congested(&rl->q->backing_dev_info.wb, sync);
+	/* see blk_clear_congested() */
+	if (rl == &rl->q->root_rl)
+		set_wb_congested(&rl->q->backing_dev_info.wb, sync);
 #endif
 }
 
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
