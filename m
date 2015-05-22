From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/51] writeback: add @gfp to wb_init()
Date: Fri, 22 May 2015 17:13:34 -0400
Message-ID: <1432329245-5844-21-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KFj03sVo1jNXjrBuWycMpR3ZDvxrSibmI5dkpshhozo=;
        b=q+jsQhmIL4XhiKKFJf7+61yVC6HBU/aLIJiwAZU8O5vf5qPik276o90pjqrNxXdhay
         l9B8CdraMLGT8TMmIRhSqjugxbYYkR7AdacHbvNFjndGW2U68nbMgTbO8ikq+WXinGhQ
         +LHLt90SXOMr+0p13JuhDuuEBgt4YW9Zx/W40tHoT82bZsxE9ahj1T0bCwDUoqTUAjNO
         nVnpDzW0foKiR8oSCZbpYeLgAYLsGrRqlcd/SBZe/mDb7Bn7nYymxNcoJhMbHFjirW30
         etAKbP9FRmncFPVDdtYubGBnSTlJyOMRf5QTuhYtvPd4wS6pfaXLwHaQeyjV9Ced3Xrr
         vCNw==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

wb_init() currently always uses GFP_KERNEL but the planned cgroup
writeback support needs using other allocation masks.  Add @gfp to
wb_init().

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
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
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
