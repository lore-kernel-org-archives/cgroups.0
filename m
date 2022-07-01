From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH RESEND v6 0/8] bugfix and cleanup for blk-throttle
Date: Fri,  1 Jul 2022 17:34:33 +0800
Message-ID: <20220701093441.885741-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Resend v5 by a new mail address(huaweicloud.com) because old
address(huawei.com)has some problem that emails can end up in spam.
Please let me know if anyone still see this patchset end up in spam.

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

Patch 1 fix that blk-throttle can't work if multiple bios are throttle,
Patch 2 fix overflow while calculating wait time
Patch 3,4 fix io hung due to configuration updates.
Patch 5-8 are cleanup patches, there are no functional changes, just
some places that I think can be optimized during code review.

Previous version:
v1: https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v2: https://lore.kernel.org/all/20220518072751.1188163-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v3: https://lore.kernel.org/all/20220519085811.879097-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v4: https://lore.kernel.org/all/20220523082633.2324980-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v5: https://lore.kernel.org/all/20220528064330.3471000-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

Yu Kuai (8):
  blk-throttle: fix that io throttle can only work for single bio
  blk-throttle: prevent overflow while calculating wait time
  blk-throttle: factor out code to calculate ios/bytes_allowed
  blk-throttle: fix io hung due to config updates
  blk-throttle: use 'READ/WRITE' instead of '0/1'
  blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
  blk-throttle: cleanup tg_update_disptime()
  blk-throttle: clean up flag 'THROTL_TG_PENDING'

 block/blk-throttle.c | 168 +++++++++++++++++++++++++++++--------------
 block/blk-throttle.h |  16 +++--
 2 files changed, 128 insertions(+), 56 deletions(-)

-- 
2.31.1

