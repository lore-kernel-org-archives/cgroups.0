From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 36/45] writeback: dirty inodes against their matching cgroup bdi_writeback's
Date: Tue,  6 Jan 2015 16:26:13 -0500
Message-ID: <1420579582-8516-37-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TL4o8FQFetAFd2prggY1xLSeDHFsN+kGsYEBcTDDLFQ=;
        b=sRhruNOhwIDOCt4KEoe7CalME8Jn9Ubp8Q5s3XXqh2/ciaKzeKpjUlghVhqbMBegGf
         aUfF1Eum5YC76YofvxPX7NaubnNZaWw62mW3VL0B3b/byL5u1ph9dRj89ra0zzROMmoz
         xhg6+2Jk+0VPLdTuVAdRA1tg/ecvgjqBAYuhiVaJH+eNEetQKvh1qZ6pNrRFvPcLlaGu
         XLvf9RRMP6PdARfL8otF95607YgsRHU+zPqarz/mNuVaxEnHc5oGkDvDJEN7isEMdyqw
         Ypjs5s4Um0kwH7DZq6S5FBoBvQneVP08EspsLOq9U7ygXf2Kvc+DOWKIZIuy0bK06GQd
         PsVQ==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

mark_inode_dirty_dctx() always dirtied the inode against the root wb
(bdi_writeback).  The previous patches added all the infrastructure
necessary to attribute an inode against the wb of the dirtying cgroup.

On entry to mark_inode_dirty_dctx(), @dctx now carries the matching wb
and iwbl (inode_wb_link).  This patch updates mark_inode_dirty_dctx()
so that it uses the wb and iwbl from @dctx instead of unconditionally
using the root ones.

Currently, none of the filesystems has FS_CGROUP_WRITEBACK and all
pages will keep being dirtied against the root wb.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index df99b5b..dfcf5dd 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1734,8 +1734,9 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void mark_inode_dirty_dctx(struct dirty_context *dctx, int flags)
 {
 	struct inode *inode = dctx->inode;
+	struct inode_wb_link *iwbl = dctx->iwbl;
+	struct bdi_writeback *wb = dctx->wb;
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = NULL;
 
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
@@ -1764,7 +1765,6 @@ void mark_inode_dirty_dctx(struct dirty_context *dctx, int flags)
 
 	spin_lock(&inode->i_lock);
 	if ((inode->i_state & flags) != flags) {
-		struct inode_wb_link *iwbl = &inode->i_wb_link;
 		const int was_dirty = inode->i_state & I_DIRTY;
 
 		inode->i_state |= flags;
@@ -1794,19 +1794,17 @@ void mark_inode_dirty_dctx(struct dirty_context *dctx, int flags)
 		 */
 		if (!was_dirty) {
 			bool wakeup_bdi = false;
-			bdi = inode_to_bdi(inode);
 
 			spin_unlock(&inode->i_lock);
-			spin_lock(&bdi->wb.list_lock);
+			spin_lock(&wb->list_lock);
 
-			WARN(bdi_cap_writeback_dirty(bdi) &&
-			     !test_bit(WB_registered, &bdi->wb.state),
-			     "bdi-%s not registered\n", bdi->name);
+			WARN(bdi_cap_writeback_dirty(wb->bdi) &&
+			     !test_bit(WB_registered, &wb->state),
+			     "bdi-%s not registered\n", wb->bdi->name);
 
 			iwbl->dirtied_when = jiffies;
-			wakeup_bdi = iwbl_move_locked(iwbl, &bdi->wb,
-						      &bdi->wb.b_dirty);
-			spin_unlock(&bdi->wb.list_lock);
+			wakeup_bdi = iwbl_move_locked(iwbl, wb, &wb->b_dirty);
+			spin_unlock(&wb->list_lock);
 
 			/*
 			 * If this is the first dirty inode for this bdi,
@@ -1814,8 +1812,8 @@ void mark_inode_dirty_dctx(struct dirty_context *dctx, int flags)
 			 * to make sure background write-back happens
 			 * later.
 			 */
-			if (bdi_cap_writeback_dirty(bdi) && wakeup_bdi)
-				wb_wakeup_delayed(&bdi->wb);
+			if (bdi_cap_writeback_dirty(wb->bdi) && wakeup_bdi)
+				wb_wakeup_delayed(wb);
 			return;
 		}
 	}
-- 
2.1.0
