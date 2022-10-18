From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/3] block: Remove redundant parent blkcg_gp check in check_scale_change
Date: Tue, 18 Oct 2022 19:12:38 +0800
Message-ID: <20221018111240.22612-2-shikemeng@huawei.com>
References: <20221018111240.22612-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221018111240.22612-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Function blkcg_iolatency_throttle will make sure blkg->parent is not
NULL before calls check_scale_change. And function check_scale_change
is only called in blkcg_iolatency_throttle.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
---
 block/blk-iolatency.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 571fa95aafe9..b24d7b788ba3 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -403,9 +403,6 @@ static void check_scale_change(struct iolatency_grp *iolat)
 	u64 scale_lat;
 	int direction = 0;
 
-	if (lat_to_blkg(iolat)->parent == NULL)
-		return;
-
 	parent = blkg_to_lat(lat_to_blkg(iolat)->parent);
 	if (!parent)
 		return;
-- 
2.30.0

