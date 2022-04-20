From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/15] blk-cgroup: remove __bio_blkcg
Date: Wed, 20 Apr 2022 06:27:09 +0200
Message-ID: <20220420042723.1010598-2-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pUx9E4bSsgTtsaDMfSE5EDajyzAF5/fHK6uAh8Ed1Gg=; b=uNkgsxELSTCE2JMXfgQQtkD9MY
        B+72ptZYalj2Ob23DD2ORCU3vyCOzMbIg92e+4bEh0R4/5UFv9FTP2dMABwokzQtJIESrN/DyxAhF
        HB2rocYfwAd0fy79eQUjfVuIkodyaZdYUp+frZc1JYy+8QNxfDFTcEKX9Sc2Lp6lkTMgNGhyDsRCJ
        vGDckqqRt/ngcyFA+VKNCrK3q1PpnwLRaYy/ef9aFWeGbz4HzlU0eXswHCY91slT9vL6VZd9KCUkA
        dPwxVISwd4J/MhAXRLs9RVzSrQSQ6t4Jl7J4gWjJO8XLU+ATVcMZkxRCbh8HqRS+d7Z3wqFwTV9q/
        PZSxg22w==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Remove the unused and deprecated __bio_blkcg helper.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.h | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 47e1e38390c96..49e88fc9cc391 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -139,27 +139,6 @@ static inline struct cgroup_subsys_state *blkcg_css(void)
 	return task_css(current, io_cgrp_id);
 }
 
-/**
- * __bio_blkcg - internal, inconsistent version to get blkcg
- *
- * DO NOT USE.
- * This function is inconsistent and consequently is dangerous to use.  The
- * first part of the function returns a blkcg where a reference is owned by the
- * bio.  This means it does not need to be rcu protected as it cannot go away
- * with the bio owning a reference to it.  However, the latter potentially gets
- * it from task_css().  This can race against task migration and the cgroup
- * dying.  It is also semantically different as it must be called rcu protected
- * and is susceptible to failure when trying to get a reference to it.
- * Therefore, it is not ok to assume that *_get() will always succeed on the
- * blkcg returned here.
- */
-static inline struct blkcg *__bio_blkcg(struct bio *bio)
-{
-	if (bio && bio->bi_blkg)
-		return bio->bi_blkg->blkcg;
-	return css_to_blkcg(blkcg_css());
-}
-
 /**
  * bio_issue_as_root_blkg - see if this bio needs to be issued as root blkg
  * @return: true if this bio needs to be submitted with the root blkg context.
@@ -471,8 +450,6 @@ static inline int blkcg_activate_policy(struct request_queue *q,
 static inline void blkcg_deactivate_policy(struct request_queue *q,
 					   const struct blkcg_policy *pol) { }
 
-static inline struct blkcg *__bio_blkcg(struct bio *bio) { return NULL; }
-
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
 						  struct blkcg_policy *pol) { return NULL; }
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
-- 
2.30.2

