From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/10] blk-throttle: avoid dead code in throtl_hierarchy_can_upgrade
Date: Tue, 29 Nov 2022 11:01:47 +0800
Message-ID: <20221129030147.27400-11-shikemeng@huawei.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221129030147.27400-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Function throtl_hierarchy_can_upgrade will always return from while loop,
so the return outside while loop is never reached. Break the loop when
we traverse to root as throtl_hierarchy_can_downgrade do to avoid dead
code.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4c80f2aa1e29..9946524de158 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1854,7 +1854,7 @@ static bool throtl_hierarchy_can_upgrade(struct throtl_grp *tg)
 			return true;
 		tg = sq_to_tg(tg->service_queue.parent_sq);
 		if (!tg || !tg_to_blkg(tg)->parent)
-			return false;
+			break;
 	}
 	return false;
 }
-- 
2.30.0

