From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/19] writeback: add dirty_throttle_control->wb_completions
Date: Fri, 22 May 2015 18:23:27 -0400
Message-ID: <1432333416-6221-11-git-send-email-tj@kernel.org>
References: <1432333416-6221-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8BTqx5CX5VGO7LIMqUMWk2soxVUZYbkff7FSGF7HSoc=;
        b=gb1WlDv2MIt+BWd52PUIJUsIzGjVgv3FIWIgc/ezYnVadMi/IW4A4K5MWZEo/MADwB
         QjNrJwPha4Mvst60xwgXBeqUQ9Ipf3mgVLmMpTqv5UvHtdiVXc6Z8OKlidmHPXMmBtnU
         P29OZYiJ7m/BPIucRWpvjDLAJcBKZ88xlZm2YqBvw4hdv0lvFW0fxGAnH2JaNPsnoJz7
         qdMEsxZCmL6Lm+3By2FMPGTUGJSky3HNcw9TBIC21SYcwcTQ5g4eGa3msBK4qMVy8Ll2
         GVDFfghhD/yFPyN8gUFM95gPksBK3mlOeazvTbk6rguu5GicRtqo7W/XjcE8yyVLXyOr
         7Gdg==
In-Reply-To: <1432333416-6221-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

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
index fcebae7..5b439fc 100644
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
2.4.0
