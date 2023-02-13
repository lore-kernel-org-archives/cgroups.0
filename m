From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] blk-cgroup: only grab an inode reference to the disk for each blkg
Date: Mon, 13 Feb 2023 11:41:34 +0100
Message-ID: <20230213104134.475204-4-hch@lst.de>
References: <20230213104134.475204-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ckmxv8qhJugK1MrR2lVAP90BuFXp6EXY+cU1PNhLSHU=; b=xTAl0YM5g5CYBFm3f8D7umNDo7
        x5HeBP/Pbg1MHWPkf6CXEYrWZLpWDoDWgIw9fgcc3/5pXBgH/C3tBhMee2rv5xHq9wm1Xlaxh+LSG
        tAVHJPE+zFhIPuFtxdBvbVSxnuFAM7meC/kkk/uHJmPq2jiHpSsrJs5JoXbEv2YxPq91ioCE4pJ2G
        P7AR670iFcpc796xctHxG6lp1YsGKH2ffHlwMG0HiutIh1m82GeB+ixnoOjmppaOdKyihfalb3tPe
        z2vrSGwZE75EHQsqtKQ21GguZHKQR8GPD25c30b4Yxc5Nc5SxV84U27MzM82WjdMgSDgCqjfAYje9
        fetC9WIg==;
In-Reply-To: <20230213104134.475204-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

To avoid a circular reference, do not grab a device model reference
to the gendisk for each blkg, but just the lower level inode reference
preventing the memory from beeing freed.

This means blkg freeing and pd_free need to be careful to not rely
on anything torn down in disk_release.

Fixes: c43332fe028c ("blk-cgroup: delay calling blkcg_exit_disk until disk_release")
Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 935028912e7abf..9e7e48c8fa47ae 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -136,7 +136,7 @@ static void blkg_free_workfn(struct work_struct *work)
 	list_del_init(&blkg->entry);
 	mutex_unlock(&blkg->disk->blkcg_mutex);
 
-	put_disk(blkg->disk);
+	iput(blkg->disk->part0->bd_inode);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -264,9 +264,15 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	if (!blkg->iostat_cpu)
 		goto out_exit_refcnt;
 
+	/*
+	 * Grab a reference the part0 inode, which keeps the memory backing the
+	 * gendisk from beeing released and safe for use in ->pd_free instead of
+	 * the full fledged device model reference because the blkgs are only
+	 * released in disk_release and would thus create circular references.
+	 */
 	if (test_bit(GD_DEAD, &disk->state))
 		goto out_free_iostat;
-	get_device(disk_to_dev(disk));
+	igrab(disk->part0->bd_inode);
 	blkg->disk = disk;
 
 	INIT_LIST_HEAD(&blkg->entry);
@@ -304,7 +310,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	while (--i >= 0)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
-	put_disk(blkg->disk);
+	iput(blkg->disk->part0->bd_inode);
 out_free_iostat:
 	free_percpu(blkg->iostat_cpu);
 out_exit_refcnt:
-- 
2.39.1

