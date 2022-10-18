From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH v2 3/5] blk-iocost: Trace vtime_base_rate instead of vtime_rate
Date: Tue, 18 Oct 2022 20:19:30 +0800
Message-ID: <20221018121932.10792-4-shikemeng@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221018121932.10792-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Since commit ac33e91e2daca ("blk-iocost: implement vtime loss
compensation") rename original vtime_rate to vtime_base_rate
and current vtime_rate is original vtime_rate with compensation.
The current rate showed in tracepoint is mixed with vtime_rate
and vtime_base_rate:
1) In function ioc_adjust_base_vrate, the first trace_iocost_ioc_vrate_adj
shows vtime_rate, the second trace_iocost_ioc_vrate_adj shows
vtime_base_rate.
2) In function iocg_activate shows vtime_rate by calling
TRACE_IOCG_PATH(iocg_activate...
3) In function ioc_check_iocgs shows vtime_rate by calling
TRACE_IOCG_PATH(iocg_idle...

Trace vtime_base_rate instead of vtime_rate as:
1) Before commit ac33e91e2daca ("blk-iocost: implement vtime loss
compensation"), the traced rate is without compensation, so still
show rate without compensation.
2) The vtime_base_rate is more stable while vtime_rate heavily depends on
excess budeget on current period which may change abruptly in next period.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c            | 2 +-
 include/trace/events/iocost.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 9214733bbc14..b0991b52e3dd 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -977,7 +977,7 @@ static void ioc_adjust_base_vrate(struct ioc *ioc, u32 rq_wait_pct,
 
 	if (!ioc->busy_level || (ioc->busy_level < 0 && nr_lagging)) {
 		if (ioc->busy_level != prev_busy_level || nr_lagging)
-			trace_iocost_ioc_vrate_adj(ioc, atomic64_read(&ioc->vtime_rate),
+			trace_iocost_ioc_vrate_adj(ioc, vrate,
 						   missed_ppm, rq_wait_pct,
 						   nr_lagging, nr_shortages);
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index 6d1626e7a4ce..af8bfed528fc 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -38,7 +38,7 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 		__assign_str(cgroup, path);
 		__entry->now = now->now;
 		__entry->vnow = now->vnow;
-		__entry->vrate = now->vrate;
+		__entry->vrate = iocg->ioc->vtime_base_rate;
 		__entry->last_period = last_period;
 		__entry->cur_period = cur_period;
 		__entry->vtime = vtime;
@@ -160,7 +160,7 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 
 	TP_fast_assign(
 		__assign_str(devname, ioc_name(ioc));
-		__entry->old_vrate = atomic64_read(&ioc->vtime_rate);
+		__entry->old_vrate = ioc->vtime_base_rate;
 		__entry->new_vrate = new_vrate;
 		__entry->busy_level = ioc->busy_level;
 		__entry->read_missed_ppm = missed_ppm[READ];
-- 
2.30.0

