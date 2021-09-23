From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 0/6] fix uaf in rq_qos_done_io()
Date: Thu, 23 Sep 2021 21:46:25 +0800
Message-ID: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

This patch set tries to fix the uaf when bio_endio() is called from
error path and is concurrent with blk_cleanup_queue().

Yu Kuai (6):
  rq-qos: introduce rq_qos_free()
  blk-wbt: introduce wbt_free()
  io-cost: introduce ioc_rqos_free()
  blk-iolatency: splict blkcg_iolatency_free() from
    blkcg_iolatency_exit()
  blk-ioprio: introduce blkcg_ioprio_free()
  rq-qos: fix uaf in rq_qos_done_io()

 block/blk-iocost.c    |  7 +++++++
 block/blk-iolatency.c |  7 +++++++
 block/blk-ioprio.c    |  7 ++++++-
 block/blk-rq-qos.c    | 12 +++++++++++-
 block/blk-rq-qos.h    |  2 ++
 block/blk-sysfs.c     |  1 +
 block/blk-wbt.c       |  7 +++++++
 7 files changed, 41 insertions(+), 2 deletions(-)

-- 
2.31.1

