From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/15] cfq-iosched: Make cfq_scale_slice() usable for both queues and groups
Date: Mon,  1 Oct 2012 15:32:49 -0400
Message-ID: <1349119976-26837-9-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Make cfq_scale_slice() usable both for queues and groups by taking in
weight as a parameter.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7a65e12..a929e2d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -856,12 +856,12 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
-static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+static inline u64 cfq_scale_slice(unsigned long delta, unsigned int weight)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * CFQ_WEIGHT_DEFAULT;
-	do_div(d, cfqg->weight);
+	do_div(d, weight);
 	return d;
 }
 
@@ -1302,7 +1302,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_group_st_del(st, cfqg);
-	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
+	cfqg->vdisktime += cfq_scale_slice(charge, cfqg->weight);
 	/* If a new weight was requested, update now, off tree */
 	cfq_group_st_add(st, cfqg);
 
-- 
1.7.7.6
