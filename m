From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/12] bdi: remove BDI_CAP_CGROUP_WRITEBACK
Date: Thu, 10 Sep 2020 16:48:27 +0200
Message-ID: <20200910144833.742260-8-hch@lst.de>
References: <20200910144833.742260-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=x3mXocVSE1Ebx6CKr4ScPVOkg1E0gmJHqtGLnjlzrp0=;
	b=JyR2faOdOafTeMYH/eo+WcbIBC
	7g+pcV8tPXxPXK5fTzyK0UvjDb9hX+ZsGlihd6PNSeAEcrd6/F0PKw+J/MZyRNqC3swShhX5Hcs6p
	IJgJ6wjjuOo6uHHos0BtN0Gb4MGKL6AeyuMpgv5cHWB/qykJwCGcnqI5LogBbnPB/bYCkSF5A0u/o
	o/rsXAHmOpVdy4BP3SIQCeEOoJ/v7txgXEsYdeZr3Kz6nSWE2YxQ8T4SwIhLyY1/BpTKVFESoCjM1
	sl1PjMR+PX6pHDiUCcs0TGqQ9Q2rYCUp21Shuqfv5MJ7nYG6PS28uXxFE+LgCIrljCmxgqsvJHQ4q
	EWUWT1jg==;
In-Reply-To: <20200910144833.742260-1-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org

Just checking SB_I_CGROUPWB for cgroup writeback support is enough.
Either the file system allocates its own bdi (e.g. btrfs), in which case
it is known to support cgroup writeback, or the bdi comes from the block
layer, which always supports cgroup writeback.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn-Sjgp3cTcYWE@public.gmane.org>
---
 block/blk-core.c            | 1 -
 fs/btrfs/disk-io.c          | 1 -
 include/linux/backing-dev.h | 8 +++-----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 18c092f8d69175..d81ee511ec8b01 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -538,7 +538,6 @@ struct request_queue *blk_alloc_queue(int node_id)
 	if (!q->stats)
 		goto fail_stats;
 
-	q->backing_dev_info->capabilities = BDI_CAP_CGROUP_WRITEBACK;
 	q->node = node_id;
 
 	atomic_set(&q->nr_active_requests_shared_sbitmap, 0);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 047934cea25efa..e24927bddd5829 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3091,7 +3091,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_sb_buffer;
 	}
 
-	sb->s_bdi->capabilities |= BDI_CAP_CGROUP_WRITEBACK;
 	sb->s_bdi->ra_pages *= btrfs_super_num_devices(disk_super);
 	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 0b06b2d26c9aa3..52583b6f2ea05d 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -123,7 +123,6 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
  * BDI_CAP_NO_ACCT_WB:     Don't automatically account writeback pages
  * BDI_CAP_STRICTLIMIT:    Keep number of dirty pages below bdi threshold.
  *
- * BDI_CAP_CGROUP_WRITEBACK: Supports cgroup-aware writeback.
  * BDI_CAP_SYNCHRONOUS_IO: Device is so fast that asynchronous IO would be
  *			   inefficient.
  */
@@ -233,9 +232,9 @@ int inode_congested(struct inode *inode, int cong_bits);
  * inode_cgwb_enabled - test whether cgroup writeback is enabled on an inode
  * @inode: inode of interest
  *
- * cgroup writeback requires support from both the bdi and filesystem.
- * Also, both memcg and iocg have to be on the default hierarchy.  Test
- * whether all conditions are met.
+ * Cgroup writeback requires support from the filesystem.  Also, both memcg and
+ * iocg have to be on the default hierarchy.  Test whether all conditions are
+ * met.
  *
  * Note that the test result may change dynamically on the same inode
  * depending on how memcg and iocg are configured.
@@ -247,7 +246,6 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 	return cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 		cgroup_subsys_on_dfl(io_cgrp_subsys) &&
 		bdi_cap_account_dirty(bdi) &&
-		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
 		(inode->i_sb->s_iflags & SB_I_CGROUPWB);
 }
 
-- 
2.28.0
