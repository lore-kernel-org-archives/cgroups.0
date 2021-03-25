From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v3 14/14] bfq: optimize the calculation of bfq_weight_to_ioprio()
Date: Thu, 25 Mar 2021 14:57:58 +0800
Message-ID: <0d36b7d249e0890298e222424f524d3f9bfedbc8.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=o1CvHWMNIVE9JRrHuZNAemnGtuIBJ5AIryKfD1r6v+8=;
        b=WhK2TyCXaTs5nWrXgXWnQsFcAVspW+OYbTmTY1PFOrUpXe7RBtPozCnn0xEc5Qy4eE
         8yfrTdCLndDjDf18f4IOpLauyPoXRE/W0828gduqXyl2vBp06UZ77uoCknocQdBk5inR
         dfNe8bQuUdeiTFpTuvsJfP2XKBgDX0Egzn4Rq0agjFHydy27vVfUhGMbaOginJwoFTPo
         Ke4/UfL/shnb3yXKJjIRHHnJNqWiPIK0Ji1Qx+yKkYUngmycm82Xrm4ew4b9SoWVJwF6
         70BDWtIclqhyQxdyAlby3e7B347wzJf2UMdFXxokiZ/6XhkiWAwcn1uf8mV5sNsb90Zg
         vE5Q==
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
In-Reply-To: <cover.1616649216.git.brookxu@tencent.com>
References: <cover.1616649216.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

The value range of ioprio is [0, 7], but the result of
bfq_weight_to_ioprio() may exceed this range, so simple
optimization is required.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-wf2q.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index b477a9b..1b91c8b 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -586,8 +586,9 @@ unsigned short bfq_ioprio_to_weight(int ioprio)
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
1.8.3.1

