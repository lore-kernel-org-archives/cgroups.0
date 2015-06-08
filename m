From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/8] cfq-iosched: fix async oom queue handling
Date: Mon,  8 Jun 2015 17:59:27 +0900
Message-ID: <1433753973-23684-3-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1tfbcHMmfxw6nNNfYLYVLmq7fkFTwuO98QnI8Gw2dkk=;
        b=aPJNsShl90dlSDpCgCgkZ29u7xFOCkf0GYOWGYTsrncU0Qs84JYKWF8d8YjzvoGUkE
         B+oNaBOIxpGyOtU4Wwp6y/BKzsRkwqfsjAj8S1q8aV9PCerdAZ3sHmjNuLSRFG7D75JU
         znL9cNtoEg2YZGBhTwg/c44l5SGvlcNjdkUmL53Cv1Rbfrn7aSTwMugUYh4e/4MP7PXy
         aMuUFid8ztFX+Wo+oazyXQuTeySnWYxO7VkaZqAOof5o2YMq6DXMcR+THBLSZa6d+Jf5
         5x/bcF7rebn4OdgRiTYueZKt1oW2V0S9ym7yytqRdFYi7kzAGmOc9MhTg9vUaVCvihX7
         QLnw==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Async cfqq's (cfq_queue's) are shared across cfq_data.  When
cfq_get_queue() obtains a new queue from cfq_find_alloc_queue(), it
stashes the pointer in cfq_data and reuses it from then on; however,
the function doesn't consider that cfq_find_alloc_queue() may return
the oom_cfqq under memory pressure and installs the returned queue
unconditionally.

If the oom_cfqq is installed as an async cfqq, cfq_set_request() will
continue calling cfq_get_queue() hoping to replace it with a proper
queue; however, cfq_get_queue() will keep returning the cached queue
for the slot - the oom_cfqq.

Fix it by skipping caching if the queue is the oom one.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2814bb7..c7b33aa 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3683,7 +3683,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
 	 */
-	if (!is_sync) {
+	if (!is_sync && cfqq != &cfqd->oom_cfqq) {
 		cfqq->ref++;
 		*async_cfqq = cfqq;
 	}
-- 
2.4.2
