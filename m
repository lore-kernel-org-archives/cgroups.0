From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/24] cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
Date: Fri, 28 Dec 2012 12:35:36 -0800
Message-ID: <1356726946-26037-15-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=T2naXAfjMAsIMWnkFbtbh4zo0cu3n5cx9R2Q2/5QjqM=;
        b=AZ281n5qMyjAGqh/K0sNbGV8FpYdC9H59N8azQM+a3QClsGDgwkkmNb6s/FCRGnXTW
         QA/bhiV/moN/GgLu+KPa+pMVcjKxACBhDp4rMjvJDKWOUGIhtl6FL0Mtryg5H1U/2vMk
         63Is3cYrDWQqL7gcJuhem3xi9LVYFk8fWpyKXgWBC9QN3rbeevqXe7fiKsUzhq/SEhYe
         RKpy1aFirulcKlPu0ulfMGWcmRqI0VIIOSez0bfCer7Skh9UbkR8IBCxWjWovAia/PBv
         Ls7nDGRYg8S4Aki+AhGTZbkmin/VSKM03tmWjyDiY6ImHlNVBP3vxCKzPgHMGrb/zmoe
         p4ow==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

cfq_group_slice() calculates slice by taking a fraction of
cfq_target_latency according to the ratio of cfqg->weight against
service_tree->total_weight.  This currently works only because all
cfqgs are treated to be at the same level.

To prepare for proper hierarchy support, convert cfq_group_slice() to
base the calculation on cfqg->vfraction.  As cfqg->vfraction is always
a fraction of 1 and represents the fraction allocated to the cfqg with
hierarchy considered, the slice can be simply calculated by
multiplying cfqg->vfraction to cfq_target_latency (with fixed point
shift factored in).

As vfraction calculation currently treats all non-root cfqgs as
children of the root cfqg, this patch doesn't introduce noticeable
behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b24acf6..ee34282 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -85,7 +85,6 @@ struct cfq_rb_root {
 	struct rb_root rb;
 	struct rb_node *left;
 	unsigned count;
-	unsigned total_weight;
 	u64 min_vdisktime;
 	struct cfq_ttime ttime;
 };
@@ -979,9 +978,7 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-
-	return cfqd->cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfqd->cfq_target_latency * cfqg->vfraction >> CFQ_SERVICE_SHIFT;
 }
 
 static inline unsigned
@@ -1273,7 +1270,6 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 
 	cfq_update_group_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
-	st->total_weight += cfqg->weight;
 
 	/*
 	 * Activate @cfqg and calculate the portion of vfraction @cfqg is
@@ -1360,7 +1356,6 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	}
 
 	/* remove from the service tree */
-	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 }
-- 
1.8.0.2
