From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 07/18] writeback: make __wb_calc_thresh() take
 dirty_throttle_control
Date: Wed, 25 Mar 2015 18:42:19 -0400
Message-ID: <20150325224219.GU3880@htj.duckdns.org>
References: <1427087267-16592-1-git-send-email-tj@kernel.org>
 <1427087267-16592-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DYQ9UQVvdPhr4/7tlvZBnWbnflFPRIFoOmUJdl9Zt28=;
        b=ABbkih2anPVDZIwCsnpl3Jr/upx6DKL5T3X5YcWOZ6l7S7GQWNCvb6vV5olmYpwcc8
         3rVfVTd/FjqeWzQy3hdFk/f1RJ02WTdV91utvmdFl83NWyQ0sXcS/NMFRjqc26ME5PXa
         DVPwm2tLa1JiuUv778Y3fvZAhbfZNsfpwnrE7RRU402FKgi6jaYmw4HmbnrFC7dJ08JJ
         fnSYcTgEBJc5MwcJT7plNbQBeOKKr87DaYzCBpdkLiJs3f9Zkz1Wt3JGFspVzuLOo8FL
         5WOnUjIkvOgm/UIo344eKI0kJxlAldo0xu4AKHG5KVpZT8Xgfv+1ljboS2/CD6ybM8VL
         +PPA==
Content-Disposition: inline
In-Reply-To: <1427087267-16592-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

From 1597de52b4281d9e14898c4f7cf314b0f2a507ea Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 25 Mar 2015 18:34:35 -0400

wb_calc_thresh() calculates wb_thresh by scaling thresh according to
the wb's portion in the system-wide write bandwidth.  cgroup writeback
support would need to calculate wb_thresh against memcg domain too.
This patch renames wb_calc_thresh() to __wb_calc_thresh() and makes it
take dirty_throttle_control so that the function can later be updated
to calculate against different domains according to
dirty_throttle_control.

wb_calc_thresh() is now a thin wrapper around __wb_calc_thresh().

v2: The original version was incorrectly scaling dtc->dirty instead of
    dtc->thresh.  This was due to the extremely confusing function and
    variable names.  Added a rename patch and fixed this one.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
The review git branch has been updated accordingly.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-backpressure-20150322

Please use the git branch for testing.  I'll post v2 series once I get
more feedback.

Thanks.

 mm/page-writeback.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0fe7e60..33b1536 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -557,9 +557,8 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
 }
 
 /**
- * wb_calc_thresh - @wb's share of dirty throttling threshold
- * @wb: bdi_writeback to query
- * @dirty: global dirty limit in pages
+ * __wb_calc_thresh - @wb's share of dirty throttling threshold
+ * @dtc: dirty_throttle_context of interest
  *
  * Returns @wb's dirty limit in pages. The term "dirty" in the context of
  * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
@@ -578,9 +577,10 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
  * The wb's share of dirty limit will be adapting to its throughput and
  * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
  */
-unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh)
+static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc)
 {
 	struct wb_domain *dom = &global_wb_domain;
+	unsigned long thresh = dtc->thresh;
 	u64 wb_thresh;
 	long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
@@ -588,14 +588,14 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh)
 	/*
 	 * Calculate this BDI's share of the thresh ratio.
 	 */
-	fprop_fraction_percpu(&dom->completions, &wb->completions,
+	fprop_fraction_percpu(&dom->completions, &dtc->wb->completions,
 			      &numerator, &denominator);
 
 	wb_thresh = (thresh * (100 - bdi_min_ratio)) / 100;
 	wb_thresh *= numerator;
 	do_div(wb_thresh, denominator);
 
-	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
+	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
 
 	wb_thresh += (thresh * wb_min_ratio) / 100;
 	if (wb_thresh > (thresh * wb_max_ratio) / 100)
@@ -604,6 +604,13 @@ unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh)
 	return wb_thresh;
 }
 
+unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh)
+{
+	struct dirty_throttle_control gdtc = { GDTC_INIT(wb),
+					       .thresh = thresh };
+	return __wb_calc_thresh(&gdtc);
+}
+
 /*
  *                           setpoint - dirty 3
  *        f(dirty) := 1.0 + (----------------)
@@ -1323,7 +1330,7 @@ static inline void wb_dirty_limits(struct dirty_throttle_control *dtc)
 	 *   wb_position_ratio() will let the dirtier task progress
 	 *   at some rate <= (write_bw / 2) for bringing down wb_dirty.
 	 */
-	dtc->wb_thresh = wb_calc_thresh(dtc->wb, dtc->thresh);
+	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
 		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
-- 
2.1.0
