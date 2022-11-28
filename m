From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 2/8] blk-iocost: improve hanlder of match_u64()
Date: Mon, 28 Nov 2022 23:44:28 +0800
Message-ID: <20221128154434.4177442-3-linan122@huawei.com>
References: <20221128154434.4177442-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221128154434.4177442-1-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

1) There are one place that return value of match_u64() is not checked.
2) If match_u64() failed, return value is set to -EINVAL despite that
   there are other possible errnos.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

