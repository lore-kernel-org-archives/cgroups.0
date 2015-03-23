From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/48] writeback: make bdi->min/max_ratio handling cgroup writeback aware
Date: Mon, 23 Mar 2015 00:54:44 -0400
Message-ID: <1427086499-15657-34-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cPHo3vvOUpTDiQhr6HTQHHKvmRSwnMdHQ5l8FZjR+0M=;
        b=fvRyB6TDTUEE3Glb7WdD+zMmT3Vk8QZq6Qg3AXqI3eS2NVYW2OuLcHKZlEIg+dFL3s
         EpwICEYiYS33Q3sI2AxYtwLmt0LALFNWf9+P+aHGMWN37jPLyGeqCPvpjAMLW7yvjoFD
         RXWj3zz8a2eqAVGygFRp7tGWjji+g2pQ3O+Z+M7xT9vUqVAW75HbxrKhoYKBJXAEL1Bp
         ceak+euCBg7gMF+7G3cJNU+9fLecEK8kNQ/0g5XtpSFTCaGaNOwGEJ/MxV22TAECfHah
         bdpQvLIzh34m5IfBIEGv6eoMZIGRcHTX8a2YHNpKI49yeKbhTeJ05DPSbD3mZ7iQ5oII
         ap6A==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

bdi->min/max_ratio are user-configurable per-bdi knobs which regulate
dirty limit of each bdi.  For cgroup writeback, they need to be
further distributed across wb's (bdi_writeback's) belonging to the
configured bdi.

This patch introduces wb_min_max_ratio() which distributes
bdi->min/max_ratio according to a wb's proportion in the total active
bandwidth of its bdi.

v2: Update wb_min_max_ratio() to fix a bug where both min and max were
    assigned the min value and avoid calculations when possible.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8480a45..349e32b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -155,6 +155,46 @@ static unsigned long writeout_period_time = 0;
  */
 #define VM_COMPLETIONS_PERIOD_LEN (3*HZ)
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+
+static void wb_min_max_ratio(struct bdi_writeback *wb,
+			     unsigned long *minp, unsigned long *maxp)
+{
+	unsigned long this_bw = wb->avg_write_bandwidth;
+	unsigned long tot_bw = atomic_long_read(&wb->bdi->tot_write_bandwidth);
+	unsigned long long min = wb->bdi->min_ratio;
+	unsigned long long max = wb->bdi->max_ratio;
+
+	/*
+	 * @wb may already be clean by the time control reaches here and
+	 * the total may not include its bw.
+	 */
+	if (this_bw < tot_bw) {
+		if (min) {
+			min *= this_bw;
+			do_div(min, tot_bw);
+		}
+		if (max < 100) {
+			max *= this_bw;
+			do_div(max, tot_bw);
+		}
+	}
+
+	*minp = min;
+	*maxp = max;
+}
+
+#else	/* CONFIG_CGROUP_WRITEBACK */
+
+static void wb_min_max_ratio(struct bdi_writeback *wb,
+			     unsigned long *minp, unsigned long *maxp)
+{
+	*minp = wb->bdi->min_ratio;
+	*maxp = wb->bdi->max_ratio;
+}
+
+#endif	/* CONFIG_CGROUP_WRITEBACK */
+
 /*
  * In a memory zone, there is a certain amount of pages we consider
  * available for the page cache, which is essentially the number of
@@ -539,9 +579,9 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
  */
 unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
 {
-	struct backing_dev_info *bdi = wb->bdi;
 	u64 wb_dirty;
 	long numerator, denominator;
+	unsigned long wb_min_ratio, wb_max_ratio;
 
 	/*
 	 * Calculate this BDI's share of the dirty ratio.
@@ -552,9 +592,11 @@ unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
 	wb_dirty *= numerator;
 	do_div(wb_dirty, denominator);
 
-	wb_dirty += (dirty * bdi->min_ratio) / 100;
-	if (wb_dirty > (dirty * bdi->max_ratio) / 100)
-		wb_dirty = dirty * bdi->max_ratio / 100;
+	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
+
+	wb_dirty += (dirty * wb_min_ratio) / 100;
+	if (wb_dirty > (dirty * wb_max_ratio) / 100)
+		wb_dirty = dirty * wb_max_ratio / 100;
 
 	return wb_dirty;
 }
-- 
2.1.0
