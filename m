From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 48/51] writeback: dirty inodes against their matching cgroup bdi_writeback's
Date: Fri, 22 May 2015 17:14:02 -0400
Message-ID: <1432329245-5844-49-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=15MEOM9pTxYUmXECC/OWmNKtRso9Cus40rPNw2F/6Wc=;
        b=eQYo62sS5scNvs57wWIQ5z7IBuUfyPcczyEMUDbctQURaLjEZjowshWEkwBy/PQuMg
         Y8Yt5Qal22m8Rl5C7mlJqekYmxF5w5CQvZQNz5xwbcg+zB+te2UIKU9gilUuOeCnnMm1
         MvoD6dEAqKEQe9eiCjDSGOsk+jdr7N/uDc177CqT84N54M/pj3upXF9GNxeljNyquVVY
         C43RAcU/NH+EqI7wjRihY2R9rha8jHeFRx5xll+LwrRwjfaPADemfe9Dq6pHu/bm97kg
         1037INgHZh9PrXIDBMvDnjhPZOy/pO5Wq4FAKuU4WFMv7mV9/9FIc9ZwaU6IIeGyQfwm
         85zg==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

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
index 59d76f6..881ea5d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1504,7 +1504,6 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = NULL;
 	int dirtytime;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
@@ -1574,30 +1573,30 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
+			struct bdi_writeback *wb = inode_to_wb(inode);
 			struct list_head *dirty_list;
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
 			if (dirtytime)
 				inode->dirtied_time_when = jiffies;
 
 			if (inode->i_state & (I_DIRTY_INODE | I_DIRTY_PAGES))
-				dirty_list = &bdi->wb.b_dirty;
+				dirty_list = &wb->b_dirty;
 			else
-				dirty_list = &bdi->wb.b_dirty_time;
+				dirty_list = &wb->b_dirty_time;
 
-			wakeup_bdi = inode_wb_list_move_locked(inode, &bdi->wb,
+			wakeup_bdi = inode_wb_list_move_locked(inode, wb,
 							       dirty_list);
 
-			spin_unlock(&bdi->wb.list_lock);
+			spin_unlock(&wb->list_lock);
 			trace_writeback_dirty_inode_enqueue(inode);
 
 			/*
@@ -1606,8 +1605,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
2.4.0
