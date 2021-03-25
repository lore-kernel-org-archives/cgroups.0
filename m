From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 08/14] bfq: introduce prio_expire flag for bfq_queue
Date: Thu, 25 Mar 2021 14:57:52 +0800
Message-ID: <31127a6ea5fd65c63e2327d1a4820d948d5a222e.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=JuEIKTyHIE6982Ro7ODwPRKbvkHbUMFr2p3n7zNL9q0=;
        b=tXTbr0x/J8iMTNXhIN/eItlxYhN0ex4ZfyKs5H2Ae3cPdXD1LL6rXlNsg7pJg7tcin
         SlFq7ogSnGJWQIEtXORUp1g3HuUV4CxNAvLucGkYZhqUSRSWzUlJ44XbSGWdXQNSYuBH
         76St25IXwzMTnLNDtoV9QtSTbaKb4gqbCTaKsx3FmOO89cwOdTWo6x7mXsxvrSv3FdPg
         RpryhaiGBlL/D0O6a1mS1Jq2cJlm+mqmwng1xTrO2/IlG/gLi8CGKXVzTN0QvZU8q5IY
         6z2piJav06VPmjssz3Bxoz6GJsV4FlTV2kTKnQSGX/rTMq57n6Qrrnu4mZ239oo5LSYv
         YrWQ==
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1616649216.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

When in_service_queue needs to be preempted by task with
a higher priority, we will mark it with prio_expire flag,
and then expire it on the IO dispatch path. Here add
prio_expire flag only.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-iosched.c | 2 ++
 block/bfq-iosched.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e7bc5e2..6e19b5a 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -153,6 +153,7 @@
 BFQ_BFQQ_FNS(wait_request);
 BFQ_BFQQ_FNS(non_blocking_wait_rq);
 BFQ_BFQQ_FNS(fifo_expire);
+BFQ_BFQQ_FNS(prio_expire);
 BFQ_BFQQ_FNS(has_short_ttime);
 BFQ_BFQQ_FNS(sync);
 BFQ_BFQQ_FNS(IO_bound);
@@ -2986,6 +2987,7 @@ static void __bfq_set_in_service_queue(struct bfq_data *bfqd,
 {
 	if (bfqq) {
 		bfq_clear_bfqq_fifo_expire(bfqq);
+		bfq_clear_bfqq_prio_expire(bfqq);
 
 		bfqd->budgets_assigned = (bfqd->budgets_assigned * 7 + 256) / 8;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 674de8b..8af5ac0 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -777,6 +777,7 @@ enum bfqq_state_flags {
 				     * without idling the device
 				     */
 	BFQQF_fifo_expire,	/* FIFO checked in this slice */
+	BFQQF_prio_expire,	/* should expire for higher prio queue*/
 	BFQQF_has_short_ttime,	/* queue has a short think time */
 	BFQQF_sync,		/* synchronous queue */
 	BFQQF_IO_bound,		/*
@@ -806,6 +807,7 @@ enum bfqq_state_flags {
 BFQ_BFQQ_FNS(wait_request);
 BFQ_BFQQ_FNS(non_blocking_wait_rq);
 BFQ_BFQQ_FNS(fifo_expire);
+BFQ_BFQQ_FNS(prio_expire);
 BFQ_BFQQ_FNS(has_short_ttime);
 BFQ_BFQQ_FNS(sync);
 BFQ_BFQQ_FNS(IO_bound);
-- 
1.8.3.1

