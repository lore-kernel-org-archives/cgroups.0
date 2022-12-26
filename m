From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v3 0/5] blk-iocost: random bugfix
Date: Mon, 26 Dec 2022 16:58:54 +0800
Message-ID: <20221226085859.2701195-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

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

 block/blk-iocost.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
2.31.1

