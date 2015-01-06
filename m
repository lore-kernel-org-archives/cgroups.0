From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] blkcg: add blkcg_root_css
Date: Tue,  6 Jan 2015 14:29:04 -0500
Message-ID: <1420572557-11572-4-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qQUcWq1dlWItmN+FFq0OLwGDdoK1x/lCowU1Ca2UyPE=;
        b=03XY1meitNllAzUjrM2xMoYenH9aQCdLvDenkWZaMoo4WfVEkX/sisLa6fYZgwY4eh
         uSlOwwLLYuG3BoRMNbCqKL+VJz7IcvjNHw1js4Ryz0C/MxT3rPlfyvjX6W9Iomgn0lQY
         kwPLZuLAkf4GBkola0Glr/fAPJLb1DOyqVl4BTgNWdaDrE8RYaxv7ORHo5ipymNUtzSS
         S3eEbI9UFAGef653cpBxRtbcxTT5OUlDT5NXqllqd/cHuRYo/WSeGxrSX+5gVzfg9mFl
         R+cl01WYC+VV7St3ibXBDpn7TJAMd1V+LUSaFLEjKAzKYWGSJDWHCodonCyWt93O+zvC
         NsVw==
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, Tejun Heo <tj@kernel.org>

cgroup writeback support would need to tell whether a given blkcg
cgroup_subsys_state is the root one or not.  Add global constant
blkcg_root_css which points to &blkcg_root.css.  If blkcg is disabled,
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
