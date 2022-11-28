From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 5/8] blk-iocost: fix divide by 0 error in calc_lcoefs()
Date: Mon, 28 Nov 2022 23:44:31 +0800
Message-ID: <20221128154434.4177442-6-linan122@huawei.com>
References: <20221128154434.4177442-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221128154434.4177442-1-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

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
ULLONG_MAX, it can cause divide by 0 error.I_LCOEF_MAX is introduced to
prevent it.

Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a645184aba4a..a4fa17ebb2fa 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -306,6 +306,9 @@ enum {
 	IOC_PAGE_SIZE		= 1 << IOC_PAGE_SHIFT,
 	IOC_SECT_TO_PAGE_SHIFT	= IOC_PAGE_SHIFT - SECTOR_SHIFT,
 
+	/* avoid overflow */
+	I_LCOEF_MAX		= ULLONG_MAX - IOC_PAGE_SIZE,
+
 	/* if apart further than 16M, consider randio for linear model */
 	LCOEF_RANDIO_PAGES	= 4096,
 };
@@ -3431,6 +3434,8 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 			goto out_unlock;
 		}
 
+		if (v > I_LCOEF_MAX)
+			goto out_unlock;
 		u[tok] = v;
 		user = true;
 	}
-- 
2.31.1

