From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH] blk-throttle: avoid multiple counting for same bio
Date: Tue, 13 Feb 2018 14:45:50 +0800
Message-ID: <1518504350-139546-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;     s=04042017;
 t=1518504394;  bh=KQ7d14eJI8OAk5hG9cMFK0HZop2gkwx0c5XXraVKsck=;
        h=From:To:Subject:Date:Message-id;
        b=JrIBGKzamXwm/yjHE9GoCv3gBg/a/2YyLxEGLQbKS/PqoljifUf+Hxu30fvmVA2nl
 F3vBXobHxO8uNRUe3eqt2uKvZke8aBjEUnQUlZFh1QKvZnYKlPT/DErx/s6dIrbHWn
 j0GOO/x+hooOkMgHlgzLscQ1BrreKjr0HIGy9Q4Sq9IuFUbnPU4pfK2iq7XPb+lExy
 uWwGy+9+470RH8sXhKxIC70iJwS23SHMjckqfpQ39DiPye/qUT9hV7h18xSp+7SdXV
 z8VVDyE4uQMNcmsJIlIplKidgiN3h+kRpmZ65RjSPemTrVhIVIPJ53eXYdwuEFYbXF
 to0pOtZiTbsIA==
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@fb.com
Cc: shli@fb.com, vgoyal@redhat.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

In current throttling/upper limit policy of blkio cgroup
blkio.throttle.io_service_bytes does not exactly represent
the number of bytes issued to the disk by the group, sometimes
this number could be counted multiple times of real bytes.
This fix introduces BIO_COUNTED flag to avoid multiple counting
for same bio.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 include/linux/blk-cgroup.h | 4 ++++
 include/linux/blk_types.h  | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 69bea82..6c77711 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -686,6 +686,9 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	struct blkcg_gq *blkg;
 	bool throtl = false;
 
+	if (bio_flagged(bio, BIO_COUNTED))
+		return !throtl;
+
 	rcu_read_lock();
 	blkcg = bio_blkcg(bio);
 
@@ -708,6 +711,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
 				bio->bi_iter.bi_size);
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
+		bio_set_flag(bio, BIO_COUNTED);
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index bf18b95..23b83e7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,6 +181,7 @@ struct bio {
 				 * throttling rules. Don't do it again. */
 #define BIO_TRACE_COMPLETION 10	/* bio_endio() should trace the final completion
 				 * of this bio. */
+#define BIO_COUNTED	11	/* This bio has already been counted. */
 /* See BVEC_POOL_OFFSET below before adding new flags */
 
 /*
-- 
1.8.3.1

