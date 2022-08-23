From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v8 0/4] blk-throttle bugfix
Date: Tue, 23 Aug 2022 11:31:26 +0800
Message-ID: <20220823033130.874230-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org, ming.lei@redhat.com, mkoutny@suse.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Changes in v8:
 - use a new solution in patch 1
 - move cleanups to a separate patchset
 - rename bytes/io_skipped to carryover_bytes/ios in patch 4
Changes in v7:
 - add patch 5 to improve handling of re-entered bio for bps limit
 - as suggested by Tejun, add some comments
 - sdd some Acked tag by Tejun
Changes in v6:
 - rename parameter in patch 3
 - add comments and reviewed tag for patch 4
Changes in v5:
 - add comments in patch 4
 - clear bytes/io_skipped in throtl_start_new_slice_with_credit() in
 patch 4
 - and cleanup patches 5-8
Changes in v4:
 - add reviewed-by tag for patch 1
 - add patch 2,3
 - use a different way to fix io hung in patch 4
Changes in v3:
 - fix a check in patch 1
 - fix link err in patch 2 on 32-bit platform
 - handle overflow in patch 2
Changes in v2:
 - use a new solution suggested by Ming
 - change the title of patch 1
 - add patch 2

Patch 1 fix that blk-throttle can't work if multiple bios are throttle.
Patch 2 fix overflow while calculating wait time.
Patch 3,4 fix io hung due to configuration updates.

Previous version:
v1: https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3@huawei.com/
v2: https://lore.kernel.org/all/20220518072751.1188163-1-yukuai3@huawei.com/
v3: https://lore.kernel.org/all/20220519085811.879097-1-yukuai3@huawei.com/
v4: https://lore.kernel.org/all/20220523082633.2324980-1-yukuai3@huawei.com/
v5: https://lore.kernel.org/all/20220528064330.3471000-1-yukuai3@huawei.com/
v6: https://lore.kernel.org/all/20220701093441.885741-1-yukuai1@huaweicloud.com/
v7: https://lore.kernel.org/all/20220802140415.2960284-1-yukuai1@huaweicloud.com/
Yu Kuai (4):
  blk-throttle: fix that io throttle can only work for single bio
  blk-throttle: prevent overflow while calculating wait time
  blk-throttle: factor out code to calculate ios/bytes_allowed
  blk-throttle: fix io hung due to configuration updates

 block/bio.c               |   2 -
 block/blk-merge.c         |   7 ++
 block/blk-throttle.c      | 138 +++++++++++++++++++++++++++-----------
 block/blk-throttle.h      |  15 ++++-
 include/linux/bio.h       |   6 +-
 include/linux/blk_types.h |   6 +-
 6 files changed, 125 insertions(+), 49 deletions(-)

-- 
2.31.1

