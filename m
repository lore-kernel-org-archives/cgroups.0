From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 4/4] blk-cgroup: Document the design of new lockless iostat_cpu list
Date: Thu,  2 Jun 2022 14:54:01 -0400
Message-ID: <20220602185401.162937-1-longman@redhat.com>
References: <20220602133543.128088-2-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654196058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1q/cIPahB7x9FEDPxFfUSaoR08YIuoc7nswOzy1p8SY=;
        b=dTpMlOO83c5Y1suOynwWqWT351q4PZoO1kF4l2M2DHtHX0wCAJnTHAVBXHW/T7/JINMXFF
        88uIQCUCVgSjqoVu8G3RtaOZRa7aFnBGnunQdZqjHBQGp+k0XACPjP4AoCidNPTR3KyG+6
        AVOw/rVDz1Pq+f16v20i2FgTJcHgIdE=
In-Reply-To: <20220602133543.128088-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

A set of percpu lockless lists per block cgroup (blkcg) is added to
track the set of recently updated iostat_cpu structures. Add comment
in the code to document the design of this new set of lockless lists.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8af97f3b2fc9..f8f27551c16a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -60,6 +60,21 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
 #define BLKG_DESTROY_BATCH_SIZE  64
 
 /*
+ * Lockless lists for tracking IO stats update
+ *
+ * New IO stats are stored in the percpu iostat_cpu within blkcg_gq (blkg).
+ * There are multiple blkg's (one for each block device) attached to each
+ * blkcg. The rstat code keeps track of which cpu has IO stats updated,
+ * but it doesn't know which blkg has the updated stats. If there are many
+ * block devices in a system, the cost of iterating all the blkg's to flush
+ * out the IO stats can be high. To reduce such overhead, a set of percpu
+ * lockless lists (lhead) per blkcg are used to track the set of recently
+ * updated iostat_cpu's since the last flush. An iostat_cpu will be put
+ * onto the lockless list on the update side [blk_cgroup_bio_start()] if
+ * not there yet and then removed when being flushed [blkcg_rstat_flush()].
+ * References to blkg are gotten and then put back in the process to
+ * protect against blkg removal.
+ *
  * lnode.next of the last entry in a lockless list is NULL. To enable us to
  * use lnode.next as a boolean flag to indicate its presence in a lockless
  * list, we have to make it non-NULL for all. This is done by using a
-- 
2.31.1

