From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v4 0/5] blk-iocost: random bugfix
Date: Tue, 17 Jan 2023 15:08:01 +0800
Message-ID: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

changes in v4:
 - a litter code optimization to make it easier to understand in patch
 4.

changes in v3:
 - move some patches into separate patchset
 - don't return other error number for match_u64() in patch 1
 - instead of checking user input separately, set page directly if
 'bps + IOC_PAGE_SIZE' will overflow.

Li Nan (2):
  blk-iocost: fix divide by 0 error in calc_lcoefs()
  blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in
    ioc_refresh_params()

Yu Kuai (3):
  blk-iocost: check return value of match_u64()
  blk-iocost: don't allow to configure bio based device
  blk-iocost: read params inside lock in sysfs apis

 block/blk-iocost.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

-- 
2.31.1

