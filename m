From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/15] blk-cgroup: move blkcg_css to blk-cgroup.c
Date: Wed, 20 Apr 2022 06:27:20 +0200
Message-ID: <20220420042723.1010598-13-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EB24Pl6Dnuz4BZ6riMjfOVkZhFkJeCm3U5wG0haI3CE=; b=jPduuzobKlAP+uSSo+Orh9sslf
        gLWxMlEGJLet2t+xSNTBmZlUIaHZMBkInqspZD4XTswr0i8Oq74biZ6WisQJAMgRFIm8loWVZSIir
        0skh3C9AUWNqpAN28r5fJQ6gs2URKw+KVlXZGN61Rnja9IUxv7mvtwCwcwJm/Sk79GQWvT7Lwca17
        7Fyre5mcE0nBSwV70cZejcTxkjpRAIuZFJO+Nnn0OUvMOSoLoQlwNO0XT3rQmbaIWq9Tk2czVum1q
        xXqvK6Ca4IN2RMHS9nbDQJONquzAi7gaJzXzbvtJIMXwGBZGO5yA9Qo4S+u9Nlna6P3Vm3wfISRfk
        IL3CUhIQ==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

blkcg_css is only used in blk-cgroup.c, so move it there.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.c | 17 +++++++++++++++++
 block/blk-cgroup.h | 17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8e32cc494808d..8da00ddc1766e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -59,6 +59,23 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
+/**
+ * blkcg_css - find the current css
+ *
+ * Find the css associated with either the kthread or the current task.
+ * This may return a dying css, so it is up to the caller to use tryget logic
+ * to confirm it is alive and well.
+ */
+static struct cgroup_subsys_state *blkcg_css(void)
+{
+	struct cgroup_subsys_state *css;
+
+	css = kthread_blkcg();
+	if (css)
+		return css;
+	return task_css(current, io_cgrp_id);
+}
+
 static bool blkcg_policy_enabled(struct request_queue *q,
 				 const struct blkcg_policy *pol)
 {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 62ed8ed50b6e3..bb670e53a1de2 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -210,23 +210,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
 
-/**
- * blkcg_css - find the current css
- *
- * Find the css associated with either the kthread or the current task.
- * This may return a dying css, so it is up to the caller to use tryget logic
- * to confirm it is alive and well.
- */
-static inline struct cgroup_subsys_state *blkcg_css(void)
-{
-	struct cgroup_subsys_state *css;
-
-	css = kthread_blkcg();
-	if (css)
-		return css;
-	return task_css(current, io_cgrp_id);
-}
-
 /**
  * bio_issue_as_root_blkg - see if this bio needs to be issued as root blkg
  * @return: true if this bio needs to be submitted with the root blkg context.
-- 
2.30.2

