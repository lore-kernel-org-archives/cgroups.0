From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v2 0/2] blk-iocost: add refcounting for iocg and ioc
Date: Tue, 27 Dec 2022 20:55:00 +0800
Message-ID: <20221227125502.541931-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Changes in v2:
 - Instead add ioc_pd_offline(), and move operations for iocg from
 ioc_pd_free() to ioc_pd_offline(), use refcounting to fix the problem.

Yu Kuai (2):
  blk-iocost: add refcounting for iocg
  blk-iocost: add refcounting for ioc

 block/blk-iocost.c | 86 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 25 deletions(-)

-- 
2.31.1

