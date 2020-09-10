From: Christoph Hellwig <hch@lst.de>
Subject: bdi cleanups v4
Date: Thu, 10 Sep 2020 16:48:20 +0200
Message-ID: <20200910144833.742260-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Minchan Kim <minchan@kernel.org>, Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com, linux-mtd@lists.infradead.org, cgroups@vger.kernel.org, drbd-dev@tron.linbit.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Hi Jens,

this series contains a bunch of different BDI cleanups.  The biggest item
is to isolate block drivers from the BDI in preparation of changing the
lifetime of the block device BDI in a follow up series.


Changes since v3:
 - rebased on the lasted block tree, which has some of the prep
   changes merged
 - extend the ->ra_pages changes to ->io_pages
 - move initializing ->ra_pages and ->io_pages for block devices to
   blk_register_queue

Changes since v2:
 - fix a rw_page return value check
 - fix up various changelogs

Changes since v1:
 - rebased to the for-5.9/block-merge branch
 - explicitly set the readahead to 0 for ubifs, vboxsf and mtd
 - split the zram block_device operations
 - let rw_page users fall back to bios in swap_readpage


Diffstat:
 block/blk-core.c              |    3 -
 block/blk-integrity.c         |    4 +-
 block/blk-mq-debugfs.c        |    1 
 block/blk-settings.c          |    5 +-
 block/blk-sysfs.c             |    4 +-
 block/genhd.c                 |   13 +++++--
 drivers/block/aoe/aoeblk.c    |    2 -
 drivers/block/brd.c           |    1 
 drivers/block/drbd/drbd_nl.c  |   18 ---------
 drivers/block/drbd/drbd_req.c |    4 --
 drivers/block/rbd.c           |    2 -
 drivers/block/zram/zram_drv.c |   19 +++++++---
 drivers/md/bcache/super.c     |    4 --
 drivers/md/dm-table.c         |    9 +---
 drivers/md/raid0.c            |   16 --------
 drivers/md/raid10.c           |   46 ++++++++----------------
 drivers/md/raid5.c            |   31 +++++++---------
 drivers/mmc/core/queue.c      |    3 -
 drivers/mtd/mtdcore.c         |    2 +
 drivers/nvdimm/btt.c          |    2 -
 drivers/nvdimm/pmem.c         |    1 
 drivers/nvme/host/core.c      |    3 -
 drivers/nvme/host/multipath.c |   10 +----
 drivers/scsi/iscsi_tcp.c      |    4 +-
 fs/9p/vfs_file.c              |    2 -
 fs/9p/vfs_super.c             |    6 ++-
 fs/afs/super.c                |    1 
 fs/btrfs/disk-io.c            |    2 -
 fs/fs-writeback.c             |    7 ++-
 fs/fuse/inode.c               |    4 +-
 fs/namei.c                    |    4 +-
 fs/nfs/super.c                |    9 ----
 fs/super.c                    |    2 +
 fs/ubifs/super.c              |    2 +
 fs/vboxsf/super.c             |    2 +
 include/linux/backing-dev.h   |   78 +++++++-----------------------------------
 include/linux/blkdev.h        |    3 +
 include/linux/drbd.h          |    1 
 include/linux/fs.h            |    2 -
 mm/backing-dev.c              |   13 +++----
 mm/filemap.c                  |    4 +-
 mm/memcontrol.c               |    2 -
 mm/memory-failure.c           |    2 -
 mm/migrate.c                  |    2 -
 mm/mmap.c                     |    2 -
 mm/page-writeback.c           |   18 ++++-----
 mm/page_io.c                  |   18 +++++----
 mm/swapfile.c                 |    4 +-
 48 files changed, 144 insertions(+), 253 deletions(-)
