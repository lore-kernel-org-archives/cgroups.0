From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 7/8] bfq: remove unnecessary initialization logic
Date: Mon,  8 Mar 2021 20:00:20 +0800
Message-ID: <baf6d16ce98ef609c57a324166219003ab77e30c.1615203034.git.brookxu@tencent.com>
References: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=+kTmKHq9zv3XGMbtsWeY32mKkijl5gEMIKMC+s/P+Co=;
        b=DAA7KXeIH95cxgwsQLL5AnnEDn/kBgAQ+5tuUAikWQsPAFy7TklwND3fH5aW5yhbea
         /op2WHfyZ55X8d5bFjKIed2hk+fjfJDUwD3DQzFSs75mmwSUoSY3WEVq1siy5XaT39RH
         gz3K6pIOmcCfftym8RWn9eLHtmKhJDiUtUskevuNA340Fjdb52ceRxWBroZCa/aze5oe
         MTdrD5JXKsVGYKyCcl7ZwPTw+ATAfLC3jxgLF5a+of7I5YfdY9Sq7yw2W/yLycwAkz+/
         qxEbdkfmyc2e1DsH1/EgZEuPGcocmFxjr3cur+FH/miRxBa5WEj2fvpSBQa4ghGO29mS
         fBtA==
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <cover.1615203034.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

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

