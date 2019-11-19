From: Xianting Tian <xianting_tian@126.com>
Subject: [PATCH] bfq: Replace kmalloc_node with kzalloc_node
Date: Tue, 19 Nov 2019 10:02:26 -0500
Message-ID: <1574175746-8809-1-git-send-email-xianting_tian@126.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ECh/gxGvyp9KSqXajL
        yZib+zF6gPBMDIeYZREp09BV4=; b=lI9rukbzWZ6xgpv1+CFDPY6+fj9Ivfp2JU
        Bljz1Y6yJsW4Bcj8k8VczsLLdQpMwGQ22GX9Yl1/cPzGzMCJx1tnt63brEUshgqx
        LAhZV1mMpc0A5dHWeW/+El2RKQchrLG2Y861Grsq55zDUEXLDnp6nv+iAVTRBs9p
        zd1pGJbcg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Replace kmalloc_node with kzalloc_node

Signed-off-by: Xianting Tian <xianting_tian@126.com>
---
 block/bfq-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 86a607c..9a84d79 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1385,7 +1385,7 @@ struct bfq_group *bfq_create_group_hierarchy(struct bfq_data *bfqd, int node)
 	struct bfq_group *bfqg;
 	int i;
 
-	bfqg = kmalloc_node(sizeof(*bfqg), GFP_KERNEL | __GFP_ZERO, node);
+	bfqg = kzalloc_node(sizeof(*bfqg), GFP_KERNEL, node);
 	if (!bfqg)
 		return NULL;
 
-- 
1.8.3.1

