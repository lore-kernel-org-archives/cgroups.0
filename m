From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 0/4] cleanup and fixes for 'carryover_ios/bytes'
Date: Wed, 16 Aug 2023 09:27:04 +0800
Message-ID: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

changes in v2:
 - fix missing adjustment in throtl_log().

Patch 1 print signed value for 'carryover_ios/bytes' to user.

Patch 2 fix that comparation ”unsigned value < negative value“ will
pass, causing that io won't be throttled in the silce.

Patch 3,4 fix that 'carryover_ios/bytes' is not cleared while
'io/bytes_disp' is cleared, causing that throttle is not accurate.

Yu Kuai (4):
  blk-throttle: print signed value 'carryover_bytes/ios' for user
  blk-throttle: fix wrong comparation while 'carryover_ios/bytes' is
    negative
  blk-throttle: use calculate_io/bytes_allowed() for throtl_trim_slice()
  blk-throttle: consider 'carryover_ios/bytes' in throtl_trim_slice()

 block/blk-throttle.c | 112 +++++++++++++++++++++----------------------
 block/blk-throttle.h |   4 +-
 2 files changed, 58 insertions(+), 58 deletions(-)

-- 
2.39.2

