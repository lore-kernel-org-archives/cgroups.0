From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v2 0/5] blk-iocost: random patches to improve configuration
Date: Fri,  4 Nov 2022 10:39:33 +0800
Message-ID: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - add review tag from Christoph for patch 1-3
 - add a mutex to fix warnning as suggested by Christoph
 - add patch 5

Yu Kuai (5):
  blk-iocost: cleanup ioc_qos_write() and ioc_cost_model_write()
  blk-iocost: improve hanlder of match_u64()
  blk-iocost: don't allow to configure bio based device
  blk-iocost: fix sleeping in atomic context warnning
  blk-iocost: read params inside lock in sysfs apis

 block/blk-iocost.c | 116 +++++++++++++++++++++++++++++----------------
 1 file changed, 74 insertions(+), 42 deletions(-)

-- 
2.31.1

