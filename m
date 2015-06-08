From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/8] cfq-iosched: simplify control flow in cfq_get_queue()
Date: Mon,  8 Jun 2015 17:59:26 +0900
Message-ID: <1433753973-23684-2-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8GzFgzGaJlXIbo4Aiuvz+bN7VJ8istvOTGlFfyTDdJw=;
        b=wGSxsBq7HhTeowSmzy98pJRX/9EPKGDox5s6stme3a3oaQKlaIj/IUivOpaALcNq64
         JS22fmqcZ1lrull97NbFo/KK6dy1QhntBPN/7Sj0n5PA9mQYzSN1qlMH243asPuhy9Zm
         NmWgPmG3+GYf9/SXhu/w4ApNCM01qTHpjf0KeDRtRHfLXdChBw7j9FyJqNnJ6kd97xdO
         qZNgDusNTyOA3ipTpa6MMn09ZE5mgENw+su1gdt43l3R4v9ffHZX5TT6oWUvIEX0s6MM
         L2RK931B6w1jXF7dXvxeWZdutD7Py4zUHEmwKG23K30uiTTc1U2Cg7SSBwu4eYSQQBub
         a0oQ==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cfq_get_queue()'s control flow looks like the following.

	async_cfqq = NULL;
	cfqq = NULL;

	if (!is_sync) {
		...
		async_cfqq = ...;
		cfqq = *async_cfqq;
	}

	if (!cfqq)
		cfqq = ...;

	if (!is_sync && !(*async_cfqq))
		...;

The only thing the local variable init, the second if, and the
async_cfqq test in the third if achieves is to skip cfqq creation and
installation if *async_cfqq was already non-NULL.  This is needlessly
complicated with different tests examining the same condition.
Simplify it to the following.

	if (!is_sync) {
		...
		async_cfqq = ...;
		cfqq = *async_cfqq;
		if (cfqq)
			goto out;
	}

	cfqq = ...;

	if (!is_sync)
		...;
 out:

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index bc8f429..2814bb7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3663,8 +3663,8 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
-	struct cfq_queue **async_cfqq = NULL;
-	struct cfq_queue *cfqq = NULL;
+	struct cfq_queue **async_cfqq;
+	struct cfq_queue *cfqq;
 
 	if (!is_sync) {
 		if (!ioprio_valid(cic->ioprio)) {
@@ -3674,19 +3674,20 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 		}
 		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
 		cfqq = *async_cfqq;
+		if (cfqq)
+			goto out;
 	}
 
-	if (!cfqq)
-		cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
+	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
 	 */
-	if (!is_sync && !(*async_cfqq)) {
+	if (!is_sync) {
 		cfqq->ref++;
 		*async_cfqq = cfqq;
 	}
-
+out:
 	cfqq->ref++;
 	return cfqq;
 }
-- 
2.4.2
