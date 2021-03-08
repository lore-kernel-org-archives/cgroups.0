From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH 2/8] bfq: limit the IO depth of idle_class to 1
Date: Mon,  8 Mar 2021 20:00:15 +0800
Message-ID: <c23ff2bafdf20b3f18debfa1021e59a87aba1a11.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=dJz1mJNUFCu8/5ZpciRC6YOn6iNHDwCBUMOb6meMbWM=;
        b=VCBfFCHPdKB3UhuPOgg2Yl0CKxU24aFecGuDgxFYy0jOzvUcnjdNfbcmGVRaXyDYsa
         bAiaaKxzyJlYvUy/tR1Ko00yth8vjfUTKC5UJRAuxpY3MDubB9tSrc1aJQH0RzlGSkoS
         qbKgJC8o2DnY2wUjKr8IYnXKMvmho0+bDYbqmTbvMwjIgrKrsGc8RiqDSlS54oFkNHmo
         K66njTNaHiGJn5X6kOMvbwlEJjN+GaR5wMqXS2IuW2bmHcy1RPfWh8ZDXGCkIJ6aqRCO
         k/xN3/wy5TdmCEnQTD48QngEyGv+7eeUTE80tgBcGb1HqUS7mqlEntr3zL4n1JLzo7OG
         xYjw==
In-Reply-To: <cover.1615203034.git.brookxu@tencent.com>
In-Reply-To: <cover.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

From: Chunguang Xu <brookxu@tencent.com>

The IO depth of idle_class is limited to 1, so that it can
avoid introducing a larger tail latency under a device with
a larger IO depth. Although limiting the IO depth may reduce
the performance of idle_class, it is generally not a big
problem, because idle_class usually does not have strict
performance requirements.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-iosched.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ec482e6641ff..ea9d7f6f4e3d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4808,6 +4808,17 @@ static struct request *__bfq_dispatch_request(struct blk_mq_hw_ctx *hctx)
 	if (!bfqq)
 		goto exit;
 
+	/*
+	 * Here, the IO depth of idle_class is limited to 1, so that it
+	 * can avoid introducing a larger tail latency under a device
+	 * with a larger IO depth. Although limiting the IO depth may
+	 * reduce the performance of idle_class, it is generally not a
+	 * big problem, because idle_class usually does not have strict
+	 * performance requirements.
+	 */
+	if (bfq_class_idle(bfqq) && bfqq->dispatched)
+		goto exit;
+
 	rq = bfq_dispatch_rq_from_bfqq(bfqd, bfqq);
 
 	if (rq) {
-- 
2.30.0

