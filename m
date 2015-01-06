From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/45] writeback: implement backing_dev_info->tot_write_bandwidth
Date: Tue,  6 Jan 2015 16:25:51 -0500
Message-ID: <1420579582-8516-15-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ch3HxYkjpYRfvsn+9sLAl9uBY7JIwuI8Ss7zHu2dv8E=;
        b=yGaDxi/hUppGOScyya2F1Xpu9+TIM5D0LisbDA6BNFmkOSdGVpZfzUrbF9HEUQaq3g
         GV41p5bSqFuKW/Gn01UakafGSfST1lg3lY8TNMPirGo26MATVQc6VuoBiKhSHZ38s1ci
         d9GSSO8OlfWwktj7kX7wsa3wm07rYABk7OuoHzldiTEQTrzdbVfKZ+e9LYILbHm1KT1Y
         ulOaagonZEFcVQCrIGb+Xg3i5of2SJaD8Zy/zGEmFZNyJfY7XiW0zohMGsycxG7/pLqV
         BOtvp+H4BJ4rFlb7c/WFDMibSrq3JaRiB9BHnbuGT4vJ8ES+WEToO0lbbp52ZmlVLFnt
         MMdg==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

cgroup writeback support needs to keep track of the sum of
avg_write_bandwidth of all wb's (bdi_writeback's) with dirty inodes to
distribute write workload.  This patch adds bdi->tot_write_bandwidth
and updates inode_wb_list_move_locked(), inode_wb_list_del_locked()
and wb_update_write_bandwidth() to adjust it as wb's gain and lose
dirty inodes and its avg_write_bandwidth gets updated.

As the update events are not synchronized with each other,
bdi->tot_write_bandwidth is an atomic_long_t.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c                | 7 ++++++-
 include/linux/backing-dev-defs.h | 2 ++
 mm/page-writeback.c              | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1718f5f..d41728b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -312,6 +312,8 @@ static bool inode_wb_list_move_locked(struct inode *inode,
 		return false;
 	} else {
 		set_bit(WB_has_dirty_io, &wb->state);
+		atomic_long_add(wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
 		return true;
 	}
 }
@@ -332,8 +334,11 @@ static void inode_wb_list_del_locked(struct inode *inode,
 	list_del_init(&inode->i_wb_list);
 
 	if (wb_has_dirty_io(wb) && list_empty(&wb->b_dirty) &&
-	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io))
+	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io)) {
 		clear_bit(WB_has_dirty_io, &wb->state);
+		atomic_long_sub(wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
+	}
 }
 
 /*
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index d1c0bf4..e1f5f08 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -100,6 +100,8 @@ struct backing_dev_info {
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
+	atomic_long_t tot_write_bandwidth; /* sum of active avg_write_bw */
+
 	struct bdi_writeback wb; /* the root writeback info for this bdi */
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct radix_tree_root cgwb_tree; /* radix tree of !root cgroup wbs */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index b115a57..176d0fb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -879,6 +879,9 @@ static void wb_update_write_bandwidth(struct bdi_writeback *wb,
 		avg += (old - avg) >> 3;
 
 out:
+	if (wb_has_dirty_io(wb))
+		atomic_long_add(avg - wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
 	wb->write_bandwidth = bw;
 	wb->avg_write_bandwidth = avg;
 }
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
