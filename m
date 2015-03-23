From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 45/48] writeback: dirty inodes against their matching cgroup bdi_writeback's
Date: Mon, 23 Mar 2015 00:54:56 -0400
Message-ID: <1427086499-15657-46-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1I5WODSgsTiufuzWClWw/QDIgOTx81ZAvA1Wn62JAhY=;
        b=hEvBM26ua2evH1aUK4ALq3XBhz7vGMwoR29C4xM4A4A1f1ogSrxMyXEldWYZy9g97V
         Ql7a0Im4nJuVEkycIqSfTTEOqyodcLX97MDjdbdVxAV/SnhChemweTRx3EzRSnyQQciX
         ccM1m3oL8NUV3h9JK6Ize6DTUmscfB2PKplAim9J2JSEV0XMjVC8FMlXHQpti7ITer1x
         ox7qCdzemhYa3sEsQ0M4g9lDeZHZmFZTaQY+SkeomzakDsq+LK2lgKjFiNpvOkS2OeS6
         Ck6/2gk6iy3LbW7RrPuW4A3owMUVDzEYrnfaQoJ+n1rza6GGjEiNnZ9fjV+7V3MLWT12
         cyzA==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

__mark_inode_dirty() always dirtied the inode against the root wb
(bdi_writeback).  The previous patches added all the infrastructure
necessary to attribute an inode against the wb of the dirtying cgroup.

This patch updates __mark_inode_dirty() so that it uses the wb
associated with the inode instead of unconditionally using the root
one.

Currently, none of the filesystems has FS_CGROUP_WRITEBACK and all
pages will keep being dirtied against the root wb.

v2: Updated for per-inode wb association.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 57b2282..890cff1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1442,7 +1442,6 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = NULL;
 	int dirtytime;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
@@ -1512,21 +1511,21 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			struct bdi_writeback *wb = inode_to_wb(inode);
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
 
 			inode->dirtied_when = jiffies;
-			wakeup_bdi = inode_wb_list_move_locked(inode, &bdi->wb,
-					dirtytime ? &bdi->wb.b_dirty_time :
-						    &bdi->wb.b_dirty);
-			spin_unlock(&bdi->wb.list_lock);
+			wakeup_bdi = inode_wb_list_move_locked(inode, wb,
+					dirtytime ? &wb->b_dirty_time :
+						    &wb->b_dirty);
+			spin_unlock(&wb->list_lock);
 			trace_writeback_dirty_inode_enqueue(inode);
 
 			/*
@@ -1535,8 +1534,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
