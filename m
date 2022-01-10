From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v6 0/2] cancel all throttled bios in del_gendisk()
Date: Mon, 10 Jan 2022 21:47:56 +0800
Message-ID: <20220110134758.2233758-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mkoutny@suse.com, paulmck@kernel.org, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

If del_gendisk() is done when some io are still throttled, such io
will not be handled until the throttle is done, which is not
necessary.

Changes in v2:
 - move WARN_ON_ONCE() from throtl_rb_first() to it's caller
 - merge some patches into one.

Changes in v3:
 - some code optimization in patch 1
 - hold queue lock to cancel bios in patch 2

Changes in v4:
 - delete rcu_read_lock() and rcu_read_unlock() in patch 2

Changes in v5:
 - add comment about rcu lock

Changes in v6:
 - revert to include rcu lock with some comments.

Jagan Teki (1):
  ARM: dts: stm32: Enable LVDS panel on i.Core STM32MP1 EDIMM2.2

Yu Kuai (1):
  blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller

Yu Kuai (2):
  blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
  block: cancel all throttled bios in del_gendisk()

 block/blk-throttle.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 83 insertions(+), 3 deletions(-)

-- 
2.31.1

