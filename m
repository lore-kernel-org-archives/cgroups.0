From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/48] writeback: add @gfp to wb_init()
Date: Mon, 23 Mar 2015 00:54:29 -0400
Message-ID: <1427086499-15657-19-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3gU6/PBAYF7/rqNNM22E2oDv5E2nGm6cv6g7MeNqnoY=;
        b=BTHoj8C1T17ZWEUvQxFDARoSL22WmBc7paiThqGeu7INNb88seNM8aipnrDSTWuv4X
         d96E+5WMO8nUutJFZAJyi3MpmlM6Df+TgtwUF+zzMVFh8w8e46HtBvc/opLld72BC4KJ
         USZ0HcH2LKPnB6z67sxMbNcikISyDg/oGrWLnZKW1c9EHU9znQeg9cFTI8NFZ0i4975r
         RGJBpxHoWuWHUoL9ifArQX6xAQdSj9MupVxnMtZLqAxAVy96wxf5mIIpxvnA09qkrlcB
         uTOHYEKsEtOFz++WFF5LV6ZzhTHCmOss4nsngo0P3gGVcMrs5XSlJ1oYD1QWcAA1T6ru
         TJEw==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

wb_init() currently always uses GFP_KERNEL but the planned cgroup
writeback support needs using other allocation masks.  Add @gfp to
wb_init().

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b0707d1..805b287 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -291,7 +291,8 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
-static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
+		   gfp_t gfp)
 {
 	int i, err;
 
@@ -315,12 +316,12 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->work_list);
 	INIT_DELAYED_WORK(&wb->dwork, wb_workfn);
 
-	err = fprop_local_init_percpu(&wb->completions, GFP_KERNEL);
+	err = fprop_local_init_percpu(&wb->completions, gfp);
 	if (err)
 		return err;
 
 	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
-		err = percpu_counter_init(&wb->stat[i], 0, GFP_KERNEL);
+		err = percpu_counter_init(&wb->stat[i], 0, gfp);
 		if (err) {
 			while (--i)
 				percpu_counter_destroy(&wb->stat[i]);
@@ -378,7 +379,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
 
-	err = wb_init(&bdi->wb, bdi);
+	err = wb_init(&bdi->wb, bdi, GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.1.0
