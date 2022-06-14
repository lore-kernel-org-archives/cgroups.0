From: Guoqing Jiang <guoqing.jiang-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH] block: update comment for blkcg_init_queue
Date: Tue, 14 Jun 2022 18:05:56 +0800
Message-ID: <20220614100556.20899-1-guoqing.jiang@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655201164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GTMScp+nfQrh9LZR7Rnix9tWdvmjglsycVb9AO//NiI=;
        b=ohrUS6cI+TdOOoC7vg7EsWgZfarq4Fbd6sazsDnmVsMnwPryoLRA63EWd6S4bA/RbOKWJ1
        6ngjdFhrFlixB6SUDdwg+DL8ZUGtQ3262duv4Xh4xrhjlqManyQmc7MF+ERVxTDDG/80Xf
        Vr/66fEpj6JFDgtjaOySUGph8xaFArI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It was called from __alloc_disk_node since commit 1059699f87eb ("block:
move blkcg initialization/destroy into disk allocation/release handler).
Let's change the comment accordingly.

Signed-off-by: Guoqing Jiang <guoqing.jiang-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 764e740b0c0f..48ea9919e3ce 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1256,7 +1256,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
  * blkcg_init_queue - initialize blkcg part of request queue
  * @q: request_queue to initialize
  *
- * Called from blk_alloc_queue(). Responsible for initializing blkcg
+ * Called from __alloc_disk_node(). Responsible for initializing blkcg
  * part of new request_queue @q.
  *
  * RETURNS:
-- 
2.31.1

