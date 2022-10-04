From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 2/3] blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
Date: Tue,  4 Oct 2022 11:17:47 -0400
Message-ID: <20221004151748.293388-3-longman@redhat.com>
References: <20221004151748.293388-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664896690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FkptcB12HL5wUxg8krwHfAYvchewTp4XjnIeno+kUJ0=;
        b=FpgO2FAHf02cGT8F8XvVl4SfpxHuyb4u2bB4FjO+vxHmtW5/YfwBVn7t/gj3QHbnOut+GS
        xfO/5i87eZ4VrMgFhzgmx1nHOteh80YlQBSY6PAbRBBVFSz0P44VLrya5H7OxZzhs2MTvf
        +0ID9cmWwE7g9IzePfnPjVesJgp6s2Q=
In-Reply-To: <20221004151748.293388-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
Simplify error handling code by returning this error directly instead
of setting an intermediate "ret" variable.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 869af9d72bcf..946592249795 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1177,7 +1177,6 @@ static struct cgroup_subsys_state *
 blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct blkcg *blkcg;
-	struct cgroup_subsys_state *ret;
 	int i;
 
 	mutex_lock(&blkcg_pol_mutex);
@@ -1186,10 +1185,8 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		blkcg = &blkcg_root;
 	} else {
 		blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
-		if (!blkcg) {
-			ret = ERR_PTR(-ENOMEM);
+		if (!blkcg)
 			goto unlock;
-		}
 	}
 
 	for (i = 0; i < BLKCG_MAX_POLS ; i++) {
@@ -1206,10 +1203,9 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 			continue;
 
 		cpd = pol->cpd_alloc_fn(GFP_KERNEL);
-		if (!cpd) {
-			ret = ERR_PTR(-ENOMEM);
+		if (!cpd)
 			goto free_pd_blkcg;
-		}
+
 		blkcg->cpd[i] = cpd;
 		cpd->blkcg = blkcg;
 		cpd->plid = i;
@@ -1238,7 +1234,7 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		kfree(blkcg);
 unlock:
 	mutex_unlock(&blkcg_pol_mutex);
-	return ret;
+	return ERR_PTR(-ENOMEM);
 }
 
 static int blkcg_css_online(struct cgroup_subsys_state *css)
-- 
2.31.1

