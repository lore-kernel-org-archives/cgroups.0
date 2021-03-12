From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH v2 11/11] bfq: optimize the calculation of bfq_weight_to_ioprio()
Date: Fri, 12 Mar 2021 19:08:45 +0800
Message-ID: <29efad299fd111b38ad215dcbc6eb506290e7937.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ZEYL/pbFIoRQQHylJZyb6mvpBG/vJ0CzVs8U+fDkQms=;
        b=fDVgcd6CradPpZOVQhUMVl1zY6XDbhFqMkk4LY+ex6E56v/JqmtuN+XcpqYkN0QxU8
         eOv3acgR/VQTPgS+YCZlSYLiwXSLKMSCBcguGL40LJ6EOBXrvWHegtWndkARFq8ZVQ1Q
         rcJ99csDt8f0DX2tAYsw0iJ4T2CAGL66fx6rvQx6PEz0Nkzo/KfWE0Gam//0TeEtYzZQ
         xvyYfViiR6iAuln08vPKuT+id9NBl+Zwu2JJxZEkOEZ8/RXIKj9UtpWHvAv0zuLkfupT
         Elq1xJxBCFfVQidEQUGLC1gcHQbQXy/EIcmK0WTWhplSm0Ak+/hgpJf3MjptOgn7T/fg
         O07Q==
In-Reply-To: <cover.1615517202.git.brookxu@tencent.com>
In-Reply-To: <cover.1615527324.git.brookxu@tencent.com>
References: <cover.1615527324.git.brookxu@tencent.com>
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
index f6c67a80e454..86558a8fede1 100644
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

