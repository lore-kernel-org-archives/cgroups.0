From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v7 0/2] cancel all throttled bios in del_gendisk()
Date: Fri, 28 Jan 2022 16:45:20 +0800
Message-ID: <20220128084522.3169961-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ming.lei@redhat.com, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

If del_gendisk() is done when some io are still throttled, such io
will not be handled until the throttle is done, which is not
necessary.

Changes in v7:
 - use the new solution as suggested by Ming.

Yu Kuai (2):
  blk-throtl: introduce a new flag THROTL_TG_CANCELING
  block: cancel all throttled bios in del_gendisk()

 block/blk-throttle.c | 49 ++++++++++++++++++++++++++++++++++++++++----
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 49 insertions(+), 4 deletions(-)

-- 
2.31.1

