From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 0/4] cleanup and fixes for 'carryover_ios/bytes'
Date: Tue, 15 Aug 2023 09:41:19 +0800
Message-ID: <20230815014123.368929-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

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

 block/blk-throttle.c | 105 +++++++++++++++++++++----------------------
 block/blk-throttle.h |   4 +-
 2 files changed, 54 insertions(+), 55 deletions(-)

-- 
2.39.2

