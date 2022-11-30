From: Li Nan <linan122@huawei.com>
Subject: [PATCH -next v2 2/9] blk-iocost: improve hanlder of match_u64()
Date: Wed, 30 Nov 2022 21:21:49 +0800
Message-ID: <20221130132156.2836184-3-linan122@huawei.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20221130132156.2836184-1-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

1) There are one place that return value of match_u64() is not checked.
2) If match_u64() failed, return value is set to -EINVAL despite that
   there are other possible errnos.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Li Nan <linan122@huawei.com>
---
 block/blk-iocost.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index fd495e823db2..c532129a1456 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3202,6 +3202,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		substring_t args[MAX_OPT_ARGS];
 		char buf[32];
 		int tok;
+		int err;
 		s64 v;
 
 		if (!*p)
@@ -3209,7 +3210,12 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 
 		switch (match_token(p, qos_ctrl_tokens, args)) {
 		case QOS_ENABLE:
-			match_u64(&args[0], &v);
+			err = match_u64(&args[0], &v);
+			if (err) {
+				ret = err;
+				goto out_unlock;
+			}
+
 			enable = v;
 			continue;
 		case QOS_CTRL:
@@ -3238,8 +3244,12 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 			break;
 		case QOS_RLAT:
 		case QOS_WLAT:
-			if (match_u64(&args[0], &v))
+			err = match_u64(&args[0], &v);
+			if (err) {
+				ret = err;
 				goto out_unlock;
+			}
+
 			qos[tok] = v;
 			break;
 		case QOS_MIN:
@@ -3374,6 +3384,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		substring_t args[MAX_OPT_ARGS];
 		char buf[32];
 		int tok;
+		int err;
 		u64 v;
 
 		if (!*p)
@@ -3399,8 +3410,13 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		tok = match_token(p, i_lcoef_tokens, args);
 		if (tok == NR_I_LCOEFS)
 			goto out_unlock;
-		if (match_u64(&args[0], &v))
+
+		err = match_u64(&args[0], &v);
+		if (err) {
+			ret = err;
 			goto out_unlock;
+		}
+
 		u[tok] = v;
 		user = true;
 	}
-- 
2.31.1

