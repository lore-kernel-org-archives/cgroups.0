From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v4 1/5] blk-iocost: check return value of match_u64()
Date: Tue, 17 Jan 2023 15:08:02 +0800
Message-ID: <20230117070806.3857142-2-yukuai1@huaweicloud.com>
References: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

This patch fixs that the return value of match_u64() from ioc_qos_write()
is not checked,

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6955605629e4..f1166582fb64 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3212,7 +3212,8 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 
 		switch (match_token(p, qos_ctrl_tokens, args)) {
 		case QOS_ENABLE:
-			match_u64(&args[0], &v);
+			if (match_u64(&args[0], &v))
+				goto einval;
 			enable = v;
 			continue;
 		case QOS_CTRL:
-- 
2.31.1

