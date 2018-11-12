From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 06/12] block, bfq: align min and default weights with cfq
Date: Mon, 12 Nov 2018 10:56:26 +0100
Message-ID: <20181112095632.69114-7-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P3gM8CEth45UYnNHSZF98Zi/zDAo21J+oNJpFvTMXDU=;
        b=F+07G256OoZzsTmnbt0RELuT0heBN/K8A2OrFVYc5axzgzepR5T2xKkZNXlibAtKAJ
         809E2WdhkOSlr2VxSQawiDZ9b1WIzjE9faJ7tuvvOP/NGFenBt5I92R4MWTVciVtbKU9
         TdhCVPR+K7VkxBtuZ276fOv470Q1nrjMDL6vk=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

The I/O schedulers bfq and cfq expose a cgroup attribute with the same
meaning: weight.

This commit changes bfq default and min weights to match the ones set
by cfq.

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

