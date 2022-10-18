From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/5] blk-iocost: Remove vrate member in struct ioc_now
Date: Tue, 18 Oct 2022 20:19:31 +0800
Message-ID: <20221018121932.10792-5-shikemeng@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221018121932.10792-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If we trace vtime_base_rate instead of vtime_rate, there is nowhere
which accesses now->vrate except function ioc_now using now->vrate locally.
Just remove it.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b0991b52e3dd..761295ed9c5a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -556,7 +556,6 @@ struct ioc_now {
 	u64				now_ns;
 	u64				now;
 	u64				vnow;
-	u64				vrate;
 };
 
 struct iocg_wait {
@@ -1020,10 +1019,11 @@ static void ioc_adjust_base_vrate(struct ioc *ioc, u32 rq_wait_pct,
 static void ioc_now(struct ioc *ioc, struct ioc_now *now)
 {
 	unsigned seq;
+	u64 vrate;
 
 	now->now_ns = ktime_get();
 	now->now = ktime_to_us(now->now_ns);
-	now->vrate = atomic64_read(&ioc->vtime_rate);
+	vrate = atomic64_read(&ioc->vtime_rate);
 
 	/*
 	 * The current vtime is
@@ -1036,7 +1036,7 @@ static void ioc_now(struct ioc *ioc, struct ioc_now *now)
 	do {
 		seq = read_seqcount_begin(&ioc->period_seqcount);
 		now->vnow = ioc->period_at_vtime +
-			(now->now - ioc->period_at) * now->vrate;
+			(now->now - ioc->period_at) * vrate;
 	} while (read_seqcount_retry(&ioc->period_seqcount, seq));
 }
 
-- 
2.30.0

