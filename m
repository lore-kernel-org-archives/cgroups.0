From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/24] cfq-iosched: separate out cfqg_stats_reset() from cfq_pd_reset_stats()
Date: Fri, 28 Dec 2012 12:35:44 -0800
Message-ID: <1356726946-26037-23-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=EMYk29uQNPtzIS83iQ17sHhn4NfTmeA8B7v7YwLp/Us=;
        b=OK5h0JGKOdnwKX3WkPdWRJvp6+zgEp+QpurmesHTvXMO8l4QL8ehCBGe3e/FO9M/JD
         AsQbqiYohl8LpuuTNNbTCTX2tIWubTSxk7N1+p6jk22TMldToUroQWBTOaRxsDvJPFTJ
         TEkl/0NJY+Otlz+WPycG3wNEZH3GZQXtmOLvUXv9i5ETPd15c4vL/JNdtIuG2q6DvflS
         CJJvTAFCrAWQuD51cIxJYhc0/ztqc1q/fwg8fZu4Q6V9Y2Tdyoan3oLpP4/sy3p5CWfO
         6GBVVz69MNFWMOXVemnYCkP5LKtZ3PxdIAlYXKmaF2HAkaoUJQWEfzM/Raj0IwRoRmq7
         GSEg==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

Separate out cfqg_stats_reset() which takes struct cfqg_stats * from
cfq_pd_reset_stats() and move the latter to where other pd methods are
defined.  cfqg_stats_reset() will be used to implement hierarchical
stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d43145cc..f8b34bb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -688,11 +688,9 @@ static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 				io_start_time - start_time);
 }
 
-static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
+/* @stats = 0 */
+static void cfqg_stats_reset(struct cfqg_stats *stats)
 {
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
-	struct cfqg_stats *stats = &cfqg->stats;
-
 	/* queued stats shouldn't be cleared */
 	blkg_rwstat_reset(&stats->service_bytes);
 	blkg_rwstat_reset(&stats->serviced);
@@ -1477,6 +1475,13 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
 }
 
+static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
+{
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+
+	cfqg_stats_reset(&cfqg->stats);
+}
+
 /*
  * Search for the cfq group current task belongs to. request_queue lock must
  * be held.
-- 
1.8.0.2
