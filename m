From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 8/8] bfq: optimize the calculation of bfq_weight_to_ioprio()
Date: Mon,  8 Mar 2021 20:00:21 +0800
Message-ID: <cbd1e689ca0010c3d437f22c904f10b123e6b1f4.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=MsMrEc4lTH47pfPngVwGfQNjeTIkU6svvwLN8Qg8P28=;
        b=mUhvT0FPrBG4HiXW7y9J5WZyUFm+kOkubtMISyASrxvxjTNSoam06f4EeFpOTS9Wuu
         thpfbVouSfVT7cXTmuRE0ohBa+/AQ9VhaFZOlbfshF66qKj3i/jrFp+7PmvcXJTYmWMH
         Oq0ZYBzYVY1mLPzsORhJjSK+oXkkGmW1g9lLklufsnikuAli+fxEkJopncvjQS5IQswZ
         nviudM05sIkbc5fpXP1pyW6CIgEfa8C2NDWAtX9Wh9JBwl+9SpRfaWAPVhT1gIfrWqqn
         EPlA51MNz2CDinh4BlhkmljgFeXQQan01LmYCGkmcL8xscJQxoRNLfPAzXVfKUv7KcaA
         3Rvw==
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

The value range of ioprio is [0, 7], but the result of
bfq_weight_to_ioprio() may exceed this range, so simple
optimization is required.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-wf2q.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 850a8e2f0bda..1d565daf516f 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -536,8 +536,9 @@ unsigned short bfq_ioprio_to_weight(int ioprio)
  */
 static unsigned short bfq_weight_to_ioprio(int weight)
 {
-	return max_t(int, 0,
-		     IOPRIO_BE_NR * BFQ_WEIGHT_CONVERSION_COEFF - weight);
+	int ioprio = IOPRIO_BE_NR  - weight / BFQ_WEIGHT_CONVERSION_COEFF;
+
+	return ioprio < 0 ? 0 : min_t(int, ioprio, IOPRIO_BE_NR - 1);
 }
 
 static void bfq_get_entity(struct bfq_entity *entity)
-- 
2.30.0

