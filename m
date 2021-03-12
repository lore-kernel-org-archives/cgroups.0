From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 07/11] bfq: optimse IO injection for CLASS_RT
Date: Fri, 12 Mar 2021 19:08:41 +0800
Message-ID: <ab86856f91a4734adf9cbf4212adfe2252ddbc57.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=3QEWlUrFLMLaUGl8wHuUk98pwVzXJV4Z6adAvQh0quw=;
        b=AGOaWhDWZN5OxUpAk5V5Je2FjeTyxmmJlwyPNZzcQmCQ+g/rNzmGRA5ryZ1FcaImaO
         jqKkyKDssGkwA3qgyEp4KuNPs4zMC4GInA4VFAlsduFYqPgdxhU9J+tQemyGyTnmT6wN
         XAHdNUtd8/4ReAlRmlcv8q5kQEwJgkJZakU3RNBvTyIu6DVkU13lj6L1Mq0vJyx+MLhk
         qKSmRn52WJ0F12fAviPFMVW7yiDDq0ovLTmUcGvswcGNbaR4daC7yoGG98tgwLtrylEl
         IQ2TNM1RUug/vlh4k9Qoc5dZcyMo8M7VQBVByQcN0SX3C0vpECt3udTKKTHx473mSmdq
         Qkvw==
In-Reply-To: <cover.1615517202.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

CLASS_RT is more sensitive to latency, and IO injection
will increase the CLASS_RT latency. For this reason,
consider prohibiting the injection of async queue for
CLASS_RT, and only the waker queue and other active
queues belonging to CLASS_RT are allowed to inject. In
this way, for CLASS_RT, both the advantages of inject
and IO latency can be maintained.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-iosched.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 8af73473c45c..a5f13589df79 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1965,6 +1965,9 @@ static void bfq_check_waker(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	    bfqd->last_completed_rq_bfqq == bfqq->waker_bfqq)
 		return;
 
+	if (bfq_class_rt(bfqq) && !bfq_class_rt(bfqd->last_completed_rq_bfqq))
+		return;
+
 	if (bfqd->last_completed_rq_bfqq !=
 	    bfqq->tentative_waker_bfqq) {
 		/*
@@ -4391,6 +4394,9 @@ bfq_choose_bfqq_for_injection(struct bfq_data *bfqd)
 			else
 				limit = in_serv_bfqq->inject_limit;
 
+			if (bfq_class_rt(in_serv_bfqq) && !bfq_class_rt(bfqq))
+				continue;
+
 			if (bfqd->rq_in_driver < limit) {
 				bfqd->rqs_injected = true;
 				return bfqq;
@@ -4565,7 +4571,7 @@ static struct bfq_queue *bfq_select_queue(struct bfq_data *bfqd)
 		 * may not be minimized, because the waker queue may
 		 * happen to be served only after other queues.
 		 */
-		if (async_bfqq &&
+		if (async_bfqq && !bfq_class_rt(bfqq) &&
 		    icq_to_bic(async_bfqq->next_rq->elv.icq) == bfqq->bic &&
 		    bfq_serv_to_charge(async_bfqq->next_rq, async_bfqq) <=
 		    bfq_bfqq_budget_left(async_bfqq))
-- 
2.30.0

