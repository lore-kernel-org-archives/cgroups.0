From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v2 0/2] bugfix for blk-throttle
Date: Wed, 18 May 2022 15:27:49 +0800
Message-ID: <20220518072751.1188163-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Changes in v2:
 - use a new solution suggested by Ming
 - change the title of patch 1
 - add patch 2

Patch 1 fix that blk-throttle can't work if multiple bios are throttle,
Patch 2 fix io hung due to configuration updates.

Previous version:
v1 : https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

Yu Kuai (2):
  blk-throttle: fix that io throttle can only work for single bio
  blk-throttle: fix io hung due to configuration updates

 block/blk-throttle.c | 88 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 69 insertions(+), 19 deletions(-)

-- 
2.31.1

