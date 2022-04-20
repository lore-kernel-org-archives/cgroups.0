From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/15] blk-cgroup: remove pointless CONFIG_BLOCK ifdefs
Date: Wed, 20 Apr 2022 06:27:18 +0200
Message-ID: <20220420042723.1010598-11-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lCOBvABRVXqvoK7YjkTVz0nyOLl8eIMjcntmO1hcFBU=; b=GZMUjFSY7N17YDxVy5vCXFC8DI
        iO7ufwCQBhEzzmAA16IH5fKaUdj7MzC9pssyigjBN6zc4QeGjVp2cC0+oKW0ngBKJUmwwfrnOJLez
        kVwFW6riBd2KDqqmrn5na8NftMQ8V/aDFJoDGmQ8oaQImJcCqC9IpvsmBzVRcif6mj9jDEyJR6Dnr
        8ZETYU53611Z2h3wRXH7LsIwvn+BakoMFNb6O20luyRapaDtDEe4qaVIGZkY1Fm9rnk9gwEQU4mTv
        3wrFnLN1cVNUrZWxDHVu3EjRcUgZVbJJcIk15tAQwR7nv+O2jxOZzcO0PDV91hcb+vRgppcqEKbM2
        qqVUXUsA==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

No need to make BLK_CGROUP stubs conditional on CONFIG_BLOCK as they
can't be used without that.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.h         | 3 ---
 include/linux/blk-cgroup.h | 4 ----
 2 files changed, 7 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 03405ddf2a7ba..a948f4eb0bff8 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -525,8 +525,6 @@ struct blkcg_policy {
 struct blkcg {
 };
 
-#ifdef CONFIG_BLOCK
-
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline struct blkcg_gq *blk_queue_root_blkg(struct request_queue *q)
 { return NULL; }
@@ -554,7 +552,6 @@ static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { r
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
 
-#endif	/* CONFIG_BLOCK */
 #endif	/* CONFIG_BLK_CGROUP */
 
 #endif /* _BLK_CGROUP_PRIVATE_H */
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 97c7968e32040..abbfa97d6d46f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -44,15 +44,11 @@ struct cgroup_subsys_state *bio_blkcg_css(struct bio *bio);
 
 static inline void blkcg_maybe_throttle_current(void) { }
 static inline bool blk_cgroup_congested(void) { return false; }
-
-#ifdef CONFIG_BLOCK
 static inline void blkcg_schedule_throttle(struct request_queue *q, bool use_memdelay) { }
 static inline struct cgroup_subsys_state *bio_blkcg_css(struct bio *bio)
 {
 	return NULL;
 }
-#endif /* CONFIG_BLOCK */
-
 #endif	/* CONFIG_BLK_CGROUP */
 
 int blkcg_set_fc_appid(char *app_id, u64 cgrp_id, size_t app_id_len);
-- 
2.30.2

