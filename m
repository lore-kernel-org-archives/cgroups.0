From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/19] writeback: add dirty_throttle_control->wb_completions
Date: Mon,  6 Apr 2015 16:04:25 -0400
Message-ID: <1428350674-8303-11-git-send-email-tj@kernel.org>
References: <1428350674-8303-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OfQazpMSvRcpnOKmHymncrvS4Tlzv3pZh5ll7JIF3yA=;
        b=o6phAUJFWIRrilroegiVjVt97o1uUg0cAvD4MM4gF0gs4fDG+ED29F3oVbR9og/FP1
         OwaDOSjfY4br/NkX4KAXxAppnRITXybeaGPM2nSBw26hYrMtDIOVBwTIFp186bLifnoF
         d+8umf49H0O8H1juTX5wCa9fA/4yhX69IiLvu77PeoXiay6e7xtK9zINdEX7xDBjFa7z
         ovQKcWIzpa8No2ZhSKw0Juhd9i0AIX8Gi0P3myhH85LgGlbLzJ0nq/RcxyHwLaR8kxZd
         IfvZmBCGwMYxrys8icqB6CuaF5KWfaaxcZhZhHL/4VN6GKwiYOMgv4e6a8AACW3bQeE0
         Q3AA==
In-Reply-To: <1428350674-8303-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

wb->completions measures the wb's proportional write bandwidth in
global_wb_domain and thus naturally tied to the wb_domain.  This patch
adds dirty_throttle_control->wb_completions which is initialized to
wb->completions by GDTC_INIT() and updates __wb_dirty_limits() to use
it instead of dereferencing wb->completions directly.

This will allow dirty_throttle_control to represent different
wb_domains and the matching wb completions.

This patch doesn't introduce any behavioral changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 mm/page-writeback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3450520..15771a6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -127,6 +127,7 @@ struct wb_domain global_wb_domain;
 /* consolidated parameters for balance_dirty_pages() and its subroutines */
 struct dirty_throttle_control {
 	struct bdi_writeback	*wb;
+	struct fprop_local_percpu *wb_completions;
 
 	unsigned long		dirty;		/* file_dirty + write + nfs */
 	unsigned long		thresh;		/* dirty threshold */
@@ -139,7 +140,8 @@ struct dirty_throttle_control {
 	unsigned long		pos_ratio;
 };
 
-#define GDTC_INIT(__wb)		.wb = (__wb)
+#define GDTC_INIT(__wb)		.wb = (__wb),				\
+				.wb_completions = &(__wb)->completions
 
 /*
  * Length of period for aging writeout fractions of bdis. This is an
@@ -590,7 +592,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc)
 	/*
 	 * Calculate this BDI's share of the thresh ratio.
 	 */
-	fprop_fraction_percpu(&dom->completions, &dtc->wb->completions,
+	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
 	wb_thresh = (thresh * (100 - bdi_min_ratio)) / 100;
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
