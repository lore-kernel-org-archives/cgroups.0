From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 15/16] writeback: add @gfp to wb_init()
Date: Tue,  6 Jan 2015 14:29:16 -0500
Message-ID: <1420572557-11572-16-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aJBBr3ibH+p9NYUFZiUd/NAkp6PDYHM9KxqoiISJRIc=;
        b=VcTKJ9gzPyH8EaeaJ71rxmMl38LngOl/Uw2mELg2Eo6nbpSznTvtWN6E5ffcTUXwrk
         bYyH7NNDdWEZHK8zIKubKv9rc5cdbHowdXspyhJiULMfBhTYEtCGRl0Z24BlLoil7LTY
         wk9lIjeKmZt+QKB4FUboUZqJDQHHSREeaD3evol6/lZDBO5oc+ivicKORVp0ac4qai5L
         1/xRwAn9ZSKNKelP9QUa2cmN5QGDU94QioLdB6WA8+B6oWFG8gyy1jGkQiC3O6w/dNp4
         jlBwsRvryjHp4C2EAwREW3Ts9ESKtiQkfMPNGTz+nXQi877bp4gtayB4lRkUM7ecItVJ
         kAbw==
In-Reply-To: <1420572557-11572-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

wb_init() currently always uses GFP_KERNEL but the planned cgroup
writeback support needs using other allocation masks.  Add @gfp to
wb_init().

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 mm/backing-dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a98a957..1c9b70e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -342,7 +342,8 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
-static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
+		   gfp_t gfp)
 {
 	int i, err;
 
@@ -365,12 +366,12 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
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
@@ -450,7 +451,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
 
-	err = wb_init(&bdi->wb, bdi);
+	err = wb_init(&bdi->wb, bdi, GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.1.0
