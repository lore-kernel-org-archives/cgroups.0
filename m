From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/51] blkcg: add blkcg_root_css
Date: Fri, 22 May 2015 17:13:21 -0400
Message-ID: <1432329245-5844-8-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8+sWa17nBYKN7wS0Ag7Hr2KTyD8s+eiFFzTkEHlKJv4=;
        b=LH/r9JfjGXzVxH3dItEA/VejTgqfVywH94mmSaUYURSJH9ZrdDah++7LWzpJ31Pr4m
         npENTBvn1nxNjioyAL9EUSNl+72dR1n3wFVw4P6I3lx85+B5yO5kEYnDS9mo8NJl1Bra
         zoPlCyyuavIHcvVS5GNlMejseiSTV8G1XzEXu3bFT1hk6SpsY3zuDpZA+h5ot3k9aWM/
         xkjkPd5rCkqHyD3YqhY05GFQdwRxnIUXYC2qPLffxRJFhh6NpJW1vbZJXv4Wy0CHs7uX
         KJC6hUwRH5dixiP5p4Vy9v2RyUTuKalXUvt2lLRYI5cxMcotAfPl0WM20Z0+x4fsBJAe
         yYJQ==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

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
index 2a4f77f..54ec172 100644
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
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
