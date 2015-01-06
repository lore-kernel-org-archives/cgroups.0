From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/16] blkcg: implement task_get_blkcg_css()
Date: Tue,  6 Jan 2015 14:29:06 -0500
Message-ID: <1420572557-11572-6-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PQAbI56x8q3o1oUCsyS/mHjy/Qt+rWQsazkrL8tgTwk=;
        b=UVxpizV5ROGY92KQUUvvwMJg3RHQcK1YiPQnJruMaU4Rl23OuJ0b4u5+arcpGhEV4V
         ZhU1P2kjpa10erOqCeDc9c3AMQ46g40b4B5J1VLyOktK45GwxViCnxzWE4SJ+nclPUoa
         ++Rq3anOMX53Nwk7E1VbEMYcRpkpY1PuA0tFybFmdncJAbmdLBAwBHhB/y+v+ULVoniG
         plJI0bXW6uYQAybuREbNCoqKm68axU2QQk3jH4CcpqgfOjDfPDiGVai2e6aven7HKCzo
         hIIWoHVOiuv5fJ4h0dmYpSgvubPIW+KVJEY/EKvN1E4BIGhtFBvWW9WeplW3+Ysc4TDr
         Hx7w==
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, Tejun Heo <tj@kernel.org>

Implement a wrapper around task_get_css() to acquire the blkcg css for
a given task.  The wrapper is necessary for !CONFIG_BLK_CGROUP as
blkio_cgrp_id would be undefined.

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
