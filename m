From: Li Nan <linan122@huawei.com>
Subject: [PATCH -next v2 0/9] iocost bugfix
Date: Wed, 30 Nov 2022 21:21:47 +0800
Message-ID: <20221130132156.2836184-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com

Li Nan (4):
  blk-iocost: fix divide by 0 error in calc_lcoefs()
  blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in
    ioc_refresh_params()
  blk-iocost: fix UAF in ioc_pd_free
  block: fix null-pointer dereference in ioc_pd_init

Yu Kuai (5):
  blk-iocost: cleanup ioc_qos_write() and ioc_cost_model_write()
  blk-iocost: improve hanlder of match_u64()
  blk-iocost: don't allow to configure bio based device
  blk-iocost: read params inside lock in sysfs apis
  blk-iocost: fix walk_list corruption

 block/blk-iocost.c | 117 ++++++++++++++++++++++++++++-----------------
 block/genhd.c      |   2 +-
 2 files changed, 75 insertions(+), 44 deletions(-)

-- 
2.31.1

