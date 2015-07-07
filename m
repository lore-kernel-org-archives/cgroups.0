From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/9] cfq-iosched: simplify control flow in cfq_get_queue()
Date: Tue,  7 Jul 2015 11:35:53 -0400
Message-ID: <1436283361-3889-2-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QuxrYPag2EB9UZ8SVqfcutfxr00RR77M7xHeJQKcIO0=;
        b=FtTMoKigjJOGeVdZfhziHvCbINV0HCPhoc8X5WwJEgCZDKN2h1k2XW5+TmZMOxQnB4
         2H+rK7ya0/9c88x+PC1d6yHY64TQL/ceZPQZalU+grNAsREH2ufsNF+kNSzZpwb6S+0V
         Wu5YhVDoPvVPWBX/qei3DgtiQWNbufxtfx332Yw/cvTVmQk1qan4YfCfbc+vKnBnIUkr
         Waz+rXbOfwqybhYJy92ocix6afR9SgTOM6KC9pdBMA4MRG1M9sm+S32IJZeEYLcs2bDa
         tuKcabLGf++fRk5bGgI+kBkfKxnEQb1fjjhGVvMvfhdf/pmi/YpeAeGg0LeZHuscVsoa
         AxXQ==
In-Reply-To: <1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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
Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c62bb2e..e91093d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3731,8 +3731,8 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
-	struct cfq_queue **async_cfqq = NULL;
-	struct cfq_queue *cfqq = NULL;
+	struct cfq_queue **async_cfqq;
+	struct cfq_queue *cfqq;
 
 	if (!is_sync) {
 		if (!ioprio_valid(cic->ioprio)) {
@@ -3742,19 +3742,20 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
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
2.4.3
