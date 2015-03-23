From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/48] blkcg: add blkcg_root_css
Date: Mon, 23 Mar 2015 00:54:16 -0400
Message-ID: <1427086499-15657-6-git-send-email-tj@kernel.org>
References: <1427086499-15657-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fvPjD34E7jghVigFdnrTMfk5/PNAO7J+HaC3AZnJ63g=;
        b=rcDxYxm+BjdWCziTULltEjD/MPqYkDW1CM8S81PKx/E5R51I3GZgc5PqgP/ozshtnz
         4BQbP1ck8zAAnjAQ5vdPKwh3a6WiXDsWzGlRSNLxaYzZq2bk+Tv+q3JXQOmqwrbR5/ZQ
         S/FV4mpx/gudT9Eq7xEZi9WU26bDYC6Rbuy7LszcBRFSIXVSfJx33/HwjYh9dhtxgCO1
         U2xUWO6hDzOe5k8XoVbyGIeLl5dl+HMfKQobNJZcOLpdgKHH5Y4M7wW8JvmM58MJXLxZ
         k4yzcsZ+x0gH14ObGUaQnj01GAG0m4WpgGJvSkhOOpvVGLk+mPKSLh5zG6snXlsobzIn
         RdMQ==
In-Reply-To: <1427086499-15657-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Add global constant blkcg_root_css which points to &blkcg_root.css.
This will be used by cgroup writeback support.  If blkcg is disabled,
it's defined as ERR_PTR(-EINVAL).

v2: The declarations moved to include/linux/blk-cgroup.h as suggested
    by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c         | 2 ++
 include/linux/blk-cgroup.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c3226ce..9e0fe38 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -30,6 +30,8 @@ struct blkcg blkcg_root = { .cfq_weight = 2 * CFQ_WEIGHT_DEFAULT,
 			    .cfq_leaf_weight = 2 * CFQ_WEIGHT_DEFAULT, };
 EXPORT_SYMBOL_GPL(blkcg_root);
 
+struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
+
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
 static bool blkcg_policy_enabled(struct request_queue *q,
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 51f95b3..65f0c17 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -134,6 +134,7 @@ struct blkcg_policy {
 };
 
 extern struct blkcg blkcg_root;
+extern struct cgroup_subsys_state * const blkcg_root_css;
 
 struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, struct request_queue *q);
 struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
@@ -570,6 +571,8 @@ struct blkcg_gq {
 struct blkcg_policy {
 };
 
+#define blkcg_root_css	((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
+
 #ifdef CONFIG_BLOCK
 
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
