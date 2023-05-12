From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 0/6] blk-wbt: minor fix and cleanup
Date: Fri, 12 May 2023 17:35:48 +0800
Message-ID: <20230512093554.911753-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: lukas.bulwahn@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - make the code more readable for patch 1
 - add a new attr_group that is only visible for rq based device
 - explain in detail for patch 4
 - add review tag for patch 2,3,5

Yu Kuai (6):
  blk-wbt: fix that wbt can't be disabled by default
  blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
  blk-wbt: remove dead code to handle wbt enable/disable with io
    inflight
  blk-wbt: cleanup rwb_enabled() and wbt_disabled()
  blk-iocost: move wbt_enable/disable_default() out of spinlock
  blk-sysfs: add a new attr_group for blk_mq

 block/blk-iocost.c |   7 +-
 block/blk-sysfs.c  | 181 ++++++++++++++++++++++++++-------------------
 block/blk-wbt.c    |  33 +++------
 block/blk-wbt.h    |  19 -----
 4 files changed, 117 insertions(+), 123 deletions(-)

-- 
2.39.2

