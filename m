From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 30/48] writeback: implement backing_dev_info->tot_write_bandwidth
Date: Mon, 23 Mar 2015 00:54:41 -0400
Message-ID: <1427086499-15657-31-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oDSpXsekiYYm9TFqHQf7q23FvMqqKh2t3c5h1CHPSSM=;
        b=1IphRxndjnNE1lVlSNmocCXtHWuLIcG7AxZBaMuGXS6eNSQBqULvPBky1k5fLxVOFB
         +HqMStWQQHEW0VbP2J+ghu49FCihSsefYSC/cbLdfiMzF4sNh1JA3znEcvuHb2B54Oax
         HxaGyOsHKlDbRB+kIHhZ1X0ZkzFyiIIJQLXFvOPyPqVgcl7CzmbMZjdY/bxSnYicA0zc
         0wlC6vX9VtPT6a+HRzA3KEKCeqzvH//4cqm/t4gu9Fi/oaI8Z7w5GXA/uI1/p4XgW12X
         mtdOwIccZUIrQstSeDg7c22NffxfFZ4MzTFP5Ek0qwpPNIFbsbjyksywwl/g9bMzLy1F
         PF1w==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

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
index dc4e399..9d85f59 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -87,6 +87,8 @@ static bool wb_io_lists_populated(struct bdi_writeback *wb)
 		return false;
 	} else {
 		set_bit(WB_has_dirty_io, &wb->state);
+		atomic_long_add(wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
 		return true;
 	}
 }
@@ -94,8 +96,11 @@ static bool wb_io_lists_populated(struct bdi_writeback *wb)
 static void wb_io_lists_depopulated(struct bdi_writeback *wb)
 {
 	if (wb_has_dirty_io(wb) && list_empty(&wb->b_dirty) &&
-	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io))
+	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io)) {
 		clear_bit(WB_has_dirty_io, &wb->state);
+		atomic_long_sub(wb->avg_write_bandwidth,
+				&wb->bdi->tot_write_bandwidth);
+	}
 }
 
 /**
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 7a94b78..d631a61 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -142,6 +142,8 @@ struct backing_dev_info {
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
+	atomic_long_t tot_write_bandwidth; /* sum of active avg_write_bw */
+
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct bdi_writeback_congested wb_congested; /* its congested state */
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bfbd8d2..813e820 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -881,6 +881,9 @@ static void wb_update_write_bandwidth(struct bdi_writeback *wb,
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
