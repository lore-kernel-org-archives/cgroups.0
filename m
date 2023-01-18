From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 0/3] blk-cgroup: make sure pd_free_fn() is called in order
Date: Wed, 18 Jan 2023 20:31:49 +0800
Message-ID: <20230118123152.1926314-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

The problem was found in iocost orignally([1]) that ioc can be freed in
ioc_pd_free(). And later we found that there are more problem in
iocost([2]).

After some discussion, as suggested by Tejun([3]), we decide to fix the
problem that parent pd can be freed before child pd in cgroup layer
first. And the problem in [1] will be fixed later if this patchset is
applied.

[1] https://lore.kernel.org/all/20221130132156.2836184-8-linan122@huawei.com/
[2] https://lore.kernel.org/all/aa924294-2f54-1b53-fc6e-e4f8fa019b14@huaweicloud.com/
[3] https://lore.kernel.org/all/20221227125502.541931-1-yukuai1@huaweicloud.com/

Yu Kuai (3):
  blk-cgroup: dropping parent refcount after pd_free_fn() is done
  blk-cgroup: support to track if policy is online
  blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and
    blkcg_deactivate_policy()

 block/blk-cgroup.c     | 61 +++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h     |  1 +
 include/linux/blkdev.h |  1 +
 3 files changed, 48 insertions(+), 15 deletions(-)

-- 
2.31.1

