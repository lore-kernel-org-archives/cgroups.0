From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] blkcg: misc preparations for unified hierarchy interface
Date: Fri, 24 Jul 2015 14:43:53 -0400
Message-ID: <1437763434-28699-10-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vWFvWuIJAOqVRKOTl0wvlb90k6CnL+8HYx+2md8SQ+E=;
        b=XNPgOHq2EDVZO3eWQnIG8B9UCtxIAnojc7o6WN3sEy9Os0Y/pbNbwERoA+0dsI654R
         4mtvw1QfburGPcn+uqcLkbuIIxvomWo4pkOAeJRH/iwpQ5YmFokByNbhwGjYVWMzJ0uS
         /aIjKtzMVytngbE5WS439G5LMNtgYljlIHw2hNILfmuSfIT0fryhMFyXnXOSQNuIhIcZ
         s624uLNZHpLZGkhKusOTnqwhrZGYX2VnrnbJ0EznyJx00gEo1hjZxjygwRHtrA589qYp
         myqelV725EX3vxtQSLctR/3El3SD/3QYy33sYQqHq1iWzNrtlCqF/x6wKwriMebv9fa1
         4v6g==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

* Export blkg_dev_name()

* Drop unnecessary @cft from __cfq_set_weight().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c         | 3 ++-
 block/cfq-iosched.c        | 8 ++++----
 include/linux/blk-cgroup.h | 1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2ea3a2a..b9d511b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -462,13 +462,14 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static const char *blkg_dev_name(struct blkcg_gq *blkg)
+const char *blkg_dev_name(struct blkcg_gq *blkg)
 {
 	/* some drivers (floppy) instantiate a queue w/o disk registered */
 	if (blkg->q->backing_dev_info.dev)
 		return dev_name(blkg->q->backing_dev_info.dev);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(blkg_dev_name);
 
 /**
  * blkcg_print_blkgs - helper for printing per-blkg data
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ea88d89..7a72301 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1788,8 +1788,8 @@ static ssize_t cfqg_set_leaf_weight_device(struct kernfs_open_file *of,
 	return __cfqg_set_weight_device(of, buf, nbytes, off, true);
 }
 
-static int __cfq_set_weight(struct cgroup_subsys_state *css, struct cftype *cft,
-			    u64 val, bool is_leaf_weight)
+static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
+			    bool is_leaf_weight)
 {
 	struct blkcg *blkcg = css_to_blkcg(css);
 	struct blkcg_gq *blkg;
@@ -1834,13 +1834,13 @@ static int __cfq_set_weight(struct cgroup_subsys_state *css, struct cftype *cft,
 static int cfq_set_weight(struct cgroup_subsys_state *css, struct cftype *cft,
 			  u64 val)
 {
-	return __cfq_set_weight(css, cft, val, false);
+	return __cfq_set_weight(css, val, false);
 }
 
 static int cfq_set_leaf_weight(struct cgroup_subsys_state *css,
 			       struct cftype *cft, u64 val)
 {
-	return __cfq_set_weight(css, cft, val, true);
+	return __cfq_set_weight(css, val, true);
 }
 
 static int cfqg_print_stat(struct seq_file *sf, void *v)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 85a4d98..b270aef 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -182,6 +182,7 @@ int blkcg_activate_policy(struct request_queue *q,
 void blkcg_deactivate_policy(struct request_queue *q,
 			     const struct blkcg_policy *pol);
 
+const char *blkg_dev_name(struct blkcg_gq *blkg);
 void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 		       u64 (*prfill)(struct seq_file *,
 				     struct blkg_policy_data *, int),
-- 
2.4.3
