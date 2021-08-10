From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: move the bdi from the request_queue to the gendisk
Date: Tue, 10 Aug 2021 22:02:56 +0200
Message-ID: <20210810200256.GA30809@lst.de>
References: <20210809141744.1203023-1-hch@lst.de> <e5e19d15-7efd-31f4-941a-a5eb2f94b898@quicinc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e5e19d15-7efd-31f4-941a-a5eb2f94b898-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Aug 10, 2021 at 03:36:39PM -0400, Qian Cai wrote:
> 
> 
> On 8/9/2021 10:17 AM, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series moves the pointer to the bdi from the request_queue
> > to the bdi, better matching the life time rules of the different
> > objects.
> 
> Reverting this series fixed an use-after-free in bdev_evict_inode().

Please try the patch below as a band-aid.  Although the proper fix is
that non-default bdi_writeback structures grab a reference to the bdi,
as this was a landmine that might have already caused spurious issues
before.

diff --git a/block/genhd.c b/block/genhd.c
index f8def1129501..2e4a9d187196 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1086,7 +1086,6 @@ static void disk_release(struct device *dev)
 
 	might_sleep();
 
-	bdi_put(disk->bdi);
 	if (MAJOR(dev->devt) == BLOCK_EXT_MAJOR)
 		blk_free_ext_minor(MINOR(dev->devt));
 	disk_release_events(disk);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7c969f81327a..c6087dbae6cf 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -849,11 +849,15 @@ static void init_once(void *data)
 
 static void bdev_evict_inode(struct inode *inode)
 {
+	struct block_device *bdev = I_BDEV(inode);
+
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode); /* is it needed here? */
 	clear_inode(inode);
 	/* Detach inode from wb early as bdi_put() may free bdi->wb */
 	inode_detach_wb(inode);
+	if (!bdev_is_partition(bdev))
+		bdi_put(bdev->bd_disk->bdi);
 }
 
 static const struct super_operations bdev_sops = {
