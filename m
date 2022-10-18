From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/5] blk-iocost: Reset vtime_base_rate in ioc_refresh_params
Date: Tue, 18 Oct 2022 20:19:29 +0800
Message-ID: <20221018121932.10792-3-shikemeng@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221018121932.10792-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Since commit ac33e91e2daca("blk-iocost: implement vtime loss compensation")
split vtime_rate into vtime_rate and vtime_base_rate, we need reset both
vtime_base_rate and vtime_rate when device parameters are refreshed.
If vtime_base_rate is no reset here, vtime_rate will be overwritten with
old vtime_base_rate soon in ioc_refresh_vrate.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index be4bc38821e2..9214733bbc14 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -906,8 +906,10 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
 	if (idx == ioc->autop_idx && !force)
 		return false;
 
-	if (idx != ioc->autop_idx)
+	if (idx != ioc->autop_idx) {
 		atomic64_set(&ioc->vtime_rate, VTIME_PER_USEC);
+		ioc->vtime_base_rate = VTIME_PER_USEC;
+	}
 
 	ioc->autop_idx = idx;
 	ioc->autop_too_fast_at = 0;
-- 
2.30.0

