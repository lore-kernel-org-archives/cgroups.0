From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2 block/for-6.2] blk-iolatency: Fix memory leak on
 add_disk() failures
Date: Sat, 10 Dec 2022 08:33:10 -1000
Message-ID: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=erjJZ3BPLuF4fh5E96B8USxD9G40KMRBirufYCK/yho=;
        b=m87yCXDKsTffULppu3iMrVZ6qDGYyGYS8EBcgLw4eBJkmuxFpBVOL+7JEw4XErKQGC
         vLtJw+xsdY5BZlrCtOvEQGtNbgh7czgcay3iDqkEGsbY4qDA6JAhhC2RiQiGf63eUABC
         p9+USAbJEUvcTLi71QGdGxt+iPBTZorJbWqNoxIguBi8PAHdHsS1LV+Ib0F4XuB/96Fu
         8yUp988BD3BKPfsWqy4viBsrVQe6N010fxyG8HGst1vYlbmeW/qSYikPO0cUhHobDrDO
         hFAvxy0vvncTEfbkphhPsS0ZkUBk0i0VcT20KQsFijHFyxfG8rtA7mEhMXuDiPy24wFs
         N1/g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, darklight2357@icloud.com, Josef Bacik <josef@toxicpanda.com>, Linus Torvalds <torvalds@linux-foundation.org>, cgroups@vger.kernel.org

When a gendisk is successfully initialized but add_disk() fails such as when
a loop device has invalid number of minor device numbers specified,
blkcg_init_disk() is called during init and then blkcg_exit_disk() during
error handling. Unfortunately, iolatency gets initialized in the former but
doesn't get cleaned up in the latter.

This is because, in non-error cases, the cleanup is performed by
del_gendisk() calling rq_qos_exit(), the assumption being that rq_qos
policies, iolatency being one of them, can only be activated once the disk
is fully registered and visible. That assumption is true for wbt and iocost,
but not so for iolatency as it gets initialized before add_disk() is called.

It is desirable to lazy-init rq_qos policies because they are optional
features and add to hot path overhead once initialized - each IO has to walk
all the registered rq_qos policies. So, we want to switch iolatency to lazy
init too. However, that's a bigger change. As a fix for the immediate
problem, let's just add an extra call to rq_qos_exit() in blkcg_exit_disk().
This is safe because duplicate calls to rq_qos_exit() become noop's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: darklight2357@icloud.com
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Cc: stable@vger.kernel.org # v4.19+
---
Hello,

I'm posting two patches for the iolatency memory leak issue after add_disk()
failure. This one is the immediate fix and should be really safe. However,
any change has risks and given that the bug being address is not critical at
all, I still think it'd make sense to route it through 6.2-rc1 rather than
applying directly to master for 6.1 release. So, it's tagged for the 6.2
merge window.

Thanks.

 block/blk-cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,6 +33,7 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -1322,6 +1323,7 @@ err_unlock:
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk);
+	rq_qos_exit(disk->queue);
 	blk_throtl_exit(disk);
 }
 
