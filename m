From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/24] blkcg: add blkg_policy_data->plid
Date: Fri, 28 Dec 2012 12:35:38 -0800
Message-ID: <1356726946-26037-17-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=p51HOcjxORYwtfTlIGi2YqRjVsWvDq1qpx2Fp0Avnwc=;
        b=h3NFMJZ7cffTZ2enAekG8MIMcekIZ4a2fWZYWlziYxFZjYRw9lmZC/ERQbisSGnBSQ
         O6MFQ8EfSYXJ0hB5aznWMuKKZq31ICQ3P64l7zf3LAVmfwBYY6mqSVI7xK8tzomkEwSz
         qI+NT0kIEqZvIdiipD1QiFAweMRAA6yc+BPc07eNsKS9uI0n7zQlojpkbvMLr8CAqwBH
         marpCGRVq0hQ0TbD0y9+UyT5DCgv5DsAc3XnMHDzqqBpsYx84Tb0zYy7mi4Fa6r+HfYG
         0LbRTltTwlAG+yjNa4SGOyu+cp6qOo6Mik4gzP4dpno+gZAolitVWd7gBbUzrpnLfvLI
         FlAA==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

Add pd->plid so that the policy a pd belongs to can be identified
easily.  This will be used to implement hierarchical blkg_[rw]stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 2 ++
 block/blk-cgroup.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 10e1df9..3a8de32 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -113,6 +113,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
+		pd->plid = i;
 
 		/* invoke per-policy init */
 		if (pol->pd_init_fn)
@@ -908,6 +909,7 @@ int blkcg_activate_policy(struct request_queue *q,
 
 		blkg->pd[pol->plid] = pd;
 		pd->blkg = blkg;
+		pd->plid = pol->plid;
 		pol->pd_init_fn(blkg);
 
 		spin_unlock(&blkg->blkcg->lock);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2446225..40f5b97 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -81,8 +81,9 @@ struct blkg_rwstat {
  * beginning and pd_size can't be smaller than pd.
  */
 struct blkg_policy_data {
-	/* the blkg this per-policy data belongs to */
+	/* the blkg and policy id this per-policy data belongs to */
 	struct blkcg_gq			*blkg;
+	int				plid;
 
 	/* used during policy activation */
 	struct list_head		alloc_node;
-- 
1.8.0.2
