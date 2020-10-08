From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 4/8] blk-throttle: Fix IO hang for a corner case
Date: Thu,  8 Oct 2020 11:52:25 +0800
Message-ID: <ad720c13c15d7f6c1faa7ca1391c9f4420905f23.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
References: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

It can not scale up in throtl_adjusted_limit() if we set bps or iops is
1, which will cause IO hang when enable low limit. Thus we should treat
1 as a illegal value to avoid this issue.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b0d8f7c..0649bce 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1687,13 +1687,13 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 			goto out_finish;
 
 		ret = -EINVAL;
-		if (!strcmp(tok, "rbps"))
+		if (!strcmp(tok, "rbps") && val > 1)
 			v[0] = val;
-		else if (!strcmp(tok, "wbps"))
+		else if (!strcmp(tok, "wbps") && val > 1)
 			v[1] = val;
-		else if (!strcmp(tok, "riops"))
+		else if (!strcmp(tok, "riops") && val > 1)
 			v[2] = min_t(u64, val, UINT_MAX);
-		else if (!strcmp(tok, "wiops"))
+		else if (!strcmp(tok, "wiops") && val > 1)
 			v[3] = min_t(u64, val, UINT_MAX);
 		else if (off == LIMIT_LOW && !strcmp(tok, "idle"))
 			idle_time = val;
-- 
1.8.3.1

