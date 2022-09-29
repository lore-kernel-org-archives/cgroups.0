From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] A few cleanup patches for blk-iolatency.c
Date: Thu, 29 Sep 2022 15:40:52 +0800
Message-ID: <20220929074055.30080-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

This series contains three cleanup patches to remove redundant check,
correct comment and simplify struct iolatency_grp in blk-iolatency.c.

Kemeng Shi (3):
  block: Remove redundant parent blkcg_gp check in check_scale_change
  block: Correct comment for scale_cookie_change
  block: Replace struct rq_depth with unsigned int in struct
    iolatency_grp

 block/blk-iolatency.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

-- 
2.30.0

