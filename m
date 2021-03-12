From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 10/11] bfq: remove unnecessary initialization logic
Date: Fri, 12 Mar 2021 19:08:44 +0800
Message-ID: <dae42cd3c1c9f798a3c390e0a14ef77d02e94ce0.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=T9l6k5OqXtfEirisuPLMZitzFU3x0IHKvGRBmuRDlLQ=;
        b=Gt865lGSosE/T4BW16U1yPG0jYVc3NdxxtP9Pd66qyhtwSv8Q5grSCA5RTm/buM6aL
         9QbLbKH1f8qHAak2n67AjGhs1iL4kBnc1SZmJBzrA8mgMSDEnKJ3FwMC9l0lTFbe90a0
         iY6n13l7NyU5i6HJ5zH75q20VJCRQtXXuM2lD9cx3cZM0k4FBde1K0JS6uJ5IjbAM07J
         mAE/X6bOQkORjeAZ3xiXZBrAGZ4C6ueGaPjCAfhKj+Pc3SjUkf2Fxq0QUJgpEqByJerw
         LCb7b6eTB2PcZ1NG+OlTXFgSXjcQ29I0ulqlfsjC2A/ZaJ2a3UrMIAf8Ty5L+Kembe8r
         g5/Q==
In-Reply-To: <cover.1615517202.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615527324.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Since we will initialize sched_data.service_tree[] in
bfq_init_root_group(), bfq_create_group_hierarchy() can
ignore this part of the initialization, which can avoid
repeated initialization.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index ab4bc410e635..05054e1b5d97 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1514,15 +1514,11 @@ void bfqg_and_blkg_put(struct bfq_group *bfqg) {}
 struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node)
 {
 	struct bfq_group *bfqg;
-	int i;
 
 	bfqg = kmalloc_node(sizeof(*bfqg), GFP_KERNEL | __GFP_ZERO, node);
 	if (!bfqg)
 		return NULL;
 
-	for (i = 0; i < BFQ_IOPRIO_CLASSES; i++)
-		bfqg->sched_data.service_tree[i] = BFQ_SERVICE_TREE_INIT;
-
 	return bfqg;
 }
 #endif	/* CONFIG_BFQ_GROUP_IOSCHED */
-- 
2.30.0

