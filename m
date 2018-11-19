From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH V2 05/10] block, bfq: align min and default weights with the old cfq default
Date: Mon, 19 Nov 2018 11:34:19 +0100
Message-ID: <20181119103424.3853-6-paolo.valente@linaro.org>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X5boqJ0UbdeKGVE+FnIPUcIjT6rvSPY3NTZlqHlp7eY=;
        b=cOaOohdKAX6mJq3wr2E6Hwafuweehz68ABx+2oXHJV0TZuvr4qoCBxK2dufKJTVwOI
         pIuCn8YJgCmgtwHWw/Bhfhh2VvhLRaaHj0AkzG5SpAmKlDJQv+8kIIsF2MoREcj+qMIQ
         C2MBBTrmNvoV9HHeYBNRnb8XIcdxNvnBM7qSs=
In-Reply-To: <20181119103424.3853-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

bfq exposes a cgroup attribute, weight, with the same meaning as that
exposed by cfq.

This commit changes bfq default and min weights to match the ones set
by cfq (before legacy blk was removed).

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-iosched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 77651d817ecd..249d8128d3ee 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -22,13 +22,13 @@
 #define BFQ_IOPRIO_CLASSES	3
 #define BFQ_CL_IDLE_TIMEOUT	(HZ/5)
 
-#define BFQ_MIN_WEIGHT			1
+#define BFQ_MIN_WEIGHT			10
 #define BFQ_MAX_WEIGHT			1000
 #define BFQ_WEIGHT_CONVERSION_COEFF	10
 
 #define BFQ_DEFAULT_QUEUE_IOPRIO	4
 
-#define BFQ_WEIGHT_LEGACY_DFL	100
+#define BFQ_WEIGHT_LEGACY_DFL	500
 #define BFQ_DEFAULT_GRP_IOPRIO	0
 #define BFQ_DEFAULT_GRP_CLASS	IOPRIO_CLASS_BE
 
-- 
2.16.1

