From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 46/49] writeback: dirty inodes against their matching cgroup bdi_writeback's
Date: Mon,  6 Apr 2015 15:58:35 -0400
Message-ID: <1428350318-8215-47-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a/gtImffkfSJWdkS3RIWvK7eD/Re6jYn7iClUgg4vpo=;
        b=Oi+pvTENpHs2GoqOucRFbQL2jhXBzZd/UDHFAj9nqmBMB4hBH3PQCAox1yaaMLlwS9
         EX7q9+hTjC4QTu3gYhuS4H27YmyA5Nhidamupd5founpPNAWVZOvWSHCLZmOwVr5gXjr
         HGY+VYvtSgSWHEL70obCHya7dEj5HZ7V2Yz/2PAo3R8Fie9zWdRoyRqzxHiYuYvKVNvY
         IyRnplPw+D0BgdBty1XUbyz2goih/vRQVzThCZA2hljXHXqheZUCODLLJ4oR9gYb3+ST
         ljqYZqA2IwC2F5Ufskpf9NePjVpy/N2ejVn5cKhh8MDReAeocaRtstP3y4kxZHQh+8tB
         /NnQ==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
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
index 9f42c14..2b9c82b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1432,7 +1432,6 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = NULL;
 	int dirtytime;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
@@ -1502,21 +1501,21 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
@@ -1525,8 +1524,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
