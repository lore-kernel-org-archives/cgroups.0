From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/51] update !CONFIG_BLK_CGROUP dummies in include/linux/blk-cgroup.h
Date: Fri, 22 May 2015 17:13:18 -0400
Message-ID: <1432329245-5844-5-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q5TKnlxbui53Zuad7TvThS+6kGyCP3rE6u3412sAxDQ=;
        b=kgXtNrAF3Y544M6uD/2zNsKQ94mQJBBj2gxVIwVd9J3aoL92d3VZg6jYwqQD59Y/Tu
         0XVWxmhvk0DqEdrWAITwQmNpMKw5CllZcEQzghxcBxLTzlVK18WLdF9VAKXdUtYxG8BZ
         JkdNiHDI5f96dOkG4GQSIo+gUICqp5wDTLTEV3XBlV6wICRgs2oG6ftVEi156qN/qGN0
         Gt+aKbfue5xg/YKM1zLi3PeKsmOFJqyPfgMWqWXS8jUBQK9a8RW5IT3GYxzTQACTYE3p
         cWCgbFmcdI+g/rOmjo616RgvioFiYcf84+0siYMuCAC/I7CcLVgh+s87Fo6GrluKio3I
         zJbA==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

The header file will be used more widely with the pending cgroup
writeback support and the current set of dummy declarations aren't
enough to handle different config combinations.  Update as follows.

* Drop the struct cgroup declaration.  None of the dummy defs need it.

* Define blkcg as an empty struct instead of just declaring it.

* Wrap dummy function defs in CONFIG_BLOCK.  Some functions use block
  data types and none of them are to be used w/o block enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/blk-cgroup.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c567865..51f95b3 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -558,8 +558,8 @@ static inline void blkg_rwstat_merge(struct blkg_rwstat *to,
 
 #else	/* CONFIG_BLK_CGROUP */
 
-struct cgroup;
-struct blkcg;
+struct blkcg {
+};
 
 struct blkg_policy_data {
 };
@@ -570,6 +570,8 @@ struct blkcg_gq {
 struct blkcg_policy {
 };
 
+#ifdef CONFIG_BLOCK
+
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
@@ -599,5 +601,6 @@ static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
 
+#endif	/* CONFIG_BLOCK */
 #endif	/* CONFIG_BLK_CGROUP */
 #endif	/* _BLK_CGROUP_H */
-- 
2.4.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
