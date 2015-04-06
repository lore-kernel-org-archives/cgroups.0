From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/49] blkcg: implement task_get_blkcg_css()
Date: Mon,  6 Apr 2015 15:57:57 -0400
Message-ID: <1428350318-8215-9-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6QhiKnG6awNOOoUyM/l2PLv1fwkjCAIuOPIXvUwqjBQ=;
        b=anJh4+ry/+nUW0QA2lD1hKjU6gqtb4QluOrzru3fTdgC72e89KeWzGBvnFBH91Bb70
         /hmH6kb0mPR/eR3yWY7AuhcsD10X8fki4xhg30RE3kqPnj+Xu7KAb2YdxIJMFWrQk/db
         l5SyWmmN8r5Jc0Zbgz+h4K/AE2XcF+Vf9WPHCeiSuTcnpBsGXMI7tgqWb6TsVJtB7Brc
         AiA20HkVaGL7pz9OGAqU5HYp4mFAmOm0SlCnXdM79pyEgBNwUn//93/BGnHL6gU2zp/C
         zZa0dXvJbBnGgWlt+2G4nIB2O//qh7tIn3F/WtPCuViTeps8Y1zealz4wCRrtvu6ik5U
         abeQ==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

Implement a wrapper around task_get_css() to acquire the blkcg css for
a given task.  The wrapper is necessary for cgroup writeback support
as there will be places outside blkcg proper trying to acquire
blkcg_css and blkio_cgrp_id will be undefined when !CONFIG_BLK_CGROUP.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/blk-cgroup.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 65f0c17..4dc643f 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -195,6 +195,12 @@ static inline struct blkcg *bio_blkcg(struct bio *bio)
 	return task_blkcg(current);
 }
 
+static inline struct cgroup_subsys_state *
+task_get_blkcg_css(struct task_struct *task)
+{
+	return task_get_css(task, blkio_cgrp_id);
+}
+
 /**
  * blkcg_parent - get the parent of a blkcg
  * @blkcg: blkcg of interest
@@ -573,6 +579,12 @@ struct blkcg_policy {
 
 #define blkcg_root_css	((struct cgroup_subsys_state *)ERR_PTR(-EINVAL))
 
+static inline struct cgroup_subsys_state *
+task_get_blkcg_css(struct task_struct *task)
+{
+	return NULL;
+}
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
