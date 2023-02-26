From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 6.1 08/21] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Sat, 25 Feb 2023 22:42:43 -0500
Message-ID: <20230226034256.771769-8-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382992;
        bh=/KPj3m1KPxfGMtW8xapjQpJ0dfmXm9YDZiWr49pG+no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMPZFALqkV6ZOdd6vlFbSfOv5okMdZ7SS49sB+FcoXVYn8VgLikORNC2yO79yWfuh
         LAdHOQgW/gqJapk11eR+c0pWJoyZA1oZOGdxOdkRNSsep4D8+wu7FKKxVGxDVdiCMp
         fVfLjRyeUSH+ggloBG29KNTEHcLKvjU5Id1MOAlrQ9XA0Ati2LDVGSwirfhByt/ej9
         4g9q4MHKUSUjAHMsekx+Z0fXiMCsgHl35SmaxAHvi2z18l3DGfZ2kt31U9lYAT6a6g
         k21i2ws6huTdCa5eboc0Y/TfOCM6YaW4hJ17k7MbAKLQLbnmZnjU0KzbQXV4VnRHmB
         EfMdXsZHjN7RQ==
In-Reply-To: <20230226034256.771769-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit 984af1e66b4126cf145153661cc24c213e2ec231 ]

echo max of u64 to cost.model can cause divide by 0 error.

  # echo 8:0 rbps=18446744073709551615 > /sys/fs/cgroup/io.cost.model

  divide error: 0000 [#1] PREEMPT SMP
  RIP: 0010:calc_lcoefs+0x4c/0xc0
  Call Trace:
   <TASK>
   ioc_refresh_params+0x2b3/0x4f0
   ioc_cost_model_write+0x3cb/0x4c0
   ? _copy_from_iter+0x6d/0x6c0
   ? kernfs_fop_write_iter+0xfc/0x270
   cgroup_file_write+0xa0/0x200
   kernfs_fop_write_iter+0x17d/0x270
   vfs_write+0x414/0x620
   ksys_write+0x73/0x160
   __x64_sys_write+0x1e/0x30
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

calc_lcoefs() uses the input value of cost.model in DIV_ROUND_UP_ULL,
overflow would happen if bps plus IOC_PAGE_SIZE is greater than
ULLONG_MAX, it can cause divide by 0 error.

Fix the problem by setting basecost

Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Link: https://lore.kernel.org/r/20230117070806.3857142-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org
Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 495396425bade..bfc33fa9a063c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -865,9 +865,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
 	*page = *seqio = *randio = 0;
 
-	if (bps)
-		*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
-					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
+	if (bps) {
+		u64 bps_pages = DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);
+
+		if (bps_pages)
+			*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps_pages);
+		else
+			*page = 1;
+	}
 
 	if (seqiops) {
 		v = DIV64_U64_ROUND_UP(VTIME_PER_SEC, seqiops);
-- 
2.39.0

