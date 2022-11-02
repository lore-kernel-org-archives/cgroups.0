From: Yuwei Guan <ssawgyw@gmail.com>
Subject: [PATCH 2/5] block, bfq: remove unused bfq_log_bfqg
Date: Wed,  2 Nov 2022 19:43:51 +0800
Message-ID: <20221102114354.162-3-Yuwei.Guan@zeekrlife.com>
References: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OL88kv80oEtPFlhgWDeAL7//i16MAHkHlHkRbfyZx1Q=;
        b=FOPNzZy38c/VAGwXAxbK8HSyAK8zPJuDMlM+oR1AmBZx207mlxlXpuUbYs0Sm6zN0I
         FDZH8eBGDg2obX+2T3dbYTpgJlOqIMFI1y9Sa1Fej4zAOOb5BtprFj/hvqjcCcWcNDLd
         bhE++hmOrDAw8Qhjp26M2xX+pmgpFZ6l4TXVgkM82ov2t6F4nhwSqsU44JSZQulA06Vn
         sg4H9s34WmpH8s2GwyoHGWRBH/yhsbEg55TY6UTHaP6SYgH9tvuyXwUS76+WgwfH87DK
         +NHcjOJrhWFy/oF5nsITm20Hve7ACJzLz1Iw3aj3z0OM7gpgJVAlWpdRmKk7F5PxmGMY
         4Ktw==
In-Reply-To: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yuwei.Guan@zeekrlife.com

No callers left of bfq_log_bfqg, so remove it.

Signed-off-by: Yuwei Guan <Yuwei.Guan@zeekrlife.com>
---
 block/bfq-iosched.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 3de849e97e4e..256a9d267204 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1103,11 +1103,6 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 			"%s " fmt, pid_str, ##args);			\
 } while (0)
 
-#define bfq_log_bfqg(bfqd, bfqg, fmt, args...)	do {			\
-	blk_add_cgroup_trace_msg((bfqd)->queue,				\
-		&bfqg_to_blkg(bfqg)->blkcg->css, fmt, ##args);		\
-} while (0)
-
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
 #define bfq_log_bfqq(bfqd, bfqq, fmt, args...) do {	\
@@ -1117,7 +1112,6 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq);
 	bfq_bfqq_name((bfqq), pid_str, MAX_BFQQ_NAME_LENGTH);		\
 	blk_add_trace_msg((bfqd)->queue, "%s " fmt, pid_str, ##args);	\
 } while (0)
-#define bfq_log_bfqg(bfqd, bfqg, fmt, args...)		do {} while (0)
 
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
-- 
2.34.1

