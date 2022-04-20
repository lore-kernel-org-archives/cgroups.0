From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/15] blk-cgroup: remove unneeded includes from <linux/blk-cgroup.h>
Date: Wed, 20 Apr 2022 06:27:19 +0200
Message-ID: <20220420042723.1010598-12-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=N20iLcUnxfvG1HpPozYt/60ZT2Vdv9e3jRTpgUOWF1w=; b=XJbf2V2lCOuuEltwK6+sDCYN2p
        /hOxAg7hw6fT03id8ADUEk6yQyzR5c5wqUFwkwnf8cSGrWeEP0/SOa+lMJt3eSbSEh0f1vxPV+IKk
        DrfBjlKr6kP3FH0I+0c4nr85fisZoLjNIyZunnnBoFKL8btiPs+aufbY1iZgy5sxAlhIFyCRw1lOc
        t5oSEdRvbzQXqJVPyD+5SZWIqwFeWrq+KEU+9AkA4vAgDA8naNcDBWQyt3NW8se3h1bIoi1IN/6p3
        StnBXXBUn9lLQBOP2085O3heS0HC/p2n0gLPqsbPcyQgPz/khzHtQ/MMOc93igBxrGKS7eMQku64c
        WQRrmIrA==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Remove all the includes that aren't actually needed from
<linux/blk-cgroup.h> and push them to the actual source files where
needed.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.h         |  2 ++
 include/linux/blk-cgroup.h | 15 +++++----------
 mm/backing-dev.c           |  1 +
 mm/readahead.c             |  1 +
 mm/swapfile.c              |  1 +
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index a948f4eb0bff8..62ed8ed50b6e3 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -15,6 +15,8 @@
  */
 
 #include <linux/blk-cgroup.h>
+#include <linux/cgroup.h>
+#include <linux/kthread.h>
 #include <linux/blk-mq.h>
 
 struct blkcg_gq;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index abbfa97d6d46f..9f40dbc65f82c 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -14,16 +14,11 @@
  * 	              Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
  */
 
-#include <linux/cgroup.h>
-#include <linux/percpu.h>
-#include <linux/percpu_counter.h>
-#include <linux/u64_stats_sync.h>
-#include <linux/seq_file.h>
-#include <linux/radix-tree.h>
-#include <linux/blkdev.h>
-#include <linux/atomic.h>
-#include <linux/kthread.h>
-#include <linux/fs.h>
+#include <linux/types.h>
+
+struct bio;
+struct cgroup_subsys_state;
+struct request_queue;
 
 #define FC_APPID_LEN              129
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 98f8f62e52ca5..ff60bd7d74e07 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/blkdev.h>
 #include <linux/wait.h>
 #include <linux/rbtree.h>
 #include <linux/kthread.h>
diff --git a/mm/readahead.c b/mm/readahead.c
index 8e3775829513e..c93671a2bf0f7 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -113,6 +113,7 @@
  * ->readpage() which may be less efficient.
  */
 
+#include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include <linux/dax.h>
 #include <linux/gfp.h>
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a2b31fea0c42e..981a6e85c88e7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -6,6 +6,7 @@
  *  Swap reorganised 29.12.95, Stephen Tweedie
  */
 
+#include <linux/blkdev.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
-- 
2.30.2

