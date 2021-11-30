From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v2 0/2] cancel all throttled bios in del_gendisk()
Date: Tue, 30 Nov 2021 09:17:28 +0800
Message-ID: <20211130011730.2584339-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@infradead.org, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

If del_gendisk() is done when some io are still throttled, such io
will not be handled until the throttle is done, which is not
necessary.

Changes in v2:
 - move WARN_ON_ONCE() from throtl_rb_first() to it's caller
 - merge some patches into one.

Yu Kuai (2):
  blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
  block: cancel all throttled bios in del_gendisk()

 block/blk-throttle.c | 68 ++++++++++++++++++++++++++++++++++++++++++--
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 69 insertions(+), 3 deletions(-)

-- 
2.31.1

