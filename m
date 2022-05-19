From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v3 0/2] bugfix for blk-throttle
Date: Thu, 19 May 2022 16:58:09 +0800
Message-ID: <20220519085811.879097-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, geert@linux-m68k.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Changes in v3:
 - fix a check in patch 1
 - fix link err in patch 2 on 32-bit platform
 - hanlde overflow in patch 2
Changes in v2:
 - use a new solution suggested by Ming
 - change the title of patch 1
 - add patch 2

Patch 1 fix that blk-throttle can't work if multiple bios are throttle,
Patch 2 fix io hung due to configuration updates.

Previous version:
v1 : https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3@huawei.com/
v2 : https://lore.kernel.org/all/20220518072751.1188163-1-yukuai3@huawei.com/
Yu Kuai (2):
  blk-throttle: fix that io throttle can only work for single bio
  blk-throttle: fix io hung due to configuration updates

 block/blk-throttle.c | 104 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 85 insertions(+), 19 deletions(-)

-- 
2.31.1

