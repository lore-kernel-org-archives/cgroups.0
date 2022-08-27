From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v2 0/3] blk-throttle cleanups
Date: Sat, 27 Aug 2022 18:16:34 +0800
Message-ID: <20220827101637.1775111-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - add tag
 - remove patch 4

There are no functional changes.

Yu Kuai (3):
  blk-throttle: use 'READ/WRITE' instead of '0/1'
  blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
  blk-throttle: cleanup tg_update_disptime()

 block/blk-throttle.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

-- 
2.31.1

